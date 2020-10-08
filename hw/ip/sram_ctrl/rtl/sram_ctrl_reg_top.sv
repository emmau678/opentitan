// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module sram_ctrl_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output sram_ctrl_reg_pkg::sram_ctrl_reg2hw_t reg2hw, // Write
  input  sram_ctrl_reg_pkg::sram_ctrl_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import sram_ctrl_reg_pkg::* ;

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

  assign tl_reg_h2d = tl_i;
  assign tl_o       = tl_reg_d2h;

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
  logic intr_state_qs;
  logic intr_state_wd;
  logic intr_state_we;
  logic intr_enable_qs;
  logic intr_enable_wd;
  logic intr_enable_we;
  logic intr_test_wd;
  logic intr_test_we;
  logic status_error_qs;
  logic status_error_re;
  logic status_scr_key_valid_qs;
  logic status_scr_key_valid_re;
  logic status_scr_key_seed_valid_qs;
  logic status_scr_key_seed_valid_re;
  logic ctrl_regwen_qs;
  logic ctrl_regwen_wd;
  logic ctrl_regwen_we;
  logic ctrl_wd;
  logic ctrl_we;
  logic sram_cfg_regwen_qs;
  logic sram_cfg_regwen_wd;
  logic sram_cfg_regwen_we;
  logic [7:0] sram_cfg_qs;
  logic [7:0] sram_cfg_wd;
  logic sram_cfg_we;
  logic error_type_correctable_qs;
  logic error_type_correctable_wd;
  logic error_type_correctable_we;
  logic error_type_uncorrectable_qs;
  logic error_type_uncorrectable_wd;
  logic error_type_uncorrectable_we;
  logic [31:0] error_address_qs;

  // Register instances
  // R[intr_state]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.de),
    .d      (hw2reg.intr_state.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.q ),

    // to register interface (read)
    .qs     (intr_state_qs)
  );


  // R[intr_enable]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_intr_enable (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.q ),

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
    .q      (reg2hw.intr_test.q ),
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


  //   F[scr_key_valid]: 1:1
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


  //   F[scr_key_seed_valid]: 2:2
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


  // R[ctrl_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
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


  // R[ctrl]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_ctrl (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (ctrl_we & ctrl_regwen_qs),
    .wd     (ctrl_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.ctrl.qe),
    .q      (reg2hw.ctrl.q ),

    .qs     ()
  );


  // R[sram_cfg_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_sram_cfg_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sram_cfg_regwen_we),
    .wd     (sram_cfg_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sram_cfg_regwen_qs)
  );


  // R[sram_cfg]: V(False)

  prim_subreg #(
    .DW      (8),
    .SWACCESS("RW"),
    .RESVAL  (8'h0)
  ) u_sram_cfg (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (sram_cfg_we & sram_cfg_regwen_qs),
    .wd     (sram_cfg_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sram_cfg.q ),

    // to register interface (read)
    .qs     (sram_cfg_qs)
  );


  // R[error_type]: V(False)

  //   F[correctable]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_error_type_correctable (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (error_type_correctable_we),
    .wd     (error_type_correctable_wd),

    // from internal hardware
    .de     (hw2reg.error_type.correctable.de),
    .d      (hw2reg.error_type.correctable.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.error_type.correctable.q ),

    // to register interface (read)
    .qs     (error_type_correctable_qs)
  );


  //   F[uncorrectable]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_error_type_uncorrectable (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (error_type_uncorrectable_we),
    .wd     (error_type_uncorrectable_wd),

    // from internal hardware
    .de     (hw2reg.error_type.uncorrectable.de),
    .d      (hw2reg.error_type.uncorrectable.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.error_type.uncorrectable.q ),

    // to register interface (read)
    .qs     (error_type_uncorrectable_qs)
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




  logic [9:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == SRAM_CTRL_INTR_STATE_OFFSET);
    addr_hit[1] = (reg_addr == SRAM_CTRL_INTR_ENABLE_OFFSET);
    addr_hit[2] = (reg_addr == SRAM_CTRL_INTR_TEST_OFFSET);
    addr_hit[3] = (reg_addr == SRAM_CTRL_STATUS_OFFSET);
    addr_hit[4] = (reg_addr == SRAM_CTRL_CTRL_REGWEN_OFFSET);
    addr_hit[5] = (reg_addr == SRAM_CTRL_CTRL_OFFSET);
    addr_hit[6] = (reg_addr == SRAM_CTRL_SRAM_CFG_REGWEN_OFFSET);
    addr_hit[7] = (reg_addr == SRAM_CTRL_SRAM_CFG_OFFSET);
    addr_hit[8] = (reg_addr == SRAM_CTRL_ERROR_TYPE_OFFSET);
    addr_hit[9] = (reg_addr == SRAM_CTRL_ERROR_ADDRESS_OFFSET);
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
    if (addr_hit[7] && reg_we && (SRAM_CTRL_PERMIT[7] != (SRAM_CTRL_PERMIT[7] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[8] && reg_we && (SRAM_CTRL_PERMIT[8] != (SRAM_CTRL_PERMIT[8] & reg_be))) wr_err = 1'b1 ;
    if (addr_hit[9] && reg_we && (SRAM_CTRL_PERMIT[9] != (SRAM_CTRL_PERMIT[9] & reg_be))) wr_err = 1'b1 ;
  end

  assign intr_state_we = addr_hit[0] & reg_we & ~wr_err;
  assign intr_state_wd = reg_wdata[0];

  assign intr_enable_we = addr_hit[1] & reg_we & ~wr_err;
  assign intr_enable_wd = reg_wdata[0];

  assign intr_test_we = addr_hit[2] & reg_we & ~wr_err;
  assign intr_test_wd = reg_wdata[0];

  assign status_error_re = addr_hit[3] && reg_re;

  assign status_scr_key_valid_re = addr_hit[3] && reg_re;

  assign status_scr_key_seed_valid_re = addr_hit[3] && reg_re;

  assign ctrl_regwen_we = addr_hit[4] & reg_we & ~wr_err;
  assign ctrl_regwen_wd = reg_wdata[0];

  assign ctrl_we = addr_hit[5] & reg_we & ~wr_err;
  assign ctrl_wd = reg_wdata[0];

  assign sram_cfg_regwen_we = addr_hit[6] & reg_we & ~wr_err;
  assign sram_cfg_regwen_wd = reg_wdata[0];

  assign sram_cfg_we = addr_hit[7] & reg_we & ~wr_err;
  assign sram_cfg_wd = reg_wdata[7:0];

  assign error_type_correctable_we = addr_hit[8] & reg_we & ~wr_err;
  assign error_type_correctable_wd = reg_wdata[0];

  assign error_type_uncorrectable_we = addr_hit[8] & reg_we & ~wr_err;
  assign error_type_uncorrectable_wd = reg_wdata[1];


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
        reg_rdata_next[0] = status_error_qs;
        reg_rdata_next[1] = status_scr_key_valid_qs;
        reg_rdata_next[2] = status_scr_key_seed_valid_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ctrl_regwen_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = sram_cfg_regwen_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[7:0] = sram_cfg_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = error_type_correctable_qs;
        reg_rdata_next[1] = error_type_uncorrectable_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = error_address_qs;
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
