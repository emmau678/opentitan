// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/dif/dif_entropy_src.h"

#include "gtest/gtest.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/base/mock_mmio.h"
#include "sw/device/lib/base/multibits.h"
#include "sw/device/lib/dif/dif_base.h"
#include "sw/device/lib/dif/dif_test_base.h"

#include "entropy_src_regs.h"  // Generated

namespace dif_entropy_src_unittest {
namespace {

class EntropySrcTest : public testing::Test, public mock_mmio::MmioTest {
 protected:
  const dif_entropy_src_t entropy_src_ = {.base_addr = dev().region()};
};

class ConfigTest : public EntropySrcTest {
 protected:
  dif_entropy_src_config_t config_ = {
      .fips_enable = false,
      .route_to_firmware = false,
      .single_bit_mode = kDifEntropySrcSingleBitModeDisabled,
  };
};

TEST_F(ConfigTest, NullHandle) {
  EXPECT_DIF_BADARG(
      dif_entropy_src_configure(nullptr, config_, kDifToggleEnabled));
}

TEST_F(ConfigTest, BadEnabled) {
  EXPECT_DIF_BADARG(dif_entropy_src_configure(&entropy_src_, config_,
                                              static_cast<dif_toggle_t>(2)));
}

TEST_F(ConfigTest, BadSingleBitMode) {
  config_.single_bit_mode = static_cast<dif_entropy_src_single_bit_mode_t>(5);
  EXPECT_DIF_BADARG(
      dif_entropy_src_configure(&entropy_src_, config_, kDifToggleEnabled));
}

struct ConfigParams {
  bool fips_enable;
  bool route_to_firmware;
  dif_entropy_src_single_bit_mode_t single_bit_mode;
  bool health_test_threshold_scope;
  uint16_t health_test_window_size;
  dif_toggle_t enabled;
};

class ConfigTestAllParams : public ConfigTest,
                            public testing::WithParamInterface<ConfigParams> {};

TEST_P(ConfigTestAllParams, ValidConfigurationMode) {
  const ConfigParams &test_param = GetParam();
  config_.fips_enable = test_param.fips_enable;
  config_.route_to_firmware = test_param.route_to_firmware;
  config_.single_bit_mode = test_param.single_bit_mode;
  config_.health_test_threshold_scope = test_param.health_test_threshold_scope;
  config_.health_test_window_size = test_param.health_test_window_size;

  multi_bit_bool_t route_to_firmware_mubi =
      test_param.route_to_firmware ? kMultiBitBool4True : kMultiBitBool4False;

  EXPECT_WRITE32(
      ENTROPY_SRC_ENTROPY_CONTROL_REG_OFFSET,
      {
          {ENTROPY_SRC_ENTROPY_CONTROL_ES_ROUTE_OFFSET, route_to_firmware_mubi},
          {ENTROPY_SRC_ENTROPY_CONTROL_ES_TYPE_OFFSET, kMultiBitBool4False},
      });

  multi_bit_bool_t fips_enable_mubi =
      test_param.fips_enable ? kMultiBitBool4True : kMultiBitBool4False;
  multi_bit_bool_t threshold_scope_mubi = test_param.health_test_threshold_scope
                                              ? kMultiBitBool4True
                                              : kMultiBitBool4False;
  multi_bit_bool_t rng_bit_enable_mubi =
      test_param.single_bit_mode == kDifEntropySrcSingleBitModeDisabled
          ? kMultiBitBool4False
          : kMultiBitBool4True;
  uint8_t rng_bit_sel =
      test_param.single_bit_mode == kDifEntropySrcSingleBitModeDisabled
          ? 0
          : test_param.single_bit_mode;

  EXPECT_WRITE32(
      ENTROPY_SRC_CONF_REG_OFFSET,
      {
          {ENTROPY_SRC_CONF_FIPS_ENABLE_OFFSET, fips_enable_mubi},
          {ENTROPY_SRC_CONF_ENTROPY_DATA_REG_ENABLE_OFFSET,
           route_to_firmware_mubi},
          {ENTROPY_SRC_CONF_THRESHOLD_SCOPE_OFFSET, threshold_scope_mubi},
          {ENTROPY_SRC_CONF_RNG_BIT_ENABLE_OFFSET, rng_bit_enable_mubi},
          {ENTROPY_SRC_CONF_RNG_BIT_SEL_OFFSET, rng_bit_sel},
      });

  if (config_.health_test_threshold_scope) {
    EXPECT_WRITE32(ENTROPY_SRC_HEALTH_TEST_WINDOWS_REG_OFFSET,
                   test_param.health_test_window_size);
  }

  EXPECT_WRITE32(ENTROPY_SRC_MODULE_ENABLE_REG_OFFSET,
                 {
                     {ENTROPY_SRC_MODULE_ENABLE_MODULE_ENABLE_OFFSET,
                      dif_toggle_to_multi_bit_bool4(test_param.enabled)},
                 });

  EXPECT_DIF_OK(
      dif_entropy_src_configure(&entropy_src_, config_, test_param.enabled));
}

INSTANTIATE_TEST_SUITE_P(
    ConfigTestAllParams, ConfigTestAllParams,
    testing::Values(
        // Test FIPS enabled.
        ConfigParams{true, false, kDifEntropySrcSingleBitModeDisabled, false,
                     0xFFFF, kDifToggleEnabled},
        // Test route to firmware.
        ConfigParams{false, true, kDifEntropySrcSingleBitModeDisabled, false,
                     kDifToggleEnabled},
        // Test single_bit_mode
        ConfigParams{false, false, kDifEntropySrcSingleBitMode0, false, 512,
                     kDifToggleEnabled},
        ConfigParams{false, false, kDifEntropySrcSingleBitMode1, false, 256,
                     kDifToggleEnabled},
        ConfigParams{false, false, kDifEntropySrcSingleBitMode2, false, 128,
                     kDifToggleEnabled},
        ConfigParams{false, false, kDifEntropySrcSingleBitMode3, false, 64,
                     kDifToggleEnabled},
        // Test all disabled.
        ConfigParams{false, false, kDifEntropySrcSingleBitMode0, false, 0,
                     kDifToggleDisabled},
        // Test all enabled.
        ConfigParams{true, true, kDifEntropySrcSingleBitMode0, true, 32,
                     kDifToggleEnabled}));

class FwOverrideConfigTest : public EntropySrcTest {
 protected:
  dif_entropy_src_fw_override_config_t config_ = {
      .entropy_insert_enable = true,
      .buffer_threshold = ENTROPY_SRC_OBSERVE_FIFO_THRESH_REG_RESVAL,
  };
};

TEST_F(FwOverrideConfigTest, NullHandle) {
  EXPECT_DIF_BADARG(dif_entropy_src_fw_override_configure(nullptr, config_,
                                                          kDifToggleEnabled));
}

TEST_F(FwOverrideConfigTest, BadBufferThreshold) {
  config_.buffer_threshold =
      ENTROPY_SRC_OBSERVE_FIFO_THRESH_OBSERVE_FIFO_THRESH_MASK + 1;
  EXPECT_DIF_BADARG(dif_entropy_src_fw_override_configure(
      &entropy_src_, config_, kDifToggleEnabled));

  config_.buffer_threshold = 0;
  EXPECT_DIF_BADARG(dif_entropy_src_fw_override_configure(
      &entropy_src_, config_, kDifToggleEnabled));
}

TEST_F(FwOverrideConfigTest, BadEnabled) {
  EXPECT_DIF_BADARG(dif_entropy_src_fw_override_configure(
      &entropy_src_, config_, static_cast<dif_toggle_t>(2)));
}

TEST_F(FwOverrideConfigTest, Success) {
  EXPECT_WRITE32(ENTROPY_SRC_OBSERVE_FIFO_THRESH_REG_OFFSET,
                 config_.buffer_threshold);
  EXPECT_WRITE32(ENTROPY_SRC_FW_OV_CONTROL_REG_OFFSET, 0x66);
  EXPECT_DIF_OK(dif_entropy_src_fw_override_configure(&entropy_src_, config_,
                                                      kDifToggleEnabled));

  EXPECT_WRITE32(ENTROPY_SRC_OBSERVE_FIFO_THRESH_REG_OFFSET,
                 config_.buffer_threshold);
  EXPECT_WRITE32(ENTROPY_SRC_FW_OV_CONTROL_REG_OFFSET, 0x69);
  EXPECT_DIF_OK(dif_entropy_src_fw_override_configure(&entropy_src_, config_,
                                                      kDifToggleDisabled));
}

class HealthTestConfigTest : public EntropySrcTest {
 protected:
  dif_entropy_src_health_test_config_t config_ = {
      .test_type = kDifEntropySrcTestRepetitionCount,
      .high_threshold = 0xFFFF,
      .low_threshold = 0,
  };
};

TEST_F(HealthTestConfigTest, NullHandle) {
  EXPECT_DIF_BADARG(dif_entropy_src_health_test_configure(nullptr, config_));
}

TEST_F(HealthTestConfigTest, BadTestType) {
  config_.test_type = kDifEntropySrcTestNumVariants;
  EXPECT_DIF_BADARG(
      dif_entropy_src_health_test_configure(&entropy_src_, config_));
}

TEST_F(HealthTestConfigTest, BadLowThreshold) {
  config_.low_threshold = 0x1;
  EXPECT_DIF_BADARG(
      dif_entropy_src_health_test_configure(&entropy_src_, config_));
}

TEST_F(HealthTestConfigTest, SuccessOneThreshold) {
  EXPECT_WRITE32(ENTROPY_SRC_REPCNT_THRESHOLDS_REG_OFFSET,
                 config_.high_threshold);
  EXPECT_DIF_OK(dif_entropy_src_health_test_configure(&entropy_src_, config_));
}

TEST_F(HealthTestConfigTest, SuccessTwoThresholds) {
  config_.test_type = kDifEntropySrcTestMarkov;
  config_.low_threshold = 0xABAB;
  EXPECT_WRITE32(ENTROPY_SRC_MARKOV_HI_THRESHOLDS_REG_OFFSET,
                 config_.high_threshold);
  EXPECT_WRITE32(ENTROPY_SRC_MARKOV_LO_THRESHOLDS_REG_OFFSET,
                 config_.low_threshold);
  EXPECT_DIF_OK(dif_entropy_src_health_test_configure(&entropy_src_, config_));
}

class HealthTestStatsGetTest : public EntropySrcTest {};

TEST_F(HealthTestStatsGetTest, NullArgs) {
  dif_entropy_src_health_test_stats_t stats;
  EXPECT_DIF_BADARG(dif_entropy_src_get_health_test_stats(nullptr, &stats));
  EXPECT_DIF_BADARG(
      dif_entropy_src_get_health_test_stats(&entropy_src_, nullptr));
  EXPECT_DIF_BADARG(dif_entropy_src_get_health_test_stats(nullptr, nullptr));
}

TEST_F(HealthTestStatsGetTest, Success) {
  dif_entropy_src_health_test_stats_t stats;

  EXPECT_READ32(ENTROPY_SRC_REPCNT_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_REPCNT_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_READ32(ENTROPY_SRC_REPCNTS_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_REPCNTS_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_READ32(ENTROPY_SRC_ADAPTP_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_ADAPTP_LO_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_ADAPTP_HI_TOTAL_FAILS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_ADAPTP_LO_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_READ32(ENTROPY_SRC_BUCKET_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_BUCKET_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_READ32(ENTROPY_SRC_MARKOV_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_MARKOV_LO_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_MARKOV_HI_TOTAL_FAILS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_MARKOV_LO_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_READ32(ENTROPY_SRC_EXTHT_HI_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_EXTHT_LO_WATERMARKS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_EXTHT_HI_TOTAL_FAILS_REG_OFFSET, 10);
  EXPECT_READ32(ENTROPY_SRC_EXTHT_LO_TOTAL_FAILS_REG_OFFSET, 10);

  EXPECT_DIF_OK(dif_entropy_src_get_health_test_stats(&entropy_src_, &stats));
  for (uint32_t i = 0; i < kDifEntropySrcTestNumVariants; ++i) {
    EXPECT_EQ(stats.high_watermark[i], 10);
    if (i == 2 || i == 4 || i == 5) {
      EXPECT_EQ(stats.low_watermark[i], 10);
    } else {
      EXPECT_EQ(stats.low_watermark[i], 0);
    }

    EXPECT_EQ(stats.high_fails[i], 10);
    if (i == 2 || i == 4 || i == 5) {
      EXPECT_EQ(stats.low_fails[i], 10);
    } else {
      EXPECT_EQ(stats.low_fails[i], 0);
    }
  }
}

class GetAlertFailCountsTest : public EntropySrcTest {};

TEST_F(GetAlertFailCountsTest, NullArgs) {
  dif_entropy_src_alert_fail_counts_t counts;
  EXPECT_DIF_BADARG(dif_entropy_src_get_alert_fail_counts(nullptr, &counts));
  EXPECT_DIF_BADARG(
      dif_entropy_src_get_alert_fail_counts(&entropy_src_, nullptr));
  EXPECT_DIF_BADARG(dif_entropy_src_get_alert_fail_counts(nullptr, nullptr));
}

TEST_F(GetAlertFailCountsTest, Success) {
  dif_entropy_src_alert_fail_counts_t counts;

  EXPECT_READ32(ENTROPY_SRC_ALERT_SUMMARY_FAIL_COUNTS_REG_OFFSET, 128);
  EXPECT_READ32(
      ENTROPY_SRC_ALERT_FAIL_COUNTS_REG_OFFSET,
      {{ENTROPY_SRC_ALERT_FAIL_COUNTS_REPCNT_FAIL_COUNT_OFFSET, 0xA},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_ADAPTP_HI_FAIL_COUNT_OFFSET, 0xC},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_ADAPTP_LO_FAIL_COUNT_OFFSET, 0xC},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_BUCKET_FAIL_COUNT_OFFSET, 0xD},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_MARKOV_HI_FAIL_COUNT_OFFSET, 0xE},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_MARKOV_LO_FAIL_COUNT_OFFSET, 0xE},
       {ENTROPY_SRC_ALERT_FAIL_COUNTS_REPCNTS_FAIL_COUNT_OFFSET, 0xB}});
  EXPECT_READ32(
      ENTROPY_SRC_EXTHT_FAIL_COUNTS_REG_OFFSET,
      {{ENTROPY_SRC_EXTHT_FAIL_COUNTS_EXTHT_HI_FAIL_COUNT_OFFSET, 0xF},
       {ENTROPY_SRC_EXTHT_FAIL_COUNTS_EXTHT_LO_FAIL_COUNT_OFFSET, 0xF}});
  EXPECT_DIF_OK(dif_entropy_src_get_alert_fail_counts(&entropy_src_, &counts));

  uint8_t num_fails = 0xA;
  for (uint32_t i = 0; i < kDifEntropySrcTestNumVariants; ++i) {
    EXPECT_EQ(counts.high_fails[i], num_fails);
    if (i == 2 || i == 4 || i == 5) {
      EXPECT_EQ(counts.low_fails[i], num_fails);
    } else {
      EXPECT_EQ(counts.low_fails[i], 0);
    }
    num_fails++;
  }
}

class ReadTest : public EntropySrcTest {};

TEST_F(ReadTest, EntropyBadArg) {
  uint32_t word;
  EXPECT_DIF_BADARG(dif_entropy_src_read(nullptr, &word));
}

TEST_F(ReadTest, WordBadArg) {
  EXPECT_DIF_BADARG(dif_entropy_src_read(&entropy_src_, nullptr));
}

TEST_F(ReadTest, ReadDataUnAvailable) {
  EXPECT_READ32(ENTROPY_SRC_INTR_STATE_REG_OFFSET, 0);
  uint32_t got_word;
  EXPECT_EQ(dif_entropy_src_read(&entropy_src_, &got_word), kDifUnavailable);
}

TEST_F(ReadTest, ReadOk) {
  const uint32_t expected_word = 0x65585497;
  EXPECT_READ32(ENTROPY_SRC_INTR_STATE_REG_OFFSET,
                1 << ENTROPY_SRC_INTR_STATE_ES_ENTROPY_VALID_BIT);
  EXPECT_READ32(ENTROPY_SRC_ENTROPY_DATA_REG_OFFSET, expected_word);
  EXPECT_READ32(ENTROPY_SRC_INTR_STATE_REG_OFFSET,
                1 << ENTROPY_SRC_INTR_STATE_ES_ENTROPY_VALID_BIT);
  EXPECT_WRITE32(ENTROPY_SRC_INTR_STATE_REG_OFFSET,
                 {{ENTROPY_SRC_INTR_STATE_ES_ENTROPY_VALID_BIT, true}});

  uint32_t got_word;
  EXPECT_DIF_OK(dif_entropy_src_read(&entropy_src_, &got_word));
  EXPECT_EQ(got_word, expected_word);
}

class ReadFifoDepthTest : public EntropySrcTest {};

TEST_F(ReadFifoDepthTest, EntropyBadArg) {
  uint32_t depth;
  EXPECT_DIF_BADARG(dif_entropy_src_get_fifo_depth(nullptr, &depth));
}

TEST_F(ReadFifoDepthTest, DepthBadArg) {
  EXPECT_DIF_BADARG(dif_entropy_src_get_fifo_depth(&entropy_src_, nullptr));
}

TEST_F(ReadFifoDepthTest, ReadSuccess) {
  EXPECT_READ32(ENTROPY_SRC_OBSERVE_FIFO_DEPTH_REG_OFFSET, 6);
  uint32_t depth;
  EXPECT_DIF_OK(dif_entropy_src_get_fifo_depth(&entropy_src_, &depth));
  EXPECT_EQ(depth, 6);
}

}  // namespace
}  // namespace dif_entropy_src_unittest
