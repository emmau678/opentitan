// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module otbn_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o  [2],
  input  tlul_pkg::tl_d2h_t tl_win_i  [2],

  // To HW
  output otbn_reg_pkg::otbn_reg2hw_t reg2hw, // Write
  input  otbn_reg_pkg::otbn_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import otbn_reg_pkg::* ;

  localparam int AW = 22;
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
    .clk_i,
    .rst_ni,
    .tl_h_i (tl_i),
    .tl_h_o (tl_o),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select_i (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer = 2;       // Default set to register

    // TODO: Can below codes be unique case () inside ?
    if (tl_i.a_address[AW-1:0] >= 1048576 && tl_i.a_address[AW-1:0] < 1052672) begin
      reg_steer = 0;
    end
    if (tl_i.a_address[AW-1:0] >= 2097152 && tl_i.a_address[AW-1:0] < 2101248) begin
      reg_steer = 1;
    end
  end

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
  logic intr_state_done_qs;
  logic intr_state_done_wd;
  logic intr_state_done_we;
  logic intr_state_err_qs;
  logic intr_state_err_wd;
  logic intr_state_err_we;
  logic intr_enable_done_qs;
  logic intr_enable_done_wd;
  logic intr_enable_done_we;
  logic intr_enable_err_qs;
  logic intr_enable_err_wd;
  logic intr_enable_err_we;
  logic intr_test_done_wd;
  logic intr_test_done_we;
  logic intr_test_err_wd;
  logic intr_test_err_we;
  logic cmd_start_wd;
  logic cmd_start_we;
  logic cmd_dummy_wd;
  logic cmd_dummy_we;
  logic status_busy_qs;
  logic status_busy_re;
  logic status_dummy_qs;
  logic status_dummy_re;
  logic [31:0] err_code_qs;
  logic [31:0] start_addr_wd;
  logic start_addr_we;

  // Register instances
  // R[intr_state]: V(False)

  //   F[done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_done_we),
    .wd     (intr_state_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.done.de),
    .d      (hw2reg.intr_state.done.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.done.q ),

    // to register interface (read)
    .qs     (intr_state_done_qs)
  );


  //   F[err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_err_we),
    .wd     (intr_state_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.err.de),
    .d      (hw2reg.intr_state.err.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.err.q ),

    // to register interface (read)
    .qs     (intr_state_err_qs)
  );


  // R[intr_enable]: V(False)

  //   F[done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_done_we),
    .wd     (intr_enable_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.done.q ),

    // to register interface (read)
    .qs     (intr_enable_done_qs)
  );


  //   F[err]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_err_we),
    .wd     (intr_enable_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.err.q ),

    // to register interface (read)
    .qs     (intr_enable_err_qs)
  );


  // R[intr_test]: V(True)

  //   F[done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_done (
    .re     (1'b0),
    .we     (intr_test_done_we),
    .wd     (intr_test_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.done.qe),
    .q      (reg2hw.intr_test.done.q ),
    .qs     ()
  );


  //   F[err]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_err (
    .re     (1'b0),
    .we     (intr_test_err_we),
    .wd     (intr_test_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.err.qe),
    .q      (reg2hw.intr_test.err.q ),
    .qs     ()
  );


  // R[cmd]: V(True)

  //   F[start]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_start (
    .re     (1'b0),
    .we     (cmd_start_we),
    .wd     (cmd_start_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.cmd.start.qe),
    .q      (reg2hw.cmd.start.q ),
    .qs     ()
  );


  //   F[dummy]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_dummy (
    .re     (1'b0),
    .we     (cmd_dummy_we),
    .wd     (cmd_dummy_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.cmd.dummy.qe),
    .q      (reg2hw.cmd.dummy.q ),
    .qs     ()
  );


  // R[status]: V(True)

  //   F[busy]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_busy (
    .re     (status_busy_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.busy.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_busy_qs)
  );


  //   F[dummy]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_dummy (
    .re     (status_dummy_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.dummy.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_dummy_qs)
  );


  // R[err_code]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_err_code (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.err_code.de),
    .d      (hw2reg.err_code.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_code_qs)
  );


  // R[start_addr]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_start_addr (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (start_addr_we),
    .wd     (start_addr_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.start_addr.q ),

    .qs     ()
  );




  logic [6:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == OTBN_INTR_STATE_OFFSET);
    addr_hit[1] = (reg_addr == OTBN_INTR_ENABLE_OFFSET);
    addr_hit[2] = (reg_addr == OTBN_INTR_TEST_OFFSET);
    addr_hit[3] = (reg_addr == OTBN_CMD_OFFSET);
    addr_hit[4] = (reg_addr == OTBN_STATUS_OFFSET);
    addr_hit[5] = (reg_addr == OTBN_ERR_CODE_OFFSET);
    addr_hit[6] = (reg_addr == OTBN_START_ADDR_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (OTBN_PERMIT[0] != (OTBN_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[1] && reg_we && (OTBN_PERMIT[1] != (OTBN_PERMIT[1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[2] && reg_we && (OTBN_PERMIT[2] != (OTBN_PERMIT[2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[3] && reg_we && (OTBN_PERMIT[3] != (OTBN_PERMIT[3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[4] && reg_we && (OTBN_PERMIT[4] != (OTBN_PERMIT[4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[5] && reg_we && (OTBN_PERMIT[5] != (OTBN_PERMIT[5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[6] && reg_we && (OTBN_PERMIT[6] != (OTBN_PERMIT[6] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_done_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_done_wd = reg_wdata[0];

  assign intr_state_err_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_err_wd = reg_wdata[1];

  assign intr_enable_done_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_done_wd = reg_wdata[0];

  assign intr_enable_err_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_err_wd = reg_wdata[1];

  assign intr_test_done_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_done_wd = reg_wdata[0];

  assign intr_test_err_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_err_wd = reg_wdata[1];

  assign cmd_start_we = addr_hit[3] & reg_we & ~wr_err;
  assign cmd_start_wd = reg_wdata[0];

  assign cmd_dummy_we = addr_hit[3] & reg_we & ~wr_err;
  assign cmd_dummy_wd = reg_wdata[1];

  assign status_busy_re = addr_hit[4] && reg_re;

  assign status_dummy_re = addr_hit[4] && reg_re;


  assign start_addr_we = addr_hit[6] & reg_we & ~wr_err;
  assign start_addr_wd = reg_wdata[31:0];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_done_qs;
        reg_rdata_next[1] = intr_state_err_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_done_qs;
        reg_rdata_next[1] = intr_enable_err_qs;
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
        reg_rdata_next[0] = status_busy_qs;
        reg_rdata_next[1] = status_dummy_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = err_code_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = '0;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0)

endmodule
