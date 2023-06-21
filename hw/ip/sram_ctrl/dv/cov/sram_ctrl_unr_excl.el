// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//==================================================
// This file contains the Excluded objects
// Generated By User: root
// Format Version: 2
// Date: Tue Jun 20 19:02:19 2023
// ExclMode: default
//==================================================
CHECKSUM: "2736927696 2852341788"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte.gen_integ_handling.u_sync_fifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Block 12 "398307645" "wptr_o <= (wptr_o + {{(Width - 1) {1'b0}}, 1'b1});"
ANNOTATION: "VC_COV_UNR"
Block 21 "2517571270" "rptr_o <= (rptr_o + {{(Width - 1) {1'b0}}, 1'b1});"
CHECKSUM: "4263908928 1069164873"
INSTANCE: tb.dut.u_prim_ram_1p_scr
ANNOTATION: "VC_COV_UNR"
Block 23 "264295034" "rdata_o[k] = rdata[k];"
CHECKSUM: "4224194069 2881513198"
INSTANCE: tb.dut.u_tlul_lc_gate
ANNOTATION: "VC_COV_UNR"
Block 25 "1494489313" "block_cmd = 1'b1;"
ANNOTATION: "VC_COV_UNR"
Block 26 "2660541555" "state_d = StError;"
ANNOTATION: "VC_COV_UNR"
Block 27 "4271836668" "if ((!flush_req_i))"
ANNOTATION: "VC_COV_UNR"
Block 28 "1563566888" "state_d = StActive;"
ANNOTATION: "VC_COV_UNR"
Block 36 "3828992405" "err_o = 1'b1;"
CHECKSUM: "2574923469 1685788927"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte
ANNOTATION: "VC_COV_UNR"
Block 25 "520728696" ";"
CHECKSUM: "4224194069 4098474623"
INSTANCE: tb.dut.u_tlul_lc_gate
Fsm state_q "3443824386"
ANNOTATION: "VC_COV_UNR"
State StFlush "76"
CHECKSUM: "74367784 3785313510"
INSTANCE: tb.dut.u_reg_regs.u_reg_if
ANNOTATION: "VC_COV_UNR"
Condition 18 "3340270436" "(addr_align_err | malformed_meta_err | tl_err | instr_error | intg_error) 1 -1" (5 "01000")
CHECKSUM: "1335069400 4206106139"
INSTANCE: tb.dut.u_tlul_adapter_sram
ANNOTATION: "VC_COV_UNR"
Condition 12 "1155425989" "(wr_attr_error | wr_vld_error | rd_vld_error | instr_error | tlul_error | intg_error) 1 -1" (7 "100000")
ANNOTATION: "VC_COV_UNR"
Condition 15 "3623514242" "(req_o & gnt_i) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 16 "1378572318" "(d_valid & reqfifo_rvalid & rspfifo_rvalid & (reqfifo_rdata.op == OpRead)) 1 -1" (1 "0111")
ANNOTATION: "VC_COV_UNR"
Condition 16 "1378572318" "(d_valid & reqfifo_rvalid & rspfifo_rvalid & (reqfifo_rdata.op == OpRead)) 1 -1" (2 "1011")
ANNOTATION: "VC_COV_UNR"
Condition 28 "1798941048" "(d_valid && d_error) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 37 "927800449" "(rvalid_i & reqfifo_rvalid) 1 -1" (2 "10")
CHECKSUM: "2574923469 2212102968"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte
ANNOTATION: "VC_COV_UNR"
Condition 6 "2868221468" "(tl_i.a_valid & ((~gen_integ_handling.stall_host))) 1 -1" (1 "01")
ANNOTATION: "VC_COV_UNR"
Condition 7 "925049118" "(tl_sram_i.a_ready & ((~gen_integ_handling.stall_host)) & gen_integ_handling.fifo_rdy & gen_integ_handling.size_fifo_rdy) 1 -1" (2 "1011")
ANNOTATION: "VC_COV_UNR"
Condition 7 "925049118" "(tl_sram_i.a_ready & ((~gen_integ_handling.stall_host)) & gen_integ_handling.fifo_rdy & gen_integ_handling.size_fifo_rdy) 1 -1" (3 "1101")
ANNOTATION: "VC_COV_UNR"
Condition 7 "925049118" "(tl_sram_i.a_ready & ((~gen_integ_handling.stall_host)) & gen_integ_handling.fifo_rdy & gen_integ_handling.size_fifo_rdy) 1 -1" (4 "1110")
CHECKSUM: "835220981 4098890454"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_reqfifo
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 7 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
CHECKSUM: "835220981 1390693035"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_rspfifo
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
CHECKSUM: "835220981 3043678275"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte.gen_integ_handling.u_sync_fifo_a_size
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 7 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
CHECKSUM: "835220981 2760258094"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte.gen_integ_handling.u_sync_fifo
ANNOTATION: "VC_COV_UNR"
Condition 2 "4002946372" "((gen_normal_fifo.wptr_msb == gen_normal_fifo.rptr_msb) ? ((1'(gen_normal_fifo.wptr_value) - 1'(gen_normal_fifo.rptr_value))) : (((1'(Depth) - 1'(gen_normal_fifo.rptr_value)) + 1'(gen_normal_fifo.wptr_value)))) 1 -1" (1 "0")
ANNOTATION: "VC_COV_UNR"
Condition 3 "1926118060" "(gen_normal_fifo.wptr_msb == gen_normal_fifo.rptr_msb) 1 -1" (1 "0")
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 7 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
CHECKSUM: "835220981 869192578"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sramreqfifo
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "VC_COV_UNR"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "011")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (3 "110")
ANNOTATION: "VC_COV_UNR"
Condition 7 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")
CHECKSUM: "4224194069 3219254590"
INSTANCE: tb.dut.u_tlul_lc_gate
ANNOTATION: "VC_COV_UNR"
Branch 2 "1850090820" "state_q" (6) "state_q StFlush ,-,-,-,1,-,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 2 "1850090820" "state_q" (7) "state_q StFlush ,-,-,-,0,1,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 2 "1850090820" "state_q" (8) "state_q StFlush ,-,-,-,0,0,-,-"
ANNOTATION: "VC_COV_UNR"
Branch 2 "1850090820" "state_q" (13) "state_q default,-,-,-,-,-,-,-"
CHECKSUM: "2574923469 3226983296"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte
ANNOTATION: "VC_COV_UNR"
Branch 1 "4121297012" "gen_integ_handling.state_q" (8) "gen_integ_handling.state_q default,-,-,-,-,-"
CHECKSUM: "835220981 2124237550"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte.gen_integ_handling.u_sync_fifo
ANNOTATION: "VC_COV_UNR"
Branch 0 "1862733684" "gen_normal_fifo.full" (2) "gen_normal_fifo.full 0,0"
CHECKSUM: "2736927696 689627449"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte.gen_integ_handling.u_sync_fifo.gen_normal_fifo.u_fifo_cnt
ANNOTATION: "VC_COV_UNR"
Branch 0 "353148737" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
ANNOTATION: "VC_COV_UNR"
Branch 1 "3145009581" "(!rst_ni)" (3) "(!rst_ni) 0,0,0,1"
