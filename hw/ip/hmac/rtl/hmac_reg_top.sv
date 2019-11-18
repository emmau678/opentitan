// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

module hmac_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o  [1],
  input  tlul_pkg::tl_d2h_t tl_win_i  [1],

  // To HW
  output hmac_reg_pkg::hmac_reg2hw_t reg2hw, // Write
  input  hmac_reg_pkg::hmac_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import hmac_reg_pkg::* ;

  localparam AW = 12;
  localparam DW = 32;
  localparam DBW = DW/8;                    // Byte Width

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

  tlul_pkg::tl_h2d_t tl_socket_h2d [2];
  tlul_pkg::tl_d2h_t tl_socket_d2h [2];

  logic [1:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[1];
  assign tl_socket_d2h[1] = tl_reg_d2h;

  assign tl_win_o[0] = tl_socket_h2d[0];
  assign tl_socket_d2h[0] = tl_win_i[0];

  // Create Socket_1n
  tlul_socket_1n #(
    .N          (2),
    .HReqPass   (1'b1),
    .HRspPass   (1'b1),
    .DReqPass   ({2{1'b1}}),
    .DRspPass   ({2{1'b1}}),
    .HReqDepth  (4'h0),
    .HRspDepth  (4'h0),
    .DReqDepth  ({2{4'h0}}),
    .DRspDepth  ({2{4'h0}})
  ) u_socket (
    .clk_i,
    .rst_ni,
    .tl_h_i (tl_i),
    .tl_h_o (tl_o),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer = 1;       // Default set to register

    // TODO: Can below codes be unique case () inside ?
    if (tl_i.a_address[AW-1:0] >= 2048) begin
      // Exceed or meet the address range. Removed the comparison of limit addr 'h 1000
      reg_steer = 0;
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
  logic intr_state_hmac_done_qs;
  logic intr_state_hmac_done_wd;
  logic intr_state_hmac_done_we;
  logic intr_state_fifo_full_qs;
  logic intr_state_fifo_full_wd;
  logic intr_state_fifo_full_we;
  logic intr_state_hmac_err_qs;
  logic intr_state_hmac_err_wd;
  logic intr_state_hmac_err_we;
  logic intr_enable_hmac_done_qs;
  logic intr_enable_hmac_done_wd;
  logic intr_enable_hmac_done_we;
  logic intr_enable_fifo_full_qs;
  logic intr_enable_fifo_full_wd;
  logic intr_enable_fifo_full_we;
  logic intr_enable_hmac_err_qs;
  logic intr_enable_hmac_err_wd;
  logic intr_enable_hmac_err_we;
  logic intr_test_hmac_done_wd;
  logic intr_test_hmac_done_we;
  logic intr_test_fifo_full_wd;
  logic intr_test_fifo_full_we;
  logic intr_test_hmac_err_wd;
  logic intr_test_hmac_err_we;
  logic cfg_hmac_en_qs;
  logic cfg_hmac_en_wd;
  logic cfg_hmac_en_we;
  logic cfg_hmac_en_re;
  logic cfg_sha_en_qs;
  logic cfg_sha_en_wd;
  logic cfg_sha_en_we;
  logic cfg_sha_en_re;
  logic cfg_endian_swap_qs;
  logic cfg_endian_swap_wd;
  logic cfg_endian_swap_we;
  logic cfg_endian_swap_re;
  logic cfg_digest_swap_qs;
  logic cfg_digest_swap_wd;
  logic cfg_digest_swap_we;
  logic cfg_digest_swap_re;
  logic cmd_hash_start_wd;
  logic cmd_hash_start_we;
  logic cmd_hash_process_wd;
  logic cmd_hash_process_we;
  logic status_fifo_empty_qs;
  logic status_fifo_empty_re;
  logic status_fifo_full_qs;
  logic status_fifo_full_re;
  logic [4:0] status_fifo_depth_qs;
  logic status_fifo_depth_re;
  logic [31:0] err_code_qs;
  logic [31:0] wipe_secret_wd;
  logic wipe_secret_we;
  logic [31:0] key0_wd;
  logic key0_we;
  logic [31:0] key1_wd;
  logic key1_we;
  logic [31:0] key2_wd;
  logic key2_we;
  logic [31:0] key3_wd;
  logic key3_we;
  logic [31:0] key4_wd;
  logic key4_we;
  logic [31:0] key5_wd;
  logic key5_we;
  logic [31:0] key6_wd;
  logic key6_we;
  logic [31:0] key7_wd;
  logic key7_we;
  logic [31:0] digest0_qs;
  logic digest0_re;
  logic [31:0] digest1_qs;
  logic digest1_re;
  logic [31:0] digest2_qs;
  logic digest2_re;
  logic [31:0] digest3_qs;
  logic digest3_re;
  logic [31:0] digest4_qs;
  logic digest4_re;
  logic [31:0] digest5_qs;
  logic digest5_re;
  logic [31:0] digest6_qs;
  logic digest6_re;
  logic [31:0] digest7_qs;
  logic digest7_re;
  logic [31:0] msg_length_lower_qs;
  logic [31:0] msg_length_upper_qs;

  // Register instances
  // R[intr_state]: V(False)

  //   F[hmac_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_hmac_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_hmac_done_we),
    .wd     (intr_state_hmac_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.hmac_done.de),
    .d      (hw2reg.intr_state.hmac_done.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.hmac_done.q ),

    // to register interface (read)
    .qs     (intr_state_hmac_done_qs)
  );


  //   F[fifo_full]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_fifo_full (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_fifo_full_we),
    .wd     (intr_state_fifo_full_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.fifo_full.de),
    .d      (hw2reg.intr_state.fifo_full.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.fifo_full.q ),

    // to register interface (read)
    .qs     (intr_state_fifo_full_qs)
  );


  //   F[hmac_err]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_hmac_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_hmac_err_we),
    .wd     (intr_state_hmac_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.hmac_err.de),
    .d      (hw2reg.intr_state.hmac_err.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.hmac_err.q ),

    // to register interface (read)
    .qs     (intr_state_hmac_err_qs)
  );


  // R[intr_enable]: V(False)

  //   F[hmac_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_hmac_done (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_hmac_done_we),
    .wd     (intr_enable_hmac_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.hmac_done.q ),

    // to register interface (read)
    .qs     (intr_enable_hmac_done_qs)
  );


  //   F[fifo_full]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_fifo_full (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_fifo_full_we),
    .wd     (intr_enable_fifo_full_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.fifo_full.q ),

    // to register interface (read)
    .qs     (intr_enable_fifo_full_qs)
  );


  //   F[hmac_err]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable_hmac_err (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_hmac_err_we),
    .wd     (intr_enable_hmac_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.hmac_err.q ),

    // to register interface (read)
    .qs     (intr_enable_hmac_err_qs)
  );


  // R[intr_test]: V(True)

  //   F[hmac_done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_hmac_done (
    .re     (1'b0),
    .we     (intr_test_hmac_done_we),
    .wd     (intr_test_hmac_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.hmac_done.qe),
    .q      (reg2hw.intr_test.hmac_done.q ),
    .qs     ()
  );


  //   F[fifo_full]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_fifo_full (
    .re     (1'b0),
    .we     (intr_test_fifo_full_we),
    .wd     (intr_test_fifo_full_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.fifo_full.qe),
    .q      (reg2hw.intr_test.fifo_full.q ),
    .qs     ()
  );


  //   F[hmac_err]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_hmac_err (
    .re     (1'b0),
    .we     (intr_test_hmac_err_we),
    .wd     (intr_test_hmac_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.hmac_err.qe),
    .q      (reg2hw.intr_test.hmac_err.q ),
    .qs     ()
  );


  // R[cfg]: V(True)

  //   F[hmac_en]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_hmac_en (
    .re     (cfg_hmac_en_re),
    .we     (cfg_hmac_en_we),
    .wd     (cfg_hmac_en_wd),
    .d      (hw2reg.cfg.hmac_en.d),
    .qre    (),
    .qe     (reg2hw.cfg.hmac_en.qe),
    .q      (reg2hw.cfg.hmac_en.q ),
    .qs     (cfg_hmac_en_qs)
  );


  //   F[sha_en]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_sha_en (
    .re     (cfg_sha_en_re),
    .we     (cfg_sha_en_we),
    .wd     (cfg_sha_en_wd),
    .d      (hw2reg.cfg.sha_en.d),
    .qre    (),
    .qe     (reg2hw.cfg.sha_en.qe),
    .q      (reg2hw.cfg.sha_en.q ),
    .qs     (cfg_sha_en_qs)
  );


  //   F[endian_swap]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_endian_swap (
    .re     (cfg_endian_swap_re),
    .we     (cfg_endian_swap_we),
    .wd     (cfg_endian_swap_wd),
    .d      (hw2reg.cfg.endian_swap.d),
    .qre    (),
    .qe     (reg2hw.cfg.endian_swap.qe),
    .q      (reg2hw.cfg.endian_swap.q ),
    .qs     (cfg_endian_swap_qs)
  );


  //   F[digest_swap]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_digest_swap (
    .re     (cfg_digest_swap_re),
    .we     (cfg_digest_swap_we),
    .wd     (cfg_digest_swap_wd),
    .d      (hw2reg.cfg.digest_swap.d),
    .qre    (),
    .qe     (reg2hw.cfg.digest_swap.qe),
    .q      (reg2hw.cfg.digest_swap.q ),
    .qs     (cfg_digest_swap_qs)
  );


  // R[cmd]: V(True)

  //   F[hash_start]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_start (
    .re     (1'b0),
    .we     (cmd_hash_start_we),
    .wd     (cmd_hash_start_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.cmd.hash_start.qe),
    .q      (reg2hw.cmd.hash_start.q ),
    .qs     ()
  );


  //   F[hash_process]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_process (
    .re     (1'b0),
    .we     (cmd_hash_process_we),
    .wd     (cmd_hash_process_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.cmd.hash_process.qe),
    .q      (reg2hw.cmd.hash_process.q ),
    .qs     ()
  );


  // R[status]: V(True)

  //   F[fifo_empty]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fifo_empty (
    .re     (status_fifo_empty_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_empty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_fifo_empty_qs)
  );


  //   F[fifo_full]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fifo_full (
    .re     (status_fifo_full_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_full.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_fifo_full_qs)
  );


  //   F[fifo_depth]: 8:4
  prim_subreg_ext #(
    .DW    (5)
  ) u_status_fifo_depth (
    .re     (status_fifo_depth_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_depth.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (status_fifo_depth_qs)
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


  // R[wipe_secret]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wipe_secret (
    .re     (1'b0),
    .we     (wipe_secret_we),
    .wd     (wipe_secret_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.wipe_secret.qe),
    .q      (reg2hw.wipe_secret.q ),
    .qs     ()
  );



  // Subregister 0 of Multireg key
  // R[key0]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key0 (
    .re     (1'b0),
    .we     (key0_we),
    .wd     (key0_wd),
    .d      (hw2reg.key[0].d),
    .qre    (),
    .qe     (reg2hw.key[0].qe),
    .q      (reg2hw.key[0].q ),
    .qs     ()
  );

  // Subregister 1 of Multireg key
  // R[key1]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key1 (
    .re     (1'b0),
    .we     (key1_we),
    .wd     (key1_wd),
    .d      (hw2reg.key[1].d),
    .qre    (),
    .qe     (reg2hw.key[1].qe),
    .q      (reg2hw.key[1].q ),
    .qs     ()
  );

  // Subregister 2 of Multireg key
  // R[key2]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key2 (
    .re     (1'b0),
    .we     (key2_we),
    .wd     (key2_wd),
    .d      (hw2reg.key[2].d),
    .qre    (),
    .qe     (reg2hw.key[2].qe),
    .q      (reg2hw.key[2].q ),
    .qs     ()
  );

  // Subregister 3 of Multireg key
  // R[key3]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key3 (
    .re     (1'b0),
    .we     (key3_we),
    .wd     (key3_wd),
    .d      (hw2reg.key[3].d),
    .qre    (),
    .qe     (reg2hw.key[3].qe),
    .q      (reg2hw.key[3].q ),
    .qs     ()
  );

  // Subregister 4 of Multireg key
  // R[key4]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key4 (
    .re     (1'b0),
    .we     (key4_we),
    .wd     (key4_wd),
    .d      (hw2reg.key[4].d),
    .qre    (),
    .qe     (reg2hw.key[4].qe),
    .q      (reg2hw.key[4].q ),
    .qs     ()
  );

  // Subregister 5 of Multireg key
  // R[key5]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key5 (
    .re     (1'b0),
    .we     (key5_we),
    .wd     (key5_wd),
    .d      (hw2reg.key[5].d),
    .qre    (),
    .qe     (reg2hw.key[5].qe),
    .q      (reg2hw.key[5].q ),
    .qs     ()
  );

  // Subregister 6 of Multireg key
  // R[key6]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key6 (
    .re     (1'b0),
    .we     (key6_we),
    .wd     (key6_wd),
    .d      (hw2reg.key[6].d),
    .qre    (),
    .qe     (reg2hw.key[6].qe),
    .q      (reg2hw.key[6].q ),
    .qs     ()
  );

  // Subregister 7 of Multireg key
  // R[key7]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_key7 (
    .re     (1'b0),
    .we     (key7_we),
    .wd     (key7_wd),
    .d      (hw2reg.key[7].d),
    .qre    (),
    .qe     (reg2hw.key[7].qe),
    .q      (reg2hw.key[7].q ),
    .qs     ()
  );



  // Subregister 0 of Multireg digest
  // R[digest0]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest0 (
    .re     (digest0_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[0].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest0_qs)
  );

  // Subregister 1 of Multireg digest
  // R[digest1]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest1 (
    .re     (digest1_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[1].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest1_qs)
  );

  // Subregister 2 of Multireg digest
  // R[digest2]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest2 (
    .re     (digest2_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[2].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest2_qs)
  );

  // Subregister 3 of Multireg digest
  // R[digest3]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest3 (
    .re     (digest3_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[3].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest3_qs)
  );

  // Subregister 4 of Multireg digest
  // R[digest4]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest4 (
    .re     (digest4_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[4].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest4_qs)
  );

  // Subregister 5 of Multireg digest
  // R[digest5]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest5 (
    .re     (digest5_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[5].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest5_qs)
  );

  // Subregister 6 of Multireg digest
  // R[digest6]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest6 (
    .re     (digest6_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[6].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest6_qs)
  );

  // Subregister 7 of Multireg digest
  // R[digest7]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_digest7 (
    .re     (digest7_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.digest[7].d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (digest7_qs)
  );


  // R[msg_length_lower]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_msg_length_lower (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.msg_length_lower.de),
    .d      (hw2reg.msg_length_lower.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (msg_length_lower_qs)
  );


  // R[msg_length_upper]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RO"),
    .RESVAL  (32'h0)
  ) u_msg_length_upper (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    .we     (1'b0),
    .wd     ('0  ),

    // from internal hardware
    .de     (hw2reg.msg_length_upper.de),
    .d      (hw2reg.msg_length_upper.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (msg_length_upper_qs)
  );




  logic [25:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == HMAC_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == HMAC_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == HMAC_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == HMAC_CFG_OFFSET);
    addr_hit[ 4] = (reg_addr == HMAC_CMD_OFFSET);
    addr_hit[ 5] = (reg_addr == HMAC_STATUS_OFFSET);
    addr_hit[ 6] = (reg_addr == HMAC_ERR_CODE_OFFSET);
    addr_hit[ 7] = (reg_addr == HMAC_WIPE_SECRET_OFFSET);
    addr_hit[ 8] = (reg_addr == HMAC_KEY0_OFFSET);
    addr_hit[ 9] = (reg_addr == HMAC_KEY1_OFFSET);
    addr_hit[10] = (reg_addr == HMAC_KEY2_OFFSET);
    addr_hit[11] = (reg_addr == HMAC_KEY3_OFFSET);
    addr_hit[12] = (reg_addr == HMAC_KEY4_OFFSET);
    addr_hit[13] = (reg_addr == HMAC_KEY5_OFFSET);
    addr_hit[14] = (reg_addr == HMAC_KEY6_OFFSET);
    addr_hit[15] = (reg_addr == HMAC_KEY7_OFFSET);
    addr_hit[16] = (reg_addr == HMAC_DIGEST0_OFFSET);
    addr_hit[17] = (reg_addr == HMAC_DIGEST1_OFFSET);
    addr_hit[18] = (reg_addr == HMAC_DIGEST2_OFFSET);
    addr_hit[19] = (reg_addr == HMAC_DIGEST3_OFFSET);
    addr_hit[20] = (reg_addr == HMAC_DIGEST4_OFFSET);
    addr_hit[21] = (reg_addr == HMAC_DIGEST5_OFFSET);
    addr_hit[22] = (reg_addr == HMAC_DIGEST6_OFFSET);
    addr_hit[23] = (reg_addr == HMAC_DIGEST7_OFFSET);
    addr_hit[24] = (reg_addr == HMAC_MSG_LENGTH_LOWER_OFFSET);
    addr_hit[25] = (reg_addr == HMAC_MSG_LENGTH_UPPER_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[ 0] && reg_we && (HMAC_PERMIT[ 0] != (HMAC_PERMIT[ 0] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 1] && reg_we && (HMAC_PERMIT[ 1] != (HMAC_PERMIT[ 1] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 2] && reg_we && (HMAC_PERMIT[ 2] != (HMAC_PERMIT[ 2] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 3] && reg_we && (HMAC_PERMIT[ 3] != (HMAC_PERMIT[ 3] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 4] && reg_we && (HMAC_PERMIT[ 4] != (HMAC_PERMIT[ 4] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 5] && reg_we && (HMAC_PERMIT[ 5] != (HMAC_PERMIT[ 5] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 6] && reg_we && (HMAC_PERMIT[ 6] != (HMAC_PERMIT[ 6] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 7] && reg_we && (HMAC_PERMIT[ 7] != (HMAC_PERMIT[ 7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 8] && reg_we && (HMAC_PERMIT[ 8] != (HMAC_PERMIT[ 8] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[ 9] && reg_we && (HMAC_PERMIT[ 9] != (HMAC_PERMIT[ 9] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[10] && reg_we && (HMAC_PERMIT[10] != (HMAC_PERMIT[10] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[11] && reg_we && (HMAC_PERMIT[11] != (HMAC_PERMIT[11] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[12] && reg_we && (HMAC_PERMIT[12] != (HMAC_PERMIT[12] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[13] && reg_we && (HMAC_PERMIT[13] != (HMAC_PERMIT[13] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[14] && reg_we && (HMAC_PERMIT[14] != (HMAC_PERMIT[14] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[15] && reg_we && (HMAC_PERMIT[15] != (HMAC_PERMIT[15] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[16] && reg_we && (HMAC_PERMIT[16] != (HMAC_PERMIT[16] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[17] && reg_we && (HMAC_PERMIT[17] != (HMAC_PERMIT[17] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[18] && reg_we && (HMAC_PERMIT[18] != (HMAC_PERMIT[18] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[19] && reg_we && (HMAC_PERMIT[19] != (HMAC_PERMIT[19] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[20] && reg_we && (HMAC_PERMIT[20] != (HMAC_PERMIT[20] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[21] && reg_we && (HMAC_PERMIT[21] != (HMAC_PERMIT[21] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[22] && reg_we && (HMAC_PERMIT[22] != (HMAC_PERMIT[22] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[23] && reg_we && (HMAC_PERMIT[23] != (HMAC_PERMIT[23] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[24] && reg_we && (HMAC_PERMIT[24] != (HMAC_PERMIT[24] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[25] && reg_we && (HMAC_PERMIT[25] != (HMAC_PERMIT[25] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_hmac_done_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_hmac_done_wd = reg_wdata[0];

  assign intr_state_fifo_full_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_fifo_full_wd = reg_wdata[1];

  assign intr_state_hmac_err_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_hmac_err_wd = reg_wdata[2];

  assign intr_enable_hmac_done_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_hmac_done_wd = reg_wdata[0];

  assign intr_enable_fifo_full_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_fifo_full_wd = reg_wdata[1];

  assign intr_enable_hmac_err_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_hmac_err_wd = reg_wdata[2];

  assign intr_test_hmac_done_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_hmac_done_wd = reg_wdata[0];

  assign intr_test_fifo_full_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_fifo_full_wd = reg_wdata[1];

  assign intr_test_hmac_err_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_hmac_err_wd = reg_wdata[2];

  assign cfg_hmac_en_we = addr_hit[3] & reg_we & ~wr_err;
  assign cfg_hmac_en_wd = reg_wdata[0];
  assign cfg_hmac_en_re = addr_hit[3] && reg_re;

  assign cfg_sha_en_we = addr_hit[3] & reg_we & ~wr_err;
  assign cfg_sha_en_wd = reg_wdata[1];
  assign cfg_sha_en_re = addr_hit[3] && reg_re;

  assign cfg_endian_swap_we = addr_hit[3] & reg_we & ~wr_err;
  assign cfg_endian_swap_wd = reg_wdata[2];
  assign cfg_endian_swap_re = addr_hit[3] && reg_re;

  assign cfg_digest_swap_we = addr_hit[3] & reg_we & ~wr_err;
  assign cfg_digest_swap_wd = reg_wdata[3];
  assign cfg_digest_swap_re = addr_hit[3] && reg_re;

  assign cmd_hash_start_we = addr_hit[4] & reg_we & ~wr_err;
  assign cmd_hash_start_wd = reg_wdata[0];

  assign cmd_hash_process_we = addr_hit[4] & reg_we & ~wr_err;
  assign cmd_hash_process_wd = reg_wdata[1];

  assign status_fifo_empty_re = addr_hit[5] && reg_re;

  assign status_fifo_full_re = addr_hit[5] && reg_re;

  assign status_fifo_depth_re = addr_hit[5] && reg_re;


  assign wipe_secret_we = addr_hit[7] & reg_we & ~wr_err;
  assign wipe_secret_wd = reg_wdata[31:0];

  assign key0_we = addr_hit[8] & reg_we & ~wr_err;
  assign key0_wd = reg_wdata[31:0];

  assign key1_we = addr_hit[9] & reg_we & ~wr_err;
  assign key1_wd = reg_wdata[31:0];

  assign key2_we = addr_hit[10] & reg_we & ~wr_err;
  assign key2_wd = reg_wdata[31:0];

  assign key3_we = addr_hit[11] & reg_we & ~wr_err;
  assign key3_wd = reg_wdata[31:0];

  assign key4_we = addr_hit[12] & reg_we & ~wr_err;
  assign key4_wd = reg_wdata[31:0];

  assign key5_we = addr_hit[13] & reg_we & ~wr_err;
  assign key5_wd = reg_wdata[31:0];

  assign key6_we = addr_hit[14] & reg_we & ~wr_err;
  assign key6_wd = reg_wdata[31:0];

  assign key7_we = addr_hit[15] & reg_we & ~wr_err;
  assign key7_wd = reg_wdata[31:0];

  assign digest0_re = addr_hit[16] && reg_re;

  assign digest1_re = addr_hit[17] && reg_re;

  assign digest2_re = addr_hit[18] && reg_re;

  assign digest3_re = addr_hit[19] && reg_re;

  assign digest4_re = addr_hit[20] && reg_re;

  assign digest5_re = addr_hit[21] && reg_re;

  assign digest6_re = addr_hit[22] && reg_re;

  assign digest7_re = addr_hit[23] && reg_re;



  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_hmac_done_qs;
        reg_rdata_next[1] = intr_state_fifo_full_qs;
        reg_rdata_next[2] = intr_state_hmac_err_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_hmac_done_qs;
        reg_rdata_next[1] = intr_enable_fifo_full_qs;
        reg_rdata_next[2] = intr_enable_hmac_err_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = cfg_hmac_en_qs;
        reg_rdata_next[1] = cfg_sha_en_qs;
        reg_rdata_next[2] = cfg_endian_swap_qs;
        reg_rdata_next[3] = cfg_digest_swap_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = status_fifo_empty_qs;
        reg_rdata_next[1] = status_fifo_full_qs;
        reg_rdata_next[8:4] = status_fifo_depth_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = err_code_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[13]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[14]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[15]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[16]: begin
        reg_rdata_next[31:0] = digest0_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = digest1_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = digest2_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = digest3_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[31:0] = digest4_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[31:0] = digest5_qs;
      end

      addr_hit[22]: begin
        reg_rdata_next[31:0] = digest6_qs;
      end

      addr_hit[23]: begin
        reg_rdata_next[31:0] = digest7_qs;
      end

      addr_hit[24]: begin
        reg_rdata_next[31:0] = msg_length_lower_qs;
      end

      addr_hit[25]: begin
        reg_rdata_next[31:0] = msg_length_upper_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0, clk_i, !rst_ni)

endmodule
