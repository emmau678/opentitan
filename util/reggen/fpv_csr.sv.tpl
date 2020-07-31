// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// FPV CSR read and write assertions auto-generated by `reggen` containing data structure
// Do Not Edit directly
// TODO: This automation does not support: shadow reg and regwen reg
// This automation assumes that W1C and W0C are registers with 1 bit per field
<% from reggen import (gen_fpv)
%>\
<% from topgen import lib
%>\
<%def name="construct_classes(block)">\
% for b in block.blocks:
${construct_classes(b)}
% endfor

`include "prim_assert.sv"

// Block: ${block.name}
module ${block.name}_csr_assert_fpv import tlul_pkg::*; import ${block.name}_reg_pkg::*; (
  input clk_i,
  input rst_ni,

  // tile link ports
  input tl_h2d_t h2d,
  input tl_d2h_t d2h,

  // reg and hw ports
  input ${block.name}_reg2hw_t reg2hw,
  input ${block.name}_hw2reg_t hw2reg
);

  parameter int DWidth = 32;
  // mask register to convert byte to bit
  logic [DWidth-1:0] a_mask_bit;

  assign a_mask_bit[7:0]   = h2d.a_mask[0] ? '1 : '0;
  assign a_mask_bit[15:8]  = h2d.a_mask[1] ? '1 : '0;
  assign a_mask_bit[23:16] = h2d.a_mask[2] ? '1 : '0;
  assign a_mask_bit[31:24] = h2d.a_mask[3] ? '1 : '0;

<%
  addr_msb = block.addr_width - 1
  mask = block.addr_width
%>\
  // declare common read and write sequences
  sequence device_wr_S(logic [${addr_msb}:0] addr);
    h2d.a_address == addr && h2d.a_opcode inside {PutFullData, PutPartialData} &&
        h2d.a_valid && h2d.d_ready && !d2h.d_valid;
  endsequence

  sequence device_rd_S(logic [${addr_msb}:0] addr);
    h2d.a_address == addr && h2d.a_opcode inside {Get} && h2d.a_valid && h2d.d_ready &&
        !d2h.d_valid;
  endsequence

  // declare common read and write properties
  // for homog registers, we check by a reg; for non-homog regs, we check by field.
  // `mask` is used for checking by field. It masks out any act_data that are not within the field
  // `lsb` is used to check non-homog multi_reg. Because we are using a local copy `_fpv` variable
  // to store all the multi-reg within one basefield, we need to shift the `_fpv` value to the
  // correct bits, then compare with read/write exp_data.

  property wr_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit regen,
                bit [DWidth-1:0] mask, int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_wr_S(addr), id = h2d.a_source, exp_data = h2d.a_data & a_mask_bit & mask) ##1
        first_match(##[0:$] d2h.d_valid && d2h.d_source == id) |->
        (d2h.d_error || (act_data << lsb) == exp_data || !regen);
  endproperty

  // external reg will use one clk cycle to update act_data from external
  property wr_ext_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit regen,
                    bit [DWidth-1:0] mask, int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_wr_S(addr), id = h2d.a_source, exp_data = h2d.a_data & a_mask_bit & mask) ##1
        first_match(##[0:$] (d2h.d_valid && d2h.d_source == id)) |->
        (d2h.d_error || ($past(act_data) << lsb) == exp_data || !regen);
  endproperty

  property w1c_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit regen,
                bit [DWidth-1:0] mask, int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_wr_S(addr), id = h2d.a_source, exp_data = h2d.a_data & a_mask_bit & mask & '0) ##1
        first_match(##[0:$] d2h.d_valid && d2h.d_source == id) |->
        (d2h.d_error || (act_data << lsb) == exp_data || !regen);
  endproperty

  property w1c_ext_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit regen,
                    bit [DWidth-1:0] mask, int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_wr_S(addr), id = h2d.a_source, exp_data = h2d.a_data & a_mask_bit & mask & '0) ##1
        first_match(##[0:$] (d2h.d_valid && d2h.d_source == id)) |->
        (d2h.d_error || ($past(act_data) << lsb) == exp_data || !regen);
  endproperty

  property rd_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit [DWidth-1:0] mask, int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_rd_S(addr), id = h2d.a_source, exp_data = $past(act_data)) ##1
        first_match(##[0:$] (d2h.d_valid && d2h.d_source == id)) |->
        (d2h.d_error || (d2h.d_data & mask) >> lsb == exp_data);
  endproperty

  property rd_ext_P(bit [${addr_msb}:0] addr, bit [DWidth-1:0] act_data, bit [DWidth-1:0] mask,
      int lsb);
    logic [DWidth-1:0] id, exp_data;
    (device_rd_S(addr), id = h2d.a_source, exp_data = act_data) ##1
        first_match(##[0:$] (d2h.d_valid && d2h.d_source == id)) |->
        (d2h.d_error || (d2h.d_data & mask) >> lsb == exp_data);
  endproperty

  // read a WO register, always return 0
  property r_wo_P(bit [${addr_msb}:0] addr);
    logic [DWidth-1:0] id;
    (device_rd_S(addr), id = h2d.a_source) ##1
        first_match(##[0:$] (d2h.d_valid && d2h.d_source == id)) |->
        (d2h.d_error || d2h.d_data == 0);
  endproperty

  // TODO: currently not used, will use once support regwen reg
  property wr_regen_stable_P(bit regen, bit [DWidth-1:0] exp_data);
    (!regen && $stable(regen)) |-> $stable(exp_data);
  endproperty

% for r in block.regs:
<%
  has_q = r.get_n_bits(["q"]) > 0
  has_d = r.get_n_bits(["d"]) > 0
%>\
  % if not r.get_field_flat(0).shadowed:
  % if r.is_multi_reg():
<%
      mreg_name = r.name
      mreg_width_list = list()
      mreg_fpv_name_list = list()
      mreg_dut_path_list = list()
      mreg_num_regs = r.get_n_fields_flat()

      mreg_msb = -1
      mreg_lsb = 0
      i = 0
%>\
   % if not r.ishomog:
     % for field in r.get_reg_flat(0).fields:
<%
  mreg_fpv_name_list.append(mreg_name + "_" + field.get_basename())
  mreg_dut_path_list.append(mreg_name + "[s]." + field.get_basename())
  mreg_width_list.append(field.msb - field.lsb + 1)
%>\
     % endfor
<%
  mreg_num_base_fields = len(mreg_fpv_name_list)
  mreg_num_regs = mreg_num_regs / mreg_num_base_fields
%>\
   % else:
<%
  f = r.get_field_flat(0)
  mreg_num_base_fields = 1
  mreg_fpv_name_list.append(mreg_name)
  mreg_dut_path_list.append(mreg_name + "[s]")
  mreg_width_list.append(f.msb - f.lsb + 1)
%>\
   % endif

  // define local fpv variable for multi-reg
   % if r.get_n_bits(["q", "d"]):
     % for fpv_name in mreg_fpv_name_list:
${declare_fpv_var(fpv_name, int(mreg_width_list[loop.index] * mreg_num_regs - 1))}\
     % endfor
  for (genvar s = 0; s < ${int(mreg_num_regs)}; s++) begin : gen_${mreg_name}_q
     % for fpv_name in mreg_fpv_name_list:
${assign_fpv_var(fpv_name, mreg_dut_path_list[loop.index], int(mreg_width_list[loop.index]))}\
     % endfor
  end
   % endif
  % endif

  % for reg_flat in r.get_regs_flat():
<%
  reg_name = reg_flat.name
  reg_width = block.addr_width
  reg_offset =  str(reg_width) + "'h" + "%x" % reg_flat.offset
  reg_msb = reg_flat.width - 1
  regwen = reg_flat.regwen
  reg_wr_mask = 0
  hw_access = reg_flat.fields[0].hwaccess
%>\
  // assertions for register: ${reg_name}
    % if regwen:
<% reg_wen = "u_reg." + regwen + "_qs" %>\
    % else:
<% reg_wen = "1" %>\
    % endif
    % for f in reg_flat.get_fields_flat():
<%
      field_name = f.name
      assert_path = reg_name + "." + field_name
      assert_name = reg_name + "_" + field_name
      field_access = f.swaccess.name
      field_wr_mask = ((1 << (f.msb-f.lsb + 1)) -1) << f.lsb
      field_wr_mask_h = format(field_wr_mask, 'x')
      reg_wr_mask |= field_wr_mask
      reg_wr_mask_h = format(reg_wr_mask, 'x')
      lsb = f.lsb
%>\
      % if not r.ishomog:
  // this is a non-homog multi-reg
        % if r.is_multi_reg():
<%
      mreg_lsb = i * mreg_width_list[loop.index]
      mreg_msb = mreg_lsb + mreg_width_list[loop.index] - 1
%>\
${gen_multi_reg_asserts_by_category(assert_name, mreg_name + "_" + f.get_basename(), mreg_msb, mreg_lsb, reg_flat.hwext, field_wr_mask_h)}\
        % else:
${gen_asserts_by_category(assert_name, assert_path, reg_flat.hwext, field_wr_mask_h)}\
        % endif
      % endif
    % endfor
    % if r.is_multi_reg():
<%
      mreg_lsb = i * (mreg_msb - mreg_lsb + 1)
      mreg_msb = mreg_lsb + reg_msb
      i += 1
%>\
    % endif
    % if r.ishomog:
      % if r.is_multi_reg():
${gen_multi_reg_asserts_by_category(reg_name, mreg_name, mreg_msb, mreg_lsb, reg_flat.hwext, reg_wr_mask_h)}\
      % else:
${gen_asserts_by_category(reg_name, reg_name, reg_flat.hwext, reg_wr_mask_h)}\
      % endif
    % endif
  % endfor
  % endif
% endfor

<%def name="gen_asserts_by_category(assert_name, assert_path, is_ext, wr_mask)">\
  % if has_q:
<% reg_w_path = "reg2hw." + assert_path + ".q" %>\
${gen_wr_asserts(assert_name, is_ext, reg_w_path, wr_mask)}\
    % if not has_d:
${gen_rd_asserts(assert_name, is_ext, reg_w_path, "ffffffff")}\
    % endif
  % endif
  % if has_d:
<% reg_r_path = "hw2reg." + assert_path + ".d" %>\
${gen_rd_asserts(assert_name, is_ext, reg_r_path, "ffffffff")}\
  % endif
</%def>\
<%def name="gen_multi_reg_asserts_by_category(assert_name, multi_reg_name, mreg_msb, mreg_lsb, is_ext, wr_mask)">\
  % if has_q:
<% reg_w_path = multi_reg_name + "_q_fpv[" + str(mreg_msb) + ":" + str(mreg_lsb) + "]"%>\
${gen_wr_asserts(assert_name, is_ext, reg_w_path, wr_mask)}\
    % if not has_d:
${gen_rd_asserts(assert_name, is_ext, reg_w_path, wr_mask)}\
    % endif
  % endif
  % if has_d:
<% reg_r_path = mreg_name + "_d_fpv[" + str(mreg_msb) + ":" + str(mreg_lsb) + "]"%>\
${gen_rd_asserts(assert_name, is_ext, reg_r_path, wr_mask)}\
  % endif
</%def>\
<%def name="gen_wr_asserts(name, is_ext, reg_w_path, wr_mask)">\
  % if is_ext:
<% wr_property = "ext_P" %>\
  % else:
<% wr_property = "P" %>\
  % endif
  % if r.is_multi_reg() and not r.ishomog:
<% shift_index = lsb %>\
  % else:
<% shift_index = 0 %>\
  % endif
  % if field_access == "W1C":
  //`ASSERT(${name}_w0c_A, w0c_P(${reg_offset}, ${reg_w_path}, ${reg_wen}, 'h${wr_mask}, ${shift_index}))
  `ASSERT(${name}_w1c_A, w1c_${wr_property}(${reg_offset}, ${reg_w_path}, ${reg_wen}, 'h${wr_mask}, ${shift_index}))
  % elif field_access in {"RW", "WO", "W0C"}:
  `ASSERT(${name}_wr_A, wr_${wr_property}(${reg_offset}, ${reg_w_path}, ${reg_wen}, 'h${wr_mask}, ${shift_index}))
  % endif
</%def>\
<%def name="gen_rd_asserts(name, is_ext, reg_r_path, mask)">\
  % if is_ext:
<% rd_property = "rd_ext_P" %>\
  % else:
<% rd_property = "rd_P" %>\
  % endif
  % if r.is_multi_reg() and not r.ishomog:
<% shift_index = lsb %>\
  % else:
<% shift_index = 0 %>\
  % endif
  % if field_access == "W0C":
  `ASSERT(${name}_rd_A, ${rd_property}(${reg_offset}, ${reg_r_path}, 'h${mask}, ${shift_index}))
  % elif field_access == "W1C":
  `ASSERT(${name}_rd_A, ${rd_property}(${reg_offset}, ${reg_r_path}, 'h${mask}, ${shift_index}))
  % elif field_access in {"RW", "RO"}:
  `ASSERT(${name}_rd_A, ${rd_property}(${reg_offset}, ${reg_r_path}, 'h${mask}, ${shift_index}))
  % elif field_access == "WO":
  `ASSERT(${name}_rd_A, r_wo_P(${reg_offset}))
  % endif
</%def>\
<%def name="declare_fpv_var(name, width)">\
  % if has_q:
  logic [${width}:0] ${name}_q_fpv;
  % endif
  % if has_d:
  logic [${width}:0] ${name}_d_fpv;
  % endif
</%def>\
<%def name="assign_fpv_var(fpv_name, dut_path, width)">\
  % if has_q:
    assign ${fpv_name}_q_fpv[((s+1)*${width}-1):s*${width}] = reg2hw.${dut_path}.q;
  % endif
  % if has_d:
    assign ${fpv_name}_d_fpv[((s+1)*${width}-1):s*${width}] = hw2reg.${dut_path}.d;
  % endif
</%def>\
</%def>\
${construct_classes(block)}
endmodule
