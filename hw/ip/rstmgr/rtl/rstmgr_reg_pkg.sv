// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rstmgr_reg_pkg;

  // Param list
  parameter int RdWidth = 32;
  parameter int IdxWidth = 4;
  parameter int NumSwResets = 2;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
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
    logic        q;
  } rstmgr_reg2hw_sw_rst_regwen_mreg_t;

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
      logic        d;
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
    logic        d;
  } rstmgr_hw2reg_sw_rst_ctrl_n_mreg_t;

  // Register -> HW type
  typedef struct packed {
    rstmgr_reg2hw_reset_info_reg_t reset_info; // [11:11]
    rstmgr_reg2hw_alert_info_ctrl_reg_t alert_info_ctrl; // [10:6]
    rstmgr_reg2hw_sw_rst_regwen_mreg_t [1:0] sw_rst_regwen; // [5:4]
    rstmgr_reg2hw_sw_rst_ctrl_n_mreg_t [1:0] sw_rst_ctrl_n; // [3:0]
  } rstmgr_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    rstmgr_hw2reg_reset_info_reg_t reset_info; // [45:40]
    rstmgr_hw2reg_alert_info_ctrl_reg_t alert_info_ctrl; // [39:38]
    rstmgr_hw2reg_alert_info_attr_reg_t alert_info_attr; // [37:34]
    rstmgr_hw2reg_alert_info_reg_t alert_info; // [33:2]
    rstmgr_hw2reg_sw_rst_ctrl_n_mreg_t [1:0] sw_rst_ctrl_n; // [1:0]
  } rstmgr_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] RSTMGR_CIP_ID_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] RSTMGR_REVISION_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] RSTMGR_PARAMETER_BLOCK_TYPE_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] RSTMGR_PARAMETER_BLOCK_LENGTH_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] RSTMGR_NEXT_PARAMETER_BLOCK_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] RSTMGR_RESET_INFO_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_CTRL_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_ATTR_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] RSTMGR_ALERT_INFO_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] RSTMGR_SW_RST_REGWEN_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] RSTMGR_SW_RST_CTRL_N_OFFSET = 7'h 54;

  // Reset values for hwext registers and their fields
  parameter logic [3:0] RSTMGR_ALERT_INFO_ATTR_RESVAL = 4'h 0;
  parameter logic [3:0] RSTMGR_ALERT_INFO_ATTR_CNT_AVAIL_RESVAL = 4'h 0;
  parameter logic [31:0] RSTMGR_ALERT_INFO_RESVAL = 32'h 0;
  parameter logic [31:0] RSTMGR_ALERT_INFO_VALUE_RESVAL = 32'h 0;
  parameter logic [1:0] RSTMGR_SW_RST_CTRL_N_RESVAL = 2'h 3;
  parameter logic [0:0] RSTMGR_SW_RST_CTRL_N_VAL_0_RESVAL = 1'h 1;
  parameter logic [0:0] RSTMGR_SW_RST_CTRL_N_VAL_1_RESVAL = 1'h 1;

  // Register index
  typedef enum int {
    RSTMGR_CIP_ID,
    RSTMGR_REVISION,
    RSTMGR_PARAMETER_BLOCK_TYPE,
    RSTMGR_PARAMETER_BLOCK_LENGTH,
    RSTMGR_NEXT_PARAMETER_BLOCK,
    RSTMGR_RESET_INFO,
    RSTMGR_ALERT_INFO_CTRL,
    RSTMGR_ALERT_INFO_ATTR,
    RSTMGR_ALERT_INFO,
    RSTMGR_SW_RST_REGWEN,
    RSTMGR_SW_RST_CTRL_N
  } rstmgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] RSTMGR_PERMIT [11] = '{
    4'b 1111, // index[ 0] RSTMGR_CIP_ID
    4'b 1111, // index[ 1] RSTMGR_REVISION
    4'b 1111, // index[ 2] RSTMGR_PARAMETER_BLOCK_TYPE
    4'b 1111, // index[ 3] RSTMGR_PARAMETER_BLOCK_LENGTH
    4'b 1111, // index[ 4] RSTMGR_NEXT_PARAMETER_BLOCK
    4'b 0001, // index[ 5] RSTMGR_RESET_INFO
    4'b 0001, // index[ 6] RSTMGR_ALERT_INFO_CTRL
    4'b 0001, // index[ 7] RSTMGR_ALERT_INFO_ATTR
    4'b 1111, // index[ 8] RSTMGR_ALERT_INFO
    4'b 0001, // index[ 9] RSTMGR_SW_RST_REGWEN
    4'b 0001  // index[10] RSTMGR_SW_RST_CTRL_N
  };

endpackage
