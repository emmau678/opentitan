// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module rv_dm_rom_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o,
  input  tlul_pkg::tl_d2h_t tl_win_i,

  // To HW

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rv_dm_reg_pkg::* ;


  // Because we have no registers and only one window, this block is purely
  // combinatorial. Mark the clk and reset inputs as unused.
  logic unused_clk, unused_rst_n;
  assign unused_clk = clk_i;
  assign unused_rst_n = rst_ni;


  // Since there are no registers in this block, commands are routed through to windows which
  // can report their own integrity errors.
  assign intg_err_o = 1'b0;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  assign tl_win_o = tl_i;
  assign tl_o_pre = tl_win_i;

  // Unused signal tieoff
  // devmode_i is not used if there are no registers
  logic unused_devmode;
  assign unused_devmode = ^devmode_i;
endmodule
