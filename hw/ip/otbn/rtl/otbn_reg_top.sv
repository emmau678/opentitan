// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module otbn_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o  [2],
  input  tlul_pkg::tl_d2h_t tl_win_i  [2],

  // To HW
  output otbn_reg_pkg::otbn_reg2hw_t reg2hw, // Write
  input  otbn_reg_pkg::otbn_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import otbn_reg_pkg::* ;

  localparam int AW = 16;
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
    .EnableDataIntgGen(0)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  tlul_pkg::tl_h2d_t tl_socket_h2d [3];
  tlul_pkg::tl_d2h_t tl_socket_d2h [3];

  logic [1:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[2];
  assign tl_socket_d2h[2] = tl_reg_d2h;

  assign tl_win_o[0] = tl_socket_h2d[0];
  assign tl_socket_d2h[0] = tl_win_i[0];
  assign tl_win_o[1] = tl_socket_h2d[1];
  assign tl_socket_d2h[1] = tl_win_i[1];

  // Create Socket_1n
  tlul_socket_1n #(
    .N          (3),
    .HReqPass   (1'b1),
    .HRspPass   (1'b1),
    .DReqPass   ({3{1'b1}}),
    .DRspPass   ({3{1'b1}}),
    .HReqDepth  (4'h0),
    .HRspDepth  (4'h0),
    .DReqDepth  ({3{4'h0}}),
    .DRspDepth  ({3{4'h0}})
  ) u_socket (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .tl_h_i (tl_i),
    .tl_h_o (tl_o_pre),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select_i (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer = 2;       // Default set to register

    // TODO: Can below codes be unique case () inside ?
    if (tl_i.a_address[AW-1:0] >= 16384 && tl_i.a_address[AW-1:0] < 20480) begin
      reg_steer = 0;
    end
    if (tl_i.a_address[AW-1:0] >= 32768 && tl_i.a_address[AW-1:0] < 36864) begin
      reg_steer = 1;
    end
    if (intg_err) begin
      reg_steer = 2;
    end
  end

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(1)
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
  logic alert_test_fatal_wd;
  logic alert_test_recov_wd;
  logic cmd_we;
  logic [7:0] cmd_wd;
  logic ctrl_re;
  logic ctrl_we;
  logic ctrl_qs;
  logic ctrl_wd;
  logic [7:0] status_qs;
  logic err_bits_bad_data_addr_qs;
  logic err_bits_bad_insn_addr_qs;
  logic err_bits_call_stack_qs;
  logic err_bits_illegal_insn_qs;
  logic err_bits_loop_qs;
  logic err_bits_imem_intg_violation_qs;
  logic err_bits_dmem_intg_violation_qs;
  logic err_bits_reg_intg_violation_qs;
  logic err_bits_bus_intg_violation_qs;
  logic err_bits_bad_internal_state_qs;
  logic err_bits_illegal_bus_access_qs;
  logic err_bits_lifecycle_escalation_qs;
  logic err_bits_fatal_software_qs;
  logic fatal_alert_cause_imem_intg_violation_qs;
  logic fatal_alert_cause_dmem_intg_violation_qs;
  logic fatal_alert_cause_reg_intg_violation_qs;
  logic fatal_alert_cause_bus_intg_violation_qs;
  logic fatal_alert_cause_bad_internal_state_qs;
  logic fatal_alert_cause_illegal_bus_access_qs;
  logic fatal_alert_cause_lifecycle_escalation_qs;
  logic fatal_alert_cause_fatal_software_qs;
  logic insn_cnt_re;
  logic [31:0] insn_cnt_qs;
  logic load_checksum_we;
  logic [31:0] load_checksum_qs;
  logic [31:0] load_checksum_wd;

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
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.qe),
    .q      (reg2hw.intr_test.q),
    .qs     ()
  );


  // R[alert_test]: V(True)
  //   F[fatal]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.fatal.qe),
    .q      (reg2hw.alert_test.fatal.q),
    .qs     ()
  );

  //   F[recov]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov.qe),
    .q      (reg2hw.alert_test.recov.q),
    .qs     ()
  );


  // R[cmd]: V(True)
  prim_subreg_ext #(
    .DW    (8)
  ) u_cmd (
    .re     (1'b0),
    .we     (cmd_we),
    .wd     (cmd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.cmd.qe),
    .q      (reg2hw.cmd.q),
    .qs     ()
  );


  // R[ctrl]: V(True)
  prim_subreg_ext #(
    .DW    (1)
  ) u_ctrl (
    .re     (ctrl_re),
    .we     (ctrl_we),
    .wd     (ctrl_wd),
    .d      (hw2reg.ctrl.d),
    .qre    (),
    .qe     (reg2hw.ctrl.qe),
    .q      (reg2hw.ctrl.q),
    .qs     (ctrl_qs)
  );


  // R[status]: V(False)
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (8'h0)
  ) u_status (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.status.de),
    .d      (hw2reg.status.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (status_qs)
  );


  // R[err_bits]: V(False)
  //   F[bad_data_addr]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_bad_data_addr (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.bad_data_addr.de),
    .d      (hw2reg.err_bits.bad_data_addr.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_bad_data_addr_qs)
  );

  //   F[bad_insn_addr]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_bad_insn_addr (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.bad_insn_addr.de),
    .d      (hw2reg.err_bits.bad_insn_addr.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_bad_insn_addr_qs)
  );

  //   F[call_stack]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_call_stack (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.call_stack.de),
    .d      (hw2reg.err_bits.call_stack.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_call_stack_qs)
  );

  //   F[illegal_insn]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_illegal_insn (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.illegal_insn.de),
    .d      (hw2reg.err_bits.illegal_insn.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_illegal_insn_qs)
  );

  //   F[loop]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_loop (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.loop.de),
    .d      (hw2reg.err_bits.loop.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_loop_qs)
  );

  //   F[imem_intg_violation]: 16:16
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_imem_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.imem_intg_violation.de),
    .d      (hw2reg.err_bits.imem_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_imem_intg_violation_qs)
  );

  //   F[dmem_intg_violation]: 17:17
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_dmem_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.dmem_intg_violation.de),
    .d      (hw2reg.err_bits.dmem_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_dmem_intg_violation_qs)
  );

  //   F[reg_intg_violation]: 18:18
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_reg_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.reg_intg_violation.de),
    .d      (hw2reg.err_bits.reg_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_reg_intg_violation_qs)
  );

  //   F[bus_intg_violation]: 19:19
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_bus_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.bus_intg_violation.de),
    .d      (hw2reg.err_bits.bus_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_bus_intg_violation_qs)
  );

  //   F[bad_internal_state]: 20:20
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_bad_internal_state (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.bad_internal_state.de),
    .d      (hw2reg.err_bits.bad_internal_state.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_bad_internal_state_qs)
  );

  //   F[illegal_bus_access]: 21:21
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_illegal_bus_access (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.illegal_bus_access.de),
    .d      (hw2reg.err_bits.illegal_bus_access.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_illegal_bus_access_qs)
  );

  //   F[lifecycle_escalation]: 22:22
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_lifecycle_escalation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.lifecycle_escalation.de),
    .d      (hw2reg.err_bits.lifecycle_escalation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_lifecycle_escalation_qs)
  );

  //   F[fatal_software]: 23:23
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_err_bits_fatal_software (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_bits.fatal_software.de),
    .d      (hw2reg.err_bits.fatal_software.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_bits_fatal_software_qs)
  );


  // R[fatal_alert_cause]: V(False)
  //   F[imem_intg_violation]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_imem_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.imem_intg_violation.de),
    .d      (hw2reg.fatal_alert_cause.imem_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_imem_intg_violation_qs)
  );

  //   F[dmem_intg_violation]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_dmem_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.dmem_intg_violation.de),
    .d      (hw2reg.fatal_alert_cause.dmem_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_dmem_intg_violation_qs)
  );

  //   F[reg_intg_violation]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_reg_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.reg_intg_violation.de),
    .d      (hw2reg.fatal_alert_cause.reg_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_reg_intg_violation_qs)
  );

  //   F[bus_intg_violation]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_bus_intg_violation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.bus_intg_violation.de),
    .d      (hw2reg.fatal_alert_cause.bus_intg_violation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_bus_intg_violation_qs)
  );

  //   F[bad_internal_state]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_bad_internal_state (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.bad_internal_state.de),
    .d      (hw2reg.fatal_alert_cause.bad_internal_state.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_bad_internal_state_qs)
  );

  //   F[illegal_bus_access]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_illegal_bus_access (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.illegal_bus_access.de),
    .d      (hw2reg.fatal_alert_cause.illegal_bus_access.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_illegal_bus_access_qs)
  );

  //   F[lifecycle_escalation]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_lifecycle_escalation (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.lifecycle_escalation.de),
    .d      (hw2reg.fatal_alert_cause.lifecycle_escalation.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_lifecycle_escalation_qs)
  );

  //   F[fatal_software]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0)
  ) u_fatal_alert_cause_fatal_software (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.fatal_alert_cause.fatal_software.de),
    .d      (hw2reg.fatal_alert_cause.fatal_software.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (fatal_alert_cause_fatal_software_qs)
  );


  // R[insn_cnt]: V(True)
  prim_subreg_ext #(
    .DW    (32)
  ) u_insn_cnt (
    .re     (insn_cnt_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.insn_cnt.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (insn_cnt_qs)
  );


  // R[load_checksum]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_load_checksum (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (load_checksum_we),
    .wd     (load_checksum_wd),

    // from internal hardware
    .de     (hw2reg.load_checksum.de),
    .d      (hw2reg.load_checksum.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.load_checksum.q),

    // to register interface (read)
    .qs     (load_checksum_qs)
  );



  logic [10:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == OTBN_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == OTBN_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == OTBN_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == OTBN_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == OTBN_CMD_OFFSET);
    addr_hit[ 5] = (reg_addr == OTBN_CTRL_OFFSET);
    addr_hit[ 6] = (reg_addr == OTBN_STATUS_OFFSET);
    addr_hit[ 7] = (reg_addr == OTBN_ERR_BITS_OFFSET);
    addr_hit[ 8] = (reg_addr == OTBN_FATAL_ALERT_CAUSE_OFFSET);
    addr_hit[ 9] = (reg_addr == OTBN_INSN_CNT_OFFSET);
    addr_hit[10] = (reg_addr == OTBN_LOAD_CHECKSUM_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(OTBN_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(OTBN_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(OTBN_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(OTBN_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(OTBN_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(OTBN_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(OTBN_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(OTBN_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(OTBN_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(OTBN_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(OTBN_PERMIT[10] & ~reg_be)))));
  end
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_wd = reg_wdata[0];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_wd = reg_wdata[0];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_wd = reg_wdata[0];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_fatal_wd = reg_wdata[0];

  assign alert_test_recov_wd = reg_wdata[1];
  assign cmd_we = addr_hit[4] & reg_we & !reg_error;

  assign cmd_wd = reg_wdata[7:0];
  assign ctrl_re = addr_hit[5] & reg_re & !reg_error;
  assign ctrl_we = addr_hit[5] & reg_we & !reg_error;

  assign ctrl_wd = reg_wdata[0];
  assign insn_cnt_re = addr_hit[9] & reg_re & !reg_error;
  assign load_checksum_we = addr_hit[10] & reg_we & !reg_error;

  assign load_checksum_wd = reg_wdata[31:0];

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
        reg_rdata_next[1] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[7:0] = '0;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = ctrl_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[7:0] = status_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[0] = err_bits_bad_data_addr_qs;
        reg_rdata_next[1] = err_bits_bad_insn_addr_qs;
        reg_rdata_next[2] = err_bits_call_stack_qs;
        reg_rdata_next[3] = err_bits_illegal_insn_qs;
        reg_rdata_next[4] = err_bits_loop_qs;
        reg_rdata_next[16] = err_bits_imem_intg_violation_qs;
        reg_rdata_next[17] = err_bits_dmem_intg_violation_qs;
        reg_rdata_next[18] = err_bits_reg_intg_violation_qs;
        reg_rdata_next[19] = err_bits_bus_intg_violation_qs;
        reg_rdata_next[20] = err_bits_bad_internal_state_qs;
        reg_rdata_next[21] = err_bits_illegal_bus_access_qs;
        reg_rdata_next[22] = err_bits_lifecycle_escalation_qs;
        reg_rdata_next[23] = err_bits_fatal_software_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = fatal_alert_cause_imem_intg_violation_qs;
        reg_rdata_next[1] = fatal_alert_cause_dmem_intg_violation_qs;
        reg_rdata_next[2] = fatal_alert_cause_reg_intg_violation_qs;
        reg_rdata_next[3] = fatal_alert_cause_bus_intg_violation_qs;
        reg_rdata_next[4] = fatal_alert_cause_bad_internal_state_qs;
        reg_rdata_next[5] = fatal_alert_cause_illegal_bus_access_qs;
        reg_rdata_next[6] = fatal_alert_cause_lifecycle_escalation_qs;
        reg_rdata_next[7] = fatal_alert_cause_fatal_software_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = insn_cnt_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = load_checksum_qs;
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
  logic reg_busy_sel;
  assign reg_busy = reg_busy_sel | shadow_busy;
  always_comb begin
    reg_busy_sel = '0;
    unique case (1'b1)
      default: begin
        reg_busy_sel  = '0;
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
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o_pre.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
