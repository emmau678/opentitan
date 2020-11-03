CAPI=2:
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: "${vendor}:dv:${name}_sim:0.1"
description: "${name.upper()} DV sim target"
filesets:
  files_rtl:
    depend:
      - ${vendor}:ip:${name}

  files_dv:
    depend:
      - ${vendor}:dv:${name}_test
      - ${vendor}:dv:${name}_sva
    files:
      - tb.sv
    file_type: systemVerilogSource

targets:
  sim: &sim_target
    toplevel: tb
    filesets:
      - files_rtl
      - files_dv
    default_tool: vcs

  lint:
    <<: *sim_target
    default_tool: verilator
    tools:
      ascentlint:
        ascentlint_options:
          - "-wait_license"
          - "-stop_on_error"
      verilator:
        mode: lint-only
        verilator_options:
          - "-Wall"
