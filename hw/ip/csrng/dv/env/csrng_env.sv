// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class csrng_env extends cip_base_env #(
    .CFG_T              (csrng_env_cfg),
    .COV_T              (csrng_env_cov),
    .VIRTUAL_SEQUENCER_T(csrng_virtual_sequencer),
    .SCOREBOARD_T       (csrng_scoreboard)
  );
  `uvm_component_utils(csrng_env)

  push_pull_agent#(.HostDataWidth(entropy_src_pkg::FIPS_CSRNG_BUS_WIDTH))  m_entropy_src_agent;
  csrng_agent   m_edn_agent[NUM_HW_APPS];

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // create components
    m_entropy_src_agent = push_pull_agent#(.HostDataWidth(entropy_src_pkg::FIPS_CSRNG_BUS_WIDTH))
                          ::type_id::create("m_entropy_src_agent", this);
    uvm_config_db#(push_pull_agent_cfg#(.HostDataWidth(entropy_src_pkg::FIPS_CSRNG_BUS_WIDTH)))
        ::set(this, "m_entropy_src_agent*", "cfg", cfg.m_entropy_src_agent_cfg);
    cfg.m_entropy_src_agent_cfg.agent_type = push_pull_agent_pkg::PullAgent;
    cfg.m_entropy_src_agent_cfg.if_mode    = dv_utils_pkg::Device;
    cfg.m_entropy_src_agent_cfg.en_cov     = cfg.en_cov;

    for (int i = 0; i < NUM_HW_APPS; i++) begin
      string edn_agent_name = $sformatf("m_edn_agent[%0d]", i);
      m_edn_agent[i] = csrng_agent::type_id::create(edn_agent_name, this);
      uvm_config_db#(csrng_agent_cfg)::set(this, $sformatf("%0s*", edn_agent_name), "cfg", cfg.m_edn_agent_cfg[i]);
      cfg.m_edn_agent_cfg[i].if_mode = dv_utils_pkg::Host;
      cfg.m_edn_agent_cfg[i].en_cov  = cfg.en_cov;

      if (!uvm_config_db#(virtual pins_if)::get(this, "", "efuse_sw_app_enable_vif",
           cfg.efuse_sw_app_enable_vif)) begin
        `uvm_fatal(get_full_name(), "failed to get efuse_sw_app_enable_vif from uvm_config_db")
      end
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.en_scb) begin
      m_entropy_src_agent.monitor.analysis_port.connect(scoreboard.entropy_src_fifo.analysis_export);
      for (int i = 0; i < NUM_HW_APPS; i++) begin
        m_edn_agent[i].monitor.analysis_port.connect(scoreboard.csrng_cmd_fifo[i].analysis_export);
      end
    end
    if (cfg.is_active) begin
      if (cfg.m_entropy_src_agent_cfg.is_active)
        virtual_sequencer.entropy_src_sequencer_h = m_entropy_src_agent.sequencer;
      for (int i = 0; i < NUM_HW_APPS; i++) begin
        if (cfg.m_edn_agent_cfg[i].is_active)
          virtual_sequencer.edn_sequencer_h[i] = m_edn_agent[i].sequencer;
      end
    end
  endfunction

endclass
