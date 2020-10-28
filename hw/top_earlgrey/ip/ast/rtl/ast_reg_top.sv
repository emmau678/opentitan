// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module ast_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output ast_reg_pkg::ast_reg2hw_t reg2hw, // Write
  input  ast_reg_pkg::ast_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import ast_reg_pkg::* ;

  localparam int AW = 3;
  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

  assign tl_reg_h2d = tl_i;
  assign tl_o       = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW)
  ) u_reg_if (
    .clk_i,
    .rst_ni,

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err ;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic [31:0] rwtype0_qs;
  logic [31:0] rwtype0_wd;
  logic rwtype0_we;
  logic rwtype1_field0_qs;
  logic rwtype1_field0_wd;
  logic rwtype1_field0_we;
  logic rwtype1_field1_qs;
  logic rwtype1_field1_wd;
  logic rwtype1_field1_we;
  logic rwtype1_field4_qs;
  logic rwtype1_field4_wd;
  logic rwtype1_field4_we;
  logic [7:0] rwtype1_field15_8_qs;
  logic [7:0] rwtype1_field15_8_wd;
  logic rwtype1_field15_8_we;

  // Register instances
  // R[rwtype0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'hbc614e)
  ) u_rwtype0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype0_we),
    .wd     (rwtype0_wd),

    // from internal hardware
    .de     (hw2reg.rwtype0.de),
    .d      (hw2reg.rwtype0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype0.q ),

    // to register interface (read)
    .qs     (rwtype0_qs)
  );


  // R[rwtype1]: V(False)

  //   F[field0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rwtype1_field0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field0_we),
    .wd     (rwtype1_field0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field0.q ),

    // to register interface (read)
    .qs     (rwtype1_field0_qs)
  );


  //   F[field1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_rwtype1_field1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field1_we),
    .wd     (rwtype1_field1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field1.q ),

    // to register interface (read)
    .qs     (rwtype1_field1_qs)
  );


  //   F[field4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h1)
  ) u_rwtype1_field4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field4_we),
    .wd     (rwtype1_field4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field4.q ),

    // to register interface (read)
    .qs     (rwtype1_field4_qs)
  );


  //   F[field15_8]: 15:8
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RW"),
    .RESVAL  (8'h64)
  ) u_rwtype1_field15_8 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (rwtype1_field15_8_we),
    .wd     (rwtype1_field15_8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.rwtype1.field15_8.q ),

    // to register interface (read)
    .qs     (rwtype1_field15_8_qs)
  );




  logic [1:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == AST_RWTYPE0_OFFSET);
    addr_hit[1] = (reg_addr == AST_RWTYPE1_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (AST_PERMIT[0] != (AST_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (AST_PERMIT[1] != (AST_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
  end

  assign rwtype0_we = addr_hit[0] & reg_we & ~wr_err;
  assign rwtype0_wd = reg_wdata[31:0];

  assign rwtype1_field0_we = addr_hit[1] & reg_we & ~wr_err;
  assign rwtype1_field0_wd = reg_wdata[0];

  assign rwtype1_field1_we = addr_hit[1] & reg_we & ~wr_err;
  assign rwtype1_field1_wd = reg_wdata[1];

  assign rwtype1_field4_we = addr_hit[1] & reg_we & ~wr_err;
  assign rwtype1_field4_wd = reg_wdata[4];

  assign rwtype1_field15_8_we = addr_hit[1] & reg_we & ~wr_err;
  assign rwtype1_field15_8_wd = reg_wdata[15:8];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[31:0] = rwtype0_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = rwtype1_field0_qs;
        reg_rdata_next[1] = rwtype1_field1_qs;
        reg_rdata_next[4] = rwtype1_field4_qs;
        reg_rdata_next[15:8] = rwtype1_field15_8_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0)

endmodule
