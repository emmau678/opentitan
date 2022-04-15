// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module pwrmgr_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output pwrmgr_reg_pkg::pwrmgr_reg2hw_t reg2hw, // Write
  input  pwrmgr_reg_pkg::pwrmgr_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import pwrmgr_reg_pkg::* ;

  localparam int AW = 7;
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
  logic reg_busy;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;


  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i(tl_i),
    .err_o(intg_err)
  );

  // also check for spurious write enables
  logic reg_we_err;
  logic [16:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(17)
  ) u_prim_reg_we_check (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .oh_i  (reg_we_check),
    .en_i  (reg_we && !addrmiss),
    .err_o (reg_we_err)
  );

  logic err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= '0;
    end else if (intg_err || reg_we_err) begin
      err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = err_q | intg_err | reg_we_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
  ) u_reg_if (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .busy_i  (reg_busy),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_qs;
  logic intr_state_wd;
  logic intr_enable_we;
  logic intr_enable_qs;
  logic intr_enable_wd;
  logic intr_test_we;
  logic intr_test_wd;
  logic alert_test_we;
  logic alert_test_wd;
  logic ctrl_cfg_regwen_re;
  logic ctrl_cfg_regwen_qs;
  logic control_we;
  logic control_low_power_hint_qs;
  logic control_low_power_hint_wd;
  logic control_core_clk_en_qs;
  logic control_core_clk_en_wd;
  logic control_io_clk_en_qs;
  logic control_io_clk_en_wd;
  logic control_usb_clk_en_lp_qs;
  logic control_usb_clk_en_lp_wd;
  logic control_usb_clk_en_active_qs;
  logic control_usb_clk_en_active_wd;
  logic control_main_pd_n_qs;
  logic control_main_pd_n_wd;
  logic cfg_cdc_sync_we;
  logic cfg_cdc_sync_qs;
  logic cfg_cdc_sync_wd;
  logic wakeup_en_regwen_we;
  logic wakeup_en_regwen_qs;
  logic wakeup_en_regwen_wd;
  logic wakeup_en_we;
  logic wakeup_en_en_0_qs;
  logic wakeup_en_en_0_wd;
  logic wakeup_en_en_1_qs;
  logic wakeup_en_en_1_wd;
  logic wakeup_en_en_2_qs;
  logic wakeup_en_en_2_wd;
  logic wakeup_en_en_3_qs;
  logic wakeup_en_en_3_wd;
  logic wakeup_en_en_4_qs;
  logic wakeup_en_en_4_wd;
  logic wakeup_en_en_5_qs;
  logic wakeup_en_en_5_wd;
  logic wake_status_val_0_qs;
  logic wake_status_val_1_qs;
  logic wake_status_val_2_qs;
  logic wake_status_val_3_qs;
  logic wake_status_val_4_qs;
  logic wake_status_val_5_qs;
  logic reset_en_regwen_we;
  logic reset_en_regwen_qs;
  logic reset_en_regwen_wd;
  logic reset_en_we;
  logic reset_en_en_0_qs;
  logic reset_en_en_0_wd;
  logic reset_en_en_1_qs;
  logic reset_en_en_1_wd;
  logic reset_status_val_0_qs;
  logic reset_status_val_1_qs;
  logic escalate_reset_status_qs;
  logic wake_info_capture_dis_we;
  logic wake_info_capture_dis_qs;
  logic wake_info_capture_dis_wd;
  logic wake_info_re;
  logic wake_info_we;
  logic [5:0] wake_info_reasons_qs;
  logic [5:0] wake_info_reasons_wd;
  logic wake_info_fall_through_qs;
  logic wake_info_fall_through_wd;
  logic wake_info_abort_qs;
  logic wake_info_abort_wd;
  logic fault_status_reg_intg_err_qs;
  logic fault_status_esc_timeout_qs;
  logic fault_status_main_pd_glitch_qs;

  // Register instances
  // R[intr_state]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.de),
    .d      (hw2reg.intr_state.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.q),

    // to register interface (read)
    .qs     (intr_state_qs)
  );


  // R[intr_enable]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.q),

    // to register interface (read)
    .qs     (intr_enable_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [0:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.q),
    .qs     ()
  );
  assign reg2hw.intr_test.qe = intr_test_qe;


  // R[alert_test]: V(True)
  logic alert_test_qe;
  logic [0:0] alert_test_flds_we;
  assign alert_test_qe = &alert_test_flds_we;
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[0]),
    .q      (reg2hw.alert_test.q),
    .qs     ()
  );
  assign reg2hw.alert_test.qe = alert_test_qe;


  // R[ctrl_cfg_regwen]: V(True)
  prim_subreg_ext #(
    .DW    (1)
  ) u_ctrl_cfg_regwen (
    .re     (ctrl_cfg_regwen_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.ctrl_cfg_regwen.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (ctrl_cfg_regwen_qs)
  );


  // R[control]: V(False)
  // Create REGWEN-gated WE signal
  logic control_gated_we;
  assign control_gated_we = control_we & ctrl_cfg_regwen_qs;
  //   F[low_power_hint]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_control_low_power_hint (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_low_power_hint_wd),

    // from internal hardware
    .de     (hw2reg.control.low_power_hint.de),
    .d      (hw2reg.control.low_power_hint.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.low_power_hint.q),

    // to register interface (read)
    .qs     (control_low_power_hint_qs)
  );

  //   F[core_clk_en]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_control_core_clk_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_core_clk_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.core_clk_en.q),

    // to register interface (read)
    .qs     (control_core_clk_en_qs)
  );

  //   F[io_clk_en]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_control_io_clk_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_io_clk_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.io_clk_en.q),

    // to register interface (read)
    .qs     (control_io_clk_en_qs)
  );

  //   F[usb_clk_en_lp]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_control_usb_clk_en_lp (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_usb_clk_en_lp_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.usb_clk_en_lp.q),

    // to register interface (read)
    .qs     (control_usb_clk_en_lp_qs)
  );

  //   F[usb_clk_en_active]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1)
  ) u_control_usb_clk_en_active (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_usb_clk_en_active_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.usb_clk_en_active.q),

    // to register interface (read)
    .qs     (control_usb_clk_en_active_qs)
  );

  //   F[main_pd_n]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1)
  ) u_control_main_pd_n (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_gated_we),
    .wd     (control_main_pd_n_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.main_pd_n.q),

    // to register interface (read)
    .qs     (control_main_pd_n_qs)
  );


  // R[cfg_cdc_sync]: V(False)
  logic cfg_cdc_sync_qe;
  logic [0:0] cfg_cdc_sync_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_cfg_cdc_sync0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&cfg_cdc_sync_flds_we),
    .q_o(cfg_cdc_sync_qe)
  );
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_cfg_cdc_sync (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_cdc_sync_we),
    .wd     (cfg_cdc_sync_wd),

    // from internal hardware
    .de     (hw2reg.cfg_cdc_sync.de),
    .d      (hw2reg.cfg_cdc_sync.d),

    // to internal hardware
    .qe     (cfg_cdc_sync_flds_we[0]),
    .q      (reg2hw.cfg_cdc_sync.q),

    // to register interface (read)
    .qs     (cfg_cdc_sync_qs)
  );
  assign reg2hw.cfg_cdc_sync.qe = cfg_cdc_sync_qe;


  // R[wakeup_en_regwen]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h1)
  ) u_wakeup_en_regwen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_regwen_we),
    .wd     (wakeup_en_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wakeup_en_regwen_qs)
  );


  // Subregister 0 of Multireg wakeup_en
  // R[wakeup_en]: V(False)
  // Create REGWEN-gated WE signal
  logic wakeup_en_gated_we;
  assign wakeup_en_gated_we = wakeup_en_we & wakeup_en_regwen_qs;
  //   F[en_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[0].q),

    // to register interface (read)
    .qs     (wakeup_en_en_0_qs)
  );

  //   F[en_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[1].q),

    // to register interface (read)
    .qs     (wakeup_en_en_1_qs)
  );

  //   F[en_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[2].q),

    // to register interface (read)
    .qs     (wakeup_en_en_2_qs)
  );

  //   F[en_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[3].q),

    // to register interface (read)
    .qs     (wakeup_en_en_3_qs)
  );

  //   F[en_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[4].q),

    // to register interface (read)
    .qs     (wakeup_en_en_4_qs)
  );

  //   F[en_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wakeup_en_en_5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_en_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[5].q),

    // to register interface (read)
    .qs     (wakeup_en_en_5_qs)
  );


  // Subregister 0 of Multireg wake_status
  // R[wake_status]: V(False)
  //   F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[0].de),
    .d      (hw2reg.wake_status[0].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_0_qs)
  );

  //   F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[1].de),
    .d      (hw2reg.wake_status[1].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_1_qs)
  );

  //   F[val_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[2].de),
    .d      (hw2reg.wake_status[2].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_2_qs)
  );

  //   F[val_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[3].de),
    .d      (hw2reg.wake_status[3].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_3_qs)
  );

  //   F[val_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_4 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[4].de),
    .d      (hw2reg.wake_status[4].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_4_qs)
  );

  //   F[val_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_wake_status_val_5 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.wake_status[5].de),
    .d      (hw2reg.wake_status[5].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wake_status_val_5_qs)
  );


  // R[reset_en_regwen]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h1)
  ) u_reset_en_regwen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (reset_en_regwen_we),
    .wd     (reset_en_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_en_regwen_qs)
  );


  // Subregister 0 of Multireg reset_en
  // R[reset_en]: V(False)
  // Create REGWEN-gated WE signal
  logic reset_en_gated_we;
  assign reset_en_gated_we = reset_en_we & reset_en_regwen_qs;
  //   F[en_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_reset_en_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (reset_en_gated_we),
    .wd     (reset_en_en_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.reset_en[0].q),

    // to register interface (read)
    .qs     (reset_en_en_0_qs)
  );

  //   F[en_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_reset_en_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (reset_en_gated_we),
    .wd     (reset_en_en_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.reset_en[1].q),

    // to register interface (read)
    .qs     (reset_en_en_1_qs)
  );


  // Subregister 0 of Multireg reset_status
  // R[reset_status]: V(False)
  //   F[val_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_reset_status_val_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.reset_status[0].de),
    .d      (hw2reg.reset_status[0].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_status_val_0_qs)
  );

  //   F[val_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_reset_status_val_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.reset_status[1].de),
    .d      (hw2reg.reset_status[1].d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_status_val_1_qs)
  );


  // R[escalate_reset_status]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_escalate_reset_status (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.escalate_reset_status.de),
    .d      (hw2reg.escalate_reset_status.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (escalate_reset_status_qs)
  );


  // R[wake_info_capture_dis]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_wake_info_capture_dis (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wake_info_capture_dis_we),
    .wd     (wake_info_capture_dis_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wake_info_capture_dis.q),

    // to register interface (read)
    .qs     (wake_info_capture_dis_qs)
  );


  // R[wake_info]: V(True)
  logic wake_info_qe;
  logic [2:0] wake_info_flds_we;
  assign wake_info_qe = &wake_info_flds_we;
  //   F[reasons]: 5:0
  prim_subreg_ext #(
    .DW    (6)
  ) u_wake_info_reasons (
    .re     (wake_info_re),
    .we     (wake_info_we),
    .wd     (wake_info_reasons_wd),
    .d      (hw2reg.wake_info.reasons.d),
    .qre    (),
    .qe     (wake_info_flds_we[0]),
    .q      (reg2hw.wake_info.reasons.q),
    .qs     (wake_info_reasons_qs)
  );
  assign reg2hw.wake_info.reasons.qe = wake_info_qe;

  //   F[fall_through]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_wake_info_fall_through (
    .re     (wake_info_re),
    .we     (wake_info_we),
    .wd     (wake_info_fall_through_wd),
    .d      (hw2reg.wake_info.fall_through.d),
    .qre    (),
    .qe     (wake_info_flds_we[1]),
    .q      (reg2hw.wake_info.fall_through.q),
    .qs     (wake_info_fall_through_qs)
  );
  assign reg2hw.wake_info.fall_through.qe = wake_info_qe;

  //   F[abort]: 7:7
  prim_subreg_ext #(
    .DW    (1)
  ) u_wake_info_abort (
    .re     (wake_info_re),
    .we     (wake_info_we),
    .wd     (wake_info_abort_wd),
    .d      (hw2reg.wake_info.abort.d),
    .qre    (),
    .qe     (wake_info_flds_we[2]),
    .q      (reg2hw.wake_info.abort.q),
    .qs     (wake_info_abort_qs)
  );
  assign reg2hw.wake_info.abort.qe = wake_info_qe;


  // R[fault_status]: V(False)
  //   F[reg_intg_err]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fault_status_reg_intg_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fault_status.reg_intg_err.de),
    .d      (hw2reg.fault_status.reg_intg_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.fault_status.reg_intg_err.q),

    // to register interface (read)
    .qs     (fault_status_reg_intg_err_qs)
  );

  //   F[esc_timeout]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fault_status_esc_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fault_status.esc_timeout.de),
    .d      (hw2reg.fault_status.esc_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.fault_status.esc_timeout.q),

    // to register interface (read)
    .qs     (fault_status_esc_timeout_qs)
  );

  //   F[main_pd_glitch]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fault_status_main_pd_glitch (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fault_status.main_pd_glitch.de),
    .d      (hw2reg.fault_status.main_pd_glitch.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.fault_status.main_pd_glitch.q),

    // to register interface (read)
    .qs     (fault_status_main_pd_glitch_qs)
  );



  logic [16:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == PWRMGR_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == PWRMGR_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == PWRMGR_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == PWRMGR_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == PWRMGR_CTRL_CFG_REGWEN_OFFSET);
    addr_hit[ 5] = (reg_addr == PWRMGR_CONTROL_OFFSET);
    addr_hit[ 6] = (reg_addr == PWRMGR_CFG_CDC_SYNC_OFFSET);
    addr_hit[ 7] = (reg_addr == PWRMGR_WAKEUP_EN_REGWEN_OFFSET);
    addr_hit[ 8] = (reg_addr == PWRMGR_WAKEUP_EN_OFFSET);
    addr_hit[ 9] = (reg_addr == PWRMGR_WAKE_STATUS_OFFSET);
    addr_hit[10] = (reg_addr == PWRMGR_RESET_EN_REGWEN_OFFSET);
    addr_hit[11] = (reg_addr == PWRMGR_RESET_EN_OFFSET);
    addr_hit[12] = (reg_addr == PWRMGR_RESET_STATUS_OFFSET);
    addr_hit[13] = (reg_addr == PWRMGR_ESCALATE_RESET_STATUS_OFFSET);
    addr_hit[14] = (reg_addr == PWRMGR_WAKE_INFO_CAPTURE_DIS_OFFSET);
    addr_hit[15] = (reg_addr == PWRMGR_WAKE_INFO_OFFSET);
    addr_hit[16] = (reg_addr == PWRMGR_FAULT_STATUS_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(PWRMGR_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(PWRMGR_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(PWRMGR_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(PWRMGR_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(PWRMGR_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(PWRMGR_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(PWRMGR_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(PWRMGR_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(PWRMGR_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(PWRMGR_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(PWRMGR_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(PWRMGR_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(PWRMGR_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(PWRMGR_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(PWRMGR_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(PWRMGR_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(PWRMGR_PERMIT[16] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_wd = reg_wdata[0];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_wd = reg_wdata[0];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_wd = reg_wdata[0];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign ctrl_cfg_regwen_re = addr_hit[4] & reg_re & !reg_error;
  assign control_we = addr_hit[5] & reg_we & !reg_error;

  assign control_low_power_hint_wd = reg_wdata[0];

  assign control_core_clk_en_wd = reg_wdata[4];

  assign control_io_clk_en_wd = reg_wdata[5];

  assign control_usb_clk_en_lp_wd = reg_wdata[6];

  assign control_usb_clk_en_active_wd = reg_wdata[7];

  assign control_main_pd_n_wd = reg_wdata[8];
  assign cfg_cdc_sync_we = addr_hit[6] & reg_we & !reg_error;

  assign cfg_cdc_sync_wd = reg_wdata[0];
  assign wakeup_en_regwen_we = addr_hit[7] & reg_we & !reg_error;

  assign wakeup_en_regwen_wd = reg_wdata[0];
  assign wakeup_en_we = addr_hit[8] & reg_we & !reg_error;

  assign wakeup_en_en_0_wd = reg_wdata[0];

  assign wakeup_en_en_1_wd = reg_wdata[1];

  assign wakeup_en_en_2_wd = reg_wdata[2];

  assign wakeup_en_en_3_wd = reg_wdata[3];

  assign wakeup_en_en_4_wd = reg_wdata[4];

  assign wakeup_en_en_5_wd = reg_wdata[5];
  assign reset_en_regwen_we = addr_hit[10] & reg_we & !reg_error;

  assign reset_en_regwen_wd = reg_wdata[0];
  assign reset_en_we = addr_hit[11] & reg_we & !reg_error;

  assign reset_en_en_0_wd = reg_wdata[0];

  assign reset_en_en_1_wd = reg_wdata[1];
  assign wake_info_capture_dis_we = addr_hit[14] & reg_we & !reg_error;

  assign wake_info_capture_dis_wd = reg_wdata[0];
  assign wake_info_re = addr_hit[15] & reg_re & !reg_error;
  assign wake_info_we = addr_hit[15] & reg_we & !reg_error;

  assign wake_info_reasons_wd = reg_wdata[5:0];

  assign wake_info_fall_through_wd = reg_wdata[6];

  assign wake_info_abort_wd = reg_wdata[7];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check = '0;
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = alert_test_we;
    reg_we_check[4] = 1'b0;
    reg_we_check[5] = control_gated_we;
    reg_we_check[6] = cfg_cdc_sync_we;
    reg_we_check[7] = wakeup_en_regwen_we;
    reg_we_check[8] = wakeup_en_gated_we;
    reg_we_check[9] = 1'b0;
    reg_we_check[10] = reset_en_regwen_we;
    reg_we_check[11] = reset_en_gated_we;
    reg_we_check[12] = 1'b0;
    reg_we_check[13] = 1'b0;
    reg_we_check[14] = wake_info_capture_dis_we;
    reg_we_check[15] = wake_info_we;
    reg_we_check[16] = 1'b0;
  end

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ctrl_cfg_regwen_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = control_low_power_hint_qs;
        reg_rdata_next[4] = control_core_clk_en_qs;
        reg_rdata_next[5] = control_io_clk_en_qs;
        reg_rdata_next[6] = control_usb_clk_en_lp_qs;
        reg_rdata_next[7] = control_usb_clk_en_active_qs;
        reg_rdata_next[8] = control_main_pd_n_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = cfg_cdc_sync_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[0] = wakeup_en_regwen_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = wakeup_en_en_0_qs;
        reg_rdata_next[1] = wakeup_en_en_1_qs;
        reg_rdata_next[2] = wakeup_en_en_2_qs;
        reg_rdata_next[3] = wakeup_en_en_3_qs;
        reg_rdata_next[4] = wakeup_en_en_4_qs;
        reg_rdata_next[5] = wakeup_en_en_5_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[0] = wake_status_val_0_qs;
        reg_rdata_next[1] = wake_status_val_1_qs;
        reg_rdata_next[2] = wake_status_val_2_qs;
        reg_rdata_next[3] = wake_status_val_3_qs;
        reg_rdata_next[4] = wake_status_val_4_qs;
        reg_rdata_next[5] = wake_status_val_5_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = reset_en_regwen_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[0] = reset_en_en_0_qs;
        reg_rdata_next[1] = reset_en_en_1_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[0] = reset_status_val_0_qs;
        reg_rdata_next[1] = reset_status_val_1_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = escalate_reset_status_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[0] = wake_info_capture_dis_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[5:0] = wake_info_reasons_qs;
        reg_rdata_next[6] = wake_info_fall_through_qs;
        reg_rdata_next[7] = wake_info_abort_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[0] = fault_status_reg_intg_err_qs;
        reg_rdata_next[1] = fault_status_esc_timeout_qs;
        reg_rdata_next[2] = fault_status_main_pd_glitch_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // shadow busy
  logic shadow_busy;
  assign shadow_busy = 1'b0;

  // register busy
  assign reg_busy = shadow_busy;

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o_pre.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
