// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`define add_ip_csr_exclusions(ip) \
  begin \
    ip``_common_vseq m_``ip``_common_vseq; \
    m_``ip``_common_vseq = ip``_common_vseq::type_id::create({"m_", `"ip`", "_common_vseq"}); \
    m_``ip``_common_vseq.add_csr_exclusions(csr_test_type, csr_excl, {scope, ".", `"ip`"}); \
  end

class chip_common_vseq extends chip_base_vseq;
  `uvm_object_utils(chip_common_vseq)

  constraint num_trans_c {
    num_trans inside {[1:2]};
  }
  `uvm_object_new

  virtual task pre_start();
    super.pre_start();
    // Select SPI interface.
    cfg.jtag_spi_n_vif.drive(1'b0);
  endtask

  virtual task body();
    run_csr_vseq_wrapper(num_trans);
  endtask : body

endclass

`undef add_ip_csr_exclusions
