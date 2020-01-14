// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tl_peri package generated by `tlgen.py` tool

package tl_peri_pkg;

  localparam logic [31:0] ADDR_SPACE_UART       = 32'h 40000000;
  localparam logic [31:0] ADDR_SPACE_GPIO       = 32'h 40010000;
  localparam logic [31:0] ADDR_SPACE_SPI_DEVICE = 32'h 40020000;
  localparam logic [31:0] ADDR_SPACE_RV_TIMER   = 32'h 40080000;
  localparam logic [31:0] ADDR_SPACE_USBDEV     = 32'h 40150000;

  localparam logic [31:0] ADDR_MASK_UART       = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_GPIO       = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_SPI_DEVICE = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_RV_TIMER   = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_USBDEV     = 32'h 00000fff;

  localparam int N_HOST   = 1;
  localparam int N_DEVICE = 5;

  typedef enum int {
    TlUart = 0,
    TlGpio = 1,
    TlSpiDevice = 2,
    TlRvTimer = 3,
    TlUsbdev = 4
  } tl_device_e;

  typedef enum int {
    TlMain = 0
  } tl_host_e;

endpackage
