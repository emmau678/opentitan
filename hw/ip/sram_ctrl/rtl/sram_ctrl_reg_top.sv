// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module sram_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output sram_ctrl_reg_pkg::sram_ctrl_reg2hw_t reg2hw, // Write
  input  sram_ctrl_reg_pkg::sram_ctrl_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import sram_ctrl_reg_pkg::* ;

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
  logic alert_test_fatal_intg_error_wd;
  logic alert_test_fatal_intg_error_we;
  logic alert_test_fatal_parity_error_wd;
  logic alert_test_fatal_parity_error_we;
  logic status_error_qs;
  logic status_error_re;
  logic status_escalated_qs;
  logic status_escalated_re;
  logic status_scr_key_valid_qs;
  logic status_scr_key_valid_re;
  logic status_scr_key_seed_valid_qs;
  logic status_scr_key_seed_valid_re;
  logic exec_regwen_qs;
  logic exec_regwen_wd;
  logic exec_regwen_we;
  logic [2:0] exec_qs;
  logic [2:0] exec_wd;
  logic exec_we;
  logic ctrl_regwen_qs;
  logic ctrl_regwen_wd;
  logic ctrl_regwen_we;
  logic ctrl_wd;
  logic ctrl_we;
  logic [31:0] error_address_qs;

  // Register instances
  // R[alert_test]: V(True)

  //   F[fatal_intg_error]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_intg_error (
    .re     (1'b0),
    .we     (alert_test_fatal_intg_error_we),
    .wd     (alert_test_fatal_intg_error_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.fatal_intg_error.qe),
    .q      (reg2hw.alert_test.fatal_intg_error.q ),
    .qs     ()
  );


  //   F[fatal_parity_error]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_parity_error (
    .re     (1'b0),
    .we     (alert_test_fatal_parity_error_we),
    .wd     (alert_test_fatal_parity_error_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.fatal_parity_error.qe),
    .q      (reg2hw.alert_test.fatal_parity_error.q ),
    .qs     ()
  );


  // R[status]: V(True)

  //   F[error]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_error (
    .re     (status_error_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.error.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_error_qs)
  );


  //   F[escalated]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_escalated (
    .re     (status_escalated_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.escalated.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_escalated_qs)
  );


  //   F[scr_key_valid]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_scr_key_valid (
    .re     (status_scr_key_valid_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.scr_key_valid.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_scr_key_valid_qs)
  );


  //   F[scr_key_seed_valid]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_scr_key_seed_valid (
    .re     (status_scr_key_seed_valid_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.scr_key_seed_valid.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_scr_key_seed_valid_qs)
  );


  // R[exec_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_exec_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (exec_regwen_we),
    .wd     (exec_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (exec_regwen_qs)
  );


  // R[exec]: V(False)

  prim_subreg #(
    .DW      (3),
    .SWACCESS("RW"),
    .RESVAL  (3'h0)
  ) u_exec (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (exec_we & exec_regwen_qs),
    .wd     (exec_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.exec.q ),

    // to register interface (read)
    .qs     (exec_qs)
  );


  // R[ctrl_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_ctrl_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ctrl_regwen_we),
    .wd     (ctrl_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (ctrl_regwen_qs)
  );


  // R[ctrl]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_ctrl (
    .re     (1'b0),
    // qualified with register enable
    .we     (ctrl_we & ctrl_regwen_qs),
    .wd     (ctrl_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.ctrl.qe),
    .q      (reg2hw.ctrl.q ),
    .qs     ()
  );


  // R[error_address]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_error_address (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.error_address.de),
    .d      (hw2reg.error_address.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (error_address_qs)
  );




  logic [6:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == SRAM_CTRL_ALERT_TEST_OFFSET);
    addr_hit[1] = (reg_addr == SRAM_CTRL_STATUS_OFFSET);
    addr_hit[2] = (reg_addr == SRAM_CTRL_EXEC_REGWEN_OFFSET);
    addr_hit[3] = (reg_addr == SRAM_CTRL_EXEC_OFFSET);
    addr_hit[4] = (reg_addr == SRAM_CTRL_CTRL_REGWEN_OFFSET);
    addr_hit[5] = (reg_addr == SRAM_CTRL_CTRL_OFFSET);
    addr_hit[6] = (reg_addr == SRAM_CTRL_ERROR_ADDRESS_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (SRAM_CTRL_PERMIT[0] != (SRAM_CTRL_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (SRAM_CTRL_PERMIT[1] != (SRAM_CTRL_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (SRAM_CTRL_PERMIT[2] != (SRAM_CTRL_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (SRAM_CTRL_PERMIT[3] != (SRAM_CTRL_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (SRAM_CTRL_PERMIT[4] != (SRAM_CTRL_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[5] && reg_we && (SRAM_CTRL_PERMIT[5] != (SRAM_CTRL_PERMIT[5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[6] && reg_we && (SRAM_CTRL_PERMIT[6] != (SRAM_CTRL_PERMIT[6] & reg_be))) wr_err = 1'b1 ;
  end

  assign alert_test_fatal_intg_error_we = addr_hit[0] & reg_we & !reg_error;
  assign alert_test_fatal_intg_error_wd = reg_wdata[0];

  assign alert_test_fatal_parity_error_we = addr_hit[0] & reg_we & !reg_error;
  assign alert_test_fatal_parity_error_wd = reg_wdata[1];

  assign status_error_re = addr_hit[1] & reg_re & !reg_error;

  assign status_escalated_re = addr_hit[1] & reg_re & !reg_error;

  assign status_scr_key_valid_re = addr_hit[1] & reg_re & !reg_error;

  assign status_scr_key_seed_valid_re = addr_hit[1] & reg_re & !reg_error;

  assign exec_regwen_we = addr_hit[2] & reg_we & !reg_error;
  assign exec_regwen_wd = reg_wdata[0];

  assign exec_we = addr_hit[3] & reg_we & !reg_error;
  assign exec_wd = reg_wdata[2:0];

  assign ctrl_regwen_we = addr_hit[4] & reg_we & !reg_error;
  assign ctrl_regwen_wd = reg_wdata[0];

  assign ctrl_we = addr_hit[5] & reg_we & !reg_error;
  assign ctrl_wd = reg_wdata[0];


  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = status_error_qs;
        reg_rdata_next[1] = status_escalated_qs;
        reg_rdata_next[2] = status_scr_key_valid_qs;
        reg_rdata_next[3] = status_scr_key_seed_valid_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = exec_regwen_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[2:0] = exec_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ctrl_regwen_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = error_address_qs;
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
