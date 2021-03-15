// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class pwm_agent_cfg extends dv_base_agent_cfg;

  bit en_monitor = 1'b1; // enable monitor

  // interface handle used by driver, monitor & the sequencer, via cfg handle
  virtual pwm_if vif;

  `uvm_object_utils_begin(pwm_agent_cfg)
  `uvm_object_utils_end
  `uvm_object_new

endclass : pwm_agent_cfg
