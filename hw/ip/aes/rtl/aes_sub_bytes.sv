// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES SubBytes

module aes_sub_bytes (
  input  aes_pkg::mode_e       mode_i,
  input  logic [3:0][3:0][7:0] data_i,
  output logic [3:0][3:0][7:0] data_o
);

  // Individually substitute bytes
  for (genvar j = 0; j < 4; j++) begin : gen_sbox_j
    for (genvar i = 0; i < 4; i++) begin : gen_sbox_i
      aes_sbox_lut aes_sbox_ij (
        .mode_i ( mode_i       ),
        .data_i ( data_i[i][j] ),
        .data_o ( data_o[i][j] )
      );
    end
  end

endmodule
