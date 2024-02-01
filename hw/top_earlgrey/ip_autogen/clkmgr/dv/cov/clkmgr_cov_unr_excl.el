// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Generated UNR file from Synopsys UNR tool with security modules being
// black-boxed.

//==================================================
// This file contains the Excluded objects
// Generated By User: maturana
// Format Version: 2
// Date: Wed Jan 18 15:59:24 2023
// ExclMode: default
//==================================================
CHECKSUM: "2972535896 3274445021"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_aes_val
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "2972535896 3274445021"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_hmac_val
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "2972535896 3274445021"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_kmac_val
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "2972535896 3274445021"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_otbn_val
ANNOTATION: "VC_COV_UNR"
Condition 1 "2397158838" "(wr_en ? wr_data : qs) 1 -1" (1 "0")
CHECKSUM: "2972535896 3554514034"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_aes_val
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "2972535896 3554514034"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_hmac_val
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "2972535896 3554514034"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_kmac_val
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "2972535896 3554514034"
INSTANCE: tb.dut.u_reg.u_clk_hints_status_clk_main_otbn_val
ANNOTATION: "VC_COV_UNR"
Branch 0 "3759852512" "wr_en" (1) "wr_en 0"
ANNOTATION: "VC_COV_UNR"
Branch 1 "1017474648" "(!rst_ni)" (2) "(!rst_ni) 0,0"
CHECKSUM: "215202837 3193272610"
INSTANCE: tb.dut.u_io_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk
ANNOTATION: "VC_COV_UNR"
Branch 0 "3003057152" "(!rst_ni)" (4) "(!rst_ni) 0,0,0,0"
CHECKSUM: "215202837 3193272610"
INSTANCE: tb.dut.u_io_div2_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk
ANNOTATION: "VC_COV_UNR"
Branch 0 "3003057152" "(!rst_ni)" (4) "(!rst_ni) 0,0,0,0"
CHECKSUM: "215202837 3193272610"
INSTANCE: tb.dut.u_io_div4_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk
ANNOTATION: "VC_COV_UNR"
Branch 0 "3003057152" "(!rst_ni)" (4) "(!rst_ni) 0,0,0,0"
CHECKSUM: "215202837 3193272610"
INSTANCE: tb.dut.u_main_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk
ANNOTATION: "VC_COV_UNR"
Branch 0 "3003057152" "(!rst_ni)" (4) "(!rst_ni) 0,0,0,0"
CHECKSUM: "215202837 3193272610"
INSTANCE: tb.dut.u_usb_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk
ANNOTATION: "VC_COV_UNR"
Branch 0 "3003057152" "(!rst_ni)" (4) "(!rst_ni) 0,0,0,0"
CHECKSUM: "2970503351 1213720317"
INSTANCE: tb.dut.u_reg
ANNOTATION: "VC_COV_UNR"
Condition 53 "2949805610" "(io_io_meas_ctrl_en_we & io_io_meas_ctrl_en_regwen) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 55 "3453311186" "(io_div2_io_div2_meas_ctrl_en_we & io_div2_io_div2_meas_ctrl_en_regwen) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 57 "3988383834" "(io_div4_io_div4_meas_ctrl_en_we & io_div4_io_div4_meas_ctrl_en_regwen) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 59 "1995093715" "(main_main_meas_ctrl_en_we & main_main_meas_ctrl_en_regwen) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 61 "2462107587" "(usb_usb_meas_ctrl_en_we & usb_usb_meas_ctrl_en_regwen) 1 -1" (1 "01")
CHECKSUM: "74367784 3785313510"
INSTANCE: tb.dut.u_reg.u_reg_if
ANNOTATION: "VC_COV_UNR"
Condition 18 "3340270436" "(addr_align_err | malformed_meta_err | tl_err | instr_error | intg_error) 1 -1" (5 "01000")
CHECKSUM: "2928260248 4109606122"
INSTANCE: tb.dut.u_reg.u_io_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "2928260248 4109606122"
INSTANCE: tb.dut.u_reg.u_io_div2_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "2928260248 4109606122"
INSTANCE: tb.dut.u_reg.u_io_div4_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "2928260248 4109606122"
INSTANCE: tb.dut.u_reg.u_main_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "2928260248 4109606122"
INSTANCE: tb.dut.u_reg.u_usb_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_reg.u_io_meas_ctrl_en_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_reg.u_io_div2_meas_ctrl_en_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_reg.u_io_div4_meas_ctrl_en_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_reg.u_main_meas_ctrl_en_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_reg.u_usb_meas_ctrl_en_cdc.u_arb.gen_wr_req.u_dst_update_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk.u_ref_timeout
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_meas.u_err_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_div2_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk.u_ref_timeout
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_div2_meas.u_err_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_div4_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk.u_ref_timeout
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_io_div4_meas.u_err_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_main_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk.u_ref_timeout
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_main_meas.u_err_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_usb_meas.u_meas.gen_clk_timeout_chk.u_timeout_ref_to_clk.u_ref_timeout
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_usb_meas.u_err_sync
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 2 "700807773" "(dst_req_o & dst_ack_i) 1 -1" (2 "10")
