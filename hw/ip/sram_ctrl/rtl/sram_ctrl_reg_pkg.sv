// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package sram_ctrl_reg_pkg;

  // Param list

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic        q;
  } sram_ctrl_reg2hw_intr_state_reg_t;

  typedef struct packed {
    logic        q;
  } sram_ctrl_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } sram_ctrl_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } sram_ctrl_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } sram_ctrl_reg2hw_sram_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } correctable;
    struct packed {
      logic        q;
    } uncorrectable;
  } sram_ctrl_reg2hw_error_type_reg_t;


  typedef struct packed {
    logic        d;
    logic        de;
  } sram_ctrl_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } error;
    struct packed {
      logic        d;
    } scr_key_valid;
    struct packed {
      logic        d;
    } scr_key_seed_valid;
  } sram_ctrl_hw2reg_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } correctable;
    struct packed {
      logic        d;
      logic        de;
    } uncorrectable;
  } sram_ctrl_hw2reg_error_type_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } sram_ctrl_hw2reg_error_address_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    sram_ctrl_reg2hw_intr_state_reg_t intr_state; // [15:15]
    sram_ctrl_reg2hw_intr_enable_reg_t intr_enable; // [14:14]
    sram_ctrl_reg2hw_intr_test_reg_t intr_test; // [13:12]
    sram_ctrl_reg2hw_ctrl_reg_t ctrl; // [11:10]
    sram_ctrl_reg2hw_sram_cfg_reg_t sram_cfg; // [9:2]
    sram_ctrl_reg2hw_error_type_reg_t error_type; // [1:0]
  } sram_ctrl_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    sram_ctrl_hw2reg_intr_state_reg_t intr_state; // [41:40]
    sram_ctrl_hw2reg_status_reg_t status; // [39:37]
    sram_ctrl_hw2reg_error_type_reg_t error_type; // [36:33]
    sram_ctrl_hw2reg_error_address_reg_t error_address; // [32:0]
  } sram_ctrl_hw2reg_t;

  // Register Address
  parameter logic [5:0] SRAM_CTRL_INTR_STATE_OFFSET = 6'h 0;
  parameter logic [5:0] SRAM_CTRL_INTR_ENABLE_OFFSET = 6'h 4;
  parameter logic [5:0] SRAM_CTRL_INTR_TEST_OFFSET = 6'h 8;
  parameter logic [5:0] SRAM_CTRL_STATUS_OFFSET = 6'h c;
  parameter logic [5:0] SRAM_CTRL_CTRL_REGWEN_OFFSET = 6'h 10;
  parameter logic [5:0] SRAM_CTRL_CTRL_OFFSET = 6'h 14;
  parameter logic [5:0] SRAM_CTRL_SRAM_CFG_REGWEN_OFFSET = 6'h 18;
  parameter logic [5:0] SRAM_CTRL_SRAM_CFG_OFFSET = 6'h 1c;
  parameter logic [5:0] SRAM_CTRL_ERROR_TYPE_OFFSET = 6'h 20;
  parameter logic [5:0] SRAM_CTRL_ERROR_ADDRESS_OFFSET = 6'h 24;


  // Register Index
  typedef enum int {
    SRAM_CTRL_INTR_STATE,
    SRAM_CTRL_INTR_ENABLE,
    SRAM_CTRL_INTR_TEST,
    SRAM_CTRL_STATUS,
    SRAM_CTRL_CTRL_REGWEN,
    SRAM_CTRL_CTRL,
    SRAM_CTRL_SRAM_CFG_REGWEN,
    SRAM_CTRL_SRAM_CFG,
    SRAM_CTRL_ERROR_TYPE,
    SRAM_CTRL_ERROR_ADDRESS
  } sram_ctrl_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] SRAM_CTRL_PERMIT [10] = '{
    4'b 0001, // index[0] SRAM_CTRL_INTR_STATE
    4'b 0001, // index[1] SRAM_CTRL_INTR_ENABLE
    4'b 0001, // index[2] SRAM_CTRL_INTR_TEST
    4'b 0001, // index[3] SRAM_CTRL_STATUS
    4'b 0001, // index[4] SRAM_CTRL_CTRL_REGWEN
    4'b 0001, // index[5] SRAM_CTRL_CTRL
    4'b 0001, // index[6] SRAM_CTRL_SRAM_CFG_REGWEN
    4'b 0001, // index[7] SRAM_CTRL_SRAM_CFG
    4'b 0001, // index[8] SRAM_CTRL_ERROR_TYPE
    4'b 1111  // index[9] SRAM_CTRL_ERROR_ADDRESS
  };
endpackage

