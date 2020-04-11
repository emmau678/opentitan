// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Simple parameterizable gate generator. Used to fill up the netlist
// with gates that cannot be optimized away.
//
// The module leverages 4bit SBoxes from the PRINCE cipher, and interleaves
// them with registers, resulting in a split of around 50/50 between logic and
// sequential cells.
//
// This generator has been tested with 32bit wide data, and produces
// the following results:
//
// if valid_i constantly set to 1'b1:
// -------------+-----------+----------
// requested GE | actual GE | GE error
// -------------+-----------+----------
// 500          |   679     |   179
// 1000         |   1018    |   18
// 1500         |   1696    |   196
// 2500         |   2714    |   214
// 5000         |   5210    |   210
// 7500         |   7456    |   -44
// 10000        |   10015   |   15
// 15000        |   15191   |   191
// 25000        |   25228   |   228
// 50000        |   50485   |   485
//
// otherwise, with clock gating enabled:
// -------------+-----------+----------
// requested GE | actual GE | GE error
// -------------+-----------+----------
// 500          |   696     |   196
// 1000         |   1043    |   43
// 1500         |   1737    |   237
// 2500         |   2779    |   279
// 5000         |   5340    |   340
// 7500         |   7634    |   134
// 10000        |   10284   |   284
// 15000        |   15585   |   585
// 25000        |   25855   |   855
// 50000        |   51732   |   1732
//
// Note that the generator is not very accurate for smaller gate counts due
// to the generate loop granularity. Hence, do not use for fever than 500 GE.


module prim_gate_gen #(
  parameter int DataWidth = 32,
  parameter int NumGates = 1000
) (
  input                        clk_i,
  input                        rst_ni,

  input                        valid_i,
  input        [DataWidth-1:0] data_i,
  output logic [DataWidth-1:0] data_o,
  output                       valid_o
);

  /////////////////////////////////////
  // Local parameters and assertions //
  /////////////////////////////////////

  // technology specific tuning, do not modify.
  // an inner round is comprised of a 2bit rotation, followed by a 4bit SBox Layer.
  localparam int NumInnerRounds = 2;
  localparam int GatesPerRound  = DataWidth * 10;
  // an outer round consists of NumInnerRounds, followed by a register.
  localparam int NumOuterRounds = (NumGates + GatesPerRound / 2) / GatesPerRound;

  // do not use for fewer than 500 GE
  `ASSERT(MinimumNumGates_A, NumGates >= 500)
  `ASSERT(DataMustBeMultipleOfFour_A, DataWidth % 4 == 0)

  /////////////////////
  // Generator Loops //
  /////////////////////

  logic [NumOuterRounds-1:0][DataWidth-1:0] regs_d, regs_q;
  logic [NumOuterRounds-1:0] valid_d, valid_q;

  for (genvar k = 0; k < NumOuterRounds; k++) begin : gen_outer_round

    logic [NumInnerRounds:0][DataWidth-1:0] inner_data;

    if (k==0) begin : gen_first
      assign inner_data[0] = data_i;
      assign valid_d[0]    = valid_i;
    end else begin : gen_others
      assign inner_data[0] = regs_q[k-1];
      assign valid_d[k]    = valid_q[k-1];
    end

    for (genvar l = 0; l < NumInnerRounds; l++) begin : gen_inner
      // 2bit rotation + sbox layer
      assign inner_data[l+1] = prim_cipher_pkg::sbox4_32bit({inner_data[l][1:0],
                                                             inner_data[l][DataWidth-1:2]},
                                                             prim_cipher_pkg::PRINCE_SBOX4);
    end

    assign regs_d[k] = inner_data[NumInnerRounds];
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      regs_q <= '0;
      valid_q <= '0;
    end else begin
      valid_q <= valid_d;
      for (int k = 0; k < NumOuterRounds; k++) begin
        if (valid_d[k]) begin
          regs_q[k] <= regs_d[k];
        end
      end
    end
  end

  assign data_o = regs_q[NumOuterRounds-1];
  assign valid_o = valid_q[NumOuterRounds-1];

endmodule : prim_gate_gen
