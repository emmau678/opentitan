// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`
<%
  from reggen.data import get_basename
  from reggen.register import Register
  from reggen.multi_register import MultiRegister

  num_wins = len(block.wins)
  num_wins_width = ((num_wins+1).bit_length()) - 1
  num_dsp  = num_wins + 1
  max_regs_char = len("{}".format(block.get_n_regs_flat()-1))
  regs_flat = block.get_regs_flat()
%>
`include "prim_assert.sv"

module ${block.name}_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
% if num_wins != 0:

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o  [${num_wins}],
  input  tlul_pkg::tl_d2h_t tl_win_i  [${num_wins}],

% endif
  // To HW
% if block.get_n_bits(["q","qe","re"]):
  output ${block.name}_reg_pkg::${block.name}_reg2hw_t reg2hw, // Write
% endif
% if block.get_n_bits(["d","de"]):
  input  ${block.name}_reg_pkg::${block.name}_hw2reg_t hw2reg, // Read
% endif

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import ${block.name}_reg_pkg::* ;

  localparam int AW = ${block.addr_width};
  localparam int DW = ${block.width};
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

% if num_wins == 0:
  assign tl_reg_h2d = tl_i;
  assign tl_o       = tl_reg_d2h;
% else:
  tlul_pkg::tl_h2d_t tl_socket_h2d [${num_dsp}];
  tlul_pkg::tl_d2h_t tl_socket_d2h [${num_dsp}];

  logic [${num_wins_width}:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[${num_wins}];
  assign tl_socket_d2h[${num_wins}] = tl_reg_d2h;

  % for i,t in enumerate(block.wins):
  assign tl_win_o[${i}] = tl_socket_h2d[${i}];
  assign tl_socket_d2h[${i}] = tl_win_i[${i}];
  % endfor

  // Create Socket_1n
  tlul_socket_1n #(
    .N          (${num_dsp}),
    .HReqPass   (1'b1),
    .HRspPass   (1'b1),
    .DReqPass   ({${num_dsp}{1'b1}}),
    .DRspPass   ({${num_dsp}{1'b1}}),
    .HReqDepth  (4'h0),
    .HRspDepth  (4'h0),
    .DReqDepth  ({${num_dsp}{4'h0}}),
    .DRspDepth  ({${num_dsp}{4'h0}})
  ) u_socket (
    .clk_i,
    .rst_ni,
    .tl_h_i (tl_i),
    .tl_h_o (tl_o),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select_i (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer = ${num_dsp-1};       // Default set to register

    // TODO: Can below codes be unique case () inside ?
  % for i,w in enumerate(block.wins):
<%
    base_addr = w.offset
    limit_addr = w.offset + w.size_in_bytes
%>\
      % if limit_addr == 2**block.addr_width:
    if (tl_i.a_address[AW-1:0] >= ${base_addr}) begin
      // Exceed or meet the address range. Removed the comparison of limit addr 'h ${'{:x}'.format(limit_addr)}
      % else:
    if (tl_i.a_address[AW-1:0] >= ${base_addr} && tl_i.a_address[AW-1:0] < ${limit_addr}) begin
      % endif
      reg_steer = ${i};
    end
  % endfor
  end
% endif

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW)
  ) u_reg_if (
    .clk_i,
    .rst_ni,

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err ;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  % for r in regs_flat:
    % if len(r.fields) == 1:
${sig_gen(r.fields[0], r.name.lower(), r.hwext, r.shadowed)}\
    % else:
      % for f in r.fields:
${sig_gen(f, r.name.lower() + "_" + f.name.lower(), r.hwext, r.shadowed)}\
      % endfor
    % endif
  % endfor

  // Register instances
  % for r in block.regs:
  ######################## multiregister ###########################
    % if isinstance(r, MultiRegister):
<%
      k = 0
%>
      % for sr in r.regs:
  // Subregister ${k} of Multireg ${r.reg.name.lower()}
  // R[${sr.name.lower()}]: V(${str(sr.hwext)})
        % if len(sr.fields) == 1:
<%
          f = sr.fields[0]
          finst_name = sr.name.lower()
          fsig_name = r.reg.name.lower() + "[%d]" % k
          k = k + 1
%>
${finst_gen(f, finst_name, fsig_name, sr.hwext, sr.regwen, sr.shadowed)}
        % else:
          % for f in sr.fields:
<%
            finst_name = sr.name.lower() + "_" + f.name.lower()
            if r.is_homogeneous():
              fsig_name = r.reg.name.lower() + "[%d]" % k
              k = k + 1
            else:
              fsig_name = r.reg.name.lower() + "[%d]" % k + "." + get_basename(f.name.lower())
%>
  // F[${f.name.lower()}]: ${f.bits.msb}:${f.bits.lsb}
${finst_gen(f, finst_name, fsig_name, sr.hwext, sr.regwen, sr.shadowed)}
          % endfor
<%
          if not r.is_homogeneous():
            k += 1
%>
        % endif
      ## for: mreg_flat
      % endfor
######################## register with single field ###########################
    % elif len(r.fields) == 1:
  // R[${r.name.lower()}]: V(${str(r.hwext)})
<%
        f = r.fields[0]
        finst_name = r.name.lower()
        fsig_name = r.name.lower()
%>
${finst_gen(f, finst_name, fsig_name, r.hwext, r.regwen, r.shadowed)}
######################## register with multiple fields ###########################
    % else:
  // R[${r.name.lower()}]: V(${str(r.hwext)})
      % for f in r.fields:
<%
        finst_name = r.name.lower() + "_" + f.name.lower()
        fsig_name = r.name.lower() + "." + f.name.lower()
%>
  //   F[${f.name.lower()}]: ${f.bits.msb}:${f.bits.lsb}
${finst_gen(f, finst_name, fsig_name, r.hwext, r.regwen, r.shadowed)}
      % endfor
    % endif

  ## for: block.regs
  % endfor


  logic [${len(regs_flat)-1}:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    % for i,r in enumerate(regs_flat):
    addr_hit[${"{}".format(i).rjust(max_regs_char)}] = (reg_addr == ${block.name.upper()}_${r.name.upper()}_OFFSET);
    % endfor
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    % for i,r in enumerate(regs_flat):
<% index_str = "{}".format(i).rjust(max_regs_char) %>\
    if (addr_hit[${index_str}] && reg_we && (${block.name.upper()}_PERMIT[${index_str}] != (${block.name.upper()}_PERMIT[${index_str}] & reg_be))) wr_err = 1'b1 ;
    % endfor
  end
  % for i, r in enumerate(regs_flat):
    % if len(r.fields) == 1:
${we_gen(r.fields[0], r.name.lower(), r.hwext, r.shadowed, i)}\
    % else:
      % for f in r.fields:
${we_gen(f, r.name.lower() + "_" + f.name.lower(), r.hwext, r.shadowed, i)}\
      % endfor
    % endif
  % endfor

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      % for i, r in enumerate(regs_flat):
        % if len(r.fields) == 1:
      addr_hit[${i}]: begin
${rdata_gen(r.fields[0], r.name.lower())}\
      end

        % else:
      addr_hit[${i}]: begin
          % for f in r.fields:
${rdata_gen(f, r.name.lower() + "_" + f.name.lower())}\
          % endfor
      end

        % endif
      % endfor
      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  `ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.parity_en == 1'b0)

endmodule
<%def name="str_bits_sv(bits)">\
% if bits.msb != bits.lsb:
${bits.msb}:${bits.lsb}\
% else:
${bits.msb}\
% endif
</%def>\
<%def name="str_arr_sv(bits)">\
% if bits.msb != bits.lsb:
[${bits.msb-bits.lsb}:0] \
% endif
</%def>\
<%def name="sig_gen(field, sig_name, hwext, shadowed)">\
  % if field.swaccess.allows_read():
  logic ${str_arr_sv(field.bits)}${sig_name}_qs;
  % endif
  % if field.swaccess.allows_write():
  logic ${str_arr_sv(field.bits)}${sig_name}_wd;
  logic ${sig_name}_we;
  % endif
  % if (field.swaccess.allows_read() and hwext) or shadowed:
  logic ${sig_name}_re;
  % endif
</%def>\
<%def name="finst_gen(field, finst_name, fsig_name, hwext, regwen, shadowed)">\
  % if hwext:       ## if hwext, instantiate prim_subreg_ext
  prim_subreg_ext #(
    .DW    (${field.bits.width()})
  ) u_${finst_name} (
    % if field.swaccess.allows_read():
    .re     (${finst_name}_re),
    % else:
    .re     (1'b0),
    % endif
    % if field.swaccess.allows_write():
      % if regwen:
    // qualified with register enable
    .we     (${finst_name}_we & ${regwen.lower()}_qs),
      % else:
    .we     (${finst_name}_we),
      % endif
    .wd     (${finst_name}_wd),
    % else:
    .we     (1'b0),
    .wd     ('0),
    % endif
    % if field.hwaccess.allows_write():
    .d      (hw2reg.${fsig_name}.d),
    % else:
    .d      ('0),
    % endif
    % if field.hwre or shadowed:
    .qre    (reg2hw.${fsig_name}.re),
    % else:
    .qre    (),
    % endif
    % if not field.hwaccess.allows_read():
    .qe     (),
    .q      (),
    % else:
      % if field.hwqe:
    .qe     (reg2hw.${fsig_name}.qe),
      % else:
    .qe     (),
      % endif
    .q      (reg2hw.${fsig_name}.q ),
    % endif
    % if field.swaccess.allows_read():
    .qs     (${finst_name}_qs)
    % else:
    .qs     ()
    % endif
  );
  % else:       ## if not hwext, instantiate prim_subreg, prim_subreg_shadow or constant assign
    % if ((not field.hwaccess.allows_read() and\
           not field.hwaccess.allows_write() and\
           field.swaccess.swrd() == SwRdAccess.RD and\
           not field.swaccess.allows_write())):
  // constant-only read
  assign ${finst_name}_qs = ${field.bits.width()}'h${"%x" % (field.resval or 0)};
    % else:     ## not hwext not constant
      % if not shadowed:
  prim_subreg #(
      % else:
  prim_subreg_shadow #(
      % endif
    .DW      (${field.bits.width()}),
    .SWACCESS("${field.swaccess.value[1].name.upper()}"),
    .RESVAL  (${field.bits.width()}'h${"%x" % (field.resval or 0)})
  ) u_${finst_name} (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

      % if shadowed:
    .re     (${finst_name}_re),
      % endif
      % if field.swaccess.allows_write(): ## non-RO types
        % if regwen:
    // from register interface (qualified with register enable)
    .we     (${finst_name}_we & ${regwen.lower()}_qs),
        % else:
    // from register interface
    .we     (${finst_name}_we),
        % endif
    .wd     (${finst_name}_wd),
      % else:                             ## RO types
    .we     (1'b0),
    .wd     ('0  ),
      % endif

    // from internal hardware
      % if field.hwaccess.allows_write():
    .de     (hw2reg.${fsig_name}.de),
    .d      (hw2reg.${fsig_name}.d ),
      % else:
    .de     (1'b0),
    .d      ('0  ),
      % endif

    // to internal hardware
      % if not field.hwaccess.allows_read():
    .qe     (),
    .q      (),
      % else:
        % if field.hwqe:
    .qe     (reg2hw.${fsig_name}.qe),
        % else:
    .qe     (),
        % endif
    .q      (reg2hw.${fsig_name}.q ),
      % endif

      % if not shadowed:
        % if field.swaccess.allows_read():
    // to register interface (read)
    .qs     (${finst_name}_qs)
        % else:
    .qs     ()
        % endif
      % else:
        % if field.swaccess.allows_read():
    // to register interface (read)
    .qs     (${finst_name}_qs),
        % else:
    .qs     (),
        % endif

    // Shadow register error conditions
    .err_update  (reg2hw.${fsig_name}.err_update ),
    .err_storage (reg2hw.${fsig_name}.err_storage)
      % endif
  );
    % endif  ## end non-constant prim_subreg
  % endif
</%def>\
<%def name="we_gen(field, sig_name, hwext, shadowed, idx)">\

% if field.swaccess.allows_write():
  % if field.swaccess.swrd() != SwRdAccess.RC:
  assign ${sig_name}_we = addr_hit[${idx}] & reg_we & ~wr_err;
  assign ${sig_name}_wd = reg_wdata[${str_bits_sv(field.bits)}];
  % else:
  ## Generate WE based on read request, read should clear
  assign ${sig_name}_we = addr_hit[${idx}] & reg_re;
  assign ${sig_name}_wd = '1;
  % endif
% endif
% if (field.swaccess.allows_read() and hwext) or shadowed:
  assign ${sig_name}_re = addr_hit[${idx}] && reg_re;
% endif
</%def>\
<%def name="rdata_gen(field, sig_name)">\
% if field.swaccess.allows_read():
        reg_rdata_next[${str_bits_sv(field.bits)}] = ${sig_name}_qs;
% else:
        reg_rdata_next[${str_bits_sv(field.bits)}] = '0;
% endif
</%def>\
