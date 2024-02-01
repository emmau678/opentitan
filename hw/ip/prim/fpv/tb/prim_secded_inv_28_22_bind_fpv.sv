// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED FPV bind file generated by util/design/secded_gen.py

module prim_secded_inv_28_22_bind_fpv;

  bind prim_secded_inv_28_22_tb
    prim_secded_inv_28_22_assert_fpv prim_secded_inv_28_22_assert_fpv (
    .clk_i,
    .rst_ni,
    .data_i,
    .data_o,
    .encoded_o,
    .syndrome_o,
    .err_o,
    .error_inject_i
  );

endmodule : prim_secded_inv_28_22_bind_fpv
