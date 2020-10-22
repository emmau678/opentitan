// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Package partition metadata.
//
// DO NOT EDIT THIS FILE DIRECTLY.
// It has been generated with hw/ip/otp_ctrl/util/translate-mmap.py

package otp_ctrl_part_pkg;

  import otp_ctrl_reg_pkg::*;
  import otp_ctrl_pkg::*;
  // TODO: need to parse this somehow from an hjson
  localparam part_info_t PartInfo [NumPart] = '{
    // Variant    | offset | size | key_sel | scrambled | HW digest | write_lock | read_lock
    // CREATOR_SW_CFG
    '{Unbuffered,   11'h0,   768,  Secret0Key,  1'b0,      1'b0,      1'b1,       1'b0},
    // OWNER_SW_CFG
    '{Unbuffered,   11'h300, 768,  Secret0Key,  1'b0,      1'b0,      1'b1,       1'b0},
    // HW_CFG
    '{Buffered,     11'h600, 176,  Secret0Key,  1'b0,      1'b1,      1'b1,       1'b0},
    // SECRET0
    '{Buffered,     11'h6B0, 40,   Secret0Key,  1'b1,      1'b1,      1'b1,       1'b1},
    // SECRET1
    '{Buffered,     11'h6D8, 88,   Secret1Key,  1'b1,      1'b1,      1'b1,       1'b1},
    // SECRET2
    '{Buffered,     11'h730, 120,  Secret2Key,  1'b1,      1'b1,      1'b1,       1'b1},
    // LIFE_CYCLE
    '{LifeCycle,    11'h7A8, 88,   Secret0Key,  1'b0,      1'b0,      1'b0,       1'b0}
  };

  typedef enum {
    CreatorSwCfgIdx,
    OwnerSwCfgIdx,
    HwCfgIdx,
    Secret0Idx,
    Secret1Idx,
    Secret2Idx,
    LifeCycleIdx,
    // These are not "real partitions", but in terms of implementation it is convenient to
    // add these at the end of certain arrays.
    DaiIdx,
    LciIdx,
    KdiIdx,
    // Number of agents is the last idx+1.
    NumAgentsIdx
  } part_idx_e;

  parameter int NumAgents = int'(NumAgentsIdx);
  parameter int NumHwCfgBits = PartInfo[HwCfgIdx].size*8;

endmodule : otp_ctrl_part_pkg
