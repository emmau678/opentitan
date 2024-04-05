// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package i2c_reg_pkg;

  // Param list
  parameter int FifoDepth = 64;
  parameter int AcqFifoDepth = 268;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 7;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } host_timeout;
    struct packed {
      logic        q;
    } unexp_stop;
    struct packed {
      logic        q;
    } acq_full;
    struct packed {
      logic        q;
    } tx_threshold;
    struct packed {
      logic        q;
    } tx_stretch;
    struct packed {
      logic        q;
    } cmd_complete;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } controller_halt;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } acq_threshold;
    struct packed {
      logic        q;
    } rx_threshold;
    struct packed {
      logic        q;
    } fmt_threshold;
  } i2c_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } host_timeout;
    struct packed {
      logic        q;
    } unexp_stop;
    struct packed {
      logic        q;
    } acq_full;
    struct packed {
      logic        q;
    } tx_threshold;
    struct packed {
      logic        q;
    } tx_stretch;
    struct packed {
      logic        q;
    } cmd_complete;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } controller_halt;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } acq_threshold;
    struct packed {
      logic        q;
    } rx_threshold;
    struct packed {
      logic        q;
    } fmt_threshold;
  } i2c_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } host_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } unexp_stop;
    struct packed {
      logic        q;
      logic        qe;
    } acq_full;
    struct packed {
      logic        q;
      logic        qe;
    } tx_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } tx_stretch;
    struct packed {
      logic        q;
      logic        qe;
    } cmd_complete;
    struct packed {
      logic        q;
      logic        qe;
    } sda_unstable;
    struct packed {
      logic        q;
      logic        qe;
    } stretch_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } sda_interference;
    struct packed {
      logic        q;
      logic        qe;
    } scl_interference;
    struct packed {
      logic        q;
      logic        qe;
    } controller_halt;
    struct packed {
      logic        q;
      logic        qe;
    } rx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } acq_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } rx_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } fmt_threshold;
  } i2c_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } i2c_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } nack_addr_after_timeout;
    struct packed {
      logic        q;
    } llpbk;
    struct packed {
      logic        q;
    } enabletarget;
    struct packed {
      logic        q;
    } enablehost;
  } i2c_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } i2c_reg2hw_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } nakok;
    struct packed {
      logic        q;
      logic        qe;
    } rcont;
    struct packed {
      logic        q;
      logic        qe;
    } readb;
    struct packed {
      logic        q;
      logic        qe;
    } stop;
    struct packed {
      logic        q;
      logic        qe;
    } start;
    struct packed {
      logic [7:0]  q;
      logic        qe;
    } fbyte;
  } i2c_reg2hw_fdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } txrst;
    struct packed {
      logic        q;
      logic        qe;
    } acqrst;
    struct packed {
      logic        q;
      logic        qe;
    } fmtrst;
    struct packed {
      logic        q;
      logic        qe;
    } rxrst;
  } i2c_reg2hw_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] q;
      logic        qe;
    } fmt_thresh;
    struct packed {
      logic [11:0] q;
      logic        qe;
    } rx_thresh;
  } i2c_reg2hw_host_fifo_config_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] q;
      logic        qe;
    } acq_thresh;
    struct packed {
      logic        q;
      logic        qe;
    } txrst_on_cond;
    struct packed {
      logic [11:0] q;
      logic        qe;
    } tx_thresh;
  } i2c_reg2hw_target_fifo_config_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } sdaval;
    struct packed {
      logic        q;
    } sclval;
    struct packed {
      logic        q;
    } txovrden;
  } i2c_reg2hw_ovrd_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } tlow;
    struct packed {
      logic [15:0] q;
    } thigh;
  } i2c_reg2hw_timing0_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } t_f;
    struct packed {
      logic [15:0] q;
    } t_r;
  } i2c_reg2hw_timing1_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } thd_sta;
    struct packed {
      logic [15:0] q;
    } tsu_sta;
  } i2c_reg2hw_timing2_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } thd_dat;
    struct packed {
      logic [15:0] q;
    } tsu_dat;
  } i2c_reg2hw_timing3_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] q;
    } t_buf;
    struct packed {
      logic [15:0] q;
    } tsu_sto;
  } i2c_reg2hw_timing4_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [30:0] q;
    } val;
  } i2c_reg2hw_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [6:0]  q;
    } mask1;
    struct packed {
      logic [6:0]  q;
    } address1;
    struct packed {
      logic [6:0]  q;
    } mask0;
    struct packed {
      logic [6:0]  q;
    } address0;
  } i2c_reg2hw_target_id_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  q;
      logic        re;
    } signal;
    struct packed {
      logic [7:0]  q;
      logic        re;
    } abyte;
  } i2c_reg2hw_acqdata_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } i2c_reg2hw_txdata_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } i2c_reg2hw_host_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [30:0] q;
    } val;
  } i2c_reg2hw_target_timeout_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } i2c_reg2hw_target_nack_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [30:0] q;
    } val;
  } i2c_reg2hw_host_nack_handler_timeout_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } unhandled_nack_timeout;
    struct packed {
      logic        q;
    } nack;
  } i2c_reg2hw_controller_events_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } fmt_threshold;
    struct packed {
      logic        d;
      logic        de;
    } rx_threshold;
    struct packed {
      logic        d;
      logic        de;
    } acq_threshold;
    struct packed {
      logic        d;
      logic        de;
    } rx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } controller_halt;
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
    } cmd_complete;
    struct packed {
      logic        d;
      logic        de;
    } tx_stretch;
    struct packed {
      logic        d;
      logic        de;
    } tx_threshold;
    struct packed {
      logic        d;
      logic        de;
    } acq_full;
    struct packed {
      logic        d;
      logic        de;
    } unexp_stop;
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
      logic [11:0] d;
    } fmtlvl;
    struct packed {
      logic [11:0] d;
    } rxlvl;
  } i2c_hw2reg_host_fifo_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] d;
    } txlvl;
    struct packed {
      logic [11:0] d;
    } acqlvl;
  } i2c_hw2reg_target_fifo_status_reg_t;

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
      logic [2:0]  d;
    } signal;
  } i2c_hw2reg_acqdata_reg_t;

  typedef struct packed {
    logic [7:0]  d;
    logic        de;
  } i2c_hw2reg_target_nack_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } nack;
    struct packed {
      logic        d;
      logic        de;
    } unhandled_nack_timeout;
  } i2c_hw2reg_controller_events_reg_t;

  // Register -> HW type
  typedef struct packed {
    i2c_reg2hw_intr_state_reg_t intr_state; // [506:492]
    i2c_reg2hw_intr_enable_reg_t intr_enable; // [491:477]
    i2c_reg2hw_intr_test_reg_t intr_test; // [476:447]
    i2c_reg2hw_alert_test_reg_t alert_test; // [446:445]
    i2c_reg2hw_ctrl_reg_t ctrl; // [444:441]
    i2c_reg2hw_rdata_reg_t rdata; // [440:432]
    i2c_reg2hw_fdata_reg_t fdata; // [431:413]
    i2c_reg2hw_fifo_ctrl_reg_t fifo_ctrl; // [412:405]
    i2c_reg2hw_host_fifo_config_reg_t host_fifo_config; // [404:379]
    i2c_reg2hw_target_fifo_config_reg_t target_fifo_config; // [378:351]
    i2c_reg2hw_ovrd_reg_t ovrd; // [350:348]
    i2c_reg2hw_timing0_reg_t timing0; // [347:316]
    i2c_reg2hw_timing1_reg_t timing1; // [315:284]
    i2c_reg2hw_timing2_reg_t timing2; // [283:252]
    i2c_reg2hw_timing3_reg_t timing3; // [251:220]
    i2c_reg2hw_timing4_reg_t timing4; // [219:188]
    i2c_reg2hw_timeout_ctrl_reg_t timeout_ctrl; // [187:156]
    i2c_reg2hw_target_id_reg_t target_id; // [155:128]
    i2c_reg2hw_acqdata_reg_t acqdata; // [127:115]
    i2c_reg2hw_txdata_reg_t txdata; // [114:106]
    i2c_reg2hw_host_timeout_ctrl_reg_t host_timeout_ctrl; // [105:74]
    i2c_reg2hw_target_timeout_ctrl_reg_t target_timeout_ctrl; // [73:42]
    i2c_reg2hw_target_nack_count_reg_t target_nack_count; // [41:34]
    i2c_reg2hw_host_nack_handler_timeout_reg_t host_nack_handler_timeout; // [33:2]
    i2c_reg2hw_controller_events_reg_t controller_events; // [1:0]
  } i2c_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    i2c_hw2reg_intr_state_reg_t intr_state; // [151:122]
    i2c_hw2reg_status_reg_t status; // [121:112]
    i2c_hw2reg_rdata_reg_t rdata; // [111:104]
    i2c_hw2reg_host_fifo_status_reg_t host_fifo_status; // [103:80]
    i2c_hw2reg_target_fifo_status_reg_t target_fifo_status; // [79:56]
    i2c_hw2reg_val_reg_t val; // [55:24]
    i2c_hw2reg_acqdata_reg_t acqdata; // [23:13]
    i2c_hw2reg_target_nack_count_reg_t target_nack_count; // [12:4]
    i2c_hw2reg_controller_events_reg_t controller_events; // [3:0]
  } i2c_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] I2C_INTR_STATE_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] I2C_INTR_ENABLE_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] I2C_INTR_TEST_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] I2C_ALERT_TEST_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] I2C_CTRL_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] I2C_STATUS_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] I2C_RDATA_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] I2C_FDATA_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] I2C_FIFO_CTRL_OFFSET = 7'h 20;
  parameter logic [BlockAw-1:0] I2C_HOST_FIFO_CONFIG_OFFSET = 7'h 24;
  parameter logic [BlockAw-1:0] I2C_TARGET_FIFO_CONFIG_OFFSET = 7'h 28;
  parameter logic [BlockAw-1:0] I2C_HOST_FIFO_STATUS_OFFSET = 7'h 2c;
  parameter logic [BlockAw-1:0] I2C_TARGET_FIFO_STATUS_OFFSET = 7'h 30;
  parameter logic [BlockAw-1:0] I2C_OVRD_OFFSET = 7'h 34;
  parameter logic [BlockAw-1:0] I2C_VAL_OFFSET = 7'h 38;
  parameter logic [BlockAw-1:0] I2C_TIMING0_OFFSET = 7'h 3c;
  parameter logic [BlockAw-1:0] I2C_TIMING1_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] I2C_TIMING2_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] I2C_TIMING3_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] I2C_TIMING4_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] I2C_TIMEOUT_CTRL_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] I2C_TARGET_ID_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] I2C_ACQDATA_OFFSET = 7'h 58;
  parameter logic [BlockAw-1:0] I2C_TXDATA_OFFSET = 7'h 5c;
  parameter logic [BlockAw-1:0] I2C_HOST_TIMEOUT_CTRL_OFFSET = 7'h 60;
  parameter logic [BlockAw-1:0] I2C_TARGET_TIMEOUT_CTRL_OFFSET = 7'h 64;
  parameter logic [BlockAw-1:0] I2C_TARGET_NACK_COUNT_OFFSET = 7'h 68;
  parameter logic [BlockAw-1:0] I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET = 7'h 6c;
  parameter logic [BlockAw-1:0] I2C_CONTROLLER_EVENTS_OFFSET = 7'h 70;

  // Reset values for hwext registers and their fields
  parameter logic [14:0] I2C_INTR_TEST_RESVAL = 15'h 0;
  parameter logic [0:0] I2C_INTR_TEST_FMT_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_RX_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_ACQ_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_RX_OVERFLOW_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_CONTROLLER_HALT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SCL_INTERFERENCE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SDA_INTERFERENCE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_STRETCH_TIMEOUT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SDA_UNSTABLE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_CMD_COMPLETE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_TX_STRETCH_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_TX_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_ACQ_FULL_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_UNEXP_STOP_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_HOST_TIMEOUT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [9:0] I2C_STATUS_RESVAL = 10'h 33c;
  parameter logic [0:0] I2C_STATUS_FMTEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_HOSTIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_TARGETIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_RXEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_TXEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_ACQEMPTY_RESVAL = 1'h 1;
  parameter logic [7:0] I2C_RDATA_RESVAL = 8'h 0;
  parameter logic [27:0] I2C_HOST_FIFO_STATUS_RESVAL = 28'h 0;
  parameter logic [27:0] I2C_TARGET_FIFO_STATUS_RESVAL = 28'h 0;
  parameter logic [31:0] I2C_VAL_RESVAL = 32'h 0;
  parameter logic [10:0] I2C_ACQDATA_RESVAL = 11'h 0;

  // Register index
  typedef enum int {
    I2C_INTR_STATE,
    I2C_INTR_ENABLE,
    I2C_INTR_TEST,
    I2C_ALERT_TEST,
    I2C_CTRL,
    I2C_STATUS,
    I2C_RDATA,
    I2C_FDATA,
    I2C_FIFO_CTRL,
    I2C_HOST_FIFO_CONFIG,
    I2C_TARGET_FIFO_CONFIG,
    I2C_HOST_FIFO_STATUS,
    I2C_TARGET_FIFO_STATUS,
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
    I2C_HOST_TIMEOUT_CTRL,
    I2C_TARGET_TIMEOUT_CTRL,
    I2C_TARGET_NACK_COUNT,
    I2C_HOST_NACK_HANDLER_TIMEOUT,
    I2C_CONTROLLER_EVENTS
  } i2c_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] I2C_PERMIT [29] = '{
    4'b 0011, // index[ 0] I2C_INTR_STATE
    4'b 0011, // index[ 1] I2C_INTR_ENABLE
    4'b 0011, // index[ 2] I2C_INTR_TEST
    4'b 0001, // index[ 3] I2C_ALERT_TEST
    4'b 0001, // index[ 4] I2C_CTRL
    4'b 0011, // index[ 5] I2C_STATUS
    4'b 0001, // index[ 6] I2C_RDATA
    4'b 0011, // index[ 7] I2C_FDATA
    4'b 0011, // index[ 8] I2C_FIFO_CTRL
    4'b 1111, // index[ 9] I2C_HOST_FIFO_CONFIG
    4'b 1111, // index[10] I2C_TARGET_FIFO_CONFIG
    4'b 1111, // index[11] I2C_HOST_FIFO_STATUS
    4'b 1111, // index[12] I2C_TARGET_FIFO_STATUS
    4'b 0001, // index[13] I2C_OVRD
    4'b 1111, // index[14] I2C_VAL
    4'b 1111, // index[15] I2C_TIMING0
    4'b 1111, // index[16] I2C_TIMING1
    4'b 1111, // index[17] I2C_TIMING2
    4'b 1111, // index[18] I2C_TIMING3
    4'b 1111, // index[19] I2C_TIMING4
    4'b 1111, // index[20] I2C_TIMEOUT_CTRL
    4'b 1111, // index[21] I2C_TARGET_ID
    4'b 0011, // index[22] I2C_ACQDATA
    4'b 0001, // index[23] I2C_TXDATA
    4'b 1111, // index[24] I2C_HOST_TIMEOUT_CTRL
    4'b 1111, // index[25] I2C_TARGET_TIMEOUT_CTRL
    4'b 0001, // index[26] I2C_TARGET_NACK_COUNT
    4'b 1111, // index[27] I2C_HOST_NACK_HANDLER_TIMEOUT
    4'b 0001  // index[28] I2C_CONTROLLER_EVENTS
  };

endpackage
