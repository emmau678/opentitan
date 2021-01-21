// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package i2c_reg_pkg;

  // Address width within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    struct packed {
      logic        q;
    } fmt_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } fmt_overflow;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } nak;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } trans_complete;
    struct packed {
      logic        q;
    } tx_empty;
    struct packed {
      logic        q;
    } tx_nonempty;
    struct packed {
      logic        q;
    } tx_overflow;
    struct packed {
      logic        q;
    } acq_overflow;
    struct packed {
      logic        q;
    } ack_stop;
    struct packed {
      logic        q;
    } host_timeout;
  } i2c_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } fmt_watermark;
    struct packed {
      logic        q;
    } rx_watermark;
    struct packed {
      logic        q;
    } fmt_overflow;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } nak;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } trans_complete;
    struct packed {
      logic        q;
    } tx_empty;
    struct packed {
      logic        q;
    } tx_nonempty;
    struct packed {
      logic        q;
    } tx_overflow;
    struct packed {
      logic        q;
    } acq_overflow;
    struct packed {
      logic        q;
    } ack_stop;
    struct packed {
      logic        q;
    } host_timeout;
  } i2c_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fmt_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } rx_watermark;
    struct packed {
      logic        q;
      logic        qe;
    } fmt_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } rx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } nak;
    struct packed {
      logic        q;
      logic        qe;
    } scl_interference;
    struct packed {
      logic        q;
      logic        qe;
    } sda_interference;
    struct packed {
      logic        q;
      logic        qe;
    } stretch_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } sda_unstable;
    struct packed {
      logic        q;
      logic        qe;
    } trans_complete;
    struct packed {
      logic        q;
      logic        qe;
    } tx_empty;
    struct packed {
      logic        q;
      logic        qe;
    } tx_nonempty;
    struct packed {
      logic        q;
      logic        qe;
    } tx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } acq_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } ack_stop;
    struct packed {
      logic        q;
      logic        qe;
    } host_timeout;
  } i2c_reg2hw_intr_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enablehost;
    struct packed {
      logic        q;
    } enabletarget;
  } i2c_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } i2c_reg2hw_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
      logic        qe;
    } fbyte;
    struct packed {
      logic        q;
      logic        qe;
    } start;
    struct packed {
      logic        q;
      logic        qe;
    } stop;
    struct packed {
      logic        q;
      logic        qe;
    } read;
    struct packed {
      logic        q;
      logic        qe;
    } rcont;
    struct packed {
      logic        q;
      logic        qe;
    } nakok;
  } i2c_reg2hw_fdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } rxrst;
    struct packed {
      logic        q;
      logic        qe;
    } fmtrst;
    struct packed {
      logic [2:0]  q;
      logic        qe;
    } rxilvl;
    struct packed {
      logic [1:0]  q;
      logic        qe;
    } fmtilvl;
    struct packed {
      logic        q;
      logic        qe;
    } acqrst;
    struct packed {
      logic        q;
      logic        qe;
    } txrst;
  } i2c_reg2hw_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } txovrden;
    struct packed {
      logic        q;
    } sclval;
    struct packed {
      logic        q;
    } sdaval;
  } i2c_reg2hw_ovrd_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } thigh;
    struct packed {
      logic [15:0] q;
    } tlow;
  } i2c_reg2hw_timing0_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } t_r;
    struct packed {
      logic [15:0] q;
    } t_f;
  } i2c_reg2hw_timing1_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } tsu_sta;
    struct packed {
      logic [15:0] q;
    } thd_sta;
  } i2c_reg2hw_timing2_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } tsu_dat;
    struct packed {
      logic [15:0] q;
    } thd_dat;
  } i2c_reg2hw_timing3_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } tsu_sto;
    struct packed {
      logic [15:0] q;
    } t_buf;
  } i2c_reg2hw_timing4_reg_t;

  typedef struct packed {
    struct packed {
      logic [30:0] q;
    } val;
    struct packed {
      logic        q;
    } en;
  } i2c_reg2hw_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [6:0]  q;
    } address0;
    struct packed {
      logic [6:0]  q;
    } mask0;
    struct packed {
      logic [6:0]  q;
    } address1;
    struct packed {
      logic [6:0]  q;
    } mask1;
  } i2c_reg2hw_target_id_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  q;
      logic        re;
    } abyte;
    struct packed {
      logic [1:0]  q;
      logic        re;
    } signal;
  } i2c_reg2hw_acqdata_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } i2c_reg2hw_txdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } enableaddr;
    struct packed {
      logic        q;
    } enabletx;
    struct packed {
      logic        q;
    } enableacq;
    struct packed {
      logic        q;
    } stop;
  } i2c_reg2hw_stretch_ctrl_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } i2c_reg2hw_host_timeout_ctrl_reg_t;


  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } fmt_watermark;
    struct packed {
      logic        d;
      logic        de;
    } rx_watermark;
    struct packed {
      logic        d;
      logic        de;
    } fmt_overflow;
    struct packed {
      logic        d;
      logic        de;
    } rx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } nak;
    struct packed {
      logic        d;
      logic        de;
    } scl_interference;
    struct packed {
      logic        d;
      logic        de;
    } sda_interference;
    struct packed {
      logic        d;
      logic        de;
    } stretch_timeout;
    struct packed {
      logic        d;
      logic        de;
    } sda_unstable;
    struct packed {
      logic        d;
      logic        de;
    } trans_complete;
    struct packed {
      logic        d;
      logic        de;
    } tx_empty;
    struct packed {
      logic        d;
      logic        de;
    } tx_nonempty;
    struct packed {
      logic        d;
      logic        de;
    } tx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } acq_overflow;
    struct packed {
      logic        d;
      logic        de;
    } ack_stop;
    struct packed {
      logic        d;
      logic        de;
    } host_timeout;
  } i2c_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } fmtfull;
    struct packed {
      logic        d;
    } rxfull;
    struct packed {
      logic        d;
    } fmtempty;
    struct packed {
      logic        d;
    } hostidle;
    struct packed {
      logic        d;
    } targetidle;
    struct packed {
      logic        d;
    } rxempty;
    struct packed {
      logic        d;
    } txfull;
    struct packed {
      logic        d;
    } acqfull;
    struct packed {
      logic        d;
    } txempty;
    struct packed {
      logic        d;
    } acqempty;
  } i2c_hw2reg_status_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } i2c_hw2reg_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  d;
    } fmtlvl;
    struct packed {
      logic [5:0]  d;
    } txlvl;
    struct packed {
      logic [5:0]  d;
    } rxlvl;
    struct packed {
      logic [5:0]  d;
    } acqlvl;
  } i2c_hw2reg_fifo_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } scl_rx;
    struct packed {
      logic [15:0] d;
    } sda_rx;
  } i2c_hw2reg_val_reg_t;

  typedef struct packed {
    struct packed {
      logic [7:0]  d;
    } abyte;
    struct packed {
      logic [1:0]  d;
    } signal;
  } i2c_hw2reg_acqdata_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    i2c_reg2hw_intr_state_reg_t intr_state; // [388:373]
    i2c_reg2hw_intr_enable_reg_t intr_enable; // [372:357]
    i2c_reg2hw_intr_test_reg_t intr_test; // [356:325]
    i2c_reg2hw_ctrl_reg_t ctrl; // [324:323]
    i2c_reg2hw_rdata_reg_t rdata; // [322:314]
    i2c_reg2hw_fdata_reg_t fdata; // [313:295]
    i2c_reg2hw_fifo_ctrl_reg_t fifo_ctrl; // [294:280]
    i2c_reg2hw_ovrd_reg_t ovrd; // [279:277]
    i2c_reg2hw_timing0_reg_t timing0; // [276:245]
    i2c_reg2hw_timing1_reg_t timing1; // [244:213]
    i2c_reg2hw_timing2_reg_t timing2; // [212:181]
    i2c_reg2hw_timing3_reg_t timing3; // [180:149]
    i2c_reg2hw_timing4_reg_t timing4; // [148:117]
    i2c_reg2hw_timeout_ctrl_reg_t timeout_ctrl; // [116:85]
    i2c_reg2hw_target_id_reg_t target_id; // [84:57]
    i2c_reg2hw_acqdata_reg_t acqdata; // [56:45]
    i2c_reg2hw_txdata_reg_t txdata; // [44:36]
    i2c_reg2hw_stretch_ctrl_reg_t stretch_ctrl; // [35:32]
    i2c_reg2hw_host_timeout_ctrl_reg_t host_timeout_ctrl; // [31:0]
  } i2c_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    i2c_hw2reg_intr_state_reg_t intr_state; // [115:84]
    i2c_hw2reg_status_reg_t status; // [83:74]
    i2c_hw2reg_rdata_reg_t rdata; // [73:66]
    i2c_hw2reg_fifo_status_reg_t fifo_status; // [65:42]
    i2c_hw2reg_val_reg_t val; // [41:10]
    i2c_hw2reg_acqdata_reg_t acqdata; // [9:0]
  } i2c_hw2reg_t;

  // Register Address
  parameter logic [BlockAw-1:0] I2C_INTR_STATE_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] I2C_INTR_ENABLE_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] I2C_INTR_TEST_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] I2C_CTRL_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] I2C_STATUS_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] I2C_RDATA_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] I2C_FDATA_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] I2C_FIFO_CTRL_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] I2C_FIFO_STATUS_OFFSET = 7'h 20;
  parameter logic [BlockAw-1:0] I2C_OVRD_OFFSET = 7'h 24;
  parameter logic [BlockAw-1:0] I2C_VAL_OFFSET = 7'h 28;
  parameter logic [BlockAw-1:0] I2C_TIMING0_OFFSET = 7'h 2c;
  parameter logic [BlockAw-1:0] I2C_TIMING1_OFFSET = 7'h 30;
  parameter logic [BlockAw-1:0] I2C_TIMING2_OFFSET = 7'h 34;
  parameter logic [BlockAw-1:0] I2C_TIMING3_OFFSET = 7'h 38;
  parameter logic [BlockAw-1:0] I2C_TIMING4_OFFSET = 7'h 3c;
  parameter logic [BlockAw-1:0] I2C_TIMEOUT_CTRL_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] I2C_TARGET_ID_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] I2C_ACQDATA_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] I2C_TXDATA_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] I2C_STRETCH_CTRL_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] I2C_HOST_TIMEOUT_CTRL_OFFSET = 7'h 54;


  // Register Index
  typedef enum int {
    I2C_INTR_STATE,
    I2C_INTR_ENABLE,
    I2C_INTR_TEST,
    I2C_CTRL,
    I2C_STATUS,
    I2C_RDATA,
    I2C_FDATA,
    I2C_FIFO_CTRL,
    I2C_FIFO_STATUS,
    I2C_OVRD,
    I2C_VAL,
    I2C_TIMING0,
    I2C_TIMING1,
    I2C_TIMING2,
    I2C_TIMING3,
    I2C_TIMING4,
    I2C_TIMEOUT_CTRL,
    I2C_TARGET_ID,
    I2C_ACQDATA,
    I2C_TXDATA,
    I2C_STRETCH_CTRL,
    I2C_HOST_TIMEOUT_CTRL
  } i2c_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] I2C_PERMIT [22] = '{
    4'b 0011, // index[ 0] I2C_INTR_STATE
    4'b 0011, // index[ 1] I2C_INTR_ENABLE
    4'b 0011, // index[ 2] I2C_INTR_TEST
    4'b 0001, // index[ 3] I2C_CTRL
    4'b 0011, // index[ 4] I2C_STATUS
    4'b 0001, // index[ 5] I2C_RDATA
    4'b 0011, // index[ 6] I2C_FDATA
    4'b 0011, // index[ 7] I2C_FIFO_CTRL
    4'b 1111, // index[ 8] I2C_FIFO_STATUS
    4'b 0001, // index[ 9] I2C_OVRD
    4'b 1111, // index[10] I2C_VAL
    4'b 1111, // index[11] I2C_TIMING0
    4'b 1111, // index[12] I2C_TIMING1
    4'b 1111, // index[13] I2C_TIMING2
    4'b 1111, // index[14] I2C_TIMING3
    4'b 1111, // index[15] I2C_TIMING4
    4'b 1111, // index[16] I2C_TIMEOUT_CTRL
    4'b 1111, // index[17] I2C_TARGET_ID
    4'b 0011, // index[18] I2C_ACQDATA
    4'b 0001, // index[19] I2C_TXDATA
    4'b 0001, // index[20] I2C_STRETCH_CTRL
    4'b 1111  // index[21] I2C_HOST_TIMEOUT_CTRL
  };
endpackage

