// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package pwm_reg_pkg;

  // Param list
  parameter int NOutputs = 6;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    logic        q;
    logic        qe;
  } pwm_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } cntr_en;
    struct packed {
      logic [3:0]  q;
      logic        qe;
    } dc_resn;
    struct packed {
      logic [26:0] q;
      logic        qe;
    } clk_div;
  } pwm_reg2hw_cfg_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } pwm_reg2hw_pwm_en_mreg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } pwm_reg2hw_invert_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } blink_en;
    struct packed {
      logic        q;
      logic        qe;
    } htbt_en;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } phase_delay;
  } pwm_reg2hw_pwm_param_mreg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } b;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } a;
  } pwm_reg2hw_duty_cycle_mreg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
      logic        qe;
    } y;
    struct packed {
      logic [15:0] q;
      logic        qe;
    } x;
  } pwm_reg2hw_blink_param_mreg_t;

  // Register -> HW type
  typedef struct packed {
    pwm_reg2hw_alert_test_reg_t alert_test; // [594:593]
    pwm_reg2hw_cfg_reg_t cfg; // [592:558]
    pwm_reg2hw_pwm_en_mreg_t [5:0] pwm_en; // [557:546]
    pwm_reg2hw_invert_mreg_t [5:0] invert; // [545:534]
    pwm_reg2hw_pwm_param_mreg_t [5:0] pwm_param; // [533:408]
    pwm_reg2hw_duty_cycle_mreg_t [5:0] duty_cycle; // [407:204]
    pwm_reg2hw_blink_param_mreg_t [5:0] blink_param; // [203:0]
  } pwm_reg2hw_t;

  // Register offsets
  parameter logic [BlockAw-1:0] PWM_ALERT_TEST_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] PWM_REGWEN_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] PWM_CFG_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] PWM_PWM_EN_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] PWM_INVERT_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_0_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_1_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_2_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_3_OFFSET = 7'h 20;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_4_OFFSET = 7'h 24;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_5_OFFSET = 7'h 28;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_0_OFFSET = 7'h 2c;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_1_OFFSET = 7'h 30;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_2_OFFSET = 7'h 34;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_3_OFFSET = 7'h 38;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_4_OFFSET = 7'h 3c;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_5_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_0_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_1_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_2_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_3_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_4_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_5_OFFSET = 7'h 58;

  // Reset values for hwext registers and their fields
  parameter logic [0:0] PWM_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] PWM_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;

  // Register index
  typedef enum int {
    PWM_ALERT_TEST,
    PWM_REGWEN,
    PWM_CFG,
    PWM_PWM_EN,
    PWM_INVERT,
    PWM_PWM_PARAM_0,
    PWM_PWM_PARAM_1,
    PWM_PWM_PARAM_2,
    PWM_PWM_PARAM_3,
    PWM_PWM_PARAM_4,
    PWM_PWM_PARAM_5,
    PWM_DUTY_CYCLE_0,
    PWM_DUTY_CYCLE_1,
    PWM_DUTY_CYCLE_2,
    PWM_DUTY_CYCLE_3,
    PWM_DUTY_CYCLE_4,
    PWM_DUTY_CYCLE_5,
    PWM_BLINK_PARAM_0,
    PWM_BLINK_PARAM_1,
    PWM_BLINK_PARAM_2,
    PWM_BLINK_PARAM_3,
    PWM_BLINK_PARAM_4,
    PWM_BLINK_PARAM_5
  } pwm_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] PWM_PERMIT [23] = '{
    4'b 0001, // index[ 0] PWM_ALERT_TEST
    4'b 0001, // index[ 1] PWM_REGWEN
    4'b 1111, // index[ 2] PWM_CFG
    4'b 0001, // index[ 3] PWM_PWM_EN
    4'b 0001, // index[ 4] PWM_INVERT
    4'b 1111, // index[ 5] PWM_PWM_PARAM_0
    4'b 1111, // index[ 6] PWM_PWM_PARAM_1
    4'b 1111, // index[ 7] PWM_PWM_PARAM_2
    4'b 1111, // index[ 8] PWM_PWM_PARAM_3
    4'b 1111, // index[ 9] PWM_PWM_PARAM_4
    4'b 1111, // index[10] PWM_PWM_PARAM_5
    4'b 1111, // index[11] PWM_DUTY_CYCLE_0
    4'b 1111, // index[12] PWM_DUTY_CYCLE_1
    4'b 1111, // index[13] PWM_DUTY_CYCLE_2
    4'b 1111, // index[14] PWM_DUTY_CYCLE_3
    4'b 1111, // index[15] PWM_DUTY_CYCLE_4
    4'b 1111, // index[16] PWM_DUTY_CYCLE_5
    4'b 1111, // index[17] PWM_BLINK_PARAM_0
    4'b 1111, // index[18] PWM_BLINK_PARAM_1
    4'b 1111, // index[19] PWM_BLINK_PARAM_2
    4'b 1111, // index[20] PWM_BLINK_PARAM_3
    4'b 1111, // index[21] PWM_BLINK_PARAM_4
    4'b 1111  // index[22] PWM_BLINK_PARAM_5
  };

endpackage
