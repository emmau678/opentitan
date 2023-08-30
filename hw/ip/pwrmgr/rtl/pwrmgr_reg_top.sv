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

  localparam int AW = 6;
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
  logic [13:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(14)
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

    .en_ifetch_i(prim_mubi_pkg::MuBi4False),
    .intg_error_o(),

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
  logic wakeup_en_qs;
  logic wakeup_en_wd;
  logic wake_status_qs;
  logic reset_en_regwen_we;
  logic reset_en_regwen_qs;
  logic reset_en_regwen_wd;
  logic reset_en_we;
  logic reset_en_qs;
  logic reset_en_wd;
  logic reset_status_qs;
  logic wake_info_capture_dis_we;
  logic wake_info_capture_dis_qs;
  logic wake_info_capture_dis_wd;
  logic wake_info_re;
  logic wake_info_we;
  logic wake_info_reasons_qs;
  logic wake_info_reasons_wd;
  logic wake_info_fall_through_qs;
  logic wake_info_fall_through_wd;
  logic wake_info_abort_qs;
  logic wake_info_abort_wd;

  // Register instances
  // R[intr_state]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_qs)
  );


  // R[intr_enable]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

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
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.qe = intr_test_qe;


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
    .ds     (),
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
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (control_low_power_hint_qs)
  );

  //   F[core_clk_en]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (control_core_clk_en_qs)
  );

  //   F[io_clk_en]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (control_io_clk_en_qs)
  );

  //   F[usb_clk_en_lp]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (control_usb_clk_en_lp_qs)
  );

  //   F[usb_clk_en_active]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (control_usb_clk_en_active_qs)
  );

  //   F[main_pd_n]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
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
    .ds     (),

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
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (cfg_cdc_sync_qs)
  );
  assign reg2hw.cfg_cdc_sync.qe = cfg_cdc_sync_qe;


  // R[wakeup_en_regwen]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (wakeup_en_regwen_qs)
  );


  // Subregister 0 of Multireg wakeup_en
  // R[wakeup_en]: V(False)
  // Create REGWEN-gated WE signal
  logic wakeup_en_gated_we;
  assign wakeup_en_gated_we = wakeup_en_we & wakeup_en_regwen_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_wakeup_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wakeup_en_gated_we),
    .wd     (wakeup_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.wakeup_en[0].q),
    .ds     (),

    // to register interface (read)
    .qs     (wakeup_en_qs)
  );


  // Subregister 0 of Multireg wake_status
  // R[wake_status]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_wake_status (
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
    .ds     (),

    // to register interface (read)
    .qs     (wake_status_qs)
  );


  // R[reset_en_regwen]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (reset_en_regwen_qs)
  );


  // Subregister 0 of Multireg reset_en
  // R[reset_en]: V(False)
  // Create REGWEN-gated WE signal
  logic reset_en_gated_we;
  assign reset_en_gated_we = reset_en_we & reset_en_regwen_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_reset_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (reset_en_gated_we),
    .wd     (reset_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.reset_en[0].q),
    .ds     (),

    // to register interface (read)
    .qs     (reset_en_qs)
  );


  // Subregister 0 of Multireg reset_status
  // R[reset_status]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_reset_status (
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
    .ds     (),

    // to register interface (read)
    .qs     (reset_status_qs)
  );


  // R[wake_info_capture_dis]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
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
    .ds     (),

    // to register interface (read)
    .qs     (wake_info_capture_dis_qs)
  );


  // R[wake_info]: V(True)
  logic wake_info_qe;
  logic [2:0] wake_info_flds_we;
  assign wake_info_qe = &wake_info_flds_we;
  //   F[reasons]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_wake_info_reasons (
    .re     (wake_info_re),
    .we     (wake_info_we),
    .wd     (wake_info_reasons_wd),
    .d      (hw2reg.wake_info.reasons.d),
    .qre    (),
    .qe     (wake_info_flds_we[0]),
    .q      (reg2hw.wake_info.reasons.q),
    .ds     (),
    .qs     (wake_info_reasons_qs)
  );
  assign reg2hw.wake_info.reasons.qe = wake_info_qe;

  //   F[fall_through]: 1:1
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
    .ds     (),
    .qs     (wake_info_fall_through_qs)
  );
  assign reg2hw.wake_info.fall_through.qe = wake_info_qe;

  //   F[abort]: 2:2
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
    .ds     (),
    .qs     (wake_info_abort_qs)
  );
  assign reg2hw.wake_info.abort.qe = wake_info_qe;



  logic [13:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == PWRMGR_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == PWRMGR_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == PWRMGR_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == PWRMGR_CTRL_CFG_REGWEN_OFFSET);
    addr_hit[ 4] = (reg_addr == PWRMGR_CONTROL_OFFSET);
    addr_hit[ 5] = (reg_addr == PWRMGR_CFG_CDC_SYNC_OFFSET);
    addr_hit[ 6] = (reg_addr == PWRMGR_WAKEUP_EN_REGWEN_OFFSET);
    addr_hit[ 7] = (reg_addr == PWRMGR_WAKEUP_EN_OFFSET);
    addr_hit[ 8] = (reg_addr == PWRMGR_WAKE_STATUS_OFFSET);
    addr_hit[ 9] = (reg_addr == PWRMGR_RESET_EN_REGWEN_OFFSET);
    addr_hit[10] = (reg_addr == PWRMGR_RESET_EN_OFFSET);
    addr_hit[11] = (reg_addr == PWRMGR_RESET_STATUS_OFFSET);
    addr_hit[12] = (reg_addr == PWRMGR_WAKE_INFO_CAPTURE_DIS_OFFSET);
    addr_hit[13] = (reg_addr == PWRMGR_WAKE_INFO_OFFSET);
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
               (addr_hit[13] & (|(PWRMGR_PERMIT[13] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_wd = reg_wdata[0];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_wd = reg_wdata[0];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_wd = reg_wdata[0];
  assign ctrl_cfg_regwen_re = addr_hit[3] & reg_re & !reg_error;
  assign control_we = addr_hit[4] & reg_we & !reg_error;

  assign control_low_power_hint_wd = reg_wdata[0];

  assign control_core_clk_en_wd = reg_wdata[4];

  assign control_io_clk_en_wd = reg_wdata[5];

  assign control_usb_clk_en_lp_wd = reg_wdata[6];

  assign control_usb_clk_en_active_wd = reg_wdata[7];

  assign control_main_pd_n_wd = reg_wdata[8];
  assign cfg_cdc_sync_we = addr_hit[5] & reg_we & !reg_error;

  assign cfg_cdc_sync_wd = reg_wdata[0];
  assign wakeup_en_regwen_we = addr_hit[6] & reg_we & !reg_error;

  assign wakeup_en_regwen_wd = reg_wdata[0];
  assign wakeup_en_we = addr_hit[7] & reg_we & !reg_error;

  assign wakeup_en_wd = reg_wdata[0];
  assign reset_en_regwen_we = addr_hit[9] & reg_we & !reg_error;

  assign reset_en_regwen_wd = reg_wdata[0];
  assign reset_en_we = addr_hit[10] & reg_we & !reg_error;

  assign reset_en_wd = reg_wdata[0];
  assign wake_info_capture_dis_we = addr_hit[12] & reg_we & !reg_error;

  assign wake_info_capture_dis_wd = reg_wdata[0];
  assign wake_info_re = addr_hit[13] & reg_re & !reg_error;
  assign wake_info_we = addr_hit[13] & reg_we & !reg_error;

  assign wake_info_reasons_wd = reg_wdata[0];

  assign wake_info_fall_through_wd = reg_wdata[1];

  assign wake_info_abort_wd = reg_wdata[2];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check = '0;
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = 1'b0;
    reg_we_check[4] = control_gated_we;
    reg_we_check[5] = cfg_cdc_sync_we;
    reg_we_check[6] = wakeup_en_regwen_we;
    reg_we_check[7] = wakeup_en_gated_we;
    reg_we_check[8] = 1'b0;
    reg_we_check[9] = reset_en_regwen_we;
    reg_we_check[10] = reset_en_gated_we;
    reg_we_check[11] = 1'b0;
    reg_we_check[12] = wake_info_capture_dis_we;
    reg_we_check[13] = wake_info_we;
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
        reg_rdata_next[0] = ctrl_cfg_regwen_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = control_low_power_hint_qs;
        reg_rdata_next[4] = control_core_clk_en_qs;
        reg_rdata_next[5] = control_io_clk_en_qs;
        reg_rdata_next[6] = control_usb_clk_en_lp_qs;
        reg_rdata_next[7] = control_usb_clk_en_active_qs;
        reg_rdata_next[8] = control_main_pd_n_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = cfg_cdc_sync_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = wakeup_en_regwen_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[0] = wakeup_en_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = wake_status_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[0] = reset_en_regwen_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = reset_en_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[0] = reset_status_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[0] = wake_info_capture_dis_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = wake_info_reasons_qs;
        reg_rdata_next[1] = wake_info_fall_through_qs;
        reg_rdata_next[2] = wake_info_abort_qs;
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
