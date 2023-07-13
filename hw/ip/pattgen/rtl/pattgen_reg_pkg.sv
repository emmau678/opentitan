// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package pattgen_reg_pkg;

  // Param list
  parameter int NumRegsData = 2;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } done_ch0;
    struct packed {
      logic        q;
    } done_ch1;
  } pattgen_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } done_ch0;
    struct packed {
      logic        q;
    } done_ch1;
  } pattgen_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } done_ch0;
    struct packed {
      logic        q;
      logic        qe;
    } done_ch1;
  } pattgen_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } pattgen_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enable_ch0;
    struct packed {
      logic        q;
    } enable_ch1;
    struct packed {
      logic        q;
    } polarity_ch0;
    struct packed {
      logic        q;
    } polarity_ch1;
  } pattgen_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } pattgen_reg2hw_prediv_ch0_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } pattgen_reg2hw_prediv_ch1_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } pattgen_reg2hw_data_ch0_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } pattgen_reg2hw_data_ch1_mreg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  q;
    } len_ch0;
    struct packed {
      logic [9:0] q;
    } reps_ch0;
    struct packed {
      logic [5:0]  q;
    } len_ch1;
    struct packed {
      logic [9:0] q;
    } reps_ch1;
  } pattgen_reg2hw_size_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } done_ch0;
    struct packed {
      logic        d;
      logic        de;
    } done_ch1;
  } pattgen_hw2reg_intr_state_reg_t;

  // Register -> HW type
  typedef struct packed {
    pattgen_reg2hw_intr_state_reg_t intr_state; // [237:236]
    pattgen_reg2hw_intr_enable_reg_t intr_enable; // [235:234]
    pattgen_reg2hw_intr_test_reg_t intr_test; // [233:230]
    pattgen_reg2hw_alert_test_reg_t alert_test; // [229:228]
    pattgen_reg2hw_ctrl_reg_t ctrl; // [227:224]
    pattgen_reg2hw_prediv_ch0_reg_t prediv_ch0; // [223:192]
    pattgen_reg2hw_prediv_ch1_reg_t prediv_ch1; // [191:160]
    pattgen_reg2hw_data_ch0_mreg_t [1:0] data_ch0; // [159:96]
    pattgen_reg2hw_data_ch1_mreg_t [1:0] data_ch1; // [95:32]
    pattgen_reg2hw_size_reg_t size; // [31:0]
  } pattgen_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    pattgen_hw2reg_intr_state_reg_t intr_state; // [3:0]
  } pattgen_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] PATTGEN_CIP_ID_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] PATTGEN_REVISION_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] PATTGEN_PARAMETER_BLOCK_TYPE_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] PATTGEN_PARAMETER_BLOCK_LENGTH_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] PATTGEN_NEXT_PARAMETER_BLOCK_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] PATTGEN_INTR_STATE_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] PATTGEN_INTR_ENABLE_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] PATTGEN_INTR_TEST_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] PATTGEN_ALERT_TEST_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] PATTGEN_CTRL_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] PATTGEN_PREDIV_CH0_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] PATTGEN_PREDIV_CH1_OFFSET = 7'h 58;
  parameter logic [BlockAw-1:0] PATTGEN_DATA_CH0_0_OFFSET = 7'h 5c;
  parameter logic [BlockAw-1:0] PATTGEN_DATA_CH0_1_OFFSET = 7'h 60;
  parameter logic [BlockAw-1:0] PATTGEN_DATA_CH1_0_OFFSET = 7'h 64;
  parameter logic [BlockAw-1:0] PATTGEN_DATA_CH1_1_OFFSET = 7'h 68;
  parameter logic [BlockAw-1:0] PATTGEN_SIZE_OFFSET = 7'h 6c;

  // Reset values for hwext registers and their fields
  parameter logic [1:0] PATTGEN_INTR_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] PATTGEN_INTR_TEST_DONE_CH0_RESVAL = 1'h 0;
  parameter logic [0:0] PATTGEN_INTR_TEST_DONE_CH1_RESVAL = 1'h 0;
  parameter logic [0:0] PATTGEN_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] PATTGEN_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;

  // Register index
  typedef enum int {
    PATTGEN_CIP_ID,
    PATTGEN_REVISION,
    PATTGEN_PARAMETER_BLOCK_TYPE,
    PATTGEN_PARAMETER_BLOCK_LENGTH,
    PATTGEN_NEXT_PARAMETER_BLOCK,
    PATTGEN_INTR_STATE,
    PATTGEN_INTR_ENABLE,
    PATTGEN_INTR_TEST,
    PATTGEN_ALERT_TEST,
    PATTGEN_CTRL,
    PATTGEN_PREDIV_CH0,
    PATTGEN_PREDIV_CH1,
    PATTGEN_DATA_CH0_0,
    PATTGEN_DATA_CH0_1,
    PATTGEN_DATA_CH1_0,
    PATTGEN_DATA_CH1_1,
    PATTGEN_SIZE
  } pattgen_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] PATTGEN_PERMIT [17] = '{
    4'b 1111, // index[ 0] PATTGEN_CIP_ID
    4'b 1111, // index[ 1] PATTGEN_REVISION
    4'b 1111, // index[ 2] PATTGEN_PARAMETER_BLOCK_TYPE
    4'b 1111, // index[ 3] PATTGEN_PARAMETER_BLOCK_LENGTH
    4'b 1111, // index[ 4] PATTGEN_NEXT_PARAMETER_BLOCK
    4'b 0001, // index[ 5] PATTGEN_INTR_STATE
    4'b 0001, // index[ 6] PATTGEN_INTR_ENABLE
    4'b 0001, // index[ 7] PATTGEN_INTR_TEST
    4'b 0001, // index[ 8] PATTGEN_ALERT_TEST
    4'b 0001, // index[ 9] PATTGEN_CTRL
    4'b 1111, // index[10] PATTGEN_PREDIV_CH0
    4'b 1111, // index[11] PATTGEN_PREDIV_CH1
    4'b 1111, // index[12] PATTGEN_DATA_CH0_0
    4'b 1111, // index[13] PATTGEN_DATA_CH0_1
    4'b 1111, // index[14] PATTGEN_DATA_CH1_0
    4'b 1111, // index[15] PATTGEN_DATA_CH1_1
    4'b 1111  // index[16] PATTGEN_SIZE
  };

endpackage
