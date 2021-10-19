// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/dif/dif_rv_timer.h"
#include "sw/device/lib/irq.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/check.h"
#include "sw/device/lib/testing/test_framework/FreeRTOSConfig.h"
#include "sw/vendor/freertos_freertos_kernel/include/FreeRTOS.h"
#include "sw/vendor/freertos_freertos_kernel/include/task.h"
#include "sw/vendor/freertos_freertos_kernel/portable/GCC/RISC-V/portmacro.h"

// TODO: make this toplevel agnostic.
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"  // Generated.

// NOTE: some of the function names below do NOT, and cannot, conform to the
// style guide, since they are specific implementations of FreeRTOS defined
// functions.

// ----------------------------------------------------------------------------
// Timer Setup (for use when preemptive scheduling is enabled)
// ----------------------------------------------------------------------------
#if configUSE_PREEMPTION

static dif_rv_timer_t timer;
static const uint32_t kTimerHartId = (uint32_t)kTopEarlgreyPlicTargetIbex0;
static const uint32_t kTimerComparatorId = 0;
static const uint64_t kTimerDeadline =
    100;  // Counter must reach 100 for an IRQ to be triggered.

// Override the timer ISR to support preemptive context switching.
void ottf_timer_isr(void) {
  LOG_INFO("Handling timer IQR ...");
  dif_rv_timer_irq_enable_snapshot_t irq_enable_snapshot;
  CHECK_DIF_OK(
      dif_rv_timer_irq_disable_all(&timer, kTimerHartId, &irq_enable_snapshot));
  CHECK_DIF_OK(dif_rv_timer_counter_write(&timer, kTimerHartId, 0));
  CHECK_DIF_OK(dif_rv_timer_irq_acknowledge(
      &timer, kDifRvTimerIrqTimerExpiredHart0Timer0));
  // TODO: increment scheduler tick and switch context if necessary
  CHECK_DIF_OK(
      dif_rv_timer_irq_restore_all(&timer, kTimerHartId, &irq_enable_snapshot));
  LOG_INFO("Done.");
}

void vPortSetupTimerInterrupt(void) {
  LOG_INFO("Configuring timer interrupt ...");

  // Initialize and reset the timer.
  CHECK_DIF_OK(dif_rv_timer_init(
      mmio_region_from_addr(TOP_EARLGREY_RV_TIMER_BASE_ADDR), &timer));

  // Compute and set tick parameters (i.e., step, prescale, etc.).
  dif_rv_timer_tick_params_t tick_params;
  CHECK_DIF_OK(dif_rv_timer_approximate_tick_params(
      kClockFreqPeripheralHz, configTICK_RATE_HZ * kTimerDeadline,
      &tick_params));
  LOG_INFO("Tick Freq. (Hz): %u, Prescale: %u; Tick Step: %u",
           (uint32_t)kClockFreqPeripheralHz, (uint32_t)tick_params.prescale,
           (uint32_t)tick_params.tick_step);
  CHECK_DIF_OK(dif_rv_timer_set_tick_params(&timer, kTimerHartId, tick_params));

  // Enable RV Timer interrupts and arm/enable the timer.
  CHECK_DIF_OK(dif_rv_timer_irq_set_enabled(
      &timer, kDifRvTimerIrqTimerExpiredHart0Timer0, kDifToggleEnabled));
  CHECK_DIF_OK(dif_rv_timer_arm(&timer, kTimerHartId, kTimerComparatorId,
                                kTimerDeadline));

  CHECK_DIF_OK(dif_rv_timer_counter_set_enabled(&timer, kTimerHartId,
                                                kDifToggleEnabled));
}

#endif  // configUSE_PREEMPTION

// ----------------------------------------------------------------------------
// Scheduler Setup
// ----------------------------------------------------------------------------
extern void xPortStartFirstTask(void);

BaseType_t xPortStartScheduler(void) {
#if configUSE_PREEMPTION
  vPortSetupTimerInterrupt();
#endif  // configUSE_PREEMPTION
  irq_timer_ctrl(true);
  irq_external_ctrl(true);
  irq_software_ctrl(true);
  xPortStartFirstTask();

  // Unreachable.
  return pdFAIL;
}

void vPortEndScheduler(void) {
  // Not implemented.
  // TODO: trigger this to be called when from the idle task hook when all tests
  // have completed.
  while (true) {
    wait_for_interrupt();
  }
}
