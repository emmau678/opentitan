// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This module implements the LFSR timer for triggering periodic consistency and integrity checks in
// OTP. In particular, this module contains two 40bit counters (one for the consistency and one
// for the integrity checks) and a 40bit LFSR to draw pseudo random wait counts.
//
// The integ_period_msk_i and cnsty_period_msk_i mask signals are used to mask off the LFSR outputs
// and hence determine the maximum wait count that can be drawn. If these values are set to
// zero, the corresponding timer is disabled.
//
// Once a particular check timer has expired, the module will send out a check request to all
// partitions and wait for an acknowledgment. If a particular partition encounters an integrity or
// consistency mismatch, this will be directly reported via the error and alert logic.
//
// In order to guard against wedged partition controllers or arbitration lock ups due to tampering
// attempts, this check timer module also supports a 32bit timeout that can optionally be
// programmed. If a particular check times out, chk_timeout_o will be asserted, which will raise
// an alert via the error logic.
//
// If needed, the LFSR can be reseeded with fresh entropy from the CSRNG via entropy_i.
//
// It is also possible to trigger one-off checks via integ_chk_trig_i and cnsty_chk_trig_i.
// This can be useful if SW chooses to leave the periodic checks disabled.
//

`include "prim_assert.sv"

module otp_ctrl_lfsr_timer import otp_ctrl_pkg::*; #(
  parameter logic [TimerWidth-1:0]       LfsrSeed     = TimerWidth'(1'b1),
  parameter logic [TimerWidth-1:0][31:0] LfsrPerm     = {
    32'd13, 32'd17, 32'd29, 32'd11, 32'd28, 32'd12, 32'd33, 32'd27,
    32'd05, 32'd39, 32'd31, 32'd21, 32'd15, 32'd01, 32'd24, 32'd37,
    32'd32, 32'd38, 32'd26, 32'd34, 32'd08, 32'd10, 32'd04, 32'd02,
    32'd19, 32'd00, 32'd20, 32'd06, 32'd25, 32'd22, 32'd03, 32'd35,
    32'd16, 32'd14, 32'd23, 32'd07, 32'd30, 32'd09, 32'd18, 32'd36
  },
  parameter int                          EntropyWidth = 8
) (
  input                            clk_i,
  input                            rst_ni,
  input                            entropy_en_i,       // entropy update pulse from CSRNG
  input        [EntropyWidth-1:0]  entropy_i,          // from CSRNG
  input                            timer_en_i,         // enable timer
  input                            integ_chk_trig_i,   // one-off trigger for integrity check
  input                            cnsty_chk_trig_i,   // one-off trigger for consistency check
  output logic                     chk_pending_o,      // indicates whether there are pending checks
  input        [31:0]              timeout_i,          // check timeout
  input        [31:0]              integ_period_msk_i, // maximum integrity check mask
  input        [31:0]              cnsty_period_msk_i, // maximum consistency check mask
  output logic [NumPart-1:0]       integ_chk_req_o,    // request to all partitions
  output logic [NumPart-1:0]       cnsty_chk_req_o,    // request to all partitions
  input        [NumPart-1:0]       integ_chk_ack_i,    // response from partitions
  input        [NumPart-1:0]       cnsty_chk_ack_i,    // response from partitions
  input  lc_tx_t                   escalate_en_i,      // escalation input, moves FSM into ErrorSt
  output logic                     chk_timeout_o,      // a check has timed out
  output logic                     fsm_err_o           // the FSM has reached an invalid state
);

  //////////
  // PRNG //
  //////////

  logic lfsr_en;
  logic [TimerWidth-1:0] lfsr_state;

  prim_lfsr #(
    .LfsrDw      ( TimerWidth   ),
    .EntropyDw   ( EntropyWidth ),
    .StateOutDw  ( TimerWidth   ),
    .DefaultSeed ( LfsrSeed     ),
    .StatePermEn ( 1'b1         ),
    .StatePerm   ( LfsrPerm     ),
    .ExtSeedSVA  ( 1'b0         ) // ext seed is unused
  ) i_prim_lfsr (
    .clk_i,
    .rst_ni,
    .seed_en_i  ( 1'b0       ),
    .seed_i     ( '0         ),
    .lfsr_en_i  ( lfsr_en | entropy_en_i ),
    .entropy_i  ( entropy_i & {EntropyWidth{entropy_en_i}} ),
    .state_o    ( lfsr_state )
  );

  //////////////
  // Counters //
  //////////////

  logic [TimerWidth-1:0] integ_cnt_d, integ_cnt_q;
  logic [TimerWidth-1:0] cnsty_cnt_d, cnsty_cnt_q;
  logic [TimerWidth-1:0] integ_mask, cnsty_mask;
  logic integ_load_period, integ_load_timeout, integ_cnt_zero;
  logic cnsty_load_period, cnsty_load_timeout, cnsty_cnt_zero;
  logic timeout_zero, integ_msk_zero, cnsty_msk_zero;

  assign integ_mask  = {integ_period_msk_i, {TimerWidth-32{1'b1}}};
  assign cnsty_mask  = {cnsty_period_msk_i, {TimerWidth-32{1'b1}}};

  assign integ_cnt_d = (integ_load_period)  ? lfsr_state & integ_mask :
                       (integ_load_timeout) ? timeout_i               :
                       (integ_cnt_zero)     ? '0                      :
                                              integ_cnt_q - 1'b1;


  assign cnsty_cnt_d = (cnsty_load_period)  ? lfsr_state & cnsty_mask :
                       (cnsty_load_timeout) ? timeout_i               :
                       (cnsty_cnt_zero)     ? '0                      :
                                              cnsty_cnt_q - 1'b1;

  assign timeout_zero   = (timeout_i == '0);
  assign integ_msk_zero = (integ_period_msk_i == '0);
  assign cnsty_msk_zero = (cnsty_period_msk_i == '0);
  assign integ_cnt_zero = (integ_cnt_q == '0);
  assign cnsty_cnt_zero = (cnsty_cnt_q == '0);

  /////////////////////
  // Request signals //
  /////////////////////

  logic set_all_integ_reqs, set_all_cnsty_reqs;
  logic [NumPart-1:0] integ_chk_req_d, integ_chk_req_q;
  logic [NumPart-1:0] cnsty_chk_req_d, cnsty_chk_req_q;
  assign integ_chk_req_o = integ_chk_req_q;
  assign cnsty_chk_req_o = cnsty_chk_req_q;
  assign integ_chk_req_d = (set_all_integ_reqs) ? {NumPart{1'b1}} :
                                                  integ_chk_req_q & ~integ_chk_ack_i;
  assign cnsty_chk_req_d = (set_all_cnsty_reqs) ? {NumPart{1'b1}} :
                                                  cnsty_chk_req_q & ~cnsty_chk_ack_i;


  ////////////////////////////
  // Ping and Timeout Logic //
  ////////////////////////////

  // Encoding generated with ./sparse-fsm-encode -d 5 -m 5 -n 9
  // Hamming distance histogram:
  //
  // 0: --
  // 1: --
  // 2: --
  // 3: --
  // 4: --
  // 5: |||||||||||||||||||| (60.00%)
  // 6: ||||||||||||| (40.00%)
  // 7: --
  // 8: --
  // 9: --
  //
  // Minimum Hamming distance: 5
  // Maximum Hamming distance: 6
  //
  typedef enum logic [8:0] {
    ResetSt     = 9'b110010010,
    IdleSt      = 9'b011011101,
    IntegWaitSt = 9'b100111111,
    CnstyWaitSt = 9'b001000110,
    ErrorSt     = 9'b101101000
  } state_e;

  state_e state_d, state_q;
  logic chk_timeout_d, chk_timeout_q;

  assign chk_timeout_o = chk_timeout_q;

  always_comb begin : p_fsm
    state_d = state_q;

    // LFSR and counter signals
    lfsr_en = 1'b0;
    integ_load_period  = 1'b0;
    cnsty_load_period  = 1'b0;
    integ_load_timeout = 1'b0;
    cnsty_load_timeout = 1'b0;

    // Requests going to partitions.
    set_all_integ_reqs = '0;
    set_all_cnsty_reqs = '0;

    // Status signals going to CSRs and error logic.
    chk_timeout_o = 1'b0;
    chk_pending_o = 1'b0;
    fsm_err_o = 1'b0;

    unique case (state_q)
      ///////////////////////////////////////////////////////////////////
      // Wait until enabled. We never return to this state
      // once enabled!
      ResetSt: begin
        if (timer_en_i) begin
          state_d = IdleSt;
          lfsr_en = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait here until one of the two timers expires (if enabled) or if
      // a check is triggered externally.
      IdleSt: begin
        if ((!integ_msk_zero && integ_cnt_zero) || integ_chk_trig_i) begin
          state_d = IntegWaitSt;
          integ_load_timeout = 1'b1;
          set_all_integ_reqs = 1'b1;
        end else if ((!cnsty_msk_zero && cnsty_cnt_zero) || cnsty_chk_trig_i) begin
          state_d = CnstyWaitSt;
          cnsty_load_timeout = 1'b1;
          set_all_cnsty_reqs = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for all the partitions to respond and go back to idle.
      // If the timeout is enabled, bail out into terminal error state
      // if the timeout counter expires (this will raise an alert).
      IntegWaitSt: begin
        chk_pending_o = 1'b1;
        if (!timeout_zero && integ_cnt_zero) begin
          state_d = ErrorSt;
          chk_timeout_d = 1'b1;
        end else if (integ_chk_req_q == '0) begin
          state_d = IdleSt;
          // This draws the next wait period.
          integ_load_period = 1'b1;
          lfsr_en = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for all the partitions to respond and go back to idle.
      // If the timeout is enabled, bail out into terminal error state
      // if the timeout counter expires (this will raise an alert).
      CnstyWaitSt: begin
        chk_pending_o = 1'b1;
        if (!timeout_zero && cnsty_cnt_zero) begin
          state_d = ErrorSt;
          chk_timeout_d = 1'b1;
        end else if (cnsty_chk_req_q == '0) begin
          state_d = IdleSt;
          // This draws the next wait period.
          cnsty_load_period = 1'b1;
          lfsr_en = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Terminal error state. This raises an alert.
      ErrorSt: begin
        if (!chk_timeout_q) begin
          fsm_err_o = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // This should never happen, hence we directly jump into the
      // error state, where an alert will be triggered.
      default: begin
        state_d = ErrorSt;
      end
      ///////////////////////////////////////////////////////////////////
    endcase // state_q

    if (state_q != ErrorSt) begin
      // Unconditionally jump into the terminal error state in case of escalation.
      if (escalate_en_i != Off) begin
        state_d = ErrorSt;
      end
    end
  end

  ///////////////
  // Registers //
  ///////////////

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      state_q     <= ResetSt;
      integ_cnt_q <= '0;
      cnsty_cnt_q <= '0;
      integ_chk_req_q <= '0;
      cnsty_chk_req_q <= '0;
      chk_timeout_q   <= 1'b0;
    end else begin
      state_q     <= state_d;
      integ_cnt_q <= integ_cnt_d;
      cnsty_cnt_q <= cnsty_cnt_d;
      integ_chk_req_q <= integ_chk_req_d;
      cnsty_chk_req_q <= cnsty_chk_req_d;
      chk_timeout_q   <= chk_timeout_d;
    end
  end

  ////////////////
  // Assertions //
  ////////////////

  `ASSERT_KNOWN(ChkPendingKnown_A,  chk_pending_o)
  `ASSERT_KNOWN(IntegChkReqKnown_A, integ_chk_req_o)
  `ASSERT_KNOWN(CnstyChkReqKnown_A, cnsty_chk_req_o)
  `ASSERT_KNOWN(ChkTimeoutKnown_A,  chk_timeout_o)

endmodule : otp_ctrl_lfsr_timer
