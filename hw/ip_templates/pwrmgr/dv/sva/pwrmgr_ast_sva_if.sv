// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This has some assertions that check the inputs from ast react according to
// the pwrmgr outputs. The ast inputs are generated by the base sequences, but
// these assertions will also be useful at full chip level.
interface pwrmgr_ast_sva_if #(
  parameter bit CheckClocks = 1'b0
) (
  input logic                     clk_slow_i,
  input logic                     rst_slow_ni,
  input logic                     clk_main_i,
  input logic                     clk_io_i,
  input logic                     clk_usb_i,
  input logic                     por_d0_ni,
  // The pwrmgr outputs.
  input pwrmgr_pkg::pwr_ast_req_t pwr_ast_o,
  // The pwrmgr inputs.
  input pwrmgr_pkg::pwr_ast_rsp_t pwr_ast_i
);

  // These numbers of cycles are meant to match both the randomization in
  // pwrmgr_base_vseq, and the actual cycle counts from full chip.
  // Notice the expectation for full chip is that deassertion of *clk_val
  // takes 0 cycles, and assertion takes a 2 cycle synchronizer delay on
  // the slow clock; deassertion of main_pok takes one cycle, and assertion
  // not more than 2 cycles.
  localparam int MIN_CLK_WAIT_CYCLES = 0;
  localparam int MIN_PDN_WAIT_CYCLES = 0;
  localparam int MAX_CLK_WAIT_CYCLES = 60;
  localparam int MAX_PDN_WAIT_CYCLES = 110;

  bit disable_sva;
  bit reset_or_disable;

  always_comb reset_or_disable = !rst_slow_ni || disable_sva;

  `define CLK_WAIT_BOUNDS ##[MIN_CLK_WAIT_CYCLES:MAX_CLK_WAIT_CYCLES]
  `define PDN_WAIT_BOUNDS ##[MIN_PDN_WAIT_CYCLES:MAX_PDN_WAIT_CYCLES]

  // Clock enable-valid.

  // Changes triggered by por_d0_ni only affect clk_val.
  `ASSERT(CoreClkGlitchToValOff_A, $fell(por_d0_ni) |-> ##[0:1] !pwr_ast_i.core_clk_val, clk_slow_i,
          reset_or_disable)
  `ASSERT(CoreClkGlitchToValOn_A,
          $rose(por_d0_ni) && pwr_ast_o.core_clk_en |-> ##[0:2] pwr_ast_i.core_clk_val, clk_slow_i,
          reset_or_disable)
  `ASSERT(IoClkGlitchToValOff_A, $fell(por_d0_ni) |-> ##[0:1] !pwr_ast_i.io_clk_val, clk_slow_i,
          reset_or_disable)
  `ASSERT(IoClkGlitchToValOn_A,
          $rose(por_d0_ni) && pwr_ast_o.io_clk_en |-> ##[0:2] pwr_ast_i.io_clk_val, clk_slow_i,
          reset_or_disable)
  `ASSERT(UsbClkGlitchToValOff_A, $fell(por_d0_ni) |-> ##[0:5] !pwr_ast_i.usb_clk_val, clk_slow_i,
          reset_or_disable)
  `ASSERT(UsbClkGlitchToValOn_A,
          $rose(por_d0_ni) && pwr_ast_o.usb_clk_en |-> ##[0:5] pwr_ast_i.usb_clk_val, clk_slow_i,
          reset_or_disable)

  // Changes not triggered by por_d0_ni
  `ASSERT(CoreClkHandshakeOn_A,
          $rose(pwr_ast_o.core_clk_en) && por_d0_ni |-> `CLK_WAIT_BOUNDS
          pwr_ast_i.core_clk_val || !por_d0_ni, clk_slow_i, reset_or_disable)
  `ASSERT(CoreClkHandshakeOff_A,
          $fell(pwr_ast_o.core_clk_en) |-> `CLK_WAIT_BOUNDS !pwr_ast_i.core_clk_val, clk_slow_i,
          reset_or_disable)

  `ASSERT(IoClkHandshakeOn_A,
          $rose(pwr_ast_o.io_clk_en) && por_d0_ni |-> `CLK_WAIT_BOUNDS
          pwr_ast_i.io_clk_val || !por_d0_ni, clk_slow_i, reset_or_disable)
  `ASSERT(IoClkHandshakeOff_A,
          $fell(pwr_ast_o.io_clk_en) |-> `CLK_WAIT_BOUNDS !pwr_ast_i.io_clk_val, clk_slow_i,
          reset_or_disable)

  // Usb is a bit different: apparently usb_clk_val can stay low after a power glitch, so it may
  // already be low when usb_clk_en drops.
  `ASSERT(UsbClkHandshakeOn_A,
          $rose(pwr_ast_o.usb_clk_en) && por_d0_ni && $past(por_d0_ni, 1) |-> `CLK_WAIT_BOUNDS
          pwr_ast_i.usb_clk_val || !por_d0_ni, clk_slow_i, reset_or_disable)
  `ASSERT(UsbClkHandshakeOff_A,
          $fell(pwr_ast_o.usb_clk_en) |-> `CLK_WAIT_BOUNDS !pwr_ast_i.usb_clk_val, clk_slow_i,
          reset_or_disable)

  if (CheckClocks) begin : gen_check_clock
    int main_clk_cycles, io_clk_cycles, usb_clk_cycles;
    always_ff @(posedge clk_main_i) main_clk_cycles++;
    always_ff @(posedge clk_io_i) io_clk_cycles++;
    always_ff @(posedge clk_usb_i) usb_clk_cycles++;

    `ASSERT(MainClkStopped_A,
            $fell(
                pwr_ast_i.core_clk_val
            ) |=> ($stable(
                main_clk_cycles
            ) || pwr_ast_i.core_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)
    `ASSERT(MainClkRun_A,
            $rose(
                pwr_ast_i.core_clk_val
            ) |=> (!$stable(
                main_clk_cycles
            ) || !pwr_ast_i.core_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)

    `ASSERT(IOClkStopped_A,
            $fell(
                pwr_ast_i.io_clk_val
            ) |=> ($stable(
                io_clk_cycles
            ) || pwr_ast_i.io_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)
    `ASSERT(IOClkRun_A,
            $rose(
                pwr_ast_i.io_clk_val
            ) |=> (!$stable(
                io_clk_cycles
            ) || !pwr_ast_i.io_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)

    `ASSERT(USBClkStopped_A,
            $fell(
                pwr_ast_i.usb_clk_val
            ) |=> ($stable(
                usb_clk_cycles
            ) || pwr_ast_i.usb_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)
    `ASSERT(USBClkRun_A,
            $rose(
                pwr_ast_i.usb_clk_val
            ) |=> (!$stable(
                usb_clk_cycles
            ) || !pwr_ast_i.usb_clk_val) [* 1 : $],
            clk_slow_i, reset_or_disable)
  end

  // Main pd-pok
  `ASSERT(MainPdHandshakeOn_A, pwr_ast_o.main_pd_n |-> `PDN_WAIT_BOUNDS pwr_ast_i.main_pok,
          clk_slow_i, reset_or_disable)
  `ASSERT(MainPdHandshakeOff_A, !pwr_ast_o.main_pd_n |-> `PDN_WAIT_BOUNDS !pwr_ast_i.main_pok,
          clk_slow_i, reset_or_disable)

  `undef CLK_WAIT_BOUNDS
  `undef PDN_WAIT_BOUNDS
endinterface
