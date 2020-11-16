// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tl_main package generated by `tlgen.py` tool

package tl_main_pkg;

  localparam logic [31:0] ADDR_SPACE_ROM           = 32'h 00008000;
  localparam logic [31:0] ADDR_SPACE_DEBUG_MEM     = 32'h 1a110000;
  localparam logic [31:0] ADDR_SPACE_RAM_MAIN      = 32'h 10000000;
  localparam logic [31:0] ADDR_SPACE_EFLASH        = 32'h 20000000;
  localparam logic [6:0][31:0] ADDR_SPACE_PERI          = {
    32'h 401b0000,
    32'h 40170000,
    32'h 40150000,
    32'h 400a0000,
    32'h 40080000,
    32'h 40000000,
    32'h 18000000
  };
  localparam logic [31:0] ADDR_SPACE_FLASH_CTRL    = 32'h 40030000;
  localparam logic [31:0] ADDR_SPACE_HMAC          = 32'h 40120000;
  localparam logic [31:0] ADDR_SPACE_KMAC          = 32'h 41120000;
  localparam logic [31:0] ADDR_SPACE_AES           = 32'h 40110000;
  localparam logic [31:0] ADDR_SPACE_ENTROPY_SRC   = 32'h 41160000;
  localparam logic [31:0] ADDR_SPACE_CSRNG         = 32'h 41150000;
  localparam logic [31:0] ADDR_SPACE_EDN0          = 32'h 41170000;
  localparam logic [31:0] ADDR_SPACE_EDN1          = 32'h 41180000;
  localparam logic [31:0] ADDR_SPACE_RV_PLIC       = 32'h 40090000;
  localparam logic [31:0] ADDR_SPACE_PINMUX        = 32'h 40070000;
  localparam logic [31:0] ADDR_SPACE_PADCTRL       = 32'h 40160000;
  localparam logic [31:0] ADDR_SPACE_ALERT_HANDLER = 32'h 411b0000;
  localparam logic [31:0] ADDR_SPACE_NMI_GEN       = 32'h 411c0000;
  localparam logic [31:0] ADDR_SPACE_OTBN          = 32'h 50000000;
  localparam logic [31:0] ADDR_SPACE_KEYMGR        = 32'h 401a0000;

  localparam logic [31:0] ADDR_MASK_ROM           = 32'h 00003fff;
  localparam logic [31:0] ADDR_MASK_DEBUG_MEM     = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_RAM_MAIN      = 32'h 0000ffff;
  localparam logic [31:0] ADDR_MASK_EFLASH        = 32'h 0007ffff;
  localparam logic [6:0][31:0] ADDR_MASK_PERI          = {
    32'h 00003fff,
    32'h 00010fff,
    32'h 00000fff,
    32'h 00020fff,
    32'h 00000fff,
    32'h 00020fff,
    32'h 00000fff
  };
  localparam logic [31:0] ADDR_MASK_FLASH_CTRL    = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_HMAC          = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_KMAC          = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_AES           = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_ENTROPY_SRC   = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_CSRNG         = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_EDN0          = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_EDN1          = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_RV_PLIC       = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_PINMUX        = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_PADCTRL       = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_ALERT_HANDLER = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_NMI_GEN       = 32'h 00000fff;
  localparam logic [31:0] ADDR_MASK_OTBN          = 32'h 0000ffff;
  localparam logic [31:0] ADDR_MASK_KEYMGR        = 32'h 00000fff;

  localparam int N_HOST   = 3;
  localparam int N_DEVICE = 20;

  typedef enum int {
    TlRom = 0,
    TlDebugMem = 1,
    TlRamMain = 2,
    TlEflash = 3,
    TlPeri = 4,
    TlFlashCtrl = 5,
    TlHmac = 6,
    TlKmac = 7,
    TlAes = 8,
    TlEntropySrc = 9,
    TlCsrng = 10,
    TlEdn0 = 11,
    TlEdn1 = 12,
    TlRvPlic = 13,
    TlPinmux = 14,
    TlPadctrl = 15,
    TlAlertHandler = 16,
    TlNmiGen = 17,
    TlOtbn = 18,
    TlKeymgr = 19
  } tl_device_e;

  typedef enum int {
    TlCorei = 0,
    TlCored = 1,
    TlDmSba = 2
  } tl_host_e;

endpackage
