// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tb__xbar_connect generated by `tlgen.py` tool

xbar_main dut();

`DRIVE_CLK(clk_main_i)
`DRIVE_CLK(clk_fixed_i)

initial force dut.clk_main_i = clk_main_i;
initial force dut.clk_fixed_i = clk_fixed_i;

// TODO, all resets tie together
initial force dut.rst_main_ni = rst_n;
initial force dut.rst_fixed_ni = rst_n;

// Host TileLink interface connections
`CONNECT_TL_HOST_IF(corei, dut, clk_main_i, rst_n)
`CONNECT_TL_HOST_IF(cored, dut, clk_main_i, rst_n)
`CONNECT_TL_HOST_IF(dm_sba, dut, clk_main_i, rst_n)

// Device TileLink interface connections
`CONNECT_TL_DEVICE_IF(rom, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(debug_mem, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(ram_main, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(eflash, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(peri, dut, clk_fixed_i, rst_n)
`CONNECT_TL_DEVICE_IF(flash_ctrl, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(hmac, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(kmac, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(aes, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(entropy_src, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(csrng, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(edn0, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(edn1, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(rv_plic, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(pinmux, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(padctrl, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(alert_handler, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(nmi_gen, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(otbn, dut, clk_main_i, rst_n)
`CONNECT_TL_DEVICE_IF(keymgr, dut, clk_main_i, rst_n)
