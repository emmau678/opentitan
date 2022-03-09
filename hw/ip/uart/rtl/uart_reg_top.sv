// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module uart_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output uart_reg_pkg::uart_reg2hw_t reg2hw, // Write
  input  uart_reg_pkg::uart_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import uart_reg_pkg::* ;

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
  logic intr_state_tx_watermark_qs;
  logic intr_state_tx_watermark_wd;
  logic intr_state_rx_watermark_qs;
  logic intr_state_rx_watermark_wd;
  logic intr_state_tx_empty_qs;
  logic intr_state_tx_empty_wd;
  logic intr_state_rx_overflow_qs;
  logic intr_state_rx_overflow_wd;
  logic intr_state_rx_frame_err_qs;
  logic intr_state_rx_frame_err_wd;
  logic intr_state_rx_break_err_qs;
  logic intr_state_rx_break_err_wd;
  logic intr_state_rx_timeout_qs;
  logic intr_state_rx_timeout_wd;
  logic intr_state_rx_parity_err_qs;
  logic intr_state_rx_parity_err_wd;
  logic intr_enable_we;
  logic intr_enable_tx_watermark_qs;
  logic intr_enable_tx_watermark_wd;
  logic intr_enable_rx_watermark_qs;
  logic intr_enable_rx_watermark_wd;
  logic intr_enable_tx_empty_qs;
  logic intr_enable_tx_empty_wd;
  logic intr_enable_rx_overflow_qs;
  logic intr_enable_rx_overflow_wd;
  logic intr_enable_rx_frame_err_qs;
  logic intr_enable_rx_frame_err_wd;
  logic intr_enable_rx_break_err_qs;
  logic intr_enable_rx_break_err_wd;
  logic intr_enable_rx_timeout_qs;
  logic intr_enable_rx_timeout_wd;
  logic intr_enable_rx_parity_err_qs;
  logic intr_enable_rx_parity_err_wd;
  logic intr_test_we;
  logic intr_test_tx_watermark_wd;
  logic intr_test_rx_watermark_wd;
  logic intr_test_tx_empty_wd;
  logic intr_test_rx_overflow_wd;
  logic intr_test_rx_frame_err_wd;
  logic intr_test_rx_break_err_wd;
  logic intr_test_rx_timeout_wd;
  logic intr_test_rx_parity_err_wd;
  logic alert_test_we;
  logic alert_test_wd;
  logic ctrl_we;
  logic ctrl_tx_qs;
  logic ctrl_tx_wd;
  logic ctrl_rx_qs;
  logic ctrl_rx_wd;
  logic ctrl_nf_qs;
  logic ctrl_nf_wd;
  logic ctrl_slpbk_qs;
  logic ctrl_slpbk_wd;
  logic ctrl_llpbk_qs;
  logic ctrl_llpbk_wd;
  logic ctrl_parity_en_qs;
  logic ctrl_parity_en_wd;
  logic ctrl_parity_odd_qs;
  logic ctrl_parity_odd_wd;
  logic [1:0] ctrl_rxblvl_qs;
  logic [1:0] ctrl_rxblvl_wd;
  logic [15:0] ctrl_nco_qs;
  logic [15:0] ctrl_nco_wd;
  logic status_re;
  logic status_txfull_qs;
  logic status_rxfull_qs;
  logic status_txempty_qs;
  logic status_txidle_qs;
  logic status_rxidle_qs;
  logic status_rxempty_qs;
  logic rdata_re;
  logic [7:0] rdata_qs;
  logic wdata_we;
  logic [7:0] wdata_wd;
  logic fifo_ctrl_we;
  logic fifo_ctrl_rxrst_wd;
  logic fifo_ctrl_txrst_wd;
  logic [2:0] fifo_ctrl_rxilvl_qs;
  logic [2:0] fifo_ctrl_rxilvl_wd;
  logic [1:0] fifo_ctrl_txilvl_qs;
  logic [1:0] fifo_ctrl_txilvl_wd;
  logic fifo_status_re;
  logic [5:0] fifo_status_txlvl_qs;
  logic [5:0] fifo_status_rxlvl_qs;
  logic ovrd_we;
  logic ovrd_txen_qs;
  logic ovrd_txen_wd;
  logic ovrd_txval_qs;
  logic ovrd_txval_wd;
  logic val_re;
  logic [15:0] val_qs;
  logic timeout_ctrl_we;
  logic [23:0] timeout_ctrl_val_qs;
  logic [23:0] timeout_ctrl_val_wd;
  logic timeout_ctrl_en_qs;
  logic timeout_ctrl_en_wd;

  // Register instances
  // R[intr_state]: V(False)
  //   F[tx_watermark]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_tx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_tx_watermark_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_watermark.de),
    .d      (hw2reg.intr_state.tx_watermark.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_watermark.q),

    // to register interface (read)
    .qs     (intr_state_tx_watermark_qs)
  );

  //   F[rx_watermark]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_watermark_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_watermark.de),
    .d      (hw2reg.intr_state.rx_watermark.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_watermark.q),

    // to register interface (read)
    .qs     (intr_state_rx_watermark_qs)
  );

  //   F[tx_empty]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_tx_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_tx_empty_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_empty.de),
    .d      (hw2reg.intr_state.tx_empty.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_empty.q),

    // to register interface (read)
    .qs     (intr_state_tx_empty_qs)
  );

  //   F[rx_overflow]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_overflow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_overflow_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_overflow.de),
    .d      (hw2reg.intr_state.rx_overflow.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_overflow.q),

    // to register interface (read)
    .qs     (intr_state_rx_overflow_qs)
  );

  //   F[rx_frame_err]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_frame_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_frame_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_frame_err.de),
    .d      (hw2reg.intr_state.rx_frame_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_frame_err.q),

    // to register interface (read)
    .qs     (intr_state_rx_frame_err_qs)
  );

  //   F[rx_break_err]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_break_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_break_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_break_err.de),
    .d      (hw2reg.intr_state.rx_break_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_break_err.q),

    // to register interface (read)
    .qs     (intr_state_rx_break_err_qs)
  );

  //   F[rx_timeout]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_timeout_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_timeout.de),
    .d      (hw2reg.intr_state.rx_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_timeout.q),

    // to register interface (read)
    .qs     (intr_state_rx_timeout_qs)
  );

  //   F[rx_parity_err]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_intr_state_rx_parity_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_parity_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_parity_err.de),
    .d      (hw2reg.intr_state.rx_parity_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_parity_err.q),

    // to register interface (read)
    .qs     (intr_state_rx_parity_err_qs)
  );


  // R[intr_enable]: V(False)
  //   F[tx_watermark]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_tx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_watermark.q),

    // to register interface (read)
    .qs     (intr_enable_tx_watermark_qs)
  );

  //   F[rx_watermark]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_watermark.q),

    // to register interface (read)
    .qs     (intr_enable_rx_watermark_qs)
  );

  //   F[tx_empty]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_tx_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_empty_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_empty.q),

    // to register interface (read)
    .qs     (intr_enable_tx_empty_qs)
  );

  //   F[rx_overflow]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_overflow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_overflow_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_overflow.q),

    // to register interface (read)
    .qs     (intr_enable_rx_overflow_qs)
  );

  //   F[rx_frame_err]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_frame_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_frame_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_frame_err.q),

    // to register interface (read)
    .qs     (intr_enable_rx_frame_err_qs)
  );

  //   F[rx_break_err]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_break_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_break_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_break_err.q),

    // to register interface (read)
    .qs     (intr_enable_rx_break_err_qs)
  );

  //   F[rx_timeout]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_timeout_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_timeout.q),

    // to register interface (read)
    .qs     (intr_enable_rx_timeout_qs)
  );

  //   F[rx_parity_err]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_intr_enable_rx_parity_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_parity_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_parity_err.q),

    // to register interface (read)
    .qs     (intr_enable_rx_parity_err_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [7:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  //   F[tx_watermark]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_watermark (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_watermark_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.tx_watermark.q),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_watermark.qe = intr_test_qe;

  //   F[rx_watermark]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_watermark (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_watermark_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[1]),
    .q      (reg2hw.intr_test.rx_watermark.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_watermark.qe = intr_test_qe;

  //   F[tx_empty]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_empty (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_empty_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[2]),
    .q      (reg2hw.intr_test.tx_empty.q),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_empty.qe = intr_test_qe;

  //   F[rx_overflow]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_overflow (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_overflow_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[3]),
    .q      (reg2hw.intr_test.rx_overflow.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_overflow.qe = intr_test_qe;

  //   F[rx_frame_err]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_frame_err (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_frame_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[4]),
    .q      (reg2hw.intr_test.rx_frame_err.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_frame_err.qe = intr_test_qe;

  //   F[rx_break_err]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_break_err (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_break_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[5]),
    .q      (reg2hw.intr_test.rx_break_err.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_break_err.qe = intr_test_qe;

  //   F[rx_timeout]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_timeout (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_timeout_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[6]),
    .q      (reg2hw.intr_test.rx_timeout.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_timeout.qe = intr_test_qe;

  //   F[rx_parity_err]: 7:7
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_parity_err (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_parity_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[7]),
    .q      (reg2hw.intr_test.rx_parity_err.q),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_parity_err.qe = intr_test_qe;


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


  // R[ctrl]: V(False)
  //   F[tx]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_tx (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_tx_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.tx.q),

    // to register interface (read)
    .qs     (ctrl_tx_qs)
  );

  //   F[rx]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_rx (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_rx_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.rx.q),

    // to register interface (read)
    .qs     (ctrl_rx_qs)
  );

  //   F[nf]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_nf (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_nf_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.nf.q),

    // to register interface (read)
    .qs     (ctrl_nf_qs)
  );

  //   F[slpbk]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_slpbk (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_slpbk_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.slpbk.q),

    // to register interface (read)
    .qs     (ctrl_slpbk_qs)
  );

  //   F[llpbk]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_llpbk (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_llpbk_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.llpbk.q),

    // to register interface (read)
    .qs     (ctrl_llpbk_qs)
  );

  //   F[parity_en]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_parity_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_parity_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.parity_en.q),

    // to register interface (read)
    .qs     (ctrl_parity_en_qs)
  );

  //   F[parity_odd]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ctrl_parity_odd (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_parity_odd_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.parity_odd.q),

    // to register interface (read)
    .qs     (ctrl_parity_odd_qs)
  );

  //   F[rxblvl]: 9:8
  prim_subreg #(
    .DW      (2),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (2'h0)
  ) u_ctrl_rxblvl (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_rxblvl_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.rxblvl.q),

    // to register interface (read)
    .qs     (ctrl_rxblvl_qs)
  );

  //   F[nco]: 31:16
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'h0)
  ) u_ctrl_nco (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_nco_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.nco.q),

    // to register interface (read)
    .qs     (ctrl_nco_qs)
  );


  // R[status]: V(True)
  //   F[txfull]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_txfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.txfull.d),
    .qre    (reg2hw.status.txfull.re),
    .qe     (),
    .q      (reg2hw.status.txfull.q),
    .qs     (status_txfull_qs)
  );

  //   F[rxfull]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rxfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rxfull.d),
    .qre    (reg2hw.status.rxfull.re),
    .qe     (),
    .q      (reg2hw.status.rxfull.q),
    .qs     (status_rxfull_qs)
  );

  //   F[txempty]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_txempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.txempty.d),
    .qre    (reg2hw.status.txempty.re),
    .qe     (),
    .q      (reg2hw.status.txempty.q),
    .qs     (status_txempty_qs)
  );

  //   F[txidle]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_txidle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.txidle.d),
    .qre    (reg2hw.status.txidle.re),
    .qe     (),
    .q      (reg2hw.status.txidle.q),
    .qs     (status_txidle_qs)
  );

  //   F[rxidle]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rxidle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rxidle.d),
    .qre    (reg2hw.status.rxidle.re),
    .qe     (),
    .q      (reg2hw.status.rxidle.q),
    .qs     (status_rxidle_qs)
  );

  //   F[rxempty]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rxempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rxempty.d),
    .qre    (reg2hw.status.rxempty.re),
    .qe     (),
    .q      (reg2hw.status.rxempty.q),
    .qs     (status_rxempty_qs)
  );


  // R[rdata]: V(True)
  prim_subreg_ext #(
    .DW    (8)
  ) u_rdata (
    .re     (rdata_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rdata.d),
    .qre    (reg2hw.rdata.re),
    .qe     (),
    .q      (reg2hw.rdata.q),
    .qs     (rdata_qs)
  );


  // R[wdata]: V(False)
  logic wdata_qe;
  logic [0:0] wdata_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_wdata0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&wdata_flds_we),
    .q_o(wdata_qe)
  );
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (8'h0)
  ) u_wdata (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wdata_we),
    .wd     (wdata_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (wdata_flds_we[0]),
    .q      (reg2hw.wdata.q),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.wdata.qe = wdata_qe;


  // R[fifo_ctrl]: V(False)
  logic fifo_ctrl_qe;
  logic [3:0] fifo_ctrl_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_fifo_ctrl0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&fifo_ctrl_flds_we),
    .q_o(fifo_ctrl_qe)
  );
  //   F[rxrst]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0)
  ) u_fifo_ctrl_rxrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_rxrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[0]),
    .q      (reg2hw.fifo_ctrl.rxrst.q),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.rxrst.qe = fifo_ctrl_qe;

  //   F[txrst]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0)
  ) u_fifo_ctrl_txrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_txrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[1]),
    .q      (reg2hw.fifo_ctrl.txrst.q),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.txrst.qe = fifo_ctrl_qe;

  //   F[rxilvl]: 4:2
  prim_subreg #(
    .DW      (3),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (3'h0)
  ) u_fifo_ctrl_rxilvl (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_rxilvl_wd),

    // from internal hardware
    .de     (hw2reg.fifo_ctrl.rxilvl.de),
    .d      (hw2reg.fifo_ctrl.rxilvl.d),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[2]),
    .q      (reg2hw.fifo_ctrl.rxilvl.q),

    // to register interface (read)
    .qs     (fifo_ctrl_rxilvl_qs)
  );
  assign reg2hw.fifo_ctrl.rxilvl.qe = fifo_ctrl_qe;

  //   F[txilvl]: 6:5
  prim_subreg #(
    .DW      (2),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (2'h0)
  ) u_fifo_ctrl_txilvl (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_txilvl_wd),

    // from internal hardware
    .de     (hw2reg.fifo_ctrl.txilvl.de),
    .d      (hw2reg.fifo_ctrl.txilvl.d),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[3]),
    .q      (reg2hw.fifo_ctrl.txilvl.q),

    // to register interface (read)
    .qs     (fifo_ctrl_txilvl_qs)
  );
  assign reg2hw.fifo_ctrl.txilvl.qe = fifo_ctrl_qe;


  // R[fifo_status]: V(True)
  //   F[txlvl]: 5:0
  prim_subreg_ext #(
    .DW    (6)
  ) u_fifo_status_txlvl (
    .re     (fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.fifo_status.txlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (fifo_status_txlvl_qs)
  );

  //   F[rxlvl]: 21:16
  prim_subreg_ext #(
    .DW    (6)
  ) u_fifo_status_rxlvl (
    .re     (fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.fifo_status.rxlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (fifo_status_rxlvl_qs)
  );


  // R[ovrd]: V(False)
  //   F[txen]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ovrd_txen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ovrd_we),
    .wd     (ovrd_txen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ovrd.txen.q),

    // to register interface (read)
    .qs     (ovrd_txen_qs)
  );

  //   F[txval]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ovrd_txval (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ovrd_we),
    .wd     (ovrd_txval_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ovrd.txval.q),

    // to register interface (read)
    .qs     (ovrd_txval_qs)
  );


  // R[val]: V(True)
  prim_subreg_ext #(
    .DW    (16)
  ) u_val (
    .re     (val_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.val.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (val_qs)
  );


  // R[timeout_ctrl]: V(False)
  //   F[val]: 23:0
  prim_subreg #(
    .DW      (24),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (24'h0)
  ) u_timeout_ctrl_val (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timeout_ctrl_we),
    .wd     (timeout_ctrl_val_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timeout_ctrl.val.q),

    // to register interface (read)
    .qs     (timeout_ctrl_val_qs)
  );

  //   F[en]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_timeout_ctrl_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timeout_ctrl_we),
    .wd     (timeout_ctrl_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timeout_ctrl.en.q),

    // to register interface (read)
    .qs     (timeout_ctrl_en_qs)
  );



  logic [12:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == UART_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == UART_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == UART_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == UART_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == UART_CTRL_OFFSET);
    addr_hit[ 5] = (reg_addr == UART_STATUS_OFFSET);
    addr_hit[ 6] = (reg_addr == UART_RDATA_OFFSET);
    addr_hit[ 7] = (reg_addr == UART_WDATA_OFFSET);
    addr_hit[ 8] = (reg_addr == UART_FIFO_CTRL_OFFSET);
    addr_hit[ 9] = (reg_addr == UART_FIFO_STATUS_OFFSET);
    addr_hit[10] = (reg_addr == UART_OVRD_OFFSET);
    addr_hit[11] = (reg_addr == UART_VAL_OFFSET);
    addr_hit[12] = (reg_addr == UART_TIMEOUT_CTRL_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(UART_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(UART_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(UART_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(UART_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(UART_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(UART_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(UART_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(UART_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(UART_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(UART_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(UART_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(UART_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(UART_PERMIT[12] & ~reg_be)))));
  end
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_tx_watermark_wd = reg_wdata[0];

  assign intr_state_rx_watermark_wd = reg_wdata[1];

  assign intr_state_tx_empty_wd = reg_wdata[2];

  assign intr_state_rx_overflow_wd = reg_wdata[3];

  assign intr_state_rx_frame_err_wd = reg_wdata[4];

  assign intr_state_rx_break_err_wd = reg_wdata[5];

  assign intr_state_rx_timeout_wd = reg_wdata[6];

  assign intr_state_rx_parity_err_wd = reg_wdata[7];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_tx_watermark_wd = reg_wdata[0];

  assign intr_enable_rx_watermark_wd = reg_wdata[1];

  assign intr_enable_tx_empty_wd = reg_wdata[2];

  assign intr_enable_rx_overflow_wd = reg_wdata[3];

  assign intr_enable_rx_frame_err_wd = reg_wdata[4];

  assign intr_enable_rx_break_err_wd = reg_wdata[5];

  assign intr_enable_rx_timeout_wd = reg_wdata[6];

  assign intr_enable_rx_parity_err_wd = reg_wdata[7];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_tx_watermark_wd = reg_wdata[0];

  assign intr_test_rx_watermark_wd = reg_wdata[1];

  assign intr_test_tx_empty_wd = reg_wdata[2];

  assign intr_test_rx_overflow_wd = reg_wdata[3];

  assign intr_test_rx_frame_err_wd = reg_wdata[4];

  assign intr_test_rx_break_err_wd = reg_wdata[5];

  assign intr_test_rx_timeout_wd = reg_wdata[6];

  assign intr_test_rx_parity_err_wd = reg_wdata[7];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign ctrl_we = addr_hit[4] & reg_we & !reg_error;

  assign ctrl_tx_wd = reg_wdata[0];

  assign ctrl_rx_wd = reg_wdata[1];

  assign ctrl_nf_wd = reg_wdata[2];

  assign ctrl_slpbk_wd = reg_wdata[4];

  assign ctrl_llpbk_wd = reg_wdata[5];

  assign ctrl_parity_en_wd = reg_wdata[6];

  assign ctrl_parity_odd_wd = reg_wdata[7];

  assign ctrl_rxblvl_wd = reg_wdata[9:8];

  assign ctrl_nco_wd = reg_wdata[31:16];
  assign status_re = addr_hit[5] & reg_re & !reg_error;
  assign rdata_re = addr_hit[6] & reg_re & !reg_error;
  assign wdata_we = addr_hit[7] & reg_we & !reg_error;

  assign wdata_wd = reg_wdata[7:0];
  assign fifo_ctrl_we = addr_hit[8] & reg_we & !reg_error;

  assign fifo_ctrl_rxrst_wd = reg_wdata[0];

  assign fifo_ctrl_txrst_wd = reg_wdata[1];

  assign fifo_ctrl_rxilvl_wd = reg_wdata[4:2];

  assign fifo_ctrl_txilvl_wd = reg_wdata[6:5];
  assign fifo_status_re = addr_hit[9] & reg_re & !reg_error;
  assign ovrd_we = addr_hit[10] & reg_we & !reg_error;

  assign ovrd_txen_wd = reg_wdata[0];

  assign ovrd_txval_wd = reg_wdata[1];
  assign val_re = addr_hit[11] & reg_re & !reg_error;
  assign timeout_ctrl_we = addr_hit[12] & reg_we & !reg_error;

  assign timeout_ctrl_val_wd = reg_wdata[23:0];

  assign timeout_ctrl_en_wd = reg_wdata[31];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_tx_watermark_qs;
        reg_rdata_next[1] = intr_state_rx_watermark_qs;
        reg_rdata_next[2] = intr_state_tx_empty_qs;
        reg_rdata_next[3] = intr_state_rx_overflow_qs;
        reg_rdata_next[4] = intr_state_rx_frame_err_qs;
        reg_rdata_next[5] = intr_state_rx_break_err_qs;
        reg_rdata_next[6] = intr_state_rx_timeout_qs;
        reg_rdata_next[7] = intr_state_rx_parity_err_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_tx_watermark_qs;
        reg_rdata_next[1] = intr_enable_rx_watermark_qs;
        reg_rdata_next[2] = intr_enable_tx_empty_qs;
        reg_rdata_next[3] = intr_enable_rx_overflow_qs;
        reg_rdata_next[4] = intr_enable_rx_frame_err_qs;
        reg_rdata_next[5] = intr_enable_rx_break_err_qs;
        reg_rdata_next[6] = intr_enable_rx_timeout_qs;
        reg_rdata_next[7] = intr_enable_rx_parity_err_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
        reg_rdata_next[4] = '0;
        reg_rdata_next[5] = '0;
        reg_rdata_next[6] = '0;
        reg_rdata_next[7] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ctrl_tx_qs;
        reg_rdata_next[1] = ctrl_rx_qs;
        reg_rdata_next[2] = ctrl_nf_qs;
        reg_rdata_next[4] = ctrl_slpbk_qs;
        reg_rdata_next[5] = ctrl_llpbk_qs;
        reg_rdata_next[6] = ctrl_parity_en_qs;
        reg_rdata_next[7] = ctrl_parity_odd_qs;
        reg_rdata_next[9:8] = ctrl_rxblvl_qs;
        reg_rdata_next[31:16] = ctrl_nco_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = status_txfull_qs;
        reg_rdata_next[1] = status_rxfull_qs;
        reg_rdata_next[2] = status_txempty_qs;
        reg_rdata_next[3] = status_txidle_qs;
        reg_rdata_next[4] = status_rxidle_qs;
        reg_rdata_next[5] = status_rxempty_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[7:0] = rdata_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[7:0] = '0;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[4:2] = fifo_ctrl_rxilvl_qs;
        reg_rdata_next[6:5] = fifo_ctrl_txilvl_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[5:0] = fifo_status_txlvl_qs;
        reg_rdata_next[21:16] = fifo_status_rxlvl_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = ovrd_txen_qs;
        reg_rdata_next[1] = ovrd_txval_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[15:0] = val_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[23:0] = timeout_ctrl_val_qs;
        reg_rdata_next[31] = timeout_ctrl_en_qs;
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
