// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED FPV testbench generated by util/design/secded_gen.py

module prim_secded_hamming_76_68_tb (
  input               clk_i,
  input               rst_ni,
  input        [67:0] data_i,
  output logic [67:0] data_o,
  output logic [75:0] encoded_o,
  output logic [7:0] syndrome_o,
  output logic [1:0]  err_o,
  input        [75:0] error_inject_i
);

  prim_secded_hamming_76_68_enc prim_secded_hamming_76_68_enc (
    .data_i,
    .data_o(encoded_o)
  );

  prim_secded_hamming_76_68_dec prim_secded_hamming_76_68_dec (
    .data_i(encoded_o ^ error_inject_i),
    .data_o,
    .syndrome_o,
    .err_o
  );

endmodule : prim_secded_hamming_76_68_tb
