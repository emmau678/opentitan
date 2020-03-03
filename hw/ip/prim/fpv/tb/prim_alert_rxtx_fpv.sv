// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Testbench module for alert sender/receiver pair. Intended to use with
// a formal tool.

module prim_alert_rxtx_fpv
  import prim_alert_pkg::*;
  import prim_esc_pkg::*;
(
  input        clk_i,
  input        rst_ni,
  // for sigint error injection only
  input        ping_err_pi,
  input        ping_err_ni,
  input        ack_err_pi,
  input        ack_err_ni,
  input        alert_err_pi,
  input        alert_err_ni,
  // normal I/Os
  input        alert_i,
  input        ping_en_i,
  output logic ping_ok_o,
  output logic integ_fail_o,
  output logic alert_o
);

  // synchronous case
  localparam bit AsyncOn = 1'b0;

  alert_rx_t alert_rx_out, alert_rx_in;
  alert_tx_t alert_tx_out, alert_tx_in;

  assign alert_rx_in.ping_p = alert_rx_out.ping_p ^ ping_err_pi;
  assign alert_rx_in.ping_n = alert_rx_out.ping_n ^ ping_err_ni;
  assign alert_rx_in.ack_p  = alert_rx_out.ack_p  ^ ack_err_pi;
  assign alert_rx_in.ack_n  = alert_rx_out.ack_n  ^ ack_err_ni;

  assign alert_tx_in.alert_p = alert_tx_out.alert_p ^ alert_err_pi;
  assign alert_tx_in.alert_n = alert_tx_out.alert_n ^ alert_err_ni;

  prim_alert_sender #(
    .AsyncOn ( AsyncOn )
  ) i_prim_alert_sender (
    .clk_i    ,
    .rst_ni   ,
    .alert_i  ,
    .alert_rx_i ( alert_rx_in  ),
    .alert_tx_o ( alert_tx_out )
  );

  prim_alert_receiver #(
    .AsyncOn ( AsyncOn )
  ) i_prim_alert_receiver (
    .clk_i        ,
    .rst_ni       ,
    .ping_en_i    ,
    .ping_ok_o    ,
    .integ_fail_o ,
    .alert_o      ,
    .alert_rx_o ( alert_rx_out ),
    .alert_tx_i ( alert_tx_in  )
  );

endmodule : prim_alert_rxtx_fpv
