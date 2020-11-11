// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package lc_ctrl_reg_pkg;

  // Param list
  parameter int NumTokenWords = 4;
  parameter int NumLcStateBits = 4;
  parameter int NumLcCntBits = 5;
  parameter int NumAlerts = 2;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } lc_programming_failure;
    struct packed {
      logic        q;
      logic        qe;
    } lc_state_failure;
  } lc_ctrl_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } ready;
    struct packed {
      logic        q;
    } transition_successful;
    struct packed {
      logic        q;
    } transition_error;
    struct packed {
      logic        q;
    } token_error;
    struct packed {
      logic        q;
    } otp_error;
    struct packed {
      logic        q;
    } state_error;
  } lc_ctrl_reg2hw_status_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } lc_ctrl_reg2hw_claim_transition_if_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_cmd_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_token_mreg_t;

  typedef struct packed {
    logic [3:0]  q;
    logic        qe;
  } lc_ctrl_reg2hw_transition_target_reg_t;

  typedef struct packed {
    logic [3:0]  q;
  } lc_ctrl_reg2hw_lc_state_reg_t;

  typedef struct packed {
    logic [4:0]  q;
  } lc_ctrl_reg2hw_lc_transition_cnt_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } lc_ctrl_reg2hw_lc_id_state_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
    } ready;
    struct packed {
      logic        d;
    } transition_successful;
    struct packed {
      logic        d;
    } transition_error;
    struct packed {
      logic        d;
    } token_error;
    struct packed {
      logic        d;
    } otp_error;
    struct packed {
      logic        d;
    } state_error;
  } lc_ctrl_hw2reg_status_reg_t;

  typedef struct packed {
    logic        d;
  } lc_ctrl_hw2reg_claim_transition_if_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } lc_ctrl_hw2reg_transition_regwen_reg_t;

  typedef struct packed {
    logic        d;
  } lc_ctrl_hw2reg_transition_cmd_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } lc_ctrl_hw2reg_transition_token_mreg_t;

  typedef struct packed {
    logic [3:0]  d;
  } lc_ctrl_hw2reg_transition_target_reg_t;

  typedef struct packed {
    logic [3:0]  d;
  } lc_ctrl_hw2reg_lc_state_reg_t;

  typedef struct packed {
    logic [4:0]  d;
  } lc_ctrl_hw2reg_lc_transition_cnt_reg_t;

  typedef struct packed {
    logic [1:0]  d;
  } lc_ctrl_hw2reg_lc_id_state_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    lc_ctrl_reg2hw_alert_test_reg_t alert_test; // [161:158]
    lc_ctrl_reg2hw_status_reg_t status; // [157:152]
    lc_ctrl_reg2hw_claim_transition_if_reg_t claim_transition_if; // [151:150]
    lc_ctrl_reg2hw_transition_cmd_reg_t transition_cmd; // [149:148]
    lc_ctrl_reg2hw_transition_token_mreg_t [3:0] transition_token; // [147:16]
    lc_ctrl_reg2hw_transition_target_reg_t transition_target; // [15:11]
    lc_ctrl_reg2hw_lc_state_reg_t lc_state; // [10:7]
    lc_ctrl_reg2hw_lc_transition_cnt_reg_t lc_transition_cnt; // [6:2]
    lc_ctrl_reg2hw_lc_id_state_reg_t lc_id_state; // [1:0]
  } lc_ctrl_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    lc_ctrl_hw2reg_status_reg_t status; // [152:147]
    lc_ctrl_hw2reg_claim_transition_if_reg_t claim_transition_if; // [146:145]
    lc_ctrl_hw2reg_transition_regwen_reg_t transition_regwen; // [144:145]
    lc_ctrl_hw2reg_transition_cmd_reg_t transition_cmd; // [144:143]
    lc_ctrl_hw2reg_transition_token_mreg_t [3:0] transition_token; // [142:15]
    lc_ctrl_hw2reg_transition_target_reg_t transition_target; // [14:10]
    lc_ctrl_hw2reg_lc_state_reg_t lc_state; // [9:6]
    lc_ctrl_hw2reg_lc_transition_cnt_reg_t lc_transition_cnt; // [5:1]
    lc_ctrl_hw2reg_lc_id_state_reg_t lc_id_state; // [0:-1]
  } lc_ctrl_hw2reg_t;

  // Register Address
  parameter logic [5:0] LC_CTRL_ALERT_TEST_OFFSET = 6'h 0;
  parameter logic [5:0] LC_CTRL_STATUS_OFFSET = 6'h 4;
  parameter logic [5:0] LC_CTRL_CLAIM_TRANSITION_IF_OFFSET = 6'h 8;
  parameter logic [5:0] LC_CTRL_TRANSITION_REGWEN_OFFSET = 6'h c;
  parameter logic [5:0] LC_CTRL_TRANSITION_CMD_OFFSET = 6'h 10;
  parameter logic [5:0] LC_CTRL_TRANSITION_TOKEN_0_OFFSET = 6'h 14;
  parameter logic [5:0] LC_CTRL_TRANSITION_TOKEN_1_OFFSET = 6'h 18;
  parameter logic [5:0] LC_CTRL_TRANSITION_TOKEN_2_OFFSET = 6'h 1c;
  parameter logic [5:0] LC_CTRL_TRANSITION_TOKEN_3_OFFSET = 6'h 20;
  parameter logic [5:0] LC_CTRL_TRANSITION_TARGET_OFFSET = 6'h 24;
  parameter logic [5:0] LC_CTRL_LC_STATE_OFFSET = 6'h 28;
  parameter logic [5:0] LC_CTRL_LC_TRANSITION_CNT_OFFSET = 6'h 2c;
  parameter logic [5:0] LC_CTRL_LC_ID_STATE_OFFSET = 6'h 30;


  // Register Index
  typedef enum int {
    LC_CTRL_ALERT_TEST,
    LC_CTRL_STATUS,
    LC_CTRL_CLAIM_TRANSITION_IF,
    LC_CTRL_TRANSITION_REGWEN,
    LC_CTRL_TRANSITION_CMD,
    LC_CTRL_TRANSITION_TOKEN_0,
    LC_CTRL_TRANSITION_TOKEN_1,
    LC_CTRL_TRANSITION_TOKEN_2,
    LC_CTRL_TRANSITION_TOKEN_3,
    LC_CTRL_TRANSITION_TARGET,
    LC_CTRL_LC_STATE,
    LC_CTRL_LC_TRANSITION_CNT,
    LC_CTRL_LC_ID_STATE
  } lc_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] LC_CTRL_PERMIT [13] = '{
    4'b 0001, // index[ 0] LC_CTRL_ALERT_TEST
    4'b 0001, // index[ 1] LC_CTRL_STATUS
    4'b 0001, // index[ 2] LC_CTRL_CLAIM_TRANSITION_IF
    4'b 0001, // index[ 3] LC_CTRL_TRANSITION_REGWEN
    4'b 0001, // index[ 4] LC_CTRL_TRANSITION_CMD
    4'b 1111, // index[ 5] LC_CTRL_TRANSITION_TOKEN_0
    4'b 1111, // index[ 6] LC_CTRL_TRANSITION_TOKEN_1
    4'b 1111, // index[ 7] LC_CTRL_TRANSITION_TOKEN_2
    4'b 1111, // index[ 8] LC_CTRL_TRANSITION_TOKEN_3
    4'b 0001, // index[ 9] LC_CTRL_TRANSITION_TARGET
    4'b 0001, // index[10] LC_CTRL_LC_STATE
    4'b 0001, // index[11] LC_CTRL_LC_TRANSITION_CNT
    4'b 0001  // index[12] LC_CTRL_LC_ID_STATE
  };
endpackage

