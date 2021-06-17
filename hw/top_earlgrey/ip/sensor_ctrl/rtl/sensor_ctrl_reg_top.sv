// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module sensor_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output sensor_ctrl_reg_pkg::sensor_ctrl_reg2hw_t reg2hw, // Write
  input  sensor_ctrl_reg_pkg::sensor_ctrl_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

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
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i,
    .err_o(intg_err)
  );

  logic intg_err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      intg_err_q <= '0;
    end else if (intg_err) begin
      intg_err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = intg_err_q | intg_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
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
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic alert_test_we;
  logic alert_test_recov_as_wd;
  logic alert_test_recov_cg_wd;
  logic alert_test_recov_gd_wd;
  logic alert_test_recov_ts_hi_wd;
  logic alert_test_recov_ts_lo_wd;
  logic alert_test_recov_fla_wd;
  logic alert_test_recov_otp_wd;
  logic alert_test_recov_ot0_wd;
  logic alert_test_recov_ot1_wd;
  logic alert_test_recov_ot2_wd;
  logic alert_test_recov_ot3_wd;
  logic alert_test_recov_ot4_wd;
  logic alert_test_recov_ot5_wd;
  logic cfg_regwen_we;
  logic cfg_regwen_qs;
  logic cfg_regwen_wd;
  logic ack_mode_we;
  logic [1:0] ack_mode_val_0_qs;
  logic [1:0] ack_mode_val_0_wd;
  logic [1:0] ack_mode_val_1_qs;
  logic [1:0] ack_mode_val_1_wd;
  logic [1:0] ack_mode_val_2_qs;
  logic [1:0] ack_mode_val_2_wd;
  logic [1:0] ack_mode_val_3_qs;
  logic [1:0] ack_mode_val_3_wd;
  logic [1:0] ack_mode_val_4_qs;
  logic [1:0] ack_mode_val_4_wd;
  logic [1:0] ack_mode_val_5_qs;
  logic [1:0] ack_mode_val_5_wd;
  logic [1:0] ack_mode_val_6_qs;
  logic [1:0] ack_mode_val_6_wd;
  logic [1:0] ack_mode_val_7_qs;
  logic [1:0] ack_mode_val_7_wd;
  logic [1:0] ack_mode_val_8_qs;
  logic [1:0] ack_mode_val_8_wd;
  logic [1:0] ack_mode_val_9_qs;
  logic [1:0] ack_mode_val_9_wd;
  logic [1:0] ack_mode_val_10_qs;
  logic [1:0] ack_mode_val_10_wd;
  logic [1:0] ack_mode_val_11_qs;
  logic [1:0] ack_mode_val_11_wd;
  logic [1:0] ack_mode_val_12_qs;
  logic [1:0] ack_mode_val_12_wd;
  logic alert_trig_we;
  logic alert_trig_val_0_qs;
  logic alert_trig_val_0_wd;
  logic alert_trig_val_1_qs;
  logic alert_trig_val_1_wd;
  logic alert_trig_val_2_qs;
  logic alert_trig_val_2_wd;
  logic alert_trig_val_3_qs;
  logic alert_trig_val_3_wd;
  logic alert_trig_val_4_qs;
  logic alert_trig_val_4_wd;
  logic alert_trig_val_5_qs;
  logic alert_trig_val_5_wd;
  logic alert_trig_val_6_qs;
  logic alert_trig_val_6_wd;
  logic alert_trig_val_7_qs;
  logic alert_trig_val_7_wd;
  logic alert_trig_val_8_qs;
  logic alert_trig_val_8_wd;
  logic alert_trig_val_9_qs;
  logic alert_trig_val_9_wd;
  logic alert_trig_val_10_qs;
  logic alert_trig_val_10_wd;
  logic alert_trig_val_11_qs;
  logic alert_trig_val_11_wd;
  logic alert_trig_val_12_qs;
  logic alert_trig_val_12_wd;
  logic alert_state_we;
  logic alert_state_val_0_qs;
  logic alert_state_val_0_wd;
  logic alert_state_val_1_qs;
  logic alert_state_val_1_wd;
  logic alert_state_val_2_qs;
  logic alert_state_val_2_wd;
  logic alert_state_val_3_qs;
  logic alert_state_val_3_wd;
  logic alert_state_val_4_qs;
  logic alert_state_val_4_wd;
  logic alert_state_val_5_qs;
  logic alert_state_val_5_wd;
  logic alert_state_val_6_qs;
  logic alert_state_val_6_wd;
  logic alert_state_val_7_qs;
  logic alert_state_val_7_wd;
  logic alert_state_val_8_qs;
  logic alert_state_val_8_wd;
  logic alert_state_val_9_qs;
  logic alert_state_val_9_wd;
  logic alert_state_val_10_qs;
  logic alert_state_val_10_wd;
  logic alert_state_val_11_qs;
  logic alert_state_val_11_wd;
  logic alert_state_val_12_qs;
  logic alert_state_val_12_wd;
  logic status_ast_init_done_qs;
  logic [1:0] status_io_pok_qs;

  // Register instances
  // R[alert_test]: V(True)

  //   F[recov_as]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_as (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_as_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_as.qe),
    .q      (reg2hw.alert_test.recov_as.q),
    .qs     ()
  );


  //   F[recov_cg]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_cg (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_cg_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_cg.qe),
    .q      (reg2hw.alert_test.recov_cg.q),
    .qs     ()
  );


  //   F[recov_gd]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_gd (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_gd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_gd.qe),
    .q      (reg2hw.alert_test.recov_gd.q),
    .qs     ()
  );


  //   F[recov_ts_hi]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ts_hi (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ts_hi_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ts_hi.qe),
    .q      (reg2hw.alert_test.recov_ts_hi.q),
    .qs     ()
  );


  //   F[recov_ts_lo]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ts_lo (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ts_lo_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ts_lo.qe),
    .q      (reg2hw.alert_test.recov_ts_lo.q),
    .qs     ()
  );


  //   F[recov_fla]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_fla (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_fla_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_fla.qe),
    .q      (reg2hw.alert_test.recov_fla.q),
    .qs     ()
  );


  //   F[recov_otp]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_otp (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_otp_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_otp.qe),
    .q      (reg2hw.alert_test.recov_otp.q),
    .qs     ()
  );


  //   F[recov_ot0]: 7:7
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot0 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot0_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot0.qe),
    .q      (reg2hw.alert_test.recov_ot0.q),
    .qs     ()
  );


  //   F[recov_ot1]: 8:8
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot1 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot1_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot1.qe),
    .q      (reg2hw.alert_test.recov_ot1.q),
    .qs     ()
  );


  //   F[recov_ot2]: 9:9
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot2 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot2_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot2.qe),
    .q      (reg2hw.alert_test.recov_ot2.q),
    .qs     ()
  );


  //   F[recov_ot3]: 10:10
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot3 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot3_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot3.qe),
    .q      (reg2hw.alert_test.recov_ot3.q),
    .qs     ()
  );


  //   F[recov_ot4]: 11:11
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot4 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot4_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot4.qe),
    .q      (reg2hw.alert_test.recov_ot4.q),
    .qs     ()
  );


  //   F[recov_ot5]: 12:12
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_ot5 (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_ot5_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_ot5.qe),
    .q      (reg2hw.alert_test.recov_ot5.q),
    .qs     ()
  );


  // R[cfg_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_cfg_regwen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_regwen_we),
    .wd     (cfg_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

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
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[0].q),

    // to register interface (read)
    .qs     (ack_mode_val_0_qs)
  );


  // F[val_1]: 3:2
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[1].q),

    // to register interface (read)
    .qs     (ack_mode_val_1_qs)
  );


  // F[val_2]: 5:4
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[2].q),

    // to register interface (read)
    .qs     (ack_mode_val_2_qs)
  );


  // F[val_3]: 7:6
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[3].q),

    // to register interface (read)
    .qs     (ack_mode_val_3_qs)
  );


  // F[val_4]: 9:8
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[4].q),

    // to register interface (read)
    .qs     (ack_mode_val_4_qs)
  );


  // F[val_5]: 11:10
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[5].q),

    // to register interface (read)
    .qs     (ack_mode_val_5_qs)
  );


  // F[val_6]: 13:12
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_6 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[6].q),

    // to register interface (read)
    .qs     (ack_mode_val_6_qs)
  );


  // F[val_7]: 15:14
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_7 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[7].q),

    // to register interface (read)
    .qs     (ack_mode_val_7_qs)
  );


  // F[val_8]: 17:16
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_8 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[8].q),

    // to register interface (read)
    .qs     (ack_mode_val_8_qs)
  );


  // F[val_9]: 19:18
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_9 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_9_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[9].q),

    // to register interface (read)
    .qs     (ack_mode_val_9_qs)
  );


  // F[val_10]: 21:20
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_10 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_10_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[10].q),

    // to register interface (read)
    .qs     (ack_mode_val_10_qs)
  );


  // F[val_11]: 23:22
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_11 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_11_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[11].q),

    // to register interface (read)
    .qs     (ack_mode_val_11_qs)
  );


  // F[val_12]: 25:24
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h0)
  ) u_ack_mode_val_12 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ack_mode_we & cfg_regwen_qs),
    .wd     (ack_mode_val_12_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ack_mode[12].q),

    // to register interface (read)
    .qs     (ack_mode_val_12_qs)
  );




  // Subregister 0 of Multireg alert_trig
  // R[alert_trig]: V(False)

  // F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[0].q),

    // to register interface (read)
    .qs     (alert_trig_val_0_qs)
  );


  // F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[1].q),

    // to register interface (read)
    .qs     (alert_trig_val_1_qs)
  );


  // F[val_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[2].q),

    // to register interface (read)
    .qs     (alert_trig_val_2_qs)
  );


  // F[val_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[3].q),

    // to register interface (read)
    .qs     (alert_trig_val_3_qs)
  );


  // F[val_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[4].q),

    // to register interface (read)
    .qs     (alert_trig_val_4_qs)
  );


  // F[val_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[5].q),

    // to register interface (read)
    .qs     (alert_trig_val_5_qs)
  );


  // F[val_6]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_6 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[6].q),

    // to register interface (read)
    .qs     (alert_trig_val_6_qs)
  );


  // F[val_7]: 7:7
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_7 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[7].q),

    // to register interface (read)
    .qs     (alert_trig_val_7_qs)
  );


  // F[val_8]: 8:8
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_8 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_8_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[8].q),

    // to register interface (read)
    .qs     (alert_trig_val_8_qs)
  );


  // F[val_9]: 9:9
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_9 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_9_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[9].q),

    // to register interface (read)
    .qs     (alert_trig_val_9_qs)
  );


  // F[val_10]: 10:10
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_10 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_10_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[10].q),

    // to register interface (read)
    .qs     (alert_trig_val_10_qs)
  );


  // F[val_11]: 11:11
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_11 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_11_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[11].q),

    // to register interface (read)
    .qs     (alert_trig_val_11_qs)
  );


  // F[val_12]: 12:12
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_trig_val_12 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_trig_we),
    .wd     (alert_trig_val_12_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_trig[12].q),

    // to register interface (read)
    .qs     (alert_trig_val_12_qs)
  );




  // Subregister 0 of Multireg alert_state
  // R[alert_state]: V(False)

  // F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_0_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[0].de),
    .d      (hw2reg.alert_state[0].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[0].qe),
    .q      (reg2hw.alert_state[0].q),

    // to register interface (read)
    .qs     (alert_state_val_0_qs)
  );


  // F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_1_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[1].de),
    .d      (hw2reg.alert_state[1].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[1].qe),
    .q      (reg2hw.alert_state[1].q),

    // to register interface (read)
    .qs     (alert_state_val_1_qs)
  );


  // F[val_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_2_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[2].de),
    .d      (hw2reg.alert_state[2].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[2].qe),
    .q      (reg2hw.alert_state[2].q),

    // to register interface (read)
    .qs     (alert_state_val_2_qs)
  );


  // F[val_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_3_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[3].de),
    .d      (hw2reg.alert_state[3].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[3].qe),
    .q      (reg2hw.alert_state[3].q),

    // to register interface (read)
    .qs     (alert_state_val_3_qs)
  );


  // F[val_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_4_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[4].de),
    .d      (hw2reg.alert_state[4].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[4].qe),
    .q      (reg2hw.alert_state[4].q),

    // to register interface (read)
    .qs     (alert_state_val_4_qs)
  );


  // F[val_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_5_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[5].de),
    .d      (hw2reg.alert_state[5].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[5].qe),
    .q      (reg2hw.alert_state[5].q),

    // to register interface (read)
    .qs     (alert_state_val_5_qs)
  );


  // F[val_6]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_6 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_6_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[6].de),
    .d      (hw2reg.alert_state[6].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[6].qe),
    .q      (reg2hw.alert_state[6].q),

    // to register interface (read)
    .qs     (alert_state_val_6_qs)
  );


  // F[val_7]: 7:7
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_7 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_7_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[7].de),
    .d      (hw2reg.alert_state[7].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[7].qe),
    .q      (reg2hw.alert_state[7].q),

    // to register interface (read)
    .qs     (alert_state_val_7_qs)
  );


  // F[val_8]: 8:8
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_8 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_8_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[8].de),
    .d      (hw2reg.alert_state[8].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[8].qe),
    .q      (reg2hw.alert_state[8].q),

    // to register interface (read)
    .qs     (alert_state_val_8_qs)
  );


  // F[val_9]: 9:9
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_9 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_9_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[9].de),
    .d      (hw2reg.alert_state[9].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[9].qe),
    .q      (reg2hw.alert_state[9].q),

    // to register interface (read)
    .qs     (alert_state_val_9_qs)
  );


  // F[val_10]: 10:10
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_10 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_10_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[10].de),
    .d      (hw2reg.alert_state[10].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[10].qe),
    .q      (reg2hw.alert_state[10].q),

    // to register interface (read)
    .qs     (alert_state_val_10_qs)
  );


  // F[val_11]: 11:11
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_11 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_11_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[11].de),
    .d      (hw2reg.alert_state[11].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[11].qe),
    .q      (reg2hw.alert_state[11].q),

    // to register interface (read)
    .qs     (alert_state_val_11_qs)
  );


  // F[val_12]: 12:12
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_alert_state_val_12 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (alert_state_we),
    .wd     (alert_state_val_12_wd),

    // from internal hardware
    .de     (hw2reg.alert_state[12].de),
    .d      (hw2reg.alert_state[12].d),

    // to internal hardware
    .qe     (reg2hw.alert_state[12].qe),
    .q      (reg2hw.alert_state[12].q),

    // to register interface (read)
    .qs     (alert_state_val_12_qs)
  );



  // R[status]: V(False)

  //   F[ast_init_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_status_ast_init_done (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.status.ast_init_done.de),
    .d      (hw2reg.status.ast_init_done.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (status_ast_init_done_qs)
  );


  //   F[io_pok]: 2:1
  prim_subreg #(
    .DW      (2),
    .SWACCESS("RO"),
    .RESVAL  (2'h3)
  ) u_status_io_pok (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.status.io_pok.de),
    .d      (hw2reg.status.io_pok.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (status_io_pok_qs)
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
    wr_err = (reg_we &
              ((addr_hit[0] & (|(SENSOR_CTRL_PERMIT[0] & ~reg_be))) |
               (addr_hit[1] & (|(SENSOR_CTRL_PERMIT[1] & ~reg_be))) |
               (addr_hit[2] & (|(SENSOR_CTRL_PERMIT[2] & ~reg_be))) |
               (addr_hit[3] & (|(SENSOR_CTRL_PERMIT[3] & ~reg_be))) |
               (addr_hit[4] & (|(SENSOR_CTRL_PERMIT[4] & ~reg_be))) |
               (addr_hit[5] & (|(SENSOR_CTRL_PERMIT[5] & ~reg_be)))));
  end
  assign alert_test_we = addr_hit[0] & reg_we & !reg_error;

  assign alert_test_recov_as_wd = reg_wdata[0];

  assign alert_test_recov_cg_wd = reg_wdata[1];

  assign alert_test_recov_gd_wd = reg_wdata[2];

  assign alert_test_recov_ts_hi_wd = reg_wdata[3];

  assign alert_test_recov_ts_lo_wd = reg_wdata[4];

  assign alert_test_recov_fla_wd = reg_wdata[5];

  assign alert_test_recov_otp_wd = reg_wdata[6];

  assign alert_test_recov_ot0_wd = reg_wdata[7];

  assign alert_test_recov_ot1_wd = reg_wdata[8];

  assign alert_test_recov_ot2_wd = reg_wdata[9];

  assign alert_test_recov_ot3_wd = reg_wdata[10];

  assign alert_test_recov_ot4_wd = reg_wdata[11];

  assign alert_test_recov_ot5_wd = reg_wdata[12];
  assign cfg_regwen_we = addr_hit[1] & reg_we & !reg_error;

  assign cfg_regwen_wd = reg_wdata[0];
  assign ack_mode_we = addr_hit[2] & reg_we & !reg_error;

  assign ack_mode_val_0_wd = reg_wdata[1:0];

  assign ack_mode_val_1_wd = reg_wdata[3:2];

  assign ack_mode_val_2_wd = reg_wdata[5:4];

  assign ack_mode_val_3_wd = reg_wdata[7:6];

  assign ack_mode_val_4_wd = reg_wdata[9:8];

  assign ack_mode_val_5_wd = reg_wdata[11:10];

  assign ack_mode_val_6_wd = reg_wdata[13:12];

  assign ack_mode_val_7_wd = reg_wdata[15:14];

  assign ack_mode_val_8_wd = reg_wdata[17:16];

  assign ack_mode_val_9_wd = reg_wdata[19:18];

  assign ack_mode_val_10_wd = reg_wdata[21:20];

  assign ack_mode_val_11_wd = reg_wdata[23:22];

  assign ack_mode_val_12_wd = reg_wdata[25:24];
  assign alert_trig_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_trig_val_0_wd = reg_wdata[0];

  assign alert_trig_val_1_wd = reg_wdata[1];

  assign alert_trig_val_2_wd = reg_wdata[2];

  assign alert_trig_val_3_wd = reg_wdata[3];

  assign alert_trig_val_4_wd = reg_wdata[4];

  assign alert_trig_val_5_wd = reg_wdata[5];

  assign alert_trig_val_6_wd = reg_wdata[6];

  assign alert_trig_val_7_wd = reg_wdata[7];

  assign alert_trig_val_8_wd = reg_wdata[8];

  assign alert_trig_val_9_wd = reg_wdata[9];

  assign alert_trig_val_10_wd = reg_wdata[10];

  assign alert_trig_val_11_wd = reg_wdata[11];

  assign alert_trig_val_12_wd = reg_wdata[12];
  assign alert_state_we = addr_hit[4] & reg_we & !reg_error;

  assign alert_state_val_0_wd = reg_wdata[0];

  assign alert_state_val_1_wd = reg_wdata[1];

  assign alert_state_val_2_wd = reg_wdata[2];

  assign alert_state_val_3_wd = reg_wdata[3];

  assign alert_state_val_4_wd = reg_wdata[4];

  assign alert_state_val_5_wd = reg_wdata[5];

  assign alert_state_val_6_wd = reg_wdata[6];

  assign alert_state_val_7_wd = reg_wdata[7];

  assign alert_state_val_8_wd = reg_wdata[8];

  assign alert_state_val_9_wd = reg_wdata[9];

  assign alert_state_val_10_wd = reg_wdata[10];

  assign alert_state_val_11_wd = reg_wdata[11];

  assign alert_state_val_12_wd = reg_wdata[12];

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
        reg_rdata_next[7] = '0;
        reg_rdata_next[8] = '0;
        reg_rdata_next[9] = '0;
        reg_rdata_next[10] = '0;
        reg_rdata_next[11] = '0;
        reg_rdata_next[12] = '0;
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
        reg_rdata_next[15:14] = ack_mode_val_7_qs;
        reg_rdata_next[17:16] = ack_mode_val_8_qs;
        reg_rdata_next[19:18] = ack_mode_val_9_qs;
        reg_rdata_next[21:20] = ack_mode_val_10_qs;
        reg_rdata_next[23:22] = ack_mode_val_11_qs;
        reg_rdata_next[25:24] = ack_mode_val_12_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = alert_trig_val_0_qs;
        reg_rdata_next[1] = alert_trig_val_1_qs;
        reg_rdata_next[2] = alert_trig_val_2_qs;
        reg_rdata_next[3] = alert_trig_val_3_qs;
        reg_rdata_next[4] = alert_trig_val_4_qs;
        reg_rdata_next[5] = alert_trig_val_5_qs;
        reg_rdata_next[6] = alert_trig_val_6_qs;
        reg_rdata_next[7] = alert_trig_val_7_qs;
        reg_rdata_next[8] = alert_trig_val_8_qs;
        reg_rdata_next[9] = alert_trig_val_9_qs;
        reg_rdata_next[10] = alert_trig_val_10_qs;
        reg_rdata_next[11] = alert_trig_val_11_qs;
        reg_rdata_next[12] = alert_trig_val_12_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = alert_state_val_0_qs;
        reg_rdata_next[1] = alert_state_val_1_qs;
        reg_rdata_next[2] = alert_state_val_2_qs;
        reg_rdata_next[3] = alert_state_val_3_qs;
        reg_rdata_next[4] = alert_state_val_4_qs;
        reg_rdata_next[5] = alert_state_val_5_qs;
        reg_rdata_next[6] = alert_state_val_6_qs;
        reg_rdata_next[7] = alert_state_val_7_qs;
        reg_rdata_next[8] = alert_state_val_8_qs;
        reg_rdata_next[9] = alert_state_val_9_qs;
        reg_rdata_next[10] = alert_state_val_10_qs;
        reg_rdata_next[11] = alert_state_val_11_qs;
        reg_rdata_next[12] = alert_state_val_12_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = status_ast_init_done_qs;
        reg_rdata_next[2:1] = status_io_pok_qs;
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
