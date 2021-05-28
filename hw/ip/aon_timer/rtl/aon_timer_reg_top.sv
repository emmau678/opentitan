// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module aon_timer_reg_top (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output aon_timer_reg_pkg::aon_timer_reg2hw_t reg2hw, // Write
  input  aon_timer_reg_pkg::aon_timer_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o,

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import aon_timer_reg_pkg::* ;

  localparam int AW = 6;
  localparam int DW = 32;
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
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
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
  assign reg_error = (devmode_i & addrmiss) | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic wkup_ctrl_enable_qs;
  logic wkup_ctrl_enable_wd;
  logic wkup_ctrl_enable_we;
  logic wkup_ctrl_enable_re;
  logic [11:0] wkup_ctrl_prescaler_qs;
  logic [11:0] wkup_ctrl_prescaler_wd;
  logic wkup_ctrl_prescaler_we;
  logic wkup_ctrl_prescaler_re;
  logic [31:0] wkup_thold_qs;
  logic [31:0] wkup_thold_wd;
  logic wkup_thold_we;
  logic wkup_thold_re;
  logic [31:0] wkup_count_qs;
  logic [31:0] wkup_count_wd;
  logic wkup_count_we;
  logic wkup_count_re;
  logic wdog_regwen_qs;
  logic wdog_regwen_wd;
  logic wdog_regwen_we;
  logic wdog_ctrl_enable_qs;
  logic wdog_ctrl_enable_wd;
  logic wdog_ctrl_enable_we;
  logic wdog_ctrl_enable_re;
  logic wdog_ctrl_pause_in_sleep_qs;
  logic wdog_ctrl_pause_in_sleep_wd;
  logic wdog_ctrl_pause_in_sleep_we;
  logic wdog_ctrl_pause_in_sleep_re;
  logic [31:0] wdog_bark_thold_qs;
  logic [31:0] wdog_bark_thold_wd;
  logic wdog_bark_thold_we;
  logic wdog_bark_thold_re;
  logic [31:0] wdog_bite_thold_qs;
  logic [31:0] wdog_bite_thold_wd;
  logic wdog_bite_thold_we;
  logic wdog_bite_thold_re;
  logic [31:0] wdog_count_qs;
  logic [31:0] wdog_count_wd;
  logic wdog_count_we;
  logic wdog_count_re;
  logic intr_state_wkup_timer_expired_qs;
  logic intr_state_wkup_timer_expired_wd;
  logic intr_state_wkup_timer_expired_we;
  logic intr_state_wdog_timer_expired_qs;
  logic intr_state_wdog_timer_expired_wd;
  logic intr_state_wdog_timer_expired_we;
  logic intr_test_wkup_timer_expired_wd;
  logic intr_test_wkup_timer_expired_we;
  logic intr_test_wdog_timer_expired_wd;
  logic intr_test_wdog_timer_expired_we;
  logic wkup_cause_qs;
  logic wkup_cause_wd;
  logic wkup_cause_we;
  logic wkup_cause_re;

  // Register instances
  // R[wkup_ctrl]: V(True)

  //   F[enable]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_wkup_ctrl_enable (
    .re     (wkup_ctrl_enable_re),
    .we     (wkup_ctrl_enable_we),
    .wd     (wkup_ctrl_enable_wd),
    .d      (hw2reg.wkup_ctrl.enable.d),
    .qre    (),
    .qe     (reg2hw.wkup_ctrl.enable.qe),
    .q      (reg2hw.wkup_ctrl.enable.q),
    .qs     (wkup_ctrl_enable_qs)
  );


  //   F[prescaler]: 12:1
  prim_subreg_ext #(
    .DW    (12)
  ) u_wkup_ctrl_prescaler (
    .re     (wkup_ctrl_prescaler_re),
    .we     (wkup_ctrl_prescaler_we),
    .wd     (wkup_ctrl_prescaler_wd),
    .d      (hw2reg.wkup_ctrl.prescaler.d),
    .qre    (),
    .qe     (reg2hw.wkup_ctrl.prescaler.qe),
    .q      (reg2hw.wkup_ctrl.prescaler.q),
    .qs     (wkup_ctrl_prescaler_qs)
  );


  // R[wkup_thold]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wkup_thold (
    .re     (wkup_thold_re),
    .we     (wkup_thold_we),
    .wd     (wkup_thold_wd),
    .d      (hw2reg.wkup_thold.d),
    .qre    (),
    .qe     (reg2hw.wkup_thold.qe),
    .q      (reg2hw.wkup_thold.q),
    .qs     (wkup_thold_qs)
  );


  // R[wkup_count]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wkup_count (
    .re     (wkup_count_re),
    .we     (wkup_count_we),
    .wd     (wkup_count_wd),
    .d      (hw2reg.wkup_count.d),
    .qre    (),
    .qe     (reg2hw.wkup_count.qe),
    .q      (reg2hw.wkup_count.q),
    .qs     (wkup_count_qs)
  );


  // R[wdog_regwen]: V(False)

  prim_subreg #(
    .DW      (1),
    .SWACCESS("W0C"),
    .RESVAL  (1'h1)
  ) u_wdog_regwen (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (wdog_regwen_we),
    .wd     (wdog_regwen_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (),

    // to register interface (read)
    .qs     (wdog_regwen_qs)
  );


  // R[wdog_ctrl]: V(True)

  //   F[enable]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_wdog_ctrl_enable (
    .re     (wdog_ctrl_enable_re),
    .we     (wdog_ctrl_enable_we & wdog_regwen_qs),
    .wd     (wdog_ctrl_enable_wd),
    .d      (hw2reg.wdog_ctrl.enable.d),
    .qre    (),
    .qe     (reg2hw.wdog_ctrl.enable.qe),
    .q      (reg2hw.wdog_ctrl.enable.q),
    .qs     (wdog_ctrl_enable_qs)
  );


  //   F[pause_in_sleep]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_wdog_ctrl_pause_in_sleep (
    .re     (wdog_ctrl_pause_in_sleep_re),
    .we     (wdog_ctrl_pause_in_sleep_we & wdog_regwen_qs),
    .wd     (wdog_ctrl_pause_in_sleep_wd),
    .d      (hw2reg.wdog_ctrl.pause_in_sleep.d),
    .qre    (),
    .qe     (reg2hw.wdog_ctrl.pause_in_sleep.qe),
    .q      (reg2hw.wdog_ctrl.pause_in_sleep.q),
    .qs     (wdog_ctrl_pause_in_sleep_qs)
  );


  // R[wdog_bark_thold]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wdog_bark_thold (
    .re     (wdog_bark_thold_re),
    .we     (wdog_bark_thold_we & wdog_regwen_qs),
    .wd     (wdog_bark_thold_wd),
    .d      (hw2reg.wdog_bark_thold.d),
    .qre    (),
    .qe     (reg2hw.wdog_bark_thold.qe),
    .q      (reg2hw.wdog_bark_thold.q),
    .qs     (wdog_bark_thold_qs)
  );


  // R[wdog_bite_thold]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wdog_bite_thold (
    .re     (wdog_bite_thold_re),
    .we     (wdog_bite_thold_we & wdog_regwen_qs),
    .wd     (wdog_bite_thold_wd),
    .d      (hw2reg.wdog_bite_thold.d),
    .qre    (),
    .qe     (reg2hw.wdog_bite_thold.qe),
    .q      (reg2hw.wdog_bite_thold.q),
    .qs     (wdog_bite_thold_qs)
  );


  // R[wdog_count]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_wdog_count (
    .re     (wdog_count_re),
    .we     (wdog_count_we),
    .wd     (wdog_count_wd),
    .d      (hw2reg.wdog_count.d),
    .qre    (),
    .qe     (reg2hw.wdog_count.qe),
    .q      (reg2hw.wdog_count.q),
    .qs     (wdog_count_qs)
  );


  // R[intr_state]: V(False)

  //   F[wkup_timer_expired]: 0:0
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_wkup_timer_expired (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_wkup_timer_expired_we),
    .wd     (intr_state_wkup_timer_expired_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.wkup_timer_expired.de),
    .d      (hw2reg.intr_state.wkup_timer_expired.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.wkup_timer_expired.q),

    // to register interface (read)
    .qs     (intr_state_wkup_timer_expired_qs)
  );


  //   F[wdog_timer_expired]: 1:1
  prim_subreg #(
    .DW      (1),
    .SWACCESS("W1C"),
    .RESVAL  (1'h0)
  ) u_intr_state_wdog_timer_expired (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_wdog_timer_expired_we),
    .wd     (intr_state_wdog_timer_expired_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.wdog_timer_expired.de),
    .d      (hw2reg.intr_state.wdog_timer_expired.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.wdog_timer_expired.q),

    // to register interface (read)
    .qs     (intr_state_wdog_timer_expired_qs)
  );


  // R[intr_test]: V(True)

  //   F[wkup_timer_expired]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_wkup_timer_expired (
    .re     (1'b0),
    .we     (intr_test_wkup_timer_expired_we),
    .wd     (intr_test_wkup_timer_expired_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.wkup_timer_expired.qe),
    .q      (reg2hw.intr_test.wkup_timer_expired.q),
    .qs     ()
  );


  //   F[wdog_timer_expired]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_wdog_timer_expired (
    .re     (1'b0),
    .we     (intr_test_wdog_timer_expired_we),
    .wd     (intr_test_wdog_timer_expired_wd),
    .d      ('0),
    .qre    (),
    .qe     (reg2hw.intr_test.wdog_timer_expired.qe),
    .q      (reg2hw.intr_test.wdog_timer_expired.q),
    .qs     ()
  );


  // R[wkup_cause]: V(True)

  prim_subreg_ext #(
    .DW    (1)
  ) u_wkup_cause (
    .re     (wkup_cause_re),
    .we     (wkup_cause_we),
    .wd     (wkup_cause_wd),
    .d      (hw2reg.wkup_cause.d),
    .qre    (),
    .qe     (reg2hw.wkup_cause.qe),
    .q      (reg2hw.wkup_cause.q),
    .qs     (wkup_cause_qs)
  );




  logic [10:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == AON_TIMER_WKUP_CTRL_OFFSET);
    addr_hit[ 1] = (reg_addr == AON_TIMER_WKUP_THOLD_OFFSET);
    addr_hit[ 2] = (reg_addr == AON_TIMER_WKUP_COUNT_OFFSET);
    addr_hit[ 3] = (reg_addr == AON_TIMER_WDOG_REGWEN_OFFSET);
    addr_hit[ 4] = (reg_addr == AON_TIMER_WDOG_CTRL_OFFSET);
    addr_hit[ 5] = (reg_addr == AON_TIMER_WDOG_BARK_THOLD_OFFSET);
    addr_hit[ 6] = (reg_addr == AON_TIMER_WDOG_BITE_THOLD_OFFSET);
    addr_hit[ 7] = (reg_addr == AON_TIMER_WDOG_COUNT_OFFSET);
    addr_hit[ 8] = (reg_addr == AON_TIMER_INTR_STATE_OFFSET);
    addr_hit[ 9] = (reg_addr == AON_TIMER_INTR_TEST_OFFSET);
    addr_hit[10] = (reg_addr == AON_TIMER_WKUP_CAUSE_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(AON_TIMER_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(AON_TIMER_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(AON_TIMER_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(AON_TIMER_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(AON_TIMER_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(AON_TIMER_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(AON_TIMER_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(AON_TIMER_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(AON_TIMER_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(AON_TIMER_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(AON_TIMER_PERMIT[10] & ~reg_be)))));
  end

  assign wkup_ctrl_enable_we = addr_hit[0] & reg_we & !reg_error;
  assign wkup_ctrl_enable_wd = reg_wdata[0];
  assign wkup_ctrl_enable_re = addr_hit[0] & reg_re & !reg_error;

  assign wkup_ctrl_prescaler_we = addr_hit[0] & reg_we & !reg_error;
  assign wkup_ctrl_prescaler_wd = reg_wdata[12:1];
  assign wkup_ctrl_prescaler_re = addr_hit[0] & reg_re & !reg_error;

  assign wkup_thold_we = addr_hit[1] & reg_we & !reg_error;
  assign wkup_thold_wd = reg_wdata[31:0];
  assign wkup_thold_re = addr_hit[1] & reg_re & !reg_error;

  assign wkup_count_we = addr_hit[2] & reg_we & !reg_error;
  assign wkup_count_wd = reg_wdata[31:0];
  assign wkup_count_re = addr_hit[2] & reg_re & !reg_error;

  assign wdog_regwen_we = addr_hit[3] & reg_we & !reg_error;
  assign wdog_regwen_wd = reg_wdata[0];

  assign wdog_ctrl_enable_we = addr_hit[4] & reg_we & !reg_error;
  assign wdog_ctrl_enable_wd = reg_wdata[0];
  assign wdog_ctrl_enable_re = addr_hit[4] & reg_re & !reg_error;

  assign wdog_ctrl_pause_in_sleep_we = addr_hit[4] & reg_we & !reg_error;
  assign wdog_ctrl_pause_in_sleep_wd = reg_wdata[1];
  assign wdog_ctrl_pause_in_sleep_re = addr_hit[4] & reg_re & !reg_error;

  assign wdog_bark_thold_we = addr_hit[5] & reg_we & !reg_error;
  assign wdog_bark_thold_wd = reg_wdata[31:0];
  assign wdog_bark_thold_re = addr_hit[5] & reg_re & !reg_error;

  assign wdog_bite_thold_we = addr_hit[6] & reg_we & !reg_error;
  assign wdog_bite_thold_wd = reg_wdata[31:0];
  assign wdog_bite_thold_re = addr_hit[6] & reg_re & !reg_error;

  assign wdog_count_we = addr_hit[7] & reg_we & !reg_error;
  assign wdog_count_wd = reg_wdata[31:0];
  assign wdog_count_re = addr_hit[7] & reg_re & !reg_error;

  assign intr_state_wkup_timer_expired_we = addr_hit[8] & reg_we & !reg_error;
  assign intr_state_wkup_timer_expired_wd = reg_wdata[0];

  assign intr_state_wdog_timer_expired_we = addr_hit[8] & reg_we & !reg_error;
  assign intr_state_wdog_timer_expired_wd = reg_wdata[1];

  assign intr_test_wkup_timer_expired_we = addr_hit[9] & reg_we & !reg_error;
  assign intr_test_wkup_timer_expired_wd = reg_wdata[0];

  assign intr_test_wdog_timer_expired_we = addr_hit[9] & reg_we & !reg_error;
  assign intr_test_wdog_timer_expired_wd = reg_wdata[1];

  assign wkup_cause_we = addr_hit[10] & reg_we & !reg_error;
  assign wkup_cause_wd = reg_wdata[0];
  assign wkup_cause_re = addr_hit[10] & reg_re & !reg_error;

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = wkup_ctrl_enable_qs;
        reg_rdata_next[12:1] = wkup_ctrl_prescaler_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[31:0] = wkup_thold_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[31:0] = wkup_count_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = wdog_regwen_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = wdog_ctrl_enable_qs;
        reg_rdata_next[1] = wdog_ctrl_pause_in_sleep_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = wdog_bark_thold_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = wdog_bite_thold_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = wdog_count_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[0] = intr_state_wkup_timer_expired_qs;
        reg_rdata_next[1] = intr_state_wdog_timer_expired_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = wkup_cause_qs;
      end

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
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
