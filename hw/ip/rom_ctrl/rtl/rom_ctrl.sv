// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

module rom_ctrl
  import rom_ctrl_reg_pkg::NumAlerts;
  import prim_rom_pkg::rom_cfg_t;
#(
  parameter                       BootRomInitFile = "",
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter bit [63:0]            RndCnstScrNonce = '0,
  parameter bit [127:0]           RndCnstScrKey = '0,

  // Disable all (de)scrambling operation. This disables both the scrambling block and the boot-time
  // checker. Don't use this in a real chip, but it's handy for small FPGA targets where we don't
  // want to spend area on unused scrambling.
  parameter bit                   SecDisableScrambling = 1'b0
) (
  input  clk_i,
  input  rst_ni,

  // ROM configuration parameters
  input  rom_cfg_t rom_cfg_i,

  input  tlul_pkg::tl_h2d_t rom_tl_i,
  output tlul_pkg::tl_d2h_t rom_tl_o,

  input  tlul_pkg::tl_h2d_t regs_tl_i,
  output tlul_pkg::tl_d2h_t regs_tl_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // Connections to other blocks
  output rom_ctrl_pkg::pwrmgr_data_t pwrmgr_data_o,
  output rom_ctrl_pkg::keymgr_data_t keymgr_data_o,
  input  kmac_pkg::app_rsp_t         kmac_data_i,
  output kmac_pkg::app_req_t         kmac_data_o
);

  import rom_ctrl_pkg::*;
  import rom_ctrl_reg_pkg::*;
  import prim_mubi_pkg::mubi4_t, prim_mubi_pkg::MuBi4True;
  import prim_util_pkg::vbits;

  // ROM_CTRL_ROM_SIZE is auto-generated by regtool and comes from the bus window size, measured in
  // bytes of content (i.e. 4 times the number of 32 bit words).
  localparam int unsigned RomSizeByte = ROM_CTRL_ROM_SIZE;
  localparam int unsigned RomSizeWords = RomSizeByte >> 2;
  localparam int unsigned RomIndexWidth = vbits(RomSizeWords);

  // DataWidth is normally 39, representing 32 bits of actual data plus 7 ECC check bits. If
  // scrambling is disabled ("insecure mode"), we store a raw 32-bit image and generate ECC check
  // bits on the fly.
  localparam int unsigned DataWidth = SecDisableScrambling ? 32 : 39;

  mubi4_t                   rom_select_bus;

  logic [RomIndexWidth-1:0] rom_rom_index, rom_prince_index;
  logic                     rom_req;
  logic [DataWidth-1:0]     rom_scr_rdata;
  logic [DataWidth-1:0]     rom_clr_rdata;
  logic                     rom_rvalid;

  logic [RomIndexWidth-1:0] bus_rom_rom_index, bus_rom_prince_index;
  logic                     bus_rom_req;
  logic                     bus_rom_gnt;
  logic [DataWidth-1:0]     bus_rom_rdata;
  logic                     bus_rom_rvalid, bus_rom_rvalid_raw;

  logic [RomIndexWidth-1:0] checker_rom_index;
  logic                     checker_rom_req;
  logic [DataWidth-1:0]     checker_rom_rdata;

  logic                     internal_alert;

  // Force point for reset glitch tests
  logic rst_n;
  prim_clock_buf #(
    .NoFpgaBuf(1)
  ) u_prim_clock_buf_rst_n (
    .clk_i(rst_ni),
    .clk_o(rst_n)
  );

  // Pack / unpack kmac connection data ========================================

  logic [63:0]              kmac_rom_data;
  logic                     kmac_rom_rdy;
  logic                     kmac_rom_vld;
  logic                     kmac_rom_last;
  logic                     kmac_done;
  logic [255:0]             kmac_digest;
  logic                     kmac_err;

  if (!SecDisableScrambling) begin : gen_kmac_scramble_enabled
    // The usual situation, with scrambling enabled. Collect up output signals for kmac and split up
    // the input struct into separate signals.

    // SEC_CM: MEM.DIGEST
    assign kmac_data_o = '{valid: kmac_rom_vld,
                           data: kmac_rom_data,
                           strb: '1,
                           last: kmac_rom_last};

    assign kmac_rom_rdy = kmac_data_i.ready;
    assign kmac_done = kmac_data_i.done;
    assign kmac_digest = kmac_data_i.digest_share0[255:0] ^ kmac_data_i.digest_share1[255:0];
    assign kmac_err = kmac_data_i.error;

    logic unused_kmac_digest;
    assign unused_kmac_digest = ^{
      kmac_data_i.digest_share0[kmac_pkg::AppDigestW-1:256],
      kmac_data_i.digest_share1[kmac_pkg::AppDigestW-1:256]
    };

  end : gen_kmac_scramble_enabled
  else begin : gen_kmac_scramble_disabled
    // Scrambling is disabled. Stub out all KMAC connections and waive the ignored signals.

    assign kmac_data_o = '0;
    assign kmac_rom_rdy = 1'b0;
    assign kmac_done = 1'b0;
    assign kmac_digest = '0;
    assign kmac_err = 1'b0;

    logic unused_kmac_inputs;
    assign unused_kmac_inputs = ^{kmac_data_i};

    logic unused_kmac_outputs;
    assign unused_kmac_outputs = ^{kmac_rom_vld, kmac_rom_data, kmac_rom_last};

  end : gen_kmac_scramble_disabled

  // TL interface ==============================================================

  tlul_pkg::tl_h2d_t tl_rom_h2d_upstream, tl_rom_h2d_downstream;
  tlul_pkg::tl_d2h_t tl_rom_d2h;

  logic  rom_reg_integrity_error;

  rom_ctrl_rom_reg_top u_rom_top (
    .clk_i      (clk_i),
    .rst_ni     (rst_n),
    .tl_i       (rom_tl_i),
    .tl_o       (rom_tl_o),
    .tl_win_o   (tl_rom_h2d_upstream),
    .tl_win_i   (tl_rom_d2h),

    .intg_err_o (rom_reg_integrity_error),    // SEC_CM: BUS.INTEGRITY

    .devmode_i  (1'b1)
  );

  // This buffer ensures that when we calculate bus_rom_prince_index by snooping on
  // tl_rom_h2d_upstream, we get a value that's buffered from the thing that goes into both the ECC
  // check and the addr_o output of u_tl_adapter_rom. That way, an injected 1- or 2-bit fault that
  // affects bus_rom_prince_index must either affect the ECC check (causing it to fail) OR it cannot
  // affect bus_rom_rom_index (so the address-tweakable scrambling will mean the read probably gets
  // garbage).
  //
  // SEC_CM: CTRL.REDUN
  prim_buf #(
    .Width($bits(tlul_pkg::tl_h2d_t))
  ) u_tl_rom_h2d_buf (
    .in_i (tl_rom_h2d_upstream),
    .out_o (tl_rom_h2d_downstream)
  );

  // Bus -> ROM adapter ========================================================

  logic rom_integrity_error;

  tlul_adapter_sram #(
    .SramAw(RomIndexWidth),
    .SramDw(32),
    .Outstanding(2),
    .ByteAccess(0),
    .ErrOnWrite(1),
    .CmdIntgCheck(1),
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(SecDisableScrambling),
    .EnableDataIntgPt(!SecDisableScrambling)
  ) u_tl_adapter_rom (
    .clk_i        (clk_i),
    .rst_ni       (rst_n),

    .tl_i         (tl_rom_h2d_downstream),
    .tl_o         (tl_rom_d2h),
    .en_ifetch_i  (prim_mubi_pkg::MuBi4True),
    .req_o        (bus_rom_req),
    .req_type_o   (),
    .gnt_i        (bus_rom_gnt),
    .we_o         (),
    .addr_o       (bus_rom_rom_index),
    .wdata_o      (),
    .wmask_o      (),
    .intg_error_o (rom_integrity_error),
    .rdata_i      (bus_rom_rdata),
    .rvalid_i     (bus_rom_rvalid),
    .rerror_i     (2'b00)
  );

  // Snoop on the "upstream" TL transaction to infer the address to pass to the PRINCE cipher.
  assign bus_rom_prince_index = (tl_rom_h2d_upstream.a_valid ?
                                 tl_rom_h2d_upstream.a_address[2 +: RomIndexWidth] :
                                 '0);

  // Unless there has been an injected fault, bus_rom_prince_index and bus_rom_rom_index should have
  // the same value.
  `ASSERT(BusRomIndicesMatch_A, bus_rom_prince_index == bus_rom_rom_index)

  // The mux ===================================================================

  logic mux_alert;

  rom_ctrl_mux #(
    .AW (RomIndexWidth),
    .DW (DataWidth)
  ) u_mux (
    .clk_i             (clk_i),
    .rst_ni            (rst_n),
    .sel_bus_i         (rom_select_bus),
    .bus_rom_addr_i    (bus_rom_rom_index),
    .bus_prince_addr_i (bus_rom_prince_index),
    .bus_req_i         (bus_rom_req),
    .bus_gnt_o         (bus_rom_gnt),
    .bus_rdata_o       (bus_rom_rdata),
    .bus_rvalid_o      (bus_rom_rvalid_raw),
    .chk_addr_i        (checker_rom_index),
    .chk_req_i         (checker_rom_req),
    .chk_rdata_o       (checker_rom_rdata),
    .rom_rom_addr_o    (rom_rom_index),
    .rom_prince_addr_o (rom_prince_index),
    .rom_req_o         (rom_req),
    .rom_scr_rdata_i   (rom_scr_rdata),
    .rom_clr_rdata_i   (rom_clr_rdata),
    .rom_rvalid_i      (rom_rvalid),
    .alert_o           (mux_alert)
  );

  // Squash all responses from the ROM to the bus if there's an internal integrity error from the
  // checker FSM or the mux. This avoids having to handle awkward corner cases in the mux: if
  // something looks bad, we'll complain and hang the bus transaction.
  //
  // Note that the two signals that go into internal_alert are both sticky. The mux explicitly
  // latches its alert_o output and the checker FSM jumps to an invalid scrap state when it sees an
  // error which, in turn, sets checker_alert.
  //
  // SEC_CM: BUS.LOCAL_ESC
  assign bus_rom_rvalid = bus_rom_rvalid_raw & !internal_alert;

  // The ROM itself ============================================================

  if (!SecDisableScrambling) begin : gen_rom_scramble_enabled

    // SEC_CM: MEM.SCRAMBLE
    rom_ctrl_scrambled_rom #(
      .MemInitFile (BootRomInitFile),
      .Width       (DataWidth),
      .Depth       (RomSizeWords),
      .ScrNonce    (RndCnstScrNonce),
      .ScrKey      (RndCnstScrKey)
    ) u_rom (
      .clk_i         (clk_i),
      .rst_ni        (rst_n),
      .req_i         (rom_req),
      .rom_addr_i    (rom_rom_index),
      .prince_addr_i (rom_prince_index),
      .rvalid_o      (rom_rvalid),
      .scr_rdata_o   (rom_scr_rdata),
      .clr_rdata_o   (rom_clr_rdata),
      .cfg_i         (rom_cfg_i)
    );

  end : gen_rom_scramble_enabled
  else begin : gen_rom_scramble_disabled

    // If scrambling is disabled then instantiate a normal ROM primitive (no PRINCE cipher etc.).
    // Note that this "raw memory" doesn't have ECC bits either.

    prim_rom_adv #(
      .Width       (DataWidth),
      .Depth       (RomSizeWords),
      .MemInitFile (BootRomInitFile)
    ) u_rom (
      .clk_i    (clk_i),
      .rst_ni   (rst_n),
      .req_i    (rom_req),
      .addr_i   (rom_rom_index),
      .rvalid_o (rom_rvalid),
      .rdata_o  (rom_scr_rdata),
      .cfg_i    (rom_cfg_i)
    );

    // There's no scrambling, so "scrambled" and "clear" rdata are equal.
    assign rom_clr_rdata = rom_scr_rdata;

    // Since we're not generating a keystream, we don't use the rom_prince_index at all
    logic unused_prince_index;
    assign unused_prince_index = ^rom_prince_index;

  end : gen_rom_scramble_disabled

  // Zero expand checker rdata to pass to KMAC
  assign kmac_rom_data = {{64-DataWidth{1'b0}}, checker_rom_rdata};

  // Register block ============================================================

  rom_ctrl_regs_reg2hw_t reg2hw;
  rom_ctrl_regs_hw2reg_t hw2reg;
  logic                  reg_integrity_error;

  rom_ctrl_regs_reg_top u_reg_regs (
    .clk_i      (clk_i),
    .rst_ni     (rst_n),
    .tl_i       (regs_tl_i),
    .tl_o       (regs_tl_o),
    .reg2hw     (reg2hw),
    .hw2reg     (hw2reg),
    .intg_err_o (reg_integrity_error),    // SEC_CM: BUS.INTEGRITY
    .devmode_i  (1'b1)
   );

  // The checker FSM ===========================================================

  logic [255:0] digest_q, exp_digest_q;
  logic [255:0] digest_d;
  logic         digest_de;
  logic [31:0]  exp_digest_word_d;
  logic         exp_digest_de;
  logic [2:0]   exp_digest_idx;

  logic         checker_alert;

  if (!SecDisableScrambling) begin : gen_fsm_scramble_enabled

    rom_ctrl_fsm #(
      .RomDepth (RomSizeWords),
      .TopCount (8)
    ) u_checker_fsm (
      .clk_i                (clk_i),
      .rst_ni               (rst_n),
      .digest_i             (digest_q),
      .exp_digest_i         (exp_digest_q),
      .digest_o             (digest_d),
      .digest_vld_o         (digest_de),
      .exp_digest_o         (exp_digest_word_d),
      .exp_digest_vld_o     (exp_digest_de),
      .exp_digest_idx_o     (exp_digest_idx),
      .pwrmgr_data_o        (pwrmgr_data_o),
      .keymgr_data_o        (keymgr_data_o),
      .kmac_rom_rdy_i       (kmac_rom_rdy),
      .kmac_rom_vld_o       (kmac_rom_vld),
      .kmac_rom_last_o      (kmac_rom_last),
      .kmac_done_i          (kmac_done),
      .kmac_digest_i        (kmac_digest),
      .kmac_err_i           (kmac_err),
      .rom_select_bus_o     (rom_select_bus),
      .rom_addr_o           (checker_rom_index),
      .rom_req_o            (checker_rom_req),
      .rom_data_i           (checker_rom_rdata[31:0]),
      .alert_o              (checker_alert)
    );

  end : gen_fsm_scramble_enabled
  else begin : gen_fsm_scramble_disabled

    // If scrambling is disabled, there's no checker FSM.

    assign digest_d = '0;
    assign digest_de = 1'b0;
    assign exp_digest_word_d = '0;
    assign exp_digest_de = 1'b0;
    assign exp_digest_idx = '0;

    assign pwrmgr_data_o = PWRMGR_DATA_DEFAULT;
    // Send something other than '1 or '0 because the key manager has an "all ones" and an "all
    // zeros" check.
    assign keymgr_data_o = '{data: {128{2'b10}}, valid: 1'b1};

    assign kmac_rom_vld = 1'b0;
    assign kmac_rom_last = 1'b0;

    // Always grant access to the bus. Setting this to a constant should mean the mux gets
    // synthesized away completely.
    assign rom_select_bus = MuBi4True;

    assign checker_rom_index = '0;
    assign checker_rom_req = 1'b0;
    assign checker_alert = 1'b0;

    logic unused_fsm_inputs;
    assign unused_fsm_inputs = ^{kmac_rom_rdy, kmac_done, kmac_digest, digest_q, exp_digest_q};

  end : gen_fsm_scramble_disabled

  // Register data =============================================================

  // DIGEST and EXP_DIGEST registers

  // Repack signals to convert between the view expected by rom_ctrl_reg_pkg for CSRs and the view
  // expected by rom_ctrl_fsm. Register 0 of a multi-reg appears as the low bits of the packed data.
  for (genvar i = 0; i < 8; i++) begin: gen_csr_digest
    localparam int unsigned TopBitInt = 32 * i + 31;
    localparam bit [7:0] TopBit = TopBitInt[7:0];

    assign hw2reg.digest[i].d = digest_d[TopBit -: 32];
    assign hw2reg.digest[i].de = digest_de;

    assign hw2reg.exp_digest[i].d = exp_digest_word_d;
    assign hw2reg.exp_digest[i].de = exp_digest_de && (i[2:0] == exp_digest_idx);

    assign digest_q[TopBit -: 32] = reg2hw.digest[i].q;
    assign exp_digest_q[TopBit -: 32] = reg2hw.exp_digest[i].q;
  end

  logic bus_integrity_error;
  assign bus_integrity_error = rom_reg_integrity_error | rom_integrity_error | reg_integrity_error;

  assign internal_alert = checker_alert | mux_alert;

  // FATAL_ALERT_CAUSE register
  assign hw2reg.fatal_alert_cause.checker_error.d  = internal_alert;
  assign hw2reg.fatal_alert_cause.checker_error.de = internal_alert;
  assign hw2reg.fatal_alert_cause.integrity_error.d  = bus_integrity_error;
  assign hw2reg.fatal_alert_cause.integrity_error.de = bus_integrity_error;

  // Alert generation ==========================================================

  logic [NumAlerts-1:0] alert_test;
  assign alert_test[AlertFatal] = reg2hw.alert_test.q &
                                  reg2hw.alert_test.qe;

  logic [NumAlerts-1:0] alerts;
  assign alerts[AlertFatal] = bus_integrity_error | checker_alert | mux_alert;

  for (genvar i = 0; i < NumAlerts; i++) begin: gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(i == AlertFatal)
    ) u_alert_sender (
      .clk_i,
      .rst_ni(rst_n),
      .alert_test_i  ( alert_test[i] ),
      .alert_req_i   ( alerts[i]     ),
      .alert_ack_o   (               ),
      .alert_state_o (               ),
      .alert_rx_i    ( alert_rx_i[i] ),
      .alert_tx_o    ( alert_tx_o[i] )
    );
  end

  // Asserts ===================================================================
  //
  // "ROM" TL interface: The d_valid and a_ready signals should be unconditionally defined. The
  // other signals in rom_tl_o (which are the other D channel signals) should be defined if d_valid.
  `ASSERT_KNOWN(RomTlODValidKnown_A, rom_tl_o.d_valid)
  `ASSERT_KNOWN(RomTlOAReadyKnown_A, rom_tl_o.a_ready)
  `ASSERT_KNOWN_IF(RomTlODDataKnown_A, rom_tl_o, rom_tl_o.d_valid)

  // "regs" TL interface: The d_valid and a_ready signals should be unconditionally defined. The
  // other signals in rom_tl_o (which are the other D channel signals) should be defined if d_valid.
  `ASSERT_KNOWN(RegsTlODValidKnown_A, regs_tl_o.d_valid)
  `ASSERT_KNOWN(RegsTlOAReadyKnown_A, regs_tl_o.a_ready)
  `ASSERT_KNOWN_IF(RegsTlODDataKnown_A, regs_tl_o, regs_tl_o.d_valid)

  // The assert_tx_o output should have a known value when out of reset
  `ASSERT_KNOWN(AlertTxOKnown_A, alert_tx_o)

  // Assertions to check that we've wired up our alert bits correctly
  if (!SecDisableScrambling) begin : gen_asserts_with_scrambling
    `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(CompareFsmAlert_A,
                                         gen_fsm_scramble_enabled.
                                         u_checker_fsm.u_compare.u_state_regs,
                                         alert_tx_o[AlertFatal])
    `ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(CheckerFsmAlert_A,
                                         gen_fsm_scramble_enabled.
                                         u_checker_fsm.u_state_regs,
                                         alert_tx_o[AlertFatal])
  end

  // The pwrmgr_data_o output (the "done" and "good" signals) should have a known value when out of
  // reset. (In theory, the "good" signal could be unknown when !done, but the stronger and simpler
  // assertion is also true, so we use that)
  `ASSERT_KNOWN(PwrmgrDataOKnown_A, pwrmgr_data_o)

  // The valid signal for keymgr_data_o should always be known when out of reset. The rest of the
  // struct (a data signal) should be known whenever the valid signal is true.
  `ASSERT_KNOWN(KeymgrDataOValidKnown_A, keymgr_data_o.valid)
  `ASSERT_KNOWN_IF(KeymgrDataODataKnown_A, keymgr_data_o, keymgr_data_o.valid)

  // The valid signal for kmac_data_o should always be known when out of reset. The rest of the
  // struct (data, strb and last) should be known whenever the valid signal is true.
  `ASSERT_KNOWN(KmacDataOValidKnown_A, kmac_data_o.valid)
  `ASSERT_KNOWN_IF(KmacDataODataKnown_A, kmac_data_o, kmac_data_o.valid)

  // Check that pwrmgr_data_o.good is stable when kmac_data_o.valid is asserted
  `ASSERT(StabilityChkKmac_A, kmac_data_o.valid && $past(kmac_data_o.valid)
          |-> $stable(pwrmgr_data_o.good))

  // Check that pwrmgr_data_o.good is stable when keymgr_data_o.valid is asserted
  `ASSERT(StabilityChkkeymgr_A, keymgr_data_o.valid && $past(keymgr_data_o.valid)
          |-> $stable(pwrmgr_data_o.good))

  // Check that pwrmgr_data_o.done is never de-asserted once asserted
  `ASSERT(PwrmgrDataChk_A, $rose(pwrmgr_data_o.done) |-> always !$fell(pwrmgr_data_o.done))

  // Check that keymgr_data_o.valid is never de-asserted once asserted
  `ASSERT(KeymgrValidChk_A, $rose(keymgr_data_o.valid) |-> always !$fell(keymgr_data_o.valid))

  // Check that rom_tl_o.d_valid is not asserted unless pwrmgr_data_o.done is asseterd.
  // This check ensures that all tl accesses are blocked until rom check is completed. You might
  // think we could check for a_ready, but that doesn't work because the TL to SRAM adapter has a
  // 1-entry cache that accepts the transaction (but doesn't reply)
  `ASSERT(TlAccessChk_A,
          (pwrmgr_data_o.done == prim_mubi_pkg::MuBi4False) |->
          (!rom_tl_o.d_valid || (rom_tl_o.d_valid && rom_tl_o.d_error)))

  // Check that whenever there is an alert triggered and FSM state is Invalid, there is no response
  // to read requests.
  `ASSERT(BusLocalEscChk_A,
          (gen_fsm_scramble_enabled.u_checker_fsm.state_d == rom_ctrl_pkg::Invalid)
          |-> always(!bus_rom_rvalid))
endmodule
