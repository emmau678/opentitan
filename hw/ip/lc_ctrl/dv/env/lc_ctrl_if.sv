// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// interface for input data from OTP
interface lc_ctrl_if(input clk, input rst_n);

  import lc_ctrl_pkg::*;
  import otp_ctrl_pkg::*;
  import otp_ctrl_part_pkg::*;

  otp_ctrl_pkg::otp_lc_data_t     otp_i;
  otp_ctrl_part_pkg::otp_hw_cfg_t otp_hw_cfg_i;

  lc_ctrl_pkg::lc_tx_t lc_dft_en_o;
  lc_ctrl_pkg::lc_tx_t lc_nvm_debug_en_o;
  lc_ctrl_pkg::lc_tx_t lc_hw_debug_en_o;
  lc_ctrl_pkg::lc_tx_t lc_cpu_en_o;
  lc_ctrl_pkg::lc_tx_t lc_creator_seed_sw_rw_en_o;
  lc_ctrl_pkg::lc_tx_t lc_owner_seed_sw_rw_en_o;
  lc_ctrl_pkg::lc_tx_t lc_iso_part_sw_rd_en_o;
  lc_ctrl_pkg::lc_tx_t lc_iso_part_sw_wr_en_o;
  lc_ctrl_pkg::lc_tx_t lc_seed_hw_rd_en_o;
  lc_ctrl_pkg::lc_tx_t lc_keymgr_en_o;
  lc_ctrl_pkg::lc_tx_t lc_escalate_en_o;

  lc_ctrl_pkg::lc_keymgr_div_t lc_keymgr_div_o;

  task automatic init(lc_ctrl_pkg::lc_state_e lc_state = LcStRaw,
                      lc_ctrl_pkg::lc_cnt_e   lc_cnt = LcCntRaw);
    otp_i.valid = 1;
    otp_i.state = lc_state;
    otp_i.count = lc_cnt;
    otp_i.all_zero_token = 0;
    otp_i.raw_unlock_token = 0;
    otp_i.test_unlock_token = 0;
    otp_i.test_exit_token = 0;
    otp_i.rma_token = 0;
    otp_i.id_state = LcIdBlank;

    otp_hw_cfg_i.valid = lc_ctrl_pkg::Off;
    otp_hw_cfg_i.data = 0;
  endtask

endinterface
