// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED FPV testbench generated by util/design/secded_gen.py

module prim_secded_inv_hamming_72_64_tb (
  input               clk_i,
  input               rst_ni,
  input        [63:0] data_i,
  output logic [63:0] data_o,
  output logic [7:0] syndrome_o,
  output logic [1:0]  err_o,
  input        [71:0] error_inject_i
);

  logic [71:0] data_enc;

  prim_secded_inv_hamming_72_64_enc prim_secded_inv_hamming_72_64_enc (
    .data_i,
    .data_o(data_enc)
  );

  prim_secded_inv_hamming_72_64_dec prim_secded_inv_hamming_72_64_dec (
    .data_i(data_enc ^ error_inject_i),
    .data_o,
    .syndrome_o,
    .err_o
  );

endmodule : prim_secded_inv_hamming_72_64_tb
