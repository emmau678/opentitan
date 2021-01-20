// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package otp_ctrl_reg_pkg;

  // Param list
  parameter int NumSramKeyReqSlots = 2;
  parameter int OtpByteAddrWidth = 11;
  parameter int NumErrorEntries = 9;
  parameter int NumDaiWords = 2;
  parameter int NumDigestWords = 2;
  parameter int NumSwCfgWindowWords = 512;
  parameter int NumDebugWindowWords = 16;
  parameter int NumPart = 7;
  parameter int CreatorSwCfgOffset = 0;
  parameter int CreatorSwCfgSize = 768;
  parameter int CreatorSwCfgContentOffset = 0;
  parameter int CreatorSwCfgContentSize = 760;
  parameter int CreatorSwCfgDigestOffset = 760;
  parameter int CreatorSwCfgDigestSize = 8;
  parameter int OwnerSwCfgOffset = 768;
  parameter int OwnerSwCfgSize = 768;
  parameter int OwnerSwCfgContentOffset = 768;
  parameter int OwnerSwCfgContentSize = 760;
  parameter int OwnerSwCfgDigestOffset = 1528;
  parameter int OwnerSwCfgDigestSize = 8;
  parameter int HwCfgOffset = 1536;
  parameter int HwCfgSize = 208;
  parameter int DeviceIdOffset = 1536;
  parameter int DeviceIdSize = 32;
  parameter int HwCfgContentOffset = 1568;
  parameter int HwCfgContentSize = 168;
  parameter int HwCfgDigestOffset = 1736;
  parameter int HwCfgDigestSize = 8;
  parameter int Secret0Offset = 1744;
  parameter int Secret0Size = 40;
  parameter int TestUnlockTokenOffset = 1744;
  parameter int TestUnlockTokenSize = 16;
  parameter int TestExitTokenOffset = 1760;
  parameter int TestExitTokenSize = 16;
  parameter int Secret0DigestOffset = 1776;
  parameter int Secret0DigestSize = 8;
  parameter int Secret1Offset = 1784;
  parameter int Secret1Size = 88;
  parameter int FlashAddrKeySeedOffset = 1784;
  parameter int FlashAddrKeySeedSize = 32;
  parameter int FlashDataKeySeedOffset = 1816;
  parameter int FlashDataKeySeedSize = 32;
  parameter int SramDataKeySeedOffset = 1848;
  parameter int SramDataKeySeedSize = 16;
  parameter int Secret1DigestOffset = 1864;
  parameter int Secret1DigestSize = 8;
  parameter int Secret2Offset = 1872;
  parameter int Secret2Size = 120;
  parameter int RmaTokenOffset = 1872;
  parameter int RmaTokenSize = 16;
  parameter int CreatorRootKeyShare0Offset = 1888;
  parameter int CreatorRootKeyShare0Size = 32;
  parameter int CreatorRootKeyShare1Offset = 1920;
  parameter int CreatorRootKeyShare1Size = 32;
  parameter int Secret2DigestOffset = 1984;
  parameter int Secret2DigestSize = 8;
  parameter int LifeCycleOffset = 1992;
  parameter int LifeCycleSize = 56;
  parameter int LcStateOffset = 1992;
  parameter int LcStateSize = 24;
  parameter int LcTransitionCntOffset = 2016;
  parameter int LcTransitionCntSize = 32;
  parameter int NumAlerts = 2;

  // Address width within the block
  parameter int BlockAw = 14;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } otp_operation_done;
    struct packed {
      logic        q;
    } otp_error;
  } otp_ctrl_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } otp_operation_done;
    struct packed {
      logic        q;
    } otp_error;
  } otp_ctrl_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } otp_operation_done;
    struct packed {
      logic        q;
      logic        qe;
    } otp_error;
  } otp_ctrl_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal_macro_error;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_check_error;
  } otp_ctrl_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } rd;
    struct packed {
      logic        q;
      logic        qe;
    } wr;
    struct packed {
      logic        q;
      logic        qe;
    } digest;
  } otp_ctrl_reg2hw_direct_access_cmd_reg_t;

  typedef struct packed {
    logic [10:0] q;
  } otp_ctrl_reg2hw_direct_access_address_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_direct_access_wdata_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } integrity;
    struct packed {
      logic        q;
      logic        qe;
    } consistency;
  } otp_ctrl_reg2hw_check_trigger_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_check_timeout_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_integrity_check_period_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } otp_ctrl_reg2hw_consistency_check_period_reg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_creator_sw_cfg_read_lock_reg_t;

  typedef struct packed {
    logic        q;
  } otp_ctrl_reg2hw_owner_sw_cfg_read_lock_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } otp_operation_done;
    struct packed {
      logic        d;
      logic        de;
    } otp_error;
  } otp_ctrl_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } creator_sw_cfg_error;
    struct packed {
      logic        d;
    } owner_sw_cfg_error;
    struct packed {
      logic        d;
    } hw_cfg_error;
    struct packed {
      logic        d;
    } secret0_error;
    struct packed {
      logic        d;
    } secret1_error;
    struct packed {
      logic        d;
    } secret2_error;
    struct packed {
      logic        d;
    } life_cycle_error;
    struct packed {
      logic        d;
    } dai_error;
    struct packed {
      logic        d;
    } lci_error;
    struct packed {
      logic        d;
    } timeout_error;
    struct packed {
      logic        d;
    } lfsr_fsm_error;
    struct packed {
      logic        d;
    } scrambling_fsm_error;
    struct packed {
      logic        d;
    } key_deriv_fsm_error;
    struct packed {
      logic        d;
    } dai_idle;
    struct packed {
      logic        d;
    } check_pending;
  } otp_ctrl_hw2reg_status_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } otp_ctrl_hw2reg_err_code_mreg_t;

  typedef struct packed {
    logic        d;
  } otp_ctrl_hw2reg_direct_access_regwen_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_direct_access_rdata_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_creator_sw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_owner_sw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_hw_cfg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret0_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret1_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } otp_ctrl_hw2reg_secret2_digest_mreg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    otp_ctrl_reg2hw_intr_state_reg_t intr_state; // [194:193]
    otp_ctrl_reg2hw_intr_enable_reg_t intr_enable; // [192:191]
    otp_ctrl_reg2hw_intr_test_reg_t intr_test; // [190:187]
    otp_ctrl_reg2hw_alert_test_reg_t alert_test; // [186:183]
    otp_ctrl_reg2hw_direct_access_cmd_reg_t direct_access_cmd; // [182:177]
    otp_ctrl_reg2hw_direct_access_address_reg_t direct_access_address; // [176:166]
    otp_ctrl_reg2hw_direct_access_wdata_mreg_t [1:0] direct_access_wdata; // [165:102]
    otp_ctrl_reg2hw_check_trigger_reg_t check_trigger; // [101:98]
    otp_ctrl_reg2hw_check_timeout_reg_t check_timeout; // [97:66]
    otp_ctrl_reg2hw_integrity_check_period_reg_t integrity_check_period; // [65:34]
    otp_ctrl_reg2hw_consistency_check_period_reg_t consistency_check_period; // [33:2]
    otp_ctrl_reg2hw_creator_sw_cfg_read_lock_reg_t creator_sw_cfg_read_lock; // [1:1]
    otp_ctrl_reg2hw_owner_sw_cfg_read_lock_reg_t owner_sw_cfg_read_lock; // [0:0]
  } otp_ctrl_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    otp_ctrl_hw2reg_intr_state_reg_t intr_state; // [494:491]
    otp_ctrl_hw2reg_status_reg_t status; // [490:476]
    otp_ctrl_hw2reg_err_code_mreg_t [8:0] err_code; // [475:449]
    otp_ctrl_hw2reg_direct_access_regwen_reg_t direct_access_regwen; // [448:448]
    otp_ctrl_hw2reg_direct_access_rdata_mreg_t [1:0] direct_access_rdata; // [447:384]
    otp_ctrl_hw2reg_creator_sw_cfg_digest_mreg_t [1:0] creator_sw_cfg_digest; // [383:320]
    otp_ctrl_hw2reg_owner_sw_cfg_digest_mreg_t [1:0] owner_sw_cfg_digest; // [319:256]
    otp_ctrl_hw2reg_hw_cfg_digest_mreg_t [1:0] hw_cfg_digest; // [255:192]
    otp_ctrl_hw2reg_secret0_digest_mreg_t [1:0] secret0_digest; // [191:128]
    otp_ctrl_hw2reg_secret1_digest_mreg_t [1:0] secret1_digest; // [127:64]
    otp_ctrl_hw2reg_secret2_digest_mreg_t [1:0] secret2_digest; // [63:0]
  } otp_ctrl_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] OTP_CTRL_INTR_STATE_OFFSET = 14'h 0;
  parameter logic [BlockAw-1:0] OTP_CTRL_INTR_ENABLE_OFFSET = 14'h 4;
  parameter logic [BlockAw-1:0] OTP_CTRL_INTR_TEST_OFFSET = 14'h 8;
  parameter logic [BlockAw-1:0] OTP_CTRL_ALERT_TEST_OFFSET = 14'h c;
  parameter logic [BlockAw-1:0] OTP_CTRL_STATUS_OFFSET = 14'h 10;
  parameter logic [BlockAw-1:0] OTP_CTRL_ERR_CODE_OFFSET = 14'h 14;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_REGWEN_OFFSET = 14'h 18;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_CMD_OFFSET = 14'h 1c;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_ADDRESS_OFFSET = 14'h 20;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_WDATA_0_OFFSET = 14'h 24;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_WDATA_1_OFFSET = 14'h 28;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_RDATA_0_OFFSET = 14'h 2c;
  parameter logic [BlockAw-1:0] OTP_CTRL_DIRECT_ACCESS_RDATA_1_OFFSET = 14'h 30;
  parameter logic [BlockAw-1:0] OTP_CTRL_CHECK_TRIGGER_REGWEN_OFFSET = 14'h 34;
  parameter logic [BlockAw-1:0] OTP_CTRL_CHECK_TRIGGER_OFFSET = 14'h 38;
  parameter logic [BlockAw-1:0] OTP_CTRL_CHECK_REGWEN_OFFSET = 14'h 3c;
  parameter logic [BlockAw-1:0] OTP_CTRL_CHECK_TIMEOUT_OFFSET = 14'h 40;
  parameter logic [BlockAw-1:0] OTP_CTRL_INTEGRITY_CHECK_PERIOD_OFFSET = 14'h 44;
  parameter logic [BlockAw-1:0] OTP_CTRL_CONSISTENCY_CHECK_PERIOD_OFFSET = 14'h 48;
  parameter logic [BlockAw-1:0] OTP_CTRL_CREATOR_SW_CFG_READ_LOCK_OFFSET = 14'h 4c;
  parameter logic [BlockAw-1:0] OTP_CTRL_OWNER_SW_CFG_READ_LOCK_OFFSET = 14'h 50;
  parameter logic [BlockAw-1:0] OTP_CTRL_CREATOR_SW_CFG_DIGEST_0_OFFSET = 14'h 54;
  parameter logic [BlockAw-1:0] OTP_CTRL_CREATOR_SW_CFG_DIGEST_1_OFFSET = 14'h 58;
  parameter logic [BlockAw-1:0] OTP_CTRL_OWNER_SW_CFG_DIGEST_0_OFFSET = 14'h 5c;
  parameter logic [BlockAw-1:0] OTP_CTRL_OWNER_SW_CFG_DIGEST_1_OFFSET = 14'h 60;
  parameter logic [BlockAw-1:0] OTP_CTRL_HW_CFG_DIGEST_0_OFFSET = 14'h 64;
  parameter logic [BlockAw-1:0] OTP_CTRL_HW_CFG_DIGEST_1_OFFSET = 14'h 68;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET0_DIGEST_0_OFFSET = 14'h 6c;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET0_DIGEST_1_OFFSET = 14'h 70;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET1_DIGEST_0_OFFSET = 14'h 74;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET1_DIGEST_1_OFFSET = 14'h 78;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET2_DIGEST_0_OFFSET = 14'h 7c;
  parameter logic [BlockAw-1:0] OTP_CTRL_SECRET2_DIGEST_1_OFFSET = 14'h 80;

  // Window parameter
  parameter logic [BlockAw-1:0] OTP_CTRL_SW_CFG_WINDOW_OFFSET = 14'h 1000;
  parameter logic [BlockAw-1:0] OTP_CTRL_SW_CFG_WINDOW_SIZE   = 14'h 800;
  parameter logic [BlockAw-1:0] OTP_CTRL_TEST_ACCESS_OFFSET = 14'h 2000;
  parameter logic [BlockAw-1:0] OTP_CTRL_TEST_ACCESS_SIZE   = 14'h 40;

  // Register Index
  typedef enum int {
    OTP_CTRL_INTR_STATE,
    OTP_CTRL_INTR_ENABLE,
    OTP_CTRL_INTR_TEST,
    OTP_CTRL_ALERT_TEST,
    OTP_CTRL_STATUS,
    OTP_CTRL_ERR_CODE,
    OTP_CTRL_DIRECT_ACCESS_REGWEN,
    OTP_CTRL_DIRECT_ACCESS_CMD,
    OTP_CTRL_DIRECT_ACCESS_ADDRESS,
    OTP_CTRL_DIRECT_ACCESS_WDATA_0,
    OTP_CTRL_DIRECT_ACCESS_WDATA_1,
    OTP_CTRL_DIRECT_ACCESS_RDATA_0,
    OTP_CTRL_DIRECT_ACCESS_RDATA_1,
    OTP_CTRL_CHECK_TRIGGER_REGWEN,
    OTP_CTRL_CHECK_TRIGGER,
    OTP_CTRL_CHECK_REGWEN,
    OTP_CTRL_CHECK_TIMEOUT,
    OTP_CTRL_INTEGRITY_CHECK_PERIOD,
    OTP_CTRL_CONSISTENCY_CHECK_PERIOD,
    OTP_CTRL_CREATOR_SW_CFG_READ_LOCK,
    OTP_CTRL_OWNER_SW_CFG_READ_LOCK,
    OTP_CTRL_CREATOR_SW_CFG_DIGEST_0,
    OTP_CTRL_CREATOR_SW_CFG_DIGEST_1,
    OTP_CTRL_OWNER_SW_CFG_DIGEST_0,
    OTP_CTRL_OWNER_SW_CFG_DIGEST_1,
    OTP_CTRL_HW_CFG_DIGEST_0,
    OTP_CTRL_HW_CFG_DIGEST_1,
    OTP_CTRL_SECRET0_DIGEST_0,
    OTP_CTRL_SECRET0_DIGEST_1,
    OTP_CTRL_SECRET1_DIGEST_0,
    OTP_CTRL_SECRET1_DIGEST_1,
    OTP_CTRL_SECRET2_DIGEST_0,
    OTP_CTRL_SECRET2_DIGEST_1
  } otp_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] OTP_CTRL_PERMIT [33] = '{
    4'b 0001, // index[ 0] OTP_CTRL_INTR_STATE
    4'b 0001, // index[ 1] OTP_CTRL_INTR_ENABLE
    4'b 0001, // index[ 2] OTP_CTRL_INTR_TEST
    4'b 0001, // index[ 3] OTP_CTRL_ALERT_TEST
    4'b 0011, // index[ 4] OTP_CTRL_STATUS
    4'b 1111, // index[ 5] OTP_CTRL_ERR_CODE
    4'b 0001, // index[ 6] OTP_CTRL_DIRECT_ACCESS_REGWEN
    4'b 0001, // index[ 7] OTP_CTRL_DIRECT_ACCESS_CMD
    4'b 0011, // index[ 8] OTP_CTRL_DIRECT_ACCESS_ADDRESS
    4'b 1111, // index[ 9] OTP_CTRL_DIRECT_ACCESS_WDATA_0
    4'b 1111, // index[10] OTP_CTRL_DIRECT_ACCESS_WDATA_1
    4'b 1111, // index[11] OTP_CTRL_DIRECT_ACCESS_RDATA_0
    4'b 1111, // index[12] OTP_CTRL_DIRECT_ACCESS_RDATA_1
    4'b 0001, // index[13] OTP_CTRL_CHECK_TRIGGER_REGWEN
    4'b 0001, // index[14] OTP_CTRL_CHECK_TRIGGER
    4'b 0001, // index[15] OTP_CTRL_CHECK_REGWEN
    4'b 1111, // index[16] OTP_CTRL_CHECK_TIMEOUT
    4'b 1111, // index[17] OTP_CTRL_INTEGRITY_CHECK_PERIOD
    4'b 1111, // index[18] OTP_CTRL_CONSISTENCY_CHECK_PERIOD
    4'b 0001, // index[19] OTP_CTRL_CREATOR_SW_CFG_READ_LOCK
    4'b 0001, // index[20] OTP_CTRL_OWNER_SW_CFG_READ_LOCK
    4'b 1111, // index[21] OTP_CTRL_CREATOR_SW_CFG_DIGEST_0
    4'b 1111, // index[22] OTP_CTRL_CREATOR_SW_CFG_DIGEST_1
    4'b 1111, // index[23] OTP_CTRL_OWNER_SW_CFG_DIGEST_0
    4'b 1111, // index[24] OTP_CTRL_OWNER_SW_CFG_DIGEST_1
    4'b 1111, // index[25] OTP_CTRL_HW_CFG_DIGEST_0
    4'b 1111, // index[26] OTP_CTRL_HW_CFG_DIGEST_1
    4'b 1111, // index[27] OTP_CTRL_SECRET0_DIGEST_0
    4'b 1111, // index[28] OTP_CTRL_SECRET0_DIGEST_1
    4'b 1111, // index[29] OTP_CTRL_SECRET1_DIGEST_0
    4'b 1111, // index[30] OTP_CTRL_SECRET1_DIGEST_1
    4'b 1111, // index[31] OTP_CTRL_SECRET2_DIGEST_0
    4'b 1111  // index[32] OTP_CTRL_SECRET2_DIGEST_1
  };
endpackage

