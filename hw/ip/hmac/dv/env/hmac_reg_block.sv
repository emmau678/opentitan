// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// UVM Registers auto-generated by `reggen` containing data structure
// Do Not Edit directly

// Block: hmac
`ifndef HMAC_REG_BLOCK__SV
`define HMAC_REG_BLOCK__SV

// Forward declare all register/memory/block classes
typedef class hmac_reg_intr_state;
typedef class hmac_reg_intr_enable;
typedef class hmac_reg_intr_test;
typedef class hmac_reg_cfg;
typedef class hmac_reg_cmd;
typedef class hmac_reg_status;
typedef class hmac_reg_err_code;
typedef class hmac_reg_wipe_secret;
typedef class hmac_reg_key0;
typedef class hmac_reg_key1;
typedef class hmac_reg_key2;
typedef class hmac_reg_key3;
typedef class hmac_reg_key4;
typedef class hmac_reg_key5;
typedef class hmac_reg_key6;
typedef class hmac_reg_key7;
typedef class hmac_reg_digest0;
typedef class hmac_reg_digest1;
typedef class hmac_reg_digest2;
typedef class hmac_reg_digest3;
typedef class hmac_reg_digest4;
typedef class hmac_reg_digest5;
typedef class hmac_reg_digest6;
typedef class hmac_reg_digest7;
typedef class hmac_reg_msg_length_lower;
typedef class hmac_reg_msg_length_upper;
typedef class hmac_mem_msg_fifo;
typedef class hmac_reg_block;

// Class: hmac_reg_intr_state
class hmac_reg_intr_state extends dv_base_reg;
  // fields
  rand dv_base_reg_field hmac_done;
  rand dv_base_reg_field fifo_full;
  rand dv_base_reg_field hmac_err;

  `uvm_object_utils(hmac_reg_intr_state)

  function new(string       name = "hmac_reg_intr_state",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    hmac_done = dv_base_reg_field::type_id::create("hmac_done");
    hmac_done.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    fifo_full = dv_base_reg_field::type_id::create("fifo_full");
    fifo_full.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("W1C"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    hmac_err = dv_base_reg_field::type_id::create("hmac_err");
    hmac_err.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("W1C"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_intr_state

// Class: hmac_reg_intr_enable
class hmac_reg_intr_enable extends dv_base_reg;
  // fields
  rand dv_base_reg_field hmac_done;
  rand dv_base_reg_field fifo_full;
  rand dv_base_reg_field hmac_err;

  `uvm_object_utils(hmac_reg_intr_enable)

  function new(string       name = "hmac_reg_intr_enable",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    hmac_done = dv_base_reg_field::type_id::create("hmac_done");
    hmac_done.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    fifo_full = dv_base_reg_field::type_id::create("fifo_full");
    fifo_full.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    hmac_err = dv_base_reg_field::type_id::create("hmac_err");
    hmac_err.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_intr_enable

// Class: hmac_reg_intr_test
class hmac_reg_intr_test extends dv_base_reg;
  // fields
  rand dv_base_reg_field hmac_done;
  rand dv_base_reg_field fifo_full;
  rand dv_base_reg_field hmac_err;

  `uvm_object_utils(hmac_reg_intr_test)

  function new(string       name = "hmac_reg_intr_test",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    hmac_done = dv_base_reg_field::type_id::create("hmac_done");
    hmac_done.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    fifo_full = dv_base_reg_field::type_id::create("fifo_full");
    fifo_full.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    hmac_err = dv_base_reg_field::type_id::create("hmac_err");
    hmac_err.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_intr_test

// Class: hmac_reg_cfg
class hmac_reg_cfg extends dv_base_reg;
  // fields
  rand dv_base_reg_field hmac_en;
  rand dv_base_reg_field sha_en;
  rand dv_base_reg_field endian_swap;
  rand dv_base_reg_field digest_swap;

  `uvm_object_utils(hmac_reg_cfg)

  function new(string       name = "hmac_reg_cfg",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    hmac_en = dv_base_reg_field::type_id::create("hmac_en");
    hmac_en.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    sha_en = dv_base_reg_field::type_id::create("sha_en");
    sha_en.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    endian_swap = dv_base_reg_field::type_id::create("endian_swap");
    endian_swap.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("RW"),
      .volatile(0),
      .reset(32'h1),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    digest_swap = dv_base_reg_field::type_id::create("digest_swap");
    digest_swap.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_cfg

// Class: hmac_reg_cmd
class hmac_reg_cmd extends dv_base_reg;
  // fields
  rand dv_base_reg_field hash_start;
  rand dv_base_reg_field hash_process;

  `uvm_object_utils(hmac_reg_cmd)

  function new(string       name = "hmac_reg_cmd",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    hash_start = dv_base_reg_field::type_id::create("hash_start");
    hash_start.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    hash_process = dv_base_reg_field::type_id::create("hash_process");
    hash_process.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("W1C"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_cmd

// Class: hmac_reg_status
class hmac_reg_status extends dv_base_reg;
  // fields
  rand dv_base_reg_field fifo_empty;
  rand dv_base_reg_field fifo_full;
  rand dv_base_reg_field fifo_depth;

  `uvm_object_utils(hmac_reg_status)

  function new(string       name = "hmac_reg_status",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    fifo_empty = dv_base_reg_field::type_id::create("fifo_empty");
    fifo_empty.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    fifo_full = dv_base_reg_field::type_id::create("fifo_full");
    fifo_full.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    fifo_depth = dv_base_reg_field::type_id::create("fifo_depth");
    fifo_depth.configure(
      .parent(this),
      .size(5),
      .lsb_pos(4),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_status

// Class: hmac_reg_err_code
class hmac_reg_err_code extends dv_base_reg;
  // fields
  rand dv_base_reg_field err_code;

  `uvm_object_utils(hmac_reg_err_code)

  function new(string       name = "hmac_reg_err_code",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    err_code = dv_base_reg_field::type_id::create("err_code");
    err_code.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_err_code

// Class: hmac_reg_wipe_secret
class hmac_reg_wipe_secret extends dv_base_reg;
  // fields
  rand dv_base_reg_field secret;

  `uvm_object_utils(hmac_reg_wipe_secret)

  function new(string       name = "hmac_reg_wipe_secret",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    secret = dv_base_reg_field::type_id::create("secret");
    secret.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_wipe_secret

// Class: hmac_reg_key0
class hmac_reg_key0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key0;

  `uvm_object_utils(hmac_reg_key0)

  function new(string       name = "hmac_reg_key0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key0 = dv_base_reg_field::type_id::create("key0");
    key0.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key0

// Class: hmac_reg_key1
class hmac_reg_key1 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key1;

  `uvm_object_utils(hmac_reg_key1)

  function new(string       name = "hmac_reg_key1",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key1 = dv_base_reg_field::type_id::create("key1");
    key1.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key1

// Class: hmac_reg_key2
class hmac_reg_key2 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key2;

  `uvm_object_utils(hmac_reg_key2)

  function new(string       name = "hmac_reg_key2",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key2 = dv_base_reg_field::type_id::create("key2");
    key2.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key2

// Class: hmac_reg_key3
class hmac_reg_key3 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key3;

  `uvm_object_utils(hmac_reg_key3)

  function new(string       name = "hmac_reg_key3",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key3 = dv_base_reg_field::type_id::create("key3");
    key3.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key3

// Class: hmac_reg_key4
class hmac_reg_key4 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key4;

  `uvm_object_utils(hmac_reg_key4)

  function new(string       name = "hmac_reg_key4",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key4 = dv_base_reg_field::type_id::create("key4");
    key4.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key4

// Class: hmac_reg_key5
class hmac_reg_key5 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key5;

  `uvm_object_utils(hmac_reg_key5)

  function new(string       name = "hmac_reg_key5",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key5 = dv_base_reg_field::type_id::create("key5");
    key5.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key5

// Class: hmac_reg_key6
class hmac_reg_key6 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key6;

  `uvm_object_utils(hmac_reg_key6)

  function new(string       name = "hmac_reg_key6",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key6 = dv_base_reg_field::type_id::create("key6");
    key6.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key6

// Class: hmac_reg_key7
class hmac_reg_key7 extends dv_base_reg;
  // fields
  rand dv_base_reg_field key7;

  `uvm_object_utils(hmac_reg_key7)

  function new(string       name = "hmac_reg_key7",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    key7 = dv_base_reg_field::type_id::create("key7");
    key7.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("WO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_key7

// Class: hmac_reg_digest0
class hmac_reg_digest0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest0;

  `uvm_object_utils(hmac_reg_digest0)

  function new(string       name = "hmac_reg_digest0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest0 = dv_base_reg_field::type_id::create("digest0");
    digest0.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest0

// Class: hmac_reg_digest1
class hmac_reg_digest1 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest1;

  `uvm_object_utils(hmac_reg_digest1)

  function new(string       name = "hmac_reg_digest1",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest1 = dv_base_reg_field::type_id::create("digest1");
    digest1.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest1

// Class: hmac_reg_digest2
class hmac_reg_digest2 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest2;

  `uvm_object_utils(hmac_reg_digest2)

  function new(string       name = "hmac_reg_digest2",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest2 = dv_base_reg_field::type_id::create("digest2");
    digest2.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest2

// Class: hmac_reg_digest3
class hmac_reg_digest3 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest3;

  `uvm_object_utils(hmac_reg_digest3)

  function new(string       name = "hmac_reg_digest3",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest3 = dv_base_reg_field::type_id::create("digest3");
    digest3.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest3

// Class: hmac_reg_digest4
class hmac_reg_digest4 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest4;

  `uvm_object_utils(hmac_reg_digest4)

  function new(string       name = "hmac_reg_digest4",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest4 = dv_base_reg_field::type_id::create("digest4");
    digest4.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest4

// Class: hmac_reg_digest5
class hmac_reg_digest5 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest5;

  `uvm_object_utils(hmac_reg_digest5)

  function new(string       name = "hmac_reg_digest5",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest5 = dv_base_reg_field::type_id::create("digest5");
    digest5.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest5

// Class: hmac_reg_digest6
class hmac_reg_digest6 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest6;

  `uvm_object_utils(hmac_reg_digest6)

  function new(string       name = "hmac_reg_digest6",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest6 = dv_base_reg_field::type_id::create("digest6");
    digest6.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest6

// Class: hmac_reg_digest7
class hmac_reg_digest7 extends dv_base_reg;
  // fields
  rand dv_base_reg_field digest7;

  `uvm_object_utils(hmac_reg_digest7)

  function new(string       name = "hmac_reg_digest7",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    digest7 = dv_base_reg_field::type_id::create("digest7");
    digest7.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_digest7

// Class: hmac_reg_msg_length_lower
class hmac_reg_msg_length_lower extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(hmac_reg_msg_length_lower)

  function new(string       name = "hmac_reg_msg_length_lower",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    v = dv_base_reg_field::type_id::create("v");
    v.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_msg_length_lower

// Class: hmac_reg_msg_length_upper
class hmac_reg_msg_length_upper extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(hmac_reg_msg_length_upper)

  function new(string       name = "hmac_reg_msg_length_upper",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    v = dv_base_reg_field::type_id::create("v");
    v.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : hmac_reg_msg_length_upper

// Class: hmac_mem_msg_fifo
class hmac_mem_msg_fifo extends dv_base_mem;

  `uvm_object_utils(hmac_mem_msg_fifo)

  function new(string           name = "hmac_mem_msg_fifo",
               longint unsigned size = 512,
               int unsigned     n_bits = 32,
               string           access = "RW"/* TODO:"WO"*/,
               int              has_coverage = UVM_NO_COVERAGE);
    super.new(name, size, n_bits, access, has_coverage);
  endfunction : new

endclass : hmac_mem_msg_fifo

// Class: hmac_reg_block
class hmac_reg_block extends dv_base_reg_block;
  // registers
  rand hmac_reg_intr_state intr_state;
  rand hmac_reg_intr_enable intr_enable;
  rand hmac_reg_intr_test intr_test;
  rand hmac_reg_cfg cfg;
  rand hmac_reg_cmd cmd;
  rand hmac_reg_status status;
  rand hmac_reg_err_code err_code;
  rand hmac_reg_wipe_secret wipe_secret;
  rand hmac_reg_key0 key0;
  rand hmac_reg_key1 key1;
  rand hmac_reg_key2 key2;
  rand hmac_reg_key3 key3;
  rand hmac_reg_key4 key4;
  rand hmac_reg_key5 key5;
  rand hmac_reg_key6 key6;
  rand hmac_reg_key7 key7;
  rand hmac_reg_digest0 digest0;
  rand hmac_reg_digest1 digest1;
  rand hmac_reg_digest2 digest2;
  rand hmac_reg_digest3 digest3;
  rand hmac_reg_digest4 digest4;
  rand hmac_reg_digest5 digest5;
  rand hmac_reg_digest6 digest6;
  rand hmac_reg_digest7 digest7;
  rand hmac_reg_msg_length_lower msg_length_lower;
  rand hmac_reg_msg_length_upper msg_length_upper;
  // memories
  rand hmac_mem_msg_fifo msg_fifo;

  `uvm_object_utils(hmac_reg_block)

  function new(string name = "hmac_reg_block",
               int    has_coverage = UVM_NO_COVERAGE);
    super.new(name, has_coverage);
  endfunction : new

  virtual function void build(uvm_reg_addr_t base_addr);
    // create default map
    this.default_map = create_map(.name("default_map"),
                                  .base_addr(base_addr),
                                  .n_bytes(4),
                                  .endian(UVM_LITTLE_ENDIAN));

    // create registers
    intr_state = hmac_reg_intr_state::type_id::create("intr_state");
    intr_state.configure(.blk_parent(this));
    intr_state.build();
    default_map.add_reg(.rg(intr_state),
                        .offset(32'h0),
                        .rights("RW"));
    intr_enable = hmac_reg_intr_enable::type_id::create("intr_enable");
    intr_enable.configure(.blk_parent(this));
    intr_enable.build();
    default_map.add_reg(.rg(intr_enable),
                        .offset(32'h4),
                        .rights("RW"));
    intr_test = hmac_reg_intr_test::type_id::create("intr_test");
    intr_test.configure(.blk_parent(this));
    intr_test.build();
    default_map.add_reg(.rg(intr_test),
                        .offset(32'h8),
                        .rights("WO"));
    cfg = hmac_reg_cfg::type_id::create("cfg");
    cfg.configure(.blk_parent(this));
    cfg.build();
    default_map.add_reg(.rg(cfg),
                        .offset(32'hc),
                        .rights("RW"));
    cmd = hmac_reg_cmd::type_id::create("cmd");
    cmd.configure(.blk_parent(this));
    cmd.build();
    default_map.add_reg(.rg(cmd),
                        .offset(32'h10),
                        .rights("RW"));
    status = hmac_reg_status::type_id::create("status");
    status.configure(.blk_parent(this));
    status.build();
    default_map.add_reg(.rg(status),
                        .offset(32'h14),
                        .rights("RO"));
    err_code = hmac_reg_err_code::type_id::create("err_code");
    err_code.configure(.blk_parent(this));
    err_code.build();
    default_map.add_reg(.rg(err_code),
                        .offset(32'h18),
                        .rights("RO"));
    wipe_secret = hmac_reg_wipe_secret::type_id::create("wipe_secret");
    wipe_secret.configure(.blk_parent(this));
    wipe_secret.build();
    default_map.add_reg(.rg(wipe_secret),
                        .offset(32'h1c),
                        .rights("WO"));
    key0 = hmac_reg_key0::type_id::create("key0");
    key0.configure(.blk_parent(this));
    key0.build();
    default_map.add_reg(.rg(key0),
                        .offset(32'h20),
                        .rights("WO"));
    key1 = hmac_reg_key1::type_id::create("key1");
    key1.configure(.blk_parent(this));
    key1.build();
    default_map.add_reg(.rg(key1),
                        .offset(32'h24),
                        .rights("WO"));
    key2 = hmac_reg_key2::type_id::create("key2");
    key2.configure(.blk_parent(this));
    key2.build();
    default_map.add_reg(.rg(key2),
                        .offset(32'h28),
                        .rights("WO"));
    key3 = hmac_reg_key3::type_id::create("key3");
    key3.configure(.blk_parent(this));
    key3.build();
    default_map.add_reg(.rg(key3),
                        .offset(32'h2c),
                        .rights("WO"));
    key4 = hmac_reg_key4::type_id::create("key4");
    key4.configure(.blk_parent(this));
    key4.build();
    default_map.add_reg(.rg(key4),
                        .offset(32'h30),
                        .rights("WO"));
    key5 = hmac_reg_key5::type_id::create("key5");
    key5.configure(.blk_parent(this));
    key5.build();
    default_map.add_reg(.rg(key5),
                        .offset(32'h34),
                        .rights("WO"));
    key6 = hmac_reg_key6::type_id::create("key6");
    key6.configure(.blk_parent(this));
    key6.build();
    default_map.add_reg(.rg(key6),
                        .offset(32'h38),
                        .rights("WO"));
    key7 = hmac_reg_key7::type_id::create("key7");
    key7.configure(.blk_parent(this));
    key7.build();
    default_map.add_reg(.rg(key7),
                        .offset(32'h3c),
                        .rights("WO"));
    digest0 = hmac_reg_digest0::type_id::create("digest0");
    digest0.configure(.blk_parent(this));
    digest0.build();
    default_map.add_reg(.rg(digest0),
                        .offset(32'h40),
                        .rights("RO"));
    digest1 = hmac_reg_digest1::type_id::create("digest1");
    digest1.configure(.blk_parent(this));
    digest1.build();
    default_map.add_reg(.rg(digest1),
                        .offset(32'h44),
                        .rights("RO"));
    digest2 = hmac_reg_digest2::type_id::create("digest2");
    digest2.configure(.blk_parent(this));
    digest2.build();
    default_map.add_reg(.rg(digest2),
                        .offset(32'h48),
                        .rights("RO"));
    digest3 = hmac_reg_digest3::type_id::create("digest3");
    digest3.configure(.blk_parent(this));
    digest3.build();
    default_map.add_reg(.rg(digest3),
                        .offset(32'h4c),
                        .rights("RO"));
    digest4 = hmac_reg_digest4::type_id::create("digest4");
    digest4.configure(.blk_parent(this));
    digest4.build();
    default_map.add_reg(.rg(digest4),
                        .offset(32'h50),
                        .rights("RO"));
    digest5 = hmac_reg_digest5::type_id::create("digest5");
    digest5.configure(.blk_parent(this));
    digest5.build();
    default_map.add_reg(.rg(digest5),
                        .offset(32'h54),
                        .rights("RO"));
    digest6 = hmac_reg_digest6::type_id::create("digest6");
    digest6.configure(.blk_parent(this));
    digest6.build();
    default_map.add_reg(.rg(digest6),
                        .offset(32'h58),
                        .rights("RO"));
    digest7 = hmac_reg_digest7::type_id::create("digest7");
    digest7.configure(.blk_parent(this));
    digest7.build();
    default_map.add_reg(.rg(digest7),
                        .offset(32'h5c),
                        .rights("RO"));
    msg_length_lower = hmac_reg_msg_length_lower::type_id::create("msg_length_lower");
    msg_length_lower.configure(.blk_parent(this));
    msg_length_lower.build();
    default_map.add_reg(.rg(msg_length_lower),
                        .offset(32'h60),
                        .rights("RO"));
    msg_length_upper = hmac_reg_msg_length_upper::type_id::create("msg_length_upper");
    msg_length_upper.configure(.blk_parent(this));
    msg_length_upper.build();
    default_map.add_reg(.rg(msg_length_upper),
                        .offset(32'h64),
                        .rights("RO"));

    // create memories
    msg_fifo = hmac_mem_msg_fifo::type_id::create("msg_fifo");
    msg_fifo.configure(.parent(this));
    default_map.add_mem(.mem(msg_fifo),
                        .offset(32'h800),
                        .rights("WO"));
  endfunction : build

endclass : hmac_reg_block

`endif
