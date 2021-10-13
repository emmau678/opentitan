CAPI=2:
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:ip:rv_plic_fpv:0.1")}
description: "FPV for RISC-V PLIC"

filesets:
  files_formal:
    depend:
      - lowrisc:ip:tlul
      - lowrisc:prim:all
      - ${instance_vlnv("lowrisc:ip:rv_plic")}
      - lowrisc:fpv:csr_assert_gen
    files:
      - tb/rv_plic_bind_fpv.sv
      - tb/rv_plic_tb.sv
      - vip/rv_plic_assert_fpv.sv
    file_type: systemVerilogSource


generate:
  csr_assert_gen:
    generator: csr_assert_gen
    parameters:
      spec: ../data/rv_plic.hjson
      depend: ${instance_vlnv("lowrisc:ip:rv_plic")}

targets:
  default: &default_target
    # note, this setting is just used
    # to generate a file list for jg
    default_tool: icarus
    filesets:
      - files_formal
    generate:
      - csr_assert_gen
    toplevel: rv_plic_tb

  formal:
    <<: *default_target

  lint:
    <<: *default_target
