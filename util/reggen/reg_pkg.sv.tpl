// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure
<%
  from topgen import lib # TODO: Split lib to common lib module

  from reggen.access import HwAccess, SwRdAccess, SwWrAccess
  from reggen.register import Register
  from reggen.multi_register import MultiRegister

  from reggen import gen_rtl

  localparams = block.params.get_localparams()

  addr_widths = gen_rtl.get_addr_widths(block)

  lblock = block.name.lower()
  ublock = lblock.upper()

  def reg_pfx(reg):
    return '{}_{}'.format(ublock, reg.name.upper())

  def reg_resname(reg):
    return '{}_RESVAL'.format(reg_pfx(reg))

  def field_resname(reg, field):
    return '{}_{}_RESVAL'.format(reg_pfx(reg), field.name.upper())

%>\
<%def name="typedefs_for_iface(iface_name, iface_desc, for_iface, rb)">\
<%
   hdr = gen_rtl.make_box_quote('Typedefs for registers' + for_iface)
%>\
% for r in rb.all_regs:
  % if r.get_n_bits(["q"]):
    % if hdr:

${hdr}
    % endif
<%
    r0 = gen_rtl.get_r0(r)
    hdr = None
%>\

  typedef struct packed {
    % if r.is_homogeneous():
      ## If we have a homogeneous register or multireg, there is just one field
      ## (possibly replicated many times). The typedef is for one copy of that
      ## field.
<%
      field = r.get_field_list()[0]
      field_q_width = field.get_n_bits(r0.hwext, r0.hwre, ['q'])
      field_q_bits = lib.bitarray(field_q_width, 2)
%>\
    logic ${field_q_bits} q;
      % if field.hwqe:
    logic        qe;
      % endif
      % if r0.hwre or (r0.shadowed and r0.hwext):
    logic        re;
      % endif
    % else:
      ## We are inhomogeneous, which means there is more than one different
      ## field. Generate a reg2hw typedef that packs together all the fields of
      ## the register.
      % for f in r0.fields:
<%
          field_q_width = f.get_n_bits(r0.hwext, r0.hwre, ["q"])
%>\
        % if field_q_width:
<%
            field_q_bits = lib.bitarray(field_q_width, 2)
            struct_name = f.name.lower()
%>\
    struct packed {
      logic ${field_q_bits} q;
          % if f.hwqe:
      logic        qe;
          % endif
          % if r0.hwre or (r0.shadowed and r0.hwext):
      logic        re;
          % endif
    } ${struct_name};
        %endif
      %endfor
    %endif
  } ${gen_rtl.get_reg_tx_type(block, r, False)};
  %endif
% endfor
% for r in rb.all_regs:
  % if r.get_n_bits(["d"]):
    % if hdr:

${hdr}
    % endif
<%
    r0 = gen_rtl.get_r0(r)
    hdr = None
%>\

  typedef struct packed {
    % if r.is_homogeneous():
      ## If we have a homogeneous register or multireg, there is just one field
      ## (possibly replicated many times). The typedef is for one copy of that
      ## field.
<%
      field = r.get_field_list()[0]
      field_d_width = field.get_n_bits(r0.hwext, r0.hwre, ['d'])
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
<%
          field_d_width = f.get_n_bits(r0.hwext, r0.hwre, ["d"])
%>\
        % if field_d_width:
<%
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
  } ${gen_rtl.get_reg_tx_type(block, r, True)};
  % endif
% endfor
% if block.expose_reg_if:
<%
    lpfx = gen_rtl.get_type_name_pfx(block, iface_name)
    addr_width = rb.get_addr_width()
    data_width = block.regwidth
    data_byte_width = data_width // 8

    # This will produce strings like "[0:0] " to let us keep
    # everything lined up whether there's 1 or 2 digits in the MSB.
    aw_bits = f'[{addr_width-1}:0]'.ljust(6)
    dw_bits = f'[{data_width-1}:0]'.ljust(6)
    dbw_bits = f'[{data_byte_width-1}:0]'.ljust(6)
%>\

  typedef struct packed {
    logic        reg_we;
    logic        reg_re;
    logic ${aw_bits} reg_addr;
    logic ${dw_bits} reg_wdata;
    logic ${dbw_bits} reg_be;
  } ${lpfx}_reg2hw_reg_if_t;
% endif
</%def>\
<%def name="reg2hw_for_iface(iface_name, iface_desc, for_iface, rb)">\
<%
lpfx = gen_rtl.get_type_name_pfx(block, iface_name)
nbits = rb.get_n_bits(["q", "qe", "re"])
packbit = 0

addr_width = rb.get_addr_width()
data_width = block.regwidth
data_byte_width = data_width // 8
reg_if_width = 2 + addr_width + data_width + data_byte_width
%>\
% if nbits > 0:

  // Register -> HW type${for_iface}
  typedef struct packed {
% if block.expose_reg_if:
    ${lpfx}_reg2hw_reg_if_t reg_if; // [${reg_if_width + nbits - 1}:${nbits}]
% endif
% for r in rb.all_regs:
  % if r.get_n_bits(["q"]):
<%
    r0 = gen_rtl.get_r0(r)
    struct_type = gen_rtl.get_reg_tx_type(block, r, False)
    struct_width = r0.get_n_bits(['q', 'qe', 're'])

    if isinstance(r, MultiRegister):
      struct_type += " [{}:0]".format(r.count - 1)
      struct_width *= r.count

    msb = nbits - packbit - 1
    lsb = msb - struct_width + 1
    packbit += struct_width
    name_and_comment = f'{r0.name.lower()}; // [{msb}:{lsb}]'
%>\
  % if 4 + len(struct_type) + 1 + len(name_and_comment) <= 100:
    ${struct_type} ${name_and_comment}
  % else:
    ${struct_type}
        ${name_and_comment}
  % endif
  % endif
% endfor
  } ${gen_rtl.get_iface_tx_type(block, iface_name, False)};
% endif
</%def>\
<%def name="hw2reg_for_iface(iface_name, iface_desc, for_iface, rb)">\
<%
nbits = rb.get_n_bits(["d", "de"])
packbit = 0
%>\
% if nbits > 0:

  // HW -> register type${for_iface}
  typedef struct packed {
% for r in rb.all_regs:
  % if r.get_n_bits(["d"]):
<%
    r0 = gen_rtl.get_r0(r)
    struct_type = gen_rtl.get_reg_tx_type(block, r, True)
    struct_width = r0.get_n_bits(['d', 'de'])

    if isinstance(r, MultiRegister):
      struct_type += " [{}:0]".format(r.count - 1)
      struct_width *= r.count

    msb = nbits - packbit - 1
    lsb = msb - struct_width + 1
    packbit += struct_width
    name_and_comment = f'{r0.name.lower()}; // [{msb}:{lsb}]'
%>\
  % if 4 + len(struct_type) + 1 + len(name_and_comment) <= 100:
    ${struct_type} ${name_and_comment}
  % else:
    ${struct_type}
        ${name_and_comment}
  % endif
  % endif
% endfor
  } ${gen_rtl.get_iface_tx_type(block, iface_name, True)};
% endif
</%def>\
<%def name="offsets_for_iface(iface_name, iface_desc, for_iface, rb)">\
% if not rb.flat_regs:
<% return STOP_RENDERING %>
% endif

  // Register offsets${for_iface}
<%
aw_name, aw = addr_widths[iface_name]
%>\
% for r in rb.flat_regs:
<%
value = "{}'h {:x}".format(aw, r.offset)
%>\
  parameter logic [${aw_name}-1:0] ${reg_pfx(r)}_OFFSET = ${value};
% endfor
</%def>\
<%def name="hwext_resvals_for_iface(iface_name, iface_desc, for_iface, rb)">\
<%
  hwext_regs = [r for r in rb.flat_regs if r.hwext]
%>\
% if hwext_regs:

  // Reset values for hwext registers and their fields${for_iface}
  % for reg in hwext_regs:
<%
    reg_width = reg.get_width()
    reg_msb = reg_width - 1
    reg_resval = "{}'h {:x}".format(reg_width, reg.resval)
%>\
  parameter logic [${reg_msb}:0] ${reg_resname(reg)} = ${reg_resval};
    % for field in reg.fields:
      % if field.resval is not None:
<%
    field_width = field.bits.width()
    field_msb = field_width - 1
    field_resval = "{}'h {:x}".format(field_width, field.resval)
%>\
  parameter logic [${field_msb}:0] ${field_resname(reg, field)} = ${field_resval};
      % endif
    % endfor
  % endfor
% endif
</%def>\
<%def name="windows_for_iface(iface_name, iface_desc, for_iface, rb)">\
% if rb.windows:
<%
  aw_name, aw = addr_widths[iface_name]
%>\

  // Window parameters${for_iface}
% for i,w in enumerate(rb.windows):
<%
    win_pfx = '{}_{}'.format(ublock, w.name.upper())
    base_txt_val = "{}'h {:x}".format(aw, w.offset)
    size_txt_val = "'h {:x}".format(w.size_in_bytes)

    offset_type = 'logic [{}-1:0]'.format(aw_name)
    size_type = 'int unsigned'
    max_type_len = max(len(offset_type), len(size_type))

    offset_type += ' ' * (max_type_len - len(offset_type))
    size_type += ' ' * (max_type_len - len(size_type))

%>\
  parameter ${offset_type} ${win_pfx}_OFFSET = ${base_txt_val};
  parameter ${size_type} ${win_pfx}_SIZE   = ${size_txt_val};
% endfor
% endif
</%def>\
<%def name="reg_data_for_iface(iface_name, iface_desc, for_iface, rb)">\
% if rb.flat_regs:
<%
  lpfx = gen_rtl.get_type_name_pfx(block, iface_name)
  upfx = lpfx.upper()
  idx_len = len("{}".format(len(rb.flat_regs) - 1))
%>\

  // Register index${for_iface}
  typedef enum int {
% for r in rb.flat_regs:
    ${ublock}_${r.name.upper()}${"" if loop.last else ","}
% endfor
  } ${lpfx}_id_e;

  // Register width information to check illegal writes${for_iface}
  parameter logic [3:0] ${upfx}_PERMIT [${len(rb.flat_regs)}] = '{
  % for i, r in enumerate(rb.flat_regs):
<%
  index_str = "{}".format(i).rjust(idx_len)
  width = r.get_width()
  if width > 24:
    mask = '1111'
  elif width > 16:
    mask = '0111'
  elif width > 8:
    mask = '0011'
  else:
    mask = '0001'

  comma = ',' if i < len(rb.flat_regs) - 1 else ' '
%>\
    4'b ${mask}${comma} // index[${index_str}] ${ublock}_${r.name.upper()}
  % endfor
  };
% endif
</%def>\

package ${lblock}${"_" + block.alias_impl if block.alias_impl else ""}_reg_pkg;
% if localparams and not block.alias_impl:

  // Param list
% for param in localparams:
  parameter ${param.param_type} ${param.name} = ${gen_rtl.render_param(param.param_type, param.value)};
% endfor
% endif

  // Address widths within the block
% for param_name, width in addr_widths.values():
  parameter int ${param_name} = ${width};
% endfor
<%
  just_default = len(block.reg_blocks) == 1 and None in block.reg_blocks
%>\
% for iface_name, rb in block.reg_blocks.items():
<%
  iface_desc = iface_name or 'default'
  for_iface = '' if just_default else ' for {} interface'.format(iface_desc)
%>\
${typedefs_for_iface(iface_name, iface_desc, for_iface, rb)}\
${reg2hw_for_iface(iface_name, iface_desc, for_iface, rb)}\
${hw2reg_for_iface(iface_name, iface_desc, for_iface, rb)}\
${offsets_for_iface(iface_name, iface_desc, for_iface, rb)}\
${hwext_resvals_for_iface(iface_name, iface_desc, for_iface, rb)}\
${windows_for_iface(iface_name, iface_desc, for_iface, rb)}\
${reg_data_for_iface(iface_name, iface_desc, for_iface, rb)}\
% endfor

endpackage
