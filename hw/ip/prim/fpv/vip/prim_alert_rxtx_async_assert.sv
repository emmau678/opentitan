// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Assertions for alert sender/receiver pair for the asynchronous case.
// Intended to use with a formal tool.

module prim_alert_rxtx_async_assert (
  input        clk_i,
  input        rst_ni,
  // for sigint error and skew injection only
  input        ping_err_pi,
  input        ping_err_ni,
  input [1:0]  ping_skew_i,
  input        ack_err_pi,
  input        ack_err_ni,
  input [1:0]  ack_skew_i,
  input        alert_err_pi,
  input        alert_err_ni,
  input [1:0]  alert_skew_i,
  // normal I/Os
  input        alert_i,
  input        ping_en_i,
  input        ping_ok_o,
  input        integ_fail_o,
  input        alert_o
);

  logic error_present;
  assign error_present = ping_err_pi  | ping_err_ni |
                         ack_err_pi   | ack_err_ni  |
                         alert_err_pi | alert_err_ni;

  // used to check that an error has never occured so far
  // this is used to check the handshake below. the handshake can lock up
  // the protocol FSMs causing the handshake to never complete.
  // note that this will block any ping messages and hence it can be
  // eventually detected by the alert handler.
  logic error_setreg_d, error_setreg_q;
  assign error_setreg_d = error_present | error_setreg_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_reg
    if (!rst_ni) begin
      error_setreg_q <= 1'b0;
    end else begin
      error_setreg_q <= error_setreg_d;
    end
  end

  // Note: we can only detect sigint errors where one wire is flipped.
  `ASSUME_FPV(PingErrorsAreOH_M,  $onehot0({ping_err_pi, ping_err_ni}),   clk_i, !rst_ni)
  `ASSUME_FPV(AckErrorsAreOH_M,   $onehot0({ack_err_pi, ack_err_ni}),     clk_i, !rst_ni)
  `ASSUME_FPV(AlertErrorsAreOH_M, $onehot0({alert_err_pi, alert_err_ni}), clk_i, !rst_ni)

  // ping will stay high until ping ok received, then it must be deasserted
  // TODO: this excludes the case where no ping ok will be returned due to an error
  `ASSUME_FPV(PingDeassert_M, ping_en_i && ping_ok_o |=> !ping_en_i, clk_i, !rst_ni)
  `ASSUME_FPV(PingEnStaysAsserted0_M, ping_en_i |=>
      (ping_en_i && !ping_ok_o) or
      (ping_en_i && ping_ok_o ##1 $fell(ping_en_i)),
      clk_i, !rst_ni || error_present)

  // Note: the sequence lengths of the handshake and the following properties needs to
  // be parameterized accordingly if different clock ratios are to be used here.
  // TODO: tighten bounds if possible
  sequence FullHandshake_S;
    $rose(prim_alert_rxtx_async_tb.alert_pd)   ##[3:5]
    $rose(prim_alert_rxtx_async_tb.ack_pd)     &&
    $stable(prim_alert_rxtx_async_tb.alert_pd) ##[3:5]
    $fell(prim_alert_rxtx_async_tb.alert_pd)   &&
    $stable(prim_alert_rxtx_async_tb.ack_pd)   ##[3:5]
    $fell(prim_alert_rxtx_async_tb.ack_pd)     &&
    $stable(prim_alert_rxtx_async_tb.alert_pd);
  endsequence

  // note: injected errors may lockup the FSMs, and hence the full HS can
  // only take place if both FSMs are in a sane state
  `ASSERT(PingHs_A, ##1 $changed(prim_alert_rxtx_async_tb.ping_pd) &&
      (prim_alert_rxtx_async_tb.i_prim_alert_sender.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_sender.Idle) &&
      (prim_alert_rxtx_async_tb.i_prim_alert_receiver.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_receiver.Idle) |-> ##[0:5] FullHandshake_S,
      clk_i, !rst_ni || error_setreg_q)
  `ASSERT(AlertHs_A, alert_i &&
      (prim_alert_rxtx_async_tb.i_prim_alert_sender.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_sender.Idle) &&
      (prim_alert_rxtx_async_tb.i_prim_alert_receiver.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_receiver.Idle) |-> ##[0:5] FullHandshake_S,
      clk_i, !rst_ni || error_setreg_q)

  // transmission of pings
  // this bound is relatively large as in the worst case, we need to resolve
  // staggered differential signal patterns on all three differential channels
  `ASSERT(AlertPing_A, $rose(ping_en_i) |-> ##[1:23] ping_ok_o,
      clk_i, !rst_ni || error_setreg_q)
  // transmission of first alert assertion (no ping collision)
  `ASSERT(AlertCheck0_A, !ping_en_i [*10] ##1 $rose(alert_i) &&
      (prim_alert_rxtx_async_tb.i_prim_alert_sender.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_sender.Idle) |->
      ##[3:5] alert_o, clk_i, !rst_ni || ping_en_i || error_setreg_q)
  // eventual transmission of alerts in the general case which can include ping collisions
  `ASSERT(AlertCheck1_A, alert_i |-> ##[1:25] alert_o,
      clk_i, !rst_ni || error_setreg_q)

  // basic liveness of FSMs in case no errors are present
  `ASSERT(FsmLivenessSender_A, !error_present [*2] ##1 !error_present &&
      (prim_alert_rxtx_async_tb.i_prim_alert_sender.state_q !=
      prim_alert_rxtx_async_tb.i_prim_alert_sender.Idle) |->
      strong(##[1:$] (prim_alert_rxtx_async_tb.i_prim_alert_sender.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_sender.Idle)), clk_i, !rst_ni || error_present)
  `ASSERT(FsmLivenessReceiver_A, !error_present [*2] ##1 !error_present &&
      (prim_alert_rxtx_async_tb.i_prim_alert_receiver.state_q !=
      prim_alert_rxtx_async_tb.i_prim_alert_receiver.Idle) |->
      strong(##[1:$] (prim_alert_rxtx_async_tb.i_prim_alert_receiver.state_q ==
      prim_alert_rxtx_async_tb.i_prim_alert_receiver.Idle)),clk_i, !rst_ni || error_present)

  // TODO: add FSM liveness of 3x diff decoder instances

endmodule : prim_alert_rxtx_async_assert
