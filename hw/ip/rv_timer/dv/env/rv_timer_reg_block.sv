// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// UVM Registers auto-generated by `reggen` containing data structure
// Do Not Edit directly

// Block: rv_timer
`ifndef RV_TIMER_REG_BLOCK__SV
`define RV_TIMER_REG_BLOCK__SV

// Forward declare all register/memory/block classes
typedef class rv_timer_reg_ctrl;
typedef class rv_timer_reg_cfg0;
typedef class rv_timer_reg_timer_v_lower0;
typedef class rv_timer_reg_timer_v_upper0;
typedef class rv_timer_reg_compare_lower0_0;
typedef class rv_timer_reg_compare_upper0_0;
typedef class rv_timer_reg_intr_enable0;
typedef class rv_timer_reg_intr_state0;
typedef class rv_timer_reg_intr_test0;
typedef class rv_timer_reg_block;

// Class: rv_timer_reg_ctrl
class rv_timer_reg_ctrl extends dv_base_reg;
  // fields
  rand dv_base_reg_field active0;

  `uvm_object_utils(rv_timer_reg_ctrl)

  function new(string       name = "rv_timer_reg_ctrl",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    active0 = dv_base_reg_field::type_id::create("active0");
    active0.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_ctrl

// Class: rv_timer_reg_cfg0
class rv_timer_reg_cfg0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field prescale;
  rand dv_base_reg_field step;

  `uvm_object_utils(rv_timer_reg_cfg0)

  function new(string       name = "rv_timer_reg_cfg0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    prescale = dv_base_reg_field::type_id::create("prescale");
    prescale.configure(
      .parent(this),
      .size(12),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
    step = dv_base_reg_field::type_id::create("step");
    step.configure(
      .parent(this),
      .size(8),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset(32'h1),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_cfg0

// Class: rv_timer_reg_timer_v_lower0
class rv_timer_reg_timer_v_lower0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(rv_timer_reg_timer_v_lower0)

  function new(string       name = "rv_timer_reg_timer_v_lower0",
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
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_timer_v_lower0

// Class: rv_timer_reg_timer_v_upper0
class rv_timer_reg_timer_v_upper0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(rv_timer_reg_timer_v_upper0)

  function new(string       name = "rv_timer_reg_timer_v_upper0",
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
      .access("RW"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_timer_v_upper0

// Class: rv_timer_reg_compare_lower0_0
class rv_timer_reg_compare_lower0_0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(rv_timer_reg_compare_lower0_0)

  function new(string       name = "rv_timer_reg_compare_lower0_0",
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
      .access("RW"),
      .volatile(0),
      .reset(32'hffffffff),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_compare_lower0_0

// Class: rv_timer_reg_compare_upper0_0
class rv_timer_reg_compare_upper0_0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field v;

  `uvm_object_utils(rv_timer_reg_compare_upper0_0)

  function new(string       name = "rv_timer_reg_compare_upper0_0",
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
      .access("RW"),
      .volatile(0),
      .reset(32'hffffffff),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_compare_upper0_0

// Class: rv_timer_reg_intr_enable0
class rv_timer_reg_intr_enable0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field ie0;

  `uvm_object_utils(rv_timer_reg_intr_enable0)

  function new(string       name = "rv_timer_reg_intr_enable0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    ie0 = dv_base_reg_field::type_id::create("ie0");
    ie0.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_intr_enable0

// Class: rv_timer_reg_intr_state0
class rv_timer_reg_intr_state0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field is0;

  `uvm_object_utils(rv_timer_reg_intr_state0)

  function new(string       name = "rv_timer_reg_intr_state0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    is0 = dv_base_reg_field::type_id::create("is0");
    is0.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_intr_state0

// Class: rv_timer_reg_intr_test0
class rv_timer_reg_intr_test0 extends dv_base_reg;
  // fields
  rand dv_base_reg_field t0;

  `uvm_object_utils(rv_timer_reg_intr_test0)

  function new(string       name = "rv_timer_reg_intr_test0",
               int unsigned n_bits = 32,
               int          has_coverage = UVM_NO_COVERAGE);
    super.new(name, n_bits, has_coverage);
  endfunction : new

  virtual function void build();
    // create fields
    t0 = dv_base_reg_field::type_id::create("t0");
    t0.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("WO"),
      .volatile(0),
      .reset(32'h0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1));
  endfunction : build

endclass : rv_timer_reg_intr_test0

// Class: rv_timer_reg_block
class rv_timer_reg_block extends dv_base_reg_block;
  // registers
  rand rv_timer_reg_ctrl ctrl;
  rand rv_timer_reg_cfg0 cfg0;
  rand rv_timer_reg_timer_v_lower0 timer_v_lower0;
  rand rv_timer_reg_timer_v_upper0 timer_v_upper0;
  rand rv_timer_reg_compare_lower0_0 compare_lower0_0;
  rand rv_timer_reg_compare_upper0_0 compare_upper0_0;
  rand rv_timer_reg_intr_enable0 intr_enable0;
  rand rv_timer_reg_intr_state0 intr_state0;
  rand rv_timer_reg_intr_test0 intr_test0;

  `uvm_object_utils(rv_timer_reg_block)

  function new(string name = "rv_timer_reg_block",
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
    ctrl = rv_timer_reg_ctrl::type_id::create("ctrl");
    ctrl.configure(.blk_parent(this));
    ctrl.build();
    default_map.add_reg(.rg(ctrl),
                        .offset(32'h0),
                        .rights("RW"));
    cfg0 = rv_timer_reg_cfg0::type_id::create("cfg0");
    cfg0.configure(.blk_parent(this));
    cfg0.build();
    default_map.add_reg(.rg(cfg0),
                        .offset(32'h100),
                        .rights("RW"));
    timer_v_lower0 = rv_timer_reg_timer_v_lower0::type_id::create("timer_v_lower0");
    timer_v_lower0.configure(.blk_parent(this));
    timer_v_lower0.build();
    default_map.add_reg(.rg(timer_v_lower0),
                        .offset(32'h104),
                        .rights("RW"));
    timer_v_upper0 = rv_timer_reg_timer_v_upper0::type_id::create("timer_v_upper0");
    timer_v_upper0.configure(.blk_parent(this));
    timer_v_upper0.build();
    default_map.add_reg(.rg(timer_v_upper0),
                        .offset(32'h108),
                        .rights("RW"));
    compare_lower0_0 = rv_timer_reg_compare_lower0_0::type_id::create("compare_lower0_0");
    compare_lower0_0.configure(.blk_parent(this));
    compare_lower0_0.build();
    default_map.add_reg(.rg(compare_lower0_0),
                        .offset(32'h10c),
                        .rights("RW"));
    compare_upper0_0 = rv_timer_reg_compare_upper0_0::type_id::create("compare_upper0_0");
    compare_upper0_0.configure(.blk_parent(this));
    compare_upper0_0.build();
    default_map.add_reg(.rg(compare_upper0_0),
                        .offset(32'h110),
                        .rights("RW"));
    intr_enable0 = rv_timer_reg_intr_enable0::type_id::create("intr_enable0");
    intr_enable0.configure(.blk_parent(this));
    intr_enable0.build();
    default_map.add_reg(.rg(intr_enable0),
                        .offset(32'h114),
                        .rights("RW"));
    intr_state0 = rv_timer_reg_intr_state0::type_id::create("intr_state0");
    intr_state0.configure(.blk_parent(this));
    intr_state0.build();
    default_map.add_reg(.rg(intr_state0),
                        .offset(32'h118),
                        .rights("RW"));
    intr_test0 = rv_timer_reg_intr_test0::type_id::create("intr_test0");
    intr_test0.configure(.blk_parent(this));
    intr_test0.build();
    default_map.add_reg(.rg(intr_test0),
                        .offset(32'h11c),
                        .rights("WO"));
  endfunction : build

endclass : rv_timer_reg_block

`endif
