// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/testing/i2c_testutils.h"

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_i2c.h"
#include "sw/device/lib/dif/dif_pinmux.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/pinmux_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "i2c_regs.h"  // Generated.

#define MODULE_ID MAKE_MODULE_ID('i', 'i', 't')

enum {
  kI2cWrite = 0,
  kI2cRead = 1,
};

// Default flags for i2c operations.
static const dif_i2c_fmt_flags_t kDefaultFlags = {.start = false,
                                                  .stop = false,
                                                  .read = false,
                                                  .read_cont = false,
                                                  .suppress_nak_irq = false};

/**
 * Define an i2c pinmux configuration.
 */
typedef struct i2c_pinmux_pins {
  pinmux_testutils_peripheral_pin_t sda;
  pinmux_testutils_peripheral_pin_t scl;
} i2c_pinmux_pins_t;

/**
 * Define an i2c pinmux configuration.
 */
typedef struct i2c_platform_pins {
  pinmux_testutils_mio_pin_t sda;
  pinmux_testutils_mio_pin_t scl;
} i2c_platform_pins_t;

/**
 * This table store the pins of all i2c instances of Earlgrey.
 * This is used to connect i2c instances to mio pins based on the platform.
 */
static const i2c_pinmux_pins_t kI2cPinmuxPins[] = {
    // I2C0.
    {.sda =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c0Sda,
             .outsel = kTopEarlgreyPinmuxOutselI2c0Sda,
         },
     .scl =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c0Scl,
             .outsel = kTopEarlgreyPinmuxOutselI2c0Scl,
         }},
    // I2C1.
    {.sda =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c1Sda,
             .outsel = kTopEarlgreyPinmuxOutselI2c1Sda,
         },
     .scl =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c1Scl,
             .outsel = kTopEarlgreyPinmuxOutselI2c1Scl,
         }},
    // I2C2.
    {.sda =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c2Sda,
             .outsel = kTopEarlgreyPinmuxOutselI2c2Sda,
         },
     .scl =
         {
             .peripheral_in = kTopEarlgreyPinmuxPeripheralInI2c2Scl,
             .outsel = kTopEarlgreyPinmuxOutselI2c2Scl,
         }},
};

/**
 * This table store i2c pin mappings of different platforms.
 * This is used to connect i2c instances to mio pins based on the platform.
 */
static const i2c_platform_pins_t kI2cPlatformPins[] = {
    // Hyper310 bitstream.
    [I2cPinmuxPlatformIdHyper310] =
        {.sda =
             {
                 .mio_out = kTopEarlgreyPinmuxMioOutIoa7,
                 .insel = kTopEarlgreyPinmuxInselIoa7,
             },
         .scl =
             {
                 .mio_out = kTopEarlgreyPinmuxMioOutIoa8,
                 .insel = kTopEarlgreyPinmuxInselIoa8,
             }},
    // DV.
    [I2cPinmuxPlatformIdDvsim] = {.sda =
                                      {
                                          .mio_out =
                                              kTopEarlgreyPinmuxMioOutIob10,
                                          .insel = kTopEarlgreyPinmuxInselIob10,
                                      },
                                  .scl =
                                      {
                                          .mio_out =
                                              kTopEarlgreyPinmuxMioOutIob9,
                                          .insel = kTopEarlgreyPinmuxInselIob9,
                                      }},
    // Cw310 PMOD.
    [I2cPinmuxPlatformIdCw310Pmod] = {
        .sda =
            {
                .mio_out = kTopEarlgreyPinmuxMioOutIob12,
                .insel = kTopEarlgreyPinmuxInselIob12,
            },
        .scl = {
            .mio_out = kTopEarlgreyPinmuxMioOutIob11,
            .insel = kTopEarlgreyPinmuxInselIob11,
        }}};

status_t i2c_testutils_write(const dif_i2c_t *i2c, uint8_t addr,
                             size_t byte_count, const uint8_t *data,
                             bool skip_stop) {
  dif_i2c_fmt_flags_t flags = kDefaultFlags;
  uint8_t data_frame;

  TRY_CHECK(byte_count > 0);

  // First write the address.
  flags.start = true;
  data_frame = (uint8_t)(addr << 1) | (uint8_t)kI2cWrite;
  TRY(dif_i2c_write_byte_raw(i2c, data_frame, flags));

  // Once address phase is through, blast the rest as generic data.
  flags = kDefaultFlags;
  if (byte_count > 1) {
    TRY(dif_i2c_write_bytes_raw(i2c, byte_count - 1, data, flags));
  }
  // Issue a stop for the last byte.
  flags.stop = !skip_stop;
  TRY(dif_i2c_write_byte_raw(i2c, data[byte_count - 1], flags));

  // TODO: Check for errors / status.
  return OK_STATUS();
}

status_t i2c_testutils_issue_read(const dif_i2c_t *i2c, uint8_t addr,
                                  uint8_t byte_count) {
  dif_i2c_fmt_flags_t flags = kDefaultFlags;
  uint8_t data_frame;
  // The current function doesn't check for space in the FIFOs

  // First, issue a write the address transaction.
  flags.start = true;
  data_frame = (uint8_t)(addr << 1) | (uint8_t)kI2cRead;
  TRY(dif_i2c_write_byte_raw(i2c, data_frame, flags));

  bool nak = false;
  TRY(i2c_testutils_wait_transaction_finish(i2c));
  TRY(dif_i2c_irq_is_pending(i2c, kDifI2cIrqNak, &nak));
  if (!nak) {
    // We got an ack, schedule the read transaction.
    flags = kDefaultFlags;
    flags.read = true;
    flags.stop = true;
    // Inform the controller how many bytes to read overall.
    TRY(dif_i2c_write_byte_raw(i2c, byte_count, flags));
  } else {
    // We got a nak, clear the irq and return. The caller my retry later.
    TRY(dif_i2c_irq_acknowledge(i2c, kDifI2cIrqNak));
  }
  return OK_STATUS(nak);
}

status_t i2c_testutils_read(const dif_i2c_t *i2c, uint8_t addr,
                            size_t byte_count, uint8_t *data, size_t timeout) {
  uint32_t nak_count = 0;
  ibex_timeout_t timer = ibex_timeout_init(timeout);

  // Make sure to start from a clean state.
  TRY(dif_i2c_irq_acknowledge(i2c, kDifI2cIrqNak));
  TRY(dif_i2c_reset_rx_fifo(i2c));
  do {
    // Loop until we get an ACK from the device or a timeout.
    uint8_t chunk = byte_count > I2C_PARAM_FIFO_DEPTH ? I2C_PARAM_FIFO_DEPTH
                                                      : (uint8_t)byte_count;
    while (TRY(i2c_testutils_issue_read(i2c, addr, chunk))) {
      nak_count++;
      if (ibex_timeout_check(&timer)) {
        return DEADLINE_EXCEEDED();
      }
    }

    if (chunk > 0) {
      TRY(dif_i2c_read_bytes(i2c, chunk, data));
      data += chunk;
      byte_count -= chunk;
    }
  } while (byte_count > 0);

  TRY(i2c_testutils_wait_transaction_finish(i2c));
  return OK_STATUS((int32_t)nak_count);
}

status_t i2c_testutils_target_check_start(const dif_i2c_t *i2c, uint8_t *addr) {
  uint8_t acq_fifo_lvl;
  TRY(dif_i2c_get_fifo_levels(i2c, NULL, NULL, NULL, &acq_fifo_lvl));
  TRY_CHECK(acq_fifo_lvl > 1);

  dif_i2c_signal_t signal;
  uint8_t byte;
  TRY(dif_i2c_acquire_byte(i2c, &byte, &signal));
  // Check acq_fifo is as expected and write addr and continue
  TRY_CHECK(signal == kDifI2cSignalStart);
  *addr = byte >> 1;

  return OK_STATUS(byte & kI2cRead);
}

status_t i2c_testutils_target_check_end(const dif_i2c_t *i2c,
                                        uint8_t *cont_byte) {
  uint8_t acq_fifo_lvl;
  TRY(dif_i2c_get_fifo_levels(i2c, NULL, NULL, NULL, &acq_fifo_lvl));
  TRY_CHECK(acq_fifo_lvl >= 1);

  dif_i2c_signal_t signal;
  uint8_t byte;
  TRY(dif_i2c_acquire_byte(i2c, &byte, &signal));
  // Check transaction is terminated with a stop or a continue that the caller
  // is prepared to handle
  if (signal == kDifI2cSignalStop) {
    return OK_STATUS(false);
  }
  TRY_CHECK(cont_byte != NULL);
  *cont_byte = byte;
  TRY_CHECK(signal == kDifI2cSignalRepeat);

  return OK_STATUS(true);
}

status_t i2c_testutils_target_read(const dif_i2c_t *i2c, uint8_t byte_count,
                                   const uint8_t *data) {
  uint8_t tx_fifo_lvl, acq_fifo_lvl;
  TRY(dif_i2c_get_fifo_levels(i2c, NULL, NULL, &tx_fifo_lvl, &acq_fifo_lvl));
  // Check there's space in tx_fifo and acq_fifo
  TRY_CHECK(tx_fifo_lvl + byte_count <= I2C_PARAM_FIFO_DEPTH);
  TRY_CHECK(acq_fifo_lvl + 2 <= I2C_PARAM_FIFO_DEPTH);

  for (uint8_t i = 0; i < byte_count; ++i) {
    TRY(dif_i2c_transmit_byte(i2c, data[i]));
  }
  // TODO: Check for errors / status.
  return OK_STATUS();
}

status_t i2c_testutils_target_check_read(const dif_i2c_t *i2c, uint8_t *addr,
                                         uint8_t *cont_byte) {
  int32_t dir = TRY(i2c_testutils_target_check_start(i2c, addr));
  TRY_CHECK(dir == kI2cRead);
  // TODO: Check for errors / status.
  return i2c_testutils_target_check_end(i2c, cont_byte);
}

status_t i2c_testutils_target_write(const dif_i2c_t *i2c, uint8_t byte_count) {
  uint8_t acq_fifo_lvl;
  TRY(dif_i2c_get_fifo_levels(i2c, NULL, NULL, NULL, &acq_fifo_lvl));
  TRY_CHECK(acq_fifo_lvl + 2 + byte_count <= I2C_PARAM_FIFO_DEPTH);

  // TODO: Check for errors / status.
  return OK_STATUS();
}

status_t i2c_testutils_target_check_write(const dif_i2c_t *i2c,
                                          uint8_t byte_count, uint8_t *addr,
                                          uint8_t *bytes, uint8_t *cont_byte) {
  uint8_t acq_fifo_lvl;
  TRY(dif_i2c_get_fifo_levels(i2c, NULL, NULL, NULL, &acq_fifo_lvl));
  TRY_CHECK(acq_fifo_lvl >= 2 + byte_count);

  int32_t dir = TRY(i2c_testutils_target_check_start(i2c, addr));
  TRY_CHECK(dir == kI2cWrite);

  for (uint8_t i = 0; i < byte_count; ++i) {
    dif_i2c_signal_t signal;
    TRY(dif_i2c_acquire_byte(i2c, bytes + i, &signal));
    TRY_CHECK(signal == kDifI2cSignalNone);
  }

  // TODO: Check for errors / status.

  return i2c_testutils_target_check_end(i2c, cont_byte);
}

status_t i2c_testutils_select_pinmux(const dif_pinmux_t *pinmux, uint8_t i2c_id,
                                     i2c_pinmux_platform_id_t platform) {
  TRY_CHECK(
      platform < I2cPinmuxPlatformIdCount && i2c_id < ARRAYSIZE(kI2cPinmuxPins),
      "Index out of bounds");
  // Configure sda pin.
  TRY(dif_pinmux_input_select(pinmux, kI2cPinmuxPins[i2c_id].sda.peripheral_in,
                              kI2cPlatformPins[platform].sda.insel));
  TRY(dif_pinmux_output_select(pinmux, kI2cPlatformPins[platform].sda.mio_out,
                               kI2cPinmuxPins[i2c_id].sda.outsel));

  // Configure scl pin.
  TRY(dif_pinmux_input_select(pinmux, kI2cPinmuxPins[i2c_id].scl.peripheral_in,
                              kI2cPlatformPins[platform].scl.insel));
  TRY(dif_pinmux_output_select(pinmux, kI2cPlatformPins[platform].scl.mio_out,
                               kI2cPinmuxPins[i2c_id].scl.outsel));
  return OK_STATUS();
}

status_t i2c_testutils_detach_pinmux(const dif_pinmux_t *pinmux,
                                     uint8_t i2c_id) {
  // Configure sda pin.
  TRY(dif_pinmux_input_select(pinmux, kI2cPinmuxPins[i2c_id].sda.peripheral_in,
                              kTopEarlgreyPinmuxInselConstantZero));

  // Configure scl pin.
  TRY(dif_pinmux_input_select(pinmux, kI2cPinmuxPins[i2c_id].scl.peripheral_in,
                              kTopEarlgreyPinmuxInselConstantZero));
  return OK_STATUS();
}

status_t i2c_testutils_set_speed(const dif_i2c_t *i2c, dif_i2c_speed_t speed) {
  uint32_t speed_khz = 0;
  switch (speed) {
    case kDifI2cSpeedStandard:
      LOG_INFO("Setting i2c to %s mode.", "Standard (100kHz)");
      speed_khz = 100;
      break;
    case kDifI2cSpeedFast:
      LOG_INFO("Setting i2c to %s mode.", "Fast (400kHz)");
      speed_khz = 400;
      break;
    case kDifI2cSpeedFastPlus:
      LOG_INFO("Setting i2c to %s mode.", "FastPlus (1000kHz)");
      speed_khz = 1000;
      break;
  }
  // I2C speed parameters.
  dif_i2c_timing_config_t timing_config = {
      .lowest_target_device_speed = speed,
      .clock_period_nanos =
          (uint32_t)udiv64_slow(1000000000, kClockFreqPeripheralHz, NULL),
      .sda_rise_nanos = 400,
      .sda_fall_nanos = 110,
      .scl_period_nanos = 1000000 / speed_khz};

  dif_i2c_status_t status;
  TRY(dif_i2c_get_status(i2c, &status));
  if (status.enable_host) {
    TRY(dif_i2c_host_set_enabled(i2c, kDifToggleDisabled));
  }
  dif_i2c_config_t config;
  TRY(dif_i2c_compute_timing(timing_config, &config));

  LOG_INFO("period:%d nanos, cycles={fall=%d, rise=%d, hi=%d, lo=%d}",
           timing_config.clock_period_nanos, config.fall_cycles,
           config.rise_cycles, config.scl_time_high_cycles,
           config.scl_time_low_cycles);

  TRY(dif_i2c_configure(i2c, config));
  // Reenable if it was enabled before.
  if (status.enable_host) {
    TRY(dif_i2c_host_set_enabled(i2c, kDifToggleEnabled));
  }

  return OK_STATUS();
}

status_t i2c_testutils_wait_host_idle(const dif_i2c_t *i2c) {
  dif_i2c_status_t status;
  do {
    TRY(dif_i2c_get_status(i2c, &status));
  } while (!status.host_idle);
  return OK_STATUS();
}

status_t i2c_testutils_wait_transaction_finish(const dif_i2c_t *i2c) {
  dif_i2c_status_t status;
  do {
    TRY(dif_i2c_get_status(i2c, &status));
  } while (!status.fmt_fifo_empty);
  return OK_STATUS();
}
