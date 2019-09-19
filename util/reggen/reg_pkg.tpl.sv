// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

<%
  num_regs = len(block.regs)
  max_regs_char = len("{}".format(num_regs-1))
%>\
package ${block.name}_reg_pkg;

// Register to internal design logic
typedef struct packed {
<%
# directly mirrors below (avoided optimizations to ensure a match)
# have to do as a python block to avoid inserting blank lines
# compute number of bits because packed structs are declared msb first
packbit = 0
for r in block.regs:
  if len(r.fields) == 1 and r.fields[0].hwaccess in [HwAccess.HRW, HwAccess.HRO]:
    packbit += 1 + r.fields[0].msb - r.fields[0].lsb
    if r.fields[0].hwqe:
      packbit += 1
    if r.fields[0].hwre:
      packbit += 1
  elif len(r.fields) >= 2 and len([f for f in r.fields if f.hwaccess in [HwAccess.HRW, HwAccess.HRO]]):
    for f in r.fields:
      if f.hwaccess in [HwAccess.HRW, HwAccess.HRO]:
        if f.msb != f.lsb:
          packbit += 1 + f.msb - f.lsb
        else:
          packbit += 1
        if r.hwqe:
          packbit += 1
        if r.fields[0].hwre:
          packbit += 1
nbits = packbit - 1
packbit = 0
%>
% for r in block.regs:
  % if len(r.fields) == 1 and r.fields[0].hwaccess in [HwAccess.HRW, HwAccess.HRO]:
    ## Only one field, should use register name as it is
  struct packed {
    logic [${r.fields[0].msb - r.fields[0].lsb}:0] q; // [${nbits - packbit}:${nbits - (packbit + r.fields[0].msb - r.fields[0].lsb)}]<% packbit += 1 + r.fields[0].msb - r.fields[0].lsb %>
    % if r.fields[0].hwqe:
    logic qe; // [${nbits - packbit}]<% packbit += 1 %>
    % endif
    % if r.fields[0].hwre:
    logic re; // [${nbits - packbit}]<% packbit += 1 %>
    % endif
  } ${r.name};
  % elif len(r.fields) >= 2 and len([f for f in r.fields if f.hwaccess in [HwAccess.HRW, HwAccess.HRO]]):
  struct packed {
    % for f in r.fields:
      % if f.hwaccess in [HwAccess.HRW, HwAccess.HRO]:
    struct packed {
      ## reg2hw signal based on HW type and virtual?
      % if f.msb != f.lsb:
      logic [${f.msb - f.lsb}:0] q; // [${nbits - packbit}:${nbits - (packbit + f.msb - f.lsb)}]<% packbit += 1 + f.msb - f.lsb %>
      % else:
      logic q; // [${nbits - packbit}]<% packbit += 1 %>
      % endif
      % if f.hwqe:
      logic qe; // [${nbits - packbit}]<% packbit += 1 %>
      % endif
      % if r.fields[0].hwre:
      logic re; // [${nbits - packbit}]<% packbit += 1 %>
      % endif
    } ${f.name};
      % endif
    % endfor
  } ${r.name};
  % endif
% endfor
} ${block.name}_reg2hw_t;

// Internal design logic to register
typedef struct packed {
<%
packbit = 0
for r in block.regs:
  if len(r.fields) == 1 and r.fields[0].hwaccess in [HwAccess.HRW, HwAccess.HWO]:
    packbit += 1 + r.fields[0].msb - r.fields[0].lsb
    if r.hwext == 0:
      packbit += 1
  elif len(r.fields) >= 2 and len([f for f in r.fields if f.hwaccess in [HwAccess.HRW, HwAccess.HWO]]):
    for f in r.fields:
      if f.hwaccess in [HwAccess.HRW, HwAccess.HWO]:
        if f.msb != f.lsb:
          packbit += 1 + f.msb - f.lsb
        else:
          packbit += 1
        if r.hwext == 0:
          packbit += 1
nbits = packbit - 1
packbit = 0
%>
% for r in block.regs:
  % if len(r.fields) == 1 and r.fields[0].hwaccess in [HwAccess.HRW, HwAccess.HWO]:
    ## Only one field, should use register name as it is
  struct packed {
    logic [${r.fields[0].msb - r.fields[0].lsb}:0] d; // [${nbits - packbit}:${nbits - (packbit + r.fields[0].msb - r.fields[0].lsb)}]<% packbit += 1 + r.fields[0].msb - r.fields[0].lsb %>
    % if r.hwext == 0:
    logic de; // [${nbits - packbit}]<% packbit += 1 %>
    % endif
  } ${r.name};
  % elif len(r.fields) >= 2 and len([f for f in r.fields if f.hwaccess in [HwAccess.HRW, HwAccess.HWO]]):
  struct packed {
    % for f in r.fields:
      % if f.hwaccess in [HwAccess.HRW, HwAccess.HWO]:
    struct packed {
      % if f.msb != f.lsb:
      logic [${f.msb - f.lsb}:0] d; // [${nbits - packbit}:${nbits - (packbit + f.msb - f.lsb)}]<% packbit += 1 + f.msb - f.lsb %>
      % else:
      logic d;  // [${nbits - packbit}]<% packbit += 1 %>
      % endif
      % if r.hwext == 0:
      logic de; // [${nbits - packbit}]<% packbit += 1 %>
      % endif
    } ${f.name};
      % endif
    % endfor
  } ${r.name};
  % endif
% endfor
} ${block.name}_hw2reg_t;

  // Register Address
% for r in block.regs:
  parameter ${block.name.upper()}_${r.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % r.offset};
% endfor

% if len(block.wins) > 0:
  // Window parameter
% endif
% for i,w in enumerate(block.wins):
  parameter ${block.name.upper()}_${w.name.upper()}_OFFSET = ${block.addr_width}'h ${"%x" % w.base_addr};
  parameter ${block.name.upper()}_${w.name.upper()}_SIZE   = ${block.addr_width}'h ${"%x" % (w.limit_addr - w.base_addr)};
% endfor

  // Register Index
  typedef enum int {
% for r in block.regs:
    ${block.name.upper()}_${r.name.upper()}${"" if loop.last else ","}
% endfor
  } ${block.name}_id_e;

  // Register width information to check illegal writes
  localparam logic [3:0] ${block.name.upper()}_PERMIT [${len(block.regs)}] = '{
% for i,r in enumerate(block.regs):
<% index_str = "{}".format(i).rjust(max_regs_char) %>\
  % if r.width > 16:
    4'b 1111${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % elif r.width > 8:
    4'b 0011${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % else:
    4'b 0001${" " if i == num_regs-1 else ","} // index[${index_str}] ${block.name.upper()}_${r.name.upper()}
  % endif
% endfor
  };
endpackage

