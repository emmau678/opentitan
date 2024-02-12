// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package hmac_reg_pkg;

  // Param list
  parameter int NumDigestWords = 16;
  parameter int NumKeyWords = 32;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 13;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } hmac_err;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } hmac_done;
  } hmac_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } hmac_err;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } hmac_done;
  } hmac_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } hmac_err;
    struct packed {
      logic        q;
      logic        qe;
    } fifo_empty;
    struct packed {
      logic        q;
      logic        qe;
    } hmac_done;
  } hmac_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } hmac_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic [4:0]  q;
      logic        qe;
    } key_length;
    struct packed {
      logic [3:0]  q;
      logic        qe;
    } digest_size;
    struct packed {
      logic        q;
      logic        qe;
    } digest_swap;
    struct packed {
      logic        q;
      logic        qe;
    } endian_swap;
    struct packed {
      logic        q;
      logic        qe;
    } sha_en;
    struct packed {
      logic        q;
      logic        qe;
    } hmac_en;
  } hmac_reg2hw_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } hash_continue;
    struct packed {
      logic        q;
      logic        qe;
    } hash_stop;
    struct packed {
      logic        q;
      logic        qe;
    } hash_process;
    struct packed {
      logic        q;
      logic        qe;
    } hash_start;
  } hmac_reg2hw_cmd_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_wipe_secret_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_key_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_digest_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_msg_length_lower_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_msg_length_upper_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } hmac_done;
    struct packed {
      logic        d;
      logic        de;
    } fifo_empty;
    struct packed {
      logic        d;
      logic        de;
    } hmac_err;
  } hmac_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } hmac_en;
    struct packed {
      logic        d;
    } sha_en;
    struct packed {
      logic        d;
    } endian_swap;
    struct packed {
      logic        d;
    } digest_swap;
    struct packed {
      logic [3:0]  d;
    } digest_size;
    struct packed {
      logic [4:0]  d;
    } key_length;
  } hmac_hw2reg_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } fifo_empty;
    struct packed {
      logic        d;
    } fifo_full;
    struct packed {
      logic [5:0]  d;
    } fifo_depth;
  } hmac_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } hmac_hw2reg_err_code_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_key_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_msg_length_lower_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_msg_length_upper_reg_t;

  // Register -> HW type
  typedef struct packed {
    hmac_reg2hw_intr_state_reg_t intr_state; // [1723:1721]
    hmac_reg2hw_intr_enable_reg_t intr_enable; // [1720:1718]
    hmac_reg2hw_intr_test_reg_t intr_test; // [1717:1712]
    hmac_reg2hw_alert_test_reg_t alert_test; // [1711:1710]
    hmac_reg2hw_cfg_reg_t cfg; // [1709:1691]
    hmac_reg2hw_cmd_reg_t cmd; // [1690:1683]
    hmac_reg2hw_wipe_secret_reg_t wipe_secret; // [1682:1650]
    hmac_reg2hw_key_mreg_t [31:0] key; // [1649:594]
    hmac_reg2hw_digest_mreg_t [15:0] digest; // [593:66]
    hmac_reg2hw_msg_length_lower_reg_t msg_length_lower; // [65:33]
    hmac_reg2hw_msg_length_upper_reg_t msg_length_upper; // [32:0]
  } hmac_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    hmac_hw2reg_intr_state_reg_t intr_state; // [1659:1654]
    hmac_hw2reg_cfg_reg_t cfg; // [1653:1641]
    hmac_hw2reg_status_reg_t status; // [1640:1633]
    hmac_hw2reg_err_code_reg_t err_code; // [1632:1600]
    hmac_hw2reg_key_mreg_t [31:0] key; // [1599:576]
    hmac_hw2reg_digest_mreg_t [15:0] digest; // [575:64]
    hmac_hw2reg_msg_length_lower_reg_t msg_length_lower; // [63:32]
    hmac_hw2reg_msg_length_upper_reg_t msg_length_upper; // [31:0]
  } hmac_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] HMAC_INTR_STATE_OFFSET = 13'h 0;
  parameter logic [BlockAw-1:0] HMAC_INTR_ENABLE_OFFSET = 13'h 4;
  parameter logic [BlockAw-1:0] HMAC_INTR_TEST_OFFSET = 13'h 8;
  parameter logic [BlockAw-1:0] HMAC_ALERT_TEST_OFFSET = 13'h c;
  parameter logic [BlockAw-1:0] HMAC_CFG_OFFSET = 13'h 10;
  parameter logic [BlockAw-1:0] HMAC_CMD_OFFSET = 13'h 14;
  parameter logic [BlockAw-1:0] HMAC_STATUS_OFFSET = 13'h 18;
  parameter logic [BlockAw-1:0] HMAC_ERR_CODE_OFFSET = 13'h 1c;
  parameter logic [BlockAw-1:0] HMAC_WIPE_SECRET_OFFSET = 13'h 20;
  parameter logic [BlockAw-1:0] HMAC_KEY_0_OFFSET = 13'h 24;
  parameter logic [BlockAw-1:0] HMAC_KEY_1_OFFSET = 13'h 28;
  parameter logic [BlockAw-1:0] HMAC_KEY_2_OFFSET = 13'h 2c;
  parameter logic [BlockAw-1:0] HMAC_KEY_3_OFFSET = 13'h 30;
  parameter logic [BlockAw-1:0] HMAC_KEY_4_OFFSET = 13'h 34;
  parameter logic [BlockAw-1:0] HMAC_KEY_5_OFFSET = 13'h 38;
  parameter logic [BlockAw-1:0] HMAC_KEY_6_OFFSET = 13'h 3c;
  parameter logic [BlockAw-1:0] HMAC_KEY_7_OFFSET = 13'h 40;
  parameter logic [BlockAw-1:0] HMAC_KEY_8_OFFSET = 13'h 44;
  parameter logic [BlockAw-1:0] HMAC_KEY_9_OFFSET = 13'h 48;
  parameter logic [BlockAw-1:0] HMAC_KEY_10_OFFSET = 13'h 4c;
  parameter logic [BlockAw-1:0] HMAC_KEY_11_OFFSET = 13'h 50;
  parameter logic [BlockAw-1:0] HMAC_KEY_12_OFFSET = 13'h 54;
  parameter logic [BlockAw-1:0] HMAC_KEY_13_OFFSET = 13'h 58;
  parameter logic [BlockAw-1:0] HMAC_KEY_14_OFFSET = 13'h 5c;
  parameter logic [BlockAw-1:0] HMAC_KEY_15_OFFSET = 13'h 60;
  parameter logic [BlockAw-1:0] HMAC_KEY_16_OFFSET = 13'h 64;
  parameter logic [BlockAw-1:0] HMAC_KEY_17_OFFSET = 13'h 68;
  parameter logic [BlockAw-1:0] HMAC_KEY_18_OFFSET = 13'h 6c;
  parameter logic [BlockAw-1:0] HMAC_KEY_19_OFFSET = 13'h 70;
  parameter logic [BlockAw-1:0] HMAC_KEY_20_OFFSET = 13'h 74;
  parameter logic [BlockAw-1:0] HMAC_KEY_21_OFFSET = 13'h 78;
  parameter logic [BlockAw-1:0] HMAC_KEY_22_OFFSET = 13'h 7c;
  parameter logic [BlockAw-1:0] HMAC_KEY_23_OFFSET = 13'h 80;
  parameter logic [BlockAw-1:0] HMAC_KEY_24_OFFSET = 13'h 84;
  parameter logic [BlockAw-1:0] HMAC_KEY_25_OFFSET = 13'h 88;
  parameter logic [BlockAw-1:0] HMAC_KEY_26_OFFSET = 13'h 8c;
  parameter logic [BlockAw-1:0] HMAC_KEY_27_OFFSET = 13'h 90;
  parameter logic [BlockAw-1:0] HMAC_KEY_28_OFFSET = 13'h 94;
  parameter logic [BlockAw-1:0] HMAC_KEY_29_OFFSET = 13'h 98;
  parameter logic [BlockAw-1:0] HMAC_KEY_30_OFFSET = 13'h 9c;
  parameter logic [BlockAw-1:0] HMAC_KEY_31_OFFSET = 13'h a0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_0_OFFSET = 13'h a4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_1_OFFSET = 13'h a8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_2_OFFSET = 13'h ac;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_3_OFFSET = 13'h b0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_4_OFFSET = 13'h b4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_5_OFFSET = 13'h b8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_6_OFFSET = 13'h bc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_7_OFFSET = 13'h c0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_8_OFFSET = 13'h c4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_9_OFFSET = 13'h c8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_10_OFFSET = 13'h cc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_11_OFFSET = 13'h d0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_12_OFFSET = 13'h d4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_13_OFFSET = 13'h d8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_14_OFFSET = 13'h dc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_15_OFFSET = 13'h e0;
  parameter logic [BlockAw-1:0] HMAC_MSG_LENGTH_LOWER_OFFSET = 13'h e4;
  parameter logic [BlockAw-1:0] HMAC_MSG_LENGTH_UPPER_OFFSET = 13'h e8;

  // Reset values for hwext registers and their fields
  parameter logic [2:0] HMAC_INTR_TEST_RESVAL = 3'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_HMAC_DONE_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_FIFO_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_HMAC_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [12:0] HMAC_CFG_RESVAL = 13'h 210;
  parameter logic [0:0] HMAC_CFG_ENDIAN_SWAP_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_CFG_DIGEST_SWAP_RESVAL = 1'h 0;
  parameter logic [3:0] HMAC_CFG_DIGEST_SIZE_RESVAL = 4'h 1;
  parameter logic [4:0] HMAC_CFG_KEY_LENGTH_RESVAL = 5'h 2;
  parameter logic [3:0] HMAC_CMD_RESVAL = 4'h 0;
  parameter logic [9:0] HMAC_STATUS_RESVAL = 10'h 1;
  parameter logic [0:0] HMAC_STATUS_FIFO_EMPTY_RESVAL = 1'h 1;
  parameter logic [31:0] HMAC_WIPE_SECRET_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_0_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_1_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_2_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_3_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_4_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_5_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_6_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_7_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_8_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_9_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_10_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_11_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_12_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_13_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_14_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_15_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_16_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_17_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_18_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_19_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_20_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_21_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_22_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_23_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_24_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_25_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_26_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_27_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_28_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_29_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_30_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_31_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_0_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_1_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_2_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_3_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_4_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_5_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_6_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_7_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_8_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_9_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_10_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_11_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_12_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_13_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_14_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_15_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_MSG_LENGTH_LOWER_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_MSG_LENGTH_UPPER_RESVAL = 32'h 0;

  // Window parameters
  parameter logic [BlockAw-1:0] HMAC_MSG_FIFO_OFFSET = 13'h 1000;
  parameter int unsigned        HMAC_MSG_FIFO_SIZE   = 'h 1000;
  parameter int unsigned        HMAC_MSG_FIFO_IDX    = 0;

  // Register index
  typedef enum int {
    HMAC_INTR_STATE,
    HMAC_INTR_ENABLE,
    HMAC_INTR_TEST,
    HMAC_ALERT_TEST,
    HMAC_CFG,
    HMAC_CMD,
    HMAC_STATUS,
    HMAC_ERR_CODE,
    HMAC_WIPE_SECRET,
    HMAC_KEY_0,
    HMAC_KEY_1,
    HMAC_KEY_2,
    HMAC_KEY_3,
    HMAC_KEY_4,
    HMAC_KEY_5,
    HMAC_KEY_6,
    HMAC_KEY_7,
    HMAC_KEY_8,
    HMAC_KEY_9,
    HMAC_KEY_10,
    HMAC_KEY_11,
    HMAC_KEY_12,
    HMAC_KEY_13,
    HMAC_KEY_14,
    HMAC_KEY_15,
    HMAC_KEY_16,
    HMAC_KEY_17,
    HMAC_KEY_18,
    HMAC_KEY_19,
    HMAC_KEY_20,
    HMAC_KEY_21,
    HMAC_KEY_22,
    HMAC_KEY_23,
    HMAC_KEY_24,
    HMAC_KEY_25,
    HMAC_KEY_26,
    HMAC_KEY_27,
    HMAC_KEY_28,
    HMAC_KEY_29,
    HMAC_KEY_30,
    HMAC_KEY_31,
    HMAC_DIGEST_0,
    HMAC_DIGEST_1,
    HMAC_DIGEST_2,
    HMAC_DIGEST_3,
    HMAC_DIGEST_4,
    HMAC_DIGEST_5,
    HMAC_DIGEST_6,
    HMAC_DIGEST_7,
    HMAC_DIGEST_8,
    HMAC_DIGEST_9,
    HMAC_DIGEST_10,
    HMAC_DIGEST_11,
    HMAC_DIGEST_12,
    HMAC_DIGEST_13,
    HMAC_DIGEST_14,
    HMAC_DIGEST_15,
    HMAC_MSG_LENGTH_LOWER,
    HMAC_MSG_LENGTH_UPPER
  } hmac_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] HMAC_PERMIT [59] = '{
    4'b 0001, // index[ 0] HMAC_INTR_STATE
    4'b 0001, // index[ 1] HMAC_INTR_ENABLE
    4'b 0001, // index[ 2] HMAC_INTR_TEST
    4'b 0001, // index[ 3] HMAC_ALERT_TEST
    4'b 0011, // index[ 4] HMAC_CFG
    4'b 0001, // index[ 5] HMAC_CMD
    4'b 0011, // index[ 6] HMAC_STATUS
    4'b 1111, // index[ 7] HMAC_ERR_CODE
    4'b 1111, // index[ 8] HMAC_WIPE_SECRET
    4'b 1111, // index[ 9] HMAC_KEY_0
    4'b 1111, // index[10] HMAC_KEY_1
    4'b 1111, // index[11] HMAC_KEY_2
    4'b 1111, // index[12] HMAC_KEY_3
    4'b 1111, // index[13] HMAC_KEY_4
    4'b 1111, // index[14] HMAC_KEY_5
    4'b 1111, // index[15] HMAC_KEY_6
    4'b 1111, // index[16] HMAC_KEY_7
    4'b 1111, // index[17] HMAC_KEY_8
    4'b 1111, // index[18] HMAC_KEY_9
    4'b 1111, // index[19] HMAC_KEY_10
    4'b 1111, // index[20] HMAC_KEY_11
    4'b 1111, // index[21] HMAC_KEY_12
    4'b 1111, // index[22] HMAC_KEY_13
    4'b 1111, // index[23] HMAC_KEY_14
    4'b 1111, // index[24] HMAC_KEY_15
    4'b 1111, // index[25] HMAC_KEY_16
    4'b 1111, // index[26] HMAC_KEY_17
    4'b 1111, // index[27] HMAC_KEY_18
    4'b 1111, // index[28] HMAC_KEY_19
    4'b 1111, // index[29] HMAC_KEY_20
    4'b 1111, // index[30] HMAC_KEY_21
    4'b 1111, // index[31] HMAC_KEY_22
    4'b 1111, // index[32] HMAC_KEY_23
    4'b 1111, // index[33] HMAC_KEY_24
    4'b 1111, // index[34] HMAC_KEY_25
    4'b 1111, // index[35] HMAC_KEY_26
    4'b 1111, // index[36] HMAC_KEY_27
    4'b 1111, // index[37] HMAC_KEY_28
    4'b 1111, // index[38] HMAC_KEY_29
    4'b 1111, // index[39] HMAC_KEY_30
    4'b 1111, // index[40] HMAC_KEY_31
    4'b 1111, // index[41] HMAC_DIGEST_0
    4'b 1111, // index[42] HMAC_DIGEST_1
    4'b 1111, // index[43] HMAC_DIGEST_2
    4'b 1111, // index[44] HMAC_DIGEST_3
    4'b 1111, // index[45] HMAC_DIGEST_4
    4'b 1111, // index[46] HMAC_DIGEST_5
    4'b 1111, // index[47] HMAC_DIGEST_6
    4'b 1111, // index[48] HMAC_DIGEST_7
    4'b 1111, // index[49] HMAC_DIGEST_8
    4'b 1111, // index[50] HMAC_DIGEST_9
    4'b 1111, // index[51] HMAC_DIGEST_10
    4'b 1111, // index[52] HMAC_DIGEST_11
    4'b 1111, // index[53] HMAC_DIGEST_12
    4'b 1111, // index[54] HMAC_DIGEST_13
    4'b 1111, // index[55] HMAC_DIGEST_14
    4'b 1111, // index[56] HMAC_DIGEST_15
    4'b 1111, // index[57] HMAC_MSG_LENGTH_LOWER
    4'b 1111  // index[58] HMAC_MSG_LENGTH_UPPER
  };

endpackage
