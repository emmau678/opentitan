// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Direct access interface for OTP controller.
//

`include "prim_assert.sv"

module otp_ctrl_dai
  import otp_ctrl_pkg::*;
  import otp_ctrl_reg_pkg::*;
(
  input                                  clk_i,
  input                                  rst_ni,
  // Init reqest from power manager
  input                                  init_req_i,
  output logic                           init_done_o,
  // Init request going to partitions
  output logic                           part_init_req_o,
  input  [NumPart-1:0]                   part_init_done_i,
  // Escalation input. This moves the FSM into a terminal state and locks down
  // the DAI.
  input lc_tx_t                          escalate_en_i,
  // Output error state of DAI, to be consumed by OTP error/alert logic.
  // Note that most errors are not recoverable and move the DAI FSM into
  // a terminal error state.
  output otp_err_e                       error_o,
  // Access/lock status from partitions
  input  part_access_t [NumPart-1:0]     part_access_i,
  // CSR interface
  input        [OtpByteAddrWidth-1:0]    dai_addr_i,
  input dai_cmd_e                        dai_cmd_i,
  input logic                            dai_req_i,
  input        [NumDaiWords-1:0][31:0]   dai_wdata_i,
  output logic                           dai_idle_o,     // wired to the status CSRs
  output logic                           dai_cmd_done_o, // this is used to raise an IRQ
  output logic [NumDaiWords-1:0][31:0]   dai_rdata_o,
  // OTP interface
  output logic                           otp_req_o,
  output prim_otp_cmd_e                  otp_cmd_o,
  output logic [OtpSizeWidth-1:0]        otp_size_o,
  output logic [OtpIfWidth-1:0]          otp_wdata_o,
  output logic [OtpAddrWidth-1:0]        otp_addr_o,
  input                                  otp_gnt_i,
  input                                  otp_rvalid_i,
  input  [ScrmblBlockWidth-1:0]          otp_rdata_i,
  input  otp_err_e                       otp_err_i,
  // Scrambling mutex request
  output logic                           scrmbl_mtx_req_o,
  input                                  scrmbl_mtx_gnt_i,
  // Scrambling datapath interface
  output otp_scrmbl_cmd_e                scrmbl_cmd_o,
  output logic [ConstSelWidth-1:0]       scrmbl_sel_o,
  output logic [ScrmblBlockWidth-1:0]    scrmbl_data_o,
  output logic                           scrmbl_valid_o,
  input  logic                           scrmbl_ready_i,
  input  logic                           scrmbl_valid_i,
  input  logic [ScrmblBlockWidth-1:0]    scrmbl_data_i
);

  ////////////////////////
  // Integration Checks //
  ////////////////////////

  import prim_util_pkg::vbits;

  localparam int CntWidth = OtpByteAddrWidth - $clog2(ScrmblBlockWidth/8);

  // Integration checks for parameters.
  `ASSERT_INIT(CheckNativeOtpWidth0_A, (ScrmblBlockWidth % OtpWidth) == 0)
  `ASSERT_INIT(CheckNativeOtpWidth1_A, (32 % OtpWidth) == 0)

  /////////////////////
  // DAI Control FSM //
  /////////////////////

  // Encoding generated with ./sparse-fsm-encode -d 5 -m 20 -n 12
  // Hamming distance histogram:
  //
  // 0:  --
  // 1:  --
  // 2:  --
  // 3:  --
  // 4:  --
  // 5:  ||||||||||||||| (30.53%)
  // 6:  |||||||||||||||||||| (38.42%)
  // 7:  |||||||| (15.79%)
  // 8:  |||| (8.42%)
  // 9:  | (3.68%)
  // 10:  (1.05%)
  // 11: | (2.11%)
  // 12: --
  //
  // Minimum Hamming distance: 5
  // Maximum Hamming distance: 11
  //
  typedef enum logic [11:0] {
    ResetSt       = 12'b000000011100,
    InitOtpSt     = 12'b010011000101,
    InitPartSt    = 12'b101011010111,
    IdleSt        = 12'b000010001011,
    ErrorSt       = 12'b010010110000,
    ReadSt        = 12'b111110000001,
    ReadWaitSt    = 12'b001111100011,
    DescrSt       = 12'b100101000110,
    DescrWaitSt   = 12'b011000000010,
    WriteSt       = 12'b001100111010,
    WriteWaitSt   = 12'b110111101111,
    ScrSt         = 12'b101010101000,
    ScrWaitSt     = 12'b111110011110,
    DigClrSt      = 12'b011101110100,
    DigReadSt     = 12'b001101001101,
    DigReadWaitSt = 12'b111001111001,
    DigSt         = 12'b100111011000,
    DigPadSt      = 12'b100000100101,
    DigFinSt      = 12'b010101010011,
    DigWaitSt     = 12'b010100101001
  } state_e;

  typedef enum logic [1:0] {
    OtpData = 2'b00,
    DaiData = 2'b01,
    ScrmblData = 2'b10
  } data_sel_e;


  typedef enum logic {
    PartOffset = 1'b0,
    DaiOffset = 1'b1
  } addr_sel_e;

  state_e state_d, state_q;
  logic [CntWidth-1:0] cnt_d, cnt_q;
  logic cnt_en, cnt_clr;
  otp_err_e error_d, error_q;
  logic data_en, data_clr;
  data_sel_e data_sel;
  addr_sel_e base_sel_d, base_sel_q;
  logic [ScrmblBlockWidth-1:0] data_q;
  logic [NumPartWidth-1:0] part_idx;
  logic [NumPart-1:0][OtpAddrWidth-1:0] digest_addr_lut;

  // Output partition error state.
  assign error_o       = error_q;
  // Working register is connected to data outputs.
  assign dai_rdata_o   = data_q;
  assign otp_wdata_o   = data_q;
  assign scrmbl_data_o = data_q;

  always_comb begin : p_fsm
    state_d = state_q;

    // Init signals
    init_done_o = 1'b1;
    part_init_req_o = 1'b0;

    // DAI signals
    dai_idle_o = 1'b0;
    dai_cmd_done_o = 1'b0;

    // OTP signals
    otp_req_o = 1'b0;
    otp_cmd_o = OtpInit;

    // Scrambling mutex
    scrmbl_mtx_req_o = 1'b0;

    // Scrambling datapath
    scrmbl_cmd_o   = LoadShadow;
    scrmbl_sel_o   = '0;
    scrmbl_valid_o = 1'b0;

    // Counter
    cnt_en  = 1'b0;
    cnt_clr = 1'b0;
    base_sel_d = base_sel_q;

    // Temporary data register
    data_en = 1'b0;
    data_clr = 1'b0;
    data_sel = OtpData;

    // Error Register
    error_d = error_q;

    unique case (state_q)
      ///////////////////////////////////////////////////////////////////
      // We get here after reset and wait until the power manager
      // requests OTP initialization. If initialization is requested,
      // an init command is written to the OTP macro, and we move on
      // to the InitOtpSt waiting state.
      ResetSt: begin
        init_done_o = 1'b0;
        data_clr = 1'b1;
        if (init_req_i) begin
          otp_req_o = 1'b1;
          if (otp_gnt_i) begin
            state_d = InitOtpSt;
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // We wait here unitl the OTP macro has initialized without
      // error. If an error occurred during this stage, we latch that
      // error and move into a terminal error  state.
      InitOtpSt: begin
        init_done_o = 1'b0;
        if (otp_rvalid_i) begin
          if ((!(otp_err_i inside {NoErr, OtpReadCorrErr}))) begin
            state_d = ErrorSt;
            error_d = otp_err_i;
          end else begin
            state_d = InitPartSt;
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Since the OTP macro is now functional, we can send out an
      // initialization request to all partitions and wait until they
      // all have initialized.
      InitPartSt: begin
        init_done_o = 1'b0;
        part_init_req_o = 1'b1;
        if (part_init_done_i == {NumPart{1'b1}}) begin
          state_d = IdleSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Idle state where we wait for incoming commands.
      // Invalid commands trigger a CmdInvErr, which is recoverable.
      IdleSt: begin
        dai_idle_o  = 1'b1;
        if (dai_req_i) begin
          // This clears previous (recoverable) errors.
          error_d = NoErr;
          // Clear the temporary data register.
          data_clr = 1'b1;
          unique case (dai_cmd_i)
            DaiRead:  begin
              state_d = ReadSt;
              base_sel_d = DaiOffset;
            end
            DaiWrite: begin
              // Fetch data block.
              data_sel = DaiData;
              data_en = 1'b1;
              base_sel_d = DaiOffset;
              // If this partition is scrambled, directly go to write scrambling first.
              if (PartInfo[part_idx].scrambled) begin
                state_d = ScrSt;
              end else begin
                state_d = WriteSt;
              end
            end
            DaiDigest: begin
              state_d = DigClrSt;
              scrmbl_mtx_req_o = 1'b1;
              base_sel_d = PartOffset;
            end
            default: begin
              // Invalid commands get caught here. This is a recoverable error.
              error_d = CmdInvErr;
            end
          endcase // dai_cmd_i
        end // dai_req_i
      end
      ///////////////////////////////////////////////////////////////////
      // Each time we request a block of data from OTP, we re-check
      // whether read access has been locked for this partition. If
      // that is the case, we immediately bail out. Otherwise, we
      // request a block of data from OTP.
      ReadSt: begin
        if (part_access_i[part_idx].read_lock == Unlocked) begin
          otp_req_o = 1'b1;
          otp_cmd_o = OtpRead;
          if (otp_gnt_i) begin
            state_d = ReadWaitSt;
          end
        end else begin
          state_d = IdleSt;
          error_d = AccessErr; // Signal this error, but do not go into terminal error state.
          dai_cmd_done_o = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for OTP response and write to readout register. Check
      // whether descrambling is  required or not. In case an OTP
      // transaction fails, latch the OTP error code, and jump to
      // terminal error state.
      ReadWaitSt: begin
        if (otp_rvalid_i) begin
          // Check OTP return code.
          if ((!(otp_err_i inside {NoErr, OtpReadCorrErr}))) begin
            state_d = ErrorSt;
            error_d = otp_err_i;
          end else begin
            data_en = 1'b1;
            if (PartInfo[part_idx].scrambled) begin
              state_d = DescrSt;
            end else begin
              state_d = IdleSt;
              dai_cmd_done_o = 1'b1;
            end
            // Signal soft ECC errors, but do not go into terminal error state.
            if (otp_err_i == OtpReadCorrErr) begin
              error_d = otp_err_i;
            end
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Descrambling state. This first acquires the scrambling
      // datapath mutex. Note that once the mutex is acquired, we have
      // exclusive access to the scrambling datapath until we release
      // the mutex by deasserting scrmbl_mtx_req_o.
      DescrSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        scrmbl_cmd_o = Decrypt;
        scrmbl_sel_o = PartInfo[part_idx].key_idx;
        if (scrmbl_mtx_gnt_i && scrmbl_ready_i) begin
          state_d = DescrWaitSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for the descrambled data to return. Note that we release
      // the mutex lock upon leaving this state.
      DescrWaitSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_sel_o = PartInfo[part_idx].key_idx;
        data_sel = ScrmblData;
        if (scrmbl_valid_i) begin
          state_d = IdleSt;
          data_en = 1'b1;
          dai_cmd_done_o = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // First, check whether write accesses are allowed to this
      // partition, and error out otherwise. Note that for buffered
      // partitions, we do not allow DAI writes to the digest offset.
      // Unbuffered partitions have SW managed digests, hence that
      // check is not needed in that case. The LC partition is
      // permanently write locked and can hence not be written via the DAI.
      WriteSt: begin
        if (part_access_i[part_idx].write_lock == Unlocked &&
            // If this is a HW digest write to a buffered partition.
            ((PartInfo[part_idx].variant == Buffered && PartInfo[part_idx].hw_digest &&
              base_sel_q == PartOffset && otp_addr_o == digest_addr_lut[part_idx]) ||
             // If this is a non HW digest write to a buffered partition.
             (PartInfo[part_idx].variant == Buffered && PartInfo[part_idx].hw_digest &&
              base_sel_q == DaiOffset && otp_addr_o < digest_addr_lut[part_idx]) ||
             // If this is a write to an unbuffered partition
             (PartInfo[part_idx].variant != Buffered && base_sel_q == DaiOffset))) begin
          otp_req_o = 1'b1;
          otp_cmd_o = OtpWrite;
          if (otp_gnt_i) begin
            state_d = WriteWaitSt;
          end
        end else begin
          state_d = IdleSt;
          error_d = AccessErr; // Signal this error, but do not go into terminal error state.
          dai_cmd_done_o = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for OTP response, and then go back to idle. In case an
      // OTP transaction fails, latch the OTP error code, and jump to
      // terminal error state.
      WriteWaitSt: begin
        if (otp_rvalid_i) begin
          // Check OTP return code. Note that non-blank errors are recoverable.
          if ((!(otp_err_i inside {NoErr, OtpWriteBlankErr}))) begin
            state_d = ErrorSt;
            error_d = otp_err_i;
          end else begin
            state_d = IdleSt;
            dai_cmd_done_o = 1'b1;
            // Signal non-blank state, but do not go to terminal error state.
            if (otp_err_i == OtpWriteBlankErr) begin
              error_d = otp_err_i;
            end
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Scrambling state. This first acquires the scrambling
      // datapath mutex. Note that once the mutex is acquired, we have
      // exclusive access to the scrambling datapath until we release
      // the mutex by deasserting scrmbl_mtx_req_o.
      ScrSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        scrmbl_cmd_o = Encrypt;
        scrmbl_sel_o = PartInfo[part_idx].key_idx;
        if (scrmbl_mtx_gnt_i && scrmbl_ready_i) begin
          state_d = ScrWaitSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for the scrambled data to return. Note that we release
      // the mutex lock upon leaving this state.
      ScrWaitSt: begin
        scrmbl_mtx_req_o = 1'b1;
        data_sel = ScrmblData;
        if (scrmbl_valid_i) begin
          state_d = WriteSt;
          data_en = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // First, acquire the mutex for the digest and clear the digest state.
      DigClrSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        // Need to reset the digest state and set digest mode to "standard".
        scrmbl_sel_o = StandardMode;
        scrmbl_cmd_o = DigestInit;
        if (scrmbl_mtx_gnt_i && scrmbl_ready_i) begin
          state_d = DigReadSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // This requests a 64bit block to be pushed into the digest datapath.
      // We also check here whether the partition has been write locked.
      DigReadSt: begin
        scrmbl_mtx_req_o = 1'b1;
        if (part_access_i[part_idx].read_lock == Unlocked &&
            part_access_i[part_idx].write_lock == Unlocked) begin
          otp_req_o = 1'b1;
          otp_cmd_o = OtpRead;
          if (otp_gnt_i) begin
            state_d = DigReadWaitSt;
          end
        end else begin
          state_d = IdleSt;
          error_d = AccessErr; // Signal this error, but do not go into terminal error state.
          dai_cmd_done_o = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for OTP response and write to readout register. Check
      // whether descrambling is required or not. In case an OTP
      // transaction fails, latch the OTP error code, and jump to
      // terminal error state.
      DigReadWaitSt: begin
        scrmbl_mtx_req_o = 1'b1;
        if (otp_rvalid_i) begin
          cnt_en = 1'b1;
          // Check OTP return code.
          if ((!(otp_err_i inside {NoErr, OtpReadCorrErr}))) begin
            state_d = ErrorSt;
            error_d = otp_err_i;
          end else begin
            data_en = 1'b1;
            state_d = DigSt;
            // Signal soft ECC errors, but do not go into terminal error state.
            if (otp_err_i == OtpReadCorrErr) begin
              error_d = otp_err_i;
            end
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Push the word read into the scrambling datapath.  The last
      // block is repeated in case the number blocks in this partition
      // is odd.
      DigSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        // No need to digest the digest value itself
        if (otp_addr_o == digest_addr_lut[part_idx]) begin
          // Trigger digest round in case this is the second block in a row.
          if (cnt_q[0]) begin
            scrmbl_cmd_o = Digest;
            if (scrmbl_ready_i) begin
              state_d = DigFinSt;
            end
          // Otherwise, just load low word and go to padding state.
          end else if (scrmbl_ready_i) begin
            state_d = DigPadSt;
          end
        end else begin
          // Trigger digest round in case this is the second block in a row.
          if (cnt_q[0]) begin
            scrmbl_cmd_o = Digest;
          end
          // Go back and fetch more data blocks.
          if (scrmbl_ready_i) begin
            state_d = DigReadSt;
          end
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Padding state, just repeat the last block and go to digest
      // finalization.
      DigPadSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        scrmbl_cmd_o = Digest;
        if (scrmbl_ready_i) begin
          state_d = DigFinSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Trigger digest finalization and go wait for the result.
      DigFinSt: begin
        scrmbl_mtx_req_o = 1'b1;
        scrmbl_valid_o = 1'b1;
        scrmbl_cmd_o = DigestFinalize;
        if (scrmbl_ready_i) begin
          state_d = DigWaitSt;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Wait for the digest to return, and write the result to OTP.
      // Note that the write address will be correct in this state,
      // since the counter has been stepped to the correct address as
      // part of the readout sequence, and the correct size for this
      // access has been loaded before.
      DigWaitSt: begin
        scrmbl_mtx_req_o = 1'b1;
        data_sel = ScrmblData;
        if (scrmbl_valid_i) begin
          state_d = WriteSt;
          data_en = 1'b1;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // Terminal Error State. This locks access to the DAI. Make sure
      // an FsmErr error code is assigned here, in case no error code has
      // been assigned yet.
      ErrorSt: begin
        if (!error_q) begin
          error_d = FsmErr;
        end
      end
      ///////////////////////////////////////////////////////////////////
      // We should never get here. If we do (e.g. via a malicious
      // glitch), error out immediately.
      default: begin
        state_d = ErrorSt;
      end
      ///////////////////////////////////////////////////////////////////
    endcase // state_q

    if (state_q != ErrorSt) begin
      // Unconditionally jump into the terminal error state in case of
      // escalation, and lock access to the DAI down.
      if (escalate_en_i != Off) begin
        state_d = ErrorSt;
        error_d = EscErr;
      end
    end
  end

  ////////////////////////////
  // Partition Select Logic //
  ////////////////////////////

  // This checks which partition the address belongs to by comparing
  // the incoming address to the partition address ranges. The onehot
  // bitvector generated by the parallel comparisons is fed into a
  // binary tree that determines the partition index with O(log(N)) delay.

  logic [NumPart-1:0] part_sel_oh;
  for (genvar k = 0; k < NumPart; k++) begin : gen_part_sel
    localparam logic [OtpByteAddrWidth:0] PartEnd = (OtpByteAddrWidth+1)'(PartInfo[k].offset) +
                                                    (OtpByteAddrWidth+1)'(PartInfo[k].size);
    assign part_sel_oh[k] = (dai_addr_i >= PartInfo[k].offset) & ({1'b0, dai_addr_i} < PartEnd);
    // Needed for other address and access checks.
    localparam logic [OtpByteAddrWidth-1:0] DigestOffset = OtpByteAddrWidth'(PartEnd -
                                                                             ScrmblBlockWidth/8);
    assign digest_addr_lut[k] = DigestOffset >> OtpAddrShift;
  end

  `ASSERT(PartSelMustBeOnehot_A, $onehot0(part_sel_oh))

  prim_arbiter_fixed #(
    .N(NumPart),
    .EnDataPort(0)
  ) i_prim_arbiter_fixed (
    .clk_i,
    .rst_ni,
    .req_i   ( part_sel_oh    ),
    .data_i  ( '{default: '0} ),
    .gnt_o   (                ), // unused
    .idx_o   ( part_idx       ),
    .valid_o (                ), // unused
    .data_o  (                ), // unused
    .ready_i ( 1'b0           )
  );

  /////////////////////////////////////
  // Address Calculations for Digest //
  /////////////////////////////////////

  // Depending on whether this is a 32bit or 64bit partition, we cut off the lower address bits.
  logic [OtpByteAddrWidth-1:0] addr_base;
  assign addr_base = (base_sel_q == PartOffset)     ? PartInfo[part_idx].offset :
                     (PartInfo[part_idx].scrambled) ? {dai_addr_i[OtpByteAddrWidth-1:3], 3'h0} :
                                                      {dai_addr_i[OtpByteAddrWidth-1:2], 2'h0};

  // OTP transaction sizes are 64bit for scrambled partitions, and when digesting.
  // Otherwise, they are 32bit.
  assign otp_size_o = (PartInfo[part_idx].scrambled || base_sel_q == PartOffset) ?
                      OtpSizeWidth'(unsigned'(ScrmblBlockWidth / OtpWidth - 1)) :
                      OtpSizeWidth'(unsigned'(32 / OtpWidth - 1));

  // Address counter - this is only used for computing a digest, hence the increment is
  // fixed to 8 byte.
  assign cnt_d = (cnt_clr) ? '0           :
                 (cnt_en)  ? cnt_q + 1'b1 : cnt_q;

  // Note that OTP works on halfword (16bit) addresses, hence need to
  // shift the addresses appropriately.
  logic [OtpByteAddrWidth-1:0] addr_calc;
  assign addr_calc = {cnt_q, {$clog2(ScrmblBlockWidth/8){1'b0}}} + addr_base;
  assign otp_addr_o = addr_calc >> OtpAddrShift;

  ///////////////
  // Registers //
  ///////////////

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      state_q        <= ResetSt;
      error_q        <= NoErr;
      cnt_q         <= '0;
      data_q         <= '0;
      base_sel_q     <= DaiOffset;
    end else begin
      state_q        <= state_d;
      error_q        <= error_d;
      cnt_q          <= cnt_d;
      base_sel_q     <= base_sel_d;

      // Working register
      if (data_clr) begin
        data_q <= '0;
      end else if (data_en) begin
        if (data_sel == ScrmblData) begin
          data_q <= scrmbl_data_i;
        end else if (data_sel == DaiData) begin
          data_q <= dai_wdata_i;
        end else begin
          data_q <= otp_rdata_i;
        end
      end
    end
  end

  ////////////////
  // Assertions //
  ////////////////

  // Known assertions
  `ASSERT_KNOWN(InitDoneKnown_A,     init_done_o)
  `ASSERT_KNOWN(PartInitReqKnown_A,  part_init_req_o)
  `ASSERT_KNOWN(ErrorKnown_A,        error_o)
  `ASSERT_KNOWN(DaiIdleKnown_A,      dai_idle_o)
  `ASSERT_KNOWN(DaiRdataKnown_A,     dai_rdata_o)
  `ASSERT_KNOWN(OtpReqKnown_A,       otp_req_o)
  `ASSERT_KNOWN(OtpCmdKnown_A,       otp_cmd_o)
  `ASSERT_KNOWN(OtpSizeKnown_A,      otp_size_o)
  `ASSERT_KNOWN(OtpWdataKnown_A,     otp_wdata_o)
  `ASSERT_KNOWN(OtpAddrKnown_A,      otp_addr_o)
  `ASSERT_KNOWN(ScrmblMtxReqKnown_A, scrmbl_mtx_req_o)
  `ASSERT_KNOWN(ScrmblCmdKnown_A,    scrmbl_cmd_o)
  `ASSERT_KNOWN(ScrmblSelKnown_A,    scrmbl_sel_o)
  `ASSERT_KNOWN(ScrmblDataKnown_A,   scrmbl_data_o)
  `ASSERT_KNOWN(ScrmblValidKnown_A,  scrmbl_valid_o)

  // OTP error response
  `ASSERT(OtpErrorState_A,
      state_q inside {InitOtpSt, ReadWaitSt, WriteWaitSt, DigReadWaitSt} && otp_rvalid_i &&
      !(otp_err_i inside {NoErr, OtpReadCorrErr})
      |=>
      state_q == ErrorSt && error_o == $past(otp_err_i))

endmodule : otp_ctrl_dai
