// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module rv_core_ibex_cfg_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o,
  input  tlul_pkg::tl_d2h_t tl_win_i,

  // To HW
  output rv_core_ibex_reg_pkg::rv_core_ibex_cfg_reg2hw_t reg2hw, // Write
  input  rv_core_ibex_reg_pkg::rv_core_ibex_cfg_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rv_core_ibex_reg_pkg::* ;

  localparam int AW = 8;
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

  // also check for spurious write enables
  logic reg_we_err;
  logic [24:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(25)
  ) u_prim_reg_we_check (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .oh_i  (reg_we_check),
    .en_i  (reg_we && !addrmiss),
    .err_o (reg_we_err)
  );

  logic err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= '0;
    end else if (intg_err || reg_we_err) begin
      err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = err_q | intg_err | reg_we_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  tlul_pkg::tl_h2d_t tl_socket_h2d [2];
  tlul_pkg::tl_d2h_t tl_socket_d2h [2];

  logic [0:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[1];
  assign tl_socket_d2h[1] = tl_reg_d2h;

  assign tl_win_o = tl_socket_h2d[0];
  assign tl_socket_d2h[0] = tl_win_i;

  // Create Socket_1n
  tlul_socket_1n #(
    .N            (2),
    .HReqPass     (1'b1),
    .HRspPass     (1'b1),
    .DReqPass     ({2{1'b1}}),
    .DRspPass     ({2{1'b1}}),
    .HReqDepth    (4'h0),
    .HRspDepth    (4'h0),
    .DReqDepth    ({2{4'h0}}),
    .DRspDepth    ({2{4'h0}}),
    .ExplicitErrs (1'b0)
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
    unique case (tl_i.a_address[AW-1:0]) inside
      [128:159]: begin
        reg_steer = 0;
      end
      default: begin
        // Default set to register
        reg_steer = 1;
      end
    endcase

    // Override this in case of an integrity error
    if (intg_err) begin
      reg_steer = 1;
    end
  end

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
  logic alert_test_we;
  logic alert_test_fatal_sw_err_wd;
  logic alert_test_recov_sw_err_wd;
  logic alert_test_fatal_hw_err_wd;
  logic alert_test_recov_hw_err_wd;
  logic sw_recov_err_we;
  logic [3:0] sw_recov_err_qs;
  logic [3:0] sw_recov_err_wd;
  logic sw_fatal_err_we;
  logic [3:0] sw_fatal_err_qs;
  logic [3:0] sw_fatal_err_wd;
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
  logic nmi_enable_we;
  logic nmi_enable_alert_en_qs;
  logic nmi_enable_alert_en_wd;
  logic nmi_enable_wdog_en_qs;
  logic nmi_enable_wdog_en_wd;
  logic nmi_state_we;
  logic nmi_state_alert_qs;
  logic nmi_state_alert_wd;
  logic nmi_state_wdog_qs;
  logic nmi_state_wdog_wd;
  logic err_status_we;
  logic err_status_reg_intg_err_qs;
  logic err_status_reg_intg_err_wd;
  logic err_status_fatal_intg_err_qs;
  logic err_status_fatal_intg_err_wd;
  logic err_status_fatal_core_err_qs;
  logic err_status_fatal_core_err_wd;
  logic err_status_recov_core_err_qs;
  logic err_status_recov_core_err_wd;
  logic rnd_data_re;
  logic [31:0] rnd_data_qs;
  logic rnd_status_re;
  logic rnd_status_rnd_data_valid_qs;
  logic rnd_status_rnd_data_fips_qs;
  logic fpga_info_re;
  logic [31:0] fpga_info_qs;

  // Register instances
  // R[alert_test]: V(True)
  logic alert_test_qe;
  logic [3:0] alert_test_flds_we;
  assign alert_test_qe = &alert_test_flds_we;
  //   F[fatal_sw_err]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_sw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_sw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[0]),
    .q      (reg2hw.alert_test.fatal_sw_err.q),
    .qs     ()
  );
  assign reg2hw.alert_test.fatal_sw_err.qe = alert_test_qe;

  //   F[recov_sw_err]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_sw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_sw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[1]),
    .q      (reg2hw.alert_test.recov_sw_err.q),
    .qs     ()
  );
  assign reg2hw.alert_test.recov_sw_err.qe = alert_test_qe;

  //   F[fatal_hw_err]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_fatal_hw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_fatal_hw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[2]),
    .q      (reg2hw.alert_test.fatal_hw_err.q),
    .qs     ()
  );
  assign reg2hw.alert_test.fatal_hw_err.qe = alert_test_qe;

  //   F[recov_hw_err]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test_recov_hw_err (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_recov_hw_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[3]),
    .q      (reg2hw.alert_test.recov_hw_err.q),
    .qs     ()
  );
  assign reg2hw.alert_test.recov_hw_err.qe = alert_test_qe;


  // R[sw_recov_err]: V(False)
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h5)
  ) u_sw_recov_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_recov_err_we),
    .wd     (sw_recov_err_wd),

    // from internal hardware
    .de     (hw2reg.sw_recov_err.de),
    .d      (hw2reg.sw_recov_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_recov_err.q),

    // to register interface (read)
    .qs     (sw_recov_err_qs)
  );


  // R[sw_fatal_err]: V(False)
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
    .RESVAL  (4'h5)
  ) u_sw_fatal_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (sw_fatal_err_we),
    .wd     (sw_fatal_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_fatal_err.q),

    // to register interface (read)
    .qs     (sw_fatal_err_qs)
  );


  // Subregister 0 of Multireg ibus_regwen
  // R[ibus_regwen_0]: V(False)
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
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
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
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
  // Create REGWEN-gated WE signal
  logic ibus_addr_en_0_gated_we;
  assign ibus_addr_en_0_gated_we = ibus_addr_en_0_we & ibus_regwen_0_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ibus_addr_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_en_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic ibus_addr_en_1_gated_we;
  assign ibus_addr_en_1_gated_we = ibus_addr_en_1_we & ibus_regwen_1_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_ibus_addr_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_en_1_gated_we),
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
  // Create REGWEN-gated WE signal
  logic ibus_addr_matching_0_gated_we;
  assign ibus_addr_matching_0_gated_we = ibus_addr_matching_0_we & ibus_regwen_0_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_ibus_addr_matching_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_matching_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic ibus_addr_matching_1_gated_we;
  assign ibus_addr_matching_1_gated_we = ibus_addr_matching_1_we & ibus_regwen_1_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_ibus_addr_matching_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_addr_matching_1_gated_we),
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
  // Create REGWEN-gated WE signal
  logic ibus_remap_addr_0_gated_we;
  assign ibus_remap_addr_0_gated_we = ibus_remap_addr_0_we & ibus_regwen_0_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_ibus_remap_addr_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_remap_addr_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic ibus_remap_addr_1_gated_we;
  assign ibus_remap_addr_1_gated_we = ibus_remap_addr_1_we & ibus_regwen_1_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_ibus_remap_addr_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ibus_remap_addr_1_gated_we),
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
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
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
    .SwAccess(prim_subreg_pkg::SwAccessW0C),
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
  // Create REGWEN-gated WE signal
  logic dbus_addr_en_0_gated_we;
  assign dbus_addr_en_0_gated_we = dbus_addr_en_0_we & dbus_regwen_0_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_dbus_addr_en_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_en_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic dbus_addr_en_1_gated_we;
  assign dbus_addr_en_1_gated_we = dbus_addr_en_1_we & dbus_regwen_1_qs;
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0)
  ) u_dbus_addr_en_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_en_1_gated_we),
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
  // Create REGWEN-gated WE signal
  logic dbus_addr_matching_0_gated_we;
  assign dbus_addr_matching_0_gated_we = dbus_addr_matching_0_we & dbus_regwen_0_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_dbus_addr_matching_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_matching_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic dbus_addr_matching_1_gated_we;
  assign dbus_addr_matching_1_gated_we = dbus_addr_matching_1_we & dbus_regwen_1_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_dbus_addr_matching_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_addr_matching_1_gated_we),
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
  // Create REGWEN-gated WE signal
  logic dbus_remap_addr_0_gated_we;
  assign dbus_remap_addr_0_gated_we = dbus_remap_addr_0_we & dbus_regwen_0_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_dbus_remap_addr_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_remap_addr_0_gated_we),
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
  // Create REGWEN-gated WE signal
  logic dbus_remap_addr_1_gated_we;
  assign dbus_remap_addr_1_gated_we = dbus_remap_addr_1_we & dbus_regwen_1_qs;
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (32'h0)
  ) u_dbus_remap_addr_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (dbus_remap_addr_1_gated_we),
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


  // R[nmi_enable]: V(False)
  //   F[alert_en]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1S),
    .RESVAL  (1'h0)
  ) u_nmi_enable_alert_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (nmi_enable_we),
    .wd     (nmi_enable_alert_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.nmi_enable.alert_en.q),

    // to register interface (read)
    .qs     (nmi_enable_alert_en_qs)
  );

  //   F[wdog_en]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1S),
    .RESVAL  (1'h0)
  ) u_nmi_enable_wdog_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (nmi_enable_we),
    .wd     (nmi_enable_wdog_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.nmi_enable.wdog_en.q),

    // to register interface (read)
    .qs     (nmi_enable_wdog_en_qs)
  );


  // R[nmi_state]: V(False)
  //   F[alert]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_nmi_state_alert (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (nmi_state_we),
    .wd     (nmi_state_alert_wd),

    // from internal hardware
    .de     (hw2reg.nmi_state.alert.de),
    .d      (hw2reg.nmi_state.alert.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.nmi_state.alert.q),

    // to register interface (read)
    .qs     (nmi_state_alert_qs)
  );

  //   F[wdog]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0)
  ) u_nmi_state_wdog (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (nmi_state_we),
    .wd     (nmi_state_wdog_wd),

    // from internal hardware
    .de     (hw2reg.nmi_state.wdog.de),
    .d      (hw2reg.nmi_state.wdog.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.nmi_state.wdog.q),

    // to register interface (read)
    .qs     (nmi_state_wdog_qs)
  );


  // R[err_status]: V(False)
  //   F[reg_intg_err]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
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
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
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
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
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
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
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


  // R[rnd_data]: V(True)
  prim_subreg_ext #(
    .DW    (32)
  ) u_rnd_data (
    .re     (rnd_data_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rnd_data.d),
    .qre    (reg2hw.rnd_data.re),
    .qe     (),
    .q      (reg2hw.rnd_data.q),
    .qs     (rnd_data_qs)
  );


  // R[rnd_status]: V(True)
  //   F[rnd_data_valid]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_rnd_status_rnd_data_valid (
    .re     (rnd_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rnd_status.rnd_data_valid.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (rnd_status_rnd_data_valid_qs)
  );

  //   F[rnd_data_fips]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_rnd_status_rnd_data_fips (
    .re     (rnd_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rnd_status.rnd_data_fips.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (rnd_status_rnd_data_fips_qs)
  );


  // R[fpga_info]: V(True)
  prim_subreg_ext #(
    .DW    (32)
  ) u_fpga_info (
    .re     (fpga_info_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.fpga_info.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (fpga_info_qs)
  );



  logic [24:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == RV_CORE_IBEX_ALERT_TEST_OFFSET);
    addr_hit[ 1] = (reg_addr == RV_CORE_IBEX_SW_RECOV_ERR_OFFSET);
    addr_hit[ 2] = (reg_addr == RV_CORE_IBEX_SW_FATAL_ERR_OFFSET);
    addr_hit[ 3] = (reg_addr == RV_CORE_IBEX_IBUS_REGWEN_0_OFFSET);
    addr_hit[ 4] = (reg_addr == RV_CORE_IBEX_IBUS_REGWEN_1_OFFSET);
    addr_hit[ 5] = (reg_addr == RV_CORE_IBEX_IBUS_ADDR_EN_0_OFFSET);
    addr_hit[ 6] = (reg_addr == RV_CORE_IBEX_IBUS_ADDR_EN_1_OFFSET);
    addr_hit[ 7] = (reg_addr == RV_CORE_IBEX_IBUS_ADDR_MATCHING_0_OFFSET);
    addr_hit[ 8] = (reg_addr == RV_CORE_IBEX_IBUS_ADDR_MATCHING_1_OFFSET);
    addr_hit[ 9] = (reg_addr == RV_CORE_IBEX_IBUS_REMAP_ADDR_0_OFFSET);
    addr_hit[10] = (reg_addr == RV_CORE_IBEX_IBUS_REMAP_ADDR_1_OFFSET);
    addr_hit[11] = (reg_addr == RV_CORE_IBEX_DBUS_REGWEN_0_OFFSET);
    addr_hit[12] = (reg_addr == RV_CORE_IBEX_DBUS_REGWEN_1_OFFSET);
    addr_hit[13] = (reg_addr == RV_CORE_IBEX_DBUS_ADDR_EN_0_OFFSET);
    addr_hit[14] = (reg_addr == RV_CORE_IBEX_DBUS_ADDR_EN_1_OFFSET);
    addr_hit[15] = (reg_addr == RV_CORE_IBEX_DBUS_ADDR_MATCHING_0_OFFSET);
    addr_hit[16] = (reg_addr == RV_CORE_IBEX_DBUS_ADDR_MATCHING_1_OFFSET);
    addr_hit[17] = (reg_addr == RV_CORE_IBEX_DBUS_REMAP_ADDR_0_OFFSET);
    addr_hit[18] = (reg_addr == RV_CORE_IBEX_DBUS_REMAP_ADDR_1_OFFSET);
    addr_hit[19] = (reg_addr == RV_CORE_IBEX_NMI_ENABLE_OFFSET);
    addr_hit[20] = (reg_addr == RV_CORE_IBEX_NMI_STATE_OFFSET);
    addr_hit[21] = (reg_addr == RV_CORE_IBEX_ERR_STATUS_OFFSET);
    addr_hit[22] = (reg_addr == RV_CORE_IBEX_RND_DATA_OFFSET);
    addr_hit[23] = (reg_addr == RV_CORE_IBEX_RND_STATUS_OFFSET);
    addr_hit[24] = (reg_addr == RV_CORE_IBEX_FPGA_INFO_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(RV_CORE_IBEX_CFG_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(RV_CORE_IBEX_CFG_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(RV_CORE_IBEX_CFG_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(RV_CORE_IBEX_CFG_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(RV_CORE_IBEX_CFG_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(RV_CORE_IBEX_CFG_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(RV_CORE_IBEX_CFG_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(RV_CORE_IBEX_CFG_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(RV_CORE_IBEX_CFG_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(RV_CORE_IBEX_CFG_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(RV_CORE_IBEX_CFG_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(RV_CORE_IBEX_CFG_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(RV_CORE_IBEX_CFG_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(RV_CORE_IBEX_CFG_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(RV_CORE_IBEX_CFG_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(RV_CORE_IBEX_CFG_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(RV_CORE_IBEX_CFG_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(RV_CORE_IBEX_CFG_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(RV_CORE_IBEX_CFG_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(RV_CORE_IBEX_CFG_PERMIT[19] & ~reg_be))) |
               (addr_hit[20] & (|(RV_CORE_IBEX_CFG_PERMIT[20] & ~reg_be))) |
               (addr_hit[21] & (|(RV_CORE_IBEX_CFG_PERMIT[21] & ~reg_be))) |
               (addr_hit[22] & (|(RV_CORE_IBEX_CFG_PERMIT[22] & ~reg_be))) |
               (addr_hit[23] & (|(RV_CORE_IBEX_CFG_PERMIT[23] & ~reg_be))) |
               (addr_hit[24] & (|(RV_CORE_IBEX_CFG_PERMIT[24] & ~reg_be)))));
  end

  // Generate write-enables
  assign alert_test_we = addr_hit[0] & reg_we & !reg_error;

  assign alert_test_fatal_sw_err_wd = reg_wdata[0];

  assign alert_test_recov_sw_err_wd = reg_wdata[1];

  assign alert_test_fatal_hw_err_wd = reg_wdata[2];

  assign alert_test_recov_hw_err_wd = reg_wdata[3];
  assign sw_recov_err_we = addr_hit[1] & reg_we & !reg_error;

  assign sw_recov_err_wd = reg_wdata[3:0];
  assign sw_fatal_err_we = addr_hit[2] & reg_we & !reg_error;

  assign sw_fatal_err_wd = reg_wdata[3:0];
  assign ibus_regwen_0_we = addr_hit[3] & reg_we & !reg_error;

  assign ibus_regwen_0_wd = reg_wdata[0];
  assign ibus_regwen_1_we = addr_hit[4] & reg_we & !reg_error;

  assign ibus_regwen_1_wd = reg_wdata[0];
  assign ibus_addr_en_0_we = addr_hit[5] & reg_we & !reg_error;

  assign ibus_addr_en_0_wd = reg_wdata[0];
  assign ibus_addr_en_1_we = addr_hit[6] & reg_we & !reg_error;

  assign ibus_addr_en_1_wd = reg_wdata[0];
  assign ibus_addr_matching_0_we = addr_hit[7] & reg_we & !reg_error;

  assign ibus_addr_matching_0_wd = reg_wdata[31:0];
  assign ibus_addr_matching_1_we = addr_hit[8] & reg_we & !reg_error;

  assign ibus_addr_matching_1_wd = reg_wdata[31:0];
  assign ibus_remap_addr_0_we = addr_hit[9] & reg_we & !reg_error;

  assign ibus_remap_addr_0_wd = reg_wdata[31:0];
  assign ibus_remap_addr_1_we = addr_hit[10] & reg_we & !reg_error;

  assign ibus_remap_addr_1_wd = reg_wdata[31:0];
  assign dbus_regwen_0_we = addr_hit[11] & reg_we & !reg_error;

  assign dbus_regwen_0_wd = reg_wdata[0];
  assign dbus_regwen_1_we = addr_hit[12] & reg_we & !reg_error;

  assign dbus_regwen_1_wd = reg_wdata[0];
  assign dbus_addr_en_0_we = addr_hit[13] & reg_we & !reg_error;

  assign dbus_addr_en_0_wd = reg_wdata[0];
  assign dbus_addr_en_1_we = addr_hit[14] & reg_we & !reg_error;

  assign dbus_addr_en_1_wd = reg_wdata[0];
  assign dbus_addr_matching_0_we = addr_hit[15] & reg_we & !reg_error;

  assign dbus_addr_matching_0_wd = reg_wdata[31:0];
  assign dbus_addr_matching_1_we = addr_hit[16] & reg_we & !reg_error;

  assign dbus_addr_matching_1_wd = reg_wdata[31:0];
  assign dbus_remap_addr_0_we = addr_hit[17] & reg_we & !reg_error;

  assign dbus_remap_addr_0_wd = reg_wdata[31:0];
  assign dbus_remap_addr_1_we = addr_hit[18] & reg_we & !reg_error;

  assign dbus_remap_addr_1_wd = reg_wdata[31:0];
  assign nmi_enable_we = addr_hit[19] & reg_we & !reg_error;

  assign nmi_enable_alert_en_wd = reg_wdata[0];

  assign nmi_enable_wdog_en_wd = reg_wdata[1];
  assign nmi_state_we = addr_hit[20] & reg_we & !reg_error;

  assign nmi_state_alert_wd = reg_wdata[0];

  assign nmi_state_wdog_wd = reg_wdata[1];
  assign err_status_we = addr_hit[21] & reg_we & !reg_error;

  assign err_status_reg_intg_err_wd = reg_wdata[0];

  assign err_status_fatal_intg_err_wd = reg_wdata[8];

  assign err_status_fatal_core_err_wd = reg_wdata[9];

  assign err_status_recov_core_err_wd = reg_wdata[10];
  assign rnd_data_re = addr_hit[22] & reg_re & !reg_error;
  assign rnd_status_re = addr_hit[23] & reg_re & !reg_error;
  assign fpga_info_re = addr_hit[24] & reg_re & !reg_error;

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check = '0;
    reg_we_check[0] = alert_test_we;
    reg_we_check[1] = sw_recov_err_we;
    reg_we_check[2] = sw_fatal_err_we;
    reg_we_check[3] = ibus_regwen_0_we;
    reg_we_check[4] = ibus_regwen_1_we;
    reg_we_check[5] = ibus_addr_en_0_gated_we;
    reg_we_check[6] = ibus_addr_en_1_gated_we;
    reg_we_check[7] = ibus_addr_matching_0_gated_we;
    reg_we_check[8] = ibus_addr_matching_1_gated_we;
    reg_we_check[9] = ibus_remap_addr_0_gated_we;
    reg_we_check[10] = ibus_remap_addr_1_gated_we;
    reg_we_check[11] = dbus_regwen_0_we;
    reg_we_check[12] = dbus_regwen_1_we;
    reg_we_check[13] = dbus_addr_en_0_gated_we;
    reg_we_check[14] = dbus_addr_en_1_gated_we;
    reg_we_check[15] = dbus_addr_matching_0_gated_we;
    reg_we_check[16] = dbus_addr_matching_1_gated_we;
    reg_we_check[17] = dbus_remap_addr_0_gated_we;
    reg_we_check[18] = dbus_remap_addr_1_gated_we;
    reg_we_check[19] = nmi_enable_we;
    reg_we_check[20] = nmi_state_we;
    reg_we_check[21] = err_status_we;
    reg_we_check[22] = 1'b0;
    reg_we_check[23] = 1'b0;
    reg_we_check[24] = 1'b0;
  end

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
        reg_rdata_next[3:0] = sw_recov_err_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[3:0] = sw_fatal_err_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = ibus_regwen_0_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = ibus_regwen_1_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = ibus_addr_en_0_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = ibus_addr_en_1_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = ibus_addr_matching_0_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = ibus_addr_matching_1_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = ibus_remap_addr_0_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = ibus_remap_addr_1_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[0] = dbus_regwen_0_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[0] = dbus_regwen_1_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = dbus_addr_en_0_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[0] = dbus_addr_en_1_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[31:0] = dbus_addr_matching_0_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[31:0] = dbus_addr_matching_1_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = dbus_remap_addr_0_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = dbus_remap_addr_1_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[0] = nmi_enable_alert_en_qs;
        reg_rdata_next[1] = nmi_enable_wdog_en_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[0] = nmi_state_alert_qs;
        reg_rdata_next[1] = nmi_state_wdog_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[0] = err_status_reg_intg_err_qs;
        reg_rdata_next[8] = err_status_fatal_intg_err_qs;
        reg_rdata_next[9] = err_status_fatal_core_err_qs;
        reg_rdata_next[10] = err_status_recov_core_err_qs;
      end

      addr_hit[22]: begin
        reg_rdata_next[31:0] = rnd_data_qs;
      end

      addr_hit[23]: begin
        reg_rdata_next[0] = rnd_status_rnd_data_valid_qs;
        reg_rdata_next[1] = rnd_status_rnd_data_fips_qs;
      end

      addr_hit[24]: begin
        reg_rdata_next[31:0] = fpga_info_qs;
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
  assign reg_busy = shadow_busy;

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
