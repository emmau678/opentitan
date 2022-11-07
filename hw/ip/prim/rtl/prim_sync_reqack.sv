// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// REQ/ACK synchronizer
//
// This module synchronizes a REQ/ACK handshake across a clock domain crossing.
// Both domains will see a handshake with the duration of one clock cycle.
//
// Notes:
// - Once asserted, the source (SRC) domain is not allowed to de-assert REQ without ACK.
// - The destination (DST) domain is not allowed to send an ACK without a REQ.
// - When resetting one domain, also the other domain needs to be reset with both resets being
//   active at the same time.
// - This module works both when syncing from a faster to a slower clock domain and vice versa.
// - Internally, this module uses a non-return-to-zero, two-phase handshake protocol. Assuming the
//   DST domain responds with an ACK immediately, the latency from asserting the REQ in the
//   SRC domain is:
//   - 1 source + 2 destination clock cycles until the handshake is performed in the DST domain,
//   - 1 source + 2 destination + 1 destination + 2 source clock cycles until the handshake is
//     performed in the SRC domain.
//
// For further information, see Section 8.2.4 in H. Kaeslin, "Top-Down Digital VLSI Design: From
// Architecture to Gate-Level Circuits and FPGAs", 2015.

`include "prim_assert.sv"

module prim_sync_reqack #(
  parameter bit EnRstChks = 1'b0 // Enable reset-related assertion checks, disabled by default.
) (
  input  clk_src_i,       // REQ side, SRC domain
  input  rst_src_ni,      // REQ side, SRC domain
  input  clk_dst_i,       // ACK side, DST domain
  input  rst_dst_ni,      // ACK side, DST domain

  input  logic req_chk_i, // Used for gating assertions. Drive to 1 during normal operation.

  input  logic src_req_i, // REQ side, SRC domain
  output logic src_ack_o, // REQ side, SRC domain
  output logic dst_req_o, // ACK side, DST domain
  input  logic dst_ack_i  // ACK side, DST domain
);

  // req_chk_i is used for gating assertions only.
  logic unused_req_chk;
  assign unused_req_chk = req_chk_i;

  // Types
  typedef enum logic {
    EVEN, ODD
  } sync_reqack_fsm_e;

  // Signals
  sync_reqack_fsm_e src_fsm_ns, src_fsm_cs;
  sync_reqack_fsm_e dst_fsm_ns, dst_fsm_cs;
  logic src_req_d, src_req_q, src_ack;
  logic dst_ack_d, dst_ack_q, dst_req;
  logic src_handshake, dst_handshake;

  assign src_handshake = src_req_i & src_ack_o;
  assign dst_handshake = dst_req_o & dst_ack_i;

  // Move REQ over to DST domain.
  prim_flop_2sync #(
    .Width(1)
  ) req_sync (
    .clk_i  (clk_dst_i),
    .rst_ni (rst_dst_ni),
    .d_i    (src_req_q),
    .q_o    (dst_req)
  );

  // Move ACK over to SRC domain.
  prim_flop_2sync #(
    .Width(1)
  ) ack_sync (
    .clk_i  (clk_src_i),
    .rst_ni (rst_src_ni),
    .d_i    (dst_ack_q),
    .q_o    (src_ack)
  );

  // REQ-side FSM (SRC domain)
  always_comb begin : src_fsm
    src_fsm_ns = src_fsm_cs;

    // By default, we keep the internal REQ value and don't ACK.
    src_req_d = src_req_q;
    src_ack_o = 1'b0;

    unique case (src_fsm_cs)

      EVEN: begin
        // Simply forward REQ and ACK.
        src_req_d = src_req_i;
        src_ack_o = src_ack;

        // The handshake is done for exactly 1 clock cycle.
        if (src_handshake) begin
          src_fsm_ns = ODD;
        end
      end

      ODD: begin
        // Internal REQ and ACK have inverted meaning now. If src_req_i is high again, this signals
        // a new transaction.
        src_req_d = ~src_req_i;
        src_ack_o = ~src_ack;

        // The handshake is done for exactly 1 clock cycle.
        if (src_handshake) begin
          src_fsm_ns = EVEN;
        end
      end

      //VCS coverage off
      // pragma coverage off

      default: ;

      //VCS coverage on
      // pragma coverage on

    endcase
  end

  // ACK-side FSM (DST domain)
  always_comb begin : dst_fsm
    dst_fsm_ns = dst_fsm_cs;

    // By default, we don't REQ and keep the internal ACK.
    dst_req_o = 1'b0;
    dst_ack_d = dst_ack_q;

    unique case (dst_fsm_cs)

      EVEN: begin
        // Simply forward REQ and ACK.
        dst_req_o = dst_req;
        dst_ack_d = dst_ack_i;

        // The handshake is done for exactly 1 clock cycle.
        if (dst_handshake) begin
          dst_fsm_ns = ODD;
        end
      end

      ODD: begin
        // Internal REQ and ACK have inverted meaning now. If dst_req goes low, this signals a new
        // transaction.
        dst_req_o = ~dst_req;
        dst_ack_d = ~dst_ack_i;

        // The handshake is done for exactly 1 clock cycle.
        if (dst_handshake) begin
          dst_fsm_ns = EVEN;
        end
      end

      //VCS coverage off
      // pragma coverage off

      default: ;

      //VCS coverage on
      // pragma coverage on

    endcase
  end

  // Registers
  always_ff @(posedge clk_src_i or negedge rst_src_ni) begin
    if (!rst_src_ni) begin
      src_fsm_cs <= EVEN;
      src_req_q  <= 1'b0;
    end else begin
      src_fsm_cs <= src_fsm_ns;
      src_req_q  <= src_req_d;
    end
  end
  always_ff @(posedge clk_dst_i or negedge rst_dst_ni) begin
    if (!rst_dst_ni) begin
      dst_fsm_cs <= EVEN;
      dst_ack_q  <= 1'b0;
    end else begin
      dst_fsm_cs <= dst_fsm_ns;
      dst_ack_q  <= dst_ack_d;
    end
  end

  `ifdef INC_ASSERT
    //VCS coverage off
    // pragma coverage off
    logic chk_flag;
    always_ff @(posedge clk_src_i or negedge rst_src_ni or negedge rst_dst_ni) begin
      if (!rst_src_ni || !rst_dst_ni) begin
        chk_flag <= '0;
      end else if (src_req_i && !chk_flag) begin
        chk_flag <= 1'b1;
      end
    end
    //VCS coverage on
    // pragma coverage on

    // SRC domain can only de-assert REQ after receiving ACK.
    `ASSERT(SyncReqAckHoldReq, $fell(src_req_i) && req_chk_i && chk_flag |->
        $fell(src_ack_o), clk_src_i, !rst_src_ni || !rst_dst_ni || !req_chk_i || !chk_flag)
  `endif

  // DST domain cannot assert ACK without REQ.
  `ASSERT(SyncReqAckAckNeedsReq, dst_ack_i |->
      dst_req_o, clk_dst_i, !rst_src_ni || !rst_dst_ni)

  if (EnRstChks) begin : gen_assert_en_rst_chks
  `ifdef INC_ASSERT

    //VCS coverage off
    // pragma coverage off
    // This assertion is written very oddly because it is difficult to reliably catch
    // when rst drops.
    // The problem is that reset assertion in the design is often associated with clocks
    // stopping, this means things like rise / fell don't work correctly since there are
    // no clocks.
    // As a result of this, we end up detecting way past the interest point (whenever
    // clocks are restored) and falsely assert an error.
    // The code below instead tries to use asynchronous flags to determine when and if
    // the two domains are properly reset.
    logic src_reset_flag;
    always_ff @(posedge clk_src_i or negedge rst_src_ni) begin
      if (!rst_src_ni) begin
        src_reset_flag <= '0;
      end else if(src_req_i) begin
        src_reset_flag <= 1'b1;
      end
    end

    logic dst_reset_flag;
    always_ff @(posedge clk_dst_i or negedge rst_dst_ni) begin
      if (!rst_dst_ni) begin
        dst_reset_flag <= '0;
      end else if (dst_req_o) begin
        dst_reset_flag <= 1'b1;
      end
    end
    //VCS coverage on
    // pragma coverage on

    // Always reset both domains. Both resets need to be active at the same time.
    `ASSERT(SyncReqAckRstSrc, $fell(rst_src_ni) |->
        ((src_reset_flag | dst_reset_flag)  == '0),
        clk_src_i, 0)
    `ASSERT(SyncReqAckRstDst, $fell(rst_dst_ni) |->
        ((src_reset_flag | dst_reset_flag) == '0),
        clk_dst_i, 0)

  `endif


  end

endmodule
