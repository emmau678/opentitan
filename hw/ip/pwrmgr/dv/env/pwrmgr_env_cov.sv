// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Covergoups that are dependent on run-time parameters that may be available
 * only in build_phase can be defined here.
 * Covergroups may also be wrapped inside helper classes if needed.
 */

// Wrapper class for wakeup control covergroup.
class pwrmgr_wakeup_ctrl_cg_wrap;
  // This covers enable, capture, and status of wakeups.
  covergroup wakeup_ctrl_cg(
      string name
  ) with function sample (
      bit enable, bit capture, bit wakeup, bit status
  );
    option.name = name;
    option.per_instance = 1;

    enable_cp: coverpoint enable;
    capture_cp: coverpoint capture;
    wakeup_cp: coverpoint wakeup;
    status_cp: coverpoint status;

    wakeup_cross: cross enable_cp, capture_cp, wakeup_cp, status_cp;
  endgroup

  function new(string name);
    wakeup_ctrl_cg = new(name);
  endfunction

  function void sample (bit enable, bit capture, bit wakeup, bit status);
    wakeup_ctrl_cg.sample(enable, capture, wakeup, status);
  endfunction
endclass

// Wrapper class for wakeup interrupt covergroup.
class pwrmgr_wakeup_intr_cg_wrap;
  // This covers interrupts generated by wakeups.
  covergroup wakeup_intr_cg(
      string name
  ) with function sample (
      bit enable, bit wakeup, bit interrupt
  );
    option.name = name;
    option.per_instance = 1;

    enable_cp: coverpoint enable;
    wakeup_cp: coverpoint wakeup;
    interrupt_cp: coverpoint interrupt;

    interrupt_cross: cross enable_cp, wakeup_cp, interrupt_cp;
  endgroup

  function new(string name);
    wakeup_intr_cg = new(name);
  endfunction

  function void sample (bit enable, bit wakeup, bit interrupt);
    wakeup_intr_cg.sample(enable, wakeup, interrupt);
  endfunction
endclass

class pwrmgr_env_cov extends cip_base_env_cov #(
  .CFG_T(pwrmgr_env_cfg)
);
  `uvm_component_utils(pwrmgr_env_cov)

  // the base class provides the following handles for use:
  // pwrmgr_env_cfg: cfg

  // covergroups
  pwrmgr_wakeup_ctrl_cg_wrap wakeup_ctrl_cg_wrap[pwrmgr_reg_pkg::NumWkups];
  pwrmgr_wakeup_intr_cg_wrap wakeup_intr_cg_wrap[pwrmgr_reg_pkg::NumWkups];

  // This collects coverage on the clock and power control functionality.
  covergroup control_cg with function sample (control_enables_t control_enables, bit sleep);
    core_cp: coverpoint control_enables.core_clk_en;
    io_cp: coverpoint control_enables.io_clk_en;
    usb_lp_cp: coverpoint control_enables.usb_clk_en_lp;
    usb_active_cp: coverpoint control_enables.usb_clk_en_active;
    main_pd_n_cp: coverpoint control_enables.main_pd_n;
    sleep_cp: coverpoint sleep;

    control_cross: cross core_cp, io_cp, usb_lp_cp, usb_active_cp, main_pd_n_cp, sleep_cp;
  endgroup

  covergroup hw_reset_0_cg with function sample (logic reset, logic enable, bit sleep);
    reset_cp: coverpoint reset;
    enable_cp: coverpoint enable;
    sleep_cp: coverpoint sleep;
    reset_cross: cross reset, enable, sleep;
  endgroup

  covergroup hw_reset_1_cg with function sample (logic reset, logic enable, bit sleep);
    reset_cp: coverpoint reset;
    enable_cp: coverpoint enable;
    sleep_cp: coverpoint sleep;
    reset_cross: cross reset_cp, enable_cp, sleep_cp;
  endgroup

  covergroup rstmgr_sw_reset_cg with function sample (logic sw_reset);
    sw_reset_cp: coverpoint sw_reset;
  endgroup

  covergroup main_power_reset_cg with function sample (logic main_power_reset, bit sleep);
    main_power_reset_cp: coverpoint main_power_reset;
    sleep_cp: coverpoint sleep;
    reset_cross: cross main_power_reset_cp, sleep_cp;
  endgroup

  covergroup esc_reset_cg with function sample (logic esc_reset, bit sleep);
    esc_reset_cp: coverpoint esc_reset;
    sleep_cp: coverpoint sleep;
    reset_cross: cross esc_reset_cp, sleep_cp;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    foreach (wakeup_ctrl_cg_wrap[i]) begin
      pwrmgr_env_pkg::wakeup_e wakeup = pwrmgr_env_pkg::wakeup_e'(i);
      wakeup_ctrl_cg_wrap[i] = new({wakeup.name, "_ctrl_cg"});
      wakeup_intr_cg_wrap[i] = new({wakeup.name, "_intr_cg"});
    end
    control_cg = new();
    hw_reset_0_cg = new();
    hw_reset_1_cg = new();
    rstmgr_sw_reset_cg = new();
    main_power_reset_cg = new();
    esc_reset_cg = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // [or instantiate covergroups here]
    // Please instantiate sticky_intr_cov array of objects for all interrupts that are sticky
    // See cip_base_env_cov for details
  endfunction

endclass
