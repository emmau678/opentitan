// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_64_57_dec (
  input        [63:0] data_i,
  output logic [56:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);

  logic single_error;

  // Syndrome calculation
  assign syndrome_o[0] = ^(data_i & 64'h0303FFF800007FFF);
  assign syndrome_o[1] = ^(data_i & 64'h057C1FF801FF801F);
  assign syndrome_o[2] = ^(data_i & 64'h09BDE1F87E0781E1);
  assign syndrome_o[3] = ^(data_i & 64'h11DEEE3B8E388E22);
  assign syndrome_o[4] = ^(data_i & 64'h21EF76CDB2C93244);
  assign syndrome_o[5] = ^(data_i & 64'h41F7BB56D5525488);
  assign syndrome_o[6] = ^(data_i & 64'h81FBDDA769A46910);

  // Corrected output calculation
  assign data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
  assign data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
  assign data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
  assign data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
  assign data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
  assign data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
  assign data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
  assign data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
  assign data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
  assign data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
  assign data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
  assign data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
  assign data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
  assign data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
  assign data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
  assign data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
  assign data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
  assign data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
  assign data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
  assign data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
  assign data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
  assign data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
  assign data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
  assign data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
  assign data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
  assign data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
  assign data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
  assign data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
  assign data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
  assign data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
  assign data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
  assign data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
  assign data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
  assign data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
  assign data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
  assign data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
  assign data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
  assign data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
  assign data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
  assign data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
  assign data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
  assign data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
  assign data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
  assign data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
  assign data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
  assign data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
  assign data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
  assign data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
  assign data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
  assign data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
  assign data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
  assign data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
  assign data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
  assign data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
  assign data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
  assign data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
  assign data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];

  // err_o calc. bit0: single error, bit1: double error
  assign single_error = ^syndrome_o;
  assign err_o[0] = single_error;
  assign err_o[1] = ~single_error & (|syndrome_o);

endmodule : prim_secded_64_57_dec
