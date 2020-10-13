// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class otbn_env extends cip_base_env #(
    .CFG_T              (otbn_env_cfg),
    .COV_T              (otbn_env_cov),
    .VIRTUAL_SEQUENCER_T(otbn_virtual_sequencer),
    .SCOREBOARD_T       (otbn_scoreboard)
  );
  `uvm_component_utils(otbn_env)

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg.mem_util = OtbnMemUtilMake(cfg.dut_instance_hier);
    `DV_CHECK_FATAL(cfg.mem_util != null);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  function void final_phase(uvm_phase phase);
    super.final_phase(phase);

    `DV_CHECK_FATAL(cfg.mem_util != null);
    OtbnMemUtilFree(cfg.mem_util);
    cfg.mem_util = null;
  endfunction

endclass
