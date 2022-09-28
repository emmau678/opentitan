// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rv_dm_reg_pkg;

  // Param list
  parameter int NrHarts = 1;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int RegsAw = 2;
  parameter int MemAw = 12;

  ///////////////////////////////////////////////
  // Typedefs for registers for regs interface //
  ///////////////////////////////////////////////

  typedef struct packed {
    logic        q;
    logic        qe;
  } rv_dm_reg2hw_alert_test_reg_t;

  // Register -> HW type for regs interface
  typedef struct packed {
    rv_dm_reg2hw_alert_test_reg_t alert_test; // [1:0]
  } rv_dm_regs_reg2hw_t;

  // Register offsets for regs interface
  parameter logic [RegsAw-1:0] RV_DM_ALERT_TEST_OFFSET = 2'h 0;

  // Reset values for hwext registers and their fields for regs interface
  parameter logic [0:0] RV_DM_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] RV_DM_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;

  // Register index for regs interface
  typedef enum int {
    RV_DM_ALERT_TEST
  } rv_dm_regs_id_e;

  // Register width information to check illegal writes for regs interface
  parameter logic [3:0] RV_DM_REGS_PERMIT [1] = '{
    4'b 0001  // index[0] RV_DM_ALERT_TEST
  };

  // Window parameters for mem interface
  parameter logic [MemAw-1:0] RV_DM_MEM_OFFSET = 12'h 0;
  parameter int unsigned      RV_DM_MEM_SIZE   = 'h 1000;

endpackage
