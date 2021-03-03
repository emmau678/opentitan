// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module edn_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output edn_reg_pkg::edn_reg2hw_t reg2hw, // Write
  input  edn_reg_pkg::edn_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import edn_reg_pkg::* ;

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

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i,
    // connect this to intg_err later when all DV / hosts are hooked up
    .err_o()
  );
  assign intg_err = 1'b0;

  // Once integrity error is detected, it does not let go until reset.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      intg_err_o <= '0;
    end else if (intg_err) begin
      intg_err_o <= 1'b1;
    end
  end

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen u_rsp_intg_gen (
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
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_edn_cmd_req_done_qs;
  logic intr_state_edn_cmd_req_done_wd;
  logic intr_state_edn_cmd_req_done_we;
  logic intr_state_edn_fatal_err_qs;
  logic intr_state_edn_fatal_err_wd;
  logic intr_state_edn_fatal_err_we;
  logic intr_enable_edn_cmd_req_done_qs;
  logic intr_enable_edn_cmd_req_done_wd;
  logic intr_enable_edn_cmd_req_done_we;
  logic intr_enable_edn_fatal_err_qs;
  logic intr_enable_edn_fatal_err_wd;
  logic intr_enable_edn_fatal_err_we;
  logic intr_test_edn_cmd_req_done_wd;
  logic intr_test_edn_cmd_req_done_we;
  logic intr_test_edn_fatal_err_wd;
  logic intr_test_edn_fatal_err_we;
  logic alert_test_wd;
  logic alert_test_we;
  logic regwen_qs;
  logic regwen_wd;
  logic regwen_we;
  logic ctrl_edn_enable_qs;
  logic ctrl_edn_enable_wd;
  logic ctrl_edn_enable_we;
  logic ctrl_cmd_fifo_rst_qs;
  logic ctrl_cmd_fifo_rst_wd;
  logic ctrl_cmd_fifo_rst_we;
  logic ctrl_auto_req_mode_qs;
  logic ctrl_auto_req_mode_wd;
  logic ctrl_auto_req_mode_we;
  logic ctrl_boot_req_dis_qs;
  logic ctrl_boot_req_dis_wd;
  logic ctrl_boot_req_dis_we;
  logic sum_sts_req_mode_sm_sts_qs;
  logic sum_sts_req_mode_sm_sts_wd;
  logic sum_sts_req_mode_sm_sts_we;
  logic sum_sts_boot_inst_ack_qs;
  logic sum_sts_boot_inst_ack_wd;
  logic sum_sts_boot_inst_ack_we;
  logic sum_sts_internal_use_qs;
  logic sum_sts_internal_use_wd;
  logic sum_sts_internal_use_we;
  logic [31:0] sw_cmd_req_wd;
  logic sw_cmd_req_we;
  logic sw_cmd_sts_cmd_rdy_qs;
  logic sw_cmd_sts_cmd_sts_qs;
  logic [31:0] reseed_cmd_wd;
  logic reseed_cmd_we;
  logic [31:0] generate_cmd_wd;
  logic generate_cmd_we;
  logic [31:0] max_num_reqs_between_reseeds_qs;
  logic [31:0] max_num_reqs_between_reseeds_wd;
  logic max_num_reqs_between_reseeds_we;
  logic err_code_sfifo_rescmd_err_qs;
  logic err_code_sfifo_gencmd_err_qs;
  logic err_code_edn_ack_sm_err_qs;
  logic err_code_edn_main_sm_err_qs;
  logic err_code_fifo_write_err_qs;
  logic err_code_fifo_read_err_qs;
  logic err_code_fifo_state_err_qs;
  logic [4:0] err_code_test_qs;
  logic [4:0] err_code_test_wd;
  logic err_code_test_we;

  // Register instances
  // R[intr_state]: V(False)

  //   F[edn_cmd_req_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_edn_cmd_req_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_edn_cmd_req_done_we),
    .wd     (intr_state_edn_cmd_req_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.edn_cmd_req_done.de),
    .d      (hw2reg.intr_state.edn_cmd_req_done.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.edn_cmd_req_done.q ),

    // to register interface (read)
    .qs     (intr_state_edn_cmd_req_done_qs)
  );


  //   F[edn_fatal_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_edn_fatal_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_edn_fatal_err_we),
    .wd     (intr_state_edn_fatal_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.edn_fatal_err.de),
    .d      (hw2reg.intr_state.edn_fatal_err.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.edn_fatal_err.q ),

    // to register interface (read)
    .qs     (intr_state_edn_fatal_err_qs)
  );


  // R[intr_enable]: V(False)

  //   F[edn_cmd_req_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_edn_cmd_req_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_edn_cmd_req_done_we),
    .wd     (intr_enable_edn_cmd_req_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.edn_cmd_req_done.q ),

    // to register interface (read)
    .qs     (intr_enable_edn_cmd_req_done_qs)
  );


  //   F[edn_fatal_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_edn_fatal_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_edn_fatal_err_we),
    .wd     (intr_enable_edn_fatal_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.edn_fatal_err.q ),

    // to register interface (read)
    .qs     (intr_enable_edn_fatal_err_qs)
  );


  // R[intr_test]: V(True)

  //   F[edn_cmd_req_done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_edn_cmd_req_done (
    .re     (1'b0),
    .we     (intr_test_edn_cmd_req_done_we),
    .wd     (intr_test_edn_cmd_req_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.edn_cmd_req_done.qe),
    .q      (reg2hw.intr_test.edn_cmd_req_done.q ),
    .qs     ()
  );


  //   F[edn_fatal_err]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_edn_fatal_err (
    .re     (1'b0),
    .we     (intr_test_edn_fatal_err_we),
    .wd     (intr_test_edn_fatal_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.edn_fatal_err.qe),
    .q      (reg2hw.intr_test.edn_fatal_err.q ),
    .qs     ()
  );


  // R[alert_test]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.qe),
    .q      (reg2hw.alert_test.q ),
    .qs     ()
  );


  // R[regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (regwen_we),
    .wd     (regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.regwen.q ),

    // to register interface (read)
    .qs     (regwen_qs)
  );


  // R[ctrl]: V(False)

  //   F[edn_enable]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ctrl_edn_enable (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_edn_enable_we),
    .wd     (ctrl_edn_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.edn_enable.q ),

    // to register interface (read)
    .qs     (ctrl_edn_enable_qs)
  );


  //   F[cmd_fifo_rst]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ctrl_cmd_fifo_rst (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_cmd_fifo_rst_we),
    .wd     (ctrl_cmd_fifo_rst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.cmd_fifo_rst.q ),

    // to register interface (read)
    .qs     (ctrl_cmd_fifo_rst_qs)
  );


  //   F[auto_req_mode]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ctrl_auto_req_mode (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_auto_req_mode_we),
    .wd     (ctrl_auto_req_mode_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.auto_req_mode.q ),

    // to register interface (read)
    .qs     (ctrl_auto_req_mode_qs)
  );


  //   F[boot_req_dis]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ctrl_boot_req_dis (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_boot_req_dis_we),
    .wd     (ctrl_boot_req_dis_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.boot_req_dis.q ),

    // to register interface (read)
    .qs     (ctrl_boot_req_dis_qs)
  );


  // R[sum_sts]: V(False)

  //   F[req_mode_sm_sts]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_sum_sts_req_mode_sm_sts (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sum_sts_req_mode_sm_sts_we),
    .wd     (sum_sts_req_mode_sm_sts_wd),

    // from internal hardware
    .de     (hw2reg.sum_sts.req_mode_sm_sts.de),
    .d      (hw2reg.sum_sts.req_mode_sm_sts.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sum_sts_req_mode_sm_sts_qs)
  );


  //   F[boot_inst_ack]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_sum_sts_boot_inst_ack (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sum_sts_boot_inst_ack_we),
    .wd     (sum_sts_boot_inst_ack_wd),

    // from internal hardware
    .de     (hw2reg.sum_sts.boot_inst_ack.de),
    .d      (hw2reg.sum_sts.boot_inst_ack.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sum_sts_boot_inst_ack_qs)
  );


  //   F[internal_use]: 31:31
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_sum_sts_internal_use (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sum_sts_internal_use_we),
    .wd     (sum_sts_internal_use_wd),

    // from internal hardware
    .de     (hw2reg.sum_sts.internal_use.de),
    .d      (hw2reg.sum_sts.internal_use.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sum_sts_internal_use_qs)
  );


  // R[sw_cmd_req]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_sw_cmd_req (
    .re     (1'b0),
    // qualified with register enable
    .we     (sw_cmd_req_we & regwen_qs),
    .wd     (sw_cmd_req_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.sw_cmd_req.qe),
    .q      (reg2hw.sw_cmd_req.q ),
    .qs     ()
  );


  // R[sw_cmd_sts]: V(False)

  //   F[cmd_rdy]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h1)
  ) u_sw_cmd_sts_cmd_rdy (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_rdy.de),
    .d      (hw2reg.sw_cmd_sts.cmd_rdy.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_rdy_qs)
  );


  //   F[cmd_sts]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_sw_cmd_sts_cmd_sts (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.sw_cmd_sts.cmd_sts.de),
    .d      (hw2reg.sw_cmd_sts.cmd_sts.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sw_cmd_sts_cmd_sts_qs)
  );


  // R[reseed_cmd]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_reseed_cmd (
    .re     (1'b0),
    // qualified with register enable
    .we     (reseed_cmd_we & regwen_qs),
    .wd     (reseed_cmd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.reseed_cmd.qe),
    .q      (reg2hw.reseed_cmd.q ),
    .qs     ()
  );


  // R[generate_cmd]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_generate_cmd (
    .re     (1'b0),
    // qualified with register enable
    .we     (generate_cmd_we & regwen_qs),
    .wd     (generate_cmd_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.generate_cmd.qe),
    .q      (reg2hw.generate_cmd.q ),
    .qs     ()
  );


  // R[max_num_reqs_between_reseeds]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_max_num_reqs_between_reseeds (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (max_num_reqs_between_reseeds_we),
    .wd     (max_num_reqs_between_reseeds_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.max_num_reqs_between_reseeds.qe),
    .q      (reg2hw.max_num_reqs_between_reseeds.q ),

    // to register interface (read)
    .qs     (max_num_reqs_between_reseeds_qs)
  );


  // R[err_code]: V(False)

  //   F[sfifo_rescmd_err]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_sfifo_rescmd_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.sfifo_rescmd_err.de),
    .d      (hw2reg.err_code.sfifo_rescmd_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_sfifo_rescmd_err_qs)
  );


  //   F[sfifo_gencmd_err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_sfifo_gencmd_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.sfifo_gencmd_err.de),
    .d      (hw2reg.err_code.sfifo_gencmd_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_sfifo_gencmd_err_qs)
  );


  //   F[edn_ack_sm_err]: 20:20
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_edn_ack_sm_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.edn_ack_sm_err.de),
    .d      (hw2reg.err_code.edn_ack_sm_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_edn_ack_sm_err_qs)
  );


  //   F[edn_main_sm_err]: 21:21
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_edn_main_sm_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.edn_main_sm_err.de),
    .d      (hw2reg.err_code.edn_main_sm_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_edn_main_sm_err_qs)
  );


  //   F[fifo_write_err]: 28:28
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_fifo_write_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_write_err.de),
    .d      (hw2reg.err_code.fifo_write_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_fifo_write_err_qs)
  );


  //   F[fifo_read_err]: 29:29
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_fifo_read_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_read_err.de),
    .d      (hw2reg.err_code.fifo_read_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_fifo_read_err_qs)
  );


  //   F[fifo_state_err]: 30:30
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RO"),
    .RESVAL  (1'h0)
  ) u_err_code_fifo_state_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.fifo_state_err.de),
    .d      (hw2reg.err_code.fifo_state_err.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_fifo_state_err_qs)
  );


  // R[err_code_test]: V(False)

  prim_subreg #(
    .DW      (5),
    .SWACCESS("RW"),
    .RESVAL  (5'h0)
  ) u_err_code_test (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (err_code_test_we & regwen_qs),
    .wd     (err_code_test_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.err_code_test.qe),
    .q      (reg2hw.err_code_test.q ),

    // to register interface (read)
    .qs     (err_code_test_qs)
  );




  logic [13:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == EDN_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == EDN_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == EDN_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == EDN_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == EDN_REGWEN_OFFSET);
    addr_hit[ 5] = (reg_addr == EDN_CTRL_OFFSET);
    addr_hit[ 6] = (reg_addr == EDN_SUM_STS_OFFSET);
    addr_hit[ 7] = (reg_addr == EDN_SW_CMD_REQ_OFFSET);
    addr_hit[ 8] = (reg_addr == EDN_SW_CMD_STS_OFFSET);
    addr_hit[ 9] = (reg_addr == EDN_RESEED_CMD_OFFSET);
    addr_hit[10] = (reg_addr == EDN_GENERATE_CMD_OFFSET);
    addr_hit[11] = (reg_addr == EDN_MAX_NUM_REQS_BETWEEN_RESEEDS_OFFSET);
    addr_hit[12] = (reg_addr == EDN_ERR_CODE_OFFSET);
    addr_hit[13] = (reg_addr == EDN_ERR_CODE_TEST_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[ 0] && reg_we && (EDN_PERMIT[ 0] != (EDN_PERMIT[ 0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 1] && reg_we && (EDN_PERMIT[ 1] != (EDN_PERMIT[ 1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 2] && reg_we && (EDN_PERMIT[ 2] != (EDN_PERMIT[ 2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 3] && reg_we && (EDN_PERMIT[ 3] != (EDN_PERMIT[ 3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 4] && reg_we && (EDN_PERMIT[ 4] != (EDN_PERMIT[ 4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 5] && reg_we && (EDN_PERMIT[ 5] != (EDN_PERMIT[ 5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 6] && reg_we && (EDN_PERMIT[ 6] != (EDN_PERMIT[ 6] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 7] && reg_we && (EDN_PERMIT[ 7] != (EDN_PERMIT[ 7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 8] && reg_we && (EDN_PERMIT[ 8] != (EDN_PERMIT[ 8] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 9] && reg_we && (EDN_PERMIT[ 9] != (EDN_PERMIT[ 9] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[10] && reg_we && (EDN_PERMIT[10] != (EDN_PERMIT[10] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[11] && reg_we && (EDN_PERMIT[11] != (EDN_PERMIT[11] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[12] && reg_we && (EDN_PERMIT[12] != (EDN_PERMIT[12] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[13] && reg_we && (EDN_PERMIT[13] != (EDN_PERMIT[13] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_edn_cmd_req_done_we = addr_hit[0] & reg_we & !reg_error;
  assign intr_state_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_state_edn_fatal_err_we = addr_hit[0] & reg_we & !reg_error;
  assign intr_state_edn_fatal_err_wd = reg_wdata[1];

  assign intr_enable_edn_cmd_req_done_we = addr_hit[1] & reg_we & !reg_error;
  assign intr_enable_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_enable_edn_fatal_err_we = addr_hit[1] & reg_we & !reg_error;
  assign intr_enable_edn_fatal_err_wd = reg_wdata[1];

  assign intr_test_edn_cmd_req_done_we = addr_hit[2] & reg_we & !reg_error;
  assign intr_test_edn_cmd_req_done_wd = reg_wdata[0];

  assign intr_test_edn_fatal_err_we = addr_hit[2] & reg_we & !reg_error;
  assign intr_test_edn_fatal_err_wd = reg_wdata[1];

  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;
  assign alert_test_wd = reg_wdata[0];

  assign regwen_we = addr_hit[4] & reg_we & !reg_error;
  assign regwen_wd = reg_wdata[0];

  assign ctrl_edn_enable_we = addr_hit[5] & reg_we & !reg_error;
  assign ctrl_edn_enable_wd = reg_wdata[0];

  assign ctrl_cmd_fifo_rst_we = addr_hit[5] & reg_we & !reg_error;
  assign ctrl_cmd_fifo_rst_wd = reg_wdata[1];

  assign ctrl_auto_req_mode_we = addr_hit[5] & reg_we & !reg_error;
  assign ctrl_auto_req_mode_wd = reg_wdata[2];

  assign ctrl_boot_req_dis_we = addr_hit[5] & reg_we & !reg_error;
  assign ctrl_boot_req_dis_wd = reg_wdata[3];

  assign sum_sts_req_mode_sm_sts_we = addr_hit[6] & reg_we & !reg_error;
  assign sum_sts_req_mode_sm_sts_wd = reg_wdata[0];

  assign sum_sts_boot_inst_ack_we = addr_hit[6] & reg_we & !reg_error;
  assign sum_sts_boot_inst_ack_wd = reg_wdata[1];

  assign sum_sts_internal_use_we = addr_hit[6] & reg_we & !reg_error;
  assign sum_sts_internal_use_wd = reg_wdata[31];

  assign sw_cmd_req_we = addr_hit[7] & reg_we & !reg_error;
  assign sw_cmd_req_wd = reg_wdata[31:0];



  assign reseed_cmd_we = addr_hit[9] & reg_we & !reg_error;
  assign reseed_cmd_wd = reg_wdata[31:0];

  assign generate_cmd_we = addr_hit[10] & reg_we & !reg_error;
  assign generate_cmd_wd = reg_wdata[31:0];

  assign max_num_reqs_between_reseeds_we = addr_hit[11] & reg_we & !reg_error;
  assign max_num_reqs_between_reseeds_wd = reg_wdata[31:0];








  assign err_code_test_we = addr_hit[13] & reg_we & !reg_error;
  assign err_code_test_wd = reg_wdata[4:0];

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
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = regwen_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = ctrl_edn_enable_qs;
        reg_rdata_next[1] = ctrl_cmd_fifo_rst_qs;
        reg_rdata_next[2] = ctrl_auto_req_mode_qs;
        reg_rdata_next[3] = ctrl_boot_req_dis_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = sum_sts_req_mode_sm_sts_qs;
        reg_rdata_next[1] = sum_sts_boot_inst_ack_qs;
        reg_rdata_next[31] = sum_sts_internal_use_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = sw_cmd_sts_cmd_rdy_qs;
        reg_rdata_next[1] = sw_cmd_sts_cmd_sts_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = max_num_reqs_between_reseeds_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[0] = err_code_sfifo_rescmd_err_qs;
        reg_rdata_next[1] = err_code_sfifo_gencmd_err_qs;
        reg_rdata_next[20] = err_code_edn_ack_sm_err_qs;
        reg_rdata_next[21] = err_code_edn_main_sm_err_qs;
        reg_rdata_next[28] = err_code_fifo_write_err_qs;
        reg_rdata_next[29] = err_code_fifo_read_err_qs;
        reg_rdata_next[30] = err_code_fifo_state_err_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[4:0] = err_code_test_qs;
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
