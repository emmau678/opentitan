// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package alert_handler_reg_pkg;

  // Param list
  parameter int NAlerts = 4;
  parameter int EscCntDw = 32;
  parameter int AccuCntDw = 16;
  parameter logic [NAlerts-1:0] AsyncOn = '0;
  parameter int N_CLASSES = 4;
  parameter int N_ESC_SEV = 4;
  parameter int N_PHASES = 4;
  parameter int N_LOC_ALERT = 5;
  parameter int PING_CNT_DW = 16;
  parameter int PHASE_DW = 2;
  parameter int CLASS_DW = 2;

  // Address widths within the block
  parameter int BlockAw = 9;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } classa;
    struct packed {
      logic        q;
    } classb;
    struct packed {
      logic        q;
    } classc;
    struct packed {
      logic        q;
    } classd;
  } alert_handler_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } classa;
    struct packed {
      logic        q;
    } classb;
    struct packed {
      logic        q;
    } classc;
    struct packed {
      logic        q;
    } classd;
  } alert_handler_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } classa;
    struct packed {
      logic        q;
      logic        qe;
    } classb;
    struct packed {
      logic        q;
      logic        qe;
    } classc;
    struct packed {
      logic        q;
      logic        qe;
    } classd;
  } alert_handler_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_ping_timeout_cyc_reg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_ping_timer_en_reg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_alert_regwen_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_alert_en_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
  } alert_handler_reg2hw_alert_class_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_alert_cause_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_loc_alert_en_mreg_t;

  typedef struct packed {
    logic [1:0]  q;
  } alert_handler_reg2hw_loc_alert_class_mreg_t;

  typedef struct packed {
    logic        q;
  } alert_handler_reg2hw_loc_alert_cause_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classa_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classa_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classa_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classa_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classb_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classb_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classb_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classb_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classc_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classc_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classc_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classc_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } lock;
    struct packed {
      logic        q;
    } en_e0;
    struct packed {
      logic        q;
    } en_e1;
    struct packed {
      logic        q;
    } en_e2;
    struct packed {
      logic        q;
    } en_e3;
    struct packed {
      logic [1:0]  q;
    } map_e0;
    struct packed {
      logic [1:0]  q;
    } map_e1;
    struct packed {
      logic [1:0]  q;
    } map_e2;
    struct packed {
      logic [1:0]  q;
    } map_e3;
  } alert_handler_reg2hw_classd_ctrl_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } alert_handler_reg2hw_classd_clr_reg_t;

  typedef struct packed {
    logic [15:0] q;
  } alert_handler_reg2hw_classd_accum_thresh_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_timeout_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase0_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase1_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase2_cyc_reg_t;

  typedef struct packed {
    logic [31:0] q;
  } alert_handler_reg2hw_classd_phase3_cyc_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } classa;
    struct packed {
      logic        d;
      logic        de;
    } classb;
    struct packed {
      logic        d;
      logic        de;
    } classc;
    struct packed {
      logic        d;
      logic        de;
    } classd;
  } alert_handler_hw2reg_intr_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_alert_cause_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_loc_alert_cause_mreg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classa_clr_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classa_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classa_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classa_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classb_clr_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classb_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classb_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classb_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classc_clr_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classc_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classc_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classc_state_reg_t;

  typedef struct packed {
    logic        d;
    logic        de;
  } alert_handler_hw2reg_classd_clr_regwen_reg_t;

  typedef struct packed {
    logic [15:0] d;
  } alert_handler_hw2reg_classd_accum_cnt_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } alert_handler_hw2reg_classd_esc_cnt_reg_t;

  typedef struct packed {
    logic [2:0]  d;
  } alert_handler_hw2reg_classd_state_reg_t;

  // Register -> HW type
  typedef struct packed {
    alert_handler_reg2hw_intr_state_reg_t intr_state; // [840:837]
    alert_handler_reg2hw_intr_enable_reg_t intr_enable; // [836:833]
    alert_handler_reg2hw_intr_test_reg_t intr_test; // [832:825]
    alert_handler_reg2hw_ping_timeout_cyc_reg_t ping_timeout_cyc; // [824:809]
    alert_handler_reg2hw_ping_timer_en_reg_t ping_timer_en; // [808:808]
    alert_handler_reg2hw_alert_regwen_mreg_t [3:0] alert_regwen; // [807:804]
    alert_handler_reg2hw_alert_en_mreg_t [3:0] alert_en; // [803:800]
    alert_handler_reg2hw_alert_class_mreg_t [3:0] alert_class; // [799:792]
    alert_handler_reg2hw_alert_cause_mreg_t [3:0] alert_cause; // [791:788]
    alert_handler_reg2hw_loc_alert_en_mreg_t [4:0] loc_alert_en; // [787:783]
    alert_handler_reg2hw_loc_alert_class_mreg_t [4:0] loc_alert_class; // [782:773]
    alert_handler_reg2hw_loc_alert_cause_mreg_t [4:0] loc_alert_cause; // [772:768]
    alert_handler_reg2hw_classa_ctrl_reg_t classa_ctrl; // [767:754]
    alert_handler_reg2hw_classa_clr_reg_t classa_clr; // [753:752]
    alert_handler_reg2hw_classa_accum_thresh_reg_t classa_accum_thresh; // [751:736]
    alert_handler_reg2hw_classa_timeout_cyc_reg_t classa_timeout_cyc; // [735:704]
    alert_handler_reg2hw_classa_phase0_cyc_reg_t classa_phase0_cyc; // [703:672]
    alert_handler_reg2hw_classa_phase1_cyc_reg_t classa_phase1_cyc; // [671:640]
    alert_handler_reg2hw_classa_phase2_cyc_reg_t classa_phase2_cyc; // [639:608]
    alert_handler_reg2hw_classa_phase3_cyc_reg_t classa_phase3_cyc; // [607:576]
    alert_handler_reg2hw_classb_ctrl_reg_t classb_ctrl; // [575:562]
    alert_handler_reg2hw_classb_clr_reg_t classb_clr; // [561:560]
    alert_handler_reg2hw_classb_accum_thresh_reg_t classb_accum_thresh; // [559:544]
    alert_handler_reg2hw_classb_timeout_cyc_reg_t classb_timeout_cyc; // [543:512]
    alert_handler_reg2hw_classb_phase0_cyc_reg_t classb_phase0_cyc; // [511:480]
    alert_handler_reg2hw_classb_phase1_cyc_reg_t classb_phase1_cyc; // [479:448]
    alert_handler_reg2hw_classb_phase2_cyc_reg_t classb_phase2_cyc; // [447:416]
    alert_handler_reg2hw_classb_phase3_cyc_reg_t classb_phase3_cyc; // [415:384]
    alert_handler_reg2hw_classc_ctrl_reg_t classc_ctrl; // [383:370]
    alert_handler_reg2hw_classc_clr_reg_t classc_clr; // [369:368]
    alert_handler_reg2hw_classc_accum_thresh_reg_t classc_accum_thresh; // [367:352]
    alert_handler_reg2hw_classc_timeout_cyc_reg_t classc_timeout_cyc; // [351:320]
    alert_handler_reg2hw_classc_phase0_cyc_reg_t classc_phase0_cyc; // [319:288]
    alert_handler_reg2hw_classc_phase1_cyc_reg_t classc_phase1_cyc; // [287:256]
    alert_handler_reg2hw_classc_phase2_cyc_reg_t classc_phase2_cyc; // [255:224]
    alert_handler_reg2hw_classc_phase3_cyc_reg_t classc_phase3_cyc; // [223:192]
    alert_handler_reg2hw_classd_ctrl_reg_t classd_ctrl; // [191:178]
    alert_handler_reg2hw_classd_clr_reg_t classd_clr; // [177:176]
    alert_handler_reg2hw_classd_accum_thresh_reg_t classd_accum_thresh; // [175:160]
    alert_handler_reg2hw_classd_timeout_cyc_reg_t classd_timeout_cyc; // [159:128]
    alert_handler_reg2hw_classd_phase0_cyc_reg_t classd_phase0_cyc; // [127:96]
    alert_handler_reg2hw_classd_phase1_cyc_reg_t classd_phase1_cyc; // [95:64]
    alert_handler_reg2hw_classd_phase2_cyc_reg_t classd_phase2_cyc; // [63:32]
    alert_handler_reg2hw_classd_phase3_cyc_reg_t classd_phase3_cyc; // [31:0]
  } alert_handler_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    alert_handler_hw2reg_intr_state_reg_t intr_state; // [237:230]
    alert_handler_hw2reg_alert_cause_mreg_t [3:0] alert_cause; // [229:222]
    alert_handler_hw2reg_loc_alert_cause_mreg_t [4:0] loc_alert_cause; // [221:212]
    alert_handler_hw2reg_classa_clr_regwen_reg_t classa_clr_regwen; // [211:210]
    alert_handler_hw2reg_classa_accum_cnt_reg_t classa_accum_cnt; // [209:194]
    alert_handler_hw2reg_classa_esc_cnt_reg_t classa_esc_cnt; // [193:162]
    alert_handler_hw2reg_classa_state_reg_t classa_state; // [161:159]
    alert_handler_hw2reg_classb_clr_regwen_reg_t classb_clr_regwen; // [158:157]
    alert_handler_hw2reg_classb_accum_cnt_reg_t classb_accum_cnt; // [156:141]
    alert_handler_hw2reg_classb_esc_cnt_reg_t classb_esc_cnt; // [140:109]
    alert_handler_hw2reg_classb_state_reg_t classb_state; // [108:106]
    alert_handler_hw2reg_classc_clr_regwen_reg_t classc_clr_regwen; // [105:104]
    alert_handler_hw2reg_classc_accum_cnt_reg_t classc_accum_cnt; // [103:88]
    alert_handler_hw2reg_classc_esc_cnt_reg_t classc_esc_cnt; // [87:56]
    alert_handler_hw2reg_classc_state_reg_t classc_state; // [55:53]
    alert_handler_hw2reg_classd_clr_regwen_reg_t classd_clr_regwen; // [52:51]
    alert_handler_hw2reg_classd_accum_cnt_reg_t classd_accum_cnt; // [50:35]
    alert_handler_hw2reg_classd_esc_cnt_reg_t classd_esc_cnt; // [34:3]
    alert_handler_hw2reg_classd_state_reg_t classd_state; // [2:0]
  } alert_handler_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_STATE_OFFSET = 9'h 0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_ENABLE_OFFSET = 9'h 4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_INTR_TEST_OFFSET = 9'h 8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_PING_TIMER_REGWEN_OFFSET = 9'h c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_PING_TIMEOUT_CYC_OFFSET = 9'h 10;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_PING_TIMER_EN_OFFSET = 9'h 14;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_REGWEN_0_OFFSET = 9'h 18;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_REGWEN_1_OFFSET = 9'h 1c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_REGWEN_2_OFFSET = 9'h 20;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_REGWEN_3_OFFSET = 9'h 24;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_EN_0_OFFSET = 9'h 28;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_EN_1_OFFSET = 9'h 2c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_EN_2_OFFSET = 9'h 30;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_EN_3_OFFSET = 9'h 34;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_0_OFFSET = 9'h 38;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_1_OFFSET = 9'h 3c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_2_OFFSET = 9'h 40;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CLASS_3_OFFSET = 9'h 44;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CAUSE_0_OFFSET = 9'h 48;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CAUSE_1_OFFSET = 9'h 4c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CAUSE_2_OFFSET = 9'h 50;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_ALERT_CAUSE_3_OFFSET = 9'h 54;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_REGWEN_0_OFFSET = 9'h 58;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_REGWEN_1_OFFSET = 9'h 5c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_REGWEN_2_OFFSET = 9'h 60;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_REGWEN_3_OFFSET = 9'h 64;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_REGWEN_4_OFFSET = 9'h 68;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_0_OFFSET = 9'h 6c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_1_OFFSET = 9'h 70;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_2_OFFSET = 9'h 74;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_3_OFFSET = 9'h 78;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_EN_4_OFFSET = 9'h 7c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_0_OFFSET = 9'h 80;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_1_OFFSET = 9'h 84;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_2_OFFSET = 9'h 88;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_3_OFFSET = 9'h 8c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CLASS_4_OFFSET = 9'h 90;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_0_OFFSET = 9'h 94;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_1_OFFSET = 9'h 98;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_2_OFFSET = 9'h 9c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_3_OFFSET = 9'h a0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_LOC_ALERT_CAUSE_4_OFFSET = 9'h a4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_REGWEN_OFFSET = 9'h a8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_CTRL_OFFSET = 9'h ac;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_CLR_REGWEN_OFFSET = 9'h b0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_CLR_OFFSET = 9'h b4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ACCUM_CNT_OFFSET = 9'h b8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ACCUM_THRESH_OFFSET = 9'h bc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_TIMEOUT_CYC_OFFSET = 9'h c0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE0_CYC_OFFSET = 9'h c4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE1_CYC_OFFSET = 9'h c8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE2_CYC_OFFSET = 9'h cc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_PHASE3_CYC_OFFSET = 9'h d0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_ESC_CNT_OFFSET = 9'h d4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSA_STATE_OFFSET = 9'h d8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_REGWEN_OFFSET = 9'h dc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_CTRL_OFFSET = 9'h e0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_CLR_REGWEN_OFFSET = 9'h e4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_CLR_OFFSET = 9'h e8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ACCUM_CNT_OFFSET = 9'h ec;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ACCUM_THRESH_OFFSET = 9'h f0;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_TIMEOUT_CYC_OFFSET = 9'h f4;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE0_CYC_OFFSET = 9'h f8;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE1_CYC_OFFSET = 9'h fc;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE2_CYC_OFFSET = 9'h 100;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_PHASE3_CYC_OFFSET = 9'h 104;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_ESC_CNT_OFFSET = 9'h 108;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSB_STATE_OFFSET = 9'h 10c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_REGWEN_OFFSET = 9'h 110;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_CTRL_OFFSET = 9'h 114;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_CLR_REGWEN_OFFSET = 9'h 118;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_CLR_OFFSET = 9'h 11c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ACCUM_CNT_OFFSET = 9'h 120;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ACCUM_THRESH_OFFSET = 9'h 124;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_TIMEOUT_CYC_OFFSET = 9'h 128;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE0_CYC_OFFSET = 9'h 12c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE1_CYC_OFFSET = 9'h 130;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE2_CYC_OFFSET = 9'h 134;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_PHASE3_CYC_OFFSET = 9'h 138;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_ESC_CNT_OFFSET = 9'h 13c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSC_STATE_OFFSET = 9'h 140;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_REGWEN_OFFSET = 9'h 144;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_CTRL_OFFSET = 9'h 148;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_CLR_REGWEN_OFFSET = 9'h 14c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_CLR_OFFSET = 9'h 150;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ACCUM_CNT_OFFSET = 9'h 154;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ACCUM_THRESH_OFFSET = 9'h 158;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_TIMEOUT_CYC_OFFSET = 9'h 15c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE0_CYC_OFFSET = 9'h 160;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE1_CYC_OFFSET = 9'h 164;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE2_CYC_OFFSET = 9'h 168;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_PHASE3_CYC_OFFSET = 9'h 16c;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_ESC_CNT_OFFSET = 9'h 170;
  parameter logic [BlockAw-1:0] ALERT_HANDLER_CLASSD_STATE_OFFSET = 9'h 174;

  // Reset values for hwext registers and their fields
  parameter logic [3:0] ALERT_HANDLER_INTR_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSA_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSB_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSC_RESVAL = 1'h 0;
  parameter logic [0:0] ALERT_HANDLER_INTR_TEST_CLASSD_RESVAL = 1'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSA_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSA_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSA_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSB_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSB_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSB_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSC_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSC_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSC_STATE_RESVAL = 3'h 0;
  parameter logic [15:0] ALERT_HANDLER_CLASSD_ACCUM_CNT_RESVAL = 16'h 0;
  parameter logic [31:0] ALERT_HANDLER_CLASSD_ESC_CNT_RESVAL = 32'h 0;
  parameter logic [2:0] ALERT_HANDLER_CLASSD_STATE_RESVAL = 3'h 0;

  // Register index
  typedef enum int {
    ALERT_HANDLER_INTR_STATE,
    ALERT_HANDLER_INTR_ENABLE,
    ALERT_HANDLER_INTR_TEST,
    ALERT_HANDLER_PING_TIMER_REGWEN,
    ALERT_HANDLER_PING_TIMEOUT_CYC,
    ALERT_HANDLER_PING_TIMER_EN,
    ALERT_HANDLER_ALERT_REGWEN_0,
    ALERT_HANDLER_ALERT_REGWEN_1,
    ALERT_HANDLER_ALERT_REGWEN_2,
    ALERT_HANDLER_ALERT_REGWEN_3,
    ALERT_HANDLER_ALERT_EN_0,
    ALERT_HANDLER_ALERT_EN_1,
    ALERT_HANDLER_ALERT_EN_2,
    ALERT_HANDLER_ALERT_EN_3,
    ALERT_HANDLER_ALERT_CLASS_0,
    ALERT_HANDLER_ALERT_CLASS_1,
    ALERT_HANDLER_ALERT_CLASS_2,
    ALERT_HANDLER_ALERT_CLASS_3,
    ALERT_HANDLER_ALERT_CAUSE_0,
    ALERT_HANDLER_ALERT_CAUSE_1,
    ALERT_HANDLER_ALERT_CAUSE_2,
    ALERT_HANDLER_ALERT_CAUSE_3,
    ALERT_HANDLER_LOC_ALERT_REGWEN_0,
    ALERT_HANDLER_LOC_ALERT_REGWEN_1,
    ALERT_HANDLER_LOC_ALERT_REGWEN_2,
    ALERT_HANDLER_LOC_ALERT_REGWEN_3,
    ALERT_HANDLER_LOC_ALERT_REGWEN_4,
    ALERT_HANDLER_LOC_ALERT_EN_0,
    ALERT_HANDLER_LOC_ALERT_EN_1,
    ALERT_HANDLER_LOC_ALERT_EN_2,
    ALERT_HANDLER_LOC_ALERT_EN_3,
    ALERT_HANDLER_LOC_ALERT_EN_4,
    ALERT_HANDLER_LOC_ALERT_CLASS_0,
    ALERT_HANDLER_LOC_ALERT_CLASS_1,
    ALERT_HANDLER_LOC_ALERT_CLASS_2,
    ALERT_HANDLER_LOC_ALERT_CLASS_3,
    ALERT_HANDLER_LOC_ALERT_CLASS_4,
    ALERT_HANDLER_LOC_ALERT_CAUSE_0,
    ALERT_HANDLER_LOC_ALERT_CAUSE_1,
    ALERT_HANDLER_LOC_ALERT_CAUSE_2,
    ALERT_HANDLER_LOC_ALERT_CAUSE_3,
    ALERT_HANDLER_LOC_ALERT_CAUSE_4,
    ALERT_HANDLER_CLASSA_REGWEN,
    ALERT_HANDLER_CLASSA_CTRL,
    ALERT_HANDLER_CLASSA_CLR_REGWEN,
    ALERT_HANDLER_CLASSA_CLR,
    ALERT_HANDLER_CLASSA_ACCUM_CNT,
    ALERT_HANDLER_CLASSA_ACCUM_THRESH,
    ALERT_HANDLER_CLASSA_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSA_PHASE0_CYC,
    ALERT_HANDLER_CLASSA_PHASE1_CYC,
    ALERT_HANDLER_CLASSA_PHASE2_CYC,
    ALERT_HANDLER_CLASSA_PHASE3_CYC,
    ALERT_HANDLER_CLASSA_ESC_CNT,
    ALERT_HANDLER_CLASSA_STATE,
    ALERT_HANDLER_CLASSB_REGWEN,
    ALERT_HANDLER_CLASSB_CTRL,
    ALERT_HANDLER_CLASSB_CLR_REGWEN,
    ALERT_HANDLER_CLASSB_CLR,
    ALERT_HANDLER_CLASSB_ACCUM_CNT,
    ALERT_HANDLER_CLASSB_ACCUM_THRESH,
    ALERT_HANDLER_CLASSB_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSB_PHASE0_CYC,
    ALERT_HANDLER_CLASSB_PHASE1_CYC,
    ALERT_HANDLER_CLASSB_PHASE2_CYC,
    ALERT_HANDLER_CLASSB_PHASE3_CYC,
    ALERT_HANDLER_CLASSB_ESC_CNT,
    ALERT_HANDLER_CLASSB_STATE,
    ALERT_HANDLER_CLASSC_REGWEN,
    ALERT_HANDLER_CLASSC_CTRL,
    ALERT_HANDLER_CLASSC_CLR_REGWEN,
    ALERT_HANDLER_CLASSC_CLR,
    ALERT_HANDLER_CLASSC_ACCUM_CNT,
    ALERT_HANDLER_CLASSC_ACCUM_THRESH,
    ALERT_HANDLER_CLASSC_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSC_PHASE0_CYC,
    ALERT_HANDLER_CLASSC_PHASE1_CYC,
    ALERT_HANDLER_CLASSC_PHASE2_CYC,
    ALERT_HANDLER_CLASSC_PHASE3_CYC,
    ALERT_HANDLER_CLASSC_ESC_CNT,
    ALERT_HANDLER_CLASSC_STATE,
    ALERT_HANDLER_CLASSD_REGWEN,
    ALERT_HANDLER_CLASSD_CTRL,
    ALERT_HANDLER_CLASSD_CLR_REGWEN,
    ALERT_HANDLER_CLASSD_CLR,
    ALERT_HANDLER_CLASSD_ACCUM_CNT,
    ALERT_HANDLER_CLASSD_ACCUM_THRESH,
    ALERT_HANDLER_CLASSD_TIMEOUT_CYC,
    ALERT_HANDLER_CLASSD_PHASE0_CYC,
    ALERT_HANDLER_CLASSD_PHASE1_CYC,
    ALERT_HANDLER_CLASSD_PHASE2_CYC,
    ALERT_HANDLER_CLASSD_PHASE3_CYC,
    ALERT_HANDLER_CLASSD_ESC_CNT,
    ALERT_HANDLER_CLASSD_STATE
  } alert_handler_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] ALERT_HANDLER_PERMIT [94] = '{
    4'b 0001, // index[ 0] ALERT_HANDLER_INTR_STATE
    4'b 0001, // index[ 1] ALERT_HANDLER_INTR_ENABLE
    4'b 0001, // index[ 2] ALERT_HANDLER_INTR_TEST
    4'b 0001, // index[ 3] ALERT_HANDLER_PING_TIMER_REGWEN
    4'b 0011, // index[ 4] ALERT_HANDLER_PING_TIMEOUT_CYC
    4'b 0001, // index[ 5] ALERT_HANDLER_PING_TIMER_EN
    4'b 0001, // index[ 6] ALERT_HANDLER_ALERT_REGWEN_0
    4'b 0001, // index[ 7] ALERT_HANDLER_ALERT_REGWEN_1
    4'b 0001, // index[ 8] ALERT_HANDLER_ALERT_REGWEN_2
    4'b 0001, // index[ 9] ALERT_HANDLER_ALERT_REGWEN_3
    4'b 0001, // index[10] ALERT_HANDLER_ALERT_EN_0
    4'b 0001, // index[11] ALERT_HANDLER_ALERT_EN_1
    4'b 0001, // index[12] ALERT_HANDLER_ALERT_EN_2
    4'b 0001, // index[13] ALERT_HANDLER_ALERT_EN_3
    4'b 0001, // index[14] ALERT_HANDLER_ALERT_CLASS_0
    4'b 0001, // index[15] ALERT_HANDLER_ALERT_CLASS_1
    4'b 0001, // index[16] ALERT_HANDLER_ALERT_CLASS_2
    4'b 0001, // index[17] ALERT_HANDLER_ALERT_CLASS_3
    4'b 0001, // index[18] ALERT_HANDLER_ALERT_CAUSE_0
    4'b 0001, // index[19] ALERT_HANDLER_ALERT_CAUSE_1
    4'b 0001, // index[20] ALERT_HANDLER_ALERT_CAUSE_2
    4'b 0001, // index[21] ALERT_HANDLER_ALERT_CAUSE_3
    4'b 0001, // index[22] ALERT_HANDLER_LOC_ALERT_REGWEN_0
    4'b 0001, // index[23] ALERT_HANDLER_LOC_ALERT_REGWEN_1
    4'b 0001, // index[24] ALERT_HANDLER_LOC_ALERT_REGWEN_2
    4'b 0001, // index[25] ALERT_HANDLER_LOC_ALERT_REGWEN_3
    4'b 0001, // index[26] ALERT_HANDLER_LOC_ALERT_REGWEN_4
    4'b 0001, // index[27] ALERT_HANDLER_LOC_ALERT_EN_0
    4'b 0001, // index[28] ALERT_HANDLER_LOC_ALERT_EN_1
    4'b 0001, // index[29] ALERT_HANDLER_LOC_ALERT_EN_2
    4'b 0001, // index[30] ALERT_HANDLER_LOC_ALERT_EN_3
    4'b 0001, // index[31] ALERT_HANDLER_LOC_ALERT_EN_4
    4'b 0001, // index[32] ALERT_HANDLER_LOC_ALERT_CLASS_0
    4'b 0001, // index[33] ALERT_HANDLER_LOC_ALERT_CLASS_1
    4'b 0001, // index[34] ALERT_HANDLER_LOC_ALERT_CLASS_2
    4'b 0001, // index[35] ALERT_HANDLER_LOC_ALERT_CLASS_3
    4'b 0001, // index[36] ALERT_HANDLER_LOC_ALERT_CLASS_4
    4'b 0001, // index[37] ALERT_HANDLER_LOC_ALERT_CAUSE_0
    4'b 0001, // index[38] ALERT_HANDLER_LOC_ALERT_CAUSE_1
    4'b 0001, // index[39] ALERT_HANDLER_LOC_ALERT_CAUSE_2
    4'b 0001, // index[40] ALERT_HANDLER_LOC_ALERT_CAUSE_3
    4'b 0001, // index[41] ALERT_HANDLER_LOC_ALERT_CAUSE_4
    4'b 0001, // index[42] ALERT_HANDLER_CLASSA_REGWEN
    4'b 0011, // index[43] ALERT_HANDLER_CLASSA_CTRL
    4'b 0001, // index[44] ALERT_HANDLER_CLASSA_CLR_REGWEN
    4'b 0001, // index[45] ALERT_HANDLER_CLASSA_CLR
    4'b 0011, // index[46] ALERT_HANDLER_CLASSA_ACCUM_CNT
    4'b 0011, // index[47] ALERT_HANDLER_CLASSA_ACCUM_THRESH
    4'b 1111, // index[48] ALERT_HANDLER_CLASSA_TIMEOUT_CYC
    4'b 1111, // index[49] ALERT_HANDLER_CLASSA_PHASE0_CYC
    4'b 1111, // index[50] ALERT_HANDLER_CLASSA_PHASE1_CYC
    4'b 1111, // index[51] ALERT_HANDLER_CLASSA_PHASE2_CYC
    4'b 1111, // index[52] ALERT_HANDLER_CLASSA_PHASE3_CYC
    4'b 1111, // index[53] ALERT_HANDLER_CLASSA_ESC_CNT
    4'b 0001, // index[54] ALERT_HANDLER_CLASSA_STATE
    4'b 0001, // index[55] ALERT_HANDLER_CLASSB_REGWEN
    4'b 0011, // index[56] ALERT_HANDLER_CLASSB_CTRL
    4'b 0001, // index[57] ALERT_HANDLER_CLASSB_CLR_REGWEN
    4'b 0001, // index[58] ALERT_HANDLER_CLASSB_CLR
    4'b 0011, // index[59] ALERT_HANDLER_CLASSB_ACCUM_CNT
    4'b 0011, // index[60] ALERT_HANDLER_CLASSB_ACCUM_THRESH
    4'b 1111, // index[61] ALERT_HANDLER_CLASSB_TIMEOUT_CYC
    4'b 1111, // index[62] ALERT_HANDLER_CLASSB_PHASE0_CYC
    4'b 1111, // index[63] ALERT_HANDLER_CLASSB_PHASE1_CYC
    4'b 1111, // index[64] ALERT_HANDLER_CLASSB_PHASE2_CYC
    4'b 1111, // index[65] ALERT_HANDLER_CLASSB_PHASE3_CYC
    4'b 1111, // index[66] ALERT_HANDLER_CLASSB_ESC_CNT
    4'b 0001, // index[67] ALERT_HANDLER_CLASSB_STATE
    4'b 0001, // index[68] ALERT_HANDLER_CLASSC_REGWEN
    4'b 0011, // index[69] ALERT_HANDLER_CLASSC_CTRL
    4'b 0001, // index[70] ALERT_HANDLER_CLASSC_CLR_REGWEN
    4'b 0001, // index[71] ALERT_HANDLER_CLASSC_CLR
    4'b 0011, // index[72] ALERT_HANDLER_CLASSC_ACCUM_CNT
    4'b 0011, // index[73] ALERT_HANDLER_CLASSC_ACCUM_THRESH
    4'b 1111, // index[74] ALERT_HANDLER_CLASSC_TIMEOUT_CYC
    4'b 1111, // index[75] ALERT_HANDLER_CLASSC_PHASE0_CYC
    4'b 1111, // index[76] ALERT_HANDLER_CLASSC_PHASE1_CYC
    4'b 1111, // index[77] ALERT_HANDLER_CLASSC_PHASE2_CYC
    4'b 1111, // index[78] ALERT_HANDLER_CLASSC_PHASE3_CYC
    4'b 1111, // index[79] ALERT_HANDLER_CLASSC_ESC_CNT
    4'b 0001, // index[80] ALERT_HANDLER_CLASSC_STATE
    4'b 0001, // index[81] ALERT_HANDLER_CLASSD_REGWEN
    4'b 0011, // index[82] ALERT_HANDLER_CLASSD_CTRL
    4'b 0001, // index[83] ALERT_HANDLER_CLASSD_CLR_REGWEN
    4'b 0001, // index[84] ALERT_HANDLER_CLASSD_CLR
    4'b 0011, // index[85] ALERT_HANDLER_CLASSD_ACCUM_CNT
    4'b 0011, // index[86] ALERT_HANDLER_CLASSD_ACCUM_THRESH
    4'b 1111, // index[87] ALERT_HANDLER_CLASSD_TIMEOUT_CYC
    4'b 1111, // index[88] ALERT_HANDLER_CLASSD_PHASE0_CYC
    4'b 1111, // index[89] ALERT_HANDLER_CLASSD_PHASE1_CYC
    4'b 1111, // index[90] ALERT_HANDLER_CLASSD_PHASE2_CYC
    4'b 1111, // index[91] ALERT_HANDLER_CLASSD_PHASE3_CYC
    4'b 1111, // index[92] ALERT_HANDLER_CLASSD_ESC_CNT
    4'b 0001  // index[93] ALERT_HANDLER_CLASSD_STATE
  };

endpackage

