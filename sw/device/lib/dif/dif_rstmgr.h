// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_
#define OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_

/**
 * @file
 * @brief <a href="/hw/ip/rstmgr/doc/">Reset Manager</a> Device Interface
 * Functions
 */

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_base.h"

#include "sw/device/lib/dif/autogen/dif_rstmgr_autogen.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * The maximal size of the alert crash info dump.
 *
 * Note: must match the autogenerated register definition.
 */
#define DIF_RSTMGR_ALERT_INFO_MAX_SIZE 0xf

/**
 * Reset Manager peripheral software reset control.
 */
typedef enum dif_rstmgr_software_reset {
  /**
   * Simple reset (release straight away).
   */
  kDifRstmgrSoftwareReset = 0,
  kDifRstmgrSoftwareResetHold,    /**< Hold peripheral in reset. */
  kDifRstmgrSoftwareResetRelease, /**< Release peripheral from reset. */
} dif_rstmgr_software_reset_t;

/**
 * Reset Manager reset information bitfield.
 */
typedef uint32_t dif_rstmgr_reset_info_bitfield_t;

/**
 * Reset Manager possible reset information enumeration.
 *
 * Invariants are used to extract information encoded in
 * `dif_rstmgr_reset_info_bitfield_t`, which means that the values must
 * correspond
 * to the individual bits (0x1, 0x2, 0x4, ..., 0x80000000).
 *
 * Note: these must match the autogenerated register definitions.
 */
typedef enum dif_rstmgr_reset_info {
  /**
   * Device has reset due to power up.
   */
  kDifRstmgrResetInfoPor = 0x1,
  /**
   * Device has reset due to lowe power exit.
   */
  kDifRstmgrResetInfoLowPowerExit = (0x1 << 1),
  /**
   * Device has reset due to non-debug-module request.
   */
  kDifRstmgrResetInfoNdm = (0x1 << 2),
  /**
   * Device has reset due to software request.
   */
  kDifRstmgrResetInfoSw = (0x1 << 3),
  /**
   * Device has reset due to a peripheral request. This can be an alert
   * escalation, watchdog or anything else.
   */
  kDifRstmgrResetInfoHwReq = (0xf << 4),
} dif_rstmgr_reset_info_t;

/**
 * Reset Manager software reset available peripherals.
 */
typedef uint32_t dif_rstmgr_peripheral_t;

/**
 * Creates a new handle for Reset Manager.
 *
 * This function does not actuate the hardware.
 *
 * @param params Hardware instantiation parameters.
 * @param handle Out param for the initialized handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_init(mmio_region_t base_addr, dif_rstmgr_t *handle);

/**
 * Resets the Reset Manager registers to sane defaults.
 *
 * Note that software reset enable registers cannot be cleared once have been
 * locked.
 *
 * @param handle A Reset Manager handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_reset(const dif_rstmgr_t *handle);

/**
 * Locks out requested peripheral reset functionality.
 *
 * Calling this function when software reset is locked will have no effect
 * and return `kDifOk`.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to lock the reset functionality for.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_reset_lock(const dif_rstmgr_t *handle,
                                   dif_rstmgr_peripheral_t peripheral);

/**
 * Checks whether requested peripheral reset functionality is locked.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to check the reset lock for.
 * @param is_locked Out-param for the locked state.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_reset_is_locked(const dif_rstmgr_t *handle,
                                        dif_rstmgr_peripheral_t peripheral,
                                        bool *is_locked);

/**
 * Obtains the complete Reset Manager reset information.
 *
 * The reset info are parsed and presented to the caller as an
 * array of flags in 'info'.
 *
 * @param handle A Reset Manager handle.
 * @param info Reset information.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_reset_info_get(const dif_rstmgr_t *handle,
                                       dif_rstmgr_reset_info_bitfield_t *info);

/**
 * Clears the reset information in Reset Manager.
 *
 * @param handle A Reset Manager handle.
 * @return `dif_result_t`.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_reset_info_clear(const dif_rstmgr_t *handle);

/**
 * Enables or disables the alert crash dump capture.
 *
 * When enabled, will capture the alert crash dump prior to a triggered reset.
 *
 * The alert info crash dump capture is automatically disabled upon system reset
 * (even if the Reset Manager is not reset).
 *
 * @param handle A Reset Manager handle.
 * @param state The new toggle state for the crash dump capture.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_alert_info_set_enabled(const dif_rstmgr_t *handle,
                                               dif_toggle_t state);

/**
 * Retrieves the alert info crash dump capture state.
 *
 * The alert info crash dump capture is automatically disabled upon system reset
 * (even if the Reset Manager is not reset).
 *
 * @param handle A Reset Manager handle.
 * @param state The state of the crash dump capture.
 * @return The result of the operation.
 */
dif_result_t dif_rstmgr_alert_info_get_enabled(const dif_rstmgr_t *handle,
                                               dif_toggle_t *state);

/**
 * Alert info crash dump segment.
 *
 * The alert info crash dump consists of 32-bit data segments
 */
typedef uint32_t dif_rstmgr_alert_info_dump_segment_t;

/**
 * Reads the entire alert info crash dump.
 *
 * The crash dump is always retained after any kind of reset, except on
 * Power-On-Reset (POR).
 *
 * @param handle A Reset Manager handle.
 * @param dump Alert info crash dump.
 * @param dump_size Size of the crash dump buffer. The entire crash dump will be
 *                  read, and the actual size can be determined through
 *                  the `segments_read` parameter.
 * @param segments_read Number of read segments.
 *
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_alert_info_dump_read(
    const dif_rstmgr_t *handle, dif_rstmgr_alert_info_dump_segment_t *dump,
    size_t dump_size, size_t *segments_read);

/**
 * The result of a Reset Manager software reset operation.
 */
typedef enum dif_rstmgr_software_reset_result {
  /**
   * Indicates that the operation succeeded.
   */
  kDifRstmgrSoftwareResetOk = kDifOk,
  /**
   * Indicates some unspecified failure.
   */
  kDifRstmgrSoftwareResetError = kDifError,
  /**
   * Indicates that some parameter passed into a function failed a
   * precondition.
   *
   * When this value is returned, no hardware operations occurred.
   */
  kDifRstmgrSoftwareResetBadArg = kDifBadArg,
  /**
   * Indicates that this operation has been locked out, and can never
   * succeed until hardware reset.
   */
  kDifRstmgrSoftwareResetLocked,
} dif_rstmgr_software_reset_result_t;

/**
 * Asserts or de-asserts software reset for the requested peripheral.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to assert/de-assert reset for.
 * @param reset Reset control.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_rstmgr_software_reset_result_t dif_rstmgr_software_reset(
    const dif_rstmgr_t *handle, dif_rstmgr_peripheral_t peripheral,
    dif_rstmgr_software_reset_t reset);

/**
 * Queries whether the requested peripheral is held in reset.
 *
 * @param handle A Reset Manager handle.
 * @param peripheral Peripheral to query.
 * @param asserted 'true' when held in reset, `false` otherwise.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_software_reset_is_held(
    const dif_rstmgr_t *handle, dif_rstmgr_peripheral_t peripheral,
    bool *asserted);

/**
 * Software request for system reset
 *
 * @param handle A Reset Manager handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_rstmgr_software_device_reset(const dif_rstmgr_t *handle);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_DIF_DIF_RSTMGR_H_
