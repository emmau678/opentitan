// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module rv_core_ibex_peri_reg_top (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output rv_core_ibex_peri_reg_pkg::rv_core_ibex_peri_reg2hw_t reg2hw, // Write
  input  rv_core_ibex_peri_reg_pkg::rv_core_ibex_peri_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rv_core_ibex_peri_reg_pkg::* ;

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
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
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
  logic alert_test_we;
  logic alert_test_fatal_sw_err_wd;
  logic alert_test_recov_sw_err_wd;
  logic alert_test_fatal_hw_err_wd;
  logic alert_test_recov_hw_err_wd;
  logic sw_alert_regwen_0_we;
  logic sw_alert_regwen_0_qs;
  logic sw_alert_regwen_0_wd;
  logic sw_alert_regwen_1_we;
  logic sw_alert_regwen_1_qs;
  logic sw_alert_regwen_1_wd;
  logic sw_alert_0_we;
  logic [1:0] sw_alert_0_qs;
  logic [1:0] sw_alert_0_wd;
  logic sw_alert_1_we;
  logic [1:0] sw_alert_1_qs;
  logic [1:0] sw_alert_1_wd;
  logic ibus_regwen_0_we;
  logic ibus_regwen_0_qs;
  logic ibus_regwen_0_wd;
  logic ibus_regwen_1_we;
  logic ibus_regwen_1_qs;
  logic ibus_regwen_1_wd;
  logic ibus_addr_en_0_we;
  logic ibus_addr_en_0_qs;
  logic ibus_addr_en_0_wd;
  logic ibus_addr_en_1_we;
  logic ibus_addr_en_1_qs;
  logic ibus_addr_en_1_wd;
  logic ibus_addr_matching_0_we;
  logic [31:0] ibus_addr_matching_0_qs;
  logic [31:0] ibus_addr_matching_0_wd;
  logic ibus_addr_matching_1_we;
  logic [31:0] ibus_addr_matching_1_qs;
  logic [31:0] ibus_addr_matching_1_wd;
  logic ibus_remap_addr_0_we;
  logic [31:0] ibus_remap_addr_0_qs;
  logic [31:0] ibus_remap_addr_0_wd;
  logic ibus_remap_addr_1_we;
  logic [31:0] ibus_remap_addr_1_qs;
  logic [31:0] ibus_remap_addr_1_wd;
  logic dbus_regwen_0_we;
  logic dbus_regwen_0_qs;
  logic dbus_regwen_0_wd;
  logic dbus_regwen_1_we;
  logic dbus_regwen_1_qs;
  logic dbus_regwen_1_wd;
  logic dbus_addr_en_0_we;
  logic dbus_addr_en_0_qs;
  logic dbus_addr_en_0_wd;
  logic dbus_addr_en_1_we;
  logic dbus_addr_en_1_qs;
  logic dbus_addr_en_1_wd;
  logic dbus_addr_matching_0_we;
  logic [31:0] dbus_addr_matching_0_qs;
  logic [31:0] dbus_addr_matching_0_wd;
  logic dbus_addr_matching_1_we;
  logic [31:0] dbus_addr_matching_1_qs;
  logic [31:0] dbus_addr_matching_1_wd;
  logic dbus_remap_addr_0_we;
  logic [31:0] dbus_remap_addr_0_qs;
  logic [31:0] dbus_remap_addr_0_wd;
  logic dbus_remap_addr_1_we;
  logic [31:0] dbus_remap_addr_1_qs;
  logic [31:0] dbus_remap_addr_1_wd;
  logic err_status_we;
  logic err_status_reg_intg_err_qs;
  logic err_status_reg_intg_err_wd;
  logic err_status_fatal_intg_err_qs;
  logic err_status_fatal_intg_err_wd;
  logic err_status_fatal_core_err_qs;
  logic err_status_fatal_core_err_wd;
  logic err_status_recov_core_err_qs;
  logic err_status_recov_core_err_wd;

  // Register instances
  // R[alert_test]: V(True)

  //   F[fatal_sw_err]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_sw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_sw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.fatal_sw_err.qe),
    .q      (reg2hw.alert_test.fatal_sw_err.q),
    .qs     ()
  );


  //   F[recov_sw_err]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_sw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_sw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_sw_err.qe),
    .q      (reg2hw.alert_test.recov_sw_err.q),
    .qs     ()
  );


  //   F[fatal_hw_err]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_hw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_hw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.fatal_hw_err.qe),
    .q      (reg2hw.alert_test.fatal_hw_err.q),
    .qs     ()
  );


  //   F[recov_hw_err]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_hw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_hw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.alert_test.recov_hw_err.qe),
    .q      (reg2hw.alert_test.recov_hw_err.q),
    .qs     ()
  );



  // Subregister 0 of Multireg sw_alert_regwen
  // R[sw_alert_regwen_0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_alert_regwen_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_alert_regwen_0_we),
    .wd     (sw_alert_regwen_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sw_alert_regwen_0_qs)
  );

  // Subregister 1 of Multireg sw_alert_regwen
  // R[sw_alert_regwen_1]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_alert_regwen_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_alert_regwen_1_we),
    .wd     (sw_alert_regwen_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (sw_alert_regwen_1_qs)
  );



  // Subregister 0 of Multireg sw_alert
  // R[sw_alert_0]: V(False)

  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h1)
  ) u_sw_alert_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_alert_0_we & sw_alert_regwen_0_qs),
    .wd     (sw_alert_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_alert[0].q),

    // to register interface (read)
    .qs     (sw_alert_0_qs)
  );

  // Subregister 1 of Multireg sw_alert
  // R[sw_alert_1]: V(False)

  prim_subreg #(
    .DW      (2),
    .SWACCESS("RW"),
    .RESVAL  (2'h1)
  ) u_sw_alert_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_alert_1_we & sw_alert_regwen_1_qs),
    .wd     (sw_alert_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_alert[1].q),

    // to register interface (read)
    .qs     (sw_alert_1_qs)
  );



  // Subregister 0 of Multireg ibus_regwen
  // R[ibus_regwen_0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_ibus_regwen_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_regwen_0_we),
    .wd     (ibus_regwen_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (ibus_regwen_0_qs)
  );

  // Subregister 1 of Multireg ibus_regwen
  // R[ibus_regwen_1]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_ibus_regwen_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_regwen_1_we),
    .wd     (ibus_regwen_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (ibus_regwen_1_qs)
  );



  // Subregister 0 of Multireg ibus_addr_en
  // R[ibus_addr_en_0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ibus_addr_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_en_0_we & ibus_regwen_0_qs),
    .wd     (ibus_addr_en_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_addr_en[0].q),

    // to register interface (read)
    .qs     (ibus_addr_en_0_qs)
  );

  // Subregister 1 of Multireg ibus_addr_en
  // R[ibus_addr_en_1]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_ibus_addr_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_en_1_we & ibus_regwen_1_qs),
    .wd     (ibus_addr_en_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_addr_en[1].q),

    // to register interface (read)
    .qs     (ibus_addr_en_1_qs)
  );



  // Subregister 0 of Multireg ibus_addr_matching
  // R[ibus_addr_matching_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_ibus_addr_matching_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_matching_0_we & ibus_regwen_0_qs),
    .wd     (ibus_addr_matching_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_addr_matching[0].q),

    // to register interface (read)
    .qs     (ibus_addr_matching_0_qs)
  );

  // Subregister 1 of Multireg ibus_addr_matching
  // R[ibus_addr_matching_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_ibus_addr_matching_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_matching_1_we & ibus_regwen_1_qs),
    .wd     (ibus_addr_matching_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_addr_matching[1].q),

    // to register interface (read)
    .qs     (ibus_addr_matching_1_qs)
  );



  // Subregister 0 of Multireg ibus_remap_addr
  // R[ibus_remap_addr_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_ibus_remap_addr_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_remap_addr_0_we & ibus_regwen_0_qs),
    .wd     (ibus_remap_addr_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_remap_addr[0].q),

    // to register interface (read)
    .qs     (ibus_remap_addr_0_qs)
  );

  // Subregister 1 of Multireg ibus_remap_addr
  // R[ibus_remap_addr_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_ibus_remap_addr_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_remap_addr_1_we & ibus_regwen_1_qs),
    .wd     (ibus_remap_addr_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ibus_remap_addr[1].q),

    // to register interface (read)
    .qs     (ibus_remap_addr_1_qs)
  );



  // Subregister 0 of Multireg dbus_regwen
  // R[dbus_regwen_0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_dbus_regwen_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_regwen_0_we),
    .wd     (dbus_regwen_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (dbus_regwen_0_qs)
  );

  // Subregister 1 of Multireg dbus_regwen
  // R[dbus_regwen_1]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_dbus_regwen_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_regwen_1_we),
    .wd     (dbus_regwen_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (dbus_regwen_1_qs)
  );



  // Subregister 0 of Multireg dbus_addr_en
  // R[dbus_addr_en_0]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_dbus_addr_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_en_0_we & dbus_regwen_0_qs),
    .wd     (dbus_addr_en_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_addr_en[0].q),

    // to register interface (read)
    .qs     (dbus_addr_en_0_qs)
  );

  // Subregister 1 of Multireg dbus_addr_en
  // R[dbus_addr_en_1]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_dbus_addr_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_en_1_we & dbus_regwen_1_qs),
    .wd     (dbus_addr_en_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_addr_en[1].q),

    // to register interface (read)
    .qs     (dbus_addr_en_1_qs)
  );



  // Subregister 0 of Multireg dbus_addr_matching
  // R[dbus_addr_matching_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_dbus_addr_matching_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_matching_0_we & dbus_regwen_0_qs),
    .wd     (dbus_addr_matching_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_addr_matching[0].q),

    // to register interface (read)
    .qs     (dbus_addr_matching_0_qs)
  );

  // Subregister 1 of Multireg dbus_addr_matching
  // R[dbus_addr_matching_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_dbus_addr_matching_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_matching_1_we & dbus_regwen_1_qs),
    .wd     (dbus_addr_matching_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_addr_matching[1].q),

    // to register interface (read)
    .qs     (dbus_addr_matching_1_qs)
  );



  // Subregister 0 of Multireg dbus_remap_addr
  // R[dbus_remap_addr_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_dbus_remap_addr_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_remap_addr_0_we & dbus_regwen_0_qs),
    .wd     (dbus_remap_addr_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_remap_addr[0].q),

    // to register interface (read)
    .qs     (dbus_remap_addr_0_qs)
  );

  // Subregister 1 of Multireg dbus_remap_addr
  // R[dbus_remap_addr_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_dbus_remap_addr_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_remap_addr_1_we & dbus_regwen_1_qs),
    .wd     (dbus_remap_addr_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.dbus_remap_addr[1].q),

    // to register interface (read)
    .qs     (dbus_remap_addr_1_qs)
  );


  // R[err_status]: V(False)

  //   F[reg_intg_err]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_err_status_reg_intg_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (err_status_we),
    .wd     (err_status_reg_intg_err_wd),

    // from internal hardware
    .de     (hw2reg.err_status.reg_intg_err.de),
    .d      (hw2reg.err_status.reg_intg_err.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_status_reg_intg_err_qs)
  );


  //   F[fatal_intg_err]: 8:8
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_err_status_fatal_intg_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (err_status_we),
    .wd     (err_status_fatal_intg_err_wd),

    // from internal hardware
    .de     (hw2reg.err_status.fatal_intg_err.de),
    .d      (hw2reg.err_status.fatal_intg_err.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_status_fatal_intg_err_qs)
  );


  //   F[fatal_core_err]: 9:9
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_err_status_fatal_core_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (err_status_we),
    .wd     (err_status_fatal_core_err_wd),

    // from internal hardware
    .de     (hw2reg.err_status.fatal_core_err.de),
    .d      (hw2reg.err_status.fatal_core_err.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_status_fatal_core_err_qs)
  );


  //   F[recov_core_err]: 10:10
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_err_status_recov_core_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (err_status_we),
    .wd     (err_status_recov_core_err_wd),

    // from internal hardware
    .de     (hw2reg.err_status.recov_core_err.de),
    .d      (hw2reg.err_status.recov_core_err.d),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (err_status_recov_core_err_qs)
  );




  logic [21:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == RV_CORE_IBEX_PERI_ALERT_TEST_OFFSET);
    addr_hit[ 1] = (reg_addr == RV_CORE_IBEX_PERI_SW_ALERT_REGWEN_0_OFFSET);
    addr_hit[ 2] = (reg_addr == RV_CORE_IBEX_PERI_SW_ALERT_REGWEN_1_OFFSET);
    addr_hit[ 3] = (reg_addr == RV_CORE_IBEX_PERI_SW_ALERT_0_OFFSET);
    addr_hit[ 4] = (reg_addr == RV_CORE_IBEX_PERI_SW_ALERT_1_OFFSET);
    addr_hit[ 5] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_REGWEN_0_OFFSET);
    addr_hit[ 6] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_REGWEN_1_OFFSET);
    addr_hit[ 7] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_ADDR_EN_0_OFFSET);
    addr_hit[ 8] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_ADDR_EN_1_OFFSET);
    addr_hit[ 9] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_ADDR_MATCHING_0_OFFSET);
    addr_hit[10] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_ADDR_MATCHING_1_OFFSET);
    addr_hit[11] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_REMAP_ADDR_0_OFFSET);
    addr_hit[12] = (reg_addr == RV_CORE_IBEX_PERI_IBUS_REMAP_ADDR_1_OFFSET);
    addr_hit[13] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_REGWEN_0_OFFSET);
    addr_hit[14] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_REGWEN_1_OFFSET);
    addr_hit[15] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_ADDR_EN_0_OFFSET);
    addr_hit[16] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_ADDR_EN_1_OFFSET);
    addr_hit[17] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_ADDR_MATCHING_0_OFFSET);
    addr_hit[18] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_ADDR_MATCHING_1_OFFSET);
    addr_hit[19] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_REMAP_ADDR_0_OFFSET);
    addr_hit[20] = (reg_addr == RV_CORE_IBEX_PERI_DBUS_REMAP_ADDR_1_OFFSET);
    addr_hit[21] = (reg_addr == RV_CORE_IBEX_PERI_ERR_STATUS_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(RV_CORE_IBEX_PERI_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(RV_CORE_IBEX_PERI_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(RV_CORE_IBEX_PERI_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(RV_CORE_IBEX_PERI_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(RV_CORE_IBEX_PERI_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(RV_CORE_IBEX_PERI_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(RV_CORE_IBEX_PERI_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(RV_CORE_IBEX_PERI_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(RV_CORE_IBEX_PERI_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(RV_CORE_IBEX_PERI_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(RV_CORE_IBEX_PERI_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(RV_CORE_IBEX_PERI_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(RV_CORE_IBEX_PERI_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(RV_CORE_IBEX_PERI_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(RV_CORE_IBEX_PERI_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(RV_CORE_IBEX_PERI_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(RV_CORE_IBEX_PERI_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(RV_CORE_IBEX_PERI_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(RV_CORE_IBEX_PERI_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(RV_CORE_IBEX_PERI_PERMIT[19] & ~reg_be))) |
               (addr_hit[20] & (|(RV_CORE_IBEX_PERI_PERMIT[20] & ~reg_be))) |
               (addr_hit[21] & (|(RV_CORE_IBEX_PERI_PERMIT[21] & ~reg_be)))));
  end
  assign alert_test_we = addr_hit[0] & reg_we & !reg_error;

  assign alert_test_fatal_sw_err_wd = reg_wdata[0];

  assign alert_test_recov_sw_err_wd = reg_wdata[1];

  assign alert_test_fatal_hw_err_wd = reg_wdata[2];

  assign alert_test_recov_hw_err_wd = reg_wdata[3];
  assign sw_alert_regwen_0_we = addr_hit[1] & reg_we & !reg_error;

  assign sw_alert_regwen_0_wd = reg_wdata[0];
  assign sw_alert_regwen_1_we = addr_hit[2] & reg_we & !reg_error;

  assign sw_alert_regwen_1_wd = reg_wdata[0];
  assign sw_alert_0_we = addr_hit[3] & reg_we & !reg_error;

  assign sw_alert_0_wd = reg_wdata[1:0];
  assign sw_alert_1_we = addr_hit[4] & reg_we & !reg_error;

  assign sw_alert_1_wd = reg_wdata[1:0];
  assign ibus_regwen_0_we = addr_hit[5] & reg_we & !reg_error;

  assign ibus_regwen_0_wd = reg_wdata[0];
  assign ibus_regwen_1_we = addr_hit[6] & reg_we & !reg_error;

  assign ibus_regwen_1_wd = reg_wdata[0];
  assign ibus_addr_en_0_we = addr_hit[7] & reg_we & !reg_error;

  assign ibus_addr_en_0_wd = reg_wdata[0];
  assign ibus_addr_en_1_we = addr_hit[8] & reg_we & !reg_error;

  assign ibus_addr_en_1_wd = reg_wdata[0];
  assign ibus_addr_matching_0_we = addr_hit[9] & reg_we & !reg_error;

  assign ibus_addr_matching_0_wd = reg_wdata[31:0];
  assign ibus_addr_matching_1_we = addr_hit[10] & reg_we & !reg_error;

  assign ibus_addr_matching_1_wd = reg_wdata[31:0];
  assign ibus_remap_addr_0_we = addr_hit[11] & reg_we & !reg_error;

  assign ibus_remap_addr_0_wd = reg_wdata[31:0];
  assign ibus_remap_addr_1_we = addr_hit[12] & reg_we & !reg_error;

  assign ibus_remap_addr_1_wd = reg_wdata[31:0];
  assign dbus_regwen_0_we = addr_hit[13] & reg_we & !reg_error;

  assign dbus_regwen_0_wd = reg_wdata[0];
  assign dbus_regwen_1_we = addr_hit[14] & reg_we & !reg_error;

  assign dbus_regwen_1_wd = reg_wdata[0];
  assign dbus_addr_en_0_we = addr_hit[15] & reg_we & !reg_error;

  assign dbus_addr_en_0_wd = reg_wdata[0];
  assign dbus_addr_en_1_we = addr_hit[16] & reg_we & !reg_error;

  assign dbus_addr_en_1_wd = reg_wdata[0];
  assign dbus_addr_matching_0_we = addr_hit[17] & reg_we & !reg_error;

  assign dbus_addr_matching_0_wd = reg_wdata[31:0];
  assign dbus_addr_matching_1_we = addr_hit[18] & reg_we & !reg_error;

  assign dbus_addr_matching_1_wd = reg_wdata[31:0];
  assign dbus_remap_addr_0_we = addr_hit[19] & reg_we & !reg_error;

  assign dbus_remap_addr_0_wd = reg_wdata[31:0];
  assign dbus_remap_addr_1_we = addr_hit[20] & reg_we & !reg_error;

  assign dbus_remap_addr_1_wd = reg_wdata[31:0];
  assign err_status_we = addr_hit[21] & reg_we & !reg_error;

  assign err_status_reg_intg_err_wd = reg_wdata[0];

  assign err_status_fatal_intg_err_wd = reg_wdata[8];

  assign err_status_fatal_core_err_wd = reg_wdata[9];

  assign err_status_recov_core_err_wd = reg_wdata[10];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = sw_alert_regwen_0_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = sw_alert_regwen_1_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[1:0] = sw_alert_0_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[1:0] = sw_alert_1_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = ibus_regwen_0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = ibus_regwen_1_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[0] = ibus_addr_en_0_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = ibus_addr_en_1_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = ibus_addr_matching_0_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = ibus_addr_matching_1_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = ibus_remap_addr_0_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = ibus_remap_addr_1_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = dbus_regwen_0_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[0] = dbus_regwen_1_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[0] = dbus_addr_en_0_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[0] = dbus_addr_en_1_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = dbus_addr_matching_0_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = dbus_addr_matching_1_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = dbus_remap_addr_0_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[31:0] = dbus_remap_addr_1_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[0] = err_status_reg_intg_err_qs;
        reg_rdata_next[8] = err_status_fatal_intg_err_qs;
        reg_rdata_next[9] = err_status_fatal_core_err_qs;
        reg_rdata_next[10] = err_status_recov_core_err_qs;
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
