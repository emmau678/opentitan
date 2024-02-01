// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_TESTS_OTBN_RANDOMNESS_IMPL_H_
#define OPENTITAN_SW_DEVICE_TESTS_OTBN_RANDOMNESS_IMPL_H_

#include <stdbool.h>

#include "sw/device/lib/dif/dif_otbn.h"

/**
 * Prepares the OTBN randomness test.
 *
 * Does the same as otbn_randomness_test_start() without
 * executing the test.
 *
 * @param otbn A OTBN dif handle.
 * @param iters The number of entropy requests to the RND CSR.
 */
void otbn_randomness_test_prepare(dif_otbn_t *otbn, uint32_t iters);

/**
 * Starts OTBN randomness test.
 *
 * Requires EDN0 and EDN1 to be serving entropy, as well as an initialized
 * `otbn` runtime handle. A Randomness test is loaded into OTBN. Use the
 * `otbn_randomness_test_end()` function to check the test status. This function
 * is non-blocking.
 *
 * @param otbn A OTBN dif handle.
 * @param iters The number of entropy requests to the RND CSR.
 */
void otbn_randomness_test_start(dif_otbn_t *otbn, uint32_t iters);

/**
 * Checks the OTBN randomness test result.
 *
 * This function must be called after `otbn_randomness_test_start()`.
 *
 * @param otbn A OTBN dif handle.
 * @param skip_otbn_done_check Set to true to skip OTBN done execution check.
 * The check is blocking.
 * @returns true on test pass, false otherwise.
 */
bool otbn_randomness_test_end(dif_otbn_t *otbn, bool skip_otbn_done_check);

/**
 * Prints the randomness data generated by the test.
 *
 * This function must be called after OTBN is done executing the program loaded
 * by the `otbn_randomness_test_start()` function.
 *
 * @param otbn A OTBN dif handle.
 */
void otbn_randomness_test_log_results(dif_otbn_t *otbn);

#endif  // OPENTITAN_SW_DEVICE_TESTS_OTBN_RANDOMNESS_IMPL_H_
