// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tb__xbar_connect generated by `topgen.py` tool

`define DRIVE_TL_HOST_IF(tl_name, inst_name, sig_name) \
     force ``tl_name``_tl_if.d2h = dut.top_earlgrey.u_``inst_name``.``sig_name``_i; \
     force dut.top_earlgrey.u_``inst_name``.``sig_name``_o = ``tl_name``_tl_if.h2d; \
     uvm_config_db#(virtual tl_if)::set(null, $sformatf("*%0s*", `"tl_name`"), "vif", \
                                        ``tl_name``_tl_if);

`define DRIVE_TL_DEVICE_IF(tl_name, inst_name, sig_name) \
     force ``tl_name``_tl_if.h2d = dut.top_earlgrey.u_``inst_name``.``sig_name``_i; \
     force dut.top_earlgrey.u_``inst_name``.``sig_name``_o = ``tl_name``_tl_if.d2h; \
     uvm_config_db#(virtual tl_if)::set(null, $sformatf("*%0s*", `"tl_name`"), "vif", \
                                        ``tl_name``_tl_if);

`define DRIVE_TL_EXT_DEVICE_IF(tl_name, port_name) \
     force ``tl_name``_tl_if.h2d = dut.top_earlgrey.``port_name``_req_o; \
     force dut.top_earlgrey.``port_name``_rsp_i = ``tl_name``_tl_if.d2h; \
     uvm_config_db#(virtual tl_if)::set(null, $sformatf("*%0s*", `"tl_name`"), "vif", \
                                        ``tl_name``_tl_if);

wire clk_main;
clk_rst_if clk_rst_if_main(.clk(clk_main), .rst_n(rst_n));
wire clk_io_div4;
clk_rst_if clk_rst_if_io_div4(.clk(clk_io_div4), .rst_n(rst_n));

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
tl_if otbn_tl_if(clk_main, rst_n);
tl_if uart_tl_if(clk_io_div4, rst_n);
tl_if gpio_tl_if(clk_io_div4, rst_n);
tl_if spi_device_tl_if(clk_io_div4, rst_n);
tl_if rv_timer_tl_if(clk_io_div4, rst_n);
tl_if usbdev_tl_if(clk_io_div4, rst_n);
tl_if pwrmgr_tl_if(clk_io_div4, rst_n);
tl_if rstmgr_tl_if(clk_io_div4, rst_n);
tl_if clkmgr_tl_if(clk_io_div4, rst_n);
tl_if ram_ret_tl_if(clk_io_div4, rst_n);
tl_if sensor_ctrl_tl_if(clk_io_div4, rst_n);
tl_if ast_wrapper_tl_if(clk_io_div4, rst_n);

initial begin
  bit xbar_mode;
  void'($value$plusargs("xbar_mode=%0b", xbar_mode));
  if (xbar_mode) begin
    // disable ibex clock to avoid printting too much useless log from ibex
    force `CPU_HIER.clk_i = 1'b0;
    // only enable assertions in xbar as many pins are unconnected
    $assertoff(0, tb);
    $asserton(0, tb.dut.top_earlgrey.u_xbar_main);
    $asserton(0, tb.dut.top_earlgrey.u_xbar_peri);

    clk_rst_if_main.set_active(.drive_rst_n_val(0));
    clk_rst_if_main.set_freq_khz(100000000 / 1000);
    clk_rst_if_io_div4.set_active(.drive_rst_n_val(0));
    clk_rst_if_io_div4.set_freq_khz(24000000 / 1000);

    // bypass clkmgr, force clocks directly
    force tb.dut.top_earlgrey.u_xbar_main.clk_main_i = clk_main;
    force tb.dut.top_earlgrey.u_xbar_main.clk_fixed_i = clk_io_div4;
    force tb.dut.top_earlgrey.u_xbar_peri.clk_peri_i = clk_io_div4;

    // bypass rstmgr, force resets directly
    force tb.dut.top_earlgrey.u_xbar_main.rst_main_ni = rst_n;
    force tb.dut.top_earlgrey.u_xbar_main.rst_fixed_ni = rst_n;
    force tb.dut.top_earlgrey.u_xbar_peri.rst_peri_ni = rst_n;

    `DRIVE_TL_HOST_IF(corei, rv_core_ibex, tl_i)
    `DRIVE_TL_HOST_IF(cored, rv_core_ibex, tl_d)
    `DRIVE_TL_HOST_IF(dm_sba, dm_top, tl_h)
    `DRIVE_TL_DEVICE_IF(rom, tl_adapter_rom, tl)
    `DRIVE_TL_DEVICE_IF(debug_mem, dm_top, tl_d)
    `DRIVE_TL_DEVICE_IF(ram_main, tl_adapter_ram_main, tl)
    `DRIVE_TL_DEVICE_IF(eflash, tl_adapter_eflash, tl)
    `DRIVE_TL_DEVICE_IF(flash_ctrl, flash_ctrl, tl)
    `DRIVE_TL_DEVICE_IF(hmac, hmac, tl)
    `DRIVE_TL_DEVICE_IF(aes, aes, tl)
    `DRIVE_TL_DEVICE_IF(rv_plic, rv_plic, tl)
    `DRIVE_TL_DEVICE_IF(pinmux, pinmux, tl)
    `DRIVE_TL_DEVICE_IF(padctrl, padctrl, tl)
    `DRIVE_TL_DEVICE_IF(alert_handler, alert_handler, tl)
    `DRIVE_TL_DEVICE_IF(nmi_gen, nmi_gen, tl)
    `DRIVE_TL_DEVICE_IF(otbn, otbn, tl)
    `DRIVE_TL_DEVICE_IF(uart, uart, tl)
    `DRIVE_TL_DEVICE_IF(gpio, gpio, tl)
    `DRIVE_TL_DEVICE_IF(spi_device, spi_device, tl)
    `DRIVE_TL_DEVICE_IF(rv_timer, rv_timer, tl)
    `DRIVE_TL_DEVICE_IF(usbdev, usbdev, tl)
    `DRIVE_TL_DEVICE_IF(pwrmgr, pwrmgr, tl)
    `DRIVE_TL_DEVICE_IF(rstmgr, rstmgr, tl)
    `DRIVE_TL_DEVICE_IF(clkmgr, clkmgr, tl)
    `DRIVE_TL_DEVICE_IF(ram_ret, tl_adapter_ram_ret, tl)
    `DRIVE_TL_DEVICE_IF(sensor_ctrl, sensor_ctrl, tl)
    `DRIVE_TL_EXT_DEVICE_IF(ast_wrapper, ast_tl)
  end
end

`undef DRIVE_TL_HOST_IF
`undef DRIVE_TL_DEVICE_IF
