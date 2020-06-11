// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// UVM Registers auto-generated by `reggen` containing data structure
// Do Not Edit directly
<% from reggen import (gen_dv)
%>\
<%def name="construct_classes(block)">\
% for b in block.blocks:
${construct_classes(b)}
% endfor
<%
regs_flat = block.get_regs_flat()
hier_path = ""
if (block.hier_path):
  hier_path = block.hier_path + "."
%>\

// Block: ${block.name}
package ${block.name}_ral_pkg;
  // dep packages
  import uvm_pkg::*;
  import dv_base_reg_pkg::*;
% for b in block.blocks:
  import ${b.name}_ral_pkg::*;
% endfor

  // macro includes
  `include "uvm_macros.svh"

  // Forward declare all register/memory/block classes
% for r in regs_flat:
  typedef class ${gen_dv.rcname(block, r)};
% endfor
% for w in block.wins:
  typedef class ${gen_dv.mcname(block, w)};
% endfor
  typedef class ${gen_dv.bcname(block)};

% for r in regs_flat:
<%
  reg_width = block.width
  reg_name = r.name
  is_ext = 0
%>\
  // Class: ${gen_dv.rcname(block, r)}
  class ${gen_dv.rcname(block, r)} extends dv_base_reg;
    // fields
% for f in r.fields:
    rand dv_base_reg_field ${f.name};
% endfor

    `uvm_object_utils(${gen_dv.rcname(block, r)})

    function new(string       name = "${gen_dv.rcname(block, r)}",
                 int unsigned n_bits = ${reg_width},
                 int          has_coverage = UVM_NO_COVERAGE);
      super.new(name, n_bits, has_coverage);
    endfunction : new

    virtual function void build(csr_excl_item csr_excl = null);
      // create fields
% for f in r.fields:
<%
  field_size = f.msb - f.lsb + 1
  if f.swaccess.name == "R0W1C":
    field_access = "W1C"
  else:
    field_access = f.swaccess.name

  if f.hwaccess == HwAccess.HRO:
    field_volatile = 0
  else:
    field_volatile = 1
  field_tags = f.tags

  if r.hwext or (f.hwaccess == HwAccess.NONE and f.swrdaccess == SwRdAccess.RD and
                 f.swwraccess == SwWrAccess.NONE):
    is_ext = 1

  if len(r.fields) == 1:
    reg_field_name = reg_name
  else:
    reg_field_name = reg_name + "_" + f.name
%>\
      ${f.name} = dv_base_reg_field::type_id::create("${f.name}");
      ${f.name}.configure(
        .parent(this),
        .size(${field_size}),
        .lsb_pos(${f.lsb}),
        .access("${field_access}"),
        .volatile(${field_volatile}),
        .reset(${reg_width}'h${format(f.resval, 'x')}),
        .has_reset(1),
        .is_rand(1),
        .individually_accessible(1));
      ${f.name}.set_original_access("${field_access}");
  % if f.hwaccess == HwAccess.NONE and f.swrdaccess == SwRdAccess.RD and f.swwraccess == SwWrAccess.NONE:
      // constant reg
      add_hdl_path_slice("${hier_path}u_reg.${reg_field_name}_qs", ${f.lsb}, ${field_size});
  % else:
      add_hdl_path_slice("${hier_path}u_reg.u_${reg_field_name}.q${"s" if r.hwext else ""}", ${f.lsb}, ${field_size});
  % endif
  % if field_tags:
      // create field tags
    % for field_tag in field_tags:
<%
  tag = field_tag.split(":")
%>\
    % if tag[0] == "excl":
      csr_excl.add_excl(${f.name}.get_full_name(), ${tag[2]}, ${tag[1]});
      % endif
    % endfor
  % endif
% endfor

% if is_ext:
      set_is_ext_reg(1);
% endif
    endfunction : build

  endclass : ${gen_dv.rcname(block, r)}

% endfor
% for w in block.wins:
<%
  mem_name = w.name.lower()
  mem_right = w.dvrights.upper()
  mem_n_bits = w.n_bits
  mem_size = int((w.limit_addr - w.base_addr) / (mem_n_bits / 8))
%>\
  // Class: ${gen_dv.mcname(block, w)}
  class ${gen_dv.mcname(block, w)} extends dv_base_mem;

    `uvm_object_utils(${gen_dv.mcname(block, w)})

    function new(string           name = "${gen_dv.mcname(block, w)}",
                 longint unsigned size = ${mem_size},
                 int unsigned     n_bits = ${mem_n_bits},
                 string           access = "${mem_right}",
                 int              has_coverage = UVM_NO_COVERAGE);
      super.new(name, size, n_bits, access, has_coverage);
    endfunction : new

  endclass : ${gen_dv.mcname(block, w)}

% endfor
  // Class: ${gen_dv.bcname(block)}
  class ${gen_dv.bcname(block)} extends dv_base_reg_block;
% if block.blocks:
    // sub blocks
% endif
% for b in block.blocks:
    rand ${gen_dv.bcname(b)} ${b.name};
% endfor
% if regs_flat:
    // registers
% endif
% for r in regs_flat:
    rand ${gen_dv.rcname(block, r)} ${r.name};
% endfor
% if block.wins:
    // memories
% endif
% for w in block.wins:
    rand ${gen_dv.mcname(block, w)} ${gen_dv.miname(w)};
% endfor

    `uvm_object_utils(${gen_dv.bcname(block)})

    function new(string name = "${gen_dv.bcname(block)}",
                 int    has_coverage = UVM_NO_COVERAGE);
      super.new(name, has_coverage);
    endfunction : new

    virtual function void build(uvm_reg_addr_t base_addr,
                                csr_excl_item csr_excl = null);
      // create default map
      this.default_map = create_map(.name("default_map"),
                                    .base_addr(base_addr),
                                    .n_bytes(${block.width//8}),
                                    .endian(UVM_LITTLE_ENDIAN));
      if (csr_excl == null) begin
        csr_excl = csr_excl_item::type_id::create("csr_excl");
        this.csr_excl = csr_excl;
      end
% if block.blocks:

      // create sub blocks and add their maps
% endif
% for b in block.blocks:
      ${b.name} = ${gen_dv.bcname(b)}::type_id::create("${b.name}");
      ${b.name}.configure(.parent(this));
      ${b.name}.build(.base_addr(base_addr + ${gen_dv.sv_base_addr(b)}), .csr_excl(csr_excl));
      ${b.name}.set_hdl_path_root("tb.dut.top_earlgrey.u_${b.name}");
      default_map.add_submap(.child_map(${b.name}.default_map),
                             .offset(base_addr + ${gen_dv.sv_base_addr(b)}));
% endfor
% if regs_flat:
      set_hdl_path_root("tb.dut");

      // create registers
% endif
% for r in regs_flat:
<%
  reg_name = r.name
  reg_right = r.dvrights
  reg_width = block.width
  reg_offset =  str(reg_width) + "'h" + "%x" % r.offset
  reg_wen = r.regwen
  reg_tags = r.tags
%>\
      ${reg_name} = ${gen_dv.rcname(block, r)}::type_id::create("${reg_name}");
      ${reg_name}.configure(.blk_parent(this));
      ${reg_name}.build(csr_excl);
      default_map.add_reg(.rg(${reg_name}),
                          .offset(${reg_offset}),
                          .rights("${reg_right}"));
% if reg_wen:
      ${reg_wen}.add_locked_reg(${reg_name});
% endif
% if reg_tags:
      // create register tags
% for reg_tag in reg_tags:
<%
  tag = reg_tag.split(":")
%>\
% if tag[0] == "excl":
      csr_excl.add_excl(${reg_name}.get_full_name(), ${tag[2]}, ${tag[1]});
% endif
% endfor
% endif
% endfor
% if block.wins:

      // create memories
% endif
% for w in block.wins:
<%
  mem_name = w.name.lower()
  mem_right = w.dvrights.upper()
  mem_offset = str(block.width) + "'h" + "%x" % w.base_addr
  mem_n_bits = w.n_bits
  mem_size = int((w.limit_addr - w.base_addr) / (mem_n_bits / 8))
  mem_tags = w.tags
%>\
      ${mem_name} = ${gen_dv.mcname(block, w)}::type_id::create("${mem_name}");
      ${mem_name}.configure(.parent(this));
      default_map.add_mem(.mem(${mem_name}),
                          .offset(${mem_offset}),
                          .rights("${mem_right}"));
% if mem_tags:
      // create memory tags
% for mem_tag in mem_tags:
<%
  tag = mem_tag.split(":")
%>\
% if tag[0] == "excl":
      csr_excl.add_excl(${mem_name}.get_full_name(), ${tag[2]}, ${tag[1]});
% endif
% endfor
% endif
% endfor
    endfunction : build

  endclass : ${gen_dv.bcname(block)}

endpackage\
</%def>\
${construct_classes(block)}
