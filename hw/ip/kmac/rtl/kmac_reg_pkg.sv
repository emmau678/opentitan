// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package kmac_reg_pkg;

  // Param list
  parameter int NumWordsKey = 16;
  parameter int NumWordsPrefix = 11;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } kmac_done;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } kmac_err;
  } kmac_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } kmac_done;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } kmac_err;
  } kmac_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } kmac_done;
    struct packed {
      logic        q;
      logic        qe;
    } fifo_empty;
    struct packed {
      logic        q;
      logic        qe;
    } kmac_err;
  } kmac_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } kmac_en;
    struct packed {
      logic [2:0]  q;
    } kstrength;
    struct packed {
      logic [1:0]  q;
    } mode;
    struct packed {
      logic        q;
    } msg_endianness;
    struct packed {
      logic        q;
    } state_endianness;
    struct packed {
      logic        q;
    } sideload;
  } kmac_reg2hw_cfg_reg_t;

  typedef struct packed {
    logic [3:0]  q;
    logic        qe;
  } kmac_reg2hw_cmd_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_key_share0_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_key_share1_mreg_t;

  typedef struct packed {
    logic [2:0]  q;
  } kmac_reg2hw_key_len_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } kmac_reg2hw_prefix_mreg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } kmac_done;
    struct packed {
      logic        d;
      logic        de;
    } fifo_empty;
    struct packed {
      logic        d;
      logic        de;
    } kmac_err;
  } kmac_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } sha3_idle;
    struct packed {
      logic        d;
    } sha3_absorb;
    struct packed {
      logic        d;
    } sha3_squeeze;
    struct packed {
      logic [4:0]  d;
    } fifo_depth;
    struct packed {
      logic        d;
    } fifo_empty;
    struct packed {
      logic        d;
    } fifo_full;
  } kmac_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } kmac_hw2reg_err_code_reg_t;

  typedef struct packed {
    logic        d;
  } kmac_hw2reg_cfg_regwen_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    kmac_reg2hw_intr_state_reg_t intr_state; // [1447:1445]
    kmac_reg2hw_intr_enable_reg_t intr_enable; // [1444:1442]
    kmac_reg2hw_intr_test_reg_t intr_test; // [1441:1436]
    kmac_reg2hw_cfg_reg_t cfg; // [1435:1427]
    kmac_reg2hw_cmd_reg_t cmd; // [1426:1422]
    kmac_reg2hw_key_share0_mreg_t [15:0] key_share0; // [1421:894]
    kmac_reg2hw_key_share1_mreg_t [15:0] key_share1; // [893:366]
    kmac_reg2hw_key_len_reg_t key_len; // [365:363]
    kmac_reg2hw_prefix_mreg_t [10:0] prefix; // [362:0]
  } kmac_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    kmac_hw2reg_intr_state_reg_t intr_state; // [49:47]
    kmac_hw2reg_status_reg_t status; // [46:47]
    kmac_hw2reg_err_code_reg_t err_code; // [46:47]
    kmac_hw2reg_cfg_regwen_reg_t cfg_regwen; // [46:47]
  } kmac_hw2reg_t;

  // Register Address
  parameter logic [11:0] KMAC_INTR_STATE_OFFSET = 12'h 0;
  parameter logic [11:0] KMAC_INTR_ENABLE_OFFSET = 12'h 4;
  parameter logic [11:0] KMAC_INTR_TEST_OFFSET = 12'h 8;
  parameter logic [11:0] KMAC_CFG_OFFSET = 12'h c;
  parameter logic [11:0] KMAC_CMD_OFFSET = 12'h 10;
  parameter logic [11:0] KMAC_STATUS_OFFSET = 12'h 14;
  parameter logic [11:0] KMAC_KEY_SHARE0_0_OFFSET = 12'h 18;
  parameter logic [11:0] KMAC_KEY_SHARE0_1_OFFSET = 12'h 1c;
  parameter logic [11:0] KMAC_KEY_SHARE0_2_OFFSET = 12'h 20;
  parameter logic [11:0] KMAC_KEY_SHARE0_3_OFFSET = 12'h 24;
  parameter logic [11:0] KMAC_KEY_SHARE0_4_OFFSET = 12'h 28;
  parameter logic [11:0] KMAC_KEY_SHARE0_5_OFFSET = 12'h 2c;
  parameter logic [11:0] KMAC_KEY_SHARE0_6_OFFSET = 12'h 30;
  parameter logic [11:0] KMAC_KEY_SHARE0_7_OFFSET = 12'h 34;
  parameter logic [11:0] KMAC_KEY_SHARE0_8_OFFSET = 12'h 38;
  parameter logic [11:0] KMAC_KEY_SHARE0_9_OFFSET = 12'h 3c;
  parameter logic [11:0] KMAC_KEY_SHARE0_10_OFFSET = 12'h 40;
  parameter logic [11:0] KMAC_KEY_SHARE0_11_OFFSET = 12'h 44;
  parameter logic [11:0] KMAC_KEY_SHARE0_12_OFFSET = 12'h 48;
  parameter logic [11:0] KMAC_KEY_SHARE0_13_OFFSET = 12'h 4c;
  parameter logic [11:0] KMAC_KEY_SHARE0_14_OFFSET = 12'h 50;
  parameter logic [11:0] KMAC_KEY_SHARE0_15_OFFSET = 12'h 54;
  parameter logic [11:0] KMAC_KEY_SHARE1_0_OFFSET = 12'h 58;
  parameter logic [11:0] KMAC_KEY_SHARE1_1_OFFSET = 12'h 5c;
  parameter logic [11:0] KMAC_KEY_SHARE1_2_OFFSET = 12'h 60;
  parameter logic [11:0] KMAC_KEY_SHARE1_3_OFFSET = 12'h 64;
  parameter logic [11:0] KMAC_KEY_SHARE1_4_OFFSET = 12'h 68;
  parameter logic [11:0] KMAC_KEY_SHARE1_5_OFFSET = 12'h 6c;
  parameter logic [11:0] KMAC_KEY_SHARE1_6_OFFSET = 12'h 70;
  parameter logic [11:0] KMAC_KEY_SHARE1_7_OFFSET = 12'h 74;
  parameter logic [11:0] KMAC_KEY_SHARE1_8_OFFSET = 12'h 78;
  parameter logic [11:0] KMAC_KEY_SHARE1_9_OFFSET = 12'h 7c;
  parameter logic [11:0] KMAC_KEY_SHARE1_10_OFFSET = 12'h 80;
  parameter logic [11:0] KMAC_KEY_SHARE1_11_OFFSET = 12'h 84;
  parameter logic [11:0] KMAC_KEY_SHARE1_12_OFFSET = 12'h 88;
  parameter logic [11:0] KMAC_KEY_SHARE1_13_OFFSET = 12'h 8c;
  parameter logic [11:0] KMAC_KEY_SHARE1_14_OFFSET = 12'h 90;
  parameter logic [11:0] KMAC_KEY_SHARE1_15_OFFSET = 12'h 94;
  parameter logic [11:0] KMAC_KEY_LEN_OFFSET = 12'h 98;
  parameter logic [11:0] KMAC_PREFIX_0_OFFSET = 12'h 9c;
  parameter logic [11:0] KMAC_PREFIX_1_OFFSET = 12'h a0;
  parameter logic [11:0] KMAC_PREFIX_2_OFFSET = 12'h a4;
  parameter logic [11:0] KMAC_PREFIX_3_OFFSET = 12'h a8;
  parameter logic [11:0] KMAC_PREFIX_4_OFFSET = 12'h ac;
  parameter logic [11:0] KMAC_PREFIX_5_OFFSET = 12'h b0;
  parameter logic [11:0] KMAC_PREFIX_6_OFFSET = 12'h b4;
  parameter logic [11:0] KMAC_PREFIX_7_OFFSET = 12'h b8;
  parameter logic [11:0] KMAC_PREFIX_8_OFFSET = 12'h bc;
  parameter logic [11:0] KMAC_PREFIX_9_OFFSET = 12'h c0;
  parameter logic [11:0] KMAC_PREFIX_10_OFFSET = 12'h c4;
  parameter logic [11:0] KMAC_ERR_CODE_OFFSET = 12'h c8;
  parameter logic [11:0] KMAC_CFG_REGWEN_OFFSET = 12'h cc;

  // Window parameter
  parameter logic [11:0] KMAC_STATE_OFFSET = 12'h 400;
  parameter logic [11:0] KMAC_STATE_SIZE   = 12'h 200;
  parameter logic [11:0] KMAC_MSG_FIFO_OFFSET = 12'h 800;
  parameter logic [11:0] KMAC_MSG_FIFO_SIZE   = 12'h 800;

  // Register Index
  typedef enum int {
    KMAC_INTR_STATE,
    KMAC_INTR_ENABLE,
    KMAC_INTR_TEST,
    KMAC_CFG,
    KMAC_CMD,
    KMAC_STATUS,
    KMAC_KEY_SHARE0_0,
    KMAC_KEY_SHARE0_1,
    KMAC_KEY_SHARE0_2,
    KMAC_KEY_SHARE0_3,
    KMAC_KEY_SHARE0_4,
    KMAC_KEY_SHARE0_5,
    KMAC_KEY_SHARE0_6,
    KMAC_KEY_SHARE0_7,
    KMAC_KEY_SHARE0_8,
    KMAC_KEY_SHARE0_9,
    KMAC_KEY_SHARE0_10,
    KMAC_KEY_SHARE0_11,
    KMAC_KEY_SHARE0_12,
    KMAC_KEY_SHARE0_13,
    KMAC_KEY_SHARE0_14,
    KMAC_KEY_SHARE0_15,
    KMAC_KEY_SHARE1_0,
    KMAC_KEY_SHARE1_1,
    KMAC_KEY_SHARE1_2,
    KMAC_KEY_SHARE1_3,
    KMAC_KEY_SHARE1_4,
    KMAC_KEY_SHARE1_5,
    KMAC_KEY_SHARE1_6,
    KMAC_KEY_SHARE1_7,
    KMAC_KEY_SHARE1_8,
    KMAC_KEY_SHARE1_9,
    KMAC_KEY_SHARE1_10,
    KMAC_KEY_SHARE1_11,
    KMAC_KEY_SHARE1_12,
    KMAC_KEY_SHARE1_13,
    KMAC_KEY_SHARE1_14,
    KMAC_KEY_SHARE1_15,
    KMAC_KEY_LEN,
    KMAC_PREFIX_0,
    KMAC_PREFIX_1,
    KMAC_PREFIX_2,
    KMAC_PREFIX_3,
    KMAC_PREFIX_4,
    KMAC_PREFIX_5,
    KMAC_PREFIX_6,
    KMAC_PREFIX_7,
    KMAC_PREFIX_8,
    KMAC_PREFIX_9,
    KMAC_PREFIX_10,
    KMAC_ERR_CODE,
    KMAC_CFG_REGWEN
  } kmac_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] KMAC_PERMIT [52] = '{
    4'b 0001, // index[ 0] KMAC_INTR_STATE
    4'b 0001, // index[ 1] KMAC_INTR_ENABLE
    4'b 0001, // index[ 2] KMAC_INTR_TEST
    4'b 0011, // index[ 3] KMAC_CFG
    4'b 0001, // index[ 4] KMAC_CMD
    4'b 0011, // index[ 5] KMAC_STATUS
    4'b 1111, // index[ 6] KMAC_KEY_SHARE0_0
    4'b 1111, // index[ 7] KMAC_KEY_SHARE0_1
    4'b 1111, // index[ 8] KMAC_KEY_SHARE0_2
    4'b 1111, // index[ 9] KMAC_KEY_SHARE0_3
    4'b 1111, // index[10] KMAC_KEY_SHARE0_4
    4'b 1111, // index[11] KMAC_KEY_SHARE0_5
    4'b 1111, // index[12] KMAC_KEY_SHARE0_6
    4'b 1111, // index[13] KMAC_KEY_SHARE0_7
    4'b 1111, // index[14] KMAC_KEY_SHARE0_8
    4'b 1111, // index[15] KMAC_KEY_SHARE0_9
    4'b 1111, // index[16] KMAC_KEY_SHARE0_10
    4'b 1111, // index[17] KMAC_KEY_SHARE0_11
    4'b 1111, // index[18] KMAC_KEY_SHARE0_12
    4'b 1111, // index[19] KMAC_KEY_SHARE0_13
    4'b 1111, // index[20] KMAC_KEY_SHARE0_14
    4'b 1111, // index[21] KMAC_KEY_SHARE0_15
    4'b 1111, // index[22] KMAC_KEY_SHARE1_0
    4'b 1111, // index[23] KMAC_KEY_SHARE1_1
    4'b 1111, // index[24] KMAC_KEY_SHARE1_2
    4'b 1111, // index[25] KMAC_KEY_SHARE1_3
    4'b 1111, // index[26] KMAC_KEY_SHARE1_4
    4'b 1111, // index[27] KMAC_KEY_SHARE1_5
    4'b 1111, // index[28] KMAC_KEY_SHARE1_6
    4'b 1111, // index[29] KMAC_KEY_SHARE1_7
    4'b 1111, // index[30] KMAC_KEY_SHARE1_8
    4'b 1111, // index[31] KMAC_KEY_SHARE1_9
    4'b 1111, // index[32] KMAC_KEY_SHARE1_10
    4'b 1111, // index[33] KMAC_KEY_SHARE1_11
    4'b 1111, // index[34] KMAC_KEY_SHARE1_12
    4'b 1111, // index[35] KMAC_KEY_SHARE1_13
    4'b 1111, // index[36] KMAC_KEY_SHARE1_14
    4'b 1111, // index[37] KMAC_KEY_SHARE1_15
    4'b 0001, // index[38] KMAC_KEY_LEN
    4'b 1111, // index[39] KMAC_PREFIX_0
    4'b 1111, // index[40] KMAC_PREFIX_1
    4'b 1111, // index[41] KMAC_PREFIX_2
    4'b 1111, // index[42] KMAC_PREFIX_3
    4'b 1111, // index[43] KMAC_PREFIX_4
    4'b 1111, // index[44] KMAC_PREFIX_5
    4'b 1111, // index[45] KMAC_PREFIX_6
    4'b 1111, // index[46] KMAC_PREFIX_7
    4'b 1111, // index[47] KMAC_PREFIX_8
    4'b 1111, // index[48] KMAC_PREFIX_9
    4'b 1111, // index[49] KMAC_PREFIX_10
    4'b 1111, // index[50] KMAC_ERR_CODE
    4'b 0001  // index[51] KMAC_CFG_REGWEN
  };
endpackage

