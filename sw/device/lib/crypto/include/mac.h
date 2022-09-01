// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_CRYPTO_INCLUDE_MAC_H_
#define OPENTITAN_SW_DEVICE_LIB_CRYPTO_INCLUDE_MAC_H_

/**
 * @file
 * @brief Message authentication codes for the OpenTitan cryptography library.
 *
 * Supports message authentication based on either HMAC or KMAC.
 */

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Enum to define MAC mode.
 *
 * Values are hardened.
 */
typedef enum mac_mode {
  // HMAC-SHA2-256 mode.
  kMacModeHmacSha256 = 0x953c,
  // KMAC128 mode.
  kMacModeKmac128 = 0x69b6,
  // KMAC256 mode.
  kMacModeKmac256 = 0xee62,
} mac_mode_t;

/**
 * Generic hmac context.
 *
 * Representation is internal to the hmac implementation; initialize
 * with #otcrypto_hmac_init.
 */
typedef struct hmac_context hmac_context_t;

/**
 * Performs the HMAC / KMAC function on the input data.
 *
 * HMAC: This function computes the required MAC function on the
 * `input_message` using the `key` and returns a `digest`.
 *
 * KMAC: This function computes the KMAC on the `input_message` using
 * the `key` and returns a `digest` of `required_output_len`. The
 * customization string is passed through `customization_string`
 * parameter. If no customization is desired it can be empty. The
 * `customization_string` and `required_output_len` is only used for
 * KMAC modes and is ignored for the HMAC mode.
 *
 * The caller should allocate space for the `digest` buffer, (expected
 * length is 32 bytes for HMAC and `required_output_len`for KMAC), and
 * set the length of expected output in the `len` field of `digest`.
 * If the user-set length and the output length does not match, an
 * error message will be returned.
 *
 * @param key Pointer to the blinded key struct with key shares
 * @param input_message Input message to be hashed
 * @param mac_mode Required operation to be performed (HMAC/KMAC)
 * @param customization_string Customization string for KMAC
 * @param required_output_len Required output length from KMAC, in
 * bytes
 * @param digest Output digest after hashing the input data
 * @return The result of the KMAC128 operation
 */
crypto_status_t otcrypto_mac(const crypto_blinded_key_t *key,
                             crypto_const_uint8_buf_t input_message,
                             mac_mode_t mac_mode,
                             crypto_uint8_buf_t customization_string,
                             size_t required_output_len,
                             crypto_uint8_buf_t *digest);

/**
 * Performs the INIT operation for HMAC.
 *
 * Initializes the generic HMAC context. The required HMAC mode is
 * selected through the `hmac_mode` parameter. Populates the HMAC
 * context with the digest size, block size, HMAC update and HMAC
 * final APIs to be called based on the mode.
 *
 * The structure of HMAC context and how it populates the required
 * fields based on the HMAC mode are internal to the specific HMAC
 * implementation.
 *
 * The HMAC streaming API supports only the `kMacModeHmacSha256` mode.
 * Other modes are not supported and an error would be returned. The
 * interface is designed to be generic to support other required modes
 * in the future.
 *
 * @param ctx Pointer to the generic HMAC context struct
 * @param key Pointer to the blinded HMAC key struct
 * @param hmac_mode Required HMAC mode
 * @return Result of the HMAC init operation
 */
crypto_status_t otcrypto_hmac_init(hmac_context_t *ctx,
                                   const crypto_blinded_key_t *key,
                                   mac_mode_t hmac_mode);

/**
 * Performs the UPDATE operation for HMAC.
 *
 * The update operation processes the `input_message` using the selected
 * compression function. The intermediate digest is stored in the HMAC
 * context `ctx`. Any partial data is stored back in the context and
 * combined with the subsequent bytes.
 *
 * #otcrypto_hmac_init should be called before calling this function.
 *
 * @param ctx Pointer to the generic HMAC context struct
 * @param input_message Input message to be hashed
 * @return Result of the HMAC update operation
 */
crypto_status_t otcrypto_hmac_update(hmac_context_t *const ctx,
                                     crypto_const_uint8_buf_t input_message);

/**
 * Performs the FINAL operation for HMAC.
 *
 * The final operation processes the remaining partial blocks,
 * computes the final digest and copies it to the `digest` parameter.
 *
 * #otcrypto_hmac_update should be called before calling this function.
 *
 * The caller should allocate space for the `digest` buffer, (expected
 * length is 32 bytes for HMAC), and set the length of expected output
 * in the `len` field of `digest`. If the user-set length and the
 * output length does not match, an error message will be returned.
 *
 * @param ctx Pointer to the generic HMAC context struct
 * @param digest Output digest after hashing the input blocks
 * @return Result of the HMAC final operation
 */
crypto_status_t otcrypto_hmac_final(hmac_context_t *const ctx,
                                    crypto_uint8_buf_t *digest);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_LIB_CRYPTO_INCLUDE_MAC_H_
