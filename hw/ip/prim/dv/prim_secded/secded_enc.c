// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encode code generated by
// util/design/secded_gen.py from util/design/data/secded_cfg.hjson

#include <stdbool.h>
#include <stdint.h>

#include "secded_enc.h"

// Calculates even parity for a 64-bit word
static uint8_t calc_parity(uint64_t word) {
  bool parity = false;

  while (word) {
    if (word & 1) {
      parity = !parity;
    }

    word >>= 1;
  }

  return parity;
}

uint8_t enc_secded_22_16(const uint8_t bytes[2]) {
  uint16_t word = ((uint16_t)bytes[0] << 0) | ((uint16_t)bytes[1] << 8);

  return (calc_parity(word & 0x496e) << 0) | (calc_parity(word & 0xf20b) << 1) |
         (calc_parity(word & 0x8ed8) << 2) | (calc_parity(word & 0x7714) << 3) |
         (calc_parity(word & 0xaca5) << 4) | (calc_parity(word & 0x11f3) << 5);
}

uint8_t enc_secded_28_22(const uint8_t bytes[3]) {
  uint32_t word = ((uint32_t)bytes[0] << 0) | ((uint32_t)bytes[1] << 8) |
                  ((uint32_t)bytes[2] << 16);

  return (calc_parity(word & 0x3003ff) << 0) |
         (calc_parity(word & 0x10fc0f) << 1) |
         (calc_parity(word & 0x271c71) << 2) |
         (calc_parity(word & 0x3b6592) << 3) |
         (calc_parity(word & 0x3daaa4) << 4) |
         (calc_parity(word & 0x3ed348) << 5);
}

uint8_t enc_secded_39_32(const uint8_t bytes[4]) {
  uint32_t word = ((uint32_t)bytes[0] << 0) | ((uint32_t)bytes[1] << 8) |
                  ((uint32_t)bytes[2] << 16) | ((uint32_t)bytes[3] << 24);

  return (calc_parity(word & 0x2606bd25) << 0) |
         (calc_parity(word & 0xdeba8050) << 1) |
         (calc_parity(word & 0x413d89aa) << 2) |
         (calc_parity(word & 0x31234ed1) << 3) |
         (calc_parity(word & 0xc2c1323b) << 4) |
         (calc_parity(word & 0x2dcc624c) << 5) |
         (calc_parity(word & 0x98505586) << 6);
}

uint8_t enc_secded_64_57(const uint8_t bytes[8]) {
  uint64_t word = ((uint64_t)bytes[0] << 0) | ((uint64_t)bytes[1] << 8) |
                  ((uint64_t)bytes[2] << 16) | ((uint64_t)bytes[3] << 24) |
                  ((uint64_t)bytes[4] << 32) | ((uint64_t)bytes[5] << 40) |
                  ((uint64_t)bytes[6] << 48) | ((uint64_t)bytes[7] << 56);

  return (calc_parity(word & 0x103fff800007fff) << 0) |
         (calc_parity(word & 0x17c1ff801ff801f) << 1) |
         (calc_parity(word & 0x1bde1f87e0781e1) << 2) |
         (calc_parity(word & 0x1deee3b8e388e22) << 3) |
         (calc_parity(word & 0x1ef76cdb2c93244) << 4) |
         (calc_parity(word & 0x1f7bb56d5525488) << 5) |
         (calc_parity(word & 0x1fbdda769a46910) << 6);
}

uint8_t enc_secded_72_64(const uint8_t bytes[8]) {
  uint64_t word = ((uint64_t)bytes[0] << 0) | ((uint64_t)bytes[1] << 8) |
                  ((uint64_t)bytes[2] << 16) | ((uint64_t)bytes[3] << 24) |
                  ((uint64_t)bytes[4] << 32) | ((uint64_t)bytes[5] << 40) |
                  ((uint64_t)bytes[6] << 48) | ((uint64_t)bytes[7] << 56);

  return (calc_parity(word & 0xb9000000001fffff) << 0) |
         (calc_parity(word & 0x5e00000fffe0003f) << 1) |
         (calc_parity(word & 0x67003ff003e007c1) << 2) |
         (calc_parity(word & 0xcd0fc0f03c207842) << 3) |
         (calc_parity(word & 0xb671c711c4438884) << 4) |
         (calc_parity(word & 0xb5b65926488c9108) << 5) |
         (calc_parity(word & 0xcbdaaa4a91152210) << 6) |
         (calc_parity(word & 0x7aed348d221a4420) << 7);
}
