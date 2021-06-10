// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package aon_timer_reg_pkg;

  // Address widths within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } enable;
    struct packed {
      logic [11:0] q;
    } prescaler;
  } aon_timer_reg2hw_wkup_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } aon_timer_reg2hw_wkup_thold_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } aon_timer_reg2hw_wkup_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enable;
    struct packed {
      logic        q;
    } pause_in_sleep;
  } aon_timer_reg2hw_wdog_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } aon_timer_reg2hw_wdog_bark_thold_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } aon_timer_reg2hw_wdog_bite_thold_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } aon_timer_reg2hw_wdog_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } wkup_timer_expired;
    struct packed {
      logic        q;
    } wdog_timer_expired;
  } aon_timer_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } wkup_timer_expired;
    struct packed {
      logic        q;
      logic        qe;
    } wdog_timer_expired;
  } aon_timer_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
  } aon_timer_reg2hw_wkup_cause_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } aon_timer_hw2reg_wkup_count_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } aon_timer_hw2reg_wdog_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } wkup_timer_expired;
    struct packed {
      logic        d;
      logic        de;
    } wdog_timer_expired;
  } aon_timer_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } aon_timer_hw2reg_wkup_cause_reg_t;

  // Register -> HW type
  typedef struct packed {
    aon_timer_reg2hw_wkup_ctrl_reg_t wkup_ctrl; // [181:169]
    aon_timer_reg2hw_wkup_thold_reg_t wkup_thold; // [168:137]
    aon_timer_reg2hw_wkup_count_reg_t wkup_count; // [136:105]
    aon_timer_reg2hw_wdog_ctrl_reg_t wdog_ctrl; // [104:103]
    aon_timer_reg2hw_wdog_bark_thold_reg_t wdog_bark_thold; // [102:71]
    aon_timer_reg2hw_wdog_bite_thold_reg_t wdog_bite_thold; // [70:39]
    aon_timer_reg2hw_wdog_count_reg_t wdog_count; // [38:7]
    aon_timer_reg2hw_intr_state_reg_t intr_state; // [6:5]
    aon_timer_reg2hw_intr_test_reg_t intr_test; // [4:1]
    aon_timer_reg2hw_wkup_cause_reg_t wkup_cause; // [0:0]
  } aon_timer_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    aon_timer_hw2reg_wkup_count_reg_t wkup_count; // [71:39]
    aon_timer_hw2reg_wdog_count_reg_t wdog_count; // [38:6]
    aon_timer_hw2reg_intr_state_reg_t intr_state; // [5:2]
    aon_timer_hw2reg_wkup_cause_reg_t wkup_cause; // [1:0]
  } aon_timer_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] AON_TIMER_WKUP_CTRL_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] AON_TIMER_WKUP_THOLD_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] AON_TIMER_WKUP_COUNT_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] AON_TIMER_WDOG_REGWEN_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] AON_TIMER_WDOG_CTRL_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] AON_TIMER_WDOG_BARK_THOLD_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] AON_TIMER_WDOG_BITE_THOLD_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] AON_TIMER_WDOG_COUNT_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] AON_TIMER_INTR_STATE_OFFSET = 6'h 20;
  parameter logic [BlockAw-1:0] AON_TIMER_INTR_TEST_OFFSET = 6'h 24;
  parameter logic [BlockAw-1:0] AON_TIMER_WKUP_CAUSE_OFFSET = 6'h 28;

  // Reset values for hwext registers and their fields
  parameter logic [1:0] AON_TIMER_INTR_TEST_RESVAL = 2'h 0;

  // Register index
  typedef enum int {
    AON_TIMER_WKUP_CTRL,
    AON_TIMER_WKUP_THOLD,
    AON_TIMER_WKUP_COUNT,
    AON_TIMER_WDOG_REGWEN,
    AON_TIMER_WDOG_CTRL,
    AON_TIMER_WDOG_BARK_THOLD,
    AON_TIMER_WDOG_BITE_THOLD,
    AON_TIMER_WDOG_COUNT,
    AON_TIMER_INTR_STATE,
    AON_TIMER_INTR_TEST,
    AON_TIMER_WKUP_CAUSE
  } aon_timer_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] AON_TIMER_PERMIT [11] = '{
    4'b 0011, // index[ 0] AON_TIMER_WKUP_CTRL
    4'b 1111, // index[ 1] AON_TIMER_WKUP_THOLD
    4'b 1111, // index[ 2] AON_TIMER_WKUP_COUNT
    4'b 0001, // index[ 3] AON_TIMER_WDOG_REGWEN
    4'b 0001, // index[ 4] AON_TIMER_WDOG_CTRL
    4'b 1111, // index[ 5] AON_TIMER_WDOG_BARK_THOLD
    4'b 1111, // index[ 6] AON_TIMER_WDOG_BITE_THOLD
    4'b 1111, // index[ 7] AON_TIMER_WDOG_COUNT
    4'b 0001, // index[ 8] AON_TIMER_INTR_STATE
    4'b 0001, // index[ 9] AON_TIMER_INTR_TEST
    4'b 0001  // index[10] AON_TIMER_WKUP_CAUSE
  };

endpackage

