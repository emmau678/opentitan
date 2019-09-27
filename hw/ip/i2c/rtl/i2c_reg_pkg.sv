// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package i2c_reg_pkg;

// Register to internal design logic
typedef struct packed {

  struct packed {
    struct packed {
      logic q; // [282]
    } fmt_watermark;
    struct packed {
      logic q; // [281]
    } rx_watermark;
    struct packed {
      logic q; // [280]
    } fmt_overflow;
    struct packed {
      logic q; // [279]
    } rx_overflow;
    struct packed {
      logic q; // [278]
    } nak;
    struct packed {
      logic q; // [277]
    } scl_interference;
    struct packed {
      logic q; // [276]
    } sda_interference;
    struct packed {
      logic q; // [275]
    } stretch_timeout;
    struct packed {
      logic q; // [274]
    } sda_unstable;
  } intr_state;
  struct packed {
    struct packed {
      logic q; // [273]
    } fmt_watermark;
    struct packed {
      logic q; // [272]
    } rx_watermark;
    struct packed {
      logic q; // [271]
    } fmt_overflow;
    struct packed {
      logic q; // [270]
    } rx_overflow;
    struct packed {
      logic q; // [269]
    } nak;
    struct packed {
      logic q; // [268]
    } scl_interference;
    struct packed {
      logic q; // [267]
    } sda_interference;
    struct packed {
      logic q; // [266]
    } stretch_timeout;
    struct packed {
      logic q; // [265]
    } sda_unstable;
  } intr_enable;
  struct packed {
    struct packed {
      logic q; // [264]
      logic qe; // [263]
    } fmt_watermark;
    struct packed {
      logic q; // [262]
      logic qe; // [261]
    } rx_watermark;
    struct packed {
      logic q; // [260]
      logic qe; // [259]
    } fmt_overflow;
    struct packed {
      logic q; // [258]
      logic qe; // [257]
    } rx_overflow;
    struct packed {
      logic q; // [256]
      logic qe; // [255]
    } nak;
    struct packed {
      logic q; // [254]
      logic qe; // [253]
    } scl_interference;
    struct packed {
      logic q; // [252]
      logic qe; // [251]
    } sda_interference;
    struct packed {
      logic q; // [250]
      logic qe; // [249]
    } stretch_timeout;
    struct packed {
      logic q; // [248]
      logic qe; // [247]
    } sda_unstable;
  } intr_test;
  struct packed {
    logic [0:0] q; // [246:246]
  } ctrl;
  struct packed {
    struct packed {
      logic q; // [245]
      logic re; // [244]
    } fmtfull;
    struct packed {
      logic q; // [243]
      logic re; // [242]
    } rxfull;
    struct packed {
      logic q; // [241]
      logic re; // [240]
    } fmtempty;
    struct packed {
      logic q; // [239]
      logic re; // [238]
    } hostidle;
    struct packed {
      logic q; // [237]
      logic re; // [236]
    } targetidle;
    struct packed {
      logic q; // [235]
      logic re; // [234]
    } rxempty;
  } status;
  struct packed {
    logic [7:0] q; // [233:226]
    logic re; // [225]
  } rdata;
  struct packed {
    struct packed {
      logic [7:0] q; // [224:217]
      logic qe; // [216]
    } fbyte;
    struct packed {
      logic q; // [215]
      logic qe; // [214]
    } start;
    struct packed {
      logic q; // [213]
      logic qe; // [212]
    } stop;
    struct packed {
      logic q; // [211]
      logic qe; // [210]
    } read;
    struct packed {
      logic q; // [209]
      logic qe; // [208]
    } rcont;
    struct packed {
      logic q; // [207]
      logic qe; // [206]
    } nakok;
  } fdata;
  struct packed {
    struct packed {
      logic q; // [205]
      logic qe; // [204]
    } rxrst;
    struct packed {
      logic q; // [203]
      logic qe; // [202]
    } fmtrst;
    struct packed {
      logic [2:0] q; // [201:199]
      logic qe; // [198]
    } rxilvl;
    struct packed {
      logic [1:0] q; // [197:196]
      logic qe; // [195]
    } fmtilvl;
  } fifo_ctrl;
  struct packed {
    struct packed {
      logic q; // [194]
    } txovrden;
    struct packed {
      logic q; // [193]
    } sclval;
    struct packed {
      logic q; // [192]
    } sdaval;
  } ovrd;
  struct packed {
    struct packed {
      logic [15:0] q; // [191:176]
    } thigh;
    struct packed {
      logic [15:0] q; // [175:160]
    } tlow;
  } timing0;
  struct packed {
    struct packed {
      logic [15:0] q; // [159:144]
    } t_r;
    struct packed {
      logic [15:0] q; // [143:128]
    } t_f;
  } timing1;
  struct packed {
    struct packed {
      logic [15:0] q; // [127:112]
    } tsu_sta;
    struct packed {
      logic [15:0] q; // [111:96]
    } thd_sta;
  } timing2;
  struct packed {
    struct packed {
      logic [15:0] q; // [95:80]
    } tsu_dat;
    struct packed {
      logic [15:0] q; // [79:64]
    } thd_dat;
  } timing3;
  struct packed {
    struct packed {
      logic [15:0] q; // [63:48]
    } tsu_sto;
    struct packed {
      logic [15:0] q; // [47:32]
    } t_buf;
  } timing4;
  struct packed {
    struct packed {
      logic [30:0] q; // [31:1]
    } val;
    struct packed {
      logic q; // [0]
    } en;
  } timeout_ctrl;
} i2c_reg2hw_t;

// Internal design logic to register
typedef struct packed {

  struct packed {
    struct packed {
      logic d;  // [75]
      logic de; // [74]
    } fmt_watermark;
    struct packed {
      logic d;  // [73]
      logic de; // [72]
    } rx_watermark;
    struct packed {
      logic d;  // [71]
      logic de; // [70]
    } fmt_overflow;
    struct packed {
      logic d;  // [69]
      logic de; // [68]
    } rx_overflow;
    struct packed {
      logic d;  // [67]
      logic de; // [66]
    } nak;
    struct packed {
      logic d;  // [65]
      logic de; // [64]
    } scl_interference;
    struct packed {
      logic d;  // [63]
      logic de; // [62]
    } sda_interference;
    struct packed {
      logic d;  // [61]
      logic de; // [60]
    } stretch_timeout;
    struct packed {
      logic d;  // [59]
      logic de; // [58]
    } sda_unstable;
  } intr_state;
  struct packed {
    struct packed {
      logic d;  // [57]
    } fmtfull;
    struct packed {
      logic d;  // [56]
    } rxfull;
    struct packed {
      logic d;  // [55]
    } fmtempty;
    struct packed {
      logic d;  // [54]
    } hostidle;
    struct packed {
      logic d;  // [53]
    } targetidle;
    struct packed {
      logic d;  // [52]
    } rxempty;
  } status;
  struct packed {
    logic [7:0] d; // [51:44]
  } rdata;
  struct packed {
    struct packed {
      logic [5:0] d; // [43:38]
    } fmtlvl;
    struct packed {
      logic [5:0] d; // [37:32]
    } rxlvl;
  } fifo_status;
  struct packed {
    struct packed {
      logic [15:0] d; // [31:16]
    } scl_rx;
    struct packed {
      logic [15:0] d; // [15:0]
    } sda_rx;
  } val;
} i2c_hw2reg_t;

  // Register Address
  parameter I2C_INTR_STATE_OFFSET = 7'h 0;
  parameter I2C_INTR_ENABLE_OFFSET = 7'h 4;
  parameter I2C_INTR_TEST_OFFSET = 7'h 8;
  parameter I2C_CTRL_OFFSET = 7'h c;
  parameter I2C_STATUS_OFFSET = 7'h 10;
  parameter I2C_RDATA_OFFSET = 7'h 14;
  parameter I2C_FDATA_OFFSET = 7'h 18;
  parameter I2C_FIFO_CTRL_OFFSET = 7'h 1c;
  parameter I2C_FIFO_STATUS_OFFSET = 7'h 20;
  parameter I2C_OVRD_OFFSET = 7'h 24;
  parameter I2C_VAL_OFFSET = 7'h 28;
  parameter I2C_TIMING0_OFFSET = 7'h 2c;
  parameter I2C_TIMING1_OFFSET = 7'h 30;
  parameter I2C_TIMING2_OFFSET = 7'h 34;
  parameter I2C_TIMING3_OFFSET = 7'h 38;
  parameter I2C_TIMING4_OFFSET = 7'h 3c;
  parameter I2C_TIMEOUT_CTRL_OFFSET = 7'h 40;


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
    I2C_TIMEOUT_CTRL
  } i2c_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] I2C_PERMIT [17] = '{
    4'b 0011, // index[ 0] I2C_INTR_STATE
    4'b 0011, // index[ 1] I2C_INTR_ENABLE
    4'b 0011, // index[ 2] I2C_INTR_TEST
    4'b 0001, // index[ 3] I2C_CTRL
    4'b 0001, // index[ 4] I2C_STATUS
    4'b 0001, // index[ 5] I2C_RDATA
    4'b 0011, // index[ 6] I2C_FDATA
    4'b 0001, // index[ 7] I2C_FIFO_CTRL
    4'b 1111, // index[ 8] I2C_FIFO_STATUS
    4'b 0001, // index[ 9] I2C_OVRD
    4'b 1111, // index[10] I2C_VAL
    4'b 1111, // index[11] I2C_TIMING0
    4'b 1111, // index[12] I2C_TIMING1
    4'b 1111, // index[13] I2C_TIMING2
    4'b 1111, // index[14] I2C_TIMING3
    4'b 1111, // index[15] I2C_TIMING4
    4'b 1111  // index[16] I2C_TIMEOUT_CTRL
  };
endpackage

