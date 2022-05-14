// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This has some assertions that check the inputs from rstmgr react according to
// the pwrmgr outputs. The rstmgr inputs are generated by the base sequences, but
// these assertions will also be useful at full chip level.
interface pwrmgr_rstmgr_sva_if
  import pwrmgr_pkg::*, pwrmgr_reg_pkg::NumRstReqs;
  import pwrmgr_clk_ctrl_agent_pkg::*;
(
  input logic                            clk_i,
  input logic                            rst_ni,
  input logic                            clk_slow_i,
  input logic                            rst_slow_ni,
  // Input resets.
  input logic         [  NumRstReqs-1:0] rstreqs_i,
  input logic         [  NumRstReqs-1:0] reset_en,
  input logic                            sw_rst_req_i,
  input logic                            main_rst_req_i,
  input logic                            esc_rst_req_i,
  // The inputs from pwrmgr.
  input logic         [PowerDomains-1:0] rst_lc_req,
  input logic         [PowerDomains-1:0] rst_sys_req,
  input logic         [HwResetWidth-1:0] rstreqs,
  input logic                            main_pd_n,
  input logic                            ndm_sys_req,
  input reset_cause_e                    reset_cause,
  // The inputs from rstmgr.
  input logic         [PowerDomains-1:0] rst_lc_src_n,
  input logic         [PowerDomains-1:0] rst_sys_src_n
);

  // Number of cycles for the LC/SYS reset handshake.
  localparam int MIN_LC_SYS_CYCLES = 0;
  localparam int MAX_LC_SYS_CYCLES = 24;
  `define LC_SYS_CYCLES ##[MIN_LC_SYS_CYCLES:MAX_LC_SYS_CYCLES]

  // Number of cycles for the output resets.
  localparam int MIN_RST_CYCLES = 0;
  localparam int MAX_RST_CYCLES = 4;
  `define RST_CYCLES ##[MIN_RST_CYCLES:MAX_RST_CYCLES]

  // output reset cycle with a clk enalbe disable
  localparam int MIN_MAIN_RST_CYCLES = 0;
  localparam int MAX_MAIN_RST_CYCLES = pwrmgr_clk_ctrl_agent_pkg::MAIN_CLK_DELAY_MAX;
  `define MAIN_RST_CYCLES ##[MIN_MAIN_RST_CYCLES:MAX_MAIN_RST_CYCLES]

  localparam int MIN_ESC_RST_CYCLES = 0;
  localparam int MAX_ESC_RST_CYCLES = pwrmgr_clk_ctrl_agent_pkg::ESC_CLK_DELAY_MAX * 8;
  `define ESC_RST_CYCLES ##[MIN_ESC_RST_CYCLES:MAX_ESC_RST_CYCLES]

  bit disable_sva;
  bit reset_or_disable;

  always_comb reset_or_disable = !rst_ni || !rst_slow_ni || disable_sva;

  bit check_rstreqs_en = 1;

`ifdef UVM
  import uvm_pkg::*;

  initial
    forever begin
      uvm_config_db#(bit)::wait_modified(null, "pwrmgr_rstmgr_sva_if", "check_rstreqs_en");
      if (!uvm_config_db#(bit)::get(
              null, "pwrmgr_rstmgr_sva_if", "check_rstreqs_en", check_rstreqs_en
          )) begin
        `uvm_info("pwrmgr_rstmgr_sva_if", "Can't find check_rstreqs_en", UVM_LOW)
      end else begin
        `uvm_info("pwrmgr_rstmgr_sva_if", $sformatf(
                  "Local set check_rstreqs_en=%b", check_rstreqs_en), UVM_LOW)
      end
    end
`endif

  logic [PowerDomains-1:0] actual_sys_req;
  always_comb begin
    actual_sys_req = rst_sys_req | {PowerDomains{ndm_sys_req && reset_cause == ResetNone}};
  end

  // Lc and Sys handshake: pwrmgr rst_*_req causes rstmgr rst_*_src_n
  for (genvar pd = 0; pd < PowerDomains; ++pd) begin : gen_assertions_per_power_domains
    `ASSERT(LcHandshakeOn_A, rst_lc_req[pd] |-> `LC_SYS_CYCLES !rst_lc_req[pd] || !rst_lc_src_n[pd],
            clk_i, reset_or_disable)
    `ASSERT(LcHandshakeOff_A, !rst_lc_req[pd] |-> `LC_SYS_CYCLES rst_lc_req[pd] || rst_lc_src_n[pd],
            clk_i, reset_or_disable)
    `ASSERT(SysHandshakeOn_A,
            actual_sys_req[pd] |-> `LC_SYS_CYCLES !actual_sys_req[pd] || !rst_sys_src_n[pd], clk_i,
            reset_or_disable)
    `ASSERT(SysHandshakeOff_A,
            !actual_sys_req[pd] |-> `LC_SYS_CYCLES actual_sys_req[pd] || rst_sys_src_n[pd], clk_i,
            reset_or_disable)
  end : gen_assertions_per_power_domains
  `undef LC_SYS_CYCLES

  // Reset ins to outs.
  for (genvar rst = 0; rst < NumRstReqs; ++rst) begin : gen_hw_resets
    `ASSERT(HwResetOn_A,
            $rose(
                rstreqs_i[rst] && reset_en[rst]
            ) |-> `MAIN_RST_CYCLES rstreqs[rst], clk_slow_i, reset_or_disable || !check_rstreqs_en)
    `ASSERT(HwResetOff_A,
            $fell(
                rstreqs_i[rst] && reset_en[rst]
            ) |-> `MAIN_RST_CYCLES !rstreqs[rst], clk_slow_i, reset_or_disable || !check_rstreqs_en)
  end

  // This is used to ignore main_rst_req_i (wired to rst_main_n) if it happens during low power,
  // since as part of deep sleep rst_main_n will trigger and not because of a power glitch.
  logic rst_main_n_ignored_for_main_pwr_rst;
  always_ff @(posedge clk_slow_i or negedge rst_slow_ni) begin
    if (!rst_slow_ni) begin
      rst_main_n_ignored_for_main_pwr_rst <= 0;
    end else if (!main_pd_n && reset_cause == LowPwrEntry) begin
      rst_main_n_ignored_for_main_pwr_rst <= 1;
    end else if (reset_cause != LowPwrEntry) begin
      rst_main_n_ignored_for_main_pwr_rst <= 0;
    end
  end

  `ASSERT(MainPwrRstOn_A,
          $rose(
              main_rst_req_i && !rst_main_n_ignored_for_main_pwr_rst
          ) |-> `MAIN_RST_CYCLES rstreqs[ResetMainPwrIdx], clk_slow_i,
          reset_or_disable || !check_rstreqs_en)
  `ASSERT(MainPwrRstOff_A,
          $fell(
              main_rst_req_i
          ) |-> `MAIN_RST_CYCLES !rstreqs[ResetMainPwrIdx], clk_slow_i,
          reset_or_disable || !check_rstreqs_en)

   // Singals in EscRstOn_A and EscRstOff_A are sampled with slow and fast clock.
   // Since fast clock can be gated, use fast clock to evaluate cycle delay
   // to avoid spurious failure.

  `ASSERT(EscRstOn_A,
          $rose(
              esc_rst_req_i
          ) |-> `ESC_RST_CYCLES rstreqs[ResetEscIdx], clk_i,
          reset_or_disable || !check_rstreqs_en)
  `ASSERT(EscRstOff_A,
          $fell(
              esc_rst_req_i
          ) |-> `ESC_RST_CYCLES !rstreqs[ResetEscIdx], clk_i,
          reset_or_disable || !check_rstreqs_en)
  // Software initiated resets are not sent to rstmgr since they originated there.
  `undef RST_CYCLES
  `undef MAIN_RST_CYCLES
  `undef ESC_RST_CYCLES
endinterface
