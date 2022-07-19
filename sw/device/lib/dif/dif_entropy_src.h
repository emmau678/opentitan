// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_DIF_DIF_ENTROPY_SRC_H_
#define OPENTITAN_SW_DEVICE_LIB_DIF_DIF_ENTROPY_SRC_H_

/**
 * @file
 * @brief <a href="/hw/ip/entropy_src/doc/">Entropy Source</a> Device Interface
 * Functions
 */

#include <stdint.h>

#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_base.h"

#include "sw/device/lib/dif/autogen/dif_entropy_src_autogen.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * A single-bit RNG mode, where only one bit is sampled.
 */
typedef enum dif_entropy_src_single_bit_mode {
  /**
   * Single-bit-mode, sampling the zeroth bit.
   */
  kDifEntropySrcSingleBitMode0 = 0,
  /**
   * Single-bit-mode, sampling the first bit.
   */
  kDifEntropySrcSingleBitMode1 = 1,
  /**
   * Single-bit-mode, sampling the second bit.
   */
  kDifEntropySrcSingleBitMode2 = 2,
  /**
   * Single-bit-mode, sampling the third bit.
   */
  kDifEntropySrcSingleBitMode3 = 3,
  /**
   * Indicates that single-bit-mode is disabled.
   */
  kDifEntropySrcSingleBitModeDisabled = 4,
} dif_entropy_src_single_bit_mode_t;

/**
 * Main FSM state.
 */
typedef enum dif_entropy_src_main_fsm {
  kDifEntropySrcMainFsmStateIdle = 0x0f5,
  kDifEntropySrcMainFsmStateBootHTRunning = 0x1d2,
  kDifEntropySrcMainFsmStateBootPostHTChk = 0x16e,
  kDifEntropySrcMainFsmStateBootPhaseDone = 0x08e,
  kDifEntropySrcMainFsmStateStartupHTStart = 0x02c,
  kDifEntropySrcMainFsmStateStartupPhase1 = 0x101,
  kDifEntropySrcMainFsmStateStartupPass1 = 0x1a5,
  kDifEntropySrcMainFsmStateStartupFail1 = 0x017,
  kDifEntropySrcMainFsmStateContHTStart = 0x040,
  kDifEntropySrcMainFsmStateContHTRunning = 0x1a2,
  kDifEntropySrcMainFsmStateFWInsertStart = 0x0c3,
  kDifEntropySrcMainFsmStateFWInsertMsg = 0x059,
  kDifEntropySrcMainFsmStateSha3MsgDone = 0x10f,
  kDifEntropySrcMainFsmStateSha3Prep = 0x0f8,
  kDifEntropySrcMainFsmStateSha3Process = 0x0bf,
  kDifEntropySrcMainFsmStateSha3Valid = 0x171,
  kDifEntropySrcMainFsmStateSha3Done = 0x198,
  kDifEntropySrcMainFsmStateSha3Quiesce = 0x1cd,
  kDifEntropySrcMainFsmStateAlertState = 0x1fb,
  kDifEntropySrcMainFsmStateAlertHang = 0x15c,
  kDifEntropySrcMainFsmStateError = 0x13d
} dif_entropy_src_main_fsm_t;

/**
 * Firmware override parameters for an entropy source.
 */
typedef struct dif_entropy_src_fw_override_config {
  /**
   * Enables firmware to insert entropy bits back into the pre-conditioner block
   * via `dif_entropy_fifo_write()` calls. This feature is useful when the
   * firmware is required to implement additional health checks, and to perform
   * known answer tests of the preconditioner function.
   *
   * To take effect, this requires the firmware override feature to be enabled.
   */
  bool entropy_insert_enable;
  /**
   * This field sets the depth of the observe FIFO hardware buffer used when
   * the firmware override feature is enabled.
   */
  uint8_t buffer_threshold;
} dif_entropy_src_fw_override_config_t;

/**
 * Runtime configuration for an entropy source.
 *
 * This struct describes runtime information for one-time configuration of the
 * hardware.
 */
typedef struct dif_entropy_src_config {
  /**
   * If set, FIPS compliant entropy will be generated by this module after being
   * processed by an SP 800-90B compliant conditioning function.
   *
   * Software may opt for implementing FIPS mode of operation without hardware
   * support by setting this field to false. In such case, software is
   * responsible for implementing the conditioning function.
   */
  bool fips_enable;
  /**
   * If set, entropy will be routed to a firmware-visible register instead of
   * being distributed to other hardware IPs.
   */
  bool route_to_firmware;
  /**
   * Specifies which single-bit-mode to use, if any at all.
   */
  dif_entropy_src_single_bit_mode_t single_bit_mode;
  /**
   * Controls the scope (either by-line or by-sum) of the health tests.
   *
   * If true, the Adaptive Proportion and Markov Tests will accumulate all RNG
   * input lines into a single score, and thresholds will be applied to the sum
   * of all the entropy input lines.
   *
   * If false, the RNG input lines are all scored individually. A statistical
   * deviation in any one input line, be it due to coincidence or failure, will
   * force rejection of the sample, and count toward the total alert count.
   */
  bool health_test_threshold_scope;
  /**
   * The size of the window used for health tests.
   *
   * Units: bits
   */
  uint16_t health_test_window_size;
  /**
   * The number of health test failures that must occur before an alert is
   * triggered. When set to 0, alerts are disabled.
   */
  uint16_t alert_threshold;
} dif_entropy_src_config_t;

/**
 * A statistical test on the bits emitted by an entropy source.
 */
typedef enum dif_entropy_src_test {
  /**
   * An SP 800-90B repetition count test.
   *
   * This test screens for stuck bits, or a total failure of the noise source.
   * This test fails if any sequence of bits repeats too many times in a row
   * for too many samples.
   */
  kDifEntropySrcTestRepetitionCount = 0,
  /**
   * An SP 800-90B symbol repetition count test.
   *
   * This is similar to the above, test but is performed on a symbol, instead of
   * bit, basis.
   */
  kDifEntropySrcTestRepetitionCountSymbol = 1,
  /**
   * An SP 800-90B adaptive proportion test.
   *
   * This test screens for statistical bias in the number of ones or zeros
   * output by the noise source.
   */
  kDifEntropySrcTestAdaptiveProportion = 2,
  /**
   * A bucket test.
   *
   * This test looks for correlations between individual noise channels.
   */
  kDifEntropySrcTestBucket = 3,
  /**
   * A "Markov" test.
   *
   * This test looks for unexpected first-order temporal correlations
   * between individual noise channels.
   */
  kDifEntropySrcTestMarkov = 4,
  /**
   * A firmware-driven "mailbox" test.
   *
   * This test allows firmware to inspect 2kbit blocks of entropy, and signal
   * potential concerns to the hardware.
   */
  kDifEntropySrcTestMailbox = 5,
  /** \internal */
  kDifEntropySrcTestNumVariants = 6,
} dif_entropy_src_test_t;

/**
 * Criteria used by various entropy source health tests to decide whether the
 * test has failed.
 */
typedef struct dif_entropy_src_health_test_config {
  /**
   * The entropy source health test type to configure.
   */
  dif_entropy_src_test_t test_type;
  /**
   * The high threshold for the health test.
   */
  uint16_t high_threshold;
  /**
   * The low threshold for the health test.
   *
   * If the corresponding health test has no low threshold, set to 0, otherwise
   * `dif_entropy_src_health_test_configure()` will return `kDifBadArg`.
   */
  uint16_t low_threshold;
} dif_entropy_src_health_test_config_t;

/**
 * Revision information for an entropy source.
 *
 * The fields of this struct have an implementation-specific interpretation.
 */
typedef struct dif_entropy_src_revision {
  uint8_t abi_revision;
  uint8_t hw_revision;
  uint8_t chip_type;
} dif_entropy_src_revision_t;

/**
 * Statistics on entropy source health tests.
 */
typedef struct dif_entropy_src_health_test_stats {
  /**
   * High watermark indicating the highest value emitted by a particular test.
   */
  uint16_t high_watermark[kDifEntropySrcTestNumVariants];
  /**
   * Low watermark indicating the lowest value emitted by a particular test.
   *
   * Note, some health tests do not emit a low watermark as there is no low
   * threshold. For these tests, this value will always be UINT16_MAX.
   */
  uint16_t low_watermark[kDifEntropySrcTestNumVariants];
  /**
   * The number of times a particular test has failed above the high threshold.
   */
  uint32_t high_fails[kDifEntropySrcTestNumVariants];
  /**
   * The number of times a particular test has failed below the low threshold.
   *
   * Note, some health tests do not have a low threshold. For these tests, this
   * value will always be 0.
   */
  uint32_t low_fails[kDifEntropySrcTestNumVariants];
} dif_entropy_src_health_test_stats_t;

/**
 * Statistics on entropy source health tests failures that triggered alerts.
 */
typedef struct dif_entropy_src_alert_fail_counts {
  /**
   * The total number of test failures, across all test types, that contributed
   * to the alerts fired.
   */
  uint16_t total_fails;
  /**
   * The number of test failures, due to the specific test execeeding the high
   * threshold, that cause alerts to be fired.
   */
  uint8_t high_fails[kDifEntropySrcTestNumVariants];
  /**
   * The number of test failures, due to the specific test execeeding the low
   * threshold, that cause alerts to be fired.
   *
   * Note, some health tests do not have a low threshold. For these tests, this
   * value will always be 0.
   */
  uint8_t low_fails[kDifEntropySrcTestNumVariants];
} dif_entropy_src_alert_fail_counts_t;

/**
 * Recoverable alerts.
 */
typedef enum dif_entropy_src_alert_cause {
  /**
   * Triggered when the FIPS_ENABLE field in the CONF register is set to an
   * unsupported value.
   */
  kDifEntropySrcAlertFipsEnableField = 1U << 0,
  /**
   * Triggered when the ENTROPY_DATA_REG_ENABLE field in the CONF register is
   * set to an unsupported value.
   */
  kDifEntropySrcAlertEntropyDataRegEnField = 1U << 1,
  /**
   * Triggered when the MODULE_ENABLE field in the MODULE_ENABLE register is set
   * to an unsupported value.
   */
  kDifEntropySrcAlertModuleEnableField = 1U << 2,
  /**
   * Triggered when the THRESHOLD_SCOPE field in the CONF register is set to an
   * unsupported value.
   */
  kDifEntropySrcAlertThresholdScopeField = 1U << 3,
  /**
   * Triggered when the RNG_BIT_ENABLE field in the CONF register is set to an
   * unsupported value.
   */
  kDifEntropySrcAlertRngBitEnableField = 1U << 5,
  /**
   * Triggered when the FW_OV_SHA3_START field in the FW_OV_SHA3_START register
   * is set to an unsupported value.
   */
  kDifEntropySrcAlertFwOvSha3StartField = 1U << 7,
  /**
   * Triggered when the FW_OV_MODE field in the FW_OV_CONTROL register is set to
   * an unsupported value.
   */
  kDifEntropySrcAlertFwOvModeField = 1U << 8,
  /**
   * Triggered when the FW_OV_ENTROPY_INSERT field in the FW_OV_CONTROL register
   * is set to an unsupported value.
   */
  kDifEntropySrcAlertFwOvEntropyInsertField = 1U << 9,
  /**
   * Triggered when the ES_ROUTE field in the ENTROPY_CONTROL register is set to
   * an unsupported value.
   */
  kDifEntropySrcAlertEsRouteField = 1U << 10,
  /**
   * Triggered when the ES_TYPE field in the ENTROPY_CONTROL register is set to
   * an unsupported value.
   */
  kDifEntropySrcAlertEsTypeField = 1U << 11,
  /**
   * Triggered when the main state machine detects a threshold failure state.
   */
  kDifEntropySrcAlertMainStateMachine = 1U << 12,
  /**
   * Triggered when the internal entropy bus value is equal to the prior valid
   * value on the bus, indicating a possible attack.
   */
  kDifEntropySrcAlertDuplicateValue = 1U << 13,
  /**
   * Triggered when the ALERT_THRESHOLD register is not configured properly,
   * i.e., the upper field must be the exact inverse of the lower field.
   */
  kDifEntropySrcAlertThresholdConfig = 1U << 14,
  /**
   * All alert reasons.
   *
   * This is useful when clearing all recoverable alerts at once.
   */
  kDifEntropySrcAlertAllAlerts = (1U << 15) - 1,
} dif_entropy_src_alert_cause_t;

/**
 * Error codes (non-recoverable).
 */
typedef enum dif_entropy_src_error {
  /**
   * Triggered when a write error has been detected for the esrng FIFO.
   */
  kDifEntropySrcErrorRngFifoWrite = 1U << 0,
  /**
   * Triggered when a read error has been detected for the esrng FIFO.
   */
  kDifEntropySrcErrorRngFifoRead = 1U << 1,
  /**
   * Triggered when a state error has been detected for the esrng FIFO.
   */
  kDifEntropySrcErrorRngFifoState = 1U << 2,
  /**
   * Triggered when a write error has been detected for the observe FIFO.
   */
  kDifEntropySrcErrorObserveFifoWrite = 1U << 3,
  /**
   * Triggered when a read error has been detected for the observe FIFO.
   */
  kDifEntropySrcErrorObserveFifoRead = 1U << 4,
  /**
   * Triggered when a state error has been detected for the observe FIFO.
   */
  kDifEntropySrcErrorObserveFifoState = 1U << 5,
  /**
   * Triggered when a write error has been detected for the esfinal FIFO.
   */
  kDifEntropySrcErrorFinalFifoWrite = 1U << 6,
  /**
   * Triggered when a read error has been detected for the esfinal FIFO.
   */
  kDifEntropySrcErrorFinalFifoRead = 1U << 7,
  /**
   * Triggered when a state error has been detected for the esfinal FIFO.
   */
  kDifEntropySrcErrorFinalFifoState = 1U << 8,
  /**
   * Triggered when an error has been detected for the acknowledgment stage
   * state machine.
   */
  kDifEntropySrcErrorAckStateMachine = 1U << 9,
  /**
   * Triggered when an error has been detected for the main state machine.
   */
  kDifEntropySrcErrorMainStateMachine = 1U << 10,
  /**
   * Triggered when an error has been detected for a hardened counter.
   */
  kDifEntropySrcErrorHardenedCounter = 1U << 11,
} dif_entropy_src_error_t;

/**
 * Configures entropy source with runtime information.
 *
 * This function should only need to be called once for the lifetime of the
 * `entropy` handle.
 *
 * @param entropy_src An entropy source handle.
 * @param config Runtime configuration parameters.
 * @param enabled The enablement state of the entropy source.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_configure(const dif_entropy_src_t *entropy_src,
                                       dif_entropy_src_config_t config,
                                       dif_toggle_t enabled);

/**
 * Configures entropy source firmware override feature with runtime information.
 *
 * This function should only need to be called once for the lifetime of the
 * `entropy` handle.
 *
 * @param entropy_src An entropy source handle.
 * @param config Runtime configuration parameters for firmware override.
 * @param enabled The enablement state of the firmware override option.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_fw_override_configure(
    const dif_entropy_src_t *entropy_src,
    dif_entropy_src_fw_override_config_t config, dif_toggle_t enabled);

/**
 * Configures an entropy source health test feature with runtime information.
 *
 * This function should only need to be called once for each health test that
 * requires configuration for the lifetime of the `entropy` handle.
 *
 * @param entropy_src An entropy source handle.
 * @param config Runtime configuration parameters for the health test.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_health_test_configure(
    const dif_entropy_src_t *entropy_src,
    dif_entropy_src_health_test_config_t config);

/**
 * Enables/Disables the entropy source.
 *
 * @param entropy_src An entropy source handle.
 * @param enabled The enablement state to configure the entropy source in.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_set_enabled(const dif_entropy_src_t *entropy_src,
                                         dif_toggle_t enabled);

/**
 * Locks out entropy source functionality.
 *
 * This function is reentrant: calling it while functionality is locked will
 * have no effect and return `kDifEntropySrcOk`.
 *
 * @param entropy_src An entropy source handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_lock(const dif_entropy_src_t *entropy_src);

/**
 * Checks whether this entropy source is locked.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] is_locked Out-param for the locked state.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_is_locked(const dif_entropy_src_t *entropy_src,
                                       bool *is_locked);

/**
 * Queries the entropy_src source IP for its revision information.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] revision Out-param for revision data.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_revision(const dif_entropy_src_t *entropy_src,
                                          dif_entropy_src_revision_t *revision);

/**
 * Queries the entropy source for health test statistics.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] stats Out-param for stats data.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_health_test_stats(
    const dif_entropy_src_t *entropy_src,
    dif_entropy_src_health_test_stats_t *stats);

/**
 * Queries the entropy source for health test failure statistics.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] counts Out-param for test failure data that triggers alerts.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_alert_fail_counts(
    const dif_entropy_src_t *entropy_src,
    dif_entropy_src_alert_fail_counts_t *counts);

/**
 * Checks to see if entropy is available for software consumption.
 *
 * @param entropy_src An entropy source handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_is_entropy_available(
    const dif_entropy_src_t *entropy_src);

/**
 * Reads a word of entropy from the entropy source.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] word Out-param for the entropy word.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_non_blocking_read(
    const dif_entropy_src_t *entropy_src, uint32_t *word);

/**
 * Performs a blocking read from the entropy pipeline through the observe FIFO,
 * which contains post-test, unconditioned entropy.
 *
 * The entropy source must be configured with firmware override mode enabled,
 * and the `len` parameter must be less than or equal to the FIFO threshold set
 * in the firmware override parameters (that is, the threshold that triggers an
 * interrupt). Additionally, `buf` may be `NULL`; in this case, reads will be
 * discarded.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] buf A buffer to fill with words from the pipeline.
 * @param len The number of words to read into `buf`.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_observe_fifo_blocking_read(
    const dif_entropy_src_t *entropy_src, uint32_t *buf, size_t len);

/**
 * Performs a write to the entropy pipeline through the observe FIFO.
 *
 * Entropy source must be configured with firmware override and insert mode
 * enabled, otherwise the function will return `kDifError`.
 *
 * @param entropy_src An entropy source handle.
 * @param buf A buffer to push words from into the pipeline.
 * @param len The number of words to write from `buf`.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_observe_fifo_write(
    const dif_entropy_src_t *entropy_src, const uint32_t *buf, size_t len);

/**
 * Starts conditioner operation.
 *
 * Initializes the conditioner. Use the `dif_entropy_src_observe_fifo_write()`
 * function to send data to the conditioner, and
 * `dif_entropy_src_conditioner_stop()` once ready to stop the conditioner
 * operation.
 *
 * This function is only available when firmware override mode is enabled. See
 * `dif_entropy_src_fw_override_configure()` for more details.
 *
 * @param entropy_src An entropy source handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_conditioner_start(
    const dif_entropy_src_t *entropy_src);

/**
 * Stops conditioner operation.
 *
 * The conditioner stops processing input data and deposits the result digest
 * in the entropy source output buffer. This operation is only available in
 * firmware override mode.
 *
 * @param entropy_src An entropy source handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_conditioner_stop(
    const dif_entropy_src_t *entropy_src);

/**
 * Checks whether the firmware override write FIFO is full.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] is_full Whether the FIFO is full.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_is_fifo_full(const dif_entropy_src_t *entropy_src,
                                          bool *is_full);

/**
 * Checks whether the firmware override read FIFO has overflowed.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] has_overflowed Whether the FIFO has overflowed, and data has been
 *                            lost.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_has_fifo_overflowed(
    const dif_entropy_src_t *entropy_src, bool *has_overflowed);

/**
 * Clears the firmware override read FIFO overflow status.
 *
 * @param entropy_src An entropy source handle.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_clear_fifo_overflow(
    const dif_entropy_src_t *entropy_src);

/**
 * Read the firmware override FIFO depth.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] fifo_depth The FIFO depth.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_fifo_depth(
    const dif_entropy_src_t *entropy_src, uint32_t *fifo_depth);

/**
 * Reads the recoverable alert status register.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] alerts The alerts that were triggered (one or more
 *                    `dif_entropy_src_alert_t`'s ORed together).
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_recoverable_alerts(
    const dif_entropy_src_t *entropy_src, uint32_t *alerts);

/**
 * Clears the alerts that are recoverable.
 *
 * @param entropy_src An entropy source handle.
 * @param alerts The alerts to be cleared (one or more
 *               `dif_entropy_src_alert_t`'s ORed together).
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_clear_recoverable_alerts(
    const dif_entropy_src_t *entropy_src, uint32_t alerts);

/**
 * Reads the (nonrecoverable) error code status register.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] errors The errors that were triggered (one or more
 *                    `dif_entropy_src_error_t`'s ORed together).
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_errors(const dif_entropy_src_t *entropy_src,
                                        uint32_t *errors);

/**
 * Forces the hardware to generate a error for testing purposes.
 *
 * @param entropy_src An entropy source handle.
 * @param error The error to force (for testing purposes).
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_error_force(const dif_entropy_src_t *entropy_src,
                                         dif_entropy_src_error_t error);

/**
 * Reads the current main FSM state.
 *
 * @param entropy_src An entropy source handle.
 * @param[out] state The current FSM state.
 * @return The result of the operation.
 */
OT_WARN_UNUSED_RESULT
dif_result_t dif_entropy_src_get_main_fsm_state(
    const dif_entropy_src_t *entropy_src, dif_entropy_src_main_fsm_t *state);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_DIF_DIF_ENTROPY_SRC_H_
