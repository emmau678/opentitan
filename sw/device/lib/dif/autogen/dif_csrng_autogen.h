// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_DIF_AUTOGEN_DIF_CSRNG_AUTOGEN_H_
#define OPENTITAN_SW_DEVICE_LIB_DIF_AUTOGEN_DIF_CSRNG_AUTOGEN_H_

// This file is auto-generated.

/**
 * @file
 * @brief <a href="/hw/ip/csrng/doc/">CSRNG</a> Device Interface Functions
 */

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_base.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * A handle to csrng.
 *
 * This type should be treated as opaque by users.
 */
typedef struct dif_csrng {
  /**
   * The base address for the csrng hardware registers.
   */
  mmio_region_t base_addr;
} dif_csrng_t;

/**
 * A csrng interrupt request type.
 */
typedef enum dif_csrng_irq {
  /**
   * Asserted when a command request is completed.
   */
  kDifCsrngIrqCsCmdReqDone = 0,
  /**
   * Asserted when a request for entropy has been made.
   */
  kDifCsrngIrqCsEntropyReq = 1,
  /**
   * Asserted when a hardware-attached CSRNG instance encounters a command
   * exception
   */
  kDifCsrngIrqCsHwInstExc = 2,
  /**
   * Asserted when a FIFO error or a fatal alert occurs. Check the !!ERR_CODE
   * register to get more information.
   */
  kDifCsrngIrqCsFatalErr = 3,
} dif_csrng_irq_t;

/**
 * A snapshot of the state of the interrupts for this IP.
 *
 * This is an opaque type, to be used with the `dif_csrng_irq_get_state()`
 * function.
 */
typedef uint32_t dif_csrng_irq_state_snapshot_t;

/**
 * A snapshot of the enablement state of the interrupts for this IP.
 *
 * This is an opaque type, to be used with the
 * `dif_csrng_irq_disable_all()` and `dif_csrng_irq_restore_all()`
 * functions.
 */
typedef uint32_t dif_csrng_irq_enable_snapshot_t;

/**
 * Returns whether a particular interrupt is currently pending.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @param[out] is_pending Out-param for whether the interrupt is pending.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_get_state(const dif_csrng_t *csrng,
                                     dif_csrng_irq_state_snapshot_t *snapshot);

/**
 * Returns whether a particular interrupt is currently pending.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @param[out] is_pending Out-param for whether the interrupt is pending.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_is_pending(const dif_csrng_t *csrng,
                                      dif_csrng_irq_t irq, bool *is_pending);

/**
 * Acknowledges a particular interrupt, indicating to the hardware that it has
 * been successfully serviced.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_acknowledge(const dif_csrng_t *csrng,
                                       dif_csrng_irq_t irq);

/**
 * Checks whether a particular interrupt is currently enabled or disabled.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @param[out] state Out-param toggle state of the interrupt.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_get_enabled(const dif_csrng_t *csrng,
                                       dif_csrng_irq_t irq,
                                       dif_toggle_t *state);

/**
 * Sets whether a particular interrupt is currently enabled or disabled.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @param state The new toggle state for the interrupt.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_set_enabled(const dif_csrng_t *csrng,
                                       dif_csrng_irq_t irq, dif_toggle_t state);

/**
 * Forces a particular interrupt, causing it to be serviced as if hardware had
 * asserted it.
 *
 * @param csrng A csrng handle.
 * @param irq An interrupt request.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_force(const dif_csrng_t *csrng, dif_csrng_irq_t irq);

/**
 * Disables all interrupts, optionally snapshotting all enable states for later
 * restoration.
 *
 * @param csrng A csrng handle.
 * @param[out] snapshot Out-param for the snapshot; may be `NULL`.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_disable_all(
    const dif_csrng_t *csrng, dif_csrng_irq_enable_snapshot_t *snapshot);

/**
 * Restores interrupts from the given (enable) snapshot.
 *
 * @param csrng A csrng handle.
 * @param snapshot A snapshot to restore from.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_csrng_irq_restore_all(
    const dif_csrng_t *csrng, const dif_csrng_irq_enable_snapshot_t *snapshot);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_DIF_AUTOGEN_DIF_CSRNG_AUTOGEN_H_
