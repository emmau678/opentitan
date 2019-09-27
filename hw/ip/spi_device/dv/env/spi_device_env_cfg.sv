// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class spi_device_env_cfg extends cip_base_env_cfg #(.RAL_T(spi_device_reg_block));
  rand spi_agent_cfg  m_spi_agent_cfg;
  bit [TL_AW-1:0]     sram_start_addr;
  bit [TL_AW-1:0]     sram_end_addr;

  `uvm_object_utils_begin(spi_device_env_cfg)
    `uvm_field_object(m_spi_agent_cfg, UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

  virtual function void initialize(bit [TL_AW-1:0] csr_base_addr = 0,
                                   bit [TL_AW-1:0] csr_addr_map_size = ADDR_MAP_SIZE);
    mem_addr_s mem_addr;
    super.initialize(csr_base_addr, csr_addr_map_size);
    // create spi agent config obj
    m_spi_agent_cfg = spi_agent_cfg::type_id::create("m_spi_agent_cfg");
    // set num_interrupts & num_alerts which will be used to create coverage and more
    num_interrupts = ral.intr_state.get_n_used_bits();

    sram_start_addr     = SRAM_OFFSET;
    sram_end_addr       = sram_start_addr + SRAM_SIZE - 1;
    mem_addr.start_addr = sram_start_addr;
    mem_addr.end_addr   = sram_end_addr;
    mem_addrs.push_back(mem_addr);
  endfunction

endclass
