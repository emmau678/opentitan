// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module rstmgr_reg_top (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output rstmgr_reg_pkg::rstmgr_reg2hw_t reg2hw, // Write
  input  rstmgr_reg_pkg::rstmgr_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import rstmgr_reg_pkg::* ;

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
  logic reset_info_por_qs;
  logic reset_info_por_wd;
  logic reset_info_por_we;
  logic reset_info_low_power_exit_qs;
  logic reset_info_low_power_exit_wd;
  logic reset_info_low_power_exit_we;
  logic reset_info_ndm_reset_qs;
  logic reset_info_ndm_reset_wd;
  logic reset_info_ndm_reset_we;
  logic [1:0] reset_info_hw_req_qs;
  logic [1:0] reset_info_hw_req_wd;
  logic reset_info_hw_req_we;
  logic alert_regwen_qs;
  logic alert_regwen_wd;
  logic alert_regwen_we;
  logic alert_info_ctrl_en_qs;
  logic alert_info_ctrl_en_wd;
  logic alert_info_ctrl_en_we;
  logic [3:0] alert_info_ctrl_index_qs;
  logic [3:0] alert_info_ctrl_index_wd;
  logic alert_info_ctrl_index_we;
  logic [3:0] alert_info_attr_qs;
  logic alert_info_attr_re;
  logic [31:0] alert_info_qs;
  logic alert_info_re;
  logic cpu_regwen_qs;
  logic cpu_regwen_wd;
  logic cpu_regwen_we;
  logic cpu_info_ctrl_en_qs;
  logic cpu_info_ctrl_en_wd;
  logic cpu_info_ctrl_en_we;
  logic [3:0] cpu_info_ctrl_index_qs;
  logic [3:0] cpu_info_ctrl_index_wd;
  logic cpu_info_ctrl_index_we;
  logic [3:0] cpu_info_attr_qs;
  logic cpu_info_attr_re;
  logic [31:0] cpu_info_qs;
  logic cpu_info_re;
  logic sw_rst_regen_en_0_qs;
  logic sw_rst_regen_en_0_wd;
  logic sw_rst_regen_en_0_we;
  logic sw_rst_regen_en_1_qs;
  logic sw_rst_regen_en_1_wd;
  logic sw_rst_regen_en_1_we;
  logic sw_rst_regen_en_2_qs;
  logic sw_rst_regen_en_2_wd;
  logic sw_rst_regen_en_2_we;
  logic sw_rst_regen_en_3_qs;
  logic sw_rst_regen_en_3_wd;
  logic sw_rst_regen_en_3_we;
  logic sw_rst_regen_en_4_qs;
  logic sw_rst_regen_en_4_wd;
  logic sw_rst_regen_en_4_we;
  logic sw_rst_regen_en_5_qs;
  logic sw_rst_regen_en_5_wd;
  logic sw_rst_regen_en_5_we;
  logic sw_rst_regen_en_6_qs;
  logic sw_rst_regen_en_6_wd;
  logic sw_rst_regen_en_6_we;
  logic sw_rst_ctrl_n_val_0_qs;
  logic sw_rst_ctrl_n_val_0_wd;
  logic sw_rst_ctrl_n_val_0_we;
  logic sw_rst_ctrl_n_val_0_re;
  logic sw_rst_ctrl_n_val_1_qs;
  logic sw_rst_ctrl_n_val_1_wd;
  logic sw_rst_ctrl_n_val_1_we;
  logic sw_rst_ctrl_n_val_1_re;
  logic sw_rst_ctrl_n_val_2_qs;
  logic sw_rst_ctrl_n_val_2_wd;
  logic sw_rst_ctrl_n_val_2_we;
  logic sw_rst_ctrl_n_val_2_re;
  logic sw_rst_ctrl_n_val_3_qs;
  logic sw_rst_ctrl_n_val_3_wd;
  logic sw_rst_ctrl_n_val_3_we;
  logic sw_rst_ctrl_n_val_3_re;
  logic sw_rst_ctrl_n_val_4_qs;
  logic sw_rst_ctrl_n_val_4_wd;
  logic sw_rst_ctrl_n_val_4_we;
  logic sw_rst_ctrl_n_val_4_re;
  logic sw_rst_ctrl_n_val_5_qs;
  logic sw_rst_ctrl_n_val_5_wd;
  logic sw_rst_ctrl_n_val_5_we;
  logic sw_rst_ctrl_n_val_5_re;
  logic sw_rst_ctrl_n_val_6_qs;
  logic sw_rst_ctrl_n_val_6_wd;
  logic sw_rst_ctrl_n_val_6_we;
  logic sw_rst_ctrl_n_val_6_re;

  // Register instances
  // R[reset_info]: V(False)

  //   F[por]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h1)
  ) u_reset_info_por (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (reset_info_por_we),
    .wd     (reset_info_por_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_info_por_qs)
  );


  //   F[low_power_exit]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_reset_info_low_power_exit (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (reset_info_low_power_exit_we),
    .wd     (reset_info_low_power_exit_wd),

    // from internal hardware
    .de     (hw2reg.reset_info.low_power_exit.de),
    .d      (hw2reg.reset_info.low_power_exit.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_info_low_power_exit_qs)
  );


  //   F[ndm_reset]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_reset_info_ndm_reset (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (reset_info_ndm_reset_we),
    .wd     (reset_info_ndm_reset_wd),

    // from internal hardware
    .de     (hw2reg.reset_info.ndm_reset.de),
    .d      (hw2reg.reset_info.ndm_reset.d ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (reset_info_ndm_reset_qs)
  );


  //   F[hw_req]: 4:3
  prim_subreg #(
    .DW      (2),
    .SWACCESS("W1C"),
    .RESVAL  (2'h0)
  ) u_reset_info_hw_req (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (reset_info_hw_req_we),
    .wd     (reset_info_hw_req_wd),

    // from internal hardware
    .de     (hw2reg.reset_info.hw_req.de),
    .d      (hw2reg.reset_info.hw_req.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.reset_info.hw_req.q ),

    // to register interface (read)
    .qs     (reset_info_hw_req_qs)
  );


  // R[alert_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_alert_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (alert_regwen_we),
    .wd     (alert_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (alert_regwen_qs)
  );


  // R[alert_info_ctrl]: V(False)

  //   F[en]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_alert_info_ctrl_en (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (alert_info_ctrl_en_we & alert_regwen_qs),
    .wd     (alert_info_ctrl_en_wd),

    // from internal hardware
    .de     (hw2reg.alert_info_ctrl.en.de),
    .d      (hw2reg.alert_info_ctrl.en.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_info_ctrl.en.q ),

    // to register interface (read)
    .qs     (alert_info_ctrl_en_qs)
  );


  //   F[index]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_alert_info_ctrl_index (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (alert_info_ctrl_index_we & alert_regwen_qs),
    .wd     (alert_info_ctrl_index_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.alert_info_ctrl.index.q ),

    // to register interface (read)
    .qs     (alert_info_ctrl_index_qs)
  );


  // R[alert_info_attr]: V(True)

  prim_subreg_ext #(
    .DW    (4)
  ) u_alert_info_attr (
    .re     (alert_info_attr_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.alert_info_attr.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (alert_info_attr_qs)
  );


  // R[alert_info]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_alert_info (
    .re     (alert_info_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.alert_info.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (alert_info_qs)
  );


  // R[cpu_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_cpu_regwen (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (cpu_regwen_we),
    .wd     (cpu_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (cpu_regwen_qs)
  );


  // R[cpu_info_ctrl]: V(False)

  //   F[en]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_cpu_info_ctrl_en (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (cpu_info_ctrl_en_we & cpu_regwen_qs),
    .wd     (cpu_info_ctrl_en_wd),

    // from internal hardware
    .de     (hw2reg.cpu_info_ctrl.en.de),
    .d      (hw2reg.cpu_info_ctrl.en.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cpu_info_ctrl.en.q ),

    // to register interface (read)
    .qs     (cpu_info_ctrl_en_qs)
  );


  //   F[index]: 7:4
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_cpu_info_ctrl_index (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface (qualified with register enable)
    .we     (cpu_info_ctrl_index_we & cpu_regwen_qs),
    .wd     (cpu_info_ctrl_index_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cpu_info_ctrl.index.q ),

    // to register interface (read)
    .qs     (cpu_info_ctrl_index_qs)
  );


  // R[cpu_info_attr]: V(True)

  prim_subreg_ext #(
    .DW    (4)
  ) u_cpu_info_attr (
    .re     (cpu_info_attr_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.cpu_info_attr.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (cpu_info_attr_qs)
  );


  // R[cpu_info]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_cpu_info (
    .re     (cpu_info_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.cpu_info.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (cpu_info_qs)
  );



  // Subregister 0 of Multireg sw_rst_regen
  // R[sw_rst_regen]: V(False)

  // F[en_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_0_we),
    .wd     (sw_rst_regen_en_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[0].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_0_qs)
  );


  // F[en_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_1_we),
    .wd     (sw_rst_regen_en_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[1].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_1_qs)
  );


  // F[en_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_2_we),
    .wd     (sw_rst_regen_en_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[2].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_2_qs)
  );


  // F[en_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_3_we),
    .wd     (sw_rst_regen_en_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[3].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_3_qs)
  );


  // F[en_4]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_4_we),
    .wd     (sw_rst_regen_en_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[4].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_4_qs)
  );


  // F[en_5]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_5_we),
    .wd     (sw_rst_regen_en_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[5].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_5_qs)
  );


  // F[en_6]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_sw_rst_regen_en_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (sw_rst_regen_en_6_we),
    .wd     (sw_rst_regen_en_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.sw_rst_regen[6].q ),

    // to register interface (read)
    .qs     (sw_rst_regen_en_6_qs)
  );




  // Subregister 0 of Multireg sw_rst_ctrl_n
  // R[sw_rst_ctrl_n]: V(True)

  // F[val_0]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_0 (
    .re     (sw_rst_ctrl_n_val_0_re),
    .we     (sw_rst_ctrl_n_val_0_we),
    .wd     (sw_rst_ctrl_n_val_0_wd),
    .d      (hw2reg.sw_rst_ctrl_n[0].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[0].qe),
    .q      (reg2hw.sw_rst_ctrl_n[0].q ),
    .qs     (sw_rst_ctrl_n_val_0_qs)
  );


  // F[val_1]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_1 (
    .re     (sw_rst_ctrl_n_val_1_re),
    .we     (sw_rst_ctrl_n_val_1_we),
    .wd     (sw_rst_ctrl_n_val_1_wd),
    .d      (hw2reg.sw_rst_ctrl_n[1].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[1].qe),
    .q      (reg2hw.sw_rst_ctrl_n[1].q ),
    .qs     (sw_rst_ctrl_n_val_1_qs)
  );


  // F[val_2]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_2 (
    .re     (sw_rst_ctrl_n_val_2_re),
    .we     (sw_rst_ctrl_n_val_2_we),
    .wd     (sw_rst_ctrl_n_val_2_wd),
    .d      (hw2reg.sw_rst_ctrl_n[2].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[2].qe),
    .q      (reg2hw.sw_rst_ctrl_n[2].q ),
    .qs     (sw_rst_ctrl_n_val_2_qs)
  );


  // F[val_3]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_3 (
    .re     (sw_rst_ctrl_n_val_3_re),
    .we     (sw_rst_ctrl_n_val_3_we),
    .wd     (sw_rst_ctrl_n_val_3_wd),
    .d      (hw2reg.sw_rst_ctrl_n[3].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[3].qe),
    .q      (reg2hw.sw_rst_ctrl_n[3].q ),
    .qs     (sw_rst_ctrl_n_val_3_qs)
  );


  // F[val_4]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_4 (
    .re     (sw_rst_ctrl_n_val_4_re),
    .we     (sw_rst_ctrl_n_val_4_we),
    .wd     (sw_rst_ctrl_n_val_4_wd),
    .d      (hw2reg.sw_rst_ctrl_n[4].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[4].qe),
    .q      (reg2hw.sw_rst_ctrl_n[4].q ),
    .qs     (sw_rst_ctrl_n_val_4_qs)
  );


  // F[val_5]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_5 (
    .re     (sw_rst_ctrl_n_val_5_re),
    .we     (sw_rst_ctrl_n_val_5_we),
    .wd     (sw_rst_ctrl_n_val_5_wd),
    .d      (hw2reg.sw_rst_ctrl_n[5].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[5].qe),
    .q      (reg2hw.sw_rst_ctrl_n[5].q ),
    .qs     (sw_rst_ctrl_n_val_5_qs)
  );


  // F[val_6]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_sw_rst_ctrl_n_val_6 (
    .re     (sw_rst_ctrl_n_val_6_re),
    .we     (sw_rst_ctrl_n_val_6_we),
    .wd     (sw_rst_ctrl_n_val_6_wd),
    .d      (hw2reg.sw_rst_ctrl_n[6].d),
    .qre    (),
    .qe     (reg2hw.sw_rst_ctrl_n[6].qe),
    .q      (reg2hw.sw_rst_ctrl_n[6].q ),
    .qs     (sw_rst_ctrl_n_val_6_qs)
  );





  logic [10:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == RSTMGR_RESET_INFO_OFFSET);
    addr_hit[ 1] = (reg_addr == RSTMGR_ALERT_REGWEN_OFFSET);
    addr_hit[ 2] = (reg_addr == RSTMGR_ALERT_INFO_CTRL_OFFSET);
    addr_hit[ 3] = (reg_addr == RSTMGR_ALERT_INFO_ATTR_OFFSET);
    addr_hit[ 4] = (reg_addr == RSTMGR_ALERT_INFO_OFFSET);
    addr_hit[ 5] = (reg_addr == RSTMGR_CPU_REGWEN_OFFSET);
    addr_hit[ 6] = (reg_addr == RSTMGR_CPU_INFO_CTRL_OFFSET);
    addr_hit[ 7] = (reg_addr == RSTMGR_CPU_INFO_ATTR_OFFSET);
    addr_hit[ 8] = (reg_addr == RSTMGR_CPU_INFO_OFFSET);
    addr_hit[ 9] = (reg_addr == RSTMGR_SW_RST_REGEN_OFFSET);
    addr_hit[10] = (reg_addr == RSTMGR_SW_RST_CTRL_N_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(RSTMGR_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(RSTMGR_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(RSTMGR_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(RSTMGR_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(RSTMGR_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(RSTMGR_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(RSTMGR_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(RSTMGR_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(RSTMGR_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(RSTMGR_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(RSTMGR_PERMIT[10] & ~reg_be)))));
  end

  assign reset_info_por_we = addr_hit[0] & reg_we & !reg_error;
  assign reset_info_por_wd = reg_wdata[0];

  assign reset_info_low_power_exit_we = addr_hit[0] & reg_we & !reg_error;
  assign reset_info_low_power_exit_wd = reg_wdata[1];

  assign reset_info_ndm_reset_we = addr_hit[0] & reg_we & !reg_error;
  assign reset_info_ndm_reset_wd = reg_wdata[2];

  assign reset_info_hw_req_we = addr_hit[0] & reg_we & !reg_error;
  assign reset_info_hw_req_wd = reg_wdata[4:3];

  assign alert_regwen_we = addr_hit[1] & reg_we & !reg_error;
  assign alert_regwen_wd = reg_wdata[0];

  assign alert_info_ctrl_en_we = addr_hit[2] & reg_we & !reg_error;
  assign alert_info_ctrl_en_wd = reg_wdata[0];

  assign alert_info_ctrl_index_we = addr_hit[2] & reg_we & !reg_error;
  assign alert_info_ctrl_index_wd = reg_wdata[7:4];

  assign alert_info_attr_re = addr_hit[3] & reg_re & !reg_error;

  assign alert_info_re = addr_hit[4] & reg_re & !reg_error;

  assign cpu_regwen_we = addr_hit[5] & reg_we & !reg_error;
  assign cpu_regwen_wd = reg_wdata[0];

  assign cpu_info_ctrl_en_we = addr_hit[6] & reg_we & !reg_error;
  assign cpu_info_ctrl_en_wd = reg_wdata[0];

  assign cpu_info_ctrl_index_we = addr_hit[6] & reg_we & !reg_error;
  assign cpu_info_ctrl_index_wd = reg_wdata[7:4];

  assign cpu_info_attr_re = addr_hit[7] & reg_re & !reg_error;

  assign cpu_info_re = addr_hit[8] & reg_re & !reg_error;

  assign sw_rst_regen_en_0_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_0_wd = reg_wdata[0];

  assign sw_rst_regen_en_1_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_1_wd = reg_wdata[1];

  assign sw_rst_regen_en_2_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_2_wd = reg_wdata[2];

  assign sw_rst_regen_en_3_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_3_wd = reg_wdata[3];

  assign sw_rst_regen_en_4_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_4_wd = reg_wdata[4];

  assign sw_rst_regen_en_5_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_5_wd = reg_wdata[5];

  assign sw_rst_regen_en_6_we = addr_hit[9] & reg_we & !reg_error;
  assign sw_rst_regen_en_6_wd = reg_wdata[6];

  assign sw_rst_ctrl_n_val_0_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_0_wd = reg_wdata[0];
  assign sw_rst_ctrl_n_val_0_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_1_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_1_wd = reg_wdata[1];
  assign sw_rst_ctrl_n_val_1_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_2_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_2_wd = reg_wdata[2];
  assign sw_rst_ctrl_n_val_2_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_3_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_3_wd = reg_wdata[3];
  assign sw_rst_ctrl_n_val_3_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_4_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_4_wd = reg_wdata[4];
  assign sw_rst_ctrl_n_val_4_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_5_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_5_wd = reg_wdata[5];
  assign sw_rst_ctrl_n_val_5_re = addr_hit[10] & reg_re & !reg_error;

  assign sw_rst_ctrl_n_val_6_we = addr_hit[10] & reg_we & !reg_error;
  assign sw_rst_ctrl_n_val_6_wd = reg_wdata[6];
  assign sw_rst_ctrl_n_val_6_re = addr_hit[10] & reg_re & !reg_error;

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = reset_info_por_qs;
        reg_rdata_next[1] = reset_info_low_power_exit_qs;
        reg_rdata_next[2] = reset_info_ndm_reset_qs;
        reg_rdata_next[4:3] = reset_info_hw_req_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = alert_regwen_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = alert_info_ctrl_en_qs;
        reg_rdata_next[7:4] = alert_info_ctrl_index_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[3:0] = alert_info_attr_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[31:0] = alert_info_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = cpu_regwen_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = cpu_info_ctrl_en_qs;
        reg_rdata_next[7:4] = cpu_info_ctrl_index_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[3:0] = cpu_info_attr_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = cpu_info_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[0] = sw_rst_regen_en_0_qs;
        reg_rdata_next[1] = sw_rst_regen_en_1_qs;
        reg_rdata_next[2] = sw_rst_regen_en_2_qs;
        reg_rdata_next[3] = sw_rst_regen_en_3_qs;
        reg_rdata_next[4] = sw_rst_regen_en_4_qs;
        reg_rdata_next[5] = sw_rst_regen_en_5_qs;
        reg_rdata_next[6] = sw_rst_regen_en_6_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = sw_rst_ctrl_n_val_0_qs;
        reg_rdata_next[1] = sw_rst_ctrl_n_val_1_qs;
        reg_rdata_next[2] = sw_rst_ctrl_n_val_2_qs;
        reg_rdata_next[3] = sw_rst_ctrl_n_val_3_qs;
        reg_rdata_next[4] = sw_rst_ctrl_n_val_4_qs;
        reg_rdata_next[5] = sw_rst_ctrl_n_val_5_qs;
        reg_rdata_next[6] = sw_rst_ctrl_n_val_6_qs;
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
