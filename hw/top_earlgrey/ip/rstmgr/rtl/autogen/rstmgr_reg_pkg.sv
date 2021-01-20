// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rstmgr_reg_pkg;

  // Param list
  parameter int RdWidth = 32;
  parameter int IdxWidth = 4;
  parameter int NumHwResets = 2;
  parameter int NumSwResets = 2;

  // Address width within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic [1:0]  q;
    } hw_req;
  } rstmgr_reg2hw_reset_info_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [3:0]  q;
    } index;
  } rstmgr_reg2hw_alert_info_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [3:0]  q;
    } index;
  } rstmgr_reg2hw_cpu_info_ctrl_reg_t;

  typedef struct packed {
    logic        q;
  } rstmgr_reg2hw_sw_rst_regen_mreg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } rstmgr_reg2hw_sw_rst_ctrl_n_mreg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } low_power_exit;
    struct packed {
      logic        d;
      logic        de;
    } ndm_reset;
    struct packed {
      logic [1:0]  d;
      logic        de;
    } hw_req;
  } rstmgr_hw2reg_reset_info_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } en;
  } rstmgr_hw2reg_alert_info_ctrl_reg_t;

  typedef struct packed {
    logic [3:0]  d;
  } rstmgr_hw2reg_alert_info_attr_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } rstmgr_hw2reg_alert_info_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } en;
  } rstmgr_hw2reg_cpu_info_ctrl_reg_t;

  typedef struct packed {
    logic [3:0]  d;
  } rstmgr_hw2reg_cpu_info_attr_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } rstmgr_hw2reg_cpu_info_reg_t;

  typedef struct packed {
    logic        d;
  } rstmgr_hw2reg_sw_rst_ctrl_n_mreg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    rstmgr_reg2hw_reset_info_reg_t reset_info; // [17:16]
    rstmgr_reg2hw_alert_info_ctrl_reg_t alert_info_ctrl; // [15:11]
    rstmgr_reg2hw_cpu_info_ctrl_reg_t cpu_info_ctrl; // [10:6]
    rstmgr_reg2hw_sw_rst_regen_mreg_t [1:0] sw_rst_regen; // [5:4]
    rstmgr_reg2hw_sw_rst_ctrl_n_mreg_t [1:0] sw_rst_ctrl_n; // [3:0]
  } rstmgr_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    rstmgr_hw2reg_reset_info_reg_t reset_info; // [84:78]
    rstmgr_hw2reg_alert_info_ctrl_reg_t alert_info_ctrl; // [77:76]
    rstmgr_hw2reg_alert_info_attr_reg_t alert_info_attr; // [75:72]
    rstmgr_hw2reg_alert_info_reg_t alert_info; // [71:40]
    rstmgr_hw2reg_cpu_info_ctrl_reg_t cpu_info_ctrl; // [39:38]
    rstmgr_hw2reg_cpu_info_attr_reg_t cpu_info_attr; // [37:34]
    rstmgr_hw2reg_cpu_info_reg_t cpu_info; // [33:2]
    rstmgr_hw2reg_sw_rst_ctrl_n_mreg_t [1:0] sw_rst_ctrl_n; // [1:0]
  } rstmgr_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] RSTMGR_RESET_INFO_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_CTRL_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_ATTR_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] RSTMGR_CPU_INFO_CTRL_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] RSTMGR_CPU_INFO_ATTR_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] RSTMGR_CPU_INFO_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] RSTMGR_SW_RST_REGEN_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] RSTMGR_SW_RST_CTRL_N_OFFSET = 6'h 20;


  // Register Index
  typedef enum int {
    RSTMGR_RESET_INFO,
    RSTMGR_ALERT_INFO_CTRL,
    RSTMGR_ALERT_INFO_ATTR,
    RSTMGR_ALERT_INFO,
    RSTMGR_CPU_INFO_CTRL,
    RSTMGR_CPU_INFO_ATTR,
    RSTMGR_CPU_INFO,
    RSTMGR_SW_RST_REGEN,
    RSTMGR_SW_RST_CTRL_N
  } rstmgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] RSTMGR_PERMIT [9] = '{
    4'b 0001, // index[0] RSTMGR_RESET_INFO
    4'b 0001, // index[1] RSTMGR_ALERT_INFO_CTRL
    4'b 0001, // index[2] RSTMGR_ALERT_INFO_ATTR
    4'b 1111, // index[3] RSTMGR_ALERT_INFO
    4'b 0001, // index[4] RSTMGR_CPU_INFO_CTRL
    4'b 0001, // index[5] RSTMGR_CPU_INFO_ATTR
    4'b 1111, // index[6] RSTMGR_CPU_INFO
    4'b 0001, // index[7] RSTMGR_SW_RST_REGEN
    4'b 0001  // index[8] RSTMGR_SW_RST_CTRL_N
  };
endpackage

