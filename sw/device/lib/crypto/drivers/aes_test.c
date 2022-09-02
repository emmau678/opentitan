// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/crypto/drivers/aes.h"

#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

// NIST 800-38a F.5.1 CTR-AES128.Encrypt test vectors.
static const uint32_t kSecretKey[] = {
    // Key: 2b7e151628aed2a6abf7158809cf4f3c
    0x16157e2b,
    0xa6d2ae28,
    0x8815f7ab,
    0x3c4fcf09,
};

static const aes_block_t kIv = {
    .data =
        {
            // Init Counter: f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
            0xf3f2f1f0,
            0xf7f6f5f4,
            0xfbfaf9f8,
            0xfffefdfc,
        },
};

static const aes_block_t kPlaintext[] = {
    // Block#1: 6bc1bee22e409f96e93d7e117393172a
    {.data = 0xe2bec16b, 0x969f402e, 0x117e3de9, 0x2a179373},
    // Block#2: ae2d8a571e03ac9c9eb76fac45af8e51
    {.data = 0x578a2dae, 0x9cac031e, 0xac6fb79e, 0x518eaf45},
    // Block#3: 30c81c46a35ce411e5fbc1191a0a52ef
    {.data = 0x461cc830, 0x11e45ca3, 0x19c1fbe5, 0xef520a1a},
    // Block#4: f69f2445df4f9b17ad2b417be66c3710
    {.data = 0x45249ff6, 0x179b4fdf, 0x7b412bad, 0x10376ce6},
};

static const aes_block_t kCiphertext[] = {
    // Block#1: 874d6191b620e3261bef6864990db6ce
    {.data = 0x91614d87, 0x26e320b6, 0x6468ef1b, 0xceb60d99},
    // Block#2: 9806f66b7970fdff8617187bb9fffdff
    {.data = 0x6bf60698, 0xfffd7079, 0x7b181786, 0xfffdffb9},
    // Block#3: 5ae4df3edbd5d35e5b4f09020db03eab
    {.data = 0x3edfe45a, 0x5ed3d5db, 0x02094f5b, 0xab3eb00d},
    // Block#4: 1e031dda2fbe03d1792170a0f3009cee
    {.data = 0xda1d031e, 0xd103be2f, 0xa0702179, 0xee9c00f3},
};

OTTF_DEFINE_TEST_CONFIG();
bool test_main(void) {
  // This is a weak share intended to exercise correct configuration of the
  // hardware; in general, the key should be generated by either generating
  // two shares and setting key = a ^ b, or generating a mask and setting
  // a = key ^ mask, b = mask.
  const uint32_t share0[8] = {~kSecretKey[0],
                              ~kSecretKey[1],
                              ~kSecretKey[2],
                              ~kSecretKey[3],
                              0,
                              0,
                              0,
                              0};
  const uint32_t share1[8] = {UINT32_MAX, UINT32_MAX, UINT32_MAX, UINT32_MAX,
                              0,          0,          0,          0};

  LOG_INFO("Configuring the AES hardware.");
  aes_key_t key = {
      .mode = kAesCipherModeCtr,
      .sideload = kHardenedBoolFalse,
      .key_len = kAesKeyLen128,
      .key_shares = {share0, share1},
  };
  CHECK(aes_encrypt_begin(key, &kIv) == kAesOk);

  aes_block_t ciphertext[ARRAYSIZE(kCiphertext)] = {0};
  for (size_t i = 0; i < ARRAYSIZE(kPlaintext); ++i) {
    LOG_INFO("Processing block %d.", i);
    aes_block_t *out = (i > 0) ? &ciphertext[i - 1] : NULL;
    CHECK(aes_update(out, &kPlaintext[i]) == kAesOk);
  }
  CHECK(aes_update(&ciphertext[ARRAYSIZE(ciphertext) - 1], NULL) == kAesOk);

  CHECK_ARRAYS_EQ((uint32_t *)ciphertext, (uint32_t *)kCiphertext,
                  sizeof(ciphertext) / (sizeof(uint32_t)));

  LOG_INFO("Cleaning up.");
  CHECK(aes_end() == kAesOk);

  return true;
}
