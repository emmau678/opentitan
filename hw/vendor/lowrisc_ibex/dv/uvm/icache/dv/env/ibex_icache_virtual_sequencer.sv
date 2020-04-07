// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class ibex_icache_virtual_sequencer extends dv_base_virtual_sequencer #(
    .CFG_T(ibex_icache_env_cfg),
    .COV_T(ibex_icache_env_cov)
  );
  `uvm_component_utils(ibex_icache_virtual_sequencer)

  ibex_icache_sequencer ibex_icache_sequencer_h;
  ibex_mem_intf_slave_sequencer ibex_mem_intf_slave_sequencer_h;

  `uvm_component_new

endclass
