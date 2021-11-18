// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

/**
 * OTBN Controller
 */
module otbn_controller
  import otbn_pkg::*;
#(
  // Size of the instruction memory, in bytes
  parameter int ImemSizeByte = 4096,
  // Size of the data memory, in bytes
  parameter int DmemSizeByte = 4096,
  // Enable internal secure wipe
  parameter bit SecWipeEn  = 1'b0,

  localparam int ImemAddrWidth = prim_util_pkg::vbits(ImemSizeByte),
  localparam int DmemAddrWidth = prim_util_pkg::vbits(DmemSizeByte)
) (
  input  logic  clk_i,
  input  logic  rst_ni,

  input  logic  start_i, // start the processing at address zero
  output logic  locked_o, // OTBN in locked state and must be reset to perform any further actions

  output err_bits_t err_bits_o, // valid when done_o is asserted

  // Next instruction selection (to instruction fetch)
  output logic                     insn_fetch_req_valid_o,
  output logic [ImemAddrWidth-1:0] insn_fetch_req_addr_o,
  // Error from fetch requested last cycle
  input  logic                     insn_fetch_err_i,

  // Fetched/decoded instruction
  input  logic                     insn_valid_i,
  input  logic                     insn_illegal_i,
  input  logic [ImemAddrWidth-1:0] insn_addr_i,

  // Decoded instruction data
  input insn_dec_base_t       insn_dec_base_i,
  input insn_dec_bignum_t     insn_dec_bignum_i,
  input insn_dec_shared_t     insn_dec_shared_i,

  // Base register file
  output logic [4:0]               rf_base_wr_addr_o,
  output logic                     rf_base_wr_en_o,
  output logic                     rf_base_wr_commit_o,
  output logic [31:0]              rf_base_wr_data_no_intg_o,
  output logic [BaseIntgWidth-1:0] rf_base_wr_data_intg_o,
  output logic                     rf_base_wr_data_intg_sel_o,

  output logic [4:0]               rf_base_rd_addr_a_o,
  output logic                     rf_base_rd_en_a_o,
  input  logic [BaseIntgWidth-1:0] rf_base_rd_data_a_intg_i,
  output logic [4:0]               rf_base_rd_addr_b_o,
  output logic                     rf_base_rd_en_b_o,
  input  logic [BaseIntgWidth-1:0] rf_base_rd_data_b_intg_i,
  output logic                     rf_base_rd_commit_o,

  input  logic         rf_base_call_stack_err_i,
  input  logic         rf_base_rd_data_err_i,

  // Bignum register file (WDRs)
  output logic [4:0]         rf_bignum_wr_addr_o,
  output logic [1:0]         rf_bignum_wr_en_o,
  output logic [WLEN-1:0]    rf_bignum_wr_data_no_intg_o,
  output logic [ExtWLEN-1:0] rf_bignum_wr_data_intg_o,
  output logic               rf_bignum_wr_data_intg_sel_o,

  output logic [4:0]         rf_bignum_rd_addr_a_o,
  output logic               rf_bignum_rd_en_a_o,
  input  logic [ExtWLEN-1:0] rf_bignum_rd_data_a_intg_i,

  output logic [4:0]         rf_bignum_rd_addr_b_o,
  output logic               rf_bignum_rd_en_b_o,
  input  logic [ExtWLEN-1:0] rf_bignum_rd_data_b_intg_i,

  input  logic               rf_bignum_rd_data_err_i,

  // Execution units

  // Base ALU
  output alu_base_operation_t  alu_base_operation_o,
  output alu_base_comparison_t alu_base_comparison_o,
  input  logic [31:0]          alu_base_operation_result_i,
  input  logic                 alu_base_comparison_result_i,

  // Bignum ALU
  output alu_bignum_operation_t alu_bignum_operation_o,
  input  logic [WLEN-1:0]       alu_bignum_operation_result_i,
  input  logic                  alu_bignum_selection_flag_i,

  // Bignum MAC
  output mac_bignum_operation_t mac_bignum_operation_o,
  input  logic [WLEN-1:0]       mac_bignum_operation_result_i,
  output logic                  mac_bignum_en_o,

  // LSU
  output logic                     lsu_load_req_o,
  output logic                     lsu_store_req_o,
  output insn_subset_e             lsu_req_subset_o,
  output logic [DmemAddrWidth-1:0] lsu_addr_o,

  output logic [BaseIntgWidth-1:0] lsu_base_wdata_o,
  output logic [ExtWLEN-1:0]       lsu_bignum_wdata_o,

  input  logic [BaseIntgWidth-1:0] lsu_base_rdata_i,
  input  logic [ExtWLEN-1:0]       lsu_bignum_rdata_i,
  input  logic                     lsu_rdata_err_i,

  // Internal Special-Purpose Registers (ISPRs)
  output ispr_e                       ispr_addr_o,
  output logic [31:0]                 ispr_base_wdata_o,
  output logic [BaseWordsPerWLEN-1:0] ispr_base_wr_en_o,
  output logic [WLEN-1:0]             ispr_bignum_wdata_o,
  output logic                        ispr_bignum_wr_en_o,
  input  logic [WLEN-1:0]             ispr_rdata_i,

  output logic rnd_req_o,
  output logic rnd_prefetch_req_o,
  input  logic rnd_valid_i,

  // Secure Wipe
  input  logic secure_wipe_running_i,
  output logic start_secure_wipe_o,
  input  logic sec_wipe_zero_i,

  input  logic        state_reset_i,
  output logic [31:0] insn_cnt_o,
  input  logic        bus_intg_violation_i,
  input  logic        illegal_bus_access_i,
  input  logic        lifecycle_escalation_i,
  input  logic        software_errs_fatal_i
);
  otbn_state_e state_q, state_d;

  logic err;
  logic software_err;
  logic non_insn_addr_software_err;
  logic fatal_err;
  logic done_complete;
  logic executing;

  logic insn_fetch_req_valid_raw;

  logic stall;
  logic ispr_stall;
  logic mem_stall;
  logic jump_or_branch;
  logic branch_taken;
  logic insn_executing;
  logic [ImemAddrWidth-1:0] branch_target;
  logic                     branch_target_overflow;
  logic [ImemAddrWidth:0]   next_insn_addr_wide;
  logic [ImemAddrWidth-1:0] next_insn_addr;

  csr_e                                csr_addr;
  logic [$clog2(BaseWordsPerWLEN)-1:0] csr_sub_addr;
  logic [31:0]                         csr_rdata_raw;
  logic [31:0]                         csr_rdata;
  logic [BaseWordsPerWLEN-1:0]         csr_rdata_mux [32];
  logic [31:0]                         csr_wdata_raw;
  logic [31:0]                         csr_wdata;

  wsr_e                                wsr_addr;
  logic [WLEN-1:0]                     wsr_wdata;

  ispr_e                               ispr_addr_base;
  logic [$clog2(BaseWordsPerWLEN)-1:0] ispr_word_addr_base;
  logic [BaseWordsPerWLEN-1:0]         ispr_word_sel_base;

  ispr_e                               ispr_addr_bignum;

  logic                                ispr_wr_insn, ispr_rd_insn;
  logic                                ispr_wr_base_insn;
  logic                                ispr_wr_bignum_insn;

  logic lsu_load_req_raw;
  logic lsu_store_req_raw;

  // Register read data with integrity stripped off
  logic [31:0]     rf_base_rd_data_a_no_intg;
  logic [31:0]     rf_base_rd_data_b_no_intg;
  logic [WLEN-1:0] rf_bignum_rd_data_a_no_intg;
  logic [WLEN-1:0] rf_bignum_rd_data_b_no_intg;

  logic [ExtWLEN-1:0] selection_result;

  // Computed increments for indirect register index and memory address in BN.LID/BN.SID/BN.MOVR
  // instructions.
  logic [5:0]  rf_base_rd_data_a_inc;
  logic [5:0]  rf_base_rd_data_b_inc;
  logic [26:0] rf_base_rd_data_a_wlen_word_inc;

  // Read/Write enables for base register file before illegal instruction encoding are factored in
  logic rf_base_rd_en_a_raw, rf_base_rd_en_b_raw, rf_base_wr_en_raw;

  // Output of mux taking the above increments as inputs and choosing one to write back to base
  // register file with appropriate zero extension and padding to give a 32-bit result.
  logic [31:0]              increment_out;

  // Loop control, used to start a new loop
  logic        loop_start_req;
  logic        loop_start_commit;
  logic        loop_reset;
  logic [11:0] loop_bodysize;
  logic [31:0] loop_iterations;

  // Loop generated jumps. The loop controller asks to jump when execution reaches the end of a loop
  // body that hasn't completed all of its iterations.
  logic                     loop_jump;
  logic [ImemAddrWidth-1:0] loop_jump_addr;

  logic [WLEN-1:0] mac_bignum_rf_wr_data;

  logic csr_illegal_addr, wsr_illegal_addr, ispr_illegal_addr;
  logic imem_addr_err, loop_err, ispr_err;
  logic dmem_addr_err, dmem_addr_unaligned_base, dmem_addr_unaligned_bignum, dmem_addr_overflow;
  logic illegal_insn_static;

  logic rf_a_indirect_err, rf_b_indirect_err, rf_d_indirect_err, rf_indirect_err;

  logic [31:0] insn_cnt_d, insn_cnt_q;

  logic [4:0] ld_insn_bignum_wr_addr_q;
  err_bits_t err_bits;
  // Only used with SecWipeEn == 1
  logic      err_bits_en;

  // Stall a cycle on loads to allow load data writeback to happen the following cycle. Stall not
  // required on stores as there is no response to deal with.
  // TODO: Possibility of error response on store? Probably still don't need to stall in that case
  // just ensure incoming store error stops anything else happening.
  assign mem_stall = lsu_load_req_raw;

  // Reads to RND must stall until data is available
  assign ispr_stall = rnd_req_o & ~rnd_valid_i;

  assign stall = mem_stall | ispr_stall;

  // OTBN is done when it was executing something (in state OtbnStateUrndRefresh, OtbnStateRun or
  // OtbnStateStall) and either it executes an ecall or an error occurs. A pulse on the done signal
  // raises the 'done' interrupt and also tells the top-level to update its err_bits status
  // register.
  //
  // The calculation that ecall triggered done is factored out as `done_complete` to avoid logic
  // loops in the error handling logic.
  assign done_complete = (insn_valid_i & insn_dec_shared_i.ecall_insn);
  assign executing = (state_q == OtbnStateUrndRefresh) ||
                     (state_q == OtbnStateRun) ||
                     (state_q == OtbnStateStall);

  assign locked_o = state_q == OtbnStateLocked;
  assign start_secure_wipe_o = executing & (done_complete | err) & ~secure_wipe_running_i;

  assign jump_or_branch = (insn_valid_i &
                           (insn_dec_shared_i.branch_insn | insn_dec_shared_i.jump_insn));

  // Branch taken when there is a valid branch instruction and comparison passes or a valid jump
  // instruction (which is always taken)
  assign branch_taken = insn_valid_i &
                        ((insn_dec_shared_i.branch_insn & alu_base_comparison_result_i) |
                         insn_dec_shared_i.jump_insn);
  // Branch target computed by base ALU (PC + imm)
  assign branch_target = alu_base_operation_result_i[ImemAddrWidth-1:0];
  assign branch_target_overflow = |alu_base_operation_result_i[31:ImemAddrWidth];

  assign next_insn_addr_wide = {1'b0, insn_addr_i} + 'd4;
  assign next_insn_addr = next_insn_addr_wide[ImemAddrWidth-1:0];

  always_comb begin
    state_d                  = state_q;
    // `insn_fetch_req_valid_raw` is the value `insn_fetch_req_valid_o` before any errors are
    // considered.
    insn_fetch_req_valid_raw = 1'b0;
    insn_fetch_req_addr_o    = '0;
    err_bits_en              = 1'b0;

    // TODO: Harden state machine
    // TODO: Jumps/branches
    unique case (state_q)
      OtbnStateHalt: begin
        if (start_i) begin
          state_d = OtbnStateRun;

          insn_fetch_req_addr_o    = '0;
          insn_fetch_req_valid_raw = 1'b1;

          // Enable error bits to zero them on start
          err_bits_en = 1'b1;
        end
      end
      OtbnStateRun: begin
        insn_fetch_req_valid_raw = 1'b1;

        if (done_complete) begin
          state_d                  = OtbnStateHalt;
          insn_fetch_req_valid_raw = 1'b0;
        end else begin
          // When stalling refetch the same instruction to keep decode inputs constant
          if (stall) begin
            state_d               = OtbnStateStall;
            insn_fetch_req_addr_o = insn_addr_i;
          end else begin
            if (branch_taken) begin
              insn_fetch_req_addr_o = branch_target;
            end else if (loop_jump) begin
              insn_fetch_req_addr_o = loop_jump_addr;
            end else begin
              insn_fetch_req_addr_o = next_insn_addr;
            end
          end
        end
      end
      OtbnStateStall: begin
        insn_fetch_req_valid_raw = 1'b1;

        // When stalling refetch the same instruction to keep decode inputs constant
        if (stall) begin
          state_d               = OtbnStateStall;
          insn_fetch_req_addr_o = insn_addr_i;
        end else begin
          if (loop_jump) begin
            insn_fetch_req_addr_o = loop_jump_addr;
          end else begin
            insn_fetch_req_addr_o = next_insn_addr;
          end

          state_d = OtbnStateRun;
        end
      end
      OtbnStateLocked: begin
        insn_fetch_req_valid_raw = 1'b0;
        state_d                  = OtbnStateLocked;
      end
      default: ;
    endcase

    // On any error immediately halt, either going to OtbnStateLocked or OtbnStateHalt depending on
    // whether it was a fatal error.
    if (err) begin
      if (!secure_wipe_running_i) begin
        // Capture error bits on error unless a secure wipe is in progress
        err_bits_en = 1'b1;
      end

      if (fatal_err) begin
        state_d = OtbnStateLocked;
      end else begin
        state_d = OtbnStateHalt;
      end
    end

    // Regardless of what happens above enforce staying in OtnbStateLocked.
    if (state_q == OtbnStateLocked) begin
      state_d = OtbnStateLocked;
    end
  end

  // Anything that moves us or keeps us in the stall state should cause `stall` to be asserted
  `ASSERT(StallIfNextStateStall, insn_valid_i & (state_d == OtbnStateStall) |-> stall)

  assign insn_fetch_req_valid_o = err ? 1'b0 : insn_fetch_req_valid_raw;

  // Determine if there are any errors related to the Imem fetch address.
  always_comb begin
    imem_addr_err = 1'b0;

    if (insn_fetch_req_valid_raw) begin
      if (|insn_fetch_req_addr_o[1:0]) begin
        // Imem address is unaligned
        imem_addr_err = 1'b1;
      end else if (branch_taken) begin
        imem_addr_err = branch_target_overflow;
      end else begin
        imem_addr_err = next_insn_addr_wide[ImemAddrWidth];
      end
    end
  end

  // Instruction is illegal based on the static properties of the instruction bits (illegal encoding
  // or illegal WSR/CSR referenced).
  assign illegal_insn_static = insn_illegal_i | ispr_err;

  assign err_bits.fatal_software       = software_err & software_errs_fatal_i;
  assign err_bits.lifecycle_escalation = lifecycle_escalation_i;
  assign err_bits.illegal_bus_access   = illegal_bus_access_i;
  assign err_bits.bad_internal_state   = 0;
  assign err_bits.bus_intg_violation   = bus_intg_violation_i;
  assign err_bits.reg_intg_violation   = rf_base_rd_data_err_i | rf_bignum_rd_data_err_i;
  assign err_bits.dmem_intg_violation  = lsu_rdata_err_i;
  assign err_bits.imem_intg_violation  = insn_fetch_err_i;
  assign err_bits.illegal_insn         = illegal_insn_static | rf_indirect_err;
  assign err_bits.bad_data_addr        = dmem_addr_err;
  assign err_bits.loop                 = loop_err;
  assign err_bits.call_stack           = rf_base_call_stack_err_i;
  assign err_bits.bad_insn_addr        = imem_addr_err & ~non_insn_addr_software_err;

  // All software errors that aren't bad_insn_addr. Factored into bad_insn_addr so it is only raised
  // if other software errors haven't ocurred. As bad_insn_addr relates to the next instruction
  // begin fetched it cannot occur if the current instruction has seen an error and failed to
  // execute.
  assign non_insn_addr_software_err = |{err_bits.illegal_insn,
                                        err_bits.bad_data_addr,
                                        err_bits.loop,
                                        err_bits.call_stack};

  assign software_err = |{err_bits.illegal_insn,
                          err_bits.bad_data_addr,
                          err_bits.loop,
                          err_bits.call_stack,
                          err_bits.bad_insn_addr};

  assign fatal_err = |{err_bits.fatal_software,
                       err_bits.lifecycle_escalation,
                       err_bits.illegal_bus_access,
                       err_bits.bus_intg_violation,
                       err_bits.reg_intg_violation,
                       err_bits.dmem_intg_violation,
                       err_bits.imem_intg_violation};



  if (SecWipeEn) begin: gen_sec_wipe
    err_bits_t err_bits_d, err_bits_q;

    assign err_bits_d = err_bits;
    assign err_bits_o = err_bits_q;

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        err_bits_q.fatal_software <= 1'b0;
        err_bits_q.lifecycle_escalation <= 1'b0;
        err_bits_q.illegal_bus_access  <= 1'b0;
        err_bits_q.bus_intg_violation <= 1'b0;
        err_bits_q.reg_intg_violation  <= 1'b0;
        err_bits_q.dmem_intg_violation <= 1'b0;
        err_bits_q.imem_intg_violation <= 1'b0;
        err_bits_q.illegal_insn <= 1'b0;
        err_bits_q.bad_data_addr <= 1'b0;
        err_bits_q.loop   <= 1'b0;
        err_bits_q.call_stack <= 1'b0;
        err_bits_q.bad_insn_addr <= 1'b0;
      end else if (err_bits_en) begin
        err_bits_q <= err_bits_d;
      end
    end

  end
  else begin: gen_bypass_sec_wipe
    logic unused_err_bits_en;

    assign unused_err_bits_en = err_bits_en;
    assign err_bits_o = err_bits;
  end

  assign err = software_err | fatal_err;

  // Instructions must not execute if there is an error
  assign insn_executing = insn_valid_i & ~err;

  `ASSERT(ErrBitSetOnErr, err |-> |err_bits_o)
  `ASSERT(ErrSetOnFatalErr, fatal_err |-> err)
  `ASSERT(SoftwareErrIfNonInsnAddrSoftwareErr, non_insn_addr_software_err |-> software_err)

  `ASSERT(ControllerStateValid, state_q inside {OtbnStateHalt, OtbnStateRun,
                                                OtbnStateStall, OtbnStateLocked})
  // Branch only takes effect in OtbnStateRun so must not go into stall state for branch
  // instructions.
  `ASSERT(NoStallOnBranch,
      insn_valid_i & insn_dec_shared_i.branch_insn |-> state_q != OtbnStateStall)

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= OtbnStateHalt;
    end else begin
      state_q <= state_d;
    end
  end

  always_comb begin
    if (state_reset_i || state_q == OtbnStateLocked) begin
      insn_cnt_d = 32'd0;
    end else if (insn_executing & ~stall & (insn_cnt_q != 32'hffffffff)) begin
      insn_cnt_d = insn_cnt_q + 32'd1;
    end else begin
      insn_cnt_d = insn_cnt_q;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      insn_cnt_q <= 32'd0;
    end else begin
      insn_cnt_q <= insn_cnt_d;
    end
  end

  assign insn_cnt_o = insn_cnt_q;

  assign loop_reset = state_reset_i | sec_wipe_zero_i;

  otbn_loop_controller #(
    .ImemAddrWidth(ImemAddrWidth)
  ) u_otbn_loop_controller (
    .clk_i,
    .rst_ni,

    .state_reset_i       (loop_reset),

    .insn_valid_i,
    .insn_addr_i,
    .next_insn_addr_i    (next_insn_addr),

    .loop_start_req_i    (loop_start_req),
    .loop_start_commit_i (loop_start_commit),
    .loop_bodysize_i     (loop_bodysize),
    .loop_iterations_i   (loop_iterations),

    .loop_jump_o         (loop_jump),
    .loop_jump_addr_o    (loop_jump_addr),
    .loop_err_o          (loop_err),

    .jump_or_branch_i    (jump_or_branch),
    .otbn_stall_i        (stall)
  );

  // loop_start_req indicates the instruction wishes to start a loop, loop_start_commit confirms it
  // should occur.
  assign loop_start_req    = insn_valid_i & insn_dec_shared_i.loop_insn;
  assign loop_start_commit = insn_executing;
  assign loop_bodysize     = insn_dec_base_i.loop_bodysize;
  assign loop_iterations   = insn_dec_base_i.loop_immediate ? insn_dec_base_i.i :
                                                              rf_base_rd_data_a_no_intg;

  // Compute increments which can be optionally applied to indirect register accesses and memory
  // addresses in BN.LID/BN.SID/BN.MOVR instructions.
  assign rf_base_rd_data_a_inc           = rf_base_rd_data_a_no_intg[4:0] + 1'b1;
  assign rf_base_rd_data_b_inc           = rf_base_rd_data_b_no_intg[4:0] + 1'b1;
  // We can avoid a full 32-bit adder here because the offset is 32-bit aligned, so we know the
  // load/store address will only be valid if rf_base_rd_data_a_no_intg[4:0] is zero.
  assign rf_base_rd_data_a_wlen_word_inc = rf_base_rd_data_a_no_intg[31:5] + 27'h1;

  // Choose increment to write back to base register file, only one increment can be written as
  // there is only one write port. Note that where an instruction is incrementing the indirect
  // reference to its destination register (insn_dec_bignum_i.d_inc) that reference is read on the
  // B read port so the B increment is written back.
  always_comb begin
    unique case (1'b1)
      insn_dec_bignum_i.a_inc: begin
        increment_out = {26'b0, rf_base_rd_data_a_inc};
      end
      insn_dec_bignum_i.b_inc: begin
        increment_out = {26'b0, rf_base_rd_data_b_inc};
      end
      insn_dec_bignum_i.d_inc: begin
        increment_out = {26'b0, rf_base_rd_data_b_inc};
      end
      insn_dec_bignum_i.a_wlen_word_inc: begin
        increment_out = {rf_base_rd_data_a_wlen_word_inc, 5'b0};
      end
      default: begin
        // Whenever increment_out is written back to the register file, exactly one of the
        // increment selector signals is high. To prevent the automatic inference of latches in
        // case nothing is written back (rf_wdata_sel != RfWdSelIncr) and to save logic, we choose
        // a valid output as default.
        increment_out = {26'b0, rf_base_rd_data_a_inc};
      end
    endcase
  end

  // Base RF read/write address, enable and commit control
  always_comb begin
    rf_base_rd_addr_a_o = insn_dec_base_i.a;
    rf_base_rd_addr_b_o = insn_dec_base_i.b;
    rf_base_wr_addr_o   = insn_dec_base_i.d;

    // Only commit read or write if the instruction is executing (in particular a read commit pops
    // the call stack so must not occur where a valid instruction sees an error and doesn't
    // execute).
    rf_base_rd_commit_o = insn_executing;
    rf_base_wr_commit_o = insn_executing;

    rf_base_rd_en_a_raw = 1'b0;
    rf_base_rd_en_b_raw = 1'b0;
    rf_base_wr_en_raw   = 1'b0;

    if (insn_valid_i) begin
      if (insn_dec_shared_i.st_insn) begin
        // For stores, both base reads happen in the same cycle as the request because they give the
        // address and data, which make up the request.
        rf_base_rd_en_a_raw = insn_dec_base_i.rf_ren_a & lsu_store_req_raw;
        rf_base_rd_en_b_raw = insn_dec_base_i.rf_ren_b & lsu_store_req_raw;

        // Bignum stores can update the base register file where an increment is used.
        rf_base_wr_en_raw   = (insn_dec_shared_i.subset == InsnSubsetBignum) &
                              insn_dec_base_i.rf_we                          &
                              lsu_store_req_raw;
      end else if (insn_dec_shared_i.ld_insn) begin
        // For loads, both base reads happen in the same cycle as the request. The address is
        // required for the request and the indirect destination register (only used for Bignum
        // loads) is flopped in ld_insn_bignum_wr_addr_q to correctly deal with the case where it's
        // updated by an increment.
        rf_base_rd_en_a_raw = insn_dec_base_i.rf_ren_a & lsu_load_req_raw;
        rf_base_rd_en_b_raw = insn_dec_base_i.rf_ren_b & lsu_load_req_raw;

        if (insn_dec_shared_i.subset == InsnSubsetBignum) begin
          // Bignum loads can update the base register file where an increment is used. This must
          // always happen in the same cycle as the request as this is where both registers are
          // read.
          rf_base_wr_en_raw = insn_dec_base_i.rf_we & lsu_load_req_raw;
        end else begin
          // For Base loads write the base register file when the instruction is unstalled (meaning
          // the load data is available).
          rf_base_wr_en_raw = insn_dec_base_i.rf_we & ~stall;
        end
      end else begin
        // For all other instructions the read and write happen when the instruction is unstalled.
        rf_base_rd_en_a_raw = insn_dec_base_i.rf_ren_a & ~stall;
        rf_base_rd_en_b_raw = insn_dec_base_i.rf_ren_b & ~stall;
        rf_base_wr_en_raw   = insn_dec_base_i.rf_we    & ~stall;
      end
    end

    if (insn_dec_shared_i.subset == InsnSubsetBignum) begin
      unique case (1'b1)
        insn_dec_bignum_i.a_inc,
        insn_dec_bignum_i.a_wlen_word_inc: begin
          rf_base_wr_addr_o = insn_dec_base_i.a;
        end

        insn_dec_bignum_i.b_inc,
        insn_dec_bignum_i.d_inc: begin
          rf_base_wr_addr_o = insn_dec_base_i.b;
        end
        default: ;
      endcase
    end

    rf_base_rd_en_a_o = rf_base_rd_en_a_raw & ~illegal_insn_static;
    rf_base_rd_en_b_o = rf_base_rd_en_b_raw & ~illegal_insn_static;
    rf_base_wr_en_o   = rf_base_wr_en_raw   & ~illegal_insn_static;
  end

  // Base ALU Operand A MUX
  always_comb begin
    unique case (insn_dec_base_i.op_a_sel)
      OpASelRegister: alu_base_operation_o.operand_a = rf_base_rd_data_a_no_intg;
      OpASelZero:     alu_base_operation_o.operand_a = '0;
      OpASelCurrPc:   alu_base_operation_o.operand_a = {{(32 - ImemAddrWidth){1'b0}}, insn_addr_i};
      default:        alu_base_operation_o.operand_a = rf_base_rd_data_a_no_intg;
    endcase
  end

  // Base ALU Operand B MUX
  always_comb begin
    unique case (insn_dec_base_i.op_b_sel)
      OpBSelRegister:  alu_base_operation_o.operand_b = rf_base_rd_data_b_no_intg;
      OpBSelImmediate: alu_base_operation_o.operand_b = insn_dec_base_i.i;
      default:         alu_base_operation_o.operand_b = rf_base_rd_data_b_no_intg;
    endcase
  end

  assign alu_base_operation_o.op = insn_dec_base_i.alu_op;

  assign alu_base_comparison_o.operand_a = rf_base_rd_data_a_no_intg;
  assign alu_base_comparison_o.operand_b = rf_base_rd_data_b_no_intg;
  assign alu_base_comparison_o.op = insn_dec_base_i.comparison_op;

  assign rf_base_rd_data_a_no_intg = rf_base_rd_data_a_intg_i[31:0];
  assign rf_base_rd_data_b_no_intg = rf_base_rd_data_b_intg_i[31:0];

  // TODO: For now integrity bits from RF base are ignored in the controller, remove this when end
  // to end integrity features that use them are implemented
  logic unused_rf_base_rd_a_intg_bits;
  logic unused_rf_base_rd_b_intg_bits;

  assign unused_rf_base_rd_a_intg_bits = |rf_base_rd_data_a_intg_i[38:32];
  assign unused_rf_base_rd_b_intg_bits = |rf_base_rd_data_b_intg_i[38:32];

  // Register file write MUX
  always_comb begin
    // Write data mux for anything that needs integrity computing during register write
    unique case (insn_dec_base_i.rf_wdata_sel)
      RfWdSelEx:     rf_base_wr_data_no_intg_o = alu_base_operation_result_i;
      RfWdSelNextPc: rf_base_wr_data_no_intg_o = {{(32-(ImemAddrWidth+1)){1'b0}},
                                                  next_insn_addr_wide};
      RfWdSelIspr:   rf_base_wr_data_no_intg_o = csr_rdata;
      RfWdSelIncr:   rf_base_wr_data_no_intg_o = increment_out;
      default:       rf_base_wr_data_no_intg_o = alu_base_operation_result_i;
    endcase

    // Write data mux for anything that provides its own integrity
    unique case (insn_dec_base_i.rf_wdata_sel)
      RfWdSelLsu: begin
        rf_base_wr_data_intg_sel_o = 1'b1;
        rf_base_wr_data_intg_o     = lsu_base_rdata_i;
      end
      default: begin
        rf_base_wr_data_intg_sel_o = 1'b0;
        rf_base_wr_data_intg_o     = '0;
      end
    endcase
  end

  for (genvar i = 0; i < BaseWordsPerWLEN; ++i) begin : g_rf_bignum_rd_data
    assign rf_bignum_rd_data_a_no_intg[i * 32 +: 32] = rf_bignum_rd_data_a_intg_i[i * 39 +: 32];
    assign rf_bignum_rd_data_b_no_intg[i * 32 +: 32] = rf_bignum_rd_data_b_intg_i[i * 39 +: 32];
  end

  assign rf_bignum_rd_addr_a_o = insn_dec_bignum_i.rf_a_indirect ? rf_base_rd_data_a_no_intg[4:0] :
                                                                   insn_dec_bignum_i.a;
  assign rf_bignum_rd_en_a_o = insn_dec_bignum_i.rf_ren_a & insn_valid_i;

  assign rf_bignum_rd_addr_b_o = insn_dec_bignum_i.rf_b_indirect ? rf_base_rd_data_b_no_intg[4:0] :
                                                                   insn_dec_bignum_i.b;
  assign rf_bignum_rd_en_b_o = insn_dec_bignum_i.rf_ren_b & insn_valid_i;

  assign alu_bignum_operation_o.operand_a = rf_bignum_rd_data_a_no_intg;

  // Base ALU Operand B MUX
  always_comb begin
    unique case (insn_dec_bignum_i.alu_op_b_sel)
      OpBSelRegister:  alu_bignum_operation_o.operand_b = rf_bignum_rd_data_b_no_intg;
      OpBSelImmediate: alu_bignum_operation_o.operand_b = insn_dec_bignum_i.i;
      default:         alu_bignum_operation_o.operand_b = rf_bignum_rd_data_b_no_intg;
    endcase
  end

  assign alu_bignum_operation_o.op          = insn_dec_bignum_i.alu_op;
  assign alu_bignum_operation_o.shift_right = insn_dec_bignum_i.alu_shift_right;
  assign alu_bignum_operation_o.shift_amt   = insn_dec_bignum_i.alu_shift_amt;
  assign alu_bignum_operation_o.flag_group  = insn_dec_bignum_i.alu_flag_group;
  assign alu_bignum_operation_o.sel_flag    = insn_dec_bignum_i.alu_sel_flag;
  assign alu_bignum_operation_o.alu_flag_en = insn_dec_bignum_i.alu_flag_en & insn_executing;
  assign alu_bignum_operation_o.mac_flag_en = insn_dec_bignum_i.mac_flag_en & insn_executing;

  assign mac_bignum_operation_o.operand_a         = rf_bignum_rd_data_a_no_intg;
  assign mac_bignum_operation_o.operand_b         = rf_bignum_rd_data_b_no_intg;
  assign mac_bignum_operation_o.operand_a_qw_sel  = insn_dec_bignum_i.mac_op_a_qw_sel;
  assign mac_bignum_operation_o.operand_b_qw_sel  = insn_dec_bignum_i.mac_op_b_qw_sel;
  assign mac_bignum_operation_o.wr_hw_sel_upper   = insn_dec_bignum_i.mac_wr_hw_sel_upper;
  assign mac_bignum_operation_o.pre_acc_shift_imm = insn_dec_bignum_i.mac_pre_acc_shift;
  assign mac_bignum_operation_o.zero_acc          = insn_dec_bignum_i.mac_zero_acc;
  assign mac_bignum_operation_o.shift_acc         = insn_dec_bignum_i.mac_shift_out;

  assign mac_bignum_en_o = insn_executing & insn_dec_bignum_i.mac_en;

  // Move / Conditional Select. Only select B register data when a selection instruction is being
  // executed and the selection flag isn't set.

  `ASSERT(SelFlagValid, insn_valid_i & insn_dec_bignum_i.sel_insn |->
    insn_dec_bignum_i.alu_sel_flag inside {FlagC, FlagL, FlagM, FlagZ})

  assign selection_result =
    ~insn_dec_bignum_i.sel_insn | alu_bignum_selection_flag_i ? rf_bignum_rd_data_a_intg_i :
                                                                rf_bignum_rd_data_b_intg_i;

  // Bignum Register file write control

  always_comb begin
    // By default write nothing
    rf_bignum_wr_en_o = 2'b00;

    // Only write if executing instruction wants a bignum rf write and it isn't stalled and there is
    // no error
    if (insn_executing && insn_dec_bignum_i.rf_we && !err && !stall) begin
      if (insn_dec_bignum_i.mac_en && insn_dec_bignum_i.mac_shift_out) begin
        // Special handling for BN.MULQACC.SO, only enable upper or lower half depending on
        // mac_wr_hw_sel_upper.
        rf_bignum_wr_en_o = insn_dec_bignum_i.mac_wr_hw_sel_upper ? 2'b10 : 2'b01;
      end else begin
        // For everything else write both halves immediately.
        rf_bignum_wr_en_o = 2'b11;
      end
    end
  end

  // For BN.LID sample the indirect destination register index in first cycle as an increment might
  // change it for the second cycle where the load data is written to the bignum register file.
  always_ff @(posedge clk_i) begin
    if (insn_dec_bignum_i.rf_d_indirect & lsu_load_req_raw) begin
      ld_insn_bignum_wr_addr_q <= rf_base_rd_data_b_no_intg[4:0];
    end
  end

  always_comb begin
    rf_bignum_wr_addr_o = insn_dec_bignum_i.d;

    if (insn_dec_bignum_i.rf_d_indirect) begin
      if (insn_dec_shared_i.ld_insn) begin
        // Use sampled register index from first cycle of the load (in case the increment has
        // changed the value in the mean-time).
        rf_bignum_wr_addr_o = ld_insn_bignum_wr_addr_q;
      end else begin
        // Use read register index directly
        rf_bignum_wr_addr_o = rf_base_rd_data_b_no_intg[4:0];
      end
    end
  end

  // For the shift-out variant of BN.MULQACC the bottom half of the MAC result is written to one
  // half of a desintation register specified by the instruction (mac_wr_hw_sel_upper). The bottom
  // half of the MAC result must be placed in the appropriate half of the write data (the RF only
  // accepts write data for the top half in the top half of the write data input). Otherwise
  // (shift-out to bottom half and all other BN.MULQACC instructions) simply pass the MAC result
  // through unchanged as write data.
  assign mac_bignum_rf_wr_data[WLEN-1:WLEN/2] =
      insn_dec_bignum_i.mac_wr_hw_sel_upper &&
      insn_dec_bignum_i.mac_shift_out          ? mac_bignum_operation_result_i[WLEN/2-1:0] :
                                                 mac_bignum_operation_result_i[WLEN-1:WLEN/2];

  assign mac_bignum_rf_wr_data[WLEN/2-1:0] = mac_bignum_operation_result_i[WLEN/2-1:0];

  always_comb begin
    // Write data mux for anything that needs integrity computing during register write
    // TODO: ISPR data will go via direct mux below once integrity has been implemented for
    // them.
    unique case (insn_dec_bignum_i.rf_wdata_sel)
      RfWdSelEx:   rf_bignum_wr_data_no_intg_o = alu_bignum_operation_result_i;
      RfWdSelIspr: rf_bignum_wr_data_no_intg_o = ispr_rdata_i;
      RfWdSelMac:  rf_bignum_wr_data_no_intg_o = mac_bignum_rf_wr_data;
      default:     rf_bignum_wr_data_no_intg_o = alu_bignum_operation_result_i;
    endcase

    // Write data mux for anything that provides its own integrity
    unique case (insn_dec_bignum_i.rf_wdata_sel)
      RfWdSelMovSel: begin
        rf_bignum_wr_data_intg_sel_o = 1'b1;
        rf_bignum_wr_data_intg_o     = selection_result;
      end
      RfWdSelLsu: begin
        rf_bignum_wr_data_intg_sel_o = 1'b1;
        rf_bignum_wr_data_intg_o     = lsu_bignum_rdata_i;
      end
      default: begin
        rf_bignum_wr_data_intg_sel_o = 1'b0;
        rf_bignum_wr_data_intg_o     = '0;
      end
    endcase
  end

  assign rf_a_indirect_err = insn_dec_bignum_i.rf_a_indirect    &
                             (|rf_base_rd_data_a_no_intg[31:5]) &
                             rf_base_rd_en_a_o;

  assign rf_b_indirect_err = insn_dec_bignum_i.rf_b_indirect    &
                             (|rf_base_rd_data_b_no_intg[31:5]) &
                             rf_base_rd_en_b_o;

  assign rf_d_indirect_err = insn_dec_bignum_i.rf_d_indirect    &
                             (|rf_base_rd_data_b_no_intg[31:5]) &
                             rf_base_rd_en_b_o;

  assign rf_indirect_err =
      insn_valid_i & (rf_a_indirect_err | rf_b_indirect_err | rf_d_indirect_err);

  // CSR/WSR/ISPR handling
  // ISPRs (Internal Special Purpose Registers) are the internal registers. CSRs and WSRs are the
  // ISA visible versions of those registers in the base and bignum ISAs respectively.

  assign csr_addr     = csr_e'(insn_dec_base_i.i[11:0]);
  assign csr_sub_addr = insn_dec_base_i.i[$clog2(BaseWordsPerWLEN)-1:0];

  always_comb begin
    ispr_addr_base      = IsprMod;
    ispr_word_addr_base = '0;
    csr_illegal_addr    = 1'b0;

    unique case (csr_addr)
      CsrFlags, CsrFg0, CsrFg1 : begin
        ispr_addr_base      = IsprFlags;
        ispr_word_addr_base = '0;
      end
      CsrMod0, CsrMod1, CsrMod2, CsrMod3, CsrMod4, CsrMod5, CsrMod6, CsrMod7: begin
        ispr_addr_base      = IsprMod;
        ispr_word_addr_base = csr_sub_addr;
      end
      CsrRndPrefetch: begin
        // Reading from RND_PREFETCH results in 0, there is no ISPR to read so no address is set.
        // The csr_rdata mux logic takes care of producing the 0.
      end
      CsrRnd: begin
        ispr_addr_base      = IsprRnd;
        ispr_word_addr_base = '0;
      end
      CsrUrnd: begin
        ispr_addr_base      = IsprUrnd;
        ispr_word_addr_base = '0;
      end
      default: csr_illegal_addr = 1'b1;
    endcase
  end

  for (genvar i_word = 0; i_word < BaseWordsPerWLEN; i_word++) begin : g_ispr_word_sel_base
    assign ispr_word_sel_base[i_word] = ispr_word_addr_base == i_word;
  end

  for (genvar i_bit = 0; i_bit < 32; i_bit++) begin : g_csr_rdata_mux
    for (genvar i_word = 0; i_word < BaseWordsPerWLEN; i_word++) begin : g_csr_rdata_mux_inner
      assign csr_rdata_mux[i_bit][i_word] =
          ispr_rdata_i[i_word*32 + i_bit] & ispr_word_sel_base[i_word];
    end

    assign csr_rdata_raw[i_bit] = |csr_rdata_mux[i_bit];
  end

  // Specialised read data handling for CSR reads where raw read data needs modification.
  always_comb begin
    csr_rdata = csr_rdata_raw;

    unique case (csr_addr)
      // For FG0/FG1 select out appropriate bits from FLAGS ISPR and pad the rest with zeros.
      CsrFg0:         csr_rdata = {28'b0, csr_rdata_raw[3:0]};
      CsrFg1:         csr_rdata = {28'b0, csr_rdata_raw[7:4]};
      CsrRndPrefetch: csr_rdata = '0;
      default: ;
    endcase
  end

  assign csr_wdata_raw = insn_dec_shared_i.ispr_rs_insn ? csr_rdata | rf_base_rd_data_a_no_intg :
                                                          rf_base_rd_data_a_no_intg;

  // Specialised write data handling for CSR writes where raw write data needs modification.
  always_comb begin
    csr_wdata = csr_wdata_raw;

    unique case (csr_addr)
      // For FG0/FG1 only modify relevant part of FLAGS ISPR.
      CsrFg0: csr_wdata = {24'b0, csr_rdata_raw[7:4], csr_wdata_raw[3:0]};
      CsrFg1: csr_wdata = {24'b0, csr_wdata_raw[3:0], csr_rdata_raw[3:0]};
      default: ;
    endcase
  end

  // ISPR RS (read and set) must not be combined with ISPR RD or WR (read or write). ISPR RD and
  // WR (read and write) is allowed.
  `ASSERT(NoIsprRorWAndRs, insn_valid_i |-> ~(insn_dec_shared_i.ispr_rs_insn   &
                                              (insn_dec_shared_i.ispr_rd_insn |
                                               insn_dec_shared_i.ispr_wr_insn)))


  assign wsr_addr = wsr_e'(insn_dec_bignum_i.i[WsrNumWidth-1:0]);

  always_comb begin
    ispr_addr_bignum = IsprMod;
    wsr_illegal_addr = 1'b0;

    unique case (wsr_addr)
      WsrMod:  ispr_addr_bignum = IsprMod;
      WsrRnd:  ispr_addr_bignum = IsprRnd;
      WsrUrnd: ispr_addr_bignum = IsprUrnd;
      WsrAcc:  ispr_addr_bignum = IsprAcc;
      default: wsr_illegal_addr = 1'b1;
    endcase
  end

  assign wsr_wdata = insn_dec_shared_i.ispr_rs_insn ? ispr_rdata_i | rf_bignum_rd_data_a_no_intg :
                                                      rf_bignum_rd_data_a_no_intg;

  assign ispr_illegal_addr = insn_dec_shared_i.subset == InsnSubsetBase ? csr_illegal_addr :
                                                                          wsr_illegal_addr;

  assign ispr_err = ispr_illegal_addr & insn_valid_i & (insn_dec_shared_i.ispr_rd_insn |
                                                        insn_dec_shared_i.ispr_wr_insn |
                                                        insn_dec_shared_i.ispr_rs_insn);

  assign ispr_wr_insn = insn_dec_shared_i.ispr_wr_insn | insn_dec_shared_i.ispr_rs_insn;
  assign ispr_rd_insn = insn_dec_shared_i.ispr_rd_insn | insn_dec_shared_i.ispr_rs_insn;

  // Write to RND_PREFETCH must not produce ISR write
  assign ispr_wr_base_insn =
    ispr_wr_insn & (insn_dec_shared_i.subset == InsnSubsetBase) & (csr_addr != CsrRndPrefetch);

  assign ispr_wr_bignum_insn = ispr_wr_insn & (insn_dec_shared_i.subset == InsnSubsetBignum);

  assign ispr_addr_o         = insn_dec_shared_i.subset == InsnSubsetBase ? ispr_addr_base :
                                                                            ispr_addr_bignum;
  assign ispr_base_wdata_o   = csr_wdata;
  assign ispr_base_wr_en_o   = {BaseWordsPerWLEN{ispr_wr_base_insn & insn_executing}} &
                               ispr_word_sel_base;

  assign ispr_bignum_wdata_o = wsr_wdata;
  assign ispr_bignum_wr_en_o = ispr_wr_bignum_insn & insn_executing;

  // lsu_load_req_raw/lsu_store_req_raw indicate an instruction wishes to perform a store or a load.
  // lsu_load_req_o/lsu_store_req_o factor in whether an instruction is actually executing (it may
  // be suppressed due an error) and command the load or store to happen when asserted.
  assign lsu_load_req_raw = insn_valid_i & insn_dec_shared_i.ld_insn & (state_q == OtbnStateRun);
  assign lsu_load_req_o   = insn_executing & lsu_load_req_raw;

  assign lsu_store_req_raw = insn_valid_i & insn_dec_shared_i.st_insn & (state_q == OtbnStateRun);
  assign lsu_store_req_o   = insn_executing & lsu_store_req_raw;

  assign lsu_req_subset_o = insn_dec_shared_i.subset;

  assign lsu_addr_o         = alu_base_operation_result_i[DmemAddrWidth-1:0];
  assign lsu_base_wdata_o   = rf_base_rd_data_b_intg_i;
  assign lsu_bignum_wdata_o = rf_bignum_rd_data_b_intg_i;

  assign dmem_addr_unaligned_bignum =
      (lsu_req_subset_o == InsnSubsetBignum) & (|lsu_addr_o[$clog2(WLEN/8)-1:0]);
  assign dmem_addr_unaligned_base   =
      (lsu_req_subset_o == InsnSubsetBase)   & (|lsu_addr_o[1:0]);
  assign dmem_addr_overflow         = |alu_base_operation_result_i[31:DmemAddrWidth];

  assign dmem_addr_err =
      insn_valid_i & (lsu_load_req_raw | lsu_store_req_raw) & (dmem_addr_overflow         |
                                                               dmem_addr_unaligned_bignum |
                                                               dmem_addr_unaligned_base);

  assign rnd_req_o = insn_valid_i & ispr_rd_insn & (ispr_addr_o == IsprRnd);

  assign rnd_prefetch_req_o = insn_valid_i & ispr_wr_insn &
      (insn_dec_shared_i.subset == InsnSubsetBase) & (csr_addr == CsrRndPrefetch);
endmodule
