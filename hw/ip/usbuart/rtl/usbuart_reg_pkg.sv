// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package usbuart_reg_pkg;

  // Address width within the block
  parameter int BlockAw = 6;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } tx_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } tx_overflow;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } rx_frame_err;
    struct packed {
      logic        q;
    } rx_break_err;
    struct packed {
      logic        q;
    } rx_timeout;
    struct packed {
      logic        q;
    } rx_parity_err;
  } usbuart_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } tx_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } tx_overflow;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } rx_frame_err;
    struct packed {
      logic        q;
    } rx_break_err;
    struct packed {
      logic        q;
    } rx_timeout;
    struct packed {
      logic        q;
    } rx_parity_err;
  } usbuart_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } tx_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } rx_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } tx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } rx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } rx_frame_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_break_err;
    struct packed {
      logic        q;
      logic        qe;
    } rx_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } rx_parity_err;
  } usbuart_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } tx;
    struct packed {
      logic        q;
    } rx;
    struct packed {
      logic        q;
    } nf;
    struct packed {
      logic        q;
    } slpbk;
    struct packed {
      logic        q;
    } llpbk;
    struct packed {
      logic        q;
    } parity_en;
    struct packed {
      logic        q;
    } parity_odd;
    struct packed {
      logic [1:0]  q;
    } rxblvl;
    struct packed {
      logic [15:0] q;
    } nco;
  } usbuart_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } usbuart_reg2hw_rdata_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } usbuart_reg2hw_wdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } rxrst;
    struct packed {
      logic        q;
      logic        qe;
    } txrst;
    struct packed {
      logic [2:0]  q;
      logic        qe;
    } rxilvl;
    struct packed {
      logic [1:0]  q;
      logic        qe;
    } txilvl;
  } usbuart_reg2hw_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } txen;
    struct packed {
      logic        q;
    } txval;
  } usbuart_reg2hw_ovrd_reg_t;

  typedef struct packed {
    struct packed {
      logic [23:0] q;
    } val;
    struct packed {
      logic        q;
    } en;
  } usbuart_reg2hw_timeout_ctrl_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } tx_watermark;
    struct packed {
      logic        d;
      logic        de;
    } rx_watermark;
    struct packed {
      logic        d;
      logic        de;
    } tx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } rx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } rx_frame_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_break_err;
    struct packed {
      logic        d;
      logic        de;
    } rx_timeout;
    struct packed {
      logic        d;
      logic        de;
    } rx_parity_err;
  } usbuart_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } txfull;
    struct packed {
      logic        d;
    } rxfull;
    struct packed {
      logic        d;
    } txempty;
    struct packed {
      logic        d;
    } txidle;
    struct packed {
      logic        d;
    } rxidle;
    struct packed {
      logic        d;
    } rxempty;
  } usbuart_hw2reg_status_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } usbuart_hw2reg_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } rxrst;
    struct packed {
      logic        d;
      logic        de;
    } txrst;
    struct packed {
      logic [2:0]  d;
      logic        de;
    } rxilvl;
    struct packed {
      logic [1:0]  d;
      logic        de;
    } txilvl;
  } usbuart_hw2reg_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  d;
    } txlvl;
    struct packed {
      logic [5:0]  d;
    } rxlvl;
  } usbuart_hw2reg_fifo_status_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } usbuart_hw2reg_val_reg_t;

  typedef struct packed {
    struct packed {
      logic [10:0] d;
    } frame;
    struct packed {
      logic        d;
    } host_timeout;
    struct packed {
      logic        d;
    } host_lost;
    struct packed {
      logic [6:0]  d;
    } device_address;
  } usbuart_hw2reg_usbstat_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } baud_req;
    struct packed {
      logic [1:0]  d;
    } parity_req;
  } usbuart_hw2reg_usbparam_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    usbuart_reg2hw_intr_state_reg_t intr_state; // [112:105]
    usbuart_reg2hw_intr_enable_reg_t intr_enable; // [104:97]
    usbuart_reg2hw_intr_test_reg_t intr_test; // [96:81]
    usbuart_reg2hw_ctrl_reg_t ctrl; // [80:56]
    usbuart_reg2hw_rdata_reg_t rdata; // [55:47]
    usbuart_reg2hw_wdata_reg_t wdata; // [46:38]
    usbuart_reg2hw_fifo_ctrl_reg_t fifo_ctrl; // [37:27]
    usbuart_reg2hw_ovrd_reg_t ovrd; // [26:25]
    usbuart_reg2hw_timeout_ctrl_reg_t timeout_ctrl; // [24:0]
  } usbuart_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    usbuart_hw2reg_intr_state_reg_t intr_state; // [106:91]
    usbuart_hw2reg_status_reg_t status; // [90:85]
    usbuart_hw2reg_rdata_reg_t rdata; // [84:77]
    usbuart_hw2reg_fifo_ctrl_reg_t fifo_ctrl; // [76:66]
    usbuart_hw2reg_fifo_status_reg_t fifo_status; // [65:54]
    usbuart_hw2reg_val_reg_t val; // [53:38]
    usbuart_hw2reg_usbstat_reg_t usbstat; // [37:18]
    usbuart_hw2reg_usbparam_reg_t usbparam; // [17:0]
  } usbuart_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] USBUART_INTR_STATE_OFFSET = 6'h 0;
  parameter logic [BlockAw-1:0] USBUART_INTR_ENABLE_OFFSET = 6'h 4;
  parameter logic [BlockAw-1:0] USBUART_INTR_TEST_OFFSET = 6'h 8;
  parameter logic [BlockAw-1:0] USBUART_CTRL_OFFSET = 6'h c;
  parameter logic [BlockAw-1:0] USBUART_STATUS_OFFSET = 6'h 10;
  parameter logic [BlockAw-1:0] USBUART_RDATA_OFFSET = 6'h 14;
  parameter logic [BlockAw-1:0] USBUART_WDATA_OFFSET = 6'h 18;
  parameter logic [BlockAw-1:0] USBUART_FIFO_CTRL_OFFSET = 6'h 1c;
  parameter logic [BlockAw-1:0] USBUART_FIFO_STATUS_OFFSET = 6'h 20;
  parameter logic [BlockAw-1:0] USBUART_OVRD_OFFSET = 6'h 24;
  parameter logic [BlockAw-1:0] USBUART_VAL_OFFSET = 6'h 28;
  parameter logic [BlockAw-1:0] USBUART_TIMEOUT_CTRL_OFFSET = 6'h 2c;
  parameter logic [BlockAw-1:0] USBUART_USBSTAT_OFFSET = 6'h 30;
  parameter logic [BlockAw-1:0] USBUART_USBPARAM_OFFSET = 6'h 34;


  // Register Index
  typedef enum int {
    USBUART_INTR_STATE,
    USBUART_INTR_ENABLE,
    USBUART_INTR_TEST,
    USBUART_CTRL,
    USBUART_STATUS,
    USBUART_RDATA,
    USBUART_WDATA,
    USBUART_FIFO_CTRL,
    USBUART_FIFO_STATUS,
    USBUART_OVRD,
    USBUART_VAL,
    USBUART_TIMEOUT_CTRL,
    USBUART_USBSTAT,
    USBUART_USBPARAM
  } usbuart_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] USBUART_PERMIT [14] = '{
    4'b 0001, // index[ 0] USBUART_INTR_STATE
    4'b 0001, // index[ 1] USBUART_INTR_ENABLE
    4'b 0001, // index[ 2] USBUART_INTR_TEST
    4'b 1111, // index[ 3] USBUART_CTRL
    4'b 0001, // index[ 4] USBUART_STATUS
    4'b 0001, // index[ 5] USBUART_RDATA
    4'b 0001, // index[ 6] USBUART_WDATA
    4'b 0001, // index[ 7] USBUART_FIFO_CTRL
    4'b 0111, // index[ 8] USBUART_FIFO_STATUS
    4'b 0001, // index[ 9] USBUART_OVRD
    4'b 0011, // index[10] USBUART_VAL
    4'b 1111, // index[11] USBUART_TIMEOUT_CTRL
    4'b 0111, // index[12] USBUART_USBSTAT
    4'b 0111  // index[13] USBUART_USBPARAM
  };
endpackage

