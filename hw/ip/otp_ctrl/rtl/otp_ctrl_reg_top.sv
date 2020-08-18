// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module otp_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o  [3],
  input  tlul_pkg::tl_d2h_t tl_win_i  [3],

  // To HW
  output otp_ctrl_reg_pkg::otp_ctrl_reg2hw_t reg2hw, // Write
  input  otp_ctrl_reg_pkg::otp_ctrl_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import otp_ctrl_reg_pkg::* ;

  localparam int AW = 13;
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

  tlul_pkg::tl_h2d_t tl_socket_h2d [4];
  tlul_pkg::tl_d2h_t tl_socket_d2h [4];

  logic [2:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[3];
  assign tl_socket_d2h[3] = tl_reg_d2h;

  assign tl_win_o[0] = tl_socket_h2d[0];
  assign tl_socket_d2h[0] = tl_win_i[0];
  assign tl_win_o[1] = tl_socket_h2d[1];
  assign tl_socket_d2h[1] = tl_win_i[1];
  assign tl_win_o[2] = tl_socket_h2d[2];
  assign tl_socket_d2h[2] = tl_win_i[2];

  // Create Socket_1n
  tlul_socket_1n #(
    .N          (4),
    .HReqPass   (1'b1),
    .HRspPass   (1'b1),
    .DReqPass   ({4{1'b1}}),
    .DRspPass   ({4{1'b1}}),
    .HReqDepth  (4'h0),
    .HRspDepth  (4'h0),
    .DReqDepth  ({4{4'h0}}),
    .DRspDepth  ({4{4'h0}})
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
    reg_steer = 3;       // Default set to register

    // TODO: Can below codes be unique case () inside ?
    if (tl_i.a_address[AW-1:0] >= 1024 && tl_i.a_address[AW-1:0] < 1792) begin
      reg_steer = 0;
    end
    if (tl_i.a_address[AW-1:0] >= 2048 && tl_i.a_address[AW-1:0] < 2816) begin
      reg_steer = 1;
    end
    if (tl_i.a_address[AW-1:0] >= 4096 && tl_i.a_address[AW-1:0] < 6096) begin
      reg_steer = 2;
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
  logic intr_state_otp_operation_done_qs;
  logic intr_state_otp_operation_done_wd;
  logic intr_state_otp_operation_done_we;
  logic intr_state_otp_error_qs;
  logic intr_state_otp_error_wd;
  logic intr_state_otp_error_we;
  logic intr_enable_otp_operation_done_qs;
  logic intr_enable_otp_operation_done_wd;
  logic intr_enable_otp_operation_done_we;
  logic intr_enable_otp_error_qs;
  logic intr_enable_otp_error_wd;
  logic intr_enable_otp_error_we;
  logic intr_test_otp_operation_done_wd;
  logic intr_test_otp_operation_done_we;
  logic intr_test_otp_error_wd;
  logic intr_test_otp_error_we;
  logic [2:0] status_qs;
  logic [2:0] err_code_qs;
  logic direct_access_cmd_read_wd;
  logic direct_access_cmd_read_we;
  logic direct_access_cmd_write_wd;
  logic direct_access_cmd_write_we;
  logic [10:0] direct_access_address_qs;
  logic [10:0] direct_access_address_wd;
  logic direct_access_address_we;
  logic [31:0] direct_access_wdata_0_qs;
  logic [31:0] direct_access_wdata_0_wd;
  logic direct_access_wdata_0_we;
  logic [31:0] direct_access_wdata_1_qs;
  logic [31:0] direct_access_wdata_1_wd;
  logic direct_access_wdata_1_we;
  logic [31:0] direct_access_rdata_0_qs;
  logic [31:0] direct_access_rdata_1_qs;
  logic check_period_regen_qs;
  logic check_period_regen_wd;
  logic check_period_regen_we;
  logic [5:0] integrity_check_period_msb_qs;
  logic [5:0] integrity_check_period_msb_wd;
  logic integrity_check_period_msb_we;
  logic [5:0] consistency_check_period_msb_qs;
  logic [5:0] consistency_check_period_msb_wd;
  logic consistency_check_period_msb_we;
  logic creator_sw_cfg_read_lock_qs;
  logic creator_sw_cfg_read_lock_wd;
  logic creator_sw_cfg_read_lock_we;
  logic owner_sw_cfg_read_lock_qs;
  logic owner_sw_cfg_read_lock_wd;
  logic owner_sw_cfg_read_lock_we;
  logic hw_cfg_digest_calc_wd;
  logic hw_cfg_digest_calc_we;
  logic secret_digest_calc_wd;
  logic secret_digest_calc_we;
  logic [31:0] creator_sw_cfg_digest_qs;
  logic creator_sw_cfg_digest_re;
  logic [31:0] owner_sw_cfg_digest_qs;
  logic owner_sw_cfg_digest_re;
  logic [31:0] hw_cfg_digest_qs;
  logic hw_cfg_digest_re;
  logic [31:0] secret_digest_qs;
  logic secret_digest_re;
  logic [31:0] test_tokens_lock_qs;
  logic test_tokens_lock_re;
  logic [31:0] rma_token_lock_qs;
  logic rma_token_lock_re;
  logic [31:0] flash_keys_lock_qs;
  logic flash_keys_lock_re;
  logic [31:0] sram_key_lock_qs;
  logic sram_key_lock_re;
  logic [31:0] creator_key_lock_qs;
  logic creator_key_lock_re;
  logic [7:0] lc_state_0_lc_state_0_qs;
  logic [7:0] lc_state_0_lc_state_1_qs;
  logic [7:0] lc_state_0_lc_state_2_qs;
  logic [7:0] lc_state_0_lc_state_3_qs;
  logic [7:0] lc_state_1_lc_state_4_qs;
  logic [7:0] lc_state_1_lc_state_5_qs;
  logic [7:0] lc_state_1_lc_state_6_qs;
  logic [7:0] lc_state_1_lc_state_7_qs;
  logic [7:0] lc_state_2_qs;
  logic [31:0] transition_cnt_qs;

  // Register instances
  // R[intr_state]: V(False)

  //   F[otp_operation_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_otp_operation_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_otp_operation_done_we),
    .wd     (intr_state_otp_operation_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.otp_operation_done.de),
    .d      (hw2reg.intr_state.otp_operation_done.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.otp_operation_done.q ),

    // to register interface (read)
    .qs     (intr_state_otp_operation_done_qs)
  );


  //   F[otp_error]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_otp_error (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_otp_error_we),
    .wd     (intr_state_otp_error_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.otp_error.de),
    .d      (hw2reg.intr_state.otp_error.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.otp_error.q ),

    // to register interface (read)
    .qs     (intr_state_otp_error_qs)
  );


  // R[intr_enable]: V(False)

  //   F[otp_operation_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_otp_operation_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_otp_operation_done_we),
    .wd     (intr_enable_otp_operation_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.otp_operation_done.q ),

    // to register interface (read)
    .qs     (intr_enable_otp_operation_done_qs)
  );


  //   F[otp_error]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_otp_error (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_otp_error_we),
    .wd     (intr_enable_otp_error_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.otp_error.q ),

    // to register interface (read)
    .qs     (intr_enable_otp_error_qs)
  );


  // R[intr_test]: V(True)

  //   F[otp_operation_done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_otp_operation_done (
    .re     (1'b0),
    .we     (intr_test_otp_operation_done_we),
    .wd     (intr_test_otp_operation_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.otp_operation_done.qe),
    .q      (reg2hw.intr_test.otp_operation_done.q ),
    .qs     ()
  );


  //   F[otp_error]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_otp_error (
    .re     (1'b0),
    .we     (intr_test_otp_error_we),
    .wd     (intr_test_otp_error_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.otp_error.qe),
    .q      (reg2hw.intr_test.otp_error.q ),
    .qs     ()
  );


  // R[status]: V(False)

  prim_subreg #(
    .DW      (3),
    .SWACCESS("RO"),
    .RESVAL  (3'h0)
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


  // R[err_code]: V(False)

  prim_subreg #(
    .DW      (3),
    .SWACCESS("RO"),
    .RESVAL  (3'h0)
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


  // R[direct_access_cmd]: V(True)

  //   F[read]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_direct_access_cmd_read (
    .re     (1'b0),
    .we     (direct_access_cmd_read_we),
    .wd     (direct_access_cmd_read_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.direct_access_cmd.read.qe),
    .q      (reg2hw.direct_access_cmd.read.q ),
    .qs     ()
  );


  //   F[write]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_direct_access_cmd_write (
    .re     (1'b0),
    .we     (direct_access_cmd_write_we),
    .wd     (direct_access_cmd_write_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.direct_access_cmd.write.qe),
    .q      (reg2hw.direct_access_cmd.write.q ),
    .qs     ()
  );


  // R[direct_access_address]: V(False)

  prim_subreg #(
    .DW      (11),
    .SWACCESS("RW"),
    .RESVAL  (11'h0)
  ) u_direct_access_address (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (direct_access_address_we),
    .wd     (direct_access_address_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.direct_access_address.q ),

    // to register interface (read)
    .qs     (direct_access_address_qs)
  );



  // Subregister 0 of Multireg direct_access_wdata
  // R[direct_access_wdata_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_direct_access_wdata_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (direct_access_wdata_0_we),
    .wd     (direct_access_wdata_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.direct_access_wdata[0].qe),
    .q      (reg2hw.direct_access_wdata[0].q ),

    // to register interface (read)
    .qs     (direct_access_wdata_0_qs)
  );

  // Subregister 1 of Multireg direct_access_wdata
  // R[direct_access_wdata_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_direct_access_wdata_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (direct_access_wdata_1_we),
    .wd     (direct_access_wdata_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.direct_access_wdata[1].qe),
    .q      (reg2hw.direct_access_wdata[1].q ),

    // to register interface (read)
    .qs     (direct_access_wdata_1_qs)
  );



  // Subregister 0 of Multireg direct_access_rdata
  // R[direct_access_rdata_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_direct_access_rdata_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.direct_access_rdata[0].de),
    .d      (hw2reg.direct_access_rdata[0].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (direct_access_rdata_0_qs)
  );

  // Subregister 1 of Multireg direct_access_rdata
  // R[direct_access_rdata_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_direct_access_rdata_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.direct_access_rdata[1].de),
    .d      (hw2reg.direct_access_rdata[1].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (direct_access_rdata_1_qs)
  );


  // R[check_period_regen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_check_period_regen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (check_period_regen_we),
    .wd     (check_period_regen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.check_period_regen.q ),

    // to register interface (read)
    .qs     (check_period_regen_qs)
  );


  // R[integrity_check_period_msb]: V(False)

  prim_subreg #(
    .DW      (6),
    .SWACCESS("RW"),
    .RESVAL  (6'h1b)
  ) u_integrity_check_period_msb (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (integrity_check_period_msb_we & check_period_regen_qs),
    .wd     (integrity_check_period_msb_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.integrity_check_period_msb.q ),

    // to register interface (read)
    .qs     (integrity_check_period_msb_qs)
  );


  // R[consistency_check_period_msb]: V(False)

  prim_subreg #(
    .DW      (6),
    .SWACCESS("RW"),
    .RESVAL  (6'h1e)
  ) u_consistency_check_period_msb (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (consistency_check_period_msb_we & check_period_regen_qs),
    .wd     (consistency_check_period_msb_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.consistency_check_period_msb.q ),

    // to register interface (read)
    .qs     (consistency_check_period_msb_qs)
  );


  // R[creator_sw_cfg_read_lock]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_creator_sw_cfg_read_lock (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (creator_sw_cfg_read_lock_we),
    .wd     (creator_sw_cfg_read_lock_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.creator_sw_cfg_read_lock.q ),

    // to register interface (read)
    .qs     (creator_sw_cfg_read_lock_qs)
  );


  // R[owner_sw_cfg_read_lock]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_owner_sw_cfg_read_lock (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (owner_sw_cfg_read_lock_we),
    .wd     (owner_sw_cfg_read_lock_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.owner_sw_cfg_read_lock.q ),

    // to register interface (read)
    .qs     (owner_sw_cfg_read_lock_qs)
  );


  // R[hw_cfg_digest_calc]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_hw_cfg_digest_calc (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (hw_cfg_digest_calc_we),
    .wd     (hw_cfg_digest_calc_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.hw_cfg_digest_calc.q ),

    .qs     ()
  );


  // R[secret_digest_calc]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_secret_digest_calc (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (secret_digest_calc_we),
    .wd     (secret_digest_calc_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.secret_digest_calc.q ),

    .qs     ()
  );


  // R[creator_sw_cfg_digest]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_creator_sw_cfg_digest (
    .re     (creator_sw_cfg_digest_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.creator_sw_cfg_digest.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (creator_sw_cfg_digest_qs)
  );


  // R[owner_sw_cfg_digest]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_owner_sw_cfg_digest (
    .re     (owner_sw_cfg_digest_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.owner_sw_cfg_digest.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (owner_sw_cfg_digest_qs)
  );


  // R[hw_cfg_digest]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_hw_cfg_digest (
    .re     (hw_cfg_digest_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.hw_cfg_digest.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (hw_cfg_digest_qs)
  );


  // R[secret_digest]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_secret_digest (
    .re     (secret_digest_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.secret_digest.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (secret_digest_qs)
  );


  // R[test_tokens_lock]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_test_tokens_lock (
    .re     (test_tokens_lock_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.test_tokens_lock.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (test_tokens_lock_qs)
  );


  // R[rma_token_lock]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_rma_token_lock (
    .re     (rma_token_lock_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rma_token_lock.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (rma_token_lock_qs)
  );


  // R[flash_keys_lock]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_flash_keys_lock (
    .re     (flash_keys_lock_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.flash_keys_lock.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (flash_keys_lock_qs)
  );


  // R[sram_key_lock]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_sram_key_lock (
    .re     (sram_key_lock_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.sram_key_lock.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (sram_key_lock_qs)
  );


  // R[creator_key_lock]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_creator_key_lock (
    .re     (creator_key_lock_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.creator_key_lock.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (creator_key_lock_qs)
  );



  // Subregister 0 of Multireg lc_state
  // R[lc_state_0]: V(False)

  // F[lc_state_0]: 7:0
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_0_lc_state_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[0].de),
    .d      (hw2reg.lc_state[0].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_0_lc_state_0_qs)
  );


  // F[lc_state_1]: 15:8
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_0_lc_state_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[1].de),
    .d      (hw2reg.lc_state[1].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_0_lc_state_1_qs)
  );


  // F[lc_state_2]: 23:16
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_0_lc_state_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[2].de),
    .d      (hw2reg.lc_state[2].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_0_lc_state_2_qs)
  );


  // F[lc_state_3]: 31:24
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_0_lc_state_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[3].de),
    .d      (hw2reg.lc_state[3].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_0_lc_state_3_qs)
  );


  // Subregister 4 of Multireg lc_state
  // R[lc_state_1]: V(False)

  // F[lc_state_4]: 7:0
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_1_lc_state_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[4].de),
    .d      (hw2reg.lc_state[4].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_1_lc_state_4_qs)
  );


  // F[lc_state_5]: 15:8
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_1_lc_state_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[5].de),
    .d      (hw2reg.lc_state[5].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_1_lc_state_5_qs)
  );


  // F[lc_state_6]: 23:16
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_1_lc_state_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[6].de),
    .d      (hw2reg.lc_state[6].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_1_lc_state_6_qs)
  );


  // F[lc_state_7]: 31:24
  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_1_lc_state_7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[7].de),
    .d      (hw2reg.lc_state[7].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_1_lc_state_7_qs)
  );


  // Subregister 8 of Multireg lc_state
  // R[lc_state_2]: V(False)

  prim_subreg #(
    .DW      (8),
    .SWACCESS("RO"),
    .RESVAL  (8'h0)
  ) u_lc_state_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.lc_state[8].de),
    .d      (hw2reg.lc_state[8].d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (lc_state_2_qs)
  );


  // R[transition_cnt]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_transition_cnt (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.transition_cnt.de),
    .d      (hw2reg.transition_cnt.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (transition_cnt_qs)
  );




  logic [30:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == OTP_CTRL_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == OTP_CTRL_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == OTP_CTRL_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == OTP_CTRL_STATUS_OFFSET);
    addr_hit[ 4] = (reg_addr == OTP_CTRL_ERR_CODE_OFFSET);
    addr_hit[ 5] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_CMD_OFFSET);
    addr_hit[ 6] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_ADDRESS_OFFSET);
    addr_hit[ 7] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_WDATA_0_OFFSET);
    addr_hit[ 8] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_WDATA_1_OFFSET);
    addr_hit[ 9] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_RDATA_0_OFFSET);
    addr_hit[10] = (reg_addr == OTP_CTRL_DIRECT_ACCESS_RDATA_1_OFFSET);
    addr_hit[11] = (reg_addr == OTP_CTRL_CHECK_PERIOD_REGEN_OFFSET);
    addr_hit[12] = (reg_addr == OTP_CTRL_INTEGRITY_CHECK_PERIOD_MSB_OFFSET);
    addr_hit[13] = (reg_addr == OTP_CTRL_CONSISTENCY_CHECK_PERIOD_MSB_OFFSET);
    addr_hit[14] = (reg_addr == OTP_CTRL_CREATOR_SW_CFG_READ_LOCK_OFFSET);
    addr_hit[15] = (reg_addr == OTP_CTRL_OWNER_SW_CFG_READ_LOCK_OFFSET);
    addr_hit[16] = (reg_addr == OTP_CTRL_HW_CFG_DIGEST_CALC_OFFSET);
    addr_hit[17] = (reg_addr == OTP_CTRL_SECRET_DIGEST_CALC_OFFSET);
    addr_hit[18] = (reg_addr == OTP_CTRL_CREATOR_SW_CFG_DIGEST_OFFSET);
    addr_hit[19] = (reg_addr == OTP_CTRL_OWNER_SW_CFG_DIGEST_OFFSET);
    addr_hit[20] = (reg_addr == OTP_CTRL_HW_CFG_DIGEST_OFFSET);
    addr_hit[21] = (reg_addr == OTP_CTRL_SECRET_DIGEST_OFFSET);
    addr_hit[22] = (reg_addr == OTP_CTRL_TEST_TOKENS_LOCK_OFFSET);
    addr_hit[23] = (reg_addr == OTP_CTRL_RMA_TOKEN_LOCK_OFFSET);
    addr_hit[24] = (reg_addr == OTP_CTRL_FLASH_KEYS_LOCK_OFFSET);
    addr_hit[25] = (reg_addr == OTP_CTRL_SRAM_KEY_LOCK_OFFSET);
    addr_hit[26] = (reg_addr == OTP_CTRL_CREATOR_KEY_LOCK_OFFSET);
    addr_hit[27] = (reg_addr == OTP_CTRL_LC_STATE_0_OFFSET);
    addr_hit[28] = (reg_addr == OTP_CTRL_LC_STATE_1_OFFSET);
    addr_hit[29] = (reg_addr == OTP_CTRL_LC_STATE_2_OFFSET);
    addr_hit[30] = (reg_addr == OTP_CTRL_TRANSITION_CNT_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[ 0] && reg_we && (OTP_CTRL_PERMIT[ 0] != (OTP_CTRL_PERMIT[ 0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 1] && reg_we && (OTP_CTRL_PERMIT[ 1] != (OTP_CTRL_PERMIT[ 1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 2] && reg_we && (OTP_CTRL_PERMIT[ 2] != (OTP_CTRL_PERMIT[ 2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 3] && reg_we && (OTP_CTRL_PERMIT[ 3] != (OTP_CTRL_PERMIT[ 3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 4] && reg_we && (OTP_CTRL_PERMIT[ 4] != (OTP_CTRL_PERMIT[ 4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 5] && reg_we && (OTP_CTRL_PERMIT[ 5] != (OTP_CTRL_PERMIT[ 5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 6] && reg_we && (OTP_CTRL_PERMIT[ 6] != (OTP_CTRL_PERMIT[ 6] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 7] && reg_we && (OTP_CTRL_PERMIT[ 7] != (OTP_CTRL_PERMIT[ 7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 8] && reg_we && (OTP_CTRL_PERMIT[ 8] != (OTP_CTRL_PERMIT[ 8] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 9] && reg_we && (OTP_CTRL_PERMIT[ 9] != (OTP_CTRL_PERMIT[ 9] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[10] && reg_we && (OTP_CTRL_PERMIT[10] != (OTP_CTRL_PERMIT[10] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[11] && reg_we && (OTP_CTRL_PERMIT[11] != (OTP_CTRL_PERMIT[11] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[12] && reg_we && (OTP_CTRL_PERMIT[12] != (OTP_CTRL_PERMIT[12] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[13] && reg_we && (OTP_CTRL_PERMIT[13] != (OTP_CTRL_PERMIT[13] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[14] && reg_we && (OTP_CTRL_PERMIT[14] != (OTP_CTRL_PERMIT[14] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[15] && reg_we && (OTP_CTRL_PERMIT[15] != (OTP_CTRL_PERMIT[15] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[16] && reg_we && (OTP_CTRL_PERMIT[16] != (OTP_CTRL_PERMIT[16] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[17] && reg_we && (OTP_CTRL_PERMIT[17] != (OTP_CTRL_PERMIT[17] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[18] && reg_we && (OTP_CTRL_PERMIT[18] != (OTP_CTRL_PERMIT[18] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[19] && reg_we && (OTP_CTRL_PERMIT[19] != (OTP_CTRL_PERMIT[19] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[20] && reg_we && (OTP_CTRL_PERMIT[20] != (OTP_CTRL_PERMIT[20] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[21] && reg_we && (OTP_CTRL_PERMIT[21] != (OTP_CTRL_PERMIT[21] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[22] && reg_we && (OTP_CTRL_PERMIT[22] != (OTP_CTRL_PERMIT[22] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[23] && reg_we && (OTP_CTRL_PERMIT[23] != (OTP_CTRL_PERMIT[23] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[24] && reg_we && (OTP_CTRL_PERMIT[24] != (OTP_CTRL_PERMIT[24] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[25] && reg_we && (OTP_CTRL_PERMIT[25] != (OTP_CTRL_PERMIT[25] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[26] && reg_we && (OTP_CTRL_PERMIT[26] != (OTP_CTRL_PERMIT[26] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[27] && reg_we && (OTP_CTRL_PERMIT[27] != (OTP_CTRL_PERMIT[27] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[28] && reg_we && (OTP_CTRL_PERMIT[28] != (OTP_CTRL_PERMIT[28] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[29] && reg_we && (OTP_CTRL_PERMIT[29] != (OTP_CTRL_PERMIT[29] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[30] && reg_we && (OTP_CTRL_PERMIT[30] != (OTP_CTRL_PERMIT[30] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_otp_operation_done_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_otp_operation_done_wd = reg_wdata[0];

  assign intr_state_otp_error_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_otp_error_wd = reg_wdata[1];

  assign intr_enable_otp_operation_done_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_otp_operation_done_wd = reg_wdata[0];

  assign intr_enable_otp_error_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_otp_error_wd = reg_wdata[1];

  assign intr_test_otp_operation_done_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_otp_operation_done_wd = reg_wdata[0];

  assign intr_test_otp_error_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_otp_error_wd = reg_wdata[1];



  assign direct_access_cmd_read_we = addr_hit[5] & reg_we & ~wr_err;
  assign direct_access_cmd_read_wd = reg_wdata[0];

  assign direct_access_cmd_write_we = addr_hit[5] & reg_we & ~wr_err;
  assign direct_access_cmd_write_wd = reg_wdata[1];

  assign direct_access_address_we = addr_hit[6] & reg_we & ~wr_err;
  assign direct_access_address_wd = reg_wdata[10:0];

  assign direct_access_wdata_0_we = addr_hit[7] & reg_we & ~wr_err;
  assign direct_access_wdata_0_wd = reg_wdata[31:0];

  assign direct_access_wdata_1_we = addr_hit[8] & reg_we & ~wr_err;
  assign direct_access_wdata_1_wd = reg_wdata[31:0];



  assign check_period_regen_we = addr_hit[11] & reg_we & ~wr_err;
  assign check_period_regen_wd = reg_wdata[0];

  assign integrity_check_period_msb_we = addr_hit[12] & reg_we & ~wr_err;
  assign integrity_check_period_msb_wd = reg_wdata[5:0];

  assign consistency_check_period_msb_we = addr_hit[13] & reg_we & ~wr_err;
  assign consistency_check_period_msb_wd = reg_wdata[5:0];

  assign creator_sw_cfg_read_lock_we = addr_hit[14] & reg_we & ~wr_err;
  assign creator_sw_cfg_read_lock_wd = reg_wdata[0];

  assign owner_sw_cfg_read_lock_we = addr_hit[15] & reg_we & ~wr_err;
  assign owner_sw_cfg_read_lock_wd = reg_wdata[0];

  assign hw_cfg_digest_calc_we = addr_hit[16] & reg_we & ~wr_err;
  assign hw_cfg_digest_calc_wd = reg_wdata[0];

  assign secret_digest_calc_we = addr_hit[17] & reg_we & ~wr_err;
  assign secret_digest_calc_wd = reg_wdata[0];

  assign creator_sw_cfg_digest_re = addr_hit[18] && reg_re;

  assign owner_sw_cfg_digest_re = addr_hit[19] && reg_re;

  assign hw_cfg_digest_re = addr_hit[20] && reg_re;

  assign secret_digest_re = addr_hit[21] && reg_re;

  assign test_tokens_lock_re = addr_hit[22] && reg_re;

  assign rma_token_lock_re = addr_hit[23] && reg_re;

  assign flash_keys_lock_re = addr_hit[24] && reg_re;

  assign sram_key_lock_re = addr_hit[25] && reg_re;

  assign creator_key_lock_re = addr_hit[26] && reg_re;











  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_otp_operation_done_qs;
        reg_rdata_next[1] = intr_state_otp_error_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_otp_operation_done_qs;
        reg_rdata_next[1] = intr_enable_otp_error_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[2:0] = status_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[2:0] = err_code_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[6]: begin
        reg_rdata_next[10:0] = direct_access_address_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = direct_access_wdata_0_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = direct_access_wdata_1_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = direct_access_rdata_0_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = direct_access_rdata_1_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[0] = check_period_regen_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[5:0] = integrity_check_period_msb_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[5:0] = consistency_check_period_msb_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[0] = creator_sw_cfg_read_lock_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[0] = owner_sw_cfg_read_lock_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[17]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = creator_sw_cfg_digest_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = owner_sw_cfg_digest_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[31:0] = hw_cfg_digest_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[31:0] = secret_digest_qs;
      end

      addr_hit[22]: begin
        reg_rdata_next[31:0] = test_tokens_lock_qs;
      end

      addr_hit[23]: begin
        reg_rdata_next[31:0] = rma_token_lock_qs;
      end

      addr_hit[24]: begin
        reg_rdata_next[31:0] = flash_keys_lock_qs;
      end

      addr_hit[25]: begin
        reg_rdata_next[31:0] = sram_key_lock_qs;
      end

      addr_hit[26]: begin
        reg_rdata_next[31:0] = creator_key_lock_qs;
      end

      addr_hit[27]: begin
        reg_rdata_next[7:0] = lc_state_0_lc_state_0_qs;
        reg_rdata_next[15:8] = lc_state_0_lc_state_1_qs;
        reg_rdata_next[23:16] = lc_state_0_lc_state_2_qs;
        reg_rdata_next[31:24] = lc_state_0_lc_state_3_qs;
      end

      addr_hit[28]: begin
        reg_rdata_next[7:0] = lc_state_1_lc_state_4_qs;
        reg_rdata_next[15:8] = lc_state_1_lc_state_5_qs;
        reg_rdata_next[23:16] = lc_state_1_lc_state_6_qs;
        reg_rdata_next[31:24] = lc_state_1_lc_state_7_qs;
      end

      addr_hit[29]: begin
        reg_rdata_next[7:0] = lc_state_2_qs;
      end

      addr_hit[30]: begin
        reg_rdata_next[31:0] = transition_cnt_qs;
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
