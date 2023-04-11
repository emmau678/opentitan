// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_SIGVERIFY_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_SIGVERIFY_H_

#include <stddef.h>
#include <stdint.h>

#include "sw/device/silicon_creator/lib/sigverify/rsa_verify.h"
#include "sw/device/silicon_creator/lib/sigverify/usage_constraints.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

enum {
  /**
   * Correct `flash_exec` value.
   *
   * This value must be equal to `FLASH_CTRL_PARAM_EXEC_EN`. Defined here to be
   * able to use in tests.
   */
  kSigverifyFlashExec = 0xa26a38f7,
};

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_SIGVERIFY_H_
