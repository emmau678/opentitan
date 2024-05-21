// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/arch/boot_stage.h"
#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/dif_aes.h"
#include "sw/device/lib/dif/dif_keymgr.h"
#include "sw/device/lib/dif/dif_kmac.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/aes_testutils.h"
#include "sw/device/lib/testing/keymgr_testutils.h"
#include "sw/device/lib/testing/kmac_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "kmac_regs.h"  // Generated.

#define TIMEOUT (1000 * 1000)

// Plaintext 16B block matching that input `00112233445566778899aabbccddeeff` to
// the AES C model. Refer to `hw/ip/aes/rtl/aes_cipher_core.sv` for mapping
// plaintext input to the hardware input.
static const uint32_t kPlainText[] = {
    0x33221100,  // word 0.
    0x77665544,  // word 1.
    0xbbaa9988,  // word 2.
    0xffeeddcc,  // word 3.
};

// Expected AES cipher result will be computed at the SV side and overwritten to
// this constant.
static volatile const uint8_t kAESDigest[16] = {0};

static dif_keymgr_t keymgr;
static dif_kmac_t kmac;

OTTF_DEFINE_TEST_CONFIG();

/**
 * Initializes all DIF handles for each peripheral used in this test.
 */
static void init_peripheral_handles(void) {
  CHECK_DIF_OK(
      dif_kmac_init(mmio_region_from_addr(TOP_EARLGREY_KMAC_BASE_ADDR), &kmac));
  CHECK_DIF_OK(dif_keymgr_init(
      mmio_region_from_addr(TOP_EARLGREY_KEYMGR_BASE_ADDR), &keymgr));
}

static void keymgr_initialize_sim_dv(void) {
  // Initialize keymgr and advance to CreatorRootKey state.
  CHECK_STATUS_OK(keymgr_testutils_startup(&keymgr, &kmac));
  LOG_INFO("Keymgr entered CreatorRootKey State");
  // Generate identity at CreatorRootKey (to follow same sequence and reuse
  // chip_sw_keymgr_key_derivation_vseq.sv).
  CHECK_STATUS_OK(keymgr_testutils_generate_identity(&keymgr));
  LOG_INFO("Keymgr generated identity at CreatorRootKey State");

  // Advance to OwnerIntermediateKey state and check that the state is correct.
  // The sim_dv testbench expects this state.
  CHECK_STATUS_OK(keymgr_testutils_advance_state(&keymgr, &kOwnerIntParams));
  CHECK_STATUS_OK(keymgr_testutils_check_state(
      &keymgr, kDifKeymgrStateOwnerIntermediateKey));
  LOG_INFO("Keymgr entered OwnerIntKey State");
}

static void keymgr_initialize_sival(void) {
  dif_keymgr_state_t keymgr_state;
  CHECK_STATUS_OK(keymgr_testutils_try_startup(&keymgr, &kmac, &keymgr_state));

  if (keymgr_state == kDifKeymgrStateInitialized) {
    CHECK_STATUS_OK(keymgr_testutils_advance_state(&keymgr, &kOwnerIntParams));
    CHECK_DIF_OK(dif_keymgr_get_state(&keymgr, &keymgr_state));
  }

  if (keymgr_state == kDifKeymgrStateOwnerIntermediateKey) {
    CHECK_STATUS_OK(
        keymgr_testutils_advance_state(&keymgr, &kOwnerRootKeyParams));
  }

  CHECK_STATUS_OK(
      keymgr_testutils_check_state(&keymgr, kDifKeymgrStateOwnerRootKey));
}

static void keymgr_initialize(void) {
  if (kBootStage == kBootStageOwner) {
    keymgr_initialize_sival();
  } else {
    // All other configurations use the sim_dv initialization.
    keymgr_initialize_sim_dv();
  }
}

status_t aes_crypt(dif_aes_t aes, dif_aes_data_t in_data,
                   enum dif_aes_operation crypt_op, dif_aes_data_t *out_data) {
  // Setup ECB encryption/decryption transaction using sideload key.
  dif_aes_transaction_t transaction = {
      .operation = crypt_op,
      .mode = kDifAesModeEcb,
      .key_len = kDifAesKey256,
      .key_provider = kDifAesKeySideload,
      .mask_reseeding = kDifAesReseedPer64Block,
      .manual_operation = kDifAesManualOperationManual,
      .reseed_on_key_change = false,
      .ctrl_aux_lock = false,
  };

  if (crypt_op == kDifAesOperationEncrypt) {
    LOG_INFO("Encrypting with 256-bit AES sideload key in ECB mode.");
  } else if (crypt_op == kDifAesOperationDecrypt) {
    LOG_INFO("Decrypting with 256-bit AES sideload key in ECB mode.");
  }

  CHECK_DIF_OK(dif_aes_start(&aes, &transaction, NULL, NULL));
  AES_TESTUTILS_WAIT_FOR_STATUS(&aes, kDifAesStatusInputReady, true, TIMEOUT);
  CHECK_DIF_OK(dif_aes_load_data(&aes, in_data));

  // Trigger the AES encryption and wait for it to complete.
  CHECK_DIF_OK(dif_aes_trigger(&aes, kDifAesTriggerStart));
  AES_TESTUTILS_WAIT_FOR_STATUS(&aes, kDifAesStatusOutputValid, true, TIMEOUT);

  CHECK_DIF_OK(dif_aes_read_output(&aes, out_data));

  // Finish the ECB encryption or decryption transaction.
  LOG_INFO("Finished operation with AES sideloaded key.");
  CHECK_DIF_OK(dif_aes_end(&aes));
  return OK_STATUS();
}

void aes_test(void) {
  // Generate sideload key for AES interface at current keymgr state.
  dif_keymgr_versioned_key_params_t sideload_params = kKeyVersionedParams;
  sideload_params.dest = kDifKeymgrVersionedKeyDestAes;

  // Get the maximum key version supported by the keymgr in its current state.
  uint32_t max_key_version;
  CHECK_STATUS_OK(
      keymgr_testutils_max_key_version_get(&keymgr, &max_key_version));

  if (sideload_params.version > max_key_version) {
    LOG_INFO("Key version %d is greater than the maximum key version %d",
             sideload_params.version, max_key_version);
    LOG_INFO("Setting key version to the maximum key version %d",
             max_key_version);
    sideload_params.version = max_key_version;
  }

  const char *state_name;
  CHECK_STATUS_OK(keymgr_testutils_state_string_get(&keymgr, &state_name));

  CHECK_STATUS_OK(
      keymgr_testutils_generate_versioned_key(&keymgr, sideload_params));
  LOG_INFO("Keymgr generated HW output for Aes at %s State", state_name);

  // Initialize AES.
  dif_aes_t aes;
  CHECK_DIF_OK(
      dif_aes_init(mmio_region_from_addr(TOP_EARLGREY_AES_BASE_ADDR), &aes));
  CHECK_DIF_OK(dif_aes_reset(&aes));

  dif_aes_data_t in_data_plain;
  dif_aes_data_t out_data_cipher;
  memcpy(in_data_plain.data, kPlainText, sizeof(kPlainText));

  // Encrypt using sideload key.
  CHECK_STATUS_OK(
      aes_crypt(aes, in_data_plain, kDifAesOperationEncrypt, &out_data_cipher));
  // Verify that the ciphertext is different from the plaintext.
  CHECK_ARRAYS_NE(out_data_cipher.data, kPlainText, ARRAYSIZE(kPlainText));

  // Only if running test in DV simulation: compare ciphertext generated
  // with the HW core vs. that generated by the reference C model.
  if (kDeviceType == kDeviceSimDV) {
    LOG_INFO("AES Plaintext (HW Core): 0x%08x%08x%08x%08x",
             in_data_plain.data[0], in_data_plain.data[1],
             in_data_plain.data[2], in_data_plain.data[3]);
    LOG_INFO("AES Ciphertext (HW Core): 0x%08x%08x%08x%08x",
             out_data_cipher.data[3], out_data_cipher.data[2],
             out_data_cipher.data[1], out_data_cipher.data[0]);
    LOG_INFO(
        "AES Expected Ciphertext (from C model): "
        "0x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
        kAESDigest[15], kAESDigest[14], kAESDigest[13], kAESDigest[12],
        kAESDigest[11], kAESDigest[10], kAESDigest[9], kAESDigest[8],
        kAESDigest[7], kAESDigest[6], kAESDigest[5], kAESDigest[4],
        kAESDigest[3], kAESDigest[2], kAESDigest[1], kAESDigest[0]);
    CHECK_ARRAYS_EQ(out_data_cipher.data, (uint32_t *)kAESDigest,
                    ARRAYSIZE(out_data_cipher.data));
  }

  // Decrypt using sideload key.
  dif_aes_data_t out_data_plain;
  CHECK_STATUS_OK(aes_crypt(aes, out_data_cipher, kDifAesOperationDecrypt,
                            &out_data_plain));
  CHECK_ARRAYS_EQ(out_data_plain.data, kPlainText, ARRAYSIZE(kPlainText));

  // Clear the key in the keymgr and decrypt the ciphertext again.
  LOG_INFO("Clearing the sideloaded key.");
  CHECK_DIF_OK(
      dif_keymgr_sideload_clear_set_enabled(&keymgr, kDifToggleEnabled));

  // Disable "clear the key" toggle, so that the sideload key port is stable.
  // Otherwise, the sideload port is continuously overwritten by fresh
  // randomness every clock cycle.
  CHECK_DIF_OK(
      dif_keymgr_sideload_clear_set_enabled(&keymgr, kDifToggleDisabled));

  // Decrypt again after clearing the sideload key and verify that output is not
  // the same as previous.
  CHECK_STATUS_OK(aes_crypt(aes, out_data_cipher, kDifAesOperationDecrypt,
                            &out_data_plain));
  CHECK_ARRAYS_NE(out_data_plain.data, kPlainText, ARRAYSIZE(kPlainText));

  // Generate the same key again and check that encryption result is identical
  // as the first.
  CHECK_STATUS_OK(
      keymgr_testutils_generate_versioned_key(&keymgr, sideload_params));
  LOG_INFO("Keymgr generated HW output for Aes at %s State", state_name);

  dif_aes_data_t out_data_second_cipher;
  CHECK_STATUS_OK(aes_crypt(aes, in_data_plain, kDifAesOperationEncrypt,
                            &out_data_second_cipher));

  //  Verify that the ciphertext is identical to the first one generated.
  CHECK_ARRAYS_EQ(out_data_cipher.data, out_data_second_cipher.data,
                  ARRAYSIZE(out_data_cipher.data));
}

bool test_main(void) {
  init_peripheral_handles();

  // Configure the keymgr to generate an AES key.
  keymgr_initialize();

  // Run the AES test.
  aes_test();

  return true;
}
