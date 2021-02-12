// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module sensor_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output sensor_ctrl_reg_pkg::sensor_ctrl_reg2hw_t reg2hw, // Write
  input  sensor_ctrl_reg_pkg::sensor_ctrl_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import sensor_ctrl_reg_pkg::* ;

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

  // incoming payload check
  logic chk_err;
  tlul_payload_chk u_chk (
    .tl_i,
    .err_o(chk_err)
  );

  // outgoing payload generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_gen_payload_chk u_gen_chk (
    .tl_i(tl_o_pre),
    .tl_o
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

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
  assign reg_error = (devmode_i & addrmiss) | wr_err | chk_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic alert_test_recov_as_wd;
  logic alert_test_recov_as_we;
  logic alert_test_recov_cg_wd;
  logic alert_test_recov_cg_we;
  logic alert_test_recov_gd_wd;
  logic alert_test_recov_gd_we;
  logic alert_test_recov_ts_hi_wd;
  logic alert_test_recov_ts_hi_we;
  logic alert_test_recov_ts_lo_wd;
  logic alert_test_recov_ts_lo_we;
  logic alert_test_recov_ls_wd;
  logic alert_test_recov_ls_we;
  logic alert_test_recov_ot_wd;
  logic alert_test_recov_ot_we;
  logic cfg_regwen_qs;
  logic cfg_regwen_wd;
  logic cfg_regwen_we;
  logic [1:0] ack_mode_val_0_qs;
  logic [1:0] ack_mode_val_0_wd;
  logic ack_mode_val_0_we;
  logic [1:0] ack_mode_val_1_qs;
  logic [1:0] ack_mode_val_1_wd;
  logic ack_mode_val_1_we;
  logic [1:0] ack_mode_val_2_qs;
  logic [1:0] ack_mode_val_2_wd;
  logic ack_mode_val_2_we;
  logic [1:0] ack_mode_val_3_qs;
  logic [1:0] ack_mode_val_3_wd;
  logic ack_mode_val_3_we;
  logic [1:0] ack_mode_val_4_qs;
  logic [1:0] ack_mode_val_4_wd;
  logic ack_mode_val_4_we;
  logic [1:0] ack_mode_val_5_qs;
  logic [1:0] ack_mode_val_5_wd;
  logic ack_mode_val_5_we;
  logic [1:0] ack_mode_val_6_qs;
  logic [1:0] ack_mode_val_6_wd;
  logic ack_mode_val_6_we;
  logic alert_trig_val_0_qs;
  logic alert_trig_val_0_wd;
  logic alert_trig_val_0_we;
  logic alert_trig_val_1_qs;
  logic alert_trig_val_1_wd;
  logic alert_trig_val_1_we;
  logic alert_trig_val_2_qs;
  logic alert_trig_val_2_wd;
  logic alert_trig_val_2_we;
  logic alert_trig_val_3_qs;
  logic alert_trig_val_3_wd;
  logic alert_trig_val_3_we;
  logic alert_trig_val_4_qs;
  logic alert_trig_val_4_wd;
  logic alert_trig_val_4_we;
  logic alert_trig_val_5_qs;
  logic alert_trig_val_5_wd;
  logic alert_trig_val_5_we;
  logic alert_trig_val_6_qs;
  logic alert_trig_val_6_wd;
  logic alert_trig_val_6_we;
  logic alert_state_val_0_qs;
  logic alert_state_val_0_wd;
  logic alert_state_val_0_we;
  logic alert_state_val_1_qs;
  logic alert_state_val_1_wd;
  logic alert_state_val_1_we;
  logic alert_state_val_2_qs;
  logic alert_state_val_2_wd;
  logic alert_state_val_2_we;
  logic alert_state_val_3_qs;
  logic alert_state_val_3_wd;
  logic alert_state_val_3_we;
  logic alert_state_val_4_qs;
  logic alert_state_val_4_wd;
  logic alert_state_val_4_we;
  logic alert_state_val_5_qs;
  logic alert_state_val_5_wd;
  logic alert_state_val_5_we;
  logic alert_state_val_6_qs;
  logic alert_state_val_6_wd;
  logic alert_state_val_6_we;
  logic [1:0] status_qs;

  // Register instances
  // R[alert_test]: V(True)

  //   F[recov_as]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_as (
    .re     (1'b0),
    .we     (alert_test_recov_as_we),
    .wd     (alert_test_recov_as_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_as.qe),
    .q      (reg2hw.alert_test.recov_as.q ),
    .qs     ()
  );


  //   F[recov_cg]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_cg (
    .re     (1'b0),
    .we     (alert_test_recov_cg_we),
    .wd     (alert_test_recov_cg_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_cg.qe),
    .q      (reg2hw.alert_test.recov_cg.q ),
    .qs     ()
  );


  //   F[recov_gd]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_gd (
    .re     (1'b0),
    .we     (alert_test_recov_gd_we),
    .wd     (alert_test_recov_gd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_gd.qe),
    .q      (reg2hw.alert_test.recov_gd.q ),
    .qs     ()
  );


  //   F[recov_ts_hi]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ts_hi (
    .re     (1'b0),
    .we     (alert_test_recov_ts_hi_we),
    .wd     (alert_test_recov_ts_hi_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ts_hi.qe),
    .q      (reg2hw.alert_test.recov_ts_hi.q ),
    .qs     ()
  );


  //   F[recov_ts_lo]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ts_lo (
    .re     (1'b0),
    .we     (alert_test_recov_ts_lo_we),
    .wd     (alert_test_recov_ts_lo_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ts_lo.qe),
    .q      (reg2hw.alert_test.recov_ts_lo.q ),
    .qs     ()
  );


  //   F[recov_ls]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ls (
    .re     (1'b0),
    .we     (alert_test_recov_ls_we),
    .wd     (alert_test_recov_ls_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ls.qe),
    .q      (reg2hw.alert_test.recov_ls.q ),
    .qs     ()
  );


  //   F[recov_ot]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot (
    .re     (1'b0),
    .we     (alert_test_recov_ot_we),
    .wd     (alert_test_recov_ot_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot.qe),
    .q      (reg2hw.alert_test.recov_ot.q ),
    .qs     ()
  );


  // R[cfg_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_cfg_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (cfg_regwen_we),
    .wd     (cfg_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (cfg_regwen_qs)
  );



  // Subregister 0 of Multireg ack_mode
  // R[ack_mode]: V(False)

  // F[val_0]: 1:0
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_0_we & cfg_regwen_qs),
    .wd     (ack_mode_val_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[0].q ),

    // to register interface (read)
    .qs     (ack_mode_val_0_qs)
  );


  // F[val_1]: 3:2
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_1_we & cfg_regwen_qs),
    .wd     (ack_mode_val_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[1].q ),

    // to register interface (read)
    .qs     (ack_mode_val_1_qs)
  );


  // F[val_2]: 5:4
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_2_we & cfg_regwen_qs),
    .wd     (ack_mode_val_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[2].q ),

    // to register interface (read)
    .qs     (ack_mode_val_2_qs)
  );


  // F[val_3]: 7:6
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_3_we & cfg_regwen_qs),
    .wd     (ack_mode_val_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[3].q ),

    // to register interface (read)
    .qs     (ack_mode_val_3_qs)
  );


  // F[val_4]: 9:8
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_4_we & cfg_regwen_qs),
    .wd     (ack_mode_val_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[4].q ),

    // to register interface (read)
    .qs     (ack_mode_val_4_qs)
  );


  // F[val_5]: 11:10
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_5_we & cfg_regwen_qs),
    .wd     (ack_mode_val_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[5].q ),

    // to register interface (read)
    .qs     (ack_mode_val_5_qs)
  );


  // F[val_6]: 13:12
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ack_mode_val_6_we & cfg_regwen_qs),
    .wd     (ack_mode_val_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[6].q ),

    // to register interface (read)
    .qs     (ack_mode_val_6_qs)
  );




  // Subregister 0 of Multireg alert_trig
  // R[alert_trig]: V(False)

  // F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_0_we),
    .wd     (alert_trig_val_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[0].q ),

    // to register interface (read)
    .qs     (alert_trig_val_0_qs)
  );


  // F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_1_we),
    .wd     (alert_trig_val_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[1].q ),

    // to register interface (read)
    .qs     (alert_trig_val_1_qs)
  );


  // F[val_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_2_we),
    .wd     (alert_trig_val_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[2].q ),

    // to register interface (read)
    .qs     (alert_trig_val_2_qs)
  );


  // F[val_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_3_we),
    .wd     (alert_trig_val_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[3].q ),

    // to register interface (read)
    .qs     (alert_trig_val_3_qs)
  );


  // F[val_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_4_we),
    .wd     (alert_trig_val_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[4].q ),

    // to register interface (read)
    .qs     (alert_trig_val_4_qs)
  );


  // F[val_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_5_we),
    .wd     (alert_trig_val_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[5].q ),

    // to register interface (read)
    .qs     (alert_trig_val_5_qs)
  );


  // F[val_6]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_trig_val_6_we),
    .wd     (alert_trig_val_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[6].q ),

    // to register interface (read)
    .qs     (alert_trig_val_6_qs)
  );




  // Subregister 0 of Multireg alert_state
  // R[alert_state]: V(False)

  // F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_0_we),
    .wd     (alert_state_val_0_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[0].de),
    .d      (hw2reg.alert_state[0].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[0].qe),
    .q      (reg2hw.alert_state[0].q ),

    // to register interface (read)
    .qs     (alert_state_val_0_qs)
  );


  // F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_1_we),
    .wd     (alert_state_val_1_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[1].de),
    .d      (hw2reg.alert_state[1].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[1].qe),
    .q      (reg2hw.alert_state[1].q ),

    // to register interface (read)
    .qs     (alert_state_val_1_qs)
  );


  // F[val_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_2_we),
    .wd     (alert_state_val_2_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[2].de),
    .d      (hw2reg.alert_state[2].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[2].qe),
    .q      (reg2hw.alert_state[2].q ),

    // to register interface (read)
    .qs     (alert_state_val_2_qs)
  );


  // F[val_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_3_we),
    .wd     (alert_state_val_3_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[3].de),
    .d      (hw2reg.alert_state[3].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[3].qe),
    .q      (reg2hw.alert_state[3].q ),

    // to register interface (read)
    .qs     (alert_state_val_3_qs)
  );


  // F[val_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_4_we),
    .wd     (alert_state_val_4_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[4].de),
    .d      (hw2reg.alert_state[4].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[4].qe),
    .q      (reg2hw.alert_state[4].q ),

    // to register interface (read)
    .qs     (alert_state_val_4_qs)
  );


  // F[val_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_5_we),
    .wd     (alert_state_val_5_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[5].de),
    .d      (hw2reg.alert_state[5].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[5].qe),
    .q      (reg2hw.alert_state[5].q ),

    // to register interface (read)
    .qs     (alert_state_val_5_qs)
  );


  // F[val_6]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_state_val_6_we),
    .wd     (alert_state_val_6_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[6].de),
    .d      (hw2reg.alert_state[6].d ),

    // to internal hardware
    .qe     (reg2hw.alert_state[6].qe),
    .q      (reg2hw.alert_state[6].q ),

    // to register interface (read)
    .qs     (alert_state_val_6_qs)
  );



  // R[status]: V(False)

  prim_subreg #(
    .DW      (2),
    .SWACCESS("RO"),
    .RESVAL  (2'h3)
  ) u_status (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.status.de),
    .d      (hw2reg.status.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (status_qs)
  );




  logic [5:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == SENSOR_CTRL_ALERT_TEST_OFFSET);
    addr_hit[1] = (reg_addr == SENSOR_CTRL_CFG_REGWEN_OFFSET);
    addr_hit[2] = (reg_addr == SENSOR_CTRL_ACK_MODE_OFFSET);
    addr_hit[3] = (reg_addr == SENSOR_CTRL_ALERT_TRIG_OFFSET);
    addr_hit[4] = (reg_addr == SENSOR_CTRL_ALERT_STATE_OFFSET);
    addr_hit[5] = (reg_addr == SENSOR_CTRL_STATUS_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (SENSOR_CTRL_PERMIT[0] != (SENSOR_CTRL_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (SENSOR_CTRL_PERMIT[1] != (SENSOR_CTRL_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (SENSOR_CTRL_PERMIT[2] != (SENSOR_CTRL_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (SENSOR_CTRL_PERMIT[3] != (SENSOR_CTRL_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (SENSOR_CTRL_PERMIT[4] != (SENSOR_CTRL_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[5] && reg_we && (SENSOR_CTRL_PERMIT[5] != (SENSOR_CTRL_PERMIT[5] & reg_be))) wr_err = 1'b1 ;
  end

  assign alert_test_recov_as_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_as_wd = reg_wdata[0];

  assign alert_test_recov_cg_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_cg_wd = reg_wdata[1];

  assign alert_test_recov_gd_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_gd_wd = reg_wdata[2];

  assign alert_test_recov_ts_hi_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_ts_hi_wd = reg_wdata[3];

  assign alert_test_recov_ts_lo_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_ts_lo_wd = reg_wdata[4];

  assign alert_test_recov_ls_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_ls_wd = reg_wdata[5];

  assign alert_test_recov_ot_we = addr_hit[0] & reg_we & ~wr_err;
  assign alert_test_recov_ot_wd = reg_wdata[6];

  assign cfg_regwen_we = addr_hit[1] & reg_we & ~wr_err;
  assign cfg_regwen_wd = reg_wdata[0];

  assign ack_mode_val_0_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_0_wd = reg_wdata[1:0];

  assign ack_mode_val_1_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_1_wd = reg_wdata[3:2];

  assign ack_mode_val_2_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_2_wd = reg_wdata[5:4];

  assign ack_mode_val_3_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_3_wd = reg_wdata[7:6];

  assign ack_mode_val_4_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_4_wd = reg_wdata[9:8];

  assign ack_mode_val_5_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_5_wd = reg_wdata[11:10];

  assign ack_mode_val_6_we = addr_hit[2] & reg_we & ~wr_err;
  assign ack_mode_val_6_wd = reg_wdata[13:12];

  assign alert_trig_val_0_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_0_wd = reg_wdata[0];

  assign alert_trig_val_1_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_1_wd = reg_wdata[1];

  assign alert_trig_val_2_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_2_wd = reg_wdata[2];

  assign alert_trig_val_3_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_3_wd = reg_wdata[3];

  assign alert_trig_val_4_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_4_wd = reg_wdata[4];

  assign alert_trig_val_5_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_5_wd = reg_wdata[5];

  assign alert_trig_val_6_we = addr_hit[3] & reg_we & ~wr_err;
  assign alert_trig_val_6_wd = reg_wdata[6];

  assign alert_state_val_0_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_0_wd = reg_wdata[0];

  assign alert_state_val_1_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_1_wd = reg_wdata[1];

  assign alert_state_val_2_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_2_wd = reg_wdata[2];

  assign alert_state_val_3_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_3_wd = reg_wdata[3];

  assign alert_state_val_4_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_4_wd = reg_wdata[4];

  assign alert_state_val_5_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_5_wd = reg_wdata[5];

  assign alert_state_val_6_we = addr_hit[4] & reg_we & ~wr_err;
  assign alert_state_val_6_wd = reg_wdata[6];


  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
        reg_rdata_next[4] = '0;
        reg_rdata_next[5] = '0;
        reg_rdata_next[6] = '0;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = cfg_regwen_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[1:0] = ack_mode_val_0_qs;
        reg_rdata_next[3:2] = ack_mode_val_1_qs;
        reg_rdata_next[5:4] = ack_mode_val_2_qs;
        reg_rdata_next[7:6] = ack_mode_val_3_qs;
        reg_rdata_next[9:8] = ack_mode_val_4_qs;
        reg_rdata_next[11:10] = ack_mode_val_5_qs;
        reg_rdata_next[13:12] = ack_mode_val_6_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = alert_trig_val_0_qs;
        reg_rdata_next[1] = alert_trig_val_1_qs;
        reg_rdata_next[2] = alert_trig_val_2_qs;
        reg_rdata_next[3] = alert_trig_val_3_qs;
        reg_rdata_next[4] = alert_trig_val_4_qs;
        reg_rdata_next[5] = alert_trig_val_5_qs;
        reg_rdata_next[6] = alert_trig_val_6_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = alert_state_val_0_qs;
        reg_rdata_next[1] = alert_state_val_1_qs;
        reg_rdata_next[2] = alert_state_val_2_qs;
        reg_rdata_next[3] = alert_state_val_3_qs;
        reg_rdata_next[4] = alert_state_val_4_qs;
        reg_rdata_next[5] = alert_state_val_5_qs;
        reg_rdata_next[6] = alert_state_val_6_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[1:0] = status_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
