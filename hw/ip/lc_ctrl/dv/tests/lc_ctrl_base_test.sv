// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class lc_ctrl_base_test extends cip_base_test #(
  .CFG_T(lc_ctrl_env_cfg),
  .ENV_T(lc_ctrl_env)
);

  `uvm_component_utils(lc_ctrl_base_test)
  `uvm_component_new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Enable JTAG TAP CSR access via command line option
    void'($value$plusargs("jtag_csr=%0b", cfg.jtag_csr));

  endfunction : build_phase

  // Add message demotes here
  virtual function void add_message_demotes(dv_report_catcher catcher);
    string msg;

    // Demote field access warnings to infos
    msg = "\s*Individual field access not available for field.*";
    catcher.add_change_sev("RegModel", msg, UVM_INFO);

    // Demote field access warnings to infos
    msg = "\s*Target bus does not support byte enabling.*";
    catcher.add_change_sev("RegModel", msg, UVM_INFO);

    // Demote address maps warnings
    msg = "\s*map .* does not seem to be initialized correctly.*";
    catcher.add_change_sev("RegModel", msg, UVM_INFO);
  endfunction

endclass : lc_ctrl_base_test
