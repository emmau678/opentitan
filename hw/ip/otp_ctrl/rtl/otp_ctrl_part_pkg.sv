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

  localparam part_info_t PartInfo [NumPart] = '{
    // CREATOR_SW_CFG
    '{
      variant:    Unbuffered,
      offset:     11'd0,
      size:       768,
      key_sel:    key_sel_e'('0),
      secret:     1'b0,
      hw_digest:  1'b0,
      write_lock: 1'b1,
      read_lock:  1'b0
    },
    // OWNER_SW_CFG
    '{
      variant:    Unbuffered,
      offset:     11'd768,
      size:       768,
      key_sel:    key_sel_e'('0),
      secret:     1'b0,
      hw_digest:  1'b0,
      write_lock: 1'b1,
      read_lock:  1'b0
    },
    // HW_CFG
    '{
      variant:    Buffered,
      offset:     11'd1536,
      size:       176,
      key_sel:    key_sel_e'('0),
      secret:     1'b0,
      hw_digest:  1'b1,
      write_lock: 1'b1,
      read_lock:  1'b0
    },
    // SECRET0
    '{
      variant:    Buffered,
      offset:     11'd1712,
      size:       40,
      key_sel:    Secret0Key,
      secret:     1'b1,
      hw_digest:  1'b1,
      write_lock: 1'b1,
      read_lock:  1'b1
    },
    // SECRET1
    '{
      variant:    Buffered,
      offset:     11'd1752,
      size:       88,
      key_sel:    Secret1Key,
      secret:     1'b1,
      hw_digest:  1'b1,
      write_lock: 1'b1,
      read_lock:  1'b1
    },
    // SECRET2
    '{
      variant:    Buffered,
      offset:     11'd1840,
      size:       120,
      key_sel:    Secret2Key,
      secret:     1'b1,
      hw_digest:  1'b1,
      write_lock: 1'b1,
      read_lock:  1'b1
    },
    // LIFE_CYCLE
    '{
      variant:    LifeCycle,
      offset:     11'd1960,
      size:       88,
      key_sel:    key_sel_e'('0),
      secret:     1'b0,
      hw_digest:  1'b0,
      write_lock: 1'b0,
      read_lock:  1'b0
    }
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

endpackage : otp_ctrl_part_pkg
