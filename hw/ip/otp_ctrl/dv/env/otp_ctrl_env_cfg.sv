// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`define OTP_CLK_CONSTRAINT(FREQ_) \
  FREQ_ dist { \
    6       :/ 2, \
    [24:25] :/ 2, \
    [26:47] :/ 1, \
    [48:50] :/ 2, \
    [51:95] :/ 1, \
    96      :/ 1, \
    [97:99] :/ 1, \
    100     :/ 1  \
  };

class otp_ctrl_env_cfg extends cip_base_env_cfg #(.RAL_T(otp_ctrl_core_reg_block));

  // ext component cfgs
  rand push_pull_agent_cfg#(.DeviceDataWidth(SRAM_DATA_SIZE))
      m_sram_pull_agent_cfg[NumSramKeyReqSlots];
  rand push_pull_agent_cfg#(.DeviceDataWidth(OTBN_DATA_SIZE))  m_otbn_pull_agent_cfg;
  rand push_pull_agent_cfg#(.DeviceDataWidth(FLASH_DATA_SIZE)) m_flash_data_pull_agent_cfg;
  rand push_pull_agent_cfg#(.DeviceDataWidth(FLASH_DATA_SIZE)) m_flash_addr_pull_agent_cfg;
  rand push_pull_agent_cfg#(.DeviceDataWidth(1), .HostDataWidth(LC_PROG_DATA_SIZE))
      m_lc_prog_pull_agent_cfg;

  // Memory backdoor util instance for OTP.
  mem_bkdr_util mem_bkdr_util_h;

  // ext interfaces
  otp_ctrl_vif otp_ctrl_vif;
  bit backdoor_clear_mem;

  // This value is updated in sequence when backdoor inject ECC error
  otp_ecc_err_e ecc_err = OtpNoEccErr;

  // Check ECC errors
  otp_ecc_err_e ecc_chk_err [NumPart] = '{default:OtpNoEccErr};

  // values for otp_ctrl_if signals connected to DUT
  rand otp_ctrl_ast_inputs_cfg dut_cfg;

  // TODO: reggen tool optimization. Temp mannual setup for prim_tl_agent.
  rand tl_agent_cfg            prim_tl_agent_cfg;

  `uvm_object_utils_begin(otp_ctrl_env_cfg)
  `uvm_object_utils_end

  `uvm_object_new

  constraint clk_freq_mhz_c {
    `OTP_CLK_CONSTRAINT(clk_freq_mhz)
    foreach (clk_freqs_mhz[i]) {
      `OTP_CLK_CONSTRAINT(clk_freqs_mhz[i])
    }
  }

  virtual function void initialize(bit [31:0] csr_base_addr = '1);
    // TODO: reggen tool optimization.
    // Enable these codes once prim_reg_block has register place holders.
    // string prim_ral_name = "otp_ctrl_prim_reg_block";
    // ral_model_names.push_back(prim_ral_name);
    // clk_freqs_mhz[prim_ral_name] = clk_freq_mhz;

    list_of_alerts = otp_ctrl_env_pkg::LIST_OF_ALERTS;
    num_edn = 1;
    tl_intg_alert_name = "fatal_bus_integ_error";

    super.initialize(csr_base_addr);

    // create push_pull agent config obj
    for (int i = 0; i < NumSramKeyReqSlots; i++) begin
      string cfg_name = $sformatf("sram_pull_agent_cfg[%0d]", i);
      m_sram_pull_agent_cfg[i] = push_pull_agent_cfg#(.DeviceDataWidth(SRAM_DATA_SIZE))::type_id
                                 ::create(cfg_name);
      m_sram_pull_agent_cfg[i].agent_type = PullAgent;
    end

    m_otbn_pull_agent_cfg = push_pull_agent_cfg#(.DeviceDataWidth(OTBN_DATA_SIZE))::type_id
                            ::create("m_otbn_pull_agent_cfg");
    m_otbn_pull_agent_cfg.agent_type = PullAgent;

    m_flash_data_pull_agent_cfg = push_pull_agent_cfg#(.DeviceDataWidth(FLASH_DATA_SIZE))::type_id
                                  ::create("m_flash_data_pull_agent_cfg");
    m_flash_data_pull_agent_cfg.agent_type = PullAgent;
    m_flash_addr_pull_agent_cfg = push_pull_agent_cfg#(.DeviceDataWidth(FLASH_DATA_SIZE))::type_id
                                  ::create("m_flash_addr_pull_agent_cfg");
    m_flash_addr_pull_agent_cfg.agent_type = PullAgent;

    m_lc_prog_pull_agent_cfg = push_pull_agent_cfg#(.HostDataWidth(LC_PROG_DATA_SIZE),
                               .DeviceDataWidth(1))::type_id::create("m_lc_prog_pull_agent_cfg");
    m_lc_prog_pull_agent_cfg.agent_type = PullAgent;

    // TODO: reggen tool optimization. Temp mannual setup for prim_tl_agent.
    prim_tl_agent_cfg = tl_agent_cfg::type_id::create("prim_tl_agent_cfg");
    prim_tl_agent_cfg.if_mode = dv_utils_pkg::Host;
    prim_tl_agent_cfg.host_can_stall_rsp_when_a_valid_high = $urandom_range(0, 1);
    prim_tl_agent_cfg.allow_a_valid_drop_wo_a_ready = $urandom_range(0, 1);

    // set num_interrupts & num_alerts
    begin
      uvm_reg rg = ral.get_reg_by_name("intr_state");
      if (rg != null) begin
        num_interrupts = ral.intr_state.get_n_used_bits();
      end
    end

    // only support 1 outstanding TL items in tlul_adapter
    m_tl_agent_cfg.max_outstanding_req = 1;

    // create the inputs cfg instance
    dut_cfg = otp_ctrl_ast_inputs_cfg::type_id::create("dut_cfg");
  endfunction

endclass

`undef OTP_CLK_CONSTRAINT
