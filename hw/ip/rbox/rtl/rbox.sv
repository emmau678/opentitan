// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// rbox module

`include "prim_assert.sv"

module rbox (
  input clk_i,//Always-on 24MHz clock(config)
  input clk_aon_i,//Always-on 200KHz clock(logic)
  input rst_ni,//power-on reset for the 24MHz clock(config)
  input rst_slow_ni,//power-on reset for the 200KHz clock(logic)
  output gsc_rst_o,//GSC reset to rstmgr
  output rbox_intr_o,//rbox interrupt to PLIC

  //Regster interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  //DIO
  input  cio_ac_present_i,//AC power is present
  input  cio_ec_rst_l_i,//EC reset is asserted by some other system agent
  input  cio_key0_in_i,//VolUp button in tablet; column output from the EC in a laptop
  input  cio_key1_in_i,//VolDown button in tablet; row input from keyboard matrix in a laptop
  input  cio_key2_in_i,//TBD button in tablet; row input from keyboard matrix in a laptop
  input  cio_pwrb_in_i,//Power button in both tablet and laptop
  output logic cio_bat_disable_o,//Battery is disconnected
  output logic cio_ec_rst_l_o,//EC reset is asserted by rbox
  output logic cio_key0_out_o,//Passthrough from key0_in, can be configured to invert
  output logic cio_key1_out_o,//Passthrough from key1_in, can be configured to invert
  output logic cio_key2_out_o,//Passthrough from key2_in, can be configured to invert
  output logic cio_pwrb_out_o,//Passthrough from pwrb_in, can be configured to invert
  output logic cio_bat_disable_en_o,
  output logic cio_ec_rst_l_en_o,
  output logic cio_key0_out_en_o,
  output logic cio_key1_out_en_o,
  output logic cio_key2_out_en_o,
  output logic cio_pwrb_out_en_o
);

  import rbox_reg_pkg::* ;

  rbox_reg2hw_t reg2hw;
  rbox_hw2reg_t hw2reg;

  logic pwrb_int, key0_int, key1_int, key2_int, ac_present_int;
  logic pwrb_out_hw, key0_out_hw, key1_out_hw, key2_out_hw, ec_rst_l_hw;
  logic pwrb_out_int, key0_out_int, key1_out_int, key2_out_int, bat_disable_int;

  //Always-on pins
  assign cio_ec_rst_l_en_o = 1'b1;
  assign cio_pwrb_out_en_o = 1'b1;
  assign cio_key0_out_en_o = 1'b1;
  assign cio_key1_out_en_o = 1'b1;
  assign cio_key2_out_en_o = 1'b1;
  assign cio_bat_disable_en_o = 1'b1;

  // Register module
  rbox_reg_top i_reg_top (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .tl_i(tl_i),
    .tl_o(tl_o),
    .reg2hw(reg2hw),
    .hw2reg(hw2reg),
    .devmode_i  (1'b1)
  );

  //Instantiate the autoblock module
  rbox_autoblock i_autoblock (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .clk_aon_i(clk_aon_i),
    .rst_slow_ni(rst_slow_ni),
    .pwrb_int(pwrb_int),
    .key0_int(key0_int),
    .key1_int(key1_int),
    .key2_int(key2_int),
    .pwrb_out_hw(pwrb_out_hw),
    .key0_out_hw(key0_out_hw),
    .key1_out_hw(key1_out_hw),
    .key2_out_hw(key2_out_hw)
  );

  //Instantiate the pin inversion module
  rbox_inv i_inversion (
    .clk_aon_i(clk_aon_i),
    .rst_slow_ni(rst_slow_ni),
    .cio_pwrb_in_i(cio_pwrb_in_i),
    .cio_key0_in_i(cio_key0_in_i),
    .cio_key1_in_i(cio_key1_in_i),
    .cio_key2_in_i(cio_key2_in_i),
    .cio_ac_present_i(cio_ac_present_i),
    .pwrb_out_int(pwrb_out_int),
    .key0_out_int(key0_out_int),
    .key1_out_int(key1_out_int),
    .key2_out_int(key2_out_int),
    .bat_disable_int(bat_disable_int),
    .pwrb_int(pwrb_int),
    .key0_int(key0_int),
    .key1_int(key1_int),
    .key2_int(key2_int),
    .ac_present_int(ac_present_int),
    .cio_bat_disable_o(cio_bat_disable_o),
    .cio_pwrb_out_o(cio_pwrb_out_o),
    .cio_key0_out_o(cio_key0_out_o),
    .cio_key1_out_o(cio_key1_out_o),
    .cio_key2_out_o(cio_key2_out_o)
  );

  //Instantiate the pin visibility and override module
  rbox_pin i_pin_vis_ovd (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .clk_aon_i(clk_aon_i),
    .rst_slow_ni(rst_slow_ni),
    .cio_pwrb_in_i(cio_pwrb_in_i),
    .cio_key0_in_i(cio_key0_in_i),
    .cio_key1_in_i(cio_key1_in_i),
    .cio_key2_in_i(cio_key2_in_i),
    .cio_ac_present_i(cio_ac_present_i),
    .cio_ec_rst_l_i(cio_ec_rst_l_i),
    .pwrb_out_hw(pwrb_out_hw),
    .key0_out_hw(key0_out_hw),
    .key1_out_hw(key1_out_hw),
    .key2_out_hw(key2_out_hw),
    .bat_disable_hw(bat_disable_hw),
    .ec_rst_l_hw(ec_rst_l_hw),
    .pwrb_out_int(pwrb_out_int),
    .key0_out_int(key0_out_int),
    .key1_out_int(key1_out_int),
    .key2_out_int(key2_out_int),
    .bat_disable_int(bat_disable_int),
    .cio_ec_rst_l_o(cio_ec_rst_l_o)
  );

  //Instantiate key-triggered interrupt module
  rbox_keyintr i_keyintr (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .clk_aon_i(clk_aon_i),
    .rst_slow_ni(rst_slow_ni),
    .pwrb_int(pwrb_int),
    .key0_int(key0_int),
    .key1_int(key1_int),
    .key2_int(key2_int),
    .ac_present_int(ac_present_int),
    .cio_ec_rst_l_i(cio_ec_rst_l_i)
  );

  //Instantiate combo module
  rbox_combo i_combo (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .clk_aon_i(clk_aon_i),
    .rst_slow_ni(rst_slow_ni),
    .pwrb_int(pwr_int),
    .key0_int(key0_int),
    .key1_int(key1_int),
    .key2_int(key2_int),
    .ac_present_int(ac_present_int),
    .cio_ec_rst_l_i(cio_ec_rst_l_i),
    .bat_disable_hw(bat_disable_hw),
    .gsc_rst_o(gsc_rst_o),
    .ec_rst_l_hw(ec_rst_l_hw)
  );

  //Instantiate the interrupt module
  rbox_intr i_intr (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rbox_intr_o(rbox_intr_o)
  );


endmodule
