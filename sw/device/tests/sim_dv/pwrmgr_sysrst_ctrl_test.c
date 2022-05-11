// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <limits.h>
#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/math.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_aon_timer.h"
#include "sw/device/lib/dif/dif_pinmux.h"
#include "sw/device/lib/dif/dif_pwrmgr.h"
#include "sw/device/lib/dif/dif_rstmgr.h"
#include "sw/device/lib/dif/dif_sysrst_ctrl.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/aon_timer_testutils.h"
#include "sw/device/lib/testing/pwrmgr_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

const test_config_t kTestConfig;

/**
 * Configure the sysrst.
 */
static void config_sysrst(const dif_pwrmgr_t *pwrmgr,
                          const dif_sysrst_ctrl_t *sysrst_ctrl_aon) {
  LOG_INFO("sysrst enabled");

  // Set sysrst as a reset source.
  CHECK_DIF_OK(dif_pwrmgr_set_request_sources(pwrmgr, kDifPwrmgrReqTypeReset,
                                              kDifPwrmgrResetRequestSourceOne,
                                              kDifToggleEnabled));
  LOG_INFO("Reset Request SourceOne is set");

  // Configure sysrst key combo
  // reset pulse : 50 us
  // detect durration : 50 us

  dif_sysrst_ctrl_key_combo_config_t sysrst_ctrl_key_combo_config = {
      .keys = kDifSysrstCtrlKeyAll,
      .detection_time_threshold = 10,
      .actions = kDifSysrstCtrlKeyComboActionAll,
      .embedded_controller_reset_duration = 10};

  CHECK_DIF_OK(dif_sysrst_ctrl_key_combo_detect_configure(
      sysrst_ctrl_aon, kDifSysrstCtrlKeyCombo0, sysrst_ctrl_key_combo_config));
  // Configure sysrst input change
  // debounce durration : 100 us
  dif_sysrst_ctrl_input_change_config_t sysrst_ctrl_input_change_config = {
      .input_changes = kDifSysrstCtrlInputAll, .debounce_time_threshold = 20};

  // Configure pinmux
  dif_pinmux_t pinmux;
  CHECK_DIF_OK(dif_pinmux_init(
      mmio_region_from_addr(TOP_EARLGREY_PINMUX_AON_BASE_ADDR), &pinmux));

  CHECK_DIF_OK(dif_sysrst_ctrl_input_change_detect_configure(
      sysrst_ctrl_aon, sysrst_ctrl_input_change_config));

  CHECK_DIF_OK(dif_pinmux_input_select(
      &pinmux, kTopEarlgreyPinmuxPeripheralInSysrstCtrlAonKey0In,
      kTopEarlgreyPinmuxInselIor13));

  // Wait for sysrst.
  busy_spin_micros(10 * 1000);
  // If we arrive here the test must fail.
  CHECK(false, "Timeout waiting for sysrst reset!");
}

/**
 * Configure the wdog.
 */
static void config_wdog(const dif_aon_timer_t *aon_timer,
                        const dif_pwrmgr_t *pwrmgr, uint64_t bark_time_us,
                        uint64_t bite_time_us) {
  uint32_t bark_cycles =
      aon_timer_testutils_get_aon_cycles_from_us(bark_time_us);
  uint32_t bite_cycles =
      aon_timer_testutils_get_aon_cycles_from_us(bite_time_us);

  LOG_INFO("Wdog will bark after %u us and bite after %u us",
           (uint32_t)bark_time_us, (uint32_t)bite_time_us);

  // Set wdog as a reset source.
  CHECK_DIF_OK(dif_pwrmgr_set_request_sources(pwrmgr, kDifPwrmgrReqTypeReset,
                                              kDifPwrmgrResetRequestSourceTwo,
                                              kDifToggleEnabled));

  // Setup the wdog bark and bite timeouts.
  aon_timer_testutils_watchdog_config(aon_timer, bark_cycles, bite_cycles,
                                      false);
}

/**
 * Execute the aon timer wdog bite reset test.
 */
static void wdog_bite_test(const dif_aon_timer_t *aon_timer,
                           const dif_pwrmgr_t *pwrmgr, uint64_t bark_time_us) {
  uint64_t bite_time_us = bark_time_us * 2;
  config_wdog(aon_timer, pwrmgr, bark_time_us, bite_time_us);

  // The `intr_state` takes 3 aon clock cycles to rise plus 2 extra cycles as a
  // precaution.
  uint32_t wait_us =
      bark_time_us +
      udiv64_slow(5 * 1000000 + kClockFreqAonHz - 1, kClockFreqAonHz, NULL);

  // Wait bark time and check that the bark interrupt requested.
  busy_spin_micros(wait_us);
  bool is_pending = false;
  CHECK_DIF_OK(dif_aon_timer_irq_is_pending(
      aon_timer, kDifAonTimerIrqWdogTimerBark, &is_pending));
  CHECK(is_pending, "Wdog bark irq did not rise after %u microseconds",
        wait_us);

  // Wait for the remaining time to the wdog bite.
  busy_spin_micros(wait_us);
  // If we arrive here the test must fail.
  CHECK(false, "Timeout waiting for Wdog bite reset!");
}

bool test_main(void) {
  // Initialize pwrmgr.
  dif_pwrmgr_t pwrmgr;
  CHECK_DIF_OK(dif_pwrmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_PWRMGR_AON_BASE_ADDR), &pwrmgr));

  // Initialize sysrst_ctrl.
  dif_sysrst_ctrl_t sysrst_ctrl_aon;
  CHECK_DIF_OK(dif_sysrst_ctrl_init(
      mmio_region_from_addr(TOP_EARLGREY_SYSRST_CTRL_AON_BASE_ADDR),
      &sysrst_ctrl_aon));

  // Initialize rstmgr to check the reset reason.
  dif_rstmgr_t rstmgr;
  CHECK_DIF_OK(dif_rstmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_RSTMGR_AON_BASE_ADDR), &rstmgr));

  // Initialize aon timer to use the wdog.
  dif_aon_timer_t aon_timer;
  CHECK_DIF_OK(dif_aon_timer_init(
      mmio_region_from_addr(TOP_EARLGREY_AON_TIMER_AON_BASE_ADDR), &aon_timer));

  // Check if there was a HW reset caused by the wdog bite.
  dif_rstmgr_reset_info_bitfield_t rst_info;
  CHECK_DIF_OK(dif_rstmgr_reset_info_get(&rstmgr, &rst_info));
  CHECK_DIF_OK(dif_rstmgr_reset_info_clear(&rstmgr));

  CHECK(rst_info == kDifRstmgrResetInfoPor ||
            rst_info == kDifRstmgrResetInfoWatchdog ||
            rst_info == kDifRstmgrResetInfoSysRstCtrl,
        "Wrong reset reason %02X", rst_info);

  if (rst_info == kDifRstmgrResetInfoPor) {
    LOG_INFO("Booting for the first time, setting sysrst");
    config_sysrst(&pwrmgr, &sysrst_ctrl_aon);
  } else if (rst_info == kDifRstmgrResetInfoSysRstCtrl) {
    LOG_INFO("Booting for the second time due to system reset control reset");
    // Executing the wdog bite reset test.
    wdog_bite_test(&aon_timer, &pwrmgr, /*bark_time_us=*/200);
  } else if (rst_info == kDifRstmgrResetInfoWatchdog) {
    LOG_INFO("Booting for the third time due to wdog bite reset");
  }
  return true;
}
