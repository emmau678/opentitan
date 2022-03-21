// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module rstmgr_bind;

  bind rstmgr tlul_assert #(
    .EndpointType("Device")
  ) tlul_assert_device (.clk_i, .rst_ni, .h2d(tl_i), .d2h(tl_o));

  // In top-level testbench, do not bind the csr_assert_fpv to reduce simulation time.
  `ifndef TOP_LEVEL_DV
  bind rstmgr rstmgr_csr_assert_fpv rstmgr_csr_assert (.clk_i, .rst_ni, .h2d(tl_i), .d2h(tl_o));
  `endif

  bind rstmgr pwrmgr_rstmgr_sva_if pwrmgr_rstmgr_sva_if (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .clk_slow_i(clk_aon_i),
    .rst_slow_ni(&rst_por_aon_n),
    // These inputs from pwrmgr are ignored since they check pwrmgr's rstreqs output.
    .rstreqs_i('0),
    .reset_en('0),
    .sw_rst_req_i('0),
    .main_rst_req_i('0),
    .esc_rst_req_i('0),
    .rstreqs('0),
    // These are actually used for checks.
    .rst_lc_req(pwr_i.rst_lc_req),
    .rst_sys_req(pwr_i.rst_sys_req),
    .main_pd_n('1),
    .ndm_sys_req(ndmreset_req_i),
    .reset_cause(pwr_i.reset_cause),
    // The inputs from rstmgr.
    .rst_lc_src_n(pwr_o.rst_lc_src_n),
    .rst_sys_src_n(pwr_o.rst_sys_src_n)
  );

  bind rstmgr rstmgr_cascading_sva_if rstmgr_cascading_sva_if (
    .clk_i,
    .clk_aon_i,
    .clk_io_div4_i,
    .clk_io_div2_i,
    .clk_io_i,
    .clk_main_i,
    .clk_usb_i,
    .por_n_i,
    .scan_rst_ni,
    .scanmode_i,
    .resets_o,
    .rst_lc_req(pwr_i.rst_lc_req),
    .rst_sys_req(pwr_i.rst_sys_req),
    .rst_lc_src_n(pwr_o.rst_lc_src_n),
    .rst_sys_src_n(pwr_o.rst_sys_src_n)
  );

  bind rstmgr rstmgr_attrs_sva_if rstmgr_attrs_sva_if (
    .rst_ni,
    .actual_alert_info_attr(int'(hw2reg.alert_info_attr)),
    .actual_cpu_info_attr(int'(hw2reg.cpu_info_attr)),
    .expected_alert_info_attr(($bits(alert_dump_i) + 31) / 32),
    .expected_cpu_info_attr(($bits(cpu_dump_i) + 31) / 32)
  );

  bind rstmgr rstmgr_sw_rst_sva_if rstmgr_sw_rst_sva_if (
    .clk_i({
      clk_io_div4_i,
      clk_io_div4_i,
      clk_io_div4_i,
      clk_usb_i,
      clk_io_div4_i,
      clk_io_div2_i,
      clk_io_i,
      clk_io_div4_i
    }),
    .rst_ni,
    .parent_rst_n(rst_sys_src_n[1]),
    .ctrl_ns(reg2hw.sw_rst_ctrl_n),
    .rst_ens({
      rst_en_o.i2c2[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.i2c1[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.i2c0[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.usbif[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.usb[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.spi_host1[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.spi_host0[1] == prim_mubi_pkg::MuBi4True,
      rst_en_o.spi_device[1] == prim_mubi_pkg::MuBi4True
    }),
    .rst_ns({
      resets_o.rst_i2c2_n[1],
      resets_o.rst_i2c1_n[1],
      resets_o.rst_i2c0_n[1],
      resets_o.rst_usbif_n[1],
      resets_o.rst_usb_n[1],
      resets_o.rst_spi_host1_n[1],
      resets_o.rst_spi_host0_n[1],
      resets_o.rst_spi_device_n[1]
    })
  );

  // sec cm coverage bind
  bind rstmgr cip_mubi_cov_if #(.Width(prim_mubi_pkg::MuBi4Width)) u_scanmode_mubi_cov_if (
    .rst_ni (rst_ni),
    .mubi   (scanmode_i)
  );
endmodule
