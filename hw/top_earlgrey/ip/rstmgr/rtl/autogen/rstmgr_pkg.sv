// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This module is the overall reset manager wrapper
// TODO: This module is only a draft implementation that covers most of the rstmgr
// functoinality but is incomplete

package rstmgr_pkg;

  // Power domain parameters
  parameter int PowerDomains = 2;
  parameter int DomainAonSel = 0;
  parameter int Domain0Sel = 1;

  // Number of non-always-on domains
  parameter int OffDomains = PowerDomains-1;

  // positions of software controllable reset bits
  parameter int SPI_DEVICE = 0;
  parameter int SPI_HOST0 = 1;
  parameter int SPI_HOST1 = 2;
  parameter int USB = 3;
  parameter int USBIF = 4;
  parameter int I2C0 = 5;
  parameter int I2C1 = 6;
  parameter int I2C2 = 7;

  // resets generated and broadcast
  typedef struct packed {
    logic [PowerDomains-1:0] rst_por_aon_n;
    logic [PowerDomains-1:0] rst_por_n;
    logic [PowerDomains-1:0] rst_por_io_n;
    logic [PowerDomains-1:0] rst_por_io_div2_n;
    logic [PowerDomains-1:0] rst_por_io_div4_n;
    logic [PowerDomains-1:0] rst_por_usb_n;
    logic [PowerDomains-1:0] rst_lc_shadowed_n;
    logic [PowerDomains-1:0] rst_lc_n;
    logic [PowerDomains-1:0] rst_lc_io_div4_shadowed_n;
    logic [PowerDomains-1:0] rst_lc_io_div4_n;
    logic [PowerDomains-1:0] rst_lc_aon_n;
    logic [PowerDomains-1:0] rst_sys_shadowed_n;
    logic [PowerDomains-1:0] rst_sys_n;
    logic [PowerDomains-1:0] rst_sys_io_div4_n;
    logic [PowerDomains-1:0] rst_sys_aon_n;
    logic [PowerDomains-1:0] rst_spi_device_n;
    logic [PowerDomains-1:0] rst_spi_host0_n;
    logic [PowerDomains-1:0] rst_spi_host1_n;
    logic [PowerDomains-1:0] rst_usb_n;
    logic [PowerDomains-1:0] rst_usbif_n;
    logic [PowerDomains-1:0] rst_i2c0_n;
    logic [PowerDomains-1:0] rst_i2c1_n;
    logic [PowerDomains-1:0] rst_i2c2_n;
  } rstmgr_out_t;

  // reset indication for alert handler
  typedef struct packed {
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_aon;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_io;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_io_div2;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_io_div4;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_usb;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_shadowed;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_io_div4_shadowed;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_io_div4;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_aon;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] sys_shadowed;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] sys;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] sys_io_div4;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] sys_aon;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] spi_device;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] spi_host0;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] spi_host1;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] usb;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] usbif;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] i2c0;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] i2c1;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] i2c2;
  } rstmgr_rst_en_t;

  parameter int NumOutputRst = 23 * PowerDomains;

  // cpu reset requests and status
  typedef struct packed {
    logic rst_cpu_n;
    logic ndmreset_req;
  } rstmgr_cpu_t;

  // exported resets

  // default value for rstmgr_ast_rsp_t (for dangling ports)
  parameter rstmgr_cpu_t RSTMGR_CPU_DEFAULT = '{
    rst_cpu_n: 1'b1,
    ndmreset_req: '0
  };

endpackage // rstmgr_pkg
