// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package lc_ctrl_reg_pkg;

  // Param list
  parameter int HwRevFieldWidth = 16;
  parameter int NumTokenWords = 4;
  parameter int CsrLcStateWidth = 30;
  parameter int CsrLcCountWidth = 5;
  parameter int CsrLcIdStateWidth = 32;
  parameter int CsrOtpTestCtrlWidth = 32;
  parameter int CsrOtpTestStatusWidth = 32;
  parameter int NumDeviceIdWords = 8;
  parameter int NumManufStateWords = 8;
  parameter int NumAlerts = 3;

  // Address widths within the block
  parameter int BlockAw = 8;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal_prog_error;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_state_error;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_bus_integ_error;
  } lc_ctrl_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } lc_ctrl_reg2hw_claim_transition_if_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_cmd_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_token_mreg_t;

  typedef struct packed {
    logic [29:0] q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_target_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } lc_ctrl_reg2hw_otp_vendor_test_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } initialized;
    struct packed {
      logic        d;
    } ready;
    struct packed {
      logic        d;
    } transition_successful;
    struct packed {
      logic        d;
    } transition_count_error;
    struct packed {
      logic        d;
    } transition_error;
    struct packed {
      logic        d;
    } token_error;
    struct packed {
      logic        d;
    } flash_rma_error;
    struct packed {
      logic        d;
    } otp_error;
    struct packed {
      logic        d;
    } state_error;
    struct packed {
      logic        d;
    } bus_integ_error;
    struct packed {
      logic        d;
    } otp_partition_error;
  } lc_ctrl_hw2reg_status_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } lc_ctrl_hw2reg_claim_transition_if_reg_t;

  typedef struct packed {
    logic        d;
  } lc_ctrl_hw2reg_transition_regwen_reg_t;

  typedef struct packed {
    logic        d;
  } lc_ctrl_hw2reg_transition_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_transition_token_mreg_t;

  typedef struct packed {
    logic [29:0] d;
  } lc_ctrl_hw2reg_transition_target_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_otp_vendor_test_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_otp_vendor_test_status_reg_t;

  typedef struct packed {
    logic [29:0] d;
  } lc_ctrl_hw2reg_lc_state_reg_t;

  typedef struct packed {
    logic [4:0]  d;
  } lc_ctrl_hw2reg_lc_transition_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_lc_id_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } chip_rev;
    struct packed {
      logic [15:0] d;
    } chip_gen;
  } lc_ctrl_hw2reg_hw_rev_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_device_id_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_manuf_state_mreg_t;

  // Register -> HW type
  typedef struct packed {
    lc_ctrl_reg2hw_alert_test_reg_t alert_test; // [214:209]
    lc_ctrl_reg2hw_claim_transition_if_reg_t claim_transition_if; // [208:200]
    lc_ctrl_reg2hw_transition_cmd_reg_t transition_cmd; // [199:198]
    lc_ctrl_reg2hw_transition_ctrl_reg_t transition_ctrl; // [197:196]
    lc_ctrl_reg2hw_transition_token_mreg_t [3:0] transition_token; // [195:64]
    lc_ctrl_reg2hw_transition_target_reg_t transition_target; // [63:33]
    lc_ctrl_reg2hw_otp_vendor_test_ctrl_reg_t otp_vendor_test_ctrl; // [32:0]
  } lc_ctrl_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    lc_ctrl_hw2reg_status_reg_t status; // [853:843]
    lc_ctrl_hw2reg_claim_transition_if_reg_t claim_transition_if; // [842:835]
    lc_ctrl_hw2reg_transition_regwen_reg_t transition_regwen; // [834:834]
    lc_ctrl_hw2reg_transition_ctrl_reg_t transition_ctrl; // [833:833]
    lc_ctrl_hw2reg_transition_token_mreg_t [3:0] transition_token; // [832:705]
    lc_ctrl_hw2reg_transition_target_reg_t transition_target; // [704:675]
    lc_ctrl_hw2reg_otp_vendor_test_ctrl_reg_t otp_vendor_test_ctrl; // [674:643]
    lc_ctrl_hw2reg_otp_vendor_test_status_reg_t otp_vendor_test_status; // [642:611]
    lc_ctrl_hw2reg_lc_state_reg_t lc_state; // [610:581]
    lc_ctrl_hw2reg_lc_transition_cnt_reg_t lc_transition_cnt; // [580:576]
    lc_ctrl_hw2reg_lc_id_state_reg_t lc_id_state; // [575:544]
    lc_ctrl_hw2reg_hw_rev_reg_t hw_rev; // [543:512]
    lc_ctrl_hw2reg_device_id_mreg_t [7:0] device_id; // [511:256]
    lc_ctrl_hw2reg_manuf_state_mreg_t [7:0] manuf_state; // [255:0]
  } lc_ctrl_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] LC_CTRL_ALERT_TEST_OFFSET = 8'h 0;
  parameter logic [BlockAw-1:0] LC_CTRL_STATUS_OFFSET = 8'h 4;
  parameter logic [BlockAw-1:0] LC_CTRL_CLAIM_TRANSITION_IF_OFFSET = 8'h 8;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_REGWEN_OFFSET = 8'h c;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_CMD_OFFSET = 8'h 10;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_CTRL_OFFSET = 8'h 14;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_TOKEN_0_OFFSET = 8'h 18;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_TOKEN_1_OFFSET = 8'h 1c;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_TOKEN_2_OFFSET = 8'h 20;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_TOKEN_3_OFFSET = 8'h 24;
  parameter logic [BlockAw-1:0] LC_CTRL_TRANSITION_TARGET_OFFSET = 8'h 28;
  parameter logic [BlockAw-1:0] LC_CTRL_OTP_VENDOR_TEST_CTRL_OFFSET = 8'h 2c;
  parameter logic [BlockAw-1:0] LC_CTRL_OTP_VENDOR_TEST_STATUS_OFFSET = 8'h 30;
  parameter logic [BlockAw-1:0] LC_CTRL_LC_STATE_OFFSET = 8'h 34;
  parameter logic [BlockAw-1:0] LC_CTRL_LC_TRANSITION_CNT_OFFSET = 8'h 38;
  parameter logic [BlockAw-1:0] LC_CTRL_LC_ID_STATE_OFFSET = 8'h 3c;
  parameter logic [BlockAw-1:0] LC_CTRL_HW_REV_OFFSET = 8'h 40;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_0_OFFSET = 8'h 44;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_1_OFFSET = 8'h 48;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_2_OFFSET = 8'h 4c;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_3_OFFSET = 8'h 50;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_4_OFFSET = 8'h 54;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_5_OFFSET = 8'h 58;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_6_OFFSET = 8'h 5c;
  parameter logic [BlockAw-1:0] LC_CTRL_DEVICE_ID_7_OFFSET = 8'h 60;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_0_OFFSET = 8'h 64;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_1_OFFSET = 8'h 68;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_2_OFFSET = 8'h 6c;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_3_OFFSET = 8'h 70;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_4_OFFSET = 8'h 74;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_5_OFFSET = 8'h 78;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_6_OFFSET = 8'h 7c;
  parameter logic [BlockAw-1:0] LC_CTRL_MANUF_STATE_7_OFFSET = 8'h 80;

  // Reset values for hwext registers and their fields
  parameter logic [2:0] LC_CTRL_ALERT_TEST_RESVAL = 3'h 0;
  parameter logic [0:0] LC_CTRL_ALERT_TEST_FATAL_PROG_ERROR_RESVAL = 1'h 0;
  parameter logic [0:0] LC_CTRL_ALERT_TEST_FATAL_STATE_ERROR_RESVAL = 1'h 0;
  parameter logic [0:0] LC_CTRL_ALERT_TEST_FATAL_BUS_INTEG_ERROR_RESVAL = 1'h 0;
  parameter logic [10:0] LC_CTRL_STATUS_RESVAL = 11'h 0;
  parameter logic [7:0] LC_CTRL_CLAIM_TRANSITION_IF_RESVAL = 8'h 69;
  parameter logic [7:0] LC_CTRL_CLAIM_TRANSITION_IF_MUTEX_RESVAL = 8'h 69;
  parameter logic [0:0] LC_CTRL_TRANSITION_REGWEN_RESVAL = 1'h 0;
  parameter logic [0:0] LC_CTRL_TRANSITION_REGWEN_TRANSITION_REGWEN_RESVAL = 1'h 0;
  parameter logic [0:0] LC_CTRL_TRANSITION_CMD_RESVAL = 1'h 0;
  parameter logic [0:0] LC_CTRL_TRANSITION_CTRL_RESVAL = 1'h 0;
  parameter logic [31:0] LC_CTRL_TRANSITION_TOKEN_0_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_TRANSITION_TOKEN_1_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_TRANSITION_TOKEN_2_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_TRANSITION_TOKEN_3_RESVAL = 32'h 0;
  parameter logic [29:0] LC_CTRL_TRANSITION_TARGET_RESVAL = 30'h 0;
  parameter logic [31:0] LC_CTRL_OTP_VENDOR_TEST_CTRL_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_OTP_VENDOR_TEST_STATUS_RESVAL = 32'h 0;
  parameter logic [29:0] LC_CTRL_LC_STATE_RESVAL = 30'h 0;
  parameter logic [4:0] LC_CTRL_LC_TRANSITION_CNT_RESVAL = 5'h 0;
  parameter logic [31:0] LC_CTRL_LC_ID_STATE_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_HW_REV_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_0_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_1_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_2_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_3_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_4_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_5_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_6_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_DEVICE_ID_7_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_0_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_1_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_2_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_3_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_4_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_5_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_6_RESVAL = 32'h 0;
  parameter logic [31:0] LC_CTRL_MANUF_STATE_7_RESVAL = 32'h 0;

  // Register index
  typedef enum int {
    LC_CTRL_ALERT_TEST,
    LC_CTRL_STATUS,
    LC_CTRL_CLAIM_TRANSITION_IF,
    LC_CTRL_TRANSITION_REGWEN,
    LC_CTRL_TRANSITION_CMD,
    LC_CTRL_TRANSITION_CTRL,
    LC_CTRL_TRANSITION_TOKEN_0,
    LC_CTRL_TRANSITION_TOKEN_1,
    LC_CTRL_TRANSITION_TOKEN_2,
    LC_CTRL_TRANSITION_TOKEN_3,
    LC_CTRL_TRANSITION_TARGET,
    LC_CTRL_OTP_VENDOR_TEST_CTRL,
    LC_CTRL_OTP_VENDOR_TEST_STATUS,
    LC_CTRL_LC_STATE,
    LC_CTRL_LC_TRANSITION_CNT,
    LC_CTRL_LC_ID_STATE,
    LC_CTRL_HW_REV,
    LC_CTRL_DEVICE_ID_0,
    LC_CTRL_DEVICE_ID_1,
    LC_CTRL_DEVICE_ID_2,
    LC_CTRL_DEVICE_ID_3,
    LC_CTRL_DEVICE_ID_4,
    LC_CTRL_DEVICE_ID_5,
    LC_CTRL_DEVICE_ID_6,
    LC_CTRL_DEVICE_ID_7,
    LC_CTRL_MANUF_STATE_0,
    LC_CTRL_MANUF_STATE_1,
    LC_CTRL_MANUF_STATE_2,
    LC_CTRL_MANUF_STATE_3,
    LC_CTRL_MANUF_STATE_4,
    LC_CTRL_MANUF_STATE_5,
    LC_CTRL_MANUF_STATE_6,
    LC_CTRL_MANUF_STATE_7
  } lc_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] LC_CTRL_PERMIT [33] = '{
    4'b 0001, // index[ 0] LC_CTRL_ALERT_TEST
    4'b 0011, // index[ 1] LC_CTRL_STATUS
    4'b 0001, // index[ 2] LC_CTRL_CLAIM_TRANSITION_IF
    4'b 0001, // index[ 3] LC_CTRL_TRANSITION_REGWEN
    4'b 0001, // index[ 4] LC_CTRL_TRANSITION_CMD
    4'b 0001, // index[ 5] LC_CTRL_TRANSITION_CTRL
    4'b 1111, // index[ 6] LC_CTRL_TRANSITION_TOKEN_0
    4'b 1111, // index[ 7] LC_CTRL_TRANSITION_TOKEN_1
    4'b 1111, // index[ 8] LC_CTRL_TRANSITION_TOKEN_2
    4'b 1111, // index[ 9] LC_CTRL_TRANSITION_TOKEN_3
    4'b 1111, // index[10] LC_CTRL_TRANSITION_TARGET
    4'b 1111, // index[11] LC_CTRL_OTP_VENDOR_TEST_CTRL
    4'b 1111, // index[12] LC_CTRL_OTP_VENDOR_TEST_STATUS
    4'b 1111, // index[13] LC_CTRL_LC_STATE
    4'b 0001, // index[14] LC_CTRL_LC_TRANSITION_CNT
    4'b 1111, // index[15] LC_CTRL_LC_ID_STATE
    4'b 1111, // index[16] LC_CTRL_HW_REV
    4'b 1111, // index[17] LC_CTRL_DEVICE_ID_0
    4'b 1111, // index[18] LC_CTRL_DEVICE_ID_1
    4'b 1111, // index[19] LC_CTRL_DEVICE_ID_2
    4'b 1111, // index[20] LC_CTRL_DEVICE_ID_3
    4'b 1111, // index[21] LC_CTRL_DEVICE_ID_4
    4'b 1111, // index[22] LC_CTRL_DEVICE_ID_5
    4'b 1111, // index[23] LC_CTRL_DEVICE_ID_6
    4'b 1111, // index[24] LC_CTRL_DEVICE_ID_7
    4'b 1111, // index[25] LC_CTRL_MANUF_STATE_0
    4'b 1111, // index[26] LC_CTRL_MANUF_STATE_1
    4'b 1111, // index[27] LC_CTRL_MANUF_STATE_2
    4'b 1111, // index[28] LC_CTRL_MANUF_STATE_3
    4'b 1111, // index[29] LC_CTRL_MANUF_STATE_4
    4'b 1111, // index[30] LC_CTRL_MANUF_STATE_5
    4'b 1111, // index[31] LC_CTRL_MANUF_STATE_6
    4'b 1111  // index[32] LC_CTRL_MANUF_STATE_7
  };

endpackage
