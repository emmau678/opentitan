// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

<%
  from topgen import lib # TODO: Split lib to common lib module
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

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////
% for r in block.regs:
  ## in this case we have a homogeneous multireg, with only one replicated field
  % if r.get_n_bits(["q"]) and r.ishomog:
  typedef struct packed {
    logic ${lib.bitarray(r.get_field_flat(0).get_n_bits(["q"]),2)} q;
    % if r.get_field_flat(0).hwqe:
    logic        qe;
    % endif
    % if r.get_field_flat(0).hwre:
    logic        re;
    % endif
  } ${block.name + "_reg2hw_" + r.name + ("_mreg_t" if r.is_multi_reg() else "_reg_t")};

  ## in this case we have an inhomogeneous multireg, with several different fields per register
  % elif r.get_n_bits(["q"]) and not r.ishomog:
  typedef struct packed {
    % for f in r.get_reg_flat(0).fields:
      % if f.get_n_bits(["q"]) >= 1:
    struct packed {
      logic ${lib.bitarray(f.get_n_bits(["q"]),2)} q;
      % if f.hwqe:
      logic        qe;
      % endif
      % if f.hwre:
      logic        re;
      % endif
    } ${f.get_basename() if r.is_multi_reg() else f.name};
      %endif
    %endfor
  } ${block.name + "_reg2hw_" + r.name + ("_mreg_t" if r.is_multi_reg() else "_reg_t")};

  %endif
% endfor

% for r in block.regs:
 ## in this case we have a homogeneous multireg, with only one replicated field
  % if r.get_n_bits(["d"]) and r.ishomog:
  typedef struct packed {
    logic ${lib.bitarray(r.get_field_flat(0).get_n_bits(["d"]),2)} d;
    % if not r.get_reg_flat(0).hwext:
    logic        de;
    % endif
  } ${block.name + "_hw2reg_" + r.name + ("_mreg_t" if r.is_multi_reg() else "_reg_t")};

  ## in this case we have an inhomogeneous multireg, with several different fields per register
  % elif r.get_n_bits(["d"]) and not r.ishomog:
  typedef struct packed {
    % for f in r.get_reg_flat(0).fields:
      % if f.get_n_bits(["d"]) >= 1:
    struct packed {
      logic ${lib.bitarray(f.get_n_bits(["d"]),2)} d;
      % if not r.hwext:
      logic        de;
      % endif
    } ${f.get_basename() if r.is_multi_reg() else f.name};
      %endif
    %endfor
  } ${block.name + "_hw2reg_" + r.name + ("_mreg_t" if r.is_multi_reg() else "_reg_t")};

  % endif
% endfor

  ///////////////////////////////////////
  // Register to internal design logic //
  ///////////////////////////////////////
<%
nbits = block.get_n_bits(["q","qe","re"]) - 1
packbit = 0
%>\
% if nbits > 0:
  typedef struct packed {
% for r in block.regs:
  ######################## multiregister ###########################
  % if r.is_multi_reg() and r.get_n_bits(["q"]):
<%
  array_dims = ""
  for d in r.get_nested_dims():
    array_dims += "[%d:0]" % (d-1)
%>\
    ${block.name + "_reg2hw_" + r.name + "_mreg_t"} ${array_dims} ${r.name}; // [${nbits - packbit}:${nbits - (packbit + r.get_n_bits(["q", "qe", "re"]) - 1)}]<% packbit += r.get_n_bits(["q", "qe", "re"]) %>\

  ######################## register ###########################
  % elif r.get_n_bits(["q"]):
    ## Only one field, should use register name as it is
    ${block.name + "_reg2hw_" + r.name + "_reg_t"} ${r.name}; // [${nbits - packbit}:${nbits - (packbit + r.get_n_bits(["q", "qe", "re"]) - 1)}]<% packbit += r.get_n_bits(["q", "qe", "re"]) %>\

  % endif
% endfor
  } ${block.name}_reg2hw_t;
% endif

  ///////////////////////////////////////
  // Internal design logic to register //
  ///////////////////////////////////////
<%
nbits = block.get_n_bits(["d","de"]) - 1
packbit = 0
%>\
% if nbits > 0:
  typedef struct packed {
% for r in block.regs:
  ######################## multiregister ###########################
  % if r.is_multi_reg() and r.get_n_bits(["d"]):
<%
  array_dims = ""
  for d in r.get_nested_dims():
    array_dims += "[%d:0]" % (d-1)
%>\
    ${block.name + "_hw2reg_" + r.name + "_mreg_t"} ${array_dims} ${r.name}; // [${nbits - packbit}:${nbits - (packbit + r.get_n_bits(["d", "de"]) - 1)}]<% packbit += r.get_n_bits(["d", "de"]) %>\

  ######################## register with single field ###########################
  % elif r.get_n_bits(["d"]):
    ## Only one field, should use register name as it is
    ${block.name + "_hw2reg_" + r.name + "_reg_t"} ${r.name}; // [${nbits - packbit}:${nbits - (packbit + r.get_n_bits(["q", "qe", "re"]) - 1)}]<% packbit += r.get_n_bits(["q", "qe", "re"]) %>\

  % endif
% endfor
  } ${block.name}_hw2reg_t;
% endif

  // Register Address
% for r in block.get_regs_flat():
  parameter logic [${block.addr_width-1}:0] ${block.name.upper()}_${r.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % r.offset};
% endfor

% if len(block.wins) > 0:
  // Window parameter
% endif
% for i,w in enumerate(block.wins):
  parameter logic [${block.addr_width-1}:0] ${block.name.upper()}_${w.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % w.base_addr};
  parameter logic [${block.addr_width-1}:0] ${block.name.upper()}_${w.name.upper()}_SIZE   = ${block.addr_width}'h ${"%x" % (w.limit_addr - w.base_addr)};
% endfor

  // Register Index
  typedef enum int {
% for r in block.get_regs_flat():
    ${block.name.upper()}_${r.name.upper()}${"" if loop.last else ","}
% endfor
  } ${block.name}_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] ${block.name.upper()}_PERMIT [${block.get_n_regs_flat()}] = '{
% for i,r in enumerate(block.get_regs_flat()):
<% index_str = "{}".format(i).rjust(max_regs_char) %>\
  % if r.width > 24:
    4'b 1111${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % elif r.width > 16:
    4'b 0111${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % elif r.width > 8:
    4'b 0011${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % else:
    4'b 0001${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % endif
% endfor
  };
endpackage

