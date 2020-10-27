// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package aes_reg_pkg;

  // Param list
  parameter int NumRegsKey = 8;
  parameter int NumRegsIv = 4;
  parameter int NumRegsData = 4;
  parameter int NumAlerts = 2;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } ctrl_err_update;
    struct packed {
      logic        q;
      logic        qe;
    } ctrl_err_storage;
  } aes_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_key_share0_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_key_share1_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_iv_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } aes_reg2hw_data_in_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } aes_reg2hw_data_out_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
      logic        re;
    } operation;
    struct packed {
      logic [5:0]  q;
      logic        qe;
      logic        re;
    } mode;
    struct packed {
      logic [2:0]  q;
      logic        qe;
      logic        re;
    } key_len;
    struct packed {
      logic        q;
      logic        qe;
      logic        re;
    } manual_operation;
    struct packed {
      logic        q;
      logic        qe;
      logic        re;
    } force_zero_masks;
  } aes_reg2hw_ctrl_shadowed_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } start;
    struct packed {
      logic        q;
    } key_clear;
    struct packed {
      logic        q;
    } iv_clear;
    struct packed {
      logic        q;
    } data_in_clear;
    struct packed {
      logic        q;
    } data_out_clear;
    struct packed {
      logic        q;
    } prng_reseed;
  } aes_reg2hw_trigger_reg_t;


  typedef struct packed {
    logic [31:0] d;
  } aes_hw2reg_key_share0_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } aes_hw2reg_key_share1_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } aes_hw2reg_iv_mreg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } aes_hw2reg_data_in_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } aes_hw2reg_data_out_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } operation;
    struct packed {
      logic [5:0]  d;
    } mode;
    struct packed {
      logic [2:0]  d;
    } key_len;
    struct packed {
      logic        d;
    } manual_operation;
    struct packed {
      logic        d;
    } force_zero_masks;
  } aes_hw2reg_ctrl_shadowed_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } start;
    struct packed {
      logic        d;
      logic        de;
    } key_clear;
    struct packed {
      logic        d;
      logic        de;
    } iv_clear;
    struct packed {
      logic        d;
      logic        de;
    } data_in_clear;
    struct packed {
      logic        d;
      logic        de;
    } data_out_clear;
    struct packed {
      logic        d;
      logic        de;
    } prng_reseed;
  } aes_hw2reg_trigger_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } idle;
    struct packed {
      logic        d;
      logic        de;
    } stall;
    struct packed {
      logic        d;
      logic        de;
    } output_valid;
    struct packed {
      logic        d;
      logic        de;
    } input_ready;
    struct packed {
      logic        d;
      logic        de;
    } ctrl_err_storage;
  } aes_hw2reg_status_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    aes_reg2hw_alert_test_reg_t alert_test; // [950:947]
    aes_reg2hw_key_share0_mreg_t [7:0] key_share0; // [946:683]
    aes_reg2hw_key_share1_mreg_t [7:0] key_share1; // [682:419]
    aes_reg2hw_iv_mreg_t [3:0] iv; // [418:287]
    aes_reg2hw_data_in_mreg_t [3:0] data_in; // [286:155]
    aes_reg2hw_data_out_mreg_t [3:0] data_out; // [154:23]
    aes_reg2hw_ctrl_shadowed_reg_t ctrl_shadowed; // [22:6]
    aes_reg2hw_trigger_reg_t trigger; // [5:0]
  } aes_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    aes_hw2reg_key_share0_mreg_t [7:0] key_share0; // [933:678]
    aes_hw2reg_key_share1_mreg_t [7:0] key_share1; // [677:422]
    aes_hw2reg_iv_mreg_t [3:0] iv; // [421:294]
    aes_hw2reg_data_in_mreg_t [3:0] data_in; // [293:162]
    aes_hw2reg_data_out_mreg_t [3:0] data_out; // [161:34]
    aes_hw2reg_ctrl_shadowed_reg_t ctrl_shadowed; // [33:17]
    aes_hw2reg_trigger_reg_t trigger; // [16:11]
    aes_hw2reg_status_reg_t status; // [10:11]
  } aes_hw2reg_t;

  // Register Address
  parameter logic [6:0] AES_ALERT_TEST_OFFSET = 7'h 0;
  parameter logic [6:0] AES_KEY_SHARE0_0_OFFSET = 7'h 4;
  parameter logic [6:0] AES_KEY_SHARE0_1_OFFSET = 7'h 8;
  parameter logic [6:0] AES_KEY_SHARE0_2_OFFSET = 7'h c;
  parameter logic [6:0] AES_KEY_SHARE0_3_OFFSET = 7'h 10;
  parameter logic [6:0] AES_KEY_SHARE0_4_OFFSET = 7'h 14;
  parameter logic [6:0] AES_KEY_SHARE0_5_OFFSET = 7'h 18;
  parameter logic [6:0] AES_KEY_SHARE0_6_OFFSET = 7'h 1c;
  parameter logic [6:0] AES_KEY_SHARE0_7_OFFSET = 7'h 20;
  parameter logic [6:0] AES_KEY_SHARE1_0_OFFSET = 7'h 24;
  parameter logic [6:0] AES_KEY_SHARE1_1_OFFSET = 7'h 28;
  parameter logic [6:0] AES_KEY_SHARE1_2_OFFSET = 7'h 2c;
  parameter logic [6:0] AES_KEY_SHARE1_3_OFFSET = 7'h 30;
  parameter logic [6:0] AES_KEY_SHARE1_4_OFFSET = 7'h 34;
  parameter logic [6:0] AES_KEY_SHARE1_5_OFFSET = 7'h 38;
  parameter logic [6:0] AES_KEY_SHARE1_6_OFFSET = 7'h 3c;
  parameter logic [6:0] AES_KEY_SHARE1_7_OFFSET = 7'h 40;
  parameter logic [6:0] AES_IV_0_OFFSET = 7'h 44;
  parameter logic [6:0] AES_IV_1_OFFSET = 7'h 48;
  parameter logic [6:0] AES_IV_2_OFFSET = 7'h 4c;
  parameter logic [6:0] AES_IV_3_OFFSET = 7'h 50;
  parameter logic [6:0] AES_DATA_IN_0_OFFSET = 7'h 54;
  parameter logic [6:0] AES_DATA_IN_1_OFFSET = 7'h 58;
  parameter logic [6:0] AES_DATA_IN_2_OFFSET = 7'h 5c;
  parameter logic [6:0] AES_DATA_IN_3_OFFSET = 7'h 60;
  parameter logic [6:0] AES_DATA_OUT_0_OFFSET = 7'h 64;
  parameter logic [6:0] AES_DATA_OUT_1_OFFSET = 7'h 68;
  parameter logic [6:0] AES_DATA_OUT_2_OFFSET = 7'h 6c;
  parameter logic [6:0] AES_DATA_OUT_3_OFFSET = 7'h 70;
  parameter logic [6:0] AES_CTRL_SHADOWED_OFFSET = 7'h 74;
  parameter logic [6:0] AES_TRIGGER_OFFSET = 7'h 78;
  parameter logic [6:0] AES_STATUS_OFFSET = 7'h 7c;


  // Register Index
  typedef enum int {
    AES_ALERT_TEST,
    AES_KEY_SHARE0_0,
    AES_KEY_SHARE0_1,
    AES_KEY_SHARE0_2,
    AES_KEY_SHARE0_3,
    AES_KEY_SHARE0_4,
    AES_KEY_SHARE0_5,
    AES_KEY_SHARE0_6,
    AES_KEY_SHARE0_7,
    AES_KEY_SHARE1_0,
    AES_KEY_SHARE1_1,
    AES_KEY_SHARE1_2,
    AES_KEY_SHARE1_3,
    AES_KEY_SHARE1_4,
    AES_KEY_SHARE1_5,
    AES_KEY_SHARE1_6,
    AES_KEY_SHARE1_7,
    AES_IV_0,
    AES_IV_1,
    AES_IV_2,
    AES_IV_3,
    AES_DATA_IN_0,
    AES_DATA_IN_1,
    AES_DATA_IN_2,
    AES_DATA_IN_3,
    AES_DATA_OUT_0,
    AES_DATA_OUT_1,
    AES_DATA_OUT_2,
    AES_DATA_OUT_3,
    AES_CTRL_SHADOWED,
    AES_TRIGGER,
    AES_STATUS
  } aes_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] AES_PERMIT [32] = '{
    4'b 0001, // index[ 0] AES_ALERT_TEST
    4'b 1111, // index[ 1] AES_KEY_SHARE0_0
    4'b 1111, // index[ 2] AES_KEY_SHARE0_1
    4'b 1111, // index[ 3] AES_KEY_SHARE0_2
    4'b 1111, // index[ 4] AES_KEY_SHARE0_3
    4'b 1111, // index[ 5] AES_KEY_SHARE0_4
    4'b 1111, // index[ 6] AES_KEY_SHARE0_5
    4'b 1111, // index[ 7] AES_KEY_SHARE0_6
    4'b 1111, // index[ 8] AES_KEY_SHARE0_7
    4'b 1111, // index[ 9] AES_KEY_SHARE1_0
    4'b 1111, // index[10] AES_KEY_SHARE1_1
    4'b 1111, // index[11] AES_KEY_SHARE1_2
    4'b 1111, // index[12] AES_KEY_SHARE1_3
    4'b 1111, // index[13] AES_KEY_SHARE1_4
    4'b 1111, // index[14] AES_KEY_SHARE1_5
    4'b 1111, // index[15] AES_KEY_SHARE1_6
    4'b 1111, // index[16] AES_KEY_SHARE1_7
    4'b 1111, // index[17] AES_IV_0
    4'b 1111, // index[18] AES_IV_1
    4'b 1111, // index[19] AES_IV_2
    4'b 1111, // index[20] AES_IV_3
    4'b 1111, // index[21] AES_DATA_IN_0
    4'b 1111, // index[22] AES_DATA_IN_1
    4'b 1111, // index[23] AES_DATA_IN_2
    4'b 1111, // index[24] AES_DATA_IN_3
    4'b 1111, // index[25] AES_DATA_OUT_0
    4'b 1111, // index[26] AES_DATA_OUT_1
    4'b 1111, // index[27] AES_DATA_OUT_2
    4'b 1111, // index[28] AES_DATA_OUT_3
    4'b 0011, // index[29] AES_CTRL_SHADOWED
    4'b 0001, // index[30] AES_TRIGGER
    4'b 0001  // index[31] AES_STATUS
  };
endpackage

