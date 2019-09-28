// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_timer_reg_pkg;

  // Param list
  localparam int N_HARTS = 1;
  localparam int N_TIMERS = 1;

/////////////////////////////////////////////////////////////////////
// Typedefs for multiregs
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  logic [0:0] q;
} rv_timer_reg2hw_ctrl_mreg_t;
typedef struct packed {
  logic [0:0] q;
} rv_timer_reg2hw_intr_enable0_mreg_t;
typedef struct packed {
  logic [0:0] q;
} rv_timer_reg2hw_intr_state0_mreg_t;
typedef struct packed {
  logic [0:0] q;
  logic qe;
} rv_timer_reg2hw_intr_test0_mreg_t;

typedef struct packed {
  logic [0:0] d;
  logic de;
} rv_timer_hw2reg_intr_state0_mreg_t;

/////////////////////////////////////////////////////////////////////
// Register to internal design logic
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  rv_timer_reg2hw_ctrl_mreg_t [0:0] ctrl; // [152:152]
  struct packed {
    struct packed {
      logic [11:0] q; // [151:140]
    } prescale;
    struct packed {
      logic [7:0] q; // [139:132]
    } step;
  } cfg0;
  struct packed {
    logic [31:0] q; // [131:100]
  } timer_v_lower0;
  struct packed {
    logic [31:0] q; // [99:68]
  } timer_v_upper0;
  struct packed {
    logic [31:0] q; // [67:36]
  } compare_lower0_0;
  struct packed {
    logic [31:0] q; // [35:4]
  } compare_upper0_0;
  rv_timer_reg2hw_intr_enable0_mreg_t [0:0] intr_enable0; // [3:3]
  rv_timer_reg2hw_intr_state0_mreg_t [0:0] intr_state0; // [2:2]
  rv_timer_reg2hw_intr_test0_mreg_t [0:0] intr_test0; // [1:0]
} rv_timer_reg2hw_t;

/////////////////////////////////////////////////////////////////////
// Internal design logic to register
/////////////////////////////////////////////////////////////////////

typedef struct packed {
  struct packed {
    logic [31:0] d; // [67:36]
    logic de; // [35]
  } timer_v_lower0;
  struct packed {
    logic [31:0] d; // [34:3]
    logic de; // [2]
  } timer_v_upper0;
  rv_timer_hw2reg_intr_state0_mreg_t [0:0] intr_state0; // [1:0]
} rv_timer_hw2reg_t;

  // Register Address
  parameter RV_TIMER_CTRL_OFFSET = 9'h 0;
  parameter RV_TIMER_CFG0_OFFSET = 9'h 100;
  parameter RV_TIMER_TIMER_V_LOWER0_OFFSET = 9'h 104;
  parameter RV_TIMER_TIMER_V_UPPER0_OFFSET = 9'h 108;
  parameter RV_TIMER_COMPARE_LOWER0_0_OFFSET = 9'h 10c;
  parameter RV_TIMER_COMPARE_UPPER0_0_OFFSET = 9'h 110;
  parameter RV_TIMER_INTR_ENABLE0_OFFSET = 9'h 114;
  parameter RV_TIMER_INTR_STATE0_OFFSET = 9'h 118;
  parameter RV_TIMER_INTR_TEST0_OFFSET = 9'h 11c;


  // Register Index
  typedef enum int {
    RV_TIMER_CTRL,
    RV_TIMER_CFG0,
    RV_TIMER_TIMER_V_LOWER0,
    RV_TIMER_TIMER_V_UPPER0,
    RV_TIMER_COMPARE_LOWER0_0,
    RV_TIMER_COMPARE_UPPER0_0,
    RV_TIMER_INTR_ENABLE0,
    RV_TIMER_INTR_STATE0,
    RV_TIMER_INTR_TEST0
  } rv_timer_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] RV_TIMER_PERMIT [9] = '{
    4'b 0001, // index[0] RV_TIMER_CTRL
    4'b 1111, // index[1] RV_TIMER_CFG0
    4'b 1111, // index[2] RV_TIMER_TIMER_V_LOWER0
    4'b 1111, // index[3] RV_TIMER_TIMER_V_UPPER0
    4'b 1111, // index[4] RV_TIMER_COMPARE_LOWER0_0
    4'b 1111, // index[5] RV_TIMER_COMPARE_UPPER0_0
    4'b 0001, // index[6] RV_TIMER_INTR_ENABLE0
    4'b 0001, // index[7] RV_TIMER_INTR_STATE0
    4'b 0001  // index[8] RV_TIMER_INTR_TEST0
  };
endpackage

