// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// UVM registers auto-generated by `reggen` containing UVM definitions for the entire top-level
<%!
  from reggen import gen_dv
%>
##
## This template is used for chip-wide tests. It expects to be run with the
## following arguments
##
##    top              a Top object
##
##    dv_base_prefix   a string for the base register type. If it is FOO, then
##                     we will inherit from FOO_reg (assumed to be a subclass
##                     of uvm_reg).
##
## Like uvm_reg.sv.tpl, we use functions from uvm_reg_base.sv.tpl to define
## per-device-interface code.
##
<%namespace file="uvm_reg_base.sv.tpl" import="*"/>\
##
##
## Waive the package-filename check: we're going to be defining all sorts of
## packages in a single file.

// verilog_lint: waive-start package-filename
##
## Iterate over the device interfaces of blocks in Top, constructing a package
## for each.
% for block in top.blocks.values():
%   for if_name, rb in block.reg_blocks.items():
<%
      if_suffix = '' if if_name is None else '_' + if_name
      esc_if_name = block.name.lower() + if_suffix
      if_desc = '' if if_name is None else '; interface {}'.format(if_name)
      reg_block_path = 'u_reg' + if_suffix
      reg_block_path = reg_block_path if block.hier_path is None else block.hier_path + "." + reg_block_path
%>\
// Block: ${block.name.lower()}${if_desc}
${make_ral_pkg(dv_base_prefix, top.regwidth, reg_block_path, rb, esc_if_name)}
%   endfor
% endfor
##
##
## Now that we've made the block-level packages, re-instate the
## package-filename check. The only package left is chip_ral_pkg, which should
## match the generated filename.

// verilog_lint: waive-start package-filename

// Block: chip
package chip_ral_pkg;
<%
  if_packages = []
  for block in top.blocks.values():
    for if_name in block.reg_blocks:
      if_suffix = '' if if_name is None else '_' + if_name
      if_packages.append('{}{}_ral_pkg'.format(block.name.lower(), if_suffix))

  windows = top.window_block.windows
%>\
${make_ral_pkg_hdr(dv_base_prefix, if_packages)}
${make_ral_pkg_fwd_decls('chip', [], windows)}
% for window in windows:

${make_ral_pkg_window_class(dv_base_prefix, 'chip', window)}
% endfor

  class chip_reg_block extends ${dv_base_prefix}_reg_block;
    // sub blocks
% for block in top.blocks.values():
%   for inst_name in top.block_instances[block.name.lower()]:
%     for if_name, rb in block.reg_blocks.items():
<%
        if_suffix = '' if if_name is None else '_' + if_name
        esc_if_name = block.name.lower() + if_suffix
        if_inst = inst_name + if_suffix
%>\
    rand ${gen_dv.bcname(esc_if_name)} ${if_inst};
%     endfor
%   endfor
% endfor
% if windows:
    // memories
%   for window in windows:
    rand ${gen_dv.mcname('chip', window)} ${gen_dv.miname(window)};
%   endfor
% endif

    `uvm_object_utils(chip_reg_block)

    function new(string name = "chip_reg_block",
                 int    has_coverage = UVM_NO_COVERAGE);
      super.new(name, has_coverage);
    endfunction : new

    virtual function void build(uvm_reg_addr_t base_addr,
                                csr_excl_item csr_excl = null);
      // create default map
      this.default_map = create_map(.name("default_map"),
                                    .base_addr(base_addr),
                                    .n_bytes(${top.regwidth//8}),
                                    .endian(UVM_LITTLE_ENDIAN));
      if (csr_excl == null) begin
        csr_excl = csr_excl_item::type_id::create("csr_excl");
        this.csr_excl = csr_excl;
      end

      // create sub blocks and add their maps
% for block in top.blocks.values():
%   for inst_name in top.block_instances[block.name.lower()]:
%     for if_name, rb in block.reg_blocks.items():
<%
        if_suffix = '' if if_name is None else '_' + if_name
        esc_if_name = block.name.lower() + if_suffix
        if_inst = inst_name + if_suffix

        if top.attrs.get(inst_name) == 'reggen_only':
          hdl_path = 'tb.dut.u_' + inst_name
        else:
          hdl_path = 'tb.dut.top_earlgrey.u_' + inst_name
        qual_if_name = (inst_name, if_name)
        base_addr = top.if_addrs[qual_if_name]
        sv_base_addr = gen_dv.sv_base_addr(top, qual_if_name)
%>\
      ${if_inst} = ${gen_dv.bcname(esc_if_name)}::type_id::create("${if_inst}");
      ${if_inst}.configure(.parent(this));
      ${if_inst}.build(.base_addr(base_addr + ${sv_base_addr}), .csr_excl(csr_excl));
      ${if_inst}.set_hdl_path_root("${hdl_path}", "BkdrRegPathRtl");
      ${if_inst}.set_hdl_path_root("${hdl_path}", "BkdrRegPathRtlCommitted");
      ${if_inst}.set_hdl_path_root("${hdl_path}", "BkdrRegPathRtlShadow");
      default_map.add_submap(.child_map(${if_inst}.default_map),
                             .offset(base_addr + ${sv_base_addr}));
%     endfor
%   endfor
% endfor
${make_ral_pkg_window_instances(top.regwidth, 'chip', top.window_block)}

    endfunction : build
  endclass : chip_reg_block

endpackage
