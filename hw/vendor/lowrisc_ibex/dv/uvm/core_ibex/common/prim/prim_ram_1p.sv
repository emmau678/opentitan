// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Abstract primitives wrapper.
//
// This file is a stop-gap until the DV file list is generated by FuseSoC.
// Its contents are taken from the file which would be generated by FuseSoC.
// https://github.com/lowRISC/ibex/issues/893

`ifndef PRIM_DEFAULT_IMPL
  `define PRIM_DEFAULT_IMPL prim_pkg::ImplGeneric
`endif

module prim_ram_1p #(
  parameter  int Width           = 32, // bit
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1, // Number of data bits per bit of write mask
  localparam int Aw              = $clog2(Depth)  // derived parameter
) (
  input  logic             clk_i,

  input  logic             req_i,
  input  logic             write_i,
  input  logic [Aw-1:0]    addr_i,
  input  logic [Width-1:0] wdata_i,
  input  logic [Width-1:0] wmask_i,
  output logic [Width-1:0] rdata_o // Read data. Data is returned one cycle after req_i is high.
);
  parameter prim_pkg::impl_e Impl = `PRIM_DEFAULT_IMPL;

  if (Impl == prim_pkg::ImplGeneric) begin : gen_generic
    prim_generic_ram_1p u_impl_generic (
      .*
    );
  end else begin : gen_failure
    // TODO: Find code that works across tools and causes a compile failure
  end

endmodule
