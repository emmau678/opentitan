# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Verix CDC waiver file

# dual port memory to SPI
# Two paths from different clock domains are muxed and CDC is processed by the following Tx_FIFO.
# But, the tool seems not to recognize the FIFO after the mux.
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.b_rdata_o*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_fwmode.*")} \
  -comment {Dual port memory read port to SPI}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_reg.u_control_abort.q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_fwmode.*")} \
  -comment {reg to SPI tx_fifo}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_reg.u_control_mode.q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_fwmode.*")} \
  -comment {reg to SPI tx_fifo}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_reg.u_control_mode.q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_jedec.st_q.*")} \
  -comment {reg to SPI JEDEC}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_readcmd.u_readsram.u_sram_fifo.gen_normal_fifo*")} \
  -comment {Dual port memory read port to SPI}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_readcmd.u_readsram.u_sram_fifo.gen_normal_fifo*")} \
  -comment {Dual port memory read port to SPI}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_upload.u_arbiter.u_req_fifo.gen_normal_fifo.u_fifo_cnt.rptr_o*")} \
  -comment {Dual port memory read port to SPI}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_cmdparse.cmd_info_q.addr_mode*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*")} \
  -comment {SPI to Dual port memory read port}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_fwmode.u_rx_fifo.fifo_rptr_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*")} \
  -comment {SPI to Dual port memory read port}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_spi_tpm.u_cmdaddr_buffer.storage*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*")} \
  -comment {SPI to Dual port memory read port}

# retention regs (#13811)
# they are retention registers which receive and mux multiple paths from different clock domains
# in the pinmux block. When I asked for clarifying, I got the answer that these were semi-static.
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_DEV_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

# retention regs (#13811)
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

# PAD to spi_host
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST_*") && (ReceivingFlop=~"top_earlgrey.u_spi_host0.*.sd_i_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST_*") && (ReceivingFlop=~"top_earlgrey.u_spi_host0.*.sr_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST_*") && (ReceivingFlop=~"top_earlgrey.u_spi_host0.*.rx_buf_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IOA*") && (ReceivingFlop=~"top_earlgrey.u_spi_host0.*.*u_shift_reg*")} \
  -comment {retention regs}

# PAD to sync FFs
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"*u_sync_1.gen_generic.u_impl_generic.q_o*")} \
  -comment {retention regs}

# PAD to sync FFs
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"*u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_i2c0.i2c_core.scl_rx_val*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_lc_ctrl.u_dmi_jtag.*_q")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_pinmux_aon.mio_pad_attr_q*") && (ReceivingFlop=~"top_earlgrey.u_lc_ctrl.u_dmi_jtag.*_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_rv_dm.u_lc_en_sync.gen_flops.u_prim_flop_2sync.u_sync_2.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_lc_ctrl.u_dmi_jtag.*_q*")} \
  -comment {retention regs}


set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.bypass_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_pinmux_aon.mio_pad_attr_q*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.bypass_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_rv_dm.u_lc_en_sync.gen_flops.u_prim_flop_2sync.u_sync_2.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.bypass_q*")} \
  -comment {retention regs}


set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.dr_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.*zero1*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_pinmux_aon.mio_pad_attr_q*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.*zero1*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_rv_dm.u_lc_en_sync.gen_flops.u_prim_flop_2sync.u_sync_2.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.*zero1*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "SPI_HOST*") && (ReceivingFlop=~"*u_pinmux_aon.dio_oe_retreg_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_lc_ctrl.u_lc_ctrl_fsm.u_lc_ctrl_signal_decode.u_prim_lc_sender_hw_debug_en.gen_flops.u_prim_flop.u_secure_anchor_flop.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_xbar_main.*num_req_outstanding*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_xbar_main.*num_req_outstanding*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.tl_adapter_host_d_ibex.intg_err_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_reg_cfg.u_err_status_fatal_*_err.q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_core.gen_lockstep.u_ibex_lockstep.core_outputs_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.gen_alert_senders[2].u_alert_sender.state_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.gen_alert_senders[2].u_alert_sender.alert_set_q*")} \
  -comment {retention regs}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.reqfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_usbdev.u_memory_2p.i_prim_ram_2p_async_adv.u_mem.gen_generic.u_impl_generic.a_*_i")} \
  -comment {retention regs}

# rspfifo to normal_fifo in tlul xbar_main
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_xbar_main.u_s1n_*.fifo_h.rspfifo.gen_normal_fifo.storage*")} \
  -comment {input rspfifo rd_port is in the same domain as device_fifo}

# tlul xbar_main rspfifo to ibex
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_core.gen_regfile_ff*")} \
  -comment {tlul xbar_main rspfifo to ibex}

# tlul xbar_main rspfifo to ibex
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_core.u_ibex_core.load_store_unit_i.rdata_q*")} \
  -comment {tlul xbar_main rspfifo to ibex}

# tlul xbar_main rspfifo to ibex
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.u_prim_lc_sender.gen_flops*")} \
  -comment {tlul xbar_main rspfifo to ibex}

# tlul xbar_main rspfifo to spi_device
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.a_*")} \
  -comment {tlul xbar_main rspfifo to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.reqfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.a_*")} \
  -comment {tlul xbar_main rspfifo to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "*SPI_DEV*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.b_*")} \
  -comment {PAD to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "*SPI_DEV*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_readcmd.u_readsram.u_sram_fifo.gen_normal_fifo*")} \
  -comment {PAD to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "*SPI_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.gen_wkup_detect*.u_pinmux_wkup.u_prim_filter.gen_async.prim_flop_2sync.u_sync_1.gen_generic.u_impl_generic.q_o*")} \
  -comment {PAD to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "*USB_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.gen_wkup_detect*.u_pinmux_wkup.u_prim_filter.gen_async.prim_flop_2sync.u_sync_1.gen_generic.u_impl_generic.q_o*")} \
  -comment {PAD to spi_device}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "*SPI_*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {PAD to pinmux}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {PAD to pinmux}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device*.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {another path overlapped with PAD to pinmux}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device*.u_passthrough.passthrough_s_en*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {another path overlapped with PAD to pinmux}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_host0.u_cmd_queue.cmd_fifo.gen_normal_fifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {another path overlapped with PAD to pinmux}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_spi_device.u_passthrough.addr_phase_outclk*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.dio_out_retreg_q*")} \
  -comment {another path overlapped with PAD to pinmux}

# tlul xbar_main rspfifo to usb device
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage*") && (ReceivingFlop=~"top_earlgrey.u_usbdev.u_memory_2p.i_prim_ram_2p_async_adv.u_mem.gen_generic.u_impl_generic.a_*")} \
  -comment {tlul xbar_main rspfifo to usb device}

# W_MASYNC in AST
set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "u_ast.u_ast_clks_byp.u_clk_src_sys_sel.clk_*_en_q*") && (ReceivingFlop=~"u_ast.u_ast_clks_byp.u_clk_src_*_sel.clk_ext_aoff*")} \
  -comment {w_masync issues in AST block}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "u_ast.u_ast_clks_byp.u_clk_src_*_sel.clk_*_aoff*") && (ReceivingFlop=~"top_earlgrey.u_pwrmgr_aon.u_cdc.u_ast_sync.u_sync_1.gen_generic.u_impl_generic.q_o*")} \
  -comment {w_masync issues from AST block}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_i2c*.s*_rx_val*")} \
  -comment {w_masync issues from PAD}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_spi_host1.u_spi_core.u_shift_reg.*_q*")} \
  -comment {w_masync issues from PAD}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_pinmux_aon.mio_out_retreg_q*")} \
  -comment {w_masync issues from PAD}

set_rule_status -rule {W_MASYNC} -status {Waived}                           \
  -expression {(Driver =~ "IO*") && (ReceivingFlop=~"top_earlgrey.u_rv_dm.dap.i_dmi_jtag_tap.*_q*")} \
  -comment {w_masync issues from PAD}

set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(ReceivingFlop=~"top_earlgrey.u_spi_device.u_memory_2p.u_mem.gen_generic.u_impl_generic.a_*_i*")} -comment {multiple source to 2p memory in SPI }
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(ReceivingFlop=~"top_earlgrey.u_usbdev.gen_no_stubbed_memory.u_memory_2p.i_prim_ram_2p_async_adv.u_mem.gen_generic.u_impl_generic.a_*_i*")} -comment {multiple source to 2p memory in USB}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_readcmd.u_readsram.u_fifo.gen_normal_fifo.storage*")} -comment {multiple source to readcmd sram in spi device}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(Driver =~ "top_earlgrey.u_spi_device.u_memory_2p.b_rvalid_sram_q*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_readcmd.p2s_byte_o*")} -comment {multiple source to 2p memory in spi device}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(Driver =~ "top_earlgrey.u_spi_device.u_spid_status.u_stage_to_commit.gen_generic.u_impl_generic.q_o*") && (ReceivingFlop=~"top_earlgrey.u_spi_device.u_spid_status.outclk_p2s_byte_o*")} -comment {multiple source to 2p memory in spi device}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage[0]*") && (ReceivingFlop=~"top_earlgrey.u_rv_core_ibex.gen_alert_senders[2].u_alert_sender.u_prim_flop_alert.u_secure_anchor_flop.gen_generic.u_impl_generic.q_o*")} -comment {xbar main async fifo to rv_core_ibex.gen-alert_senders}
set_rule_status -rule {W_MASYNC} -status {Waived} -expression {(Driver =~ "top_earlgrey.u_xbar_main.u_asf_*.rspfifo.storage[0]*") && (ReceivingFlop=~"top_earlgrey.u_xbar_main.u_s1n_57.fifo_h.rspfifo.gen_normal_fifo.u_fifo_cnt.wptr_o*")} -comment {xbar main async fifo to rv_core_ibex.gen-alert_senders}
