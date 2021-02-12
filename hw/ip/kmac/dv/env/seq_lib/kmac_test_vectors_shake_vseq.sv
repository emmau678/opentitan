// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_test_vectors_shake_vseq extends kmac_test_vectors_base_vseq;

  `uvm_object_utils(kmac_test_vectors_shake_vseq)
  `uvm_object_new

  virtual task pre_start();
    test_list = test_vectors_pkg::shake_file_list;
    super.pre_start();
  endtask

  virtual function void randomize_cfg(test_vectors_pkg::test_vectors_t vector);
    `DV_CHECK_RANDOMIZE_WITH_FATAL(this,
      hash_mode == sha3_pkg::Shake;
      kmac_en == 0;
      output_len == vector.digest_length_byte;
      if (vector.security_strength == 128) {
        strength == sha3_pkg::L128;
      } else if (vector.security_strength == 256) {
        strength == sha3_pkg::L256;
      }
    )
  endfunction

endclass
