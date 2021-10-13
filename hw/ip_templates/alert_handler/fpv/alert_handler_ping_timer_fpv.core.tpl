CAPI=2:
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:fpv:alert_handler_ping_timer_fpv:0.1")}
description: "ALERT_HANDLER FPV target"
filesets:
  files_fpv:
    depend:
      - lowrisc:prim:all
      - ${instance_vlnv("lowrisc:ip:alert_handler")}
    files:
      - vip/alert_handler_ping_timer_assert_fpv.sv
      - tb/alert_handler_ping_timer_bind_fpv.sv
      - tb/alert_handler_ping_timer_tb.sv
    file_type: systemVerilogSource

targets:
  default:
    # note, this setting is just used
    # to generate a file list for jg
    default_tool: icarus
    filesets:
      - files_fpv
    toplevel: alert_handler_ping_timer_tb
