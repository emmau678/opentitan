// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class keymgr_env extends cip_base_env #(
    .CFG_T              (keymgr_env_cfg),
    .COV_T              (keymgr_env_cov),
    .VIRTUAL_SEQUENCER_T(keymgr_virtual_sequencer),
    .SCOREBOARD_T       (keymgr_scoreboard)
  );
  `uvm_component_utils(keymgr_env)

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(keymgr_input_data_vif)::get(this, "", "keymgr_input_data_vif",
        cfg.keymgr_input_data_vif)) begin
      `uvm_fatal(`gfn, "failed to get keymgr_input_data_vif from uvm_config_db")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass
