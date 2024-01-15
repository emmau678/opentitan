// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module edn_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output edn_reg_pkg::edn_reg2hw_t reg2hw, // Write
  input  edn_reg_pkg::edn_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o
);

  import edn_reg_pkg::* ;

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
  assign reg_error = addrmiss | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_edn_cmd_req_done_qs;
  logic intr_state_edn_cmd_req_done_wd;
  logic intr_state_edn_fatal_err_qs;
  logic intr_state_edn_fatal_err_wd;
  logic intr_enable_we;
  logic intr_enable_edn_cmd_req_done_qs;
  logic intr_enable_edn_cmd_req_done_wd;
  logic intr_enable_edn_fatal_err_qs;
  logic intr_enable_edn_fatal_err_wd;
  logic intr_test_we;
  logic intr_test_edn_cmd_req_done_wd;
  logic intr_test_edn_fatal_err_wd;
  logic alert_test_we;
  logic alert_test_recov_alert_wd;
  logic alert_test_fatal_alert_wd;
  logic regwen_we;
  logic regwen_qs;
  logic regwen_wd;
  logic ctrl_we;
  logic [3:0] ctrl_edn_enable_qs;
  logic [3:0] ctrl_edn_enable_wd;
  logic [3:0] ctrl_boot_req_mode_qs;
  logic [3:0] ctrl_boot_req_mode_wd;
  logic [3:0] ctrl_auto_req_mode_qs;
  logic [3:0] ctrl_auto_req_mode_wd;
  logic [3:0] ctrl_cmd_fifo_rst_qs;
  logic [3:0] ctrl_cmd_fifo_rst_wd;
  logic boot_ins_cmd_we;
  logic [31:0] boot_ins_cmd_qs;
  logic [31:0] boot_ins_cmd_wd;
  logic boot_gen_cmd_we;
  logic [31:0] boot_gen_cmd_qs;
  logic [31:0] boot_gen_cmd_wd;
  logic sw_cmd_req_we;
  logic [31:0] sw_cmd_req_wd;
  logic sw_cmd_sts_cmd_reg_rdy_qs;
  logic sw_cmd_sts_cmd_rdy_qs;
  logic sw_cmd_sts_cmd_sts_qs;
  logic sw_cmd_sts_cmd_ack_qs;
  logic reseed_cmd_we;
  logic [31:0] reseed_cmd_wd;
  logic generate_cmd_we;
  logic [31:0] generate_cmd_wd;
  logic max_num_reqs_between_reseeds_we;
  logic [31:0] max_num_reqs_between_reseeds_qs;
  logic [31:0] max_num_reqs_between_reseeds_wd;
  logic recov_alert_sts_we;
  logic recov_alert_sts_edn_enable_field_alert_qs;
  logic recov_alert_sts_edn_enable_field_alert_wd;
  logic recov_alert_sts_boot_req_mode_field_alert_qs;
  logic recov_alert_sts_boot_req_mode_field_alert_wd;
  logic recov_alert_sts_auto_req_mode_field_alert_qs;
  logic recov_alert_sts_auto_req_mode_field_alert_wd;
  logic recov_alert_sts_cmd_fifo_rst_field_alert_qs;
  logic recov_alert_sts_cmd_fifo_rst_field_alert_wd;
  logic recov_alert_sts_edn_bus_cmp_alert_qs;
  logic recov_alert_sts_edn_bus_cmp_alert_wd;
  logic err_code_sfifo_rescmd_err_qs;
  logic err_code_sfifo_gencmd_err_qs;
  logic err_code_sfifo_output_err_qs;
  logic err_code_edn_ack_sm_err_qs;
  logic err_code_edn_main_sm_err_qs;
  logic err_code_edn_cntr_err_qs;
  logic err_code_fifo_write_err_qs;
  logic err_code_fifo_read_err_qs;
  logic err_code_fifo_state_err_qs;
  logic err_code_test_we;
  logic [4:0] err_code_test_qs;
  logic [4:0] err_code_test_wd;
  logic [8:0] main_sm_state_qs;

  // Register instances
  // R[intr_state]: V(False)
  //   F[edn_cmd_req_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_edn_cmd_req_done (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_edn_cmd_req_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.edn_cmd_req_done.de),
    .d      (hw2reg.intr_state.edn_cmd_req_done.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.edn_cmd_req_done.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_edn_cmd_req_done_qs)
  );

  //   F[edn_fatal_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_edn_fatal_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_edn_fatal_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.edn_fatal_err.de),
    .d      (hw2reg.intr_state.edn_fatal_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.edn_fatal_err.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_edn_fatal_err_qs)
  );


  // R[intr_enable]: V(False)
  //   F[edn_cmd_req_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_edn_cmd_req_done (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_edn_cmd_req_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.edn_cmd_req_done.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_edn_cmd_req_done_qs)
  );

  //   F[edn_fatal_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_edn_fatal_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_edn_fatal_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.edn_fatal_err.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_edn_fatal_err_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [1:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  //   F[edn_cmd_req_done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_edn_cmd_req_done (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_edn_cmd_req_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.edn_cmd_req_done.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.edn_cmd_req_done.qe = intr_test_qe;

  //   F[edn_fatal_err]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_edn_fatal_err (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_edn_fatal_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[1]),
    .q      (reg2hw.intr_test.edn_fatal_err.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.edn_fatal_err.qe = intr_test_qe;


  // R[alert_test]: V(True)
  logic alert_test_qe;
  logic [1:0] alert_test_flds_we;
  assign alert_test_qe = &alert_test_flds_we;
  //   F[recov_alert]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_alert (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_alert_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[0]),
    .q      (reg2hw.alert_test.recov_alert.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.alert_test.recov_alert.qe = alert_test_qe;

  //   F[fatal_alert]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_alert (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_alert_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[1]),
    .q      (reg2hw.alert_test.fatal_alert.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.alert_test.fatal_alert.qe = alert_test_qe;


  // R[regwen]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_regwen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (regwen_we),
    .wd     (regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (regwen_qs)
  );


  // R[ctrl]: V(False)
  // Create REGWEN-gated WE signal
  logic ctrl_gated_we;
  assign ctrl_gated_we = ctrl_we & regwen_qs;
  //   F[edn_enable]: 3:0
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h9),
    .Mubi    (1'b1)
  ) u_ctrl_edn_enable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_gated_we),
    .wd     (ctrl_edn_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.edn_enable.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_edn_enable_qs)
  );

  //   F[boot_req_mode]: 7:4
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h9),
    .Mubi    (1'b1)
  ) u_ctrl_boot_req_mode (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_gated_we),
    .wd     (ctrl_boot_req_mode_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.boot_req_mode.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_boot_req_mode_qs)
  );

  //   F[auto_req_mode]: 11:8
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h9),
    .Mubi    (1'b1)
  ) u_ctrl_auto_req_mode (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_gated_we),
    .wd     (ctrl_auto_req_mode_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.auto_req_mode.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_auto_req_mode_qs)
  );

  //   F[cmd_fifo_rst]: 15:12
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h9),
    .Mubi    (1'b1)
  ) u_ctrl_cmd_fifo_rst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_gated_we),
    .wd     (ctrl_cmd_fifo_rst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.cmd_fifo_rst.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_cmd_fifo_rst_qs)
  );


  // R[boot_ins_cmd]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h901),
    .Mubi    (1'b0)
  ) u_boot_ins_cmd (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (boot_ins_cmd_we),
    .wd     (boot_ins_cmd_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.boot_ins_cmd.q),
    .ds     (),

    // to register interface (read)
    .qs     (boot_ins_cmd_qs)
  );


  // R[boot_gen_cmd]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'hfff003),
    .Mubi    (1'b0)
  ) u_boot_gen_cmd (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (boot_gen_cmd_we),
    .wd     (boot_gen_cmd_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.boot_gen_cmd.q),
    .ds     (),

    // to register interface (read)
    .qs     (boot_gen_cmd_qs)
  );


  // R[sw_cmd_req]: V(True)
  logic sw_cmd_req_qe;
  logic [0:0] sw_cmd_req_flds_we;
  assign sw_cmd_req_qe = &sw_cmd_req_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_sw_cmd_req (
    .re     (1'b0),
    .we     (sw_cmd_req_we),
    .wd     (sw_cmd_req_wd),
    .d      ('0),
    .qre    (),
    .qe     (sw_cmd_req_flds_we[0]),
    .q      (reg2hw.sw_cmd_req.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.sw_cmd_req.qe = sw_cmd_req_qe;


  // R[sw_cmd_sts]: V(False)
  //   F[cmd_reg_rdy]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_sw_cmd_sts_cmd_reg_rdy (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_reg_rdy.de),
    .d      (hw2reg.sw_cmd_sts.cmd_reg_rdy.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_reg_rdy_qs)
  );

  //   F[cmd_rdy]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_sw_cmd_sts_cmd_rdy (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_rdy.de),
    .d      (hw2reg.sw_cmd_sts.cmd_rdy.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_rdy_qs)
  );

  //   F[cmd_sts]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_sw_cmd_sts_cmd_sts (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_sts.de),
    .d      (hw2reg.sw_cmd_sts.cmd_sts.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_sts_qs)
  );

  //   F[cmd_ack]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_sw_cmd_sts_cmd_ack (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_ack.de),
    .d      (hw2reg.sw_cmd_sts.cmd_ack.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_ack_qs)
  );


  // R[reseed_cmd]: V(True)
  logic reseed_cmd_qe;
  logic [0:0] reseed_cmd_flds_we;
  assign reseed_cmd_qe = &reseed_cmd_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_reseed_cmd (
    .re     (1'b0),
    .we     (reseed_cmd_we),
    .wd     (reseed_cmd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reseed_cmd_flds_we[0]),
    .q      (reg2hw.reseed_cmd.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.reseed_cmd.qe = reseed_cmd_qe;


  // R[generate_cmd]: V(True)
  logic generate_cmd_qe;
  logic [0:0] generate_cmd_flds_we;
  assign generate_cmd_qe = &generate_cmd_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_generate_cmd (
    .re     (1'b0),
    .we     (generate_cmd_we),
    .wd     (generate_cmd_wd),
    .d      ('0),
    .qre    (),
    .qe     (generate_cmd_flds_we[0]),
    .q      (reg2hw.generate_cmd.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.generate_cmd.qe = generate_cmd_qe;


  // R[max_num_reqs_between_reseeds]: V(False)
  logic max_num_reqs_between_reseeds_qe;
  logic [0:0] max_num_reqs_between_reseeds_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_max_num_reqs_between_reseeds0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&max_num_reqs_between_reseeds_flds_we),
    .q_o(max_num_reqs_between_reseeds_qe)
  );
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_max_num_reqs_between_reseeds (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (max_num_reqs_between_reseeds_we),
    .wd     (max_num_reqs_between_reseeds_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (max_num_reqs_between_reseeds_flds_we[0]),
    .q      (reg2hw.max_num_reqs_between_reseeds.q),
    .ds     (),

    // to register interface (read)
    .qs     (max_num_reqs_between_reseeds_qs)
  );
  assign reg2hw.max_num_reqs_between_reseeds.qe = max_num_reqs_between_reseeds_qe;


  // R[recov_alert_sts]: V(False)
  //   F[edn_enable_field_alert]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_recov_alert_sts_edn_enable_field_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (recov_alert_sts_we),
    .wd     (recov_alert_sts_edn_enable_field_alert_wd),

    // from internal hardware
    .de     (hw2reg.recov_alert_sts.edn_enable_field_alert.de),
    .d      (hw2reg.recov_alert_sts.edn_enable_field_alert.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (recov_alert_sts_edn_enable_field_alert_qs)
  );

  //   F[boot_req_mode_field_alert]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_recov_alert_sts_boot_req_mode_field_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (recov_alert_sts_we),
    .wd     (recov_alert_sts_boot_req_mode_field_alert_wd),

    // from internal hardware
    .de     (hw2reg.recov_alert_sts.boot_req_mode_field_alert.de),
    .d      (hw2reg.recov_alert_sts.boot_req_mode_field_alert.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (recov_alert_sts_boot_req_mode_field_alert_qs)
  );

  //   F[auto_req_mode_field_alert]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_recov_alert_sts_auto_req_mode_field_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (recov_alert_sts_we),
    .wd     (recov_alert_sts_auto_req_mode_field_alert_wd),

    // from internal hardware
    .de     (hw2reg.recov_alert_sts.auto_req_mode_field_alert.de),
    .d      (hw2reg.recov_alert_sts.auto_req_mode_field_alert.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (recov_alert_sts_auto_req_mode_field_alert_qs)
  );

  //   F[cmd_fifo_rst_field_alert]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_recov_alert_sts_cmd_fifo_rst_field_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (recov_alert_sts_we),
    .wd     (recov_alert_sts_cmd_fifo_rst_field_alert_wd),

    // from internal hardware
    .de     (hw2reg.recov_alert_sts.cmd_fifo_rst_field_alert.de),
    .d      (hw2reg.recov_alert_sts.cmd_fifo_rst_field_alert.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (recov_alert_sts_cmd_fifo_rst_field_alert_qs)
  );

  //   F[edn_bus_cmp_alert]: 12:12
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_recov_alert_sts_edn_bus_cmp_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (recov_alert_sts_we),
    .wd     (recov_alert_sts_edn_bus_cmp_alert_wd),

    // from internal hardware
    .de     (hw2reg.recov_alert_sts.edn_bus_cmp_alert.de),
    .d      (hw2reg.recov_alert_sts.edn_bus_cmp_alert.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (recov_alert_sts_edn_bus_cmp_alert_qs)
  );


  // R[err_code]: V(False)
  //   F[sfifo_rescmd_err]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_sfifo_rescmd_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.sfifo_rescmd_err.de),
    .d      (hw2reg.err_code.sfifo_rescmd_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_sfifo_rescmd_err_qs)
  );

  //   F[sfifo_gencmd_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_sfifo_gencmd_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.sfifo_gencmd_err.de),
    .d      (hw2reg.err_code.sfifo_gencmd_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_sfifo_gencmd_err_qs)
  );

  //   F[sfifo_output_err]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_sfifo_output_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.sfifo_output_err.de),
    .d      (hw2reg.err_code.sfifo_output_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_sfifo_output_err_qs)
  );

  //   F[edn_ack_sm_err]: 20:20
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_edn_ack_sm_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.edn_ack_sm_err.de),
    .d      (hw2reg.err_code.edn_ack_sm_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_edn_ack_sm_err_qs)
  );

  //   F[edn_main_sm_err]: 21:21
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_edn_main_sm_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.edn_main_sm_err.de),
    .d      (hw2reg.err_code.edn_main_sm_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_edn_main_sm_err_qs)
  );

  //   F[edn_cntr_err]: 22:22
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_edn_cntr_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.edn_cntr_err.de),
    .d      (hw2reg.err_code.edn_cntr_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_edn_cntr_err_qs)
  );

  //   F[fifo_write_err]: 28:28
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_fifo_write_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_write_err.de),
    .d      (hw2reg.err_code.fifo_write_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_fifo_write_err_qs)
  );

  //   F[fifo_read_err]: 29:29
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_fifo_read_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_read_err.de),
    .d      (hw2reg.err_code.fifo_read_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_fifo_read_err_qs)
  );

  //   F[fifo_state_err]: 30:30
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_err_code_fifo_state_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_state_err.de),
    .d      (hw2reg.err_code.fifo_state_err.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_fifo_state_err_qs)
  );


  // R[err_code_test]: V(False)
  logic err_code_test_qe;
  logic [0:0] err_code_test_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_err_code_test0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&err_code_test_flds_we),
    .q_o(err_code_test_qe)
  );
  prim_subreg #(
    .DW      (5),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (5'h0),
    .Mubi    (1'b0)
  ) u_err_code_test (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (err_code_test_we),
    .wd     (err_code_test_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (err_code_test_flds_we[0]),
    .q      (reg2hw.err_code_test.q),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_test_qs)
  );
  assign reg2hw.err_code_test.qe = err_code_test_qe;


  // R[main_sm_state]: V(False)
  prim_subreg #(
    .DW      (9),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (9'hc1),
    .Mubi    (1'b0)
  ) u_main_sm_state (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.main_sm_state.de),
    .d      (hw2reg.main_sm_state.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (main_sm_state_qs)
  );



  logic [16:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == EDN_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == EDN_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == EDN_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == EDN_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == EDN_REGWEN_OFFSET);
    addr_hit[ 5] = (reg_addr == EDN_CTRL_OFFSET);
    addr_hit[ 6] = (reg_addr == EDN_BOOT_INS_CMD_OFFSET);
    addr_hit[ 7] = (reg_addr == EDN_BOOT_GEN_CMD_OFFSET);
    addr_hit[ 8] = (reg_addr == EDN_SW_CMD_REQ_OFFSET);
    addr_hit[ 9] = (reg_addr == EDN_SW_CMD_STS_OFFSET);
    addr_hit[10] = (reg_addr == EDN_RESEED_CMD_OFFSET);
    addr_hit[11] = (reg_addr == EDN_GENERATE_CMD_OFFSET);
    addr_hit[12] = (reg_addr == EDN_MAX_NUM_REQS_BETWEEN_RESEEDS_OFFSET);
    addr_hit[13] = (reg_addr == EDN_RECOV_ALERT_STS_OFFSET);
    addr_hit[14] = (reg_addr == EDN_ERR_CODE_OFFSET);
    addr_hit[15] = (reg_addr == EDN_ERR_CODE_TEST_OFFSET);
    addr_hit[16] = (reg_addr == EDN_MAIN_SM_STATE_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(EDN_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(EDN_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(EDN_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(EDN_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(EDN_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(EDN_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(EDN_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(EDN_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(EDN_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(EDN_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(EDN_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(EDN_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(EDN_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(EDN_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(EDN_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(EDN_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(EDN_PERMIT[16] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_state_edn_fatal_err_wd = reg_wdata[1];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_enable_edn_fatal_err_wd = reg_wdata[1];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_test_edn_fatal_err_wd = reg_wdata[1];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_recov_alert_wd = reg_wdata[0];

  assign alert_test_fatal_alert_wd = reg_wdata[1];
  assign regwen_we = addr_hit[4] & reg_we & !reg_error;

  assign regwen_wd = reg_wdata[0];
  assign ctrl_we = addr_hit[5] & reg_we & !reg_error;

  assign ctrl_edn_enable_wd = reg_wdata[3:0];

  assign ctrl_boot_req_mode_wd = reg_wdata[7:4];

  assign ctrl_auto_req_mode_wd = reg_wdata[11:8];

  assign ctrl_cmd_fifo_rst_wd = reg_wdata[15:12];
  assign boot_ins_cmd_we = addr_hit[6] & reg_we & !reg_error;

  assign boot_ins_cmd_wd = reg_wdata[31:0];
  assign boot_gen_cmd_we = addr_hit[7] & reg_we & !reg_error;

  assign boot_gen_cmd_wd = reg_wdata[31:0];
  assign sw_cmd_req_we = addr_hit[8] & reg_we & !reg_error;

  assign sw_cmd_req_wd = reg_wdata[31:0];
  assign reseed_cmd_we = addr_hit[10] & reg_we & !reg_error;

  assign reseed_cmd_wd = reg_wdata[31:0];
  assign generate_cmd_we = addr_hit[11] & reg_we & !reg_error;

  assign generate_cmd_wd = reg_wdata[31:0];
  assign max_num_reqs_between_reseeds_we = addr_hit[12] & reg_we & !reg_error;

  assign max_num_reqs_between_reseeds_wd = reg_wdata[31:0];
  assign recov_alert_sts_we = addr_hit[13] & reg_we & !reg_error;

  assign recov_alert_sts_edn_enable_field_alert_wd = reg_wdata[0];

  assign recov_alert_sts_boot_req_mode_field_alert_wd = reg_wdata[1];

  assign recov_alert_sts_auto_req_mode_field_alert_wd = reg_wdata[2];

  assign recov_alert_sts_cmd_fifo_rst_field_alert_wd = reg_wdata[3];

  assign recov_alert_sts_edn_bus_cmp_alert_wd = reg_wdata[12];
  assign err_code_test_we = addr_hit[15] & reg_we & !reg_error;

  assign err_code_test_wd = reg_wdata[4:0];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check = '0;
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = alert_test_we;
    reg_we_check[4] = regwen_we;
    reg_we_check[5] = ctrl_gated_we;
    reg_we_check[6] = boot_ins_cmd_we;
    reg_we_check[7] = boot_gen_cmd_we;
    reg_we_check[8] = sw_cmd_req_we;
    reg_we_check[9] = 1'b0;
    reg_we_check[10] = reseed_cmd_we;
    reg_we_check[11] = generate_cmd_we;
    reg_we_check[12] = max_num_reqs_between_reseeds_we;
    reg_we_check[13] = recov_alert_sts_we;
    reg_we_check[14] = 1'b0;
    reg_we_check[15] = err_code_test_we;
    reg_we_check[16] = 1'b0;
  end

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_edn_cmd_req_done_qs;
        reg_rdata_next[1] = intr_state_edn_fatal_err_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_edn_cmd_req_done_qs;
        reg_rdata_next[1] = intr_enable_edn_fatal_err_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = regwen_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[3:0] = ctrl_edn_enable_qs;
        reg_rdata_next[7:4] = ctrl_boot_req_mode_qs;
        reg_rdata_next[11:8] = ctrl_auto_req_mode_qs;
        reg_rdata_next[15:12] = ctrl_cmd_fifo_rst_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = boot_ins_cmd_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = boot_gen_cmd_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[9]: begin
        reg_rdata_next[0] = sw_cmd_sts_cmd_reg_rdy_qs;
        reg_rdata_next[1] = sw_cmd_sts_cmd_rdy_qs;
        reg_rdata_next[2] = sw_cmd_sts_cmd_sts_qs;
        reg_rdata_next[3] = sw_cmd_sts_cmd_ack_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = max_num_reqs_between_reseeds_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = recov_alert_sts_edn_enable_field_alert_qs;
        reg_rdata_next[1] = recov_alert_sts_boot_req_mode_field_alert_qs;
        reg_rdata_next[2] = recov_alert_sts_auto_req_mode_field_alert_qs;
        reg_rdata_next[3] = recov_alert_sts_cmd_fifo_rst_field_alert_qs;
        reg_rdata_next[12] = recov_alert_sts_edn_bus_cmp_alert_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[0] = err_code_sfifo_rescmd_err_qs;
        reg_rdata_next[1] = err_code_sfifo_gencmd_err_qs;
        reg_rdata_next[2] = err_code_sfifo_output_err_qs;
        reg_rdata_next[20] = err_code_edn_ack_sm_err_qs;
        reg_rdata_next[21] = err_code_edn_main_sm_err_qs;
        reg_rdata_next[22] = err_code_edn_cntr_err_qs;
        reg_rdata_next[28] = err_code_fifo_write_err_qs;
        reg_rdata_next[29] = err_code_fifo_read_err_qs;
        reg_rdata_next[30] = err_code_fifo_state_err_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[4:0] = err_code_test_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[8:0] = main_sm_state_qs;
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
