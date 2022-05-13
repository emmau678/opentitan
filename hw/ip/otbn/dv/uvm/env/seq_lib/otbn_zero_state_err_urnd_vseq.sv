// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class otbn_zero_state_err_urnd_vseq extends otbn_single_vseq;
  `uvm_object_utils(otbn_zero_state_err_urnd_vseq)
  `uvm_object_new

  task body();
    fork
      begin
        super.body();
      end
      begin
        bit [31:0] err_val = 32'd1 << 20;
        string prng_path = "tb.dut.u_otbn_core.u_otbn_rnd.u_xoshiro256pp.xoshiro_d";

        cfg.clk_rst_vif.wait_clks($urandom_range(10, 1000));
        `DV_CHECK_FATAL(uvm_hdl_force(prng_path, 'b0) == 1);
        cfg.clk_rst_vif.wait_clks(1);
        cfg.model_agent_cfg.vif.otbn_set_no_sec_wipe_chk();
        cfg.model_agent_cfg.vif.send_err_escalation(err_val);
        `uvm_info(`gfn,"injecting zero state error into ISS", UVM_HIGH)
        `DV_CHECK_FATAL(uvm_hdl_release(prng_path) == 1);
        reset_if_locked();
      end
    join

  endtask : body

endclass : otbn_zero_state_err_urnd_vseq
