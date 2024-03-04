// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#include "otcrypto.h"
#include "sw/device/lib/testing/test_framework/ottf_test_config.h"

// This test checks that the static-linked `otcrypto` library is usable and that
// the otcrypto include files can stand on their own outside the repository.
//
// Because we are trying to test the functionality of the includes outside the
// repo, we link with the special `crypto_exported_for_test` target and avoid
// in-repo definitions of `status_t` and other in-repo macro definitions.

// From: http://www.abrahamlincolnonline.org/lincoln/speeches/gettysburg.htm
static const char kGettysburgPrelude[] =
    "Four score and seven years ago our fathers brought forth on this "
    "continent, a new nation, conceived in Liberty, and dedicated to the "
    "proposition that all men are created equal.";

// The following shell command will produce the sha256sum and convert the
// digest into valid C hexadecimal constants:
//
// $ echo -n "Four score and seven years ago our fathers brought forth on this
// continent, a new nation, conceived in Liberty, and dedicated to the
// proposition that all men are created equal." |
//     sha256sum - | cut -f1 -d' ' | sed -e "s/../0x&, /g"
//
static const uint8_t kGettysburgDigest[] = {
    0x1e, 0x6f, 0xd4, 0x03, 0x0f, 0x90, 0x34, 0xcd, 0x77, 0x57, 0x08,
    0xa3, 0x96, 0xc3, 0x24, 0xed, 0x42, 0x0e, 0xc5, 0x87, 0xeb, 0x3d,
    0xd4, 0x33, 0xe2, 0x9f, 0x6a, 0xc0, 0x8b, 0x8c, 0xc7, 0xba,
};

enum {
  kHashLength = 8,
};

// Check the value of the status_t.  If the MSB is set, the value is an
// error and we return the error value.
#define RETURN_IF_ERROR(expr_) \
  do {                         \
    status_t e = expr_;        \
    if (e.value < 0)           \
      return e.value;          \
  } while (0)

int32_t hash_test(void) {
  uint32_t digest_content[kHashLength];
  otcrypto_hash_context_t ctx;
  otcrypto_hash_digest_t digest = {
      .mode = kOtcryptoHashModeSha256,
      .len = kHashLength,
      .data = digest_content,
  };
  otcrypto_const_byte_buf_t buf = {
      .len = sizeof(kGettysburgPrelude) - 1,
      .data = (const uint8_t *)kGettysburgPrelude,
  };

  RETURN_IF_ERROR(otcrypto_hash_init(&ctx, kOtcryptoHashModeSha256));
  RETURN_IF_ERROR(otcrypto_hash_update(&ctx, buf));
  RETURN_IF_ERROR(otcrypto_hash_final(&ctx, digest));

  if (memcmp(digest.data, kGettysburgDigest, sizeof(kGettysburgDigest)) != 0) {
    return -1;
  }
  return 0;
}

OTTF_DEFINE_TEST_CONFIG();

bool test_main(void) {
  int result = hash_test();
  return result == 0;
}
