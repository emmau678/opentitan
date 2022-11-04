// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Generated UNR file from Synopsys UNR tool with security modules being
// black-boxed.

//==================================================
// This file contains the Excluded objects
// Generated By User: maturana
// Format Version: 2
// Date: Fri Nov  4 23:44:29 2022
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
CHECKSUM: "888503091 3304441462"
INSTANCE: tb.dut.u_reg.u_io_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "888503091 3304441462"
INSTANCE: tb.dut.u_reg.u_io_div2_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "888503091 3304441462"
INSTANCE: tb.dut.u_reg.u_io_div4_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "888503091 3304441462"
INSTANCE: tb.dut.u_reg.u_main_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
CHECKSUM: "888503091 3304441462"
INSTANCE: tb.dut.u_reg.u_usb_meas_ctrl_en_cdc.u_arb
ANNOTATION: "VC_COV_UNR"
Condition 5 "593451913" "(((!gen_wr_req.dst_req)) && gen_wr_req.dst_lat_d) 1 -1" (1 "01")
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
