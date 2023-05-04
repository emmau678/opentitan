// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_MANUF_KEYS_FAKE_RMA_UNLOCK_TOKEN_EXPORT_KEY_PK_HSM_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_MANUF_KEYS_FAKE_RMA_UNLOCK_TOKEN_EXPORT_KEY_PK_HSM_H_

/**
 * These constants / macros were manually created from an ECDH P256 keypair
 * generated using OpenSSL and the following commands.
 *
 * Generate the curve:
 * `openssl ecparam -out curve.pem -name prime256v1`
 *
 * Generate the ECDH private key:
 * `openssl ecparam -in curve.pem -genkey -out sk_hsm.pem`
 *
 * Convert the ECDH private key from SEC1 format to PKCS8 (we do this because
 * the Rust elliptic-curve crate is able to load PKCS8 keys with less additional
 * crates):
 * `openssl ecparam -in curve.pem -genkey -out sk_hsm.pem`
 *
 * Show the ECDH public key (so this file can be manually created):
 * `openssl ec -in sk_hsm.pem -text -noout`
 *
 * It has been formatted to allow loading an ECC public key in the crypto lib.
 *
 * TODO: update opentitantool to generate the macro below directly using a key
 * file generated by OpenSSL, or an HSM.
 */

enum {
  kEcdhPrivateKeySizeInBytes = 32,
  kEcdhPrivateKeySizeIn32BitWords =
      kEcdhPrivateKeySizeInBytes / sizeof(uint32_t),
};

uint32_t kRmaUnlockTokenEcdhPkHsmX[kEcdhPrivateKeySizeIn32BitWords] = {
    0x26e70570, 0xe872db0c, 0x35cb49fd, 0x535515c5,
    0x6016d4ad, 0x52e4a956, 0xb1d23256, 0xae84bc49,
};

uint32_t kRmaUnlockTokenEcdhPkHsmY[kEcdhPrivateKeySizeIn32BitWords] = {
    0x6f009f88, 0xaf387b76, 0xdacdec5f, 0x3a87ea35,
    0x930fef81, 0xd46a8e82, 0xa26923ee, 0xff3a5694,
};

// TODO: update the .checksum fields once cryptolib uses this field.
#define RMA_UNLOCK_TOKEN_EXPORT_KEY_PK_HSM    \
  {                                           \
    .x =                                      \
        {                                     \
            .key_mode = kKeyModeEcdh,         \
            .key_length = 32,                 \
            .key = kRmaUnlockTokenEcdhPkHsmX, \
            .checksum = 0,                    \
        },                                    \
    .y = {                                    \
        .key_mode = kKeyModeEcdh,             \
        .key_length = 32,                     \
        .key = kRmaUnlockTokenEcdhPkHsmY,     \
        .checksum = 0,                        \
    },                                        \
  }

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_MANUF_KEYS_FAKE_RMA_UNLOCK_TOKEN_EXPORT_KEY_PK_HSM_H_
