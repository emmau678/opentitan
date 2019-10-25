// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_plic_reg_pkg;

  // Param list
  localparam int NumSrc = 63;
  localparam int NumTarget = 1;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic        q;
  } rv_plic_reg2hw_le_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio0_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio1_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio2_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio3_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio4_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio5_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio6_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio7_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio8_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio9_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio10_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio11_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio12_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio13_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio14_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio15_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio16_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio17_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio18_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio19_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio20_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio21_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio22_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio23_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio24_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio25_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio26_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio27_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio28_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio29_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio30_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio31_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio32_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio33_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio34_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio35_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio36_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio37_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio38_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio39_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio40_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio41_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio42_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio43_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio44_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio45_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio46_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio47_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio48_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio49_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio50_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio51_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio52_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio53_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio54_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio55_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio56_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio57_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio58_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio59_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio60_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio61_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_plic_reg2hw_prio62_reg_t;

  typedef struct packed {
    logic        q;
  } rv_plic_reg2hw_ie0_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
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
    rv_plic_reg2hw_le_mreg_t [62:0] le; // [262:200]
    rv_plic_reg2hw_prio0_reg_t prio0; // [199:198]
    rv_plic_reg2hw_prio1_reg_t prio1; // [197:196]
    rv_plic_reg2hw_prio2_reg_t prio2; // [195:194]
    rv_plic_reg2hw_prio3_reg_t prio3; // [193:192]
    rv_plic_reg2hw_prio4_reg_t prio4; // [191:190]
    rv_plic_reg2hw_prio5_reg_t prio5; // [189:188]
    rv_plic_reg2hw_prio6_reg_t prio6; // [187:186]
    rv_plic_reg2hw_prio7_reg_t prio7; // [185:184]
    rv_plic_reg2hw_prio8_reg_t prio8; // [183:182]
    rv_plic_reg2hw_prio9_reg_t prio9; // [181:180]
    rv_plic_reg2hw_prio10_reg_t prio10; // [179:178]
    rv_plic_reg2hw_prio11_reg_t prio11; // [177:176]
    rv_plic_reg2hw_prio12_reg_t prio12; // [175:174]
    rv_plic_reg2hw_prio13_reg_t prio13; // [173:172]
    rv_plic_reg2hw_prio14_reg_t prio14; // [171:170]
    rv_plic_reg2hw_prio15_reg_t prio15; // [169:168]
    rv_plic_reg2hw_prio16_reg_t prio16; // [167:166]
    rv_plic_reg2hw_prio17_reg_t prio17; // [165:164]
    rv_plic_reg2hw_prio18_reg_t prio18; // [163:162]
    rv_plic_reg2hw_prio19_reg_t prio19; // [161:160]
    rv_plic_reg2hw_prio20_reg_t prio20; // [159:158]
    rv_plic_reg2hw_prio21_reg_t prio21; // [157:156]
    rv_plic_reg2hw_prio22_reg_t prio22; // [155:154]
    rv_plic_reg2hw_prio23_reg_t prio23; // [153:152]
    rv_plic_reg2hw_prio24_reg_t prio24; // [151:150]
    rv_plic_reg2hw_prio25_reg_t prio25; // [149:148]
    rv_plic_reg2hw_prio26_reg_t prio26; // [147:146]
    rv_plic_reg2hw_prio27_reg_t prio27; // [145:144]
    rv_plic_reg2hw_prio28_reg_t prio28; // [143:142]
    rv_plic_reg2hw_prio29_reg_t prio29; // [141:140]
    rv_plic_reg2hw_prio30_reg_t prio30; // [139:138]
    rv_plic_reg2hw_prio31_reg_t prio31; // [137:136]
    rv_plic_reg2hw_prio32_reg_t prio32; // [135:134]
    rv_plic_reg2hw_prio33_reg_t prio33; // [133:132]
    rv_plic_reg2hw_prio34_reg_t prio34; // [131:130]
    rv_plic_reg2hw_prio35_reg_t prio35; // [129:128]
    rv_plic_reg2hw_prio36_reg_t prio36; // [127:126]
    rv_plic_reg2hw_prio37_reg_t prio37; // [125:124]
    rv_plic_reg2hw_prio38_reg_t prio38; // [123:122]
    rv_plic_reg2hw_prio39_reg_t prio39; // [121:120]
    rv_plic_reg2hw_prio40_reg_t prio40; // [119:118]
    rv_plic_reg2hw_prio41_reg_t prio41; // [117:116]
    rv_plic_reg2hw_prio42_reg_t prio42; // [115:114]
    rv_plic_reg2hw_prio43_reg_t prio43; // [113:112]
    rv_plic_reg2hw_prio44_reg_t prio44; // [111:110]
    rv_plic_reg2hw_prio45_reg_t prio45; // [109:108]
    rv_plic_reg2hw_prio46_reg_t prio46; // [107:106]
    rv_plic_reg2hw_prio47_reg_t prio47; // [105:104]
    rv_plic_reg2hw_prio48_reg_t prio48; // [103:102]
    rv_plic_reg2hw_prio49_reg_t prio49; // [101:100]
    rv_plic_reg2hw_prio50_reg_t prio50; // [99:98]
    rv_plic_reg2hw_prio51_reg_t prio51; // [97:96]
    rv_plic_reg2hw_prio52_reg_t prio52; // [95:94]
    rv_plic_reg2hw_prio53_reg_t prio53; // [93:92]
    rv_plic_reg2hw_prio54_reg_t prio54; // [91:90]
    rv_plic_reg2hw_prio55_reg_t prio55; // [89:88]
    rv_plic_reg2hw_prio56_reg_t prio56; // [87:86]
    rv_plic_reg2hw_prio57_reg_t prio57; // [85:84]
    rv_plic_reg2hw_prio58_reg_t prio58; // [83:82]
    rv_plic_reg2hw_prio59_reg_t prio59; // [81:80]
    rv_plic_reg2hw_prio60_reg_t prio60; // [79:78]
    rv_plic_reg2hw_prio61_reg_t prio61; // [77:76]
    rv_plic_reg2hw_prio62_reg_t prio62; // [75:74]
    rv_plic_reg2hw_ie0_mreg_t [62:0] ie0; // [73:11]
    rv_plic_reg2hw_threshold0_reg_t threshold0; // [10:9]
    rv_plic_reg2hw_cc0_reg_t cc0; // [8:1]
    rv_plic_reg2hw_msip0_reg_t msip0; // [0:0]
  } rv_plic_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    rv_plic_hw2reg_ip_mreg_t [62:0] ip; // [131:6]
    rv_plic_hw2reg_cc0_reg_t cc0; // [5:-2]
  } rv_plic_hw2reg_t;

  // Register Address
  parameter RV_PLIC_IP0_OFFSET = 10'h 0;
  parameter RV_PLIC_IP1_OFFSET = 10'h 4;
  parameter RV_PLIC_LE0_OFFSET = 10'h 8;
  parameter RV_PLIC_LE1_OFFSET = 10'h c;
  parameter RV_PLIC_PRIO0_OFFSET = 10'h 10;
  parameter RV_PLIC_PRIO1_OFFSET = 10'h 14;
  parameter RV_PLIC_PRIO2_OFFSET = 10'h 18;
  parameter RV_PLIC_PRIO3_OFFSET = 10'h 1c;
  parameter RV_PLIC_PRIO4_OFFSET = 10'h 20;
  parameter RV_PLIC_PRIO5_OFFSET = 10'h 24;
  parameter RV_PLIC_PRIO6_OFFSET = 10'h 28;
  parameter RV_PLIC_PRIO7_OFFSET = 10'h 2c;
  parameter RV_PLIC_PRIO8_OFFSET = 10'h 30;
  parameter RV_PLIC_PRIO9_OFFSET = 10'h 34;
  parameter RV_PLIC_PRIO10_OFFSET = 10'h 38;
  parameter RV_PLIC_PRIO11_OFFSET = 10'h 3c;
  parameter RV_PLIC_PRIO12_OFFSET = 10'h 40;
  parameter RV_PLIC_PRIO13_OFFSET = 10'h 44;
  parameter RV_PLIC_PRIO14_OFFSET = 10'h 48;
  parameter RV_PLIC_PRIO15_OFFSET = 10'h 4c;
  parameter RV_PLIC_PRIO16_OFFSET = 10'h 50;
  parameter RV_PLIC_PRIO17_OFFSET = 10'h 54;
  parameter RV_PLIC_PRIO18_OFFSET = 10'h 58;
  parameter RV_PLIC_PRIO19_OFFSET = 10'h 5c;
  parameter RV_PLIC_PRIO20_OFFSET = 10'h 60;
  parameter RV_PLIC_PRIO21_OFFSET = 10'h 64;
  parameter RV_PLIC_PRIO22_OFFSET = 10'h 68;
  parameter RV_PLIC_PRIO23_OFFSET = 10'h 6c;
  parameter RV_PLIC_PRIO24_OFFSET = 10'h 70;
  parameter RV_PLIC_PRIO25_OFFSET = 10'h 74;
  parameter RV_PLIC_PRIO26_OFFSET = 10'h 78;
  parameter RV_PLIC_PRIO27_OFFSET = 10'h 7c;
  parameter RV_PLIC_PRIO28_OFFSET = 10'h 80;
  parameter RV_PLIC_PRIO29_OFFSET = 10'h 84;
  parameter RV_PLIC_PRIO30_OFFSET = 10'h 88;
  parameter RV_PLIC_PRIO31_OFFSET = 10'h 8c;
  parameter RV_PLIC_PRIO32_OFFSET = 10'h 90;
  parameter RV_PLIC_PRIO33_OFFSET = 10'h 94;
  parameter RV_PLIC_PRIO34_OFFSET = 10'h 98;
  parameter RV_PLIC_PRIO35_OFFSET = 10'h 9c;
  parameter RV_PLIC_PRIO36_OFFSET = 10'h a0;
  parameter RV_PLIC_PRIO37_OFFSET = 10'h a4;
  parameter RV_PLIC_PRIO38_OFFSET = 10'h a8;
  parameter RV_PLIC_PRIO39_OFFSET = 10'h ac;
  parameter RV_PLIC_PRIO40_OFFSET = 10'h b0;
  parameter RV_PLIC_PRIO41_OFFSET = 10'h b4;
  parameter RV_PLIC_PRIO42_OFFSET = 10'h b8;
  parameter RV_PLIC_PRIO43_OFFSET = 10'h bc;
  parameter RV_PLIC_PRIO44_OFFSET = 10'h c0;
  parameter RV_PLIC_PRIO45_OFFSET = 10'h c4;
  parameter RV_PLIC_PRIO46_OFFSET = 10'h c8;
  parameter RV_PLIC_PRIO47_OFFSET = 10'h cc;
  parameter RV_PLIC_PRIO48_OFFSET = 10'h d0;
  parameter RV_PLIC_PRIO49_OFFSET = 10'h d4;
  parameter RV_PLIC_PRIO50_OFFSET = 10'h d8;
  parameter RV_PLIC_PRIO51_OFFSET = 10'h dc;
  parameter RV_PLIC_PRIO52_OFFSET = 10'h e0;
  parameter RV_PLIC_PRIO53_OFFSET = 10'h e4;
  parameter RV_PLIC_PRIO54_OFFSET = 10'h e8;
  parameter RV_PLIC_PRIO55_OFFSET = 10'h ec;
  parameter RV_PLIC_PRIO56_OFFSET = 10'h f0;
  parameter RV_PLIC_PRIO57_OFFSET = 10'h f4;
  parameter RV_PLIC_PRIO58_OFFSET = 10'h f8;
  parameter RV_PLIC_PRIO59_OFFSET = 10'h fc;
  parameter RV_PLIC_PRIO60_OFFSET = 10'h 100;
  parameter RV_PLIC_PRIO61_OFFSET = 10'h 104;
  parameter RV_PLIC_PRIO62_OFFSET = 10'h 108;
  parameter RV_PLIC_IE00_OFFSET = 10'h 200;
  parameter RV_PLIC_IE01_OFFSET = 10'h 204;
  parameter RV_PLIC_THRESHOLD0_OFFSET = 10'h 208;
  parameter RV_PLIC_CC0_OFFSET = 10'h 20c;
  parameter RV_PLIC_MSIP0_OFFSET = 10'h 210;


  // Register Index
  typedef enum int {
    RV_PLIC_IP0,
    RV_PLIC_IP1,
    RV_PLIC_LE0,
    RV_PLIC_LE1,
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
    RV_PLIC_PRIO32,
    RV_PLIC_PRIO33,
    RV_PLIC_PRIO34,
    RV_PLIC_PRIO35,
    RV_PLIC_PRIO36,
    RV_PLIC_PRIO37,
    RV_PLIC_PRIO38,
    RV_PLIC_PRIO39,
    RV_PLIC_PRIO40,
    RV_PLIC_PRIO41,
    RV_PLIC_PRIO42,
    RV_PLIC_PRIO43,
    RV_PLIC_PRIO44,
    RV_PLIC_PRIO45,
    RV_PLIC_PRIO46,
    RV_PLIC_PRIO47,
    RV_PLIC_PRIO48,
    RV_PLIC_PRIO49,
    RV_PLIC_PRIO50,
    RV_PLIC_PRIO51,
    RV_PLIC_PRIO52,
    RV_PLIC_PRIO53,
    RV_PLIC_PRIO54,
    RV_PLIC_PRIO55,
    RV_PLIC_PRIO56,
    RV_PLIC_PRIO57,
    RV_PLIC_PRIO58,
    RV_PLIC_PRIO59,
    RV_PLIC_PRIO60,
    RV_PLIC_PRIO61,
    RV_PLIC_PRIO62,
    RV_PLIC_IE00,
    RV_PLIC_IE01,
    RV_PLIC_THRESHOLD0,
    RV_PLIC_CC0,
    RV_PLIC_MSIP0
  } rv_plic_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] RV_PLIC_PERMIT [72] = '{
    4'b 1111, // index[ 0] RV_PLIC_IP0
    4'b 1111, // index[ 1] RV_PLIC_IP1
    4'b 1111, // index[ 2] RV_PLIC_LE0
    4'b 1111, // index[ 3] RV_PLIC_LE1
    4'b 0001, // index[ 4] RV_PLIC_PRIO0
    4'b 0001, // index[ 5] RV_PLIC_PRIO1
    4'b 0001, // index[ 6] RV_PLIC_PRIO2
    4'b 0001, // index[ 7] RV_PLIC_PRIO3
    4'b 0001, // index[ 8] RV_PLIC_PRIO4
    4'b 0001, // index[ 9] RV_PLIC_PRIO5
    4'b 0001, // index[10] RV_PLIC_PRIO6
    4'b 0001, // index[11] RV_PLIC_PRIO7
    4'b 0001, // index[12] RV_PLIC_PRIO8
    4'b 0001, // index[13] RV_PLIC_PRIO9
    4'b 0001, // index[14] RV_PLIC_PRIO10
    4'b 0001, // index[15] RV_PLIC_PRIO11
    4'b 0001, // index[16] RV_PLIC_PRIO12
    4'b 0001, // index[17] RV_PLIC_PRIO13
    4'b 0001, // index[18] RV_PLIC_PRIO14
    4'b 0001, // index[19] RV_PLIC_PRIO15
    4'b 0001, // index[20] RV_PLIC_PRIO16
    4'b 0001, // index[21] RV_PLIC_PRIO17
    4'b 0001, // index[22] RV_PLIC_PRIO18
    4'b 0001, // index[23] RV_PLIC_PRIO19
    4'b 0001, // index[24] RV_PLIC_PRIO20
    4'b 0001, // index[25] RV_PLIC_PRIO21
    4'b 0001, // index[26] RV_PLIC_PRIO22
    4'b 0001, // index[27] RV_PLIC_PRIO23
    4'b 0001, // index[28] RV_PLIC_PRIO24
    4'b 0001, // index[29] RV_PLIC_PRIO25
    4'b 0001, // index[30] RV_PLIC_PRIO26
    4'b 0001, // index[31] RV_PLIC_PRIO27
    4'b 0001, // index[32] RV_PLIC_PRIO28
    4'b 0001, // index[33] RV_PLIC_PRIO29
    4'b 0001, // index[34] RV_PLIC_PRIO30
    4'b 0001, // index[35] RV_PLIC_PRIO31
    4'b 0001, // index[36] RV_PLIC_PRIO32
    4'b 0001, // index[37] RV_PLIC_PRIO33
    4'b 0001, // index[38] RV_PLIC_PRIO34
    4'b 0001, // index[39] RV_PLIC_PRIO35
    4'b 0001, // index[40] RV_PLIC_PRIO36
    4'b 0001, // index[41] RV_PLIC_PRIO37
    4'b 0001, // index[42] RV_PLIC_PRIO38
    4'b 0001, // index[43] RV_PLIC_PRIO39
    4'b 0001, // index[44] RV_PLIC_PRIO40
    4'b 0001, // index[45] RV_PLIC_PRIO41
    4'b 0001, // index[46] RV_PLIC_PRIO42
    4'b 0001, // index[47] RV_PLIC_PRIO43
    4'b 0001, // index[48] RV_PLIC_PRIO44
    4'b 0001, // index[49] RV_PLIC_PRIO45
    4'b 0001, // index[50] RV_PLIC_PRIO46
    4'b 0001, // index[51] RV_PLIC_PRIO47
    4'b 0001, // index[52] RV_PLIC_PRIO48
    4'b 0001, // index[53] RV_PLIC_PRIO49
    4'b 0001, // index[54] RV_PLIC_PRIO50
    4'b 0001, // index[55] RV_PLIC_PRIO51
    4'b 0001, // index[56] RV_PLIC_PRIO52
    4'b 0001, // index[57] RV_PLIC_PRIO53
    4'b 0001, // index[58] RV_PLIC_PRIO54
    4'b 0001, // index[59] RV_PLIC_PRIO55
    4'b 0001, // index[60] RV_PLIC_PRIO56
    4'b 0001, // index[61] RV_PLIC_PRIO57
    4'b 0001, // index[62] RV_PLIC_PRIO58
    4'b 0001, // index[63] RV_PLIC_PRIO59
    4'b 0001, // index[64] RV_PLIC_PRIO60
    4'b 0001, // index[65] RV_PLIC_PRIO61
    4'b 0001, // index[66] RV_PLIC_PRIO62
    4'b 1111, // index[67] RV_PLIC_IE00
    4'b 1111, // index[68] RV_PLIC_IE01
    4'b 0001, // index[69] RV_PLIC_THRESHOLD0
    4'b 0001, // index[70] RV_PLIC_CC0
    4'b 0001  // index[71] RV_PLIC_MSIP0
  };
endpackage

