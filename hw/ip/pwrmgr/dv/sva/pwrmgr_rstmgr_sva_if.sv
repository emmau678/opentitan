// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This has some assertions that check the inputs from rstmgr react according to
// the pwrmgr outputs. The rstmgr inputs are generated by the base sequences, but
// these assertions will also be useful at full chip level.
interface pwrmgr_rstmgr_sva_if #(
  parameter int CHECK_RSTREQS = 1
) (
  input logic                                                      clk_i,
  input logic                                                      rst_ni,
  // Input resets.
  input logic                     [pwrmgr_reg_pkg::NumRstReqs-1:0] rstreqs_i,
  input logic                     [pwrmgr_reg_pkg::NumRstReqs-1:0] reset_en,
  input logic                                                      sw_rst_req_i,
  input logic                                                      main_rst_req_i,
  input logic                                                      esc_rst_req_i,
  // The inputs from pwrmgr.
  input logic                     [  pwrmgr_pkg::PowerDomains-1:0] rst_lc_req,
  input logic                     [  pwrmgr_pkg::PowerDomains-1:0] rst_sys_req,
  input logic                     [  pwrmgr_pkg::HwResetWidth-1:0] rstreqs,
  input logic                                                      ndm_sys_req,
  input pwrmgr_pkg::reset_cause_e                                  reset_cause,
  // The inputs from rstmgr.
  input logic                     [  pwrmgr_pkg::PowerDomains-1:0] rst_lc_src_n,
  input logic                     [  pwrmgr_pkg::PowerDomains-1:0] rst_sys_src_n
);

  // Number of cycles for the LC/SYS reset handshake.
  localparam int MIN_LC_SYS_CYCLES = 0;
  localparam int MAX_LC_SYS_CYCLES = 24;
  `define LC_SYS_CYCLES ##[MIN_LC_SYS_CYCLES:MAX_LC_SYS_CYCLES]

  // Number of cycles for the output resets.
  localparam int MIN_RST_CYCLES = 0;
  localparam int MAX_RST_CYCLES = 40;
  `define RST_CYCLES ##[MIN_RST_CYCLES:MAX_RST_CYCLES]

  bit disable_sva;
  bit reset_or_disable;

  always_comb reset_or_disable = !rst_ni || disable_sva;

  function automatic bit sysOrNdmRstReq(int pd);
    return rst_sys_req[pd] || (ndm_sys_req && reset_cause == pwrmgr_pkg::ResetNone);
  endfunction

  // Lc and Sys handshake: pwrmgr rst_*_req causes rstmgr rst_*_src_n
  for (genvar pd = 0; pd < pwrmgr_pkg::PowerDomains; ++pd) begin : gen_assertions_per_power_domains
    `ASSERT(LcHandshakeOn_A, rst_lc_req[pd] |-> `LC_SYS_CYCLES !rst_lc_src_n[pd], clk_i,
            reset_or_disable)
    `ASSERT(LcHandshakeOff_A, !rst_lc_req[pd] |-> `LC_SYS_CYCLES rst_lc_src_n[pd], clk_i,
            reset_or_disable)
    `ASSERT(SysHandshakeOn_A, sysOrNdmRstReq(pd) |-> `LC_SYS_CYCLES !rst_sys_src_n[pd], clk_i,
            reset_or_disable)
    `ASSERT(SysHandshakeOff_A, !sysOrNdmRstReq(pd) |-> `LC_SYS_CYCLES rst_sys_src_n[pd], clk_i,
            reset_or_disable)
  end : gen_assertions_per_power_domains
  `undef LC_SYS_CYCLES

  // Reset ins to outs.
  if (CHECK_RSTREQS) begin : gen_rstreqs_checks
    for (genvar rst = 0; rst < pwrmgr_reg_pkg::NumRstReqs; ++rst) begin : gen_hw_resets
      `ASSERT(HwResetOn_A,
              $rose(
                  rstreqs_i[rst] && reset_en[rst]
              ) |-> `RST_CYCLES rstreqs[rst], clk_i, reset_or_disable)
      `ASSERT(HwResetOff_A,
              $fell(
                  rstreqs_i[rst] && reset_en[rst]
              ) |-> `RST_CYCLES !rstreqs[rst], clk_i, reset_or_disable)
    end


    `ASSERT(MainPwrRstOn_A,
            $rose(
                main_rst_req_i
            ) |-> `RST_CYCLES rstreqs[pwrmgr_pkg::ResetMainPwrIdx], clk_i, reset_or_disable)
    `ASSERT(MainPwrRstOff_A,
            $fell(
                main_rst_req_i
            ) |-> `RST_CYCLES !rstreqs[pwrmgr_pkg::ResetMainPwrIdx], clk_i, reset_or_disable)

    `ASSERT(EscRstOn_A,
            $rose(
                esc_rst_req_i
            ) |-> `RST_CYCLES rstreqs[pwrmgr_pkg::ResetEscIdx], clk_i, reset_or_disable)
    `ASSERT(EscRstOff_A,
            $fell(
                esc_rst_req_i
            ) |-> `RST_CYCLES !rstreqs[pwrmgr_pkg::ResetEscIdx], clk_i, reset_or_disable)

    `ASSERT(SwRstOn_A,
            $rose(
                sw_rst_req_i
            ) |-> `RST_CYCLES rstreqs[pwrmgr_pkg::ResetSwReqIdx], clk_i, reset_or_disable)
    `ASSERT(SwRstOff_A,
            $fell(
                sw_rst_req_i
            ) |-> `RST_CYCLES !rstreqs[pwrmgr_pkg::ResetSwReqIdx], clk_i, reset_or_disable)
  end : gen_rstreqs_checks
  `undef RST_CYCLES
endinterface
