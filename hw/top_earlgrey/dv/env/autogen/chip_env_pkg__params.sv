// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Generated by topgen.py

parameter string LIST_OF_ALERTS[] = {
  "gpio_fatal_fault",
  "spi_host0_fatal_fault",
  "spi_host1_fatal_fault",
  "pattgen_fatal_fault",
  "otp_ctrl_fatal_macro_error",
  "otp_ctrl_fatal_check_error",
  "lc_ctrl_fatal_prog_error",
  "lc_ctrl_fatal_state_error",
  "lc_ctrl_fatal_bus_integ_error",
  "sensor_ctrl_aon_recov_as",
  "sensor_ctrl_aon_recov_cg",
  "sensor_ctrl_aon_recov_gd",
  "sensor_ctrl_aon_recov_ts_hi",
  "sensor_ctrl_aon_recov_ts_lo",
  "sensor_ctrl_aon_recov_fla",
  "sensor_ctrl_aon_recov_otp",
  "sensor_ctrl_aon_recov_ot0",
  "sensor_ctrl_aon_recov_ot1",
  "sensor_ctrl_aon_recov_ot2",
  "sensor_ctrl_aon_recov_ot3",
  "sram_ctrl_ret_aon_fatal_intg_error",
  "sram_ctrl_ret_aon_fatal_parity_error",
  "flash_ctrl_recov_err",
  "flash_ctrl_recov_mp_err",
  "flash_ctrl_recov_ecc_err",
  "flash_ctrl_fatal_intg_err",
  "aes_recov_ctrl_update_err",
  "aes_fatal_fault",
  "hmac_fatal_fault",
  "kmac_fatal_fault",
  "keymgr_fatal_fault_err",
  "keymgr_recov_operation_err",
  "csrng_fatal_alert",
  "entropy_src_recov_alert",
  "entropy_src_fatal_alert",
  "edn0_fatal_alert",
  "edn1_fatal_alert",
  "sram_ctrl_main_fatal_intg_error",
  "sram_ctrl_main_fatal_parity_error",
  "otbn_fatal",
  "otbn_recov",
  "rom_ctrl_fatal"
};

parameter uint NUM_ALERTS = 42;
