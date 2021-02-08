// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

<%
  from topgen import lib # TODO: Split lib to common lib module
  from reggen.register import Register
  from reggen.multi_register import MultiRegister

  num_regs = block.get_n_regs_flat()
  max_regs_char = len("{}".format(num_regs-1))
%>\
package ${block.name}_reg_pkg;
% if len(block.params) != 0:

  // Param list
% endif
% for param in [p for p in block.params if p["local"] == "true"]:
  parameter ${param["type"]} ${param["name"]} = ${param["default"]};
% endfor

  // Address width within the block
  parameter int BlockAw = ${block.addr_width};

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
% for r in block.regs:
  % if r.get_n_bits(["q"]):
<%
    if isinstance(r, Register):
      r0 = r
      type_suff = 'reg_t'
    else:
      assert isinstance(r, MultiRegister)
      r0 = r.reg
      type_suff = 'mreg_t'

    reg2hw_name = ('{}_reg2hw_{}_{}'
                   .format(block.name, r0.name.lower(), type_suff))
%>\
  typedef struct packed {
    % if r.is_homogeneous():
      ## If we have a homogeneous register or multireg, there is just one field
      ## (possibly replicated many times). The typedef is for one copy of that
      ## field.
<%
      field = r.get_field_list()[0]
      field_q_width = field.get_n_bits(r0.hwext, ['q'])
      field_q_bits = lib.bitarray(field_q_width, 2)
%>\
    logic ${field_q_bits} q;
      % if field.hwqe:
    logic        qe;
      % endif
      % if field.hwre or (r0.shadowed and r0.hwext):
    logic        re;
      % endif
      % if r0.shadowed and not r0.hwext:
    logic        err_update;
    logic        err_storage;
      % endif
    % else:
      ## We are inhomogeneous, which means there is more than one different
      ## field. Generate a reg2hw typedef that packs together all the fields of
      ## the register.
      % for f in r0.fields:
        % if f.get_n_bits(r0.hwext, ["q"]) >= 1:
<%
          field_q_width = f.get_n_bits(r0.hwext, ['q'])
          field_q_bits = lib.bitarray(field_q_width, 2)

          struct_name = f.name.lower()
%>\
    struct packed {
      logic ${field_q_bits} q;
          % if f.hwqe:
      logic        qe;
          % endif
          % if f.hwre or (r0.shadowed and r0.hwext):
      logic        re;
          % endif
          % if r0.shadowed and not r0.hwext:
      logic        err_update;
      logic        err_storage;
          % endif
    } ${struct_name};
        %endif
      %endfor
    %endif
  } ${reg2hw_name};

  %endif
% endfor

% for r in block.regs:
  % if r.get_n_bits(["d"]):
<%
    if isinstance(r, Register):
      r0 = r
      type_suff = 'reg_t'
    else:
      assert isinstance(r, MultiRegister)
      r0 = r.reg
      type_suff = 'mreg_t'

    hw2reg_name = ('{}_hw2reg_{}_{}'
                   .format(block.name, r0.name.lower(), type_suff))
%>\
  typedef struct packed {
    % if r.is_homogeneous():
      ## If we have a homogeneous register or multireg, there is just one field
      ## (possibly replicated many times). The typedef is for one copy of that
      ## field.
<%
      field = r.get_field_list()[0]
      field_d_width = field.get_n_bits(r0.hwext, ['d'])
      field_d_bits = lib.bitarray(field_d_width, 2)
%>\
    logic ${field_d_bits} d;
      % if not r0.hwext:
    logic        de;
      % endif
    % else:
      ## We are inhomogeneous, which means there is more than one different
      ## field. Generate a hw2reg typedef that packs together all the fields of
      ## the register.
      % for f in r0.fields:
        % if f.get_n_bits(r0.hwext, ["d"]) >= 1:
<%
          field_d_width = f.get_n_bits(r0.hwext, ['d'])
          field_d_bits = lib.bitarray(field_d_width, 2)

          struct_name = f.name.lower()
%>\
    struct packed {
      logic ${field_d_bits} d;
          % if not r0.hwext:
      logic        de;
          % endif
    } ${struct_name};
        %endif
      %endfor
    %endif
  } ${hw2reg_name};

  % endif
% endfor

  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
<%
nbits = block.get_n_bits(["q", "qe", "re"])
packbit = 0
%>\
% if nbits > 0:
  typedef struct packed {
% for r in block.regs:
  % if r.get_n_bits(["q"]):
<%
    if isinstance(r, MultiRegister):
      r0 = r.reg
      repl_count = r.count
      type_suff = 'mreg_t [{}:0]'.format(repl_count - 1)
    else:
      r0 = r
      repl_count = 1
      type_suff = 'reg_t'

    struct_type = ('{}_reg2hw_{}_{}'
                   .format(block.name, r0.name.lower(), type_suff))

    struct_width = r0.get_n_bits(['q', 'qe', 're']) * repl_count
    msb = nbits - packbit - 1
    lsb = msb - struct_width + 1
    packbit += struct_width
%>\
    ${struct_type} ${r0.name.lower()}; // [${msb}:${lsb}]
  % endif
% endfor
  } ${block.name}_reg2hw_t;
% endif

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
<%
nbits = block.get_n_bits(["d", "de"])
packbit = 0
%>\
% if nbits > 0:
  typedef struct packed {
% for r in block.regs:
  % if r.get_n_bits(["d"]):
<%
    if isinstance(r, MultiRegister):
      r0 = r.reg
      repl_count = r.count
      type_suff = 'mreg_t [{}:0]'.format(repl_count - 1)
    else:
      r0 = r
      repl_count = 1
      type_suff = 'reg_t'

    struct_type = ('{}_hw2reg_{}_{}'
                   .format(block.name, r0.name.lower(), type_suff))

    struct_width = r0.get_n_bits(['d', 'de']) * repl_count
    msb = nbits - packbit - 1
    lsb = msb - struct_width + 1
    packbit += struct_width
%>\
    ${struct_type} ${r0.name.lower()}; // [${msb}:${lsb}]
  % endif
% endfor
  } ${block.name}_hw2reg_t;
% endif

  // Register Address
<%
ublock = block.name.upper()
%>\
% for r in block.get_regs_flat():
  parameter logic [BlockAw-1:0] ${ublock}_${r.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % r.offset};
% endfor

% if len(block.wins) > 0:
  // Window parameter
% endif
% for i,w in enumerate(block.wins):
  parameter logic [BlockAw-1:0] ${ublock}_${w.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % w.base_addr};
  parameter logic [BlockAw-1:0] ${ublock}_${w.name.upper()}_SIZE   = ${block.addr_width}'h ${"%x" % (w.limit_addr - w.base_addr)};
% endfor

  // Register Index
  typedef enum int {
% for r in block.get_regs_flat():
    ${ublock}_${r.name.upper()}${"" if loop.last else ","}
% endfor
  } ${block.name}_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] ${ublock}_PERMIT [${block.get_n_regs_flat()}] = '{
% for i,r in enumerate(block.get_regs_flat()):
<%
  index_str = "{}".format(i).rjust(max_regs_char)
  width = r.get_width()
%>\
  % if width > 24:
    4'b 1111${" " if i == num_regs-1 else ","} // index[${index_str}] ${ublock}_${r.name.upper()}
  % elif width > 16:
    4'b 0111${" " if i == num_regs-1 else ","} // index[${index_str}] ${ublock}_${r.name.upper()}
  % elif width > 8:
    4'b 0011${" " if i == num_regs-1 else ","} // index[${index_str}] ${ublock}_${r.name.upper()}
  % else:
    4'b 0001${" " if i == num_regs-1 else ","} // index[${index_str}] ${ublock}_${r.name.upper()}
  % endif
% endfor
  };
endpackage

