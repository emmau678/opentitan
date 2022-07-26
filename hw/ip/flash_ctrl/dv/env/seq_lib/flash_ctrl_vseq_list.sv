// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "flash_ctrl_callback_vseq.sv"
`include "flash_ctrl_base_vseq.sv"
`include "flash_ctrl_common_vseq.sv"
`include "flash_ctrl_rand_ops_base_vseq.sv"
`include "flash_ctrl_smoke_vseq.sv"
`include "flash_ctrl_smoke_hw_vseq.sv"
`include "flash_ctrl_rand_ops_vseq.sv"
`include "flash_ctrl_sw_op_vseq.sv"
`include "flash_ctrl_host_dir_rd_vseq.sv"
`include "flash_ctrl_rd_buff_evict_vseq.sv"
`include "flash_ctrl_phy_arb_vseq.sv"
`include "flash_ctrl_hw_sec_otp_vseq.sv"
`include "flash_ctrl_erase_suspend_vseq.sv"
`include "flash_ctrl_hw_rma_vseq.sv"
`include "flash_ctrl_host_ctrl_arb_vseq.sv"
`include "flash_ctrl_mp_regions_vseq.sv"
`include "flash_ctrl_fetch_code_vseq.sv"
`include "flash_ctrl_full_mem_access_vseq.sv"
`include "flash_ctrl_error_prog_type_vseq.sv"
`include "flash_ctrl_error_prog_win_vseq.sv"
`include "flash_ctrl_error_mp_vseq.sv"
`include "flash_ctrl_invalid_op_vseq.sv"
`include "flash_ctrl_mid_op_rst_vseq.sv"
`include "flash_ctrl_stress_all_vseq.sv"
`include "flash_ctrl_otf_base_vseq.sv"
`include "flash_ctrl_wo_vseq.sv"
`include "flash_ctrl_ro_vseq.sv"
`include "flash_ctrl_rw_vseq.sv"
`include "flash_ctrl_write_word_sweep_vseq.sv"
`include "flash_ctrl_write_rnd_wd_vseq.sv"
`include "flash_ctrl_read_word_sweep_vseq.sv"
`include "flash_ctrl_read_rnd_wd_vseq.sv"
`include "flash_ctrl_rw_rnd_wd_vseq.sv"
`include "flash_ctrl_serr_counter_vseq.sv"
`include "flash_ctrl_serr_address_vseq.sv"
`include "flash_ctrl_derr_detect_vseq.sv"
`include "flash_ctrl_hw_rma_reset_vseq.sv"
`include "flash_ctrl_otp_reset_vseq.sv"
