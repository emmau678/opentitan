// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package sensor_ctrl_reg_pkg;

  // Param list
  parameter int NumAlertEvents = 11;
  parameter int NumLocalEvents = 1;
  parameter int NumAlerts = 2;
  parameter int NumIoRails = 2;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } io_status_change;
    struct packed {
      logic        q;
    } init_status_change;
  } sensor_ctrl_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } io_status_change;
    struct packed {
      logic        q;
    } init_status_change;
  } sensor_ctrl_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } io_status_change;
    struct packed {
      logic        q;
      logic        qe;
    } init_status_change;
  } sensor_ctrl_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } recov_alert;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_alert;
  } sensor_ctrl_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic        q;
  } sensor_ctrl_reg2hw_alert_trig_mreg_t;

  typedef struct packed {
    logic        q;
  } sensor_ctrl_reg2hw_fatal_alert_en_mreg_t;

  typedef struct packed {
    logic        q;
  } sensor_ctrl_reg2hw_recov_alert_mreg_t;

  typedef struct packed {
    logic        q;
  } sensor_ctrl_reg2hw_fatal_alert_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } io_status_change;
    struct packed {
      logic        d;
      logic        de;
    } init_status_change;
  } sensor_ctrl_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } sensor_ctrl_hw2reg_recov_alert_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } sensor_ctrl_hw2reg_fatal_alert_mreg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } ast_init_done;
    struct packed {
      logic [1:0]  d;
      logic        de;
    } io_pok;
  } sensor_ctrl_hw2reg_status_reg_t;

  // Register -> HW type
  typedef struct packed {
    sensor_ctrl_reg2hw_intr_state_reg_t intr_state; // [56:55]
    sensor_ctrl_reg2hw_intr_enable_reg_t intr_enable; // [54:53]
    sensor_ctrl_reg2hw_intr_test_reg_t intr_test; // [52:49]
    sensor_ctrl_reg2hw_alert_test_reg_t alert_test; // [48:45]
    sensor_ctrl_reg2hw_alert_trig_mreg_t [10:0] alert_trig; // [44:34]
    sensor_ctrl_reg2hw_fatal_alert_en_mreg_t [10:0] fatal_alert_en; // [33:23]
    sensor_ctrl_reg2hw_recov_alert_mreg_t [10:0] recov_alert; // [22:12]
    sensor_ctrl_reg2hw_fatal_alert_mreg_t [11:0] fatal_alert; // [11:0]
  } sensor_ctrl_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    sensor_ctrl_hw2reg_intr_state_reg_t intr_state; // [54:51]
    sensor_ctrl_hw2reg_recov_alert_mreg_t [10:0] recov_alert; // [50:29]
    sensor_ctrl_hw2reg_fatal_alert_mreg_t [11:0] fatal_alert; // [28:5]
    sensor_ctrl_hw2reg_status_reg_t status; // [4:0]
  } sensor_ctrl_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] SENSOR_CTRL_CIP_ID_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_REVISION_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_PARAMETER_BLOCK_TYPE_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_PARAMETER_BLOCK_LENGTH_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_NEXT_PARAMETER_BLOCK_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_INTR_STATE_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_INTR_ENABLE_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_INTR_TEST_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_ALERT_TEST_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_CFG_REGWEN_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_ALERT_TRIG_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_FATAL_ALERT_EN_OFFSET = 7'h 58;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_RECOV_ALERT_OFFSET = 7'h 5c;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_FATAL_ALERT_OFFSET = 7'h 60;
  parameter logic [BlockAw-1:0] SENSOR_CTRL_STATUS_OFFSET = 7'h 64;

  // Reset values for hwext registers and their fields
  parameter logic [1:0] SENSOR_CTRL_INTR_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] SENSOR_CTRL_INTR_TEST_IO_STATUS_CHANGE_RESVAL = 1'h 0;
  parameter logic [0:0] SENSOR_CTRL_INTR_TEST_INIT_STATUS_CHANGE_RESVAL = 1'h 0;
  parameter logic [1:0] SENSOR_CTRL_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] SENSOR_CTRL_ALERT_TEST_RECOV_ALERT_RESVAL = 1'h 0;
  parameter logic [0:0] SENSOR_CTRL_ALERT_TEST_FATAL_ALERT_RESVAL = 1'h 0;

  // Register index
  typedef enum int {
    SENSOR_CTRL_CIP_ID,
    SENSOR_CTRL_REVISION,
    SENSOR_CTRL_PARAMETER_BLOCK_TYPE,
    SENSOR_CTRL_PARAMETER_BLOCK_LENGTH,
    SENSOR_CTRL_NEXT_PARAMETER_BLOCK,
    SENSOR_CTRL_INTR_STATE,
    SENSOR_CTRL_INTR_ENABLE,
    SENSOR_CTRL_INTR_TEST,
    SENSOR_CTRL_ALERT_TEST,
    SENSOR_CTRL_CFG_REGWEN,
    SENSOR_CTRL_ALERT_TRIG,
    SENSOR_CTRL_FATAL_ALERT_EN,
    SENSOR_CTRL_RECOV_ALERT,
    SENSOR_CTRL_FATAL_ALERT,
    SENSOR_CTRL_STATUS
  } sensor_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] SENSOR_CTRL_PERMIT [15] = '{
    4'b 1111, // index[ 0] SENSOR_CTRL_CIP_ID
    4'b 1111, // index[ 1] SENSOR_CTRL_REVISION
    4'b 1111, // index[ 2] SENSOR_CTRL_PARAMETER_BLOCK_TYPE
    4'b 1111, // index[ 3] SENSOR_CTRL_PARAMETER_BLOCK_LENGTH
    4'b 1111, // index[ 4] SENSOR_CTRL_NEXT_PARAMETER_BLOCK
    4'b 0001, // index[ 5] SENSOR_CTRL_INTR_STATE
    4'b 0001, // index[ 6] SENSOR_CTRL_INTR_ENABLE
    4'b 0001, // index[ 7] SENSOR_CTRL_INTR_TEST
    4'b 0001, // index[ 8] SENSOR_CTRL_ALERT_TEST
    4'b 0001, // index[ 9] SENSOR_CTRL_CFG_REGWEN
    4'b 0011, // index[10] SENSOR_CTRL_ALERT_TRIG
    4'b 0011, // index[11] SENSOR_CTRL_FATAL_ALERT_EN
    4'b 0011, // index[12] SENSOR_CTRL_RECOV_ALERT
    4'b 0011, // index[13] SENSOR_CTRL_FATAL_ALERT
    4'b 0001  // index[14] SENSOR_CTRL_STATUS
  };

endpackage
