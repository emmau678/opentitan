// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AUTOGENERATED. Do not edit this file by hand.
// See the tests/crypto README for details.

#ifndef OPENTITAN_SW_DEVICE_TESTS_CRYPTO_ECDSA_P256_VERIFY_TESTVECTORS_H_
#define OPENTITAN_SW_DEVICE_TESTS_CRYPTO_ECDSA_P256_VERIFY_TESTVECTORS_H_

#include "sw/device/lib/crypto/impl/ecc/ecdsa_p256.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * A test vector for ECDSA-P256 verify.
 *
 * Assumes the message is to be hashed with SHA2-256. Note that these test
 * vectors contain only the public key and cannot be used to test the
 * corresponding sign operation.
 */
typedef const struct ecdsa_p256_verify_test_vector {
  // The public key.
  p256_point_t public_key;
  // The signature to verify.
  ecdsa_p256_signature_t signature;
  // Expected result (true iff signature is valid).
  bool valid;
  // Any notes about the test vector (a C string).
  char *comment;
  // Length (in bytes) of the message.
  size_t msg_len;
  // Message bytes.
  const uint8_t *msg;
} ecdsa_p256_verify_test_vector_t;

static const size_t kEcdsaP256VerifyNumTests = ${len(tests)};

// Static message arrays.
% for i in range(len(tests)):
  % if tests[i]["msg_len"] == 0:
// msg${i} is empty.
  % else:
static const uint8_t msg${i}[${tests[i]["msg_len"]}] = {${', '.join(['{:#04x}'.format(b) for b in tests[i]["msg_bytes"]])}};
  %endif
% endfor

static const ecdsa_p256_verify_test_vector_t ecdsa_p256_verify_tests[${len(tests)}] = {
% for idx, t in enumerate(tests):
    {
        .public_key =
            { .x = {
  % for i in range(0, len(t["x_hexwords"]), 4):
                    ${', '.join(t["x_hexwords"][i:i + 4])},
  % endfor
              },
              .y = {
  % for i in range(0, len(t["y_hexwords"]), 4):
                    ${', '.join(t["y_hexwords"][i:i + 4])},
  % endfor
              },
            },
        .signature =
            { .r = {
  % for i in range(0, len(t["r_hexwords"]), 4):
                    ${', '.join(t["r_hexwords"][i:i + 4])},
  % endfor
              },
              .s = {
  % for i in range(0, len(t["s_hexwords"]), 4):
                    ${', '.join(t["s_hexwords"][i:i + 4])},
  % endfor
              },
            },
  % if t["msg_len"] == 0:
        .msg = NULL,
  % else:
        .msg = msg${idx},
  % endif
        .msg_len = ${t["msg_len"]},
        .valid = ${"true" if t["valid"] else "false"},
        .comment = "${t["comment"]}",
    },
% endfor
};

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_TESTS_CRYPTO_ECDSA_P256_VERIFY_TESTVECTORS_H_
