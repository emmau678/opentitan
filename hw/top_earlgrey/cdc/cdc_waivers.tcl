# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Verix CDC waiver file

# TODO: need to add more common waivers here. We may have to break this into
# multiple files.
#
# set_rule_status -rule { S_CONF_ENV } -status { Waived } -expression { } \
#   -comment {}
# set_rule_status -rule { S_CONF_ENV } -status { Waived } -all_rule_data \
#   -comment {}


# Assumes modules defined in run-cdc.tcl

if {[info exists modules] == 0} {
  error "modules variable does not exist!" 99
}

foreach mod $modules {
  if {[file exists $CDC_WAIVER_DIR/cdc_waivers.$mod.tcl]} {
    source $CDC_WAIVER_DIR/cdc_waivers.$mod.tcl
  }
}

# Common Waivers

# Muxed PAD output
# For IO PADs, Clock does not matter.
set_rule_status -rule {W_DATA W_MASYNC} -status {Waived} \
  -expression {(ReceivingFlop =~ "IO*")}                 \
  -comment {Direct output without flop}

# Driving from PAD to gpio/ uart/ i2c
set_rule_status -rule {W_MASYNC} -status {Waived}           \
  -expression {(Driver=~"IO*") &&                           \
    (ReceivingFlop=~"*u_gpio.gen_filter*prim_flop_2sync*")} \
  -comment {Other than PADS, other signals are static}
set_rule_status -rule {W_MASYNC} -status {Waived}                         \
  -expression {(Driver=~"IO*") && (ReceivingFlop=~"*u_uart*.*u_sync_1*")} \
  -comment {Other than PADS, other signals are static}
set_rule_status -rule {W_CNTL} -status {Waived}                           \
  -expression {(Signal=~"IO*") && (ReceivingFlop=~"*u_i2c*.*.u_sync_1*")} \
  -comment {PAD driving to I2C. PADs are not clock bounded}

set_rule_status -rule {W_GLITCH} -status {Waived}          \
  -expression {(GlitchInput=~"IO*") &&                     \
    (GlitchOutput=~"*u_sync_1*")} \
  -comment {Waive PADs input goes into synchronizer}

# Driving from PAD RESET to SPI TPM
set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived}                           \
  -expression {(DrivingSignal=~"IO*") && (ReceivingFlop=~"*u_spi_device.u_spi_tpm.*")} \
  -comment {PAD RESET driving to SPI TPM}

set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived}                           \
  -expression {(DrivingSignal=~"SPI_DEV_CS_L*") && (ReceivingFlop=~"*u_spi_device.u_spi_tpm.*")} \
  -comment {PAD RESET driving to SPI TPM}

set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived}                           \
  -expression {(DrivingSignal=~"top_earlgrey.u_pinmux_aon*") && (ReceivingFlop=~"*u_spi_device.u_spi_tpm.*")} \
  -comment {PAD RESET driving to SPI TPM}

set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived}                           \
  -expression {(DrivingSignal=~"top_earlgrey.u_rstmgr_aon*") && (ReceivingFlop=~"*u_spi_device.u_spi_tpm.*")} \
  -comment {PAD RESET driving to SPI TPM}

# Driving from PAD PIN MUX RESET to DMI JTAG
set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived}                           \
  -expression {(DrivingSignal=~"top_earlgrey.u_pinmux_aon*") && (ReceivingFlop=~"*u_dmi_jtag.*")} \
  -comment {PAD RESET driving to dmi jtag}

# dual port memory to SPI
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.b_rdata_o*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_fwmode.*")} \
  -comment {Dual port memory read port to SPI}

# retention regs (#13811)
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_DEV_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

# retention regs (#13811)
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

# rspfifo to normal_fifo in tlul xbar_main
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_xbar_main.u_s1n_57.fifo_h.rspfifo.gen_normal_fifo.storage*")} \
  -comment {input rspfifo rd_port is in the same domain as device_fifo}

# tlul xbar_main rspfifo to ibex
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_core.gen_regfile_ff*")} \
  -comment {tlul xbar_main rspfifo to ibex}

# tlul xbar_main rspfifo to ibex
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_prim_lc_sender.gen_flops*")} \
  -comment {tlul xbar_main rspfifo to ibex}

# tlul xbar_main rspfifo to spi_device
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.a_*")} \
  -comment {tlul xbar_main rspfifo to spi_device}

# tlul xbar_main rspfifo to usb device
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_usbdev.u_memory_2p.i_prim_ram_2p_async_adv.u_mem.gen_generic.u_impl_generic.a_*")} \
  -comment {tlul xbar_main rspfifo to usb device}

# AST signals reconverged
set_rule_status -rule {W_RECON_GROUPS} -status {Waived}                           \
  -expression {(ControlSignal =~ "u_ast.u_ast_clks_byp.*u_impl_generic.q_o*") && (ReconSignal=~"top_earlgrey.*.u_reg*")} \
  -comment {Reconverged signals coming from AST}

# RV PLIC signals reconverged
set_rule_status -rule {W_RECON_GROUPS} -status {Waived}                           \
  -expression {(ControlSignal =~ "*u_rv_plic.*") && (ReconSignal=~"*u_rv_plic.u_gateway.ia*")} \
  -comment {Reconverged signals in RV PLIC}

# Misc RV PLIC signals reconverged
set_rule_status -rule {W_RECON_GROUPS} -status {Waived}                           \
  -expression {(ControlSignal =~ "*u_sync_1.gen_generic.u_impl_generic.q_o*") && (ReconSignal=~"*u_rv_plic.u_gateway.ia*")} \
  -comment {Reconverged signals in RV PLIC}

# PADs attribute to multiple IPs
# Assume the attributes are not used when IPs are active
set_rule_status -rule {W_FANOUT} -status {Waived}           \
  -expression {(Driver =~ "*u_pinmux_aon.dio_pad_attr_q*")} \
  -comment {ATTR static signal propagates into USB_CLK, AON_CLK. But no Reconvergence issue}

# SPI Device PADS output
set_rule_status -rule {W_DATA} -status {Waived} -expression             \
  {(MultiClockDomains =~ "*::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") &&      \
  (ReceivingFlop =~ "SPI_DEV_*")} -comment {Direct output without flop}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression           \
  {(MultiClockDomains =~ "*::SPI_DEV_CLK,SPI_DEV_PASSTHRU_CLK") &&      \
  (ReceivingFlop =~ "SPI_DEV_*")} -comment {Direct output without flop}

set_rule_status -rule {W_DATA} -status {Waived} -expression               \
  {(MultiClockDomains =~ "*::SPI_HOST_CLK,SPI_HOST_PASSTHRU_CLK") &&      \
  (ReceivingFlop =~ "SPI_HOST_*")} -comment {Direct output without flop}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression             \
  {(MultiClockDomains =~ "*::SPI_HOST_CLK,SPI_HOST_PASSTHRU_CLK") &&      \
  (ReceivingFlop =~ "SPI_HOST_*")} -comment {Direct output without flop}

## ASYNC FIFO Gray Pointer
set_rule_status -rule {W_CNTL} -status {Waived}                              \
  -expression {(Signal=~"*ptr_gray_q*") && (ReceivingFlop =~ "*.u_sync_1*")} \
  -comment {Gray Pointer sync}

## Waive pinmux attr: static
# TODO(#13806): set_stable_value has not been added because it's overlapped with this existing waiver
set_rule_status -rule {W_MASYNC} -status {Waived}        \
  -expression {(Driver=~"*u_pinmux_aon.dio_pad_attr_*")} \
  -comment {PAD Attributes are static signals.}

# JTAG en
set_rule_status -rule {W_ASYNC_RST_FLOPS} -status {Waived} \
  -expression {(DrivingSignal=~"*.u_pinmux_strap_sampling.tap_strap_q*")} \
  -comment {Tester should ensure no jtag transactions when tap_strap is sampled}

set_rule_status -rule {W_CNTL} -status {Waived} \
  -expression {(Signal=~"*u_pinmux_aon.dio_pad_attr_*")} \
  -comment {PAD Attributes are static signals.}
set_rule_status -rule {W_DATA} -status {Waived} \
  -expression {(Signal=~"*u_pinmux_aon.dio_pad_attr_*")} \
  -comment {PAD Attributes are static signals.}

set_rule_status -rule {S_GENCLK} -status {Waived} \
  -expression {(ClockTreeSignal=~"u_ast.u_ast_clks_byp.*") && (DrivenFlop =~ "u_ast.u_ast_clks_byp.*")} \
  -comment {ast clks are assumed to be checked by the partner as standalone.}
