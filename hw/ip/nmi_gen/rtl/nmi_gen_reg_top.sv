// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module nmi_gen_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output nmi_gen_reg_pkg::nmi_gen_reg2hw_t reg2hw, // Write
  input  nmi_gen_reg_pkg::nmi_gen_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import nmi_gen_reg_pkg::* ;

  localparam int AW = 4;
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
  logic intr_state_esc0_qs;
  logic intr_state_esc0_wd;
  logic intr_state_esc0_we;
  logic intr_state_esc1_qs;
  logic intr_state_esc1_wd;
  logic intr_state_esc1_we;
  logic intr_state_esc2_qs;
  logic intr_state_esc2_wd;
  logic intr_state_esc2_we;
  logic intr_state_esc3_qs;
  logic intr_state_esc3_wd;
  logic intr_state_esc3_we;
  logic intr_enable_esc0_qs;
  logic intr_enable_esc0_wd;
  logic intr_enable_esc0_we;
  logic intr_enable_esc1_qs;
  logic intr_enable_esc1_wd;
  logic intr_enable_esc1_we;
  logic intr_enable_esc2_qs;
  logic intr_enable_esc2_wd;
  logic intr_enable_esc2_we;
  logic intr_enable_esc3_qs;
  logic intr_enable_esc3_wd;
  logic intr_enable_esc3_we;
  logic intr_test_esc0_wd;
  logic intr_test_esc0_we;
  logic intr_test_esc1_wd;
  logic intr_test_esc1_we;
  logic intr_test_esc2_wd;
  logic intr_test_esc2_we;
  logic intr_test_esc3_wd;
  logic intr_test_esc3_we;

  // Register instances
  // R[intr_state]: V(False)

  //   F[esc0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_esc0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_esc0_we),
    .wd     (intr_state_esc0_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.esc0.de),
    .d      (hw2reg.intr_state.esc0.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.esc0.q ),

    // to register interface (read)
    .qs     (intr_state_esc0_qs)
  );


  //   F[esc1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_esc1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_esc1_we),
    .wd     (intr_state_esc1_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.esc1.de),
    .d      (hw2reg.intr_state.esc1.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.esc1.q ),

    // to register interface (read)
    .qs     (intr_state_esc1_qs)
  );


  //   F[esc2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_esc2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_esc2_we),
    .wd     (intr_state_esc2_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.esc2.de),
    .d      (hw2reg.intr_state.esc2.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.esc2.q ),

    // to register interface (read)
    .qs     (intr_state_esc2_qs)
  );


  //   F[esc3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_esc3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_esc3_we),
    .wd     (intr_state_esc3_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.esc3.de),
    .d      (hw2reg.intr_state.esc3.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.esc3.q ),

    // to register interface (read)
    .qs     (intr_state_esc3_qs)
  );


  // R[intr_enable]: V(False)

  //   F[esc0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_esc0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_esc0_we),
    .wd     (intr_enable_esc0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.esc0.q ),

    // to register interface (read)
    .qs     (intr_enable_esc0_qs)
  );


  //   F[esc1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_esc1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_esc1_we),
    .wd     (intr_enable_esc1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.esc1.q ),

    // to register interface (read)
    .qs     (intr_enable_esc1_qs)
  );


  //   F[esc2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_esc2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_esc2_we),
    .wd     (intr_enable_esc2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.esc2.q ),

    // to register interface (read)
    .qs     (intr_enable_esc2_qs)
  );


  //   F[esc3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_esc3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_esc3_we),
    .wd     (intr_enable_esc3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.esc3.q ),

    // to register interface (read)
    .qs     (intr_enable_esc3_qs)
  );


  // R[intr_test]: V(True)

  //   F[esc0]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_esc0 (
    .re     (1'b0),
    .we     (intr_test_esc0_we),
    .wd     (intr_test_esc0_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.esc0.qe),
    .q      (reg2hw.intr_test.esc0.q ),
    .qs     ()
  );


  //   F[esc1]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_esc1 (
    .re     (1'b0),
    .we     (intr_test_esc1_we),
    .wd     (intr_test_esc1_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.esc1.qe),
    .q      (reg2hw.intr_test.esc1.q ),
    .qs     ()
  );


  //   F[esc2]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_esc2 (
    .re     (1'b0),
    .we     (intr_test_esc2_we),
    .wd     (intr_test_esc2_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.esc2.qe),
    .q      (reg2hw.intr_test.esc2.q ),
    .qs     ()
  );


  //   F[esc3]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_esc3 (
    .re     (1'b0),
    .we     (intr_test_esc3_we),
    .wd     (intr_test_esc3_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.esc3.qe),
    .q      (reg2hw.intr_test.esc3.q ),
    .qs     ()
  );




  logic [2:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == NMI_GEN_INTR_STATE_OFFSET);
    addr_hit[1] = (reg_addr == NMI_GEN_INTR_ENABLE_OFFSET);
    addr_hit[2] = (reg_addr == NMI_GEN_INTR_TEST_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (NMI_GEN_PERMIT[0] != (NMI_GEN_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (NMI_GEN_PERMIT[1] != (NMI_GEN_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (NMI_GEN_PERMIT[2] != (NMI_GEN_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_esc0_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_esc0_wd = reg_wdata[0];

  assign intr_state_esc1_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_esc1_wd = reg_wdata[1];

  assign intr_state_esc2_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_esc2_wd = reg_wdata[2];

  assign intr_state_esc3_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_esc3_wd = reg_wdata[3];

  assign intr_enable_esc0_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_esc0_wd = reg_wdata[0];

  assign intr_enable_esc1_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_esc1_wd = reg_wdata[1];

  assign intr_enable_esc2_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_esc2_wd = reg_wdata[2];

  assign intr_enable_esc3_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_esc3_wd = reg_wdata[3];

  assign intr_test_esc0_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_esc0_wd = reg_wdata[0];

  assign intr_test_esc1_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_esc1_wd = reg_wdata[1];

  assign intr_test_esc2_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_esc2_wd = reg_wdata[2];

  assign intr_test_esc3_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_esc3_wd = reg_wdata[3];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_esc0_qs;
        reg_rdata_next[1] = intr_state_esc1_qs;
        reg_rdata_next[2] = intr_state_esc2_qs;
        reg_rdata_next[3] = intr_state_esc3_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_esc0_qs;
        reg_rdata_next[1] = intr_enable_esc1_qs;
        reg_rdata_next[2] = intr_enable_esc2_qs;
        reg_rdata_next[3] = intr_enable_esc3_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0, clk_i, !rst_ni)

endmodule
