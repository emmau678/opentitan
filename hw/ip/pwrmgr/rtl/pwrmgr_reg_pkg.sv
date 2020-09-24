// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package pwrmgr_reg_pkg;

  // Param list
  parameter int NumWkups = 1;
  parameter int NumRstReqs = 1;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic        q;
  } pwrmgr_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } pwrmgr_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } pwrmgr_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } low_power_hint;
    struct packed {
      logic        q;
    } core_clk_en;
    struct packed {
      logic        q;
    } io_clk_en;
    struct packed {
      logic        q;
    } usb_clk_en_lp;
    struct packed {
      logic        q;
    } usb_clk_en_active;
    struct packed {
      logic        q;
    } main_pd_n;
  } pwrmgr_reg2hw_control_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } pwrmgr_reg2hw_cfg_cdc_sync_reg_t;

  typedef struct packed {
    logic        q;
  } pwrmgr_reg2hw_wakeup_en_mreg_t;

  typedef struct packed {
    logic        q;
  } pwrmgr_reg2hw_reset_en_mreg_t;

  typedef struct packed {
    logic        q;
  } pwrmgr_reg2hw_wake_info_capture_dis_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } reasons;
    struct packed {
      logic        q;
      logic        qe;
    } fall_through;
    struct packed {
      logic        q;
      logic        qe;
    } abort;
  } pwrmgr_reg2hw_wake_info_reg_t;


  typedef struct packed {
    logic        d;
    logic        de;
  } pwrmgr_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
  } pwrmgr_hw2reg_ctrl_cfg_regwen_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } low_power_hint;
  } pwrmgr_hw2reg_control_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } pwrmgr_hw2reg_cfg_cdc_sync_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } pwrmgr_hw2reg_wake_status_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } pwrmgr_hw2reg_reset_status_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } reasons;
    struct packed {
      logic        d;
    } fall_through;
    struct packed {
      logic        d;
    } abort;
  } pwrmgr_hw2reg_wake_info_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    pwrmgr_reg2hw_intr_state_reg_t intr_state; // [20:20]
    pwrmgr_reg2hw_intr_enable_reg_t intr_enable; // [19:19]
    pwrmgr_reg2hw_intr_test_reg_t intr_test; // [18:17]
    pwrmgr_reg2hw_control_reg_t control; // [16:11]
    pwrmgr_reg2hw_cfg_cdc_sync_reg_t cfg_cdc_sync; // [10:9]
    pwrmgr_reg2hw_wakeup_en_mreg_t [0:0] wakeup_en; // [8:8]
    pwrmgr_reg2hw_reset_en_mreg_t [0:0] reset_en; // [7:7]
    pwrmgr_reg2hw_wake_info_capture_dis_reg_t wake_info_capture_dis; // [6:6]
    pwrmgr_reg2hw_wake_info_reg_t wake_info; // [5:0]
  } pwrmgr_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    pwrmgr_hw2reg_intr_state_reg_t intr_state; // [13:13]
    pwrmgr_hw2reg_ctrl_cfg_regwen_reg_t ctrl_cfg_regwen; // [12:13]
    pwrmgr_hw2reg_control_reg_t control; // [12:7]
    pwrmgr_hw2reg_cfg_cdc_sync_reg_t cfg_cdc_sync; // [6:5]
    pwrmgr_hw2reg_wake_status_mreg_t [0:0] wake_status; // [4:3]
    pwrmgr_hw2reg_reset_status_mreg_t [0:0] reset_status; // [2:1]
    pwrmgr_hw2reg_wake_info_reg_t wake_info; // [0:-5]
  } pwrmgr_hw2reg_t;

  // Register Address
  parameter logic [5:0] PWRMGR_INTR_STATE_OFFSET = 6'h 0;
  parameter logic [5:0] PWRMGR_INTR_ENABLE_OFFSET = 6'h 4;
  parameter logic [5:0] PWRMGR_INTR_TEST_OFFSET = 6'h 8;
  parameter logic [5:0] PWRMGR_CTRL_CFG_REGWEN_OFFSET = 6'h c;
  parameter logic [5:0] PWRMGR_CONTROL_OFFSET = 6'h 10;
  parameter logic [5:0] PWRMGR_CFG_CDC_SYNC_OFFSET = 6'h 14;
  parameter logic [5:0] PWRMGR_WAKEUP_EN_REGWEN_OFFSET = 6'h 18;
  parameter logic [5:0] PWRMGR_WAKEUP_EN_OFFSET = 6'h 1c;
  parameter logic [5:0] PWRMGR_WAKE_STATUS_OFFSET = 6'h 20;
  parameter logic [5:0] PWRMGR_RESET_EN_REGWEN_OFFSET = 6'h 24;
  parameter logic [5:0] PWRMGR_RESET_EN_OFFSET = 6'h 28;
  parameter logic [5:0] PWRMGR_RESET_STATUS_OFFSET = 6'h 2c;
  parameter logic [5:0] PWRMGR_WAKE_INFO_CAPTURE_DIS_OFFSET = 6'h 30;
  parameter logic [5:0] PWRMGR_WAKE_INFO_OFFSET = 6'h 34;


  // Register Index
  typedef enum int {
    PWRMGR_INTR_STATE,
    PWRMGR_INTR_ENABLE,
    PWRMGR_INTR_TEST,
    PWRMGR_CTRL_CFG_REGWEN,
    PWRMGR_CONTROL,
    PWRMGR_CFG_CDC_SYNC,
    PWRMGR_WAKEUP_EN_REGWEN,
    PWRMGR_WAKEUP_EN,
    PWRMGR_WAKE_STATUS,
    PWRMGR_RESET_EN_REGWEN,
    PWRMGR_RESET_EN,
    PWRMGR_RESET_STATUS,
    PWRMGR_WAKE_INFO_CAPTURE_DIS,
    PWRMGR_WAKE_INFO
  } pwrmgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] PWRMGR_PERMIT [14] = '{
    4'b 0001, // index[ 0] PWRMGR_INTR_STATE
    4'b 0001, // index[ 1] PWRMGR_INTR_ENABLE
    4'b 0001, // index[ 2] PWRMGR_INTR_TEST
    4'b 0001, // index[ 3] PWRMGR_CTRL_CFG_REGWEN
    4'b 0011, // index[ 4] PWRMGR_CONTROL
    4'b 0001, // index[ 5] PWRMGR_CFG_CDC_SYNC
    4'b 0001, // index[ 6] PWRMGR_WAKEUP_EN_REGWEN
    4'b 0001, // index[ 7] PWRMGR_WAKEUP_EN
    4'b 0001, // index[ 8] PWRMGR_WAKE_STATUS
    4'b 0001, // index[ 9] PWRMGR_RESET_EN_REGWEN
    4'b 0001, // index[10] PWRMGR_RESET_EN
    4'b 0001, // index[11] PWRMGR_RESET_STATUS
    4'b 0001, // index[12] PWRMGR_WAKE_INFO_CAPTURE_DIS
    4'b 0001  // index[13] PWRMGR_WAKE_INFO
  };
endpackage

