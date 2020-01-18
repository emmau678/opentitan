// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

module pinmux_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output pinmux_reg_pkg::pinmux_reg2hw_t reg2hw, // Write

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import pinmux_reg_pkg::* ;

  localparam int AW = 5;
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
  logic regen_qs;
  logic regen_wd;
  logic regen_we;
  logic [3:0] periph_insel0_in0_qs;
  logic [3:0] periph_insel0_in0_wd;
  logic periph_insel0_in0_we;
  logic [3:0] periph_insel0_in1_qs;
  logic [3:0] periph_insel0_in1_wd;
  logic periph_insel0_in1_we;
  logic [3:0] periph_insel0_in2_qs;
  logic [3:0] periph_insel0_in2_wd;
  logic periph_insel0_in2_we;
  logic [3:0] periph_insel0_in3_qs;
  logic [3:0] periph_insel0_in3_wd;
  logic periph_insel0_in3_we;
  logic [3:0] periph_insel0_in4_qs;
  logic [3:0] periph_insel0_in4_wd;
  logic periph_insel0_in4_we;
  logic [3:0] periph_insel0_in5_qs;
  logic [3:0] periph_insel0_in5_wd;
  logic periph_insel0_in5_we;
  logic [3:0] periph_insel0_in6_qs;
  logic [3:0] periph_insel0_in6_wd;
  logic periph_insel0_in6_we;
  logic [3:0] periph_insel0_in7_qs;
  logic [3:0] periph_insel0_in7_wd;
  logic periph_insel0_in7_we;
  logic [3:0] periph_insel1_in8_qs;
  logic [3:0] periph_insel1_in8_wd;
  logic periph_insel1_in8_we;
  logic [3:0] periph_insel1_in9_qs;
  logic [3:0] periph_insel1_in9_wd;
  logic periph_insel1_in9_we;
  logic [3:0] periph_insel1_in10_qs;
  logic [3:0] periph_insel1_in10_wd;
  logic periph_insel1_in10_we;
  logic [3:0] periph_insel1_in11_qs;
  logic [3:0] periph_insel1_in11_wd;
  logic periph_insel1_in11_we;
  logic [3:0] periph_insel1_in12_qs;
  logic [3:0] periph_insel1_in12_wd;
  logic periph_insel1_in12_we;
  logic [3:0] periph_insel1_in13_qs;
  logic [3:0] periph_insel1_in13_wd;
  logic periph_insel1_in13_we;
  logic [3:0] periph_insel1_in14_qs;
  logic [3:0] periph_insel1_in14_wd;
  logic periph_insel1_in14_we;
  logic [3:0] periph_insel1_in15_qs;
  logic [3:0] periph_insel1_in15_wd;
  logic periph_insel1_in15_we;
  logic [4:0] mio_outsel0_out0_qs;
  logic [4:0] mio_outsel0_out0_wd;
  logic mio_outsel0_out0_we;
  logic [4:0] mio_outsel0_out1_qs;
  logic [4:0] mio_outsel0_out1_wd;
  logic mio_outsel0_out1_we;
  logic [4:0] mio_outsel0_out2_qs;
  logic [4:0] mio_outsel0_out2_wd;
  logic mio_outsel0_out2_we;
  logic [4:0] mio_outsel0_out3_qs;
  logic [4:0] mio_outsel0_out3_wd;
  logic mio_outsel0_out3_we;
  logic [4:0] mio_outsel0_out4_qs;
  logic [4:0] mio_outsel0_out4_wd;
  logic mio_outsel0_out4_we;
  logic [4:0] mio_outsel0_out5_qs;
  logic [4:0] mio_outsel0_out5_wd;
  logic mio_outsel0_out5_we;
  logic [4:0] mio_outsel1_out6_qs;
  logic [4:0] mio_outsel1_out6_wd;
  logic mio_outsel1_out6_we;
  logic [4:0] mio_outsel1_out7_qs;
  logic [4:0] mio_outsel1_out7_wd;
  logic mio_outsel1_out7_we;

  // Register instances
  // R[regen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_regen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (regen_we),
    .wd     (regen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (regen_qs)
  );



  // Subregister 0 of Multireg periph_insel
  // R[periph_insel0]: V(False)

  // F[in0]: 3:0
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in0_we & regen_qs),
    .wd     (periph_insel0_in0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[0].q ),

    // to register interface (read)
    .qs     (periph_insel0_in0_qs)
  );


  // F[in1]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in1_we & regen_qs),
    .wd     (periph_insel0_in1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[1].q ),

    // to register interface (read)
    .qs     (periph_insel0_in1_qs)
  );


  // F[in2]: 11:8
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in2_we & regen_qs),
    .wd     (periph_insel0_in2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[2].q ),

    // to register interface (read)
    .qs     (periph_insel0_in2_qs)
  );


  // F[in3]: 15:12
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in3_we & regen_qs),
    .wd     (periph_insel0_in3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[3].q ),

    // to register interface (read)
    .qs     (periph_insel0_in3_qs)
  );


  // F[in4]: 19:16
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in4_we & regen_qs),
    .wd     (periph_insel0_in4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[4].q ),

    // to register interface (read)
    .qs     (periph_insel0_in4_qs)
  );


  // F[in5]: 23:20
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in5_we & regen_qs),
    .wd     (periph_insel0_in5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[5].q ),

    // to register interface (read)
    .qs     (periph_insel0_in5_qs)
  );


  // F[in6]: 27:24
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in6_we & regen_qs),
    .wd     (periph_insel0_in6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[6].q ),

    // to register interface (read)
    .qs     (periph_insel0_in6_qs)
  );


  // F[in7]: 31:28
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel0_in7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel0_in7_we & regen_qs),
    .wd     (periph_insel0_in7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[7].q ),

    // to register interface (read)
    .qs     (periph_insel0_in7_qs)
  );


  // Subregister 8 of Multireg periph_insel
  // R[periph_insel1]: V(False)

  // F[in8]: 3:0
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in8 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in8_we & regen_qs),
    .wd     (periph_insel1_in8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[8].q ),

    // to register interface (read)
    .qs     (periph_insel1_in8_qs)
  );


  // F[in9]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in9 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in9_we & regen_qs),
    .wd     (periph_insel1_in9_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[9].q ),

    // to register interface (read)
    .qs     (periph_insel1_in9_qs)
  );


  // F[in10]: 11:8
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in10 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in10_we & regen_qs),
    .wd     (periph_insel1_in10_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[10].q ),

    // to register interface (read)
    .qs     (periph_insel1_in10_qs)
  );


  // F[in11]: 15:12
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in11 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in11_we & regen_qs),
    .wd     (periph_insel1_in11_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[11].q ),

    // to register interface (read)
    .qs     (periph_insel1_in11_qs)
  );


  // F[in12]: 19:16
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in12 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in12_we & regen_qs),
    .wd     (periph_insel1_in12_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[12].q ),

    // to register interface (read)
    .qs     (periph_insel1_in12_qs)
  );


  // F[in13]: 23:20
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in13 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in13_we & regen_qs),
    .wd     (periph_insel1_in13_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[13].q ),

    // to register interface (read)
    .qs     (periph_insel1_in13_qs)
  );


  // F[in14]: 27:24
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in14 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in14_we & regen_qs),
    .wd     (periph_insel1_in14_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[14].q ),

    // to register interface (read)
    .qs     (periph_insel1_in14_qs)
  );


  // F[in15]: 31:28
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_periph_insel1_in15 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (periph_insel1_in15_we & regen_qs),
    .wd     (periph_insel1_in15_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.periph_insel[15].q ),

    // to register interface (read)
    .qs     (periph_insel1_in15_qs)
  );




  // Subregister 0 of Multireg mio_outsel
  // R[mio_outsel0]: V(False)

  // F[out0]: 4:0
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out0_we & regen_qs),
    .wd     (mio_outsel0_out0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[0].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out0_qs)
  );


  // F[out1]: 9:5
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out1_we & regen_qs),
    .wd     (mio_outsel0_out1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[1].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out1_qs)
  );


  // F[out2]: 14:10
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out2_we & regen_qs),
    .wd     (mio_outsel0_out2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[2].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out2_qs)
  );


  // F[out3]: 19:15
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out3_we & regen_qs),
    .wd     (mio_outsel0_out3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[3].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out3_qs)
  );


  // F[out4]: 24:20
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out4_we & regen_qs),
    .wd     (mio_outsel0_out4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[4].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out4_qs)
  );


  // F[out5]: 29:25
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel0_out5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel0_out5_we & regen_qs),
    .wd     (mio_outsel0_out5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[5].q ),

    // to register interface (read)
    .qs     (mio_outsel0_out5_qs)
  );


  // Subregister 6 of Multireg mio_outsel
  // R[mio_outsel1]: V(False)

  // F[out6]: 4:0
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel1_out6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel1_out6_we & regen_qs),
    .wd     (mio_outsel1_out6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[6].q ),

    // to register interface (read)
    .qs     (mio_outsel1_out6_qs)
  );


  // F[out7]: 9:5
  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h2)
  ) u_mio_outsel1_out7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (mio_outsel1_out7_we & regen_qs),
    .wd     (mio_outsel1_out7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.mio_outsel[7].q ),

    // to register interface (read)
    .qs     (mio_outsel1_out7_qs)
  );





  logic [4:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == PINMUX_REGEN_OFFSET);
    addr_hit[1] = (reg_addr == PINMUX_PERIPH_INSEL0_OFFSET);
    addr_hit[2] = (reg_addr == PINMUX_PERIPH_INSEL1_OFFSET);
    addr_hit[3] = (reg_addr == PINMUX_MIO_OUTSEL0_OFFSET);
    addr_hit[4] = (reg_addr == PINMUX_MIO_OUTSEL1_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (PINMUX_PERMIT[0] != (PINMUX_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (PINMUX_PERMIT[1] != (PINMUX_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (PINMUX_PERMIT[2] != (PINMUX_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (PINMUX_PERMIT[3] != (PINMUX_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (PINMUX_PERMIT[4] != (PINMUX_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
  end

  assign regen_we = addr_hit[0] & reg_we & ~wr_err;
  assign regen_wd = reg_wdata[0];

  assign periph_insel0_in0_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in0_wd = reg_wdata[3:0];

  assign periph_insel0_in1_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in1_wd = reg_wdata[7:4];

  assign periph_insel0_in2_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in2_wd = reg_wdata[11:8];

  assign periph_insel0_in3_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in3_wd = reg_wdata[15:12];

  assign periph_insel0_in4_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in4_wd = reg_wdata[19:16];

  assign periph_insel0_in5_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in5_wd = reg_wdata[23:20];

  assign periph_insel0_in6_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in6_wd = reg_wdata[27:24];

  assign periph_insel0_in7_we = addr_hit[1] & reg_we & ~wr_err;
  assign periph_insel0_in7_wd = reg_wdata[31:28];

  assign periph_insel1_in8_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in8_wd = reg_wdata[3:0];

  assign periph_insel1_in9_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in9_wd = reg_wdata[7:4];

  assign periph_insel1_in10_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in10_wd = reg_wdata[11:8];

  assign periph_insel1_in11_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in11_wd = reg_wdata[15:12];

  assign periph_insel1_in12_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in12_wd = reg_wdata[19:16];

  assign periph_insel1_in13_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in13_wd = reg_wdata[23:20];

  assign periph_insel1_in14_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in14_wd = reg_wdata[27:24];

  assign periph_insel1_in15_we = addr_hit[2] & reg_we & ~wr_err;
  assign periph_insel1_in15_wd = reg_wdata[31:28];

  assign mio_outsel0_out0_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out0_wd = reg_wdata[4:0];

  assign mio_outsel0_out1_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out1_wd = reg_wdata[9:5];

  assign mio_outsel0_out2_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out2_wd = reg_wdata[14:10];

  assign mio_outsel0_out3_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out3_wd = reg_wdata[19:15];

  assign mio_outsel0_out4_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out4_wd = reg_wdata[24:20];

  assign mio_outsel0_out5_we = addr_hit[3] & reg_we & ~wr_err;
  assign mio_outsel0_out5_wd = reg_wdata[29:25];

  assign mio_outsel1_out6_we = addr_hit[4] & reg_we & ~wr_err;
  assign mio_outsel1_out6_wd = reg_wdata[4:0];

  assign mio_outsel1_out7_we = addr_hit[4] & reg_we & ~wr_err;
  assign mio_outsel1_out7_wd = reg_wdata[9:5];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = regen_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[3:0] = periph_insel0_in0_qs;
        reg_rdata_next[7:4] = periph_insel0_in1_qs;
        reg_rdata_next[11:8] = periph_insel0_in2_qs;
        reg_rdata_next[15:12] = periph_insel0_in3_qs;
        reg_rdata_next[19:16] = periph_insel0_in4_qs;
        reg_rdata_next[23:20] = periph_insel0_in5_qs;
        reg_rdata_next[27:24] = periph_insel0_in6_qs;
        reg_rdata_next[31:28] = periph_insel0_in7_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[3:0] = periph_insel1_in8_qs;
        reg_rdata_next[7:4] = periph_insel1_in9_qs;
        reg_rdata_next[11:8] = periph_insel1_in10_qs;
        reg_rdata_next[15:12] = periph_insel1_in11_qs;
        reg_rdata_next[19:16] = periph_insel1_in12_qs;
        reg_rdata_next[23:20] = periph_insel1_in13_qs;
        reg_rdata_next[27:24] = periph_insel1_in14_qs;
        reg_rdata_next[31:28] = periph_insel1_in15_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[4:0] = mio_outsel0_out0_qs;
        reg_rdata_next[9:5] = mio_outsel0_out1_qs;
        reg_rdata_next[14:10] = mio_outsel0_out2_qs;
        reg_rdata_next[19:15] = mio_outsel0_out3_qs;
        reg_rdata_next[24:20] = mio_outsel0_out4_qs;
        reg_rdata_next[29:25] = mio_outsel0_out5_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[4:0] = mio_outsel1_out6_qs;
        reg_rdata_next[9:5] = mio_outsel1_out7_qs;
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
