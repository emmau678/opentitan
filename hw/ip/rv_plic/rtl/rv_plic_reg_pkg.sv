// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_plic_reg_pkg;

  // Param list
  parameter int NumSrc = 32;
  parameter int NumTarget = 1;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic        q;
  } rv_plic_reg2hw_le_mreg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio0_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio1_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio2_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio3_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio4_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio5_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio6_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio7_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio8_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio9_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio10_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio11_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio12_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio13_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio14_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio15_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio16_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio17_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio18_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio19_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio20_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio21_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio22_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio23_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio24_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio25_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio26_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio27_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio28_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio29_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio30_reg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_prio31_reg_t;

  typedef struct packed {
    logic        q;
  } rv_plic_reg2hw_ie0_mreg_t;

  typedef struct packed {
    logic [2:0]  q;
  } rv_plic_reg2hw_threshold0_reg_t;

  typedef struct packed {
    logic [5:0]  q;
    logic        qe;
    logic        re;
  } rv_plic_reg2hw_cc0_reg_t;

  typedef struct packed {
    logic        q;
  } rv_plic_reg2hw_msip0_reg_t;


  typedef struct packed {
    logic        d;
    logic        de;
  } rv_plic_hw2reg_ip_mreg_t;

  typedef struct packed {
    logic [5:0]  d;
  } rv_plic_hw2reg_cc0_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    rv_plic_reg2hw_le_mreg_t [31:0] le; // [171:140]
    rv_plic_reg2hw_prio0_reg_t prio0; // [139:137]
    rv_plic_reg2hw_prio1_reg_t prio1; // [136:134]
    rv_plic_reg2hw_prio2_reg_t prio2; // [133:131]
    rv_plic_reg2hw_prio3_reg_t prio3; // [130:128]
    rv_plic_reg2hw_prio4_reg_t prio4; // [127:125]
    rv_plic_reg2hw_prio5_reg_t prio5; // [124:122]
    rv_plic_reg2hw_prio6_reg_t prio6; // [121:119]
    rv_plic_reg2hw_prio7_reg_t prio7; // [118:116]
    rv_plic_reg2hw_prio8_reg_t prio8; // [115:113]
    rv_plic_reg2hw_prio9_reg_t prio9; // [112:110]
    rv_plic_reg2hw_prio10_reg_t prio10; // [109:107]
    rv_plic_reg2hw_prio11_reg_t prio11; // [106:104]
    rv_plic_reg2hw_prio12_reg_t prio12; // [103:101]
    rv_plic_reg2hw_prio13_reg_t prio13; // [100:98]
    rv_plic_reg2hw_prio14_reg_t prio14; // [97:95]
    rv_plic_reg2hw_prio15_reg_t prio15; // [94:92]
    rv_plic_reg2hw_prio16_reg_t prio16; // [91:89]
    rv_plic_reg2hw_prio17_reg_t prio17; // [88:86]
    rv_plic_reg2hw_prio18_reg_t prio18; // [85:83]
    rv_plic_reg2hw_prio19_reg_t prio19; // [82:80]
    rv_plic_reg2hw_prio20_reg_t prio20; // [79:77]
    rv_plic_reg2hw_prio21_reg_t prio21; // [76:74]
    rv_plic_reg2hw_prio22_reg_t prio22; // [73:71]
    rv_plic_reg2hw_prio23_reg_t prio23; // [70:68]
    rv_plic_reg2hw_prio24_reg_t prio24; // [67:65]
    rv_plic_reg2hw_prio25_reg_t prio25; // [64:62]
    rv_plic_reg2hw_prio26_reg_t prio26; // [61:59]
    rv_plic_reg2hw_prio27_reg_t prio27; // [58:56]
    rv_plic_reg2hw_prio28_reg_t prio28; // [55:53]
    rv_plic_reg2hw_prio29_reg_t prio29; // [52:50]
    rv_plic_reg2hw_prio30_reg_t prio30; // [49:47]
    rv_plic_reg2hw_prio31_reg_t prio31; // [46:44]
    rv_plic_reg2hw_ie0_mreg_t [31:0] ie0; // [43:12]
    rv_plic_reg2hw_threshold0_reg_t threshold0; // [11:9]
    rv_plic_reg2hw_cc0_reg_t cc0; // [8:1]
    rv_plic_reg2hw_msip0_reg_t msip0; // [0:0]
  } rv_plic_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    rv_plic_hw2reg_ip_mreg_t [31:0] ip; // [69:6]
    rv_plic_hw2reg_cc0_reg_t cc0; // [5:0]
  } rv_plic_hw2reg_t;

  // Register Address
  parameter logic [8:0] RV_PLIC_IP_OFFSET = 9'h 0;
  parameter logic [8:0] RV_PLIC_LE_OFFSET = 9'h 4;
  parameter logic [8:0] RV_PLIC_PRIO0_OFFSET = 9'h 8;
  parameter logic [8:0] RV_PLIC_PRIO1_OFFSET = 9'h c;
  parameter logic [8:0] RV_PLIC_PRIO2_OFFSET = 9'h 10;
  parameter logic [8:0] RV_PLIC_PRIO3_OFFSET = 9'h 14;
  parameter logic [8:0] RV_PLIC_PRIO4_OFFSET = 9'h 18;
  parameter logic [8:0] RV_PLIC_PRIO5_OFFSET = 9'h 1c;
  parameter logic [8:0] RV_PLIC_PRIO6_OFFSET = 9'h 20;
  parameter logic [8:0] RV_PLIC_PRIO7_OFFSET = 9'h 24;
  parameter logic [8:0] RV_PLIC_PRIO8_OFFSET = 9'h 28;
  parameter logic [8:0] RV_PLIC_PRIO9_OFFSET = 9'h 2c;
  parameter logic [8:0] RV_PLIC_PRIO10_OFFSET = 9'h 30;
  parameter logic [8:0] RV_PLIC_PRIO11_OFFSET = 9'h 34;
  parameter logic [8:0] RV_PLIC_PRIO12_OFFSET = 9'h 38;
  parameter logic [8:0] RV_PLIC_PRIO13_OFFSET = 9'h 3c;
  parameter logic [8:0] RV_PLIC_PRIO14_OFFSET = 9'h 40;
  parameter logic [8:0] RV_PLIC_PRIO15_OFFSET = 9'h 44;
  parameter logic [8:0] RV_PLIC_PRIO16_OFFSET = 9'h 48;
  parameter logic [8:0] RV_PLIC_PRIO17_OFFSET = 9'h 4c;
  parameter logic [8:0] RV_PLIC_PRIO18_OFFSET = 9'h 50;
  parameter logic [8:0] RV_PLIC_PRIO19_OFFSET = 9'h 54;
  parameter logic [8:0] RV_PLIC_PRIO20_OFFSET = 9'h 58;
  parameter logic [8:0] RV_PLIC_PRIO21_OFFSET = 9'h 5c;
  parameter logic [8:0] RV_PLIC_PRIO22_OFFSET = 9'h 60;
  parameter logic [8:0] RV_PLIC_PRIO23_OFFSET = 9'h 64;
  parameter logic [8:0] RV_PLIC_PRIO24_OFFSET = 9'h 68;
  parameter logic [8:0] RV_PLIC_PRIO25_OFFSET = 9'h 6c;
  parameter logic [8:0] RV_PLIC_PRIO26_OFFSET = 9'h 70;
  parameter logic [8:0] RV_PLIC_PRIO27_OFFSET = 9'h 74;
  parameter logic [8:0] RV_PLIC_PRIO28_OFFSET = 9'h 78;
  parameter logic [8:0] RV_PLIC_PRIO29_OFFSET = 9'h 7c;
  parameter logic [8:0] RV_PLIC_PRIO30_OFFSET = 9'h 80;
  parameter logic [8:0] RV_PLIC_PRIO31_OFFSET = 9'h 84;
  parameter logic [8:0] RV_PLIC_IE0_OFFSET = 9'h 100;
  parameter logic [8:0] RV_PLIC_THRESHOLD0_OFFSET = 9'h 104;
  parameter logic [8:0] RV_PLIC_CC0_OFFSET = 9'h 108;
  parameter logic [8:0] RV_PLIC_MSIP0_OFFSET = 9'h 10c;


  // Register Index
  typedef enum int {
    RV_PLIC_IP,
    RV_PLIC_LE,
    RV_PLIC_PRIO0,
    RV_PLIC_PRIO1,
    RV_PLIC_PRIO2,
    RV_PLIC_PRIO3,
    RV_PLIC_PRIO4,
    RV_PLIC_PRIO5,
    RV_PLIC_PRIO6,
    RV_PLIC_PRIO7,
    RV_PLIC_PRIO8,
    RV_PLIC_PRIO9,
    RV_PLIC_PRIO10,
    RV_PLIC_PRIO11,
    RV_PLIC_PRIO12,
    RV_PLIC_PRIO13,
    RV_PLIC_PRIO14,
    RV_PLIC_PRIO15,
    RV_PLIC_PRIO16,
    RV_PLIC_PRIO17,
    RV_PLIC_PRIO18,
    RV_PLIC_PRIO19,
    RV_PLIC_PRIO20,
    RV_PLIC_PRIO21,
    RV_PLIC_PRIO22,
    RV_PLIC_PRIO23,
    RV_PLIC_PRIO24,
    RV_PLIC_PRIO25,
    RV_PLIC_PRIO26,
    RV_PLIC_PRIO27,
    RV_PLIC_PRIO28,
    RV_PLIC_PRIO29,
    RV_PLIC_PRIO30,
    RV_PLIC_PRIO31,
    RV_PLIC_IE0,
    RV_PLIC_THRESHOLD0,
    RV_PLIC_CC0,
    RV_PLIC_MSIP0
  } rv_plic_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] RV_PLIC_PERMIT [38] = '{
    4'b 1111, // index[ 0] RV_PLIC_IP
    4'b 1111, // index[ 1] RV_PLIC_LE
    4'b 0001, // index[ 2] RV_PLIC_PRIO0
    4'b 0001, // index[ 3] RV_PLIC_PRIO1
    4'b 0001, // index[ 4] RV_PLIC_PRIO2
    4'b 0001, // index[ 5] RV_PLIC_PRIO3
    4'b 0001, // index[ 6] RV_PLIC_PRIO4
    4'b 0001, // index[ 7] RV_PLIC_PRIO5
    4'b 0001, // index[ 8] RV_PLIC_PRIO6
    4'b 0001, // index[ 9] RV_PLIC_PRIO7
    4'b 0001, // index[10] RV_PLIC_PRIO8
    4'b 0001, // index[11] RV_PLIC_PRIO9
    4'b 0001, // index[12] RV_PLIC_PRIO10
    4'b 0001, // index[13] RV_PLIC_PRIO11
    4'b 0001, // index[14] RV_PLIC_PRIO12
    4'b 0001, // index[15] RV_PLIC_PRIO13
    4'b 0001, // index[16] RV_PLIC_PRIO14
    4'b 0001, // index[17] RV_PLIC_PRIO15
    4'b 0001, // index[18] RV_PLIC_PRIO16
    4'b 0001, // index[19] RV_PLIC_PRIO17
    4'b 0001, // index[20] RV_PLIC_PRIO18
    4'b 0001, // index[21] RV_PLIC_PRIO19
    4'b 0001, // index[22] RV_PLIC_PRIO20
    4'b 0001, // index[23] RV_PLIC_PRIO21
    4'b 0001, // index[24] RV_PLIC_PRIO22
    4'b 0001, // index[25] RV_PLIC_PRIO23
    4'b 0001, // index[26] RV_PLIC_PRIO24
    4'b 0001, // index[27] RV_PLIC_PRIO25
    4'b 0001, // index[28] RV_PLIC_PRIO26
    4'b 0001, // index[29] RV_PLIC_PRIO27
    4'b 0001, // index[30] RV_PLIC_PRIO28
    4'b 0001, // index[31] RV_PLIC_PRIO29
    4'b 0001, // index[32] RV_PLIC_PRIO30
    4'b 0001, // index[33] RV_PLIC_PRIO31
    4'b 1111, // index[34] RV_PLIC_IE0
    4'b 0001, // index[35] RV_PLIC_THRESHOLD0
    4'b 0001, // index[36] RV_PLIC_CC0
    4'b 0001  // index[37] RV_PLIC_MSIP0
  };
endpackage

