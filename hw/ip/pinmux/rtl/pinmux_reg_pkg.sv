// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package pinmux_reg_pkg;

  // Param list
  parameter int NPeriphIn = 16;
  parameter int NPeriphOut = 16;
  parameter int NMioPads = 8;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic [3:0]  q;
  } pinmux_reg2hw_periph_insel_mreg_t;

  typedef struct packed {
    logic [4:0]  q;
  } pinmux_reg2hw_mio_outsel_mreg_t;



  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    pinmux_reg2hw_periph_insel_mreg_t [15:0] periph_insel; // [103:40]
    pinmux_reg2hw_mio_outsel_mreg_t [7:0] mio_outsel; // [39:0]
  } pinmux_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////

  // Register Address
  parameter logic [4:0] PINMUX_REGEN_OFFSET = 5'h 0;
  parameter logic [4:0] PINMUX_PERIPH_INSEL0_OFFSET = 5'h 4;
  parameter logic [4:0] PINMUX_PERIPH_INSEL1_OFFSET = 5'h 8;
  parameter logic [4:0] PINMUX_MIO_OUTSEL0_OFFSET = 5'h c;
  parameter logic [4:0] PINMUX_MIO_OUTSEL1_OFFSET = 5'h 10;


  // Register Index
  typedef enum int {
    PINMUX_REGEN,
    PINMUX_PERIPH_INSEL0,
    PINMUX_PERIPH_INSEL1,
    PINMUX_MIO_OUTSEL0,
    PINMUX_MIO_OUTSEL1
  } pinmux_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] PINMUX_PERMIT [5] = '{
    4'b 0001, // index[0] PINMUX_REGEN
    4'b 1111, // index[1] PINMUX_PERIPH_INSEL0
    4'b 1111, // index[2] PINMUX_PERIPH_INSEL1
    4'b 1111, // index[3] PINMUX_MIO_OUTSEL0
    4'b 0011  // index[4] PINMUX_MIO_OUTSEL1
  };
endpackage

