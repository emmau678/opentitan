// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`
<%
  from reggen import gen_rtl
  from reggen.access import HwAccess, SwRdAccess, SwWrAccess
  from reggen.lib import get_basename
  from reggen.register import Register
  from reggen.multi_register import MultiRegister

  num_wins = len(rb.windows)
  num_wins_width = ((num_wins+1).bit_length()) - 1
  num_reg_dsp = 1 if rb.all_regs else 0
  num_dsp  = num_wins + num_reg_dsp
  regs_flat = rb.flat_regs
  max_regs_char = len("{}".format(len(regs_flat) - 1))
  addr_width = rb.get_addr_width()

  lblock = block.name.lower()
  ublock = lblock.upper()

  u_mod_base = mod_base.upper()

  reg2hw_t = gen_rtl.get_iface_tx_type(block, if_name, False)
  hw2reg_t = gen_rtl.get_iface_tx_type(block, if_name, True)

  win_array_decl = f'  [{num_wins}]' if num_wins > 1 else ''

  # Calculate whether we're going to need an AW parameter. We use it if there
  # are any registers (obviously). We also use it if there are any windows that
  # don't start at zero and end at 1 << addr_width (see the "addr_checks"
  # calculation below for where that comes from).
  needs_aw = (bool(regs_flat) or
              num_wins > 1 or
              rb.windows and (
                rb.windows[0].offset != 0 or
                rb.windows[0].size_in_bytes != (1 << addr_width)))


  common_data_intg_gen = 0 if rb.has_data_intg_passthru else 1
  adapt_data_intg_gen = 1 if rb.has_data_intg_passthru else 0
  assert common_data_intg_gen != adapt_data_intg_gen
%>
`include "prim_assert.sv"

module ${mod_name} (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
% if num_wins != 0:

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o${win_array_decl},
  input  tlul_pkg::tl_d2h_t tl_win_i${win_array_decl},

% endif
  // To HW
% if rb.get_n_bits(["q","qe","re"]):
  output ${lblock}_reg_pkg::${reg2hw_t} reg2hw, // Write
% endif
% if rb.get_n_bits(["d","de"]):
  input  ${lblock}_reg_pkg::${hw2reg_t} hw2reg, // Read
% endif

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import ${lblock}_reg_pkg::* ;

% if needs_aw:
  localparam int AW = ${addr_width};
% endif
% if rb.all_regs:
  localparam int DW = ${block.regwidth};
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
% endif

  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i,
    .err_o(intg_err)
  );

  logic intg_err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      intg_err_q <= '0;
    end else if (intg_err) begin
      intg_err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = intg_err_q | intg_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(${common_data_intg_gen})
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o
  );

% if num_dsp == 1:
  ## Either no windows (and just registers) or no registers and only
  ## one window.
  % if num_wins == 0:
  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;
  % else:
  assign tl_win_o = tl_i;
  assign tl_o_pre = tl_win_i;
  % endif
% else:
  tlul_pkg::tl_h2d_t tl_socket_h2d [${num_dsp}];
  tlul_pkg::tl_d2h_t tl_socket_d2h [${num_dsp}];

  logic [${num_wins_width}:0] reg_steer;

  // socket_1n connection
  % if rb.all_regs:
  assign tl_reg_h2d = tl_socket_h2d[${num_wins}];
  assign tl_socket_d2h[${num_wins}] = tl_reg_d2h;

  % endif
  % for i,t in enumerate(rb.windows):
<%
      win_suff = f'[{i}]' if num_wins > 1 else ''
%>\
  assign tl_win_o${win_suff} = tl_socket_h2d[${i}];
    % if common_data_intg_gen == 0 and rb.windows[i].data_intg_passthru == False:
    ## If there are multiple windows, and not every window has data integrity
    ## passthrough, we must generate data integrity for it here.
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(0),
    .EnableDataIntgGen(1)
  ) u_win${i}_data_intg_gen (
    .tl_i(tl_win_i${win_suff}),
    .tl_o(tl_socket_d2h[${i}])
  );
    % else:
  assign tl_socket_d2h[${i}] = tl_win_i${win_suff};
    % endif
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
    .tl_h_o (tl_o_pre),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select_i (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer = ${num_dsp-1};       // Default set to register

    // TODO: Can below codes be unique case () inside ?
  % for i,w in enumerate(rb.windows):
<%
      base_addr = w.offset
      limit_addr = w.offset + w.size_in_bytes

      hi_check = 'tl_i.a_address[AW-1:0] < {}'.format(limit_addr)
      addr_checks = []
      if base_addr > 0:
        addr_checks.append('tl_i.a_address[AW-1:0] >= {}'.format(base_addr))
      if limit_addr < 2**addr_width:
        addr_checks.append('tl_i.a_address[AW-1:0] < {}'.format(limit_addr))

      addr_test = ' && '.join(addr_checks)
%>\
      % if addr_test:
    if (${addr_test}) begin
      % endif
      reg_steer = ${i};
      % if addr_test:
    end
      % endif
  % endfor
    if (intg_err) begin
      reg_steer = ${num_dsp-1};
    end
  end
% endif
% if rb.all_regs:

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(${adapt_data_intg_gen})
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

  % if block.expose_reg_if:
  assign reg2hw.reg_if.reg_we    = reg_we;
  assign reg2hw.reg_if.reg_re    = reg_re;
  assign reg2hw.reg_if.reg_addr  = reg_addr;
  assign reg2hw.reg_if.reg_wdata = reg_wdata;
  assign reg2hw.reg_if.reg_be    = reg_be;

  % endif
  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  % for r in regs_flat:
${reg_sig_decl(r)}\
    % for f in r.fields:
<%
        fld_suff = '_' + f.name.lower() if len(r.fields) > 1 else ''
        sig_name = r.name.lower() + fld_suff
%>\
${field_sig_decl(f, sig_name, r.hwext, r.shadowed)}\
    % endfor
  % endfor

  // Register instances
  % for r in rb.all_regs:
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
${finst_gen(sr, f, finst_name, fsig_name)}
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
${finst_gen(sr, f, finst_name, fsig_name)}
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
${finst_gen(r, f, finst_name, fsig_name)}
######################## register with multiple fields ###########################
    % else:
  // R[${r.name.lower()}]: V(${str(r.hwext)})
      % for f in r.fields:
<%
        finst_name = r.name.lower() + "_" + f.name.lower()
        fsig_name = r.name.lower() + "." + f.name.lower()
%>
  //   F[${f.name.lower()}]: ${f.bits.msb}:${f.bits.lsb}
${finst_gen(r, f, finst_name, fsig_name)}
      % endfor
    % endif

  ## for: rb.all_regs
  % endfor


  logic [${len(regs_flat)-1}:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    % for i,r in enumerate(regs_flat):
    addr_hit[${"{}".format(i).rjust(max_regs_char)}] = (reg_addr == ${ublock}_${r.name.upper()}_OFFSET);
    % endfor
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

% if regs_flat:
<%
    # We want to signal wr_err if reg_be (the byte enable signal) is true for
    # any bytes that aren't supported by a register. That's true if a
    # addr_hit[i] and a bit is set in reg_be but not in *_PERMIT[i].

    wr_err_terms = ['(addr_hit[{idx}] & (|({mod}_PERMIT[{idx}] & ~reg_be)))'
                    .format(idx=str(i).rjust(max_regs_char),
                            mod=u_mod_base)
                    for i in range(len(regs_flat))]
    wr_err_expr = (' |\n' + (' ' * 15)).join(wr_err_terms)
%>\
  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              (${wr_err_expr}));
  end
% else:
  assign wr_error = 1'b0;
% endif\

  % for i, r in enumerate(regs_flat):
${reg_enable_gen(r, i)}\
    % if len(r.fields) == 1:
${field_wd_gen(r.fields[0], r.name.lower(), r.hwext, r.shadowed, i)}\
    % else:
      % for f in r.fields:
${field_wd_gen(f, r.name.lower() + "_" + f.name.lower(), r.hwext, r.shadowed, i)}\
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
% endif

  // Unused signal tieoff
% if rb.all_regs:

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;
% else:
  // devmode_i is not used if there are no registers
  logic unused_devmode;
  assign unused_devmode = ^devmode_i;
% endif
% if rb.all_regs:

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

% endif
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
<%def name="reg_sig_decl(reg)">\
  % if reg.needs_re():
  logic ${reg.name.lower()}_re;
  % endif
  % if reg.needs_we():
  logic ${reg.name.lower()}_we;
  % endif
</%def>\
<%def name="field_sig_decl(field, sig_name, hwext, shadowed)">\
  % if field.swaccess.allows_read():
  logic ${str_arr_sv(field.bits)}${sig_name}_qs;
  % endif
  % if field.swaccess.allows_write():
  logic ${str_arr_sv(field.bits)}${sig_name}_wd;
  % endif
</%def>\
<%def name="finst_gen(reg, field, finst_name, fsig_name)">\
<%
    re_expr = f'{reg.name.lower()}_re' if field.swaccess.allows_read() else "1'b0"

    if field.swaccess.allows_write():
      # We usually use the REG_we signal, but use REG_re for RC fields
      # (which get updated on a read, not a write)
      we_suffix = 're' if field.swaccess.swrd() == SwRdAccess.RC else 'we'
      we_signal = f'{reg.name.lower()}_{we_suffix}'

      if reg.regwen:
        we_expr = f'{we_signal} & {reg.regwen.lower()}_qs'
      else:
        we_expr = we_signal
      wd_expr = f'{finst_name}_wd'
    else:
      we_expr = "1'b0"
      wd_expr = "'0"

    if field.hwaccess.allows_write():
      de_expr = f'hw2reg.{fsig_name}.de'
      d_expr = f'hw2reg.{fsig_name}.d'
    else:
      de_expr = "1'b0"
      d_expr = "'0"

    qre_expr = f'reg2hw.{fsig_name}.re' if reg.hwre or reg.shadowed else ""

    if field.hwaccess.allows_read():
      qe_expr = f'reg2hw.{fsig_name}.qe' if reg.hwqe else ''
      q_expr = f'reg2hw.{fsig_name}.q'
    else:
      qe_expr = ''
      q_expr = ''

    qs_expr = f'{finst_name}_qs' if field.swaccess.allows_read() else ''
%>\
  % if reg.hwext:       ## if hwext, instantiate prim_subreg_ext
  prim_subreg_ext #(
    .DW    (${field.bits.width()})
  ) u_${finst_name} (
    .re     (${re_expr}),
    .we     (${we_expr}),
    .wd     (${wd_expr}),
    .d      (${d_expr}),
    .qre    (${qre_expr}),
    .qe     (${qe_expr}),
    .q      (${q_expr}),
    .qs     (${qs_expr})
  );
  % else:
<%
      # This isn't a field in a hwext register. Instantiate prim_subreg,
      # prim_subreg_shadow or constant assign.

      resval_expr = f"{field.bits.width()}'h{field.resval or 0:x}"
      is_const_reg = not (field.hwaccess.allows_read() or
                          field.hwaccess.allows_write() or
                          field.swaccess.allows_write() or
                          field.swaccess.swrd() != SwRdAccess.RD)

      subreg_block = 'prim_subreg' + ('_shadowed' if reg.shadowed else '')
%>\
    % if is_const_reg:
  // constant-only read
  assign ${finst_name}_qs = ${resval_expr};
    % else:
  ${subreg_block} #(
    .DW      (${field.bits.width()}),
    .SWACCESS("${field.swaccess.value[1].name.upper()}"),
    .RESVAL  (${resval_expr})
  ) u_${finst_name} (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
      % if reg.shadowed:
    .re     (${re_expr}),
      % endif
    .we     (${we_expr}),
    .wd     (${wd_expr}),

    // from internal hardware
    .de     (${de_expr}),
    .d      (${d_expr}),

    // to internal hardware
    .qe     (${qe_expr}),
    .q      (${q_expr}),

    // to register interface (read)
      % if not reg.shadowed:
    .qs     (${qs_expr})
      % else:
    .qs     (${qs_expr}),

    // Shadow register error conditions
    .err_update  (reg2hw.${fsig_name}.err_update),
    .err_storage (reg2hw.${fsig_name}.err_storage)
      % endif
  );
    % endif  ## end non-constant prim_subreg
  % endif
</%def>\
<%def name="reg_enable_gen(reg, idx)">\
  % if reg.needs_re():
  assign ${reg.name.lower()}_re = addr_hit[${idx}] & reg_re & !reg_error;
  % endif
  % if reg.needs_we():
  assign ${reg.name.lower()}_we = addr_hit[${idx}] & reg_we & !reg_error;
  % endif
</%def>\
<%def name="field_wd_gen(field, sig_name, hwext, shadowed, idx)">\
<%
    needs_wd = field.swaccess.allows_write()
    space = '\n' if needs_wd or needs_re else ''
%>\
${space}\
% if needs_wd:
  % if field.swaccess.swrd() == SwRdAccess.RC:
  assign ${sig_name}_wd = '1;
  % else:
  assign ${sig_name}_wd = reg_wdata[${str_bits_sv(field.bits)}];
  % endif
% endif
</%def>\
<%def name="rdata_gen(field, sig_name)">\
% if field.swaccess.allows_read():
        reg_rdata_next[${str_bits_sv(field.bits)}] = ${sig_name}_qs;
% else:
        reg_rdata_next[${str_bits_sv(field.bits)}] = '0;
% endif
</%def>\
