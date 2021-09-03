// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_core_ibex_reg_pkg;

  // Param list
  parameter int NumSwAlerts = 2;
  parameter int NumRegions = 2;
  parameter int NumAlerts = 4;

  // Address widths within the block
  parameter int CfgAw = 7;

  //////////////////////////////////////////////
  // Typedefs for registers for cfg interface //
  //////////////////////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } fatal_sw_err;
    struct packed {
      logic        q;
      logic        qe;
    } recov_sw_err;
    struct packed {
      logic        q;
      logic        qe;
    } fatal_hw_err;
    struct packed {
      logic        q;
      logic        qe;
    } recov_hw_err;
  } rv_core_ibex_reg2hw_alert_test_reg_t;

  typedef struct packed {
    logic [1:0]  q;
  } rv_core_ibex_reg2hw_sw_alert_mreg_t;

  typedef struct packed {
    logic        q;
  } rv_core_ibex_reg2hw_ibus_addr_en_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_ibus_addr_matching_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_ibus_remap_addr_mreg_t;

  typedef struct packed {
    logic        q;
  } rv_core_ibex_reg2hw_dbus_addr_en_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_dbus_addr_matching_mreg_t;

  typedef struct packed {
    logic [31:0] q;
  } rv_core_ibex_reg2hw_dbus_remap_addr_mreg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } alert_en;
    struct packed {
      logic        q;
    } wdog_en;
  } rv_core_ibex_reg2hw_nmi_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } alert;
    struct packed {
      logic        q;
    } wdog;
  } rv_core_ibex_reg2hw_nmi_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } alert;
    struct packed {
      logic        d;
      logic        de;
    } wdog;
  } rv_core_ibex_hw2reg_nmi_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } reg_intg_err;
    struct packed {
      logic        d;
      logic        de;
    } fatal_intg_err;
    struct packed {
      logic        d;
      logic        de;
    } fatal_core_err;
    struct packed {
      logic        d;
      logic        de;
    } recov_core_err;
  } rv_core_ibex_hw2reg_err_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } rv_core_ibex_hw2reg_rnd_data_reg_t;

  typedef struct packed {
    logic        d;
  } rv_core_ibex_hw2reg_rnd_status_reg_t;

  // Register -> HW type for cfg interface
  typedef struct packed {
    rv_core_ibex_reg2hw_alert_test_reg_t alert_test; // [275:268]
    rv_core_ibex_reg2hw_sw_alert_mreg_t [1:0] sw_alert; // [267:264]
    rv_core_ibex_reg2hw_ibus_addr_en_mreg_t [1:0] ibus_addr_en; // [263:262]
    rv_core_ibex_reg2hw_ibus_addr_matching_mreg_t [1:0] ibus_addr_matching; // [261:198]
    rv_core_ibex_reg2hw_ibus_remap_addr_mreg_t [1:0] ibus_remap_addr; // [197:134]
    rv_core_ibex_reg2hw_dbus_addr_en_mreg_t [1:0] dbus_addr_en; // [133:132]
    rv_core_ibex_reg2hw_dbus_addr_matching_mreg_t [1:0] dbus_addr_matching; // [131:68]
    rv_core_ibex_reg2hw_dbus_remap_addr_mreg_t [1:0] dbus_remap_addr; // [67:4]
    rv_core_ibex_reg2hw_nmi_enable_reg_t nmi_enable; // [3:2]
    rv_core_ibex_reg2hw_nmi_state_reg_t nmi_state; // [1:0]
  } rv_core_ibex_cfg_reg2hw_t;

  // HW -> register type for cfg interface
  typedef struct packed {
    rv_core_ibex_hw2reg_nmi_state_reg_t nmi_state; // [45:42]
    rv_core_ibex_hw2reg_err_status_reg_t err_status; // [41:34]
    rv_core_ibex_hw2reg_rnd_data_reg_t rnd_data; // [33:1]
    rv_core_ibex_hw2reg_rnd_status_reg_t rnd_status; // [0:0]
  } rv_core_ibex_cfg_hw2reg_t;

  // Register offsets for cfg interface
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_ALERT_TEST_OFFSET = 7'h 0;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_REGWEN_0_OFFSET = 7'h 4;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_REGWEN_1_OFFSET = 7'h 8;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_0_OFFSET = 7'h c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_SW_ALERT_1_OFFSET = 7'h 10;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REGWEN_0_OFFSET = 7'h 14;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REGWEN_1_OFFSET = 7'h 18;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_EN_0_OFFSET = 7'h 1c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_EN_1_OFFSET = 7'h 20;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_MATCHING_0_OFFSET = 7'h 24;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_ADDR_MATCHING_1_OFFSET = 7'h 28;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REMAP_ADDR_0_OFFSET = 7'h 2c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_IBUS_REMAP_ADDR_1_OFFSET = 7'h 30;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REGWEN_0_OFFSET = 7'h 34;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REGWEN_1_OFFSET = 7'h 38;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_EN_0_OFFSET = 7'h 3c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_EN_1_OFFSET = 7'h 40;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_MATCHING_0_OFFSET = 7'h 44;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_ADDR_MATCHING_1_OFFSET = 7'h 48;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REMAP_ADDR_0_OFFSET = 7'h 4c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_DBUS_REMAP_ADDR_1_OFFSET = 7'h 50;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_NMI_ENABLE_OFFSET = 7'h 54;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_NMI_STATE_OFFSET = 7'h 58;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_ERR_STATUS_OFFSET = 7'h 5c;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_RND_DATA_OFFSET = 7'h 60;
  parameter logic [CfgAw-1:0] RV_CORE_IBEX_RND_STATUS_OFFSET = 7'h 64;

  // Reset values for hwext registers and their fields for cfg interface
  parameter logic [3:0] RV_CORE_IBEX_ALERT_TEST_RESVAL = 4'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_FATAL_SW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_RECOV_SW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_FATAL_HW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_ALERT_TEST_RECOV_HW_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_RND_STATUS_RESVAL = 1'h 0;
  parameter logic [0:0] RV_CORE_IBEX_RND_STATUS_RND_DATA_VALID_RESVAL = 1'h 0;

  // Register index for cfg interface
  typedef enum int {
    RV_CORE_IBEX_ALERT_TEST,
    RV_CORE_IBEX_SW_ALERT_REGWEN_0,
    RV_CORE_IBEX_SW_ALERT_REGWEN_1,
    RV_CORE_IBEX_SW_ALERT_0,
    RV_CORE_IBEX_SW_ALERT_1,
    RV_CORE_IBEX_IBUS_REGWEN_0,
    RV_CORE_IBEX_IBUS_REGWEN_1,
    RV_CORE_IBEX_IBUS_ADDR_EN_0,
    RV_CORE_IBEX_IBUS_ADDR_EN_1,
    RV_CORE_IBEX_IBUS_ADDR_MATCHING_0,
    RV_CORE_IBEX_IBUS_ADDR_MATCHING_1,
    RV_CORE_IBEX_IBUS_REMAP_ADDR_0,
    RV_CORE_IBEX_IBUS_REMAP_ADDR_1,
    RV_CORE_IBEX_DBUS_REGWEN_0,
    RV_CORE_IBEX_DBUS_REGWEN_1,
    RV_CORE_IBEX_DBUS_ADDR_EN_0,
    RV_CORE_IBEX_DBUS_ADDR_EN_1,
    RV_CORE_IBEX_DBUS_ADDR_MATCHING_0,
    RV_CORE_IBEX_DBUS_ADDR_MATCHING_1,
    RV_CORE_IBEX_DBUS_REMAP_ADDR_0,
    RV_CORE_IBEX_DBUS_REMAP_ADDR_1,
    RV_CORE_IBEX_NMI_ENABLE,
    RV_CORE_IBEX_NMI_STATE,
    RV_CORE_IBEX_ERR_STATUS,
    RV_CORE_IBEX_RND_DATA,
    RV_CORE_IBEX_RND_STATUS
  } rv_core_ibex_cfg_id_e;

  // Register width information to check illegal writes for cfg interface
  parameter logic [3:0] RV_CORE_IBEX_CFG_PERMIT [26] = '{
    4'b 0001, // index[ 0] RV_CORE_IBEX_ALERT_TEST
    4'b 0001, // index[ 1] RV_CORE_IBEX_SW_ALERT_REGWEN_0
    4'b 0001, // index[ 2] RV_CORE_IBEX_SW_ALERT_REGWEN_1
    4'b 0001, // index[ 3] RV_CORE_IBEX_SW_ALERT_0
    4'b 0001, // index[ 4] RV_CORE_IBEX_SW_ALERT_1
    4'b 0001, // index[ 5] RV_CORE_IBEX_IBUS_REGWEN_0
    4'b 0001, // index[ 6] RV_CORE_IBEX_IBUS_REGWEN_1
    4'b 0001, // index[ 7] RV_CORE_IBEX_IBUS_ADDR_EN_0
    4'b 0001, // index[ 8] RV_CORE_IBEX_IBUS_ADDR_EN_1
    4'b 1111, // index[ 9] RV_CORE_IBEX_IBUS_ADDR_MATCHING_0
    4'b 1111, // index[10] RV_CORE_IBEX_IBUS_ADDR_MATCHING_1
    4'b 1111, // index[11] RV_CORE_IBEX_IBUS_REMAP_ADDR_0
    4'b 1111, // index[12] RV_CORE_IBEX_IBUS_REMAP_ADDR_1
    4'b 0001, // index[13] RV_CORE_IBEX_DBUS_REGWEN_0
    4'b 0001, // index[14] RV_CORE_IBEX_DBUS_REGWEN_1
    4'b 0001, // index[15] RV_CORE_IBEX_DBUS_ADDR_EN_0
    4'b 0001, // index[16] RV_CORE_IBEX_DBUS_ADDR_EN_1
    4'b 1111, // index[17] RV_CORE_IBEX_DBUS_ADDR_MATCHING_0
    4'b 1111, // index[18] RV_CORE_IBEX_DBUS_ADDR_MATCHING_1
    4'b 1111, // index[19] RV_CORE_IBEX_DBUS_REMAP_ADDR_0
    4'b 1111, // index[20] RV_CORE_IBEX_DBUS_REMAP_ADDR_1
    4'b 0001, // index[21] RV_CORE_IBEX_NMI_ENABLE
    4'b 0001, // index[22] RV_CORE_IBEX_NMI_STATE
    4'b 0011, // index[23] RV_CORE_IBEX_ERR_STATUS
    4'b 1111, // index[24] RV_CORE_IBEX_RND_DATA
    4'b 0001  // index[25] RV_CORE_IBEX_RND_STATUS
  };

endpackage

