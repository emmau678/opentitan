// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//############################################################################
// *Name: vcmain_pok
// *Module Description:  VCMAIN Power OK
//############################################################################
`ifdef SYNTHESIS
`ifndef PRIM_DEFAULT_IMPL
`define PRIM_DEFAULT_IMPL prim_pkg::ImplGeneric
`endif
`endif

module vcmain_pok (
  output logic vcmain_pok_o
);

// Local signal for testing hook
logic gen_supp_a;
assign gen_supp_a = 1'b1;

`ifndef SYNTHESIS
// Behavioral Model
////////////////////////////////////////
import ast_bhv_pkg::* ;

// The initial is needed to clear the X of the delays at the start
// Also to force a power-up effect at the bgining.
logic init_start;

initial begin
  init_start = 1'b1; #1;
  init_start = 1'b0;
end

always @( * ) begin
  if ( init_start ) begin
    vcmain_pok_o <= 1'b0;
  end else if ( !init_start && gen_supp_a ) begin
    vcmain_pok_o <= #(VCMAIN_POK_RDLY) gen_supp_a;
  end else if ( !init_start && !gen_supp_a ) begin
    vcmain_pok_o <= #(VCMAIN_POK_FDLY) gen_supp_a;
  end
end
`else
// SYNTHESIS/VERILATOR/LINTER/FPGA
///////////////////////////////////////
localparam prim_pkg::impl_e Impl = `PRIM_DEFAULT_IMPL;

if (Impl == prim_pkg::ImplXilinx) begin : gen_xilinx
  // FPGA Specific (place holder)
  ///////////////////////////////////////
  assign vcmain_pok_o = gen_supp_a;
end else begin : gen_generic
  assign vcmain_pok_o = gen_supp_a;
end
`endif

endmodule : vcmain_pok
