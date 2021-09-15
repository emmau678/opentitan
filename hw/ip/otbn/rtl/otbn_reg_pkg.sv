// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package otbn_reg_pkg;

  // Param list
  parameter int NumAlerts = 2;

  // Address widths within the block
  parameter int BlockAw = 16;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    logic        q;
  } otbn_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } otbn_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } otbn_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal;
    struct packed {
      logic        q;
      logic        qe;
    } recov;
  } otbn_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } otbn_reg2hw_cmd_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } otbn_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } otbn_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
  } otbn_hw2reg_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } otbn_hw2reg_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } bad_data_addr;
    struct packed {
      logic        d;
      logic        de;
    } bad_insn_addr;
    struct packed {
      logic        d;
      logic        de;
    } call_stack;
    struct packed {
      logic        d;
      logic        de;
    } illegal_insn;
    struct packed {
      logic        d;
      logic        de;
    } loop;
    struct packed {
      logic        d;
      logic        de;
    } imem_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } dmem_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } reg_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } bus_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } illegal_bus_access;
    struct packed {
      logic        d;
      logic        de;
    } lifecycle_escalation;
    struct packed {
      logic        d;
      logic        de;
    } fatal_software;
  } otbn_hw2reg_err_bits_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } imem_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } dmem_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } reg_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } bus_intg_violation;
    struct packed {
      logic        d;
      logic        de;
    } illegal_bus_access;
    struct packed {
      logic        d;
      logic        de;
    } lifecycle_escalation;
    struct packed {
      logic        d;
      logic        de;
    } fatal_software;
  } otbn_hw2reg_fatal_alert_cause_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } otbn_hw2reg_insn_cnt_reg_t;

  // Register -> HW type
  typedef struct packed {
    otbn_reg2hw_intr_state_reg_t intr_state; // [18:18]
    otbn_reg2hw_intr_enable_reg_t intr_enable; // [17:17]
    otbn_reg2hw_intr_test_reg_t intr_test; // [16:15]
    otbn_reg2hw_alert_test_reg_t alert_test; // [14:11]
    otbn_reg2hw_cmd_reg_t cmd; // [10:2]
    otbn_reg2hw_ctrl_reg_t ctrl; // [1:0]
  } otbn_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    otbn_hw2reg_intr_state_reg_t intr_state; // [80:79]
    otbn_hw2reg_ctrl_reg_t ctrl; // [78:78]
    otbn_hw2reg_status_reg_t status; // [77:70]
    otbn_hw2reg_err_bits_reg_t err_bits; // [69:46]
    otbn_hw2reg_fatal_alert_cause_reg_t fatal_alert_cause; // [45:32]
    otbn_hw2reg_insn_cnt_reg_t insn_cnt; // [31:0]
  } otbn_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] OTBN_INTR_STATE_OFFSET = 16'h 0;
  parameter logic [BlockAw-1:0] OTBN_INTR_ENABLE_OFFSET = 16'h 4;
  parameter logic [BlockAw-1:0] OTBN_INTR_TEST_OFFSET = 16'h 8;
  parameter logic [BlockAw-1:0] OTBN_ALERT_TEST_OFFSET = 16'h c;
  parameter logic [BlockAw-1:0] OTBN_CMD_OFFSET = 16'h 10;
  parameter logic [BlockAw-1:0] OTBN_CTRL_OFFSET = 16'h 14;
  parameter logic [BlockAw-1:0] OTBN_STATUS_OFFSET = 16'h 18;
  parameter logic [BlockAw-1:0] OTBN_ERR_BITS_OFFSET = 16'h 1c;
  parameter logic [BlockAw-1:0] OTBN_FATAL_ALERT_CAUSE_OFFSET = 16'h 20;
  parameter logic [BlockAw-1:0] OTBN_INSN_CNT_OFFSET = 16'h 24;

  // Reset values for hwext registers and their fields
  parameter logic [0:0] OTBN_INTR_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] OTBN_INTR_TEST_DONE_RESVAL = 1'h 0;
  parameter logic [1:0] OTBN_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] OTBN_ALERT_TEST_FATAL_RESVAL = 1'h 0;
  parameter logic [0:0] OTBN_ALERT_TEST_RECOV_RESVAL = 1'h 0;
  parameter logic [7:0] OTBN_CMD_RESVAL = 8'h 0;
  parameter logic [7:0] OTBN_CMD_CMD_RESVAL = 8'h 0;
  parameter logic [0:0] OTBN_CTRL_RESVAL = 1'h 0;
  parameter logic [0:0] OTBN_CTRL_SOFTWARE_ERRS_FATAL_RESVAL = 1'h 0;
  parameter logic [7:0] OTBN_STATUS_RESVAL = 8'h 0;
  parameter logic [7:0] OTBN_STATUS_STATUS_RESVAL = 8'h 0;
  parameter logic [31:0] OTBN_INSN_CNT_RESVAL = 32'h 0;
  parameter logic [31:0] OTBN_INSN_CNT_INSN_CNT_RESVAL = 32'h 0;

  // Window parameters
  parameter logic [BlockAw-1:0] OTBN_IMEM_OFFSET = 16'h 4000;
  parameter int unsigned        OTBN_IMEM_SIZE   = 'h 1000;
  parameter logic [BlockAw-1:0] OTBN_DMEM_OFFSET = 16'h 8000;
  parameter int unsigned        OTBN_DMEM_SIZE   = 'h 1000;

  // Register index
  typedef enum int {
    OTBN_INTR_STATE,
    OTBN_INTR_ENABLE,
    OTBN_INTR_TEST,
    OTBN_ALERT_TEST,
    OTBN_CMD,
    OTBN_CTRL,
    OTBN_STATUS,
    OTBN_ERR_BITS,
    OTBN_FATAL_ALERT_CAUSE,
    OTBN_INSN_CNT
  } otbn_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] OTBN_PERMIT [10] = '{
    4'b 0001, // index[0] OTBN_INTR_STATE
    4'b 0001, // index[1] OTBN_INTR_ENABLE
    4'b 0001, // index[2] OTBN_INTR_TEST
    4'b 0001, // index[3] OTBN_ALERT_TEST
    4'b 0001, // index[4] OTBN_CMD
    4'b 0001, // index[5] OTBN_CTRL
    4'b 0001, // index[6] OTBN_STATUS
    4'b 0111, // index[7] OTBN_ERR_BITS
    4'b 0001, // index[8] OTBN_FATAL_ALERT_CAUSE
    4'b 1111  // index[9] OTBN_INSN_CNT
  };

endpackage

