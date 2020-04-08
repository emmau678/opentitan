// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Power Manager Wake Information
//

`include "prim_assert.sv"

module pwrmgr_wake_info import pwrmgr_pkg::*; (
  input clk_i,
  input rst_ni,
  input wr_i,
  input [TotalWakeWidth-1:0] data_i,
  input start_capture_i,
  input record_dis_i,
  input [WakeUpPeris-1:0] wakeups_i,
  input fall_through_i,
  input abort_i,
  output logic [TotalWakeWidth-1:0] info_o
);

  logic record_en;

  // generate the record enbale signal
  // HW enables the recording
  // Software can suppress the recording or disable it
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      record_en <= 1'b0;
    end else if (start_capture_i && !record_dis_i) begin
      // if not disabled by software
      // a recording enable puls by HW starts recording
      record_en <= 1'b1;
    end else if (record_dis_i && record_en) begin
      // if recording is already ongoing
      // a disable command by software shuts things down
      record_en <= 1'b0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      info_o <= '0;
    end else if (wr_i) begin
      info_o <= info_o & ~data_i; // W1C
    end else if (record_en) begin // If set once, hold until clear
      info_o[0 +: WakeUpPeris] <= info_o[0 +: WakeUpPeris] | wakeups_i;
      info_o[WakeUpPeris +: 2] <= info_o[WakeUpPeris +: 2] | {abort_i, fall_through_i};
    end
  end


endmodule
