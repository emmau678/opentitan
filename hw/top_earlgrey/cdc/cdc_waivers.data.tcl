# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Verix CDC waiver file

set_rule_status -rule {CNTL} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_gpio.gen_filter[0].u_filter.gen_async.prim_flop_2sync.u_sync_1.gen_generic.u_impl_generic.q_o[0]") && (Signal =~ "IO*") && (Association == "None") && (SyncDepth == "2") && (SyncFlop == "top_earlgrey.u_gpio.gen_filter[0].u_filter.gen_async.prim_flop_2sync.u_sync_2.gen_generic.u_impl_generic.q_o[0]")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c2.i2c_core.scl_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c2.i2c_core.sda_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c1.i2c_core.scl_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c1.i2c_core.sda_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c0.i2c_core.sda_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(ReceivingFlop == "top_earlgrey.u_i2c0.i2c_core.scl_rx_val[0]") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop =~ "top_earlgrey.u_pinmux_aon.dio_out_retreg_q*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.sd_i_q[3:0]") && (Signal =~ "IO*")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.rx_buf_q[3:0]") && (Signal =~ "IO*")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.sr_q[3:0]") && (Signal =~ "IO*")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV2_CLK,IO_DIV4_CLK") && (ReceivingFlop =~ "IO*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "JTAG_TCK::IO_DIV2_CLK,IO_DIV4_CLK") && (ReceivingFlop =~ "IO*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") && (ReceivingFlop =~ "SPI_DEV_D*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "JTAG_TCK::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") && (ReceivingFlop =~ "SPI_DEV_D*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {IO_DIV2_CLK and IO_DIV4_CLK can be assigned on the same PAD}

set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_flash_ctrl.u_eflash.u_flash.gen_generic.u_impl_generic.gen_prim_flash_banks[0].u_prim_flash_bank.st_q[2:0]") && (Signal == "IOB2") && (Association == "Load-Control")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::ast_ext_clk,main_clk") && (receivingflop == "top_earlgrey.u_flash_ctrl.u_eflash.u_flash.gen_generic.u_impl_generic.gen_prim_flash_banks[1].u_prim_flash_bank.st_q[2:0]") && (signal == "iob2") && (association == "load-control")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::io_div4_clk,jtag_tck") && (receivingflop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.dr_q[40]") && (signal == "ior2") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::io_div4_clk,jtag_tck") && (receivingflop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.dtmcs_q.zero1[31]") && (signal == "ior2") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::io_div4_clk,jtag_tck") && (receivingflop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.i_dmi_jtag_tap.idcode_q[31]") && (signal == "ior2") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::io_div4_clk,jtag_tck") && (receivingflop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.i_dmi_jtag_tap.jtag_ir_shift_q[4]") && (signal == "ior2") && (association == "none")} -status {waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "io_div2_clk,io_div4_clk::io_div4_clk,jtag_tck") && (receivingflop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.i_dmi_jtag_tap.tap_state_q[3:0]") && (signal == "ior0") && (association == "none")} -status {waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "jtag_tck::io_div4_clk") && (receivingflop == "top_earlgrey.u_pinmux_aon.dio_oe_retreg_q[9:6]") && (signal == "ior3") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "jtag_tck::io_div4_clk") && (receivingflop == "top_earlgrey.u_pinmux_aon.dio_out_retreg_q[9:6]") && (signal == "ior3") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {data s_net_no_wave} -expression {(multiclockdomains == "jtag_tck::io_div4_clk") && (receivingflop == "top_earlgrey.u_pinmux_aon.mio_out_retreg_q[46:0]") && (signal == "ior3") && (association == "none")} -status {waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pinmux_aon.u_pinmux_strap_sampling.dft_strap_q[0]") && (Signal == "IOC3") && (Association == "None")} -status {Waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pinmux_aon.u_pinmux_strap_sampling.dft_strap_q[1]") && (Signal == "IOC4") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pinmux_aon.u_pinmux_strap_sampling.tap_strap_q[0]") && (Signal == "IOC8") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pinmux_aon.u_pinmux_strap_sampling.tap_strap_q[1]") && (Signal == "IOC5") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pwrmgr_aon.u_fsm.u_state_regs.u_state_flop.gen_generic.u_impl_generic.q_o[11:0]") && (Signal == "IOB1") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "top_earlgrey.u_pwrmgr_aon.u_fsm.u_state_regs.u_state_flop.gen_generic.u_impl_generic.q_o[11:0]") && (Signal == "IOB2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.dr_q[40]") && (Signal == "IOR2") && (Association == "None")} -status {Waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.dtmcs_q.zero1[31]") && (Signal == "IOR2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.idcode_q[31]") && (Signal == "IOR2") && (Association == "None")} -status {Waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.jtag_ir_shift_q[4]") && (Signal == "IOR2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.tap_state_q[3:0]") && (Signal == "IOR0") && (Association == "None")} -status {Waived}  -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "JTAG_TCK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.rx_buf_q[3:0]") && (Signal == "IOR3") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "JTAG_TCK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.sd_i_q[3:0]") && (Signal == "IOR3") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "JTAG_TCK::IO_DIV2_CLK") && (ReceivingFlop == "top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.sr_q[3:0]") && (Signal == "IOR3") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK,JTAG_TCK") && (ReceivingFlop == "top_earlgrey.u_lc_ctrl.u_dmi_jtag.i_dmi_jtag_tap.bypass_q") && (Signal == "IOR2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,JTAG_TCK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.bypass_q") && (Signal == "IOR2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "u_ast.padmux2ast_i[4]") && (Signal == "IOB2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,USB_CLK") && (ReceivingFlop == "u_ast.padmux2ast_i[4]") && (Signal == "IOB2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK") && (ReceivingFlop == "u_ast.padmux2ast_i[4]") && (Signal == "IOB2") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,USB_CLK") && (ReceivingFlop == "u_ast.padmux2ast_i[7]") && (Signal == "IOC3") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK::SPI_DEV_IN_CLK,SPI_DEV_PASSTHRU_IN_CLK") && (Signal =~ "SPI_DEV_*") && (Association == "None")} -status {Waived} -comment {Somehow tool does not recognize sync_fifo and raises a flag even though these clocks are in the same domain}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK::SPI_DEV_OUT_CLK,SPI_DEV_PASSTHRU_OUT_CLK") && (Signal =~ "SPI_DEV_*") && (Association == "None")} -status {Waived} -comment {Somehow tool does not recognize sync_fifo and raises a flag even though these clocks are in the same domain}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "SPI_HOST_CLK,SPI_HOST_PASSTHRU_CLK::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") && (ReceivingFlop =~ "SPI_DEV_*") && (Signal =~ "SPI_HOST_D*") && (Association == "None")} -status {Waived} -comment {Tool does not recognize sck_csb as spi_clk domain}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") && (ReceivingFlop =~ "SPI_DEV_*") && (Signal =~ "SPI_DEV_*") && (Association == "None")} -status {Waived} -comment {Tool does not recognize sck_csb as spi_clk domain}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "SPI_HOST_CLK,SPI_HOST_PASSTHRU_CLK::IO_DIV4_CLK") && (ReceivingFlop =~ "top_earlgrey.u_pinmux_aon.dio_out_retreg_q*") && (Signal =~ "SPI_HOST_*") && (Association == "None")} -status {Waived} -comment {pinmux dio_out_retreg is quasi-static}
set_rule_status -rule {DATA} -expression {(ReceivingFlop =~ "top_earlgrey.u_pinmux_aon.*io_o*_retreg_q*") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {pinmux io_out_retreg is quasi-static}
set_rule_status -rule {DATA S_NET_NO_WAVE} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::IO_DIV4_CLK,JTAG_TCK") && (Signal =~ "IO*") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK,IO_DIV4_CLK::AST_EXT_CLK,MAIN_CLK") && (ReceivingFlop == "top_earlgrey.u_flash_ctrl.u_eflash.u_flash.gen_generic.u_impl_generic.gen_prim_flash_banks[1].u_prim_flash_bank.st_q[2:0]") && (Signal == "IOB2") && (Association == "Load-Control")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV4_CLK::SPI_DEV_IN_CLK,SPI_DEV_PASSTHRU_IN_CLK") && (Signal =~ "top_earlgrey.u_spi_device.u_reg.u_cmd_info*.q*")} -status {Waived}  -comment {spi_device reg is quasi-static}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV4_CLK::SPI_DEV_IN_CLK,SPI_DEV_PASSTHRU_IN_CLK") && (Signal =~ "top_earlgrey.u_spi_device.u_reg.u_cfg*.q*")} -status {Waived}  -comment {spi_device reg is quasi-static}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV4_CLK::SPI_DEV_IN_CLK,SPI_DEV_PASSTHRU_IN_CLK") && (Signal =~ "top_earlgrey.u_pinmux_aon.dio_pad_attr_q*.invert")} -status {Waived}  -comment {pinmux dio_out_retreg is quasi-static}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV4_CLK::SPI_DEV_IN_CLK,SPI_DEV_PASSTHRU_IN_CLK") && (Signal =~ "top_earlgrey.u_spi_device.u_reg.u_control_mode.q*")} -status {Waived}  -comment {pinmux dio_out_retreg is quasi-static}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "IO_DIV2_CLK::IO_DIV2_CLK,IO_DIV4_CLK") && (ReceivingFlop =~ "IO*") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
set_rule_status -rule {DATA} -expression {(MultiClockDomains == "AST_EXT_CLK,MAIN_CLK::IO_DIV2_CLK,IO_DIV4_CLK") && (ReceivingFlop =~ "IO*") && (Association == "None")} -status {Waived} -comment {Multiple clocks can be assigned on the same pad}
