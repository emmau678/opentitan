// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package rstmgr_reg_pkg;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
  typedef struct packed {
    logic [4:0]  q;
    logic        qe;
  } rstmgr_reg2hw_reset_info_reg_t;

  typedef struct packed {
    logic        q;
  } rstmgr_reg2hw_rst_spi_device_n_reg_t;

  typedef struct packed {
    logic        q;
  } rstmgr_reg2hw_rst_usb_n_reg_t;


  typedef struct packed {
    logic [4:0]  d;
  } rstmgr_hw2reg_reset_info_reg_t;


  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
  typedef struct packed {
    rstmgr_reg2hw_reset_info_reg_t reset_info; // [7:2]
    rstmgr_reg2hw_rst_spi_device_n_reg_t rst_spi_device_n; // [1:1]
    rstmgr_reg2hw_rst_usb_n_reg_t rst_usb_n; // [0:0]
  } rstmgr_reg2hw_t;

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
  typedef struct packed {
    rstmgr_hw2reg_reset_info_reg_t reset_info; // [4:-1]
  } rstmgr_hw2reg_t;

  // Register Address
  parameter logic [4:0] RSTMGR_RESET_INFO_OFFSET = 5'h 0;
  parameter logic [4:0] RSTMGR_SPI_DEVICE_REGEN_OFFSET = 5'h 4;
  parameter logic [4:0] RSTMGR_USB_REGEN_OFFSET = 5'h 8;
  parameter logic [4:0] RSTMGR_RST_SPI_DEVICE_N_OFFSET = 5'h c;
  parameter logic [4:0] RSTMGR_RST_USB_N_OFFSET = 5'h 10;


  // Register Index
  typedef enum int {
    RSTMGR_RESET_INFO,
    RSTMGR_SPI_DEVICE_REGEN,
    RSTMGR_USB_REGEN,
    RSTMGR_RST_SPI_DEVICE_N,
    RSTMGR_RST_USB_N
  } rstmgr_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] RSTMGR_PERMIT [5] = '{
    4'b 0001, // index[0] RSTMGR_RESET_INFO
    4'b 0001, // index[1] RSTMGR_SPI_DEVICE_REGEN
    4'b 0001, // index[2] RSTMGR_USB_REGEN
    4'b 0001, // index[3] RSTMGR_RST_SPI_DEVICE_N
    4'b 0001  // index[4] RSTMGR_RST_USB_N
  };
endpackage

