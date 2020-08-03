CAPI=2:
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: "lowrisc:fpv:rv_plic_fpv:0.1"
description: "FPV genenric testbench for RISC-V PLIC example"

filesets:
  files_formal:
    depend:
      - lowrisc:fpv:rv_plic_component_fpv
      - lowrisc:top_earlgrey:rv_plic
      - lowrisc:fpv:csr_assert_gen
    files:
      - rv_plic_bind_fpv.sv
      - rv_plic_fpv.sv
    file_type: systemVerilogSource

generate:
  csr_assert_gen:
    generator: csr_assert_gen
    parameters:
      spec: ../../data/autogen/rv_plic.hjson
      depend: lowrisc:top_earlgrey:rv_plic

targets:
  default: &default_target
    # note, this setting is just used
    # to generate a file list for jg
    default_tool: icarus
    filesets:
      - files_formal
    generate:
      - csr_assert_gen
    toplevel: rv_plic_fpv

  formal:
    <<: *default_target
