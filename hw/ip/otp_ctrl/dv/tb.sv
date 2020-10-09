// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
module tb;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import otp_ctrl_env_pkg::*;
  import otp_ctrl_test_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  wire clk, rst_n;
  wire devmode;
  wire [3:0] lc_provision_en;
  // TODO: use standard req/rsp agent
  wire [2:0] pwr_otp;
  wire [NUM_MAX_INTERRUPTS-1:0] interrupts;
  wire intr_otp_operation_done, intr_otp_error;

  // interfaces
  clk_rst_if clk_rst_if(.clk(clk), .rst_n(rst_n));
  pins_if #(NUM_MAX_INTERRUPTS) intr_if(interrupts);
  pins_if #(1) devmode_if(devmode);
  // TODO: use standard req/rsp agent
  pins_if #(3) pwr_otp_if(pwr_otp);
  pins_if #(4) lc_provision_en_if(lc_provision_en);
  tl_if tl_if(.clk(clk), .rst_n(rst_n));

  // dut
  otp_ctrl dut (
    .clk_i                     (clk        ),
    .rst_ni                    (rst_n      ),

    .tl_i                      (tl_if.h2d  ),
    .tl_o                      (tl_if.d2h  ),
    // interrupt
    .intr_otp_operation_done_o (intr_otp_operation_done),
    .intr_otp_error_o          (intr_otp_error),
    // alert
    .alert_rx_i                ('0),
    .alert_tx_o                (  ),
    // ast
    .otp_ast_pwr_seq_o         (  ),
    .otp_ast_pwr_seq_h_i       ('0),
    // edn
    .otp_edn_o                 (  ),
    .otp_edn_i                 ('0),
    // pwrmgr
    .pwr_otp_i                 (pwr_otp[0]),
    .pwr_otp_o                 (pwr_otp[2:1]),
    // lc
    .lc_otp_program_i          ('0),
    .lc_otp_program_o          (  ),
    .lc_otp_token_i            ('0),
    .lc_otp_token_o            (  ),
    .lc_escalate_en_i          (lc_ctrl_pkg::Off),
    .lc_provision_en_i         (lc_provision_en),
    .lc_dft_en_i               ('0),
    .otp_lc_data_o             (  ),
    // keymgr
    .otp_keymgr_key_o          (  ),
    // flash
    .flash_otp_key_i           ('0),
    .flash_otp_key_o           (  ),
    // sram
    .sram_otp_key_i            ('0),
    .sram_otp_key_o            (  ),
    // otbn
    .otbn_otp_key_i            ('0),
    .otbn_otp_key_o            (  ),
    // hw cfg
    .hw_cfg_o                  (  )
  );

  // bind mem_bkdr_if
  `define OTP_CTRL_MEM_HIER \
      dut.u_otp.gen_generic.u_impl_generic.i_prim_ram_1p_adv.u_mem.gen_generic.u_impl_generic

  assign interrupts[OtpOperationDone] = intr_otp_operation_done;
  assign interrupts[OtpErr]           = intr_otp_error;

  bind `OTP_CTRL_MEM_HIER mem_bkdr_if mem_bkdr_if();

  initial begin
    // drive clk and rst_n from clk_if
    clk_rst_if.set_active();
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_vif", clk_rst_if);
    uvm_config_db#(intr_vif)::set(null, "*.env", "intr_vif", intr_if);
    uvm_config_db#(pwr_otp_vif)::set(null, "*.env", "pwr_otp_vif", pwr_otp_if);
    uvm_config_db#(devmode_vif)::set(null, "*.env", "devmode_vif", devmode_if);
    uvm_config_db#(lc_provision_en_vif)::set(null, "*.env", "lc_provision_en_vif",
                                             lc_provision_en_if);
    uvm_config_db#(virtual tl_if)::set(null, "*.env.m_tl_agent*", "vif", tl_if);
    uvm_config_db#(mem_bkdr_vif)::set(null, "*.env", "mem_bkdr_vif",
                                      `OTP_CTRL_MEM_HIER.mem_bkdr_if);
    $timeformat(-12, 0, " ps", 12);
    run_test();
  end

  `undef OTP_CTRL_MEM_HIER
endmodule
