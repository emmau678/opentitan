// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tb__xbar_connect generated by `topgen.py` tool
wire clk_main;
clk_rst_if clk_rst_if_main(.clk(clk_main), .rst_n(rst_n));
wire clk_io;
clk_rst_if clk_rst_if_io(.clk(clk_io), .rst_n(rst_n));
wire clk_usb;
clk_rst_if clk_rst_if_usb(.clk(clk_usb), .rst_n(rst_n));
wire clk_aon;
clk_rst_if clk_rst_if_aon(.clk(clk_aon), .rst_n(rst_n));

tl_if corei_tl_if(clk_main, rst_n);
tl_if cored_tl_if(clk_main, rst_n);
tl_if dm_sba_tl_if(clk_main, rst_n);

tl_if rom_tl_if(clk_main, rst_n);
tl_if debug_mem_tl_if(clk_main, rst_n);
tl_if ram_main_tl_if(clk_main, rst_n);
tl_if eflash_tl_if(clk_main, rst_n);
tl_if flash_ctrl_tl_if(clk_main, rst_n);
tl_if hmac_tl_if(clk_main, rst_n);
tl_if aes_tl_if(clk_main, rst_n);
tl_if rv_plic_tl_if(clk_main, rst_n);
tl_if pinmux_tl_if(clk_main, rst_n);
tl_if padctrl_tl_if(clk_main, rst_n);
tl_if alert_handler_tl_if(clk_main, rst_n);
tl_if nmi_gen_tl_if(clk_main, rst_n);
tl_if uart_tl_if(clk_io, rst_n);
tl_if gpio_tl_if(clk_io, rst_n);
tl_if spi_device_tl_if(clk_io, rst_n);
tl_if rv_timer_tl_if(clk_io, rst_n);
tl_if usbdev_tl_if(clk_io, rst_n);
tl_if pwrmgr_tl_if(clk_io, rst_n);
tl_if rstmgr_tl_if(clk_io, rst_n);
tl_if clkmgr_tl_if(clk_io, rst_n);

initial begin
  bit xbar_mode;
  void'($value$plusargs("xbar_mode=%0b", xbar_mode));
  if (xbar_mode) begin
    // only enable assertions in xbar as many pins are unconnected
    $assertoff(0, tb);
    $asserton(0, tb.dut.top_earlgrey.u_xbar_main);
    $asserton(0, tb.dut.top_earlgrey.u_xbar_peri);

    clk_rst_if_main.set_active(.drive_rst_n_val(0));
    clk_rst_if_main.set_freq_mhz(100000000 / 1000_000.0);
    clk_rst_if_io.set_active(.drive_rst_n_val(0));
    clk_rst_if_io.set_freq_mhz(100000000 / 1000_000.0);
    clk_rst_if_usb.set_active(.drive_rst_n_val(0));
    clk_rst_if_usb.set_freq_mhz(48000000 / 1000_000.0);
    clk_rst_if_aon.set_active(.drive_rst_n_val(0));
    clk_rst_if_aon.set_freq_mhz(200000 / 1000_000.0);

    // bypass clkmgr, force clocks directly
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_main_aes = clk_main;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_main_hmac = clk_main;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_main_infra = clk_main;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_io_infra = clk_io;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_io_secure = clk_io;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_main_secure = clk_main;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_io_peri = clk_io;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_usb_peri = clk_usb;
    force tb.dut.top_earlgrey.clkmgr_clocks.clk_io_timers = clk_io;

    // bypass rstmgr, force resets directly
    force tb.dut.top_earlgrey.u_xbar_main.rst_main_ni = rst_n;
    force tb.dut.top_earlgrey.u_xbar_main.rst_fixed_ni = rst_n;
    force tb.dut.top_earlgrey.u_xbar_peri.rst_peri_ni = rst_n;

    `DRIVE_TL_HOST_IF(corei, dut.top_earlgrey, clk_main, rst_n, h_h2d, h_d2h)
    `DRIVE_TL_HOST_IF(cored, dut.top_earlgrey, clk_main, rst_n, h_h2d, h_d2h)
    `DRIVE_TL_HOST_IF(dm_sba, dut.top_earlgrey, clk_main, rst_n, h_h2d, h_d2h)

    `DRIVE_TL_DEVICE_IF(rom, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(debug_mem, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(ram_main, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(eflash, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(flash_ctrl, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(hmac, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(aes, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(rv_plic, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(pinmux, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(padctrl, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(alert_handler, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(nmi_gen, dut.top_earlgrey, clk_main, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(uart, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(gpio, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(spi_device, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(rv_timer, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(usbdev, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(pwrmgr, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(rstmgr, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
    `DRIVE_TL_DEVICE_IF(clkmgr, dut.top_earlgrey, clk_io, rst_n, d_d2h, d_h2d)
  end
end
