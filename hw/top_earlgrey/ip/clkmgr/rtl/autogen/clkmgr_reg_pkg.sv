// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package clkmgr_reg_pkg;

  // Param list
  parameter int NumGroups = 7;
  parameter int NumSwGateableClocks = 4;
  parameter int NumHintableClocks = 5;
  parameter int NumAlerts = 2;

  // Address widths within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } recov_fault;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_fault;
  } clkmgr_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic [3:0]  q;
    } sel;
    struct packed {
      logic [3:0]  q;
    } step_down;
  } clkmgr_reg2hw_extclk_ctrl_reg_t;

  typedef struct packed {
    logic        q;
  } clkmgr_reg2hw_jitter_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } clk_io_div4_peri_en;
    struct packed {
      logic        q;
    } clk_io_div2_peri_en;
    struct packed {
      logic        q;
    } clk_io_peri_en;
    struct packed {
      logic        q;
    } clk_usb_peri_en;
  } clkmgr_reg2hw_clk_enables_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } clk_main_aes_hint;
    struct packed {
      logic        q;
    } clk_main_hmac_hint;
    struct packed {
      logic        q;
    } clk_main_kmac_hint;
    struct packed {
      logic        q;
    } clk_io_div4_otbn_hint;
    struct packed {
      logic        q;
    } clk_main_otbn_hint;
  } clkmgr_reg2hw_clk_hints_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [9:0] q;
    } max_thresh;
    struct packed {
      logic [9:0] q;
    } min_thresh;
  } clkmgr_reg2hw_io_measure_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [8:0]  q;
    } max_thresh;
    struct packed {
      logic [8:0]  q;
    } min_thresh;
  } clkmgr_reg2hw_io_div2_measure_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [7:0]  q;
    } max_thresh;
    struct packed {
      logic [7:0]  q;
    } min_thresh;
  } clkmgr_reg2hw_io_div4_measure_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [9:0] q;
    } max_thresh;
    struct packed {
      logic [9:0] q;
    } min_thresh;
  } clkmgr_reg2hw_main_measure_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [8:0]  q;
    } max_thresh;
    struct packed {
      logic [8:0]  q;
    } min_thresh;
  } clkmgr_reg2hw_usb_measure_ctrl_reg_t;

  typedef struct packed {
    logic        q;
  } clkmgr_reg2hw_fatal_err_code_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } clk_main_aes_val;
    struct packed {
      logic        d;
      logic        de;
    } clk_main_hmac_val;
    struct packed {
      logic        d;
      logic        de;
    } clk_main_kmac_val;
    struct packed {
      logic        d;
      logic        de;
    } clk_io_div4_otbn_val;
    struct packed {
      logic        d;
      logic        de;
    } clk_main_otbn_val;
  } clkmgr_hw2reg_clk_hints_status_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } io_measure_err;
    struct packed {
      logic        d;
      logic        de;
    } io_div2_measure_err;
    struct packed {
      logic        d;
      logic        de;
    } io_div4_measure_err;
    struct packed {
      logic        d;
      logic        de;
    } main_measure_err;
    struct packed {
      logic        d;
      logic        de;
    } usb_measure_err;
  } clkmgr_hw2reg_recov_err_code_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } clkmgr_hw2reg_fatal_err_code_reg_t;

  // Register -> HW type
  typedef struct packed {
    clkmgr_reg2hw_alert_test_reg_t alert_test; // [119:116]
    clkmgr_reg2hw_extclk_ctrl_reg_t extclk_ctrl; // [115:108]
    clkmgr_reg2hw_jitter_enable_reg_t jitter_enable; // [107:107]
    clkmgr_reg2hw_clk_enables_reg_t clk_enables; // [106:103]
    clkmgr_reg2hw_clk_hints_reg_t clk_hints; // [102:98]
    clkmgr_reg2hw_io_measure_ctrl_reg_t io_measure_ctrl; // [97:77]
    clkmgr_reg2hw_io_div2_measure_ctrl_reg_t io_div2_measure_ctrl; // [76:58]
    clkmgr_reg2hw_io_div4_measure_ctrl_reg_t io_div4_measure_ctrl; // [57:41]
    clkmgr_reg2hw_main_measure_ctrl_reg_t main_measure_ctrl; // [40:20]
    clkmgr_reg2hw_usb_measure_ctrl_reg_t usb_measure_ctrl; // [19:1]
    clkmgr_reg2hw_fatal_err_code_reg_t fatal_err_code; // [0:0]
  } clkmgr_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    clkmgr_hw2reg_clk_hints_status_reg_t clk_hints_status; // [21:12]
    clkmgr_hw2reg_recov_err_code_reg_t recov_err_code; // [11:2]
    clkmgr_hw2reg_fatal_err_code_reg_t fatal_err_code; // [1:0]
  } clkmgr_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] CLKMGR_ALERT_TEST_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] CLKMGR_EXTCLK_CTRL_REGWEN_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] CLKMGR_EXTCLK_CTRL_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] CLKMGR_JITTER_ENABLE_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] CLKMGR_CLK_ENABLES_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] CLKMGR_CLK_HINTS_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] CLKMGR_CLK_HINTS_STATUS_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] CLKMGR_MEASURE_CTRL_REGWEN_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] CLKMGR_IO_MEASURE_CTRL_OFFSET = 6'h 20;
  parameter logic [BlockAw-1:0] CLKMGR_IO_DIV2_MEASURE_CTRL_OFFSET = 6'h 24;
  parameter logic [BlockAw-1:0] CLKMGR_IO_DIV4_MEASURE_CTRL_OFFSET = 6'h 28;
  parameter logic [BlockAw-1:0] CLKMGR_MAIN_MEASURE_CTRL_OFFSET = 6'h 2c;
  parameter logic [BlockAw-1:0] CLKMGR_USB_MEASURE_CTRL_OFFSET = 6'h 30;
  parameter logic [BlockAw-1:0] CLKMGR_RECOV_ERR_CODE_OFFSET = 6'h 34;
  parameter logic [BlockAw-1:0] CLKMGR_FATAL_ERR_CODE_OFFSET = 6'h 38;

  // Reset values for hwext registers and their fields
  parameter logic [1:0] CLKMGR_ALERT_TEST_RESVAL = 2'h 0;
  parameter logic [0:0] CLKMGR_ALERT_TEST_RECOV_FAULT_RESVAL = 1'h 0;
  parameter logic [0:0] CLKMGR_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;

  // Register index
  typedef enum int {
    CLKMGR_ALERT_TEST,
    CLKMGR_EXTCLK_CTRL_REGWEN,
    CLKMGR_EXTCLK_CTRL,
    CLKMGR_JITTER_ENABLE,
    CLKMGR_CLK_ENABLES,
    CLKMGR_CLK_HINTS,
    CLKMGR_CLK_HINTS_STATUS,
    CLKMGR_MEASURE_CTRL_REGWEN,
    CLKMGR_IO_MEASURE_CTRL,
    CLKMGR_IO_DIV2_MEASURE_CTRL,
    CLKMGR_IO_DIV4_MEASURE_CTRL,
    CLKMGR_MAIN_MEASURE_CTRL,
    CLKMGR_USB_MEASURE_CTRL,
    CLKMGR_RECOV_ERR_CODE,
    CLKMGR_FATAL_ERR_CODE
  } clkmgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] CLKMGR_PERMIT [15] = '{
    4'b 0001, // index[ 0] CLKMGR_ALERT_TEST
    4'b 0001, // index[ 1] CLKMGR_EXTCLK_CTRL_REGWEN
    4'b 0001, // index[ 2] CLKMGR_EXTCLK_CTRL
    4'b 0001, // index[ 3] CLKMGR_JITTER_ENABLE
    4'b 0001, // index[ 4] CLKMGR_CLK_ENABLES
    4'b 0001, // index[ 5] CLKMGR_CLK_HINTS
    4'b 0001, // index[ 6] CLKMGR_CLK_HINTS_STATUS
    4'b 0001, // index[ 7] CLKMGR_MEASURE_CTRL_REGWEN
    4'b 0111, // index[ 8] CLKMGR_IO_MEASURE_CTRL
    4'b 0111, // index[ 9] CLKMGR_IO_DIV2_MEASURE_CTRL
    4'b 0111, // index[10] CLKMGR_IO_DIV4_MEASURE_CTRL
    4'b 0111, // index[11] CLKMGR_MAIN_MEASURE_CTRL
    4'b 0111, // index[12] CLKMGR_USB_MEASURE_CTRL
    4'b 0001, // index[13] CLKMGR_RECOV_ERR_CODE
    4'b 0001  // index[14] CLKMGR_FATAL_ERR_CODE
  };

endpackage

