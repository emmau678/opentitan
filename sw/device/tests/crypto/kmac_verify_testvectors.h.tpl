// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AUTOGENERATED. Do not edit this file by hand.
// See the crypto/tests README for details.

#ifndef OPENTITAN_SW_DEVICE_TESTS_CRYPTO_KMAC_TESTVECTORS_H_
#define OPENTITAN_SW_DEVICE_TESTS_CRYPTO_KMAC_TESTVECTORS_H_

#include "sw/device/lib/crypto/drivers/kmac.h"
#include "sw/device/lib/crypto/include/mac.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Use the following enum to route a test vector to XOF, HASH or MAC
 * call through cryptolib API.
 */
typedef enum kmac_test_operation_t {
  kKmacTestOperationXOF,
  kKmacTestOperationHASH,
  kKmacTestOperationMAC,
} kmac_test_operation_t;

// This struct allows us to neatly pack SHA-3/SHAKE/cSHAKE/KMAC vectors
typedef struct kmac_test_vector {
  char* vector_identifier;
  kmac_test_operation_t test_operation;
  xof_mode_t xof_mode;
  hash_mode_t hash_mode;
  kmac_mode_t mac_mode;
  crypto_blinded_key_t key;
  crypto_const_byte_buf_t input_msg;
  crypto_const_byte_buf_t func_name;
  crypto_const_byte_buf_t cust_str;
  crypto_const_byte_buf_t digest;
} kmac_test_vector_t;

static size_t nist_kmac_nr_of_vectors = ${len(tests)};

static kmac_test_vector_t nist_kmac_vectors[${len(tests)}] = {
% for idx, t in enumerate(tests):
    {
        .vector_identifier = "${t["vector_identifier"]}",
        .test_operation = ${t["test_operation"]},
  % if "xof_mode" in t:
        .xof_mode = ${t["xof_mode"]},
  % elif "hash_mode" in t:
        .hash_mode = ${t["hash_mode"]},
  % elif "mac_mode" in t:
        .mac_mode = ${t["mac_mode"]},
  % endif
  % if "key" in t:
        .key = {
            .config = {
                .key_mode = ${"kKeyModeKmac" + str(t["security_str"])},
                .key_length = ${t["key_len"]},
                .hw_backed = kHardenedBoolFalse,
            },
            .keyblob_length = ${4 * len(t["keyblob"])},
            .keyblob = (uint32_t[]){
      % for i in range(0, len(t["keyblob"]), 4):
                ${', '.join(t["keyblob"][i:i + 4])},
      % endfor
            },
        },
   % endif  
        .input_msg = {
  % if "input_msg" in t:
            .data = (uint8_t[]){
      % for i in range(0, len(t["input_msg"]), 8):
                ${', '.join(t["input_msg"][i:i + 8])},
      % endfor
            },
            .len = ${len(t["input_msg"])},
  % else:
            .data = NULL,
            .len = 0,
  % endif
        },
        .func_name = {
  % if "func_name" in t:
        .input_msg = {
            .data = (uint8_t[]){
      % for i in range(0, len(t["func_name"]), 8):
            ${', '.join(t["func_name"][i:i + 8])},
      % endfor
            },
            .len = ${len(t["func_name"])},
  % else:
            .data = NULL,
            .len = 0,        
  % endif
        },
        .cust_str = {
  % if "cust_str" in t:
            .data = (uint8_t[]){
      % for i in range(0, len(t["cust_str"]), 8):
                ${', '.join(t["cust_str"][i:i + 8])},
      % endfor
            },
            .len = ${len(t["cust_str"])},
  % else:
            .data = NULL,
            .len = 0,        
  % endif
        },
        .digest = {
            .data = (uint8_t[]){
      % for i in range(0, len(t["digest"]), 8):
                ${', '.join(t["digest"][i:i + 8])},
      % endfor
            },
            .len = ${len(t["digest"])},     
        },
    },
% endfor
};

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_TESTS_CRYPTO_KMAC_TESTVECTORS_H_
