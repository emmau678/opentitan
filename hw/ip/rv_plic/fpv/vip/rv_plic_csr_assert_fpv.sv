// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// FPV CSR read and write assertions auto-generated by `reggen` containing data structure
// Do Not Edit directly


// Block: rv_plic
module rv_plic_csr_assert_fpv import tlul_pkg::*; (
  input clk_i,
  input rst_ni,

  //tile link ports
  input tl_h2d_t h2d,
  input tl_d2h_t d2h
);

  // mask register to convert byte to bit
  logic [31:0] a_mask_bit;

  assign a_mask_bit[7:0]   = h2d.a_mask[0] ? '1 : '0;
  assign a_mask_bit[15:8]  = h2d.a_mask[1] ? '1 : '0;
  assign a_mask_bit[23:16] = h2d.a_mask[2] ? '1 : '0;
  assign a_mask_bit[31:24] = h2d.a_mask[3] ? '1 : '0;

  // declare common read and write sequences
  sequence device_wr_S(logic [8:0] addr);
    h2d.a_address == addr && h2d.a_opcode inside {PutFullData, PutPartialData} && h2d.a_valid && h2d.d_ready && !d2h.d_valid;
  endsequence

  sequence device_rd_S(logic [8:0] addr);
    h2d.a_address == addr && h2d.a_opcode inside {Get} && h2d.a_valid && h2d.d_ready && !d2h.d_valid;
  endsequence

  // declare common read and write properties
  property wr_P(int width, bit [8:0] addr, bit [31:0] compare_data, bit regen = 1);
    logic [31:0] id;
    logic [width:0] data;
    (device_wr_S(addr),id = h2d.a_source, data = h2d.a_data & a_mask_bit) |->
        strong(##[1:$] (d2h.d_valid && d2h.d_source == id && (d2h.d_error ||
        (!d2h.d_error && compare_data == data) || !regen)));
  endproperty

  property wr_ext_P(int width, bit [8:0] addr, bit [31:0] compare_data, bit regen = 1);
    logic [31:0] id;
    logic [width:0] data;
    logic [width:0] compare_value;
    (device_wr_S(addr),id = h2d.a_source, data = h2d.a_data & a_mask_bit,
        compare_value = compare_data) |->
        strong(##[1:$] (d2h.d_valid && d2h.d_source == id && (d2h.d_error ||
        (!d2h.d_error && compare_value == data) || !regen)));
  endproperty

  property rd_P(int width, bit [8:0] addr, bit [31:0] compare_data);
    logic [31:0] id;
    logic [width:0] data;
    (device_rd_S(addr), id = h2d.a_source, data = $past(compare_data)) |->
        strong(##[1:$] (d2h.d_valid && d2h.d_source == id && (d2h.d_error ||
        (!d2h.d_error && d2h.d_data == data))));
  endproperty

  property rd_ext_P(int width, bit [8:0] addr, bit [31:0] compare_data);
    logic [31:0] id;
    logic [width:0] data;
    (device_rd_S(addr), id = h2d.a_source, data = compare_data) |->
        strong(##[1:$] (d2h.d_valid && d2h.d_source == id && (d2h.d_error ||
        (!d2h.d_error && d2h.d_data == data))));
  endproperty

  property wr_regen_stable_P(regen, compare_data);
    (!regen && $stable(regen)) |-> $stable(compare_data);
  endproperty

// for all the regsters, declare assertion

  // define local fpv variable for the multi_reg
  logic [31:0] ip_d_fpv;
  for (genvar s = 0; s <= 31; s++) begin : gen_ip_wr
    assign ip_d_fpv[s] = i_rv_plic.hw2reg.ip[s].d;
  end

  // read/write assertions for register: ip
  `ASSERT(ip_rd_A, rd_P(31, 9'h0, ip_d_fpv[31:0]), clk_i, !rst_ni)

  // define local fpv variable for the multi_reg
  logic [31:0] le_q_fpv;
  for (genvar s = 0; s <= 31; s++) begin : gen_le_rd
    assign le_q_fpv[s] = i_rv_plic.reg2hw.le[s].q;
  end

  // read/write assertions for register: le
  `ASSERT(le_wr_A, wr_P(31, 9'h4, le_q_fpv[31:0], 0), clk_i, !rst_ni)
  `ASSERT(le_rd_A, rd_P(31, 9'h4, le_q_fpv[31:0]), clk_i, !rst_ni)

  // read/write assertions for register: prio0
  `ASSERT(prio0_wr_A, wr_P(2, 9'h8, i_rv_plic.reg2hw.prio0.q, 0), clk_i, !rst_ni)
  `ASSERT(prio0_rd_A, rd_P(2, 9'h8, i_rv_plic.reg2hw.prio0.q), clk_i, !rst_ni)

  // read/write assertions for register: prio1
  `ASSERT(prio1_wr_A, wr_P(2, 9'hc, i_rv_plic.reg2hw.prio1.q, 0), clk_i, !rst_ni)
  `ASSERT(prio1_rd_A, rd_P(2, 9'hc, i_rv_plic.reg2hw.prio1.q), clk_i, !rst_ni)

  // read/write assertions for register: prio2
  `ASSERT(prio2_wr_A, wr_P(2, 9'h10, i_rv_plic.reg2hw.prio2.q, 0), clk_i, !rst_ni)
  `ASSERT(prio2_rd_A, rd_P(2, 9'h10, i_rv_plic.reg2hw.prio2.q), clk_i, !rst_ni)

  // read/write assertions for register: prio3
  `ASSERT(prio3_wr_A, wr_P(2, 9'h14, i_rv_plic.reg2hw.prio3.q, 0), clk_i, !rst_ni)
  `ASSERT(prio3_rd_A, rd_P(2, 9'h14, i_rv_plic.reg2hw.prio3.q), clk_i, !rst_ni)

  // read/write assertions for register: prio4
  `ASSERT(prio4_wr_A, wr_P(2, 9'h18, i_rv_plic.reg2hw.prio4.q, 0), clk_i, !rst_ni)
  `ASSERT(prio4_rd_A, rd_P(2, 9'h18, i_rv_plic.reg2hw.prio4.q), clk_i, !rst_ni)

  // read/write assertions for register: prio5
  `ASSERT(prio5_wr_A, wr_P(2, 9'h1c, i_rv_plic.reg2hw.prio5.q, 0), clk_i, !rst_ni)
  `ASSERT(prio5_rd_A, rd_P(2, 9'h1c, i_rv_plic.reg2hw.prio5.q), clk_i, !rst_ni)

  // read/write assertions for register: prio6
  `ASSERT(prio6_wr_A, wr_P(2, 9'h20, i_rv_plic.reg2hw.prio6.q, 0), clk_i, !rst_ni)
  `ASSERT(prio6_rd_A, rd_P(2, 9'h20, i_rv_plic.reg2hw.prio6.q), clk_i, !rst_ni)

  // read/write assertions for register: prio7
  `ASSERT(prio7_wr_A, wr_P(2, 9'h24, i_rv_plic.reg2hw.prio7.q, 0), clk_i, !rst_ni)
  `ASSERT(prio7_rd_A, rd_P(2, 9'h24, i_rv_plic.reg2hw.prio7.q), clk_i, !rst_ni)

  // read/write assertions for register: prio8
  `ASSERT(prio8_wr_A, wr_P(2, 9'h28, i_rv_plic.reg2hw.prio8.q, 0), clk_i, !rst_ni)
  `ASSERT(prio8_rd_A, rd_P(2, 9'h28, i_rv_plic.reg2hw.prio8.q), clk_i, !rst_ni)

  // read/write assertions for register: prio9
  `ASSERT(prio9_wr_A, wr_P(2, 9'h2c, i_rv_plic.reg2hw.prio9.q, 0), clk_i, !rst_ni)
  `ASSERT(prio9_rd_A, rd_P(2, 9'h2c, i_rv_plic.reg2hw.prio9.q), clk_i, !rst_ni)

  // read/write assertions for register: prio10
  `ASSERT(prio10_wr_A, wr_P(2, 9'h30, i_rv_plic.reg2hw.prio10.q, 0), clk_i, !rst_ni)
  `ASSERT(prio10_rd_A, rd_P(2, 9'h30, i_rv_plic.reg2hw.prio10.q), clk_i, !rst_ni)

  // read/write assertions for register: prio11
  `ASSERT(prio11_wr_A, wr_P(2, 9'h34, i_rv_plic.reg2hw.prio11.q, 0), clk_i, !rst_ni)
  `ASSERT(prio11_rd_A, rd_P(2, 9'h34, i_rv_plic.reg2hw.prio11.q), clk_i, !rst_ni)

  // read/write assertions for register: prio12
  `ASSERT(prio12_wr_A, wr_P(2, 9'h38, i_rv_plic.reg2hw.prio12.q, 0), clk_i, !rst_ni)
  `ASSERT(prio12_rd_A, rd_P(2, 9'h38, i_rv_plic.reg2hw.prio12.q), clk_i, !rst_ni)

  // read/write assertions for register: prio13
  `ASSERT(prio13_wr_A, wr_P(2, 9'h3c, i_rv_plic.reg2hw.prio13.q, 0), clk_i, !rst_ni)
  `ASSERT(prio13_rd_A, rd_P(2, 9'h3c, i_rv_plic.reg2hw.prio13.q), clk_i, !rst_ni)

  // read/write assertions for register: prio14
  `ASSERT(prio14_wr_A, wr_P(2, 9'h40, i_rv_plic.reg2hw.prio14.q, 0), clk_i, !rst_ni)
  `ASSERT(prio14_rd_A, rd_P(2, 9'h40, i_rv_plic.reg2hw.prio14.q), clk_i, !rst_ni)

  // read/write assertions for register: prio15
  `ASSERT(prio15_wr_A, wr_P(2, 9'h44, i_rv_plic.reg2hw.prio15.q, 0), clk_i, !rst_ni)
  `ASSERT(prio15_rd_A, rd_P(2, 9'h44, i_rv_plic.reg2hw.prio15.q), clk_i, !rst_ni)

  // read/write assertions for register: prio16
  `ASSERT(prio16_wr_A, wr_P(2, 9'h48, i_rv_plic.reg2hw.prio16.q, 0), clk_i, !rst_ni)
  `ASSERT(prio16_rd_A, rd_P(2, 9'h48, i_rv_plic.reg2hw.prio16.q), clk_i, !rst_ni)

  // read/write assertions for register: prio17
  `ASSERT(prio17_wr_A, wr_P(2, 9'h4c, i_rv_plic.reg2hw.prio17.q, 0), clk_i, !rst_ni)
  `ASSERT(prio17_rd_A, rd_P(2, 9'h4c, i_rv_plic.reg2hw.prio17.q), clk_i, !rst_ni)

  // read/write assertions for register: prio18
  `ASSERT(prio18_wr_A, wr_P(2, 9'h50, i_rv_plic.reg2hw.prio18.q, 0), clk_i, !rst_ni)
  `ASSERT(prio18_rd_A, rd_P(2, 9'h50, i_rv_plic.reg2hw.prio18.q), clk_i, !rst_ni)

  // read/write assertions for register: prio19
  `ASSERT(prio19_wr_A, wr_P(2, 9'h54, i_rv_plic.reg2hw.prio19.q, 0), clk_i, !rst_ni)
  `ASSERT(prio19_rd_A, rd_P(2, 9'h54, i_rv_plic.reg2hw.prio19.q), clk_i, !rst_ni)

  // read/write assertions for register: prio20
  `ASSERT(prio20_wr_A, wr_P(2, 9'h58, i_rv_plic.reg2hw.prio20.q, 0), clk_i, !rst_ni)
  `ASSERT(prio20_rd_A, rd_P(2, 9'h58, i_rv_plic.reg2hw.prio20.q), clk_i, !rst_ni)

  // read/write assertions for register: prio21
  `ASSERT(prio21_wr_A, wr_P(2, 9'h5c, i_rv_plic.reg2hw.prio21.q, 0), clk_i, !rst_ni)
  `ASSERT(prio21_rd_A, rd_P(2, 9'h5c, i_rv_plic.reg2hw.prio21.q), clk_i, !rst_ni)

  // read/write assertions for register: prio22
  `ASSERT(prio22_wr_A, wr_P(2, 9'h60, i_rv_plic.reg2hw.prio22.q, 0), clk_i, !rst_ni)
  `ASSERT(prio22_rd_A, rd_P(2, 9'h60, i_rv_plic.reg2hw.prio22.q), clk_i, !rst_ni)

  // read/write assertions for register: prio23
  `ASSERT(prio23_wr_A, wr_P(2, 9'h64, i_rv_plic.reg2hw.prio23.q, 0), clk_i, !rst_ni)
  `ASSERT(prio23_rd_A, rd_P(2, 9'h64, i_rv_plic.reg2hw.prio23.q), clk_i, !rst_ni)

  // read/write assertions for register: prio24
  `ASSERT(prio24_wr_A, wr_P(2, 9'h68, i_rv_plic.reg2hw.prio24.q, 0), clk_i, !rst_ni)
  `ASSERT(prio24_rd_A, rd_P(2, 9'h68, i_rv_plic.reg2hw.prio24.q), clk_i, !rst_ni)

  // read/write assertions for register: prio25
  `ASSERT(prio25_wr_A, wr_P(2, 9'h6c, i_rv_plic.reg2hw.prio25.q, 0), clk_i, !rst_ni)
  `ASSERT(prio25_rd_A, rd_P(2, 9'h6c, i_rv_plic.reg2hw.prio25.q), clk_i, !rst_ni)

  // read/write assertions for register: prio26
  `ASSERT(prio26_wr_A, wr_P(2, 9'h70, i_rv_plic.reg2hw.prio26.q, 0), clk_i, !rst_ni)
  `ASSERT(prio26_rd_A, rd_P(2, 9'h70, i_rv_plic.reg2hw.prio26.q), clk_i, !rst_ni)

  // read/write assertions for register: prio27
  `ASSERT(prio27_wr_A, wr_P(2, 9'h74, i_rv_plic.reg2hw.prio27.q, 0), clk_i, !rst_ni)
  `ASSERT(prio27_rd_A, rd_P(2, 9'h74, i_rv_plic.reg2hw.prio27.q), clk_i, !rst_ni)

  // read/write assertions for register: prio28
  `ASSERT(prio28_wr_A, wr_P(2, 9'h78, i_rv_plic.reg2hw.prio28.q, 0), clk_i, !rst_ni)
  `ASSERT(prio28_rd_A, rd_P(2, 9'h78, i_rv_plic.reg2hw.prio28.q), clk_i, !rst_ni)

  // read/write assertions for register: prio29
  `ASSERT(prio29_wr_A, wr_P(2, 9'h7c, i_rv_plic.reg2hw.prio29.q, 0), clk_i, !rst_ni)
  `ASSERT(prio29_rd_A, rd_P(2, 9'h7c, i_rv_plic.reg2hw.prio29.q), clk_i, !rst_ni)

  // read/write assertions for register: prio30
  `ASSERT(prio30_wr_A, wr_P(2, 9'h80, i_rv_plic.reg2hw.prio30.q, 0), clk_i, !rst_ni)
  `ASSERT(prio30_rd_A, rd_P(2, 9'h80, i_rv_plic.reg2hw.prio30.q), clk_i, !rst_ni)

  // read/write assertions for register: prio31
  `ASSERT(prio31_wr_A, wr_P(2, 9'h84, i_rv_plic.reg2hw.prio31.q, 0), clk_i, !rst_ni)
  `ASSERT(prio31_rd_A, rd_P(2, 9'h84, i_rv_plic.reg2hw.prio31.q), clk_i, !rst_ni)

  // define local fpv variable for the multi_reg
  logic [31:0] ie0_q_fpv;
  for (genvar s = 0; s <= 31; s++) begin : gen_ie0_rd
    assign ie0_q_fpv[s] = i_rv_plic.reg2hw.ie0[s].q;
  end

  // read/write assertions for register: ie0
  `ASSERT(ie0_wr_A, wr_P(31, 9'h100, ie0_q_fpv[31:0], 0), clk_i, !rst_ni)
  `ASSERT(ie0_rd_A, rd_P(31, 9'h100, ie0_q_fpv[31:0]), clk_i, !rst_ni)

  // read/write assertions for register: threshold0
  `ASSERT(threshold0_wr_A, wr_P(2, 9'h104, i_rv_plic.reg2hw.threshold0.q, 0), clk_i, !rst_ni)
  `ASSERT(threshold0_rd_A, rd_P(2, 9'h104, i_rv_plic.reg2hw.threshold0.q), clk_i, !rst_ni)

  // read/write assertions for register: cc0
  `ASSERT(cc0_wr_A, wr_ext_P(5, 9'h108, i_rv_plic.reg2hw.cc0.q, 0), clk_i, !rst_ni)
  `ASSERT(cc0_rd_A, rd_ext_P(5, 9'h108, i_rv_plic.hw2reg.cc0.d), clk_i, !rst_ni)

  // read/write assertions for register: msip0
  `ASSERT(msip0_wr_A, wr_P(0, 9'h10c, i_rv_plic.reg2hw.msip0.q, 0), clk_i, !rst_ni)
  `ASSERT(msip0_rd_A, rd_P(0, 9'h10c, i_rv_plic.reg2hw.msip0.q), clk_i, !rst_ni)

endmodule
