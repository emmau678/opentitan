// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class ibex_icache_scoreboard
  extends dv_base_scoreboard #(.CFG_T(ibex_icache_env_cfg), .COV_T(ibex_icache_env_cov));

  `uvm_component_utils(ibex_icache_scoreboard)

  // TLM agent fifos
  uvm_tlm_analysis_fifo #(ibex_icache_core_bus_item) core_fifo;
  uvm_tlm_analysis_fifo #(ibex_icache_mem_bus_item)  mem_fifo;

  localparam BusWidth = 32;

  // A memory model. Note that the model is stateful (because of the seed). Since we need to try out
  // different seeds to check whether a fetch was correct, we need our own instance, rather than a
  // handle to the model used by the agent. The actual seed inside mem_model is ephemeral: we keep
  // track of state in mem_seeds, below.
  ibex_icache_mem_model #(BusWidth) mem_model;

  // A queue of memory seeds.
  bit [31:0]   mem_seeds[$];

  // Tracks the next address we expect to see on a fetch. This gets reset to 'X, then is set to an
  // address after each branch transaction.
  logic [31:0] next_addr;

  // This counter is used for tracking invalidations. When we see an invalidation happen, we set
  // this to the index of the last seed in mem_seeds. When the next branch happens, we clear out
  // memory seeds up to that index.
  int unsigned invalidate_seed = 0;

  // This counter points to the index (in mem_seeds) of the seed that was in use when the last
  // branch happened. If the cache is supposed to be disabled, a fetch is only allowed to return
  // data corresponding to that seed or later.
  int unsigned last_branch_seed = 0;

  // A counter of outstanding transactions on the memory bus. The busy flag should never go to zero
  // when this is non-zero.
  int unsigned mem_trans_count = 0;

  // Track the current enabled state. The enabled flag tracks whether the cache is currently
  // enabled. The no_cache flag is high if the cache has been disabled since before the last branch.
  // If this is set, we can be stricter about the data that can be fetched.
  //
  // TODO: Our enable tracking checks that we don't get cache hits when the cache is disabled. It
  //       doesn't yet check that the cache doesn't store fetches when disabled.
  bit          enabled = 0;
  bit          no_cache = 1'b1;

  // Track the current busy state
  bit          busy = 0;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    core_fifo = new("core_fifo", this);
    mem_fifo  = new("mem_fifo",  this);
    mem_model = new("mem_model");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      process_core_fifo();
      process_mem_fifo();
    join_none
  endtask

  task process_core_fifo();
    ibex_icache_core_bus_item item;
    forever begin
      core_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received core transaction:\n%0s", item.sprint()), UVM_HIGH)
      case (item.trans_type)
        ICacheCoreBusTransTypeBranch:     process_branch(item);
        ICacheCoreBusTransTypeFetch:      process_fetch(item);
        ICacheCoreBusTransTypeInvalidate: process_invalidate(item);
        ICacheCoreBusTransTypeEnable:     process_enable(item);
        ICacheCoreBusTransTypeBusy:       process_busy(item);
        default: `uvm_fatal(`gfn, $sformatf("Bad transaction type %0d", item.trans_type))
      endcase
    end
  endtask

  task process_branch(ibex_icache_core_bus_item item);
    next_addr = item.address;

    if (invalidate_seed > 0) begin
      // We've seen an invalidate signal recently. Clear out any expired seeds.
      assert(invalidate_seed < mem_seeds.size);
      mem_seeds = mem_seeds[invalidate_seed:$];
      invalidate_seed = 0;
    end

    assert(mem_seeds.size > 0);
    last_branch_seed = mem_seeds.size - 1;

    if (!enabled) no_cache = 1'b1;
  endtask

  task process_fetch(ibex_icache_core_bus_item item);
    // Check that the address is what we expect
    `DV_CHECK_EQ(item.address, next_addr)

    // Update expected address, incrementing by 2 or 4.
    next_addr = next_addr + ((item.insn_data[1:0] == 2'b11) ? 32'd4 : 32'd2);

    // Check the received data is compatible with one of our seeds
    check_compatible(item);
  endtask

  task process_invalidate(ibex_icache_core_bus_item item);
    assert(mem_seeds.size > 0);
    invalidate_seed = mem_seeds.size - 1;
  endtask

  task process_enable(ibex_icache_core_bus_item item);
    enabled = item.enable;
    if (enabled) no_cache = 0;
  endtask

  task process_busy(ibex_icache_core_bus_item item);
    busy = item.busy;
    if (!busy) busy_check();
  endtask

  task process_mem_fifo();
    ibex_icache_mem_bus_item item;
    forever begin
      mem_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received mem transaction:\n%0s", item.sprint()), UVM_HIGH)

      case (item.trans_type)
        ICacheMemNewSeed: begin
          mem_seeds.push_back(item.data);
        end

        ICacheMemGrant: begin
          mem_trans_count += 1;
        end

        ICacheMemResponse: begin
          busy_check();
          `DV_CHECK_FATAL(mem_trans_count > 0);
          mem_trans_count -= 1;
        end
      endcase
    end
  endtask

  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    next_addr = 'X;
    mem_seeds = {32'd0};
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(ibex_icache_core_bus_item, core_fifo)
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(ibex_icache_mem_bus_item,  mem_fifo)
  endfunction

  // Check whether observed fetched instruction data matches the given single memory fetch.
  //
  // This is used to check aligned accesses or misaligned accesses where we saw an error in the
  // lower word or where the lower 16 bits of instruction data give a compressed instruction. If
  // chatty is true, print a message about why the fetch is compatible or not (used to help
  // debugging failures)
  function automatic logic is_fetch_compatible_1(logic [31:0] seen_insn_data,
                                                 logic        seen_err,

                                                 bit          exp_err,
                                                 bit [31:0]   exp_insn_data,

                                                 bit [31:0]   seed,
                                                 bit          chatty);

    logic is_compressed;

    if (exp_err) begin
      if (!seen_err) begin
        // The (lower) memory fetch should have failed, but we haven't got an error flag.
        if (chatty) begin
          `uvm_info(`gfn,
                    $sformatf("Not seed 0x%08h: expected seen_err but saw 0.", seed),
                    UVM_MEDIUM)
        end
        return 0;
      end

      // If we have seen an expected error, that's a match (and we shouldn't have gone around again
      // with the chatty flag set)
      `DV_CHECK_FATAL(!chatty)

      return 1'b1;
    end

    is_compressed = exp_insn_data[1:0] != 2'b11;
    if (is_compressed) begin
      if (seen_insn_data[15:0] != exp_insn_data[15:0]) begin
        if (chatty) begin
          `uvm_info(`gfn,
                    $sformatf("Not seed 0x%08h (expected cmp 0x(%04h)%04h; saw 0x(%04h)%04h).",
                              seed, exp_insn_data[31:16], exp_insn_data[15:0],
                              seen_insn_data[31:16], seen_insn_data[15:0]),
                    UVM_MEDIUM)
        end
        return 0;
      end
    end else begin
      if (seen_insn_data != exp_insn_data) begin
        if (chatty) begin
          `uvm_info(`gfn,
                    $sformatf("Not seed 0x%08h (expected uncomp 0x%08h; saw 0x%08h).",
                              seed, exp_insn_data, seen_insn_data),
                    UVM_MEDIUM)
        end
        return 0;
      end
    end

    if (seen_err) begin
      if (chatty) begin
        `uvm_info(`gfn,
                  $sformatf("Not seed 0x%08h: got unexpected error flag.", seed),
                  UVM_MEDIUM)
      end
      return 0;
    end

    // This seed matches, so we shouldn't have been called with the chatty flag set.
    `DV_CHECK_FATAL(!chatty)
    return 1'b1;
  endfunction

  // Check whether observed fetched instruction data matches the given pair of memory fetches.
  //
  // This is used to check misaligned accesses where the instruction data gives an uncompressed
  // instruction. If chatty is true, print a message about why the fetch is compatible or not (used
  // to help debugging failures)
  function automatic logic is_fetch_compatible_2(logic [31:0] seen_insn_data,
                                                 logic        seen_err_plus2,

                                                 bit          exp_err_lo,
                                                 bit          exp_err_hi,
                                                 bit [31:0]   exp_insn_data,

                                                 bit [31:0]   seed_lo,
                                                 bit [31:0]   seed_hi,
                                                 bit          chatty);

    // We should only be called when the seen instruction data for the lower word is uncompressed
    assert(seen_insn_data[1:0] == 2'b11);

    if (exp_err_lo) begin
      if (chatty) begin
        `uvm_info(`gfn,
                  $sformatf("Not seeds 0x%08h/0x%08h (expected error in low word).",
                            seed_lo, seed_hi),
                  UVM_MEDIUM)
      end
      return 0;
    end

    if (exp_err_hi != seen_err_plus2) begin
      if (chatty) begin
        `uvm_info(`gfn,
                  $sformatf("Not seeds 0x%08h/0x%08h (exp/seen top errors %0d/%0d).",
                            seed_lo, seed_hi, exp_err_hi, seen_err_plus2),
                  UVM_MEDIUM)
      end
      return 0;
    end

    if (exp_err_hi) begin
      if (chatty) begin
        `uvm_info(`gfn,
                  $sformatf("Match for seeds 0x%08h/0x%08h (seen upper error).",
                            seed_lo, seed_hi),
                  UVM_MEDIUM)
      end
      return 1'b1;
    end

    // No errors seen or expected. Check the data matches (for a full uncompressed insn)
    if (exp_insn_data != seen_insn_data) begin
      if (chatty) begin
        `uvm_info(`gfn,
                  $sformatf("Not seeds 0x%08h/0x%08h (exp/seen data 0x%08h/0x%08h).",
                            seed_lo, seed_hi, exp_insn_data, seen_insn_data),
                  UVM_MEDIUM)
      end
      return 0;
    end

    // This seed matches, so we shouldn't have been called with the chatty flag set.
    `DV_CHECK_FATAL(!chatty)

    return 1'b1;

  endfunction

  // Do a single read from the memory model, rounding down the address and re-aligning the returned
  // data if necessary. Use is_fetch_compatible_1 to decide whether the result seen is compatible
  // with the seed.
  function automatic logic is_seed_compatible_1(logic [31:0] address,
                                                logic [31:0] seen_insn_data,
                                                logic        seen_err,
                                                bit [31:0]   seed,
                                                bit          chatty);
    int                bus_shift;
    logic [31:0]       addr_lo;
    int unsigned       lo_bits_to_drop;

    logic              retval;

    bit [BusWidth-1:0] rdata;

    bus_shift = $clog2(BusWidth / 8);
    addr_lo = (address >> bus_shift) << bus_shift;

    // If address is not aligned to BusWidth, the aligned read that we do from mem_model will have
    // some data that needs shifting out of the way. We'll fill the top with zeroes, but that's fine
    // because we only use this function for misaligned accesses if seen_insn_data looks like it's a
    // compressed instruction, in which case we don't care about the top bits anyway.
    lo_bits_to_drop = 8 * (address - addr_lo);

    rdata = mem_model.read_data(seed, addr_lo) >> lo_bits_to_drop;

    return is_fetch_compatible_1(seen_insn_data,
                                 seen_err,
                                 mem_model.is_either_error(seed, addr_lo),
                                 rdata[31:0],
                                 seed,
                                 chatty);
  endfunction

  // Do a pair of reads from the memory model with the given pair of seeds to model a misaligned
  // access. Glue together the results and pass them to is_fetch_compatible_2 to decide whether the
  // result seen is compatible with the given pair of seeds.
  function automatic logic is_seed_compatible_2(logic [31:0] address,
                                                logic [31:0] seen_insn_data,
                                                logic        seen_err_plus2,

                                                bit [31:0]   seed_lo,
                                                bit [31:0]   seed_hi,
                                                bit          chatty);
    int          bus_shift;
    logic [31:0] addr_lo, addr_hi;

    bit                exp_err_lo, exp_err_hi;
    bit [31:0]         exp_data;
    bit [BusWidth-1:0] rdata;

    int unsigned lo_bits_to_take, lo_bits_to_drop;

    bus_shift = $clog2(BusWidth / 8);
    addr_lo = (address >> bus_shift) << bus_shift;
    addr_hi = addr_lo + (32'd1 << bus_shift);

    // This is only supposed to be used for misaligned reads
    assert (addr_lo < address);

    // How many bits do we get from each read? (Note that for half-word aligned reads on a 32-bit
    // bus, both of these numbers will be 16, but this code should be correct with other values of
    // BusWidth).
    lo_bits_to_take = 8 * (address - addr_lo);
    lo_bits_to_drop = BusWidth - lo_bits_to_take;

    // Do the first read (from the low address) and shift right to drop the bits that we don't need.
    exp_err_lo = mem_model.is_either_error(seed_lo, addr_lo);
    rdata      = mem_model.read_data(seed_lo, addr_lo) >> lo_bits_to_drop;
    exp_data   = rdata[31:0];

    // Now do the second read (from the upper address). Shift the result up by lo_bits_to_take,
    // which will discard some top bits. Then extract 32 bits and OR with what we have so far.
    exp_err_hi = mem_model.is_either_error(seed_hi, addr_hi);
    rdata      = mem_model.read_data(seed_hi, addr_hi) << lo_bits_to_take;
    exp_data   = exp_data | rdata[31:0];

    return is_fetch_compatible_2(seen_insn_data, seen_err_plus2,
                                 exp_err_lo, exp_err_hi, exp_data,
                                 seed_lo, seed_hi, chatty);
  endfunction

  // The logic to check whether a fetch that's been seen is compatible with some seed that's visible
  // at the moment.
  function automatic bit check_compatible_1(logic [31:0] address,
                                            logic [31:0] seen_insn_data,
                                            logic        seen_err,
                                            bit          chatty);
    int unsigned min_idx = no_cache ? last_branch_seed : 0;
    assert(min_idx < mem_seeds.size);

    for (int unsigned i = min_idx; i < mem_seeds.size; i++) begin
      if (is_seed_compatible_1(address, seen_insn_data, seen_err, mem_seeds[i], chatty)) begin
        return 1'b1;
      end
    end

    return 1'b0;
  endfunction

  // The logic to check whether a fetch that's been seen is compatible with some pair of seeds that
  // are visible at the moment.
  function automatic bit check_compatible_2(logic [31:0] address,
                                            logic [31:0] seen_insn_data,
                                            logic        seen_err_plus2,
                                            bit          chatty);

    // We want to iterate over all pairs of seeds. We can do this with a nested pair of foreach
    // loops, but we expect that usually we'll get a hit on the "diagonal", so we check that first.
    int unsigned min_idx = no_cache ? last_branch_seed : 0;
    assert(min_idx < mem_seeds.size);

    for (int unsigned i = min_idx; i < mem_seeds.size; i++) begin
      if (is_seed_compatible_2(address, seen_insn_data, seen_err_plus2,
                               mem_seeds[i], mem_seeds[i], chatty)) begin
        return 1'b1;
      end
    end
    for (int unsigned i = min_idx; i < mem_seeds.size; i++) begin
      for (int unsigned j = min_idx; j < mem_seeds.size; j++) begin
        if (i != j) begin
          if (is_seed_compatible_2(address, seen_insn_data, seen_err_plus2,
                                   mem_seeds[i], mem_seeds[j], chatty)) begin
            return 1'b1;
          end
        end
      end
    end
  endfunction

  // Check whether a fetch might be correct.
  task automatic check_compatible(ibex_icache_core_bus_item item);
    logic misaligned;
    logic good_bottom_word;
    logic uncompressed;

    misaligned       = (item.address & 3) != 0;
    good_bottom_word = (~item.err) | item.err_plus2;
    uncompressed     = item.insn_data[1:0] == 2'b11;

    if (misaligned && good_bottom_word && uncompressed) begin
      // It looks like this was a misaligned fetch (so came from two fetches from memory) and the
      // bottom word's fetch succeeded, giving an uncompressed result (so we care about the upper
      // fetch).
      if (!check_compatible_2(item.address, item.insn_data, item.err & item.err_plus2, 1'b0)) begin
        void'(check_compatible_2(item.address, item.insn_data, item.err & item.err_plus2, 1'b1));
        `uvm_error(`gfn,
                   $sformatf("Fetch at address 0x%08h got data incompatible with available seeds.",
                             item.address));
      end
    end else begin
      // The easier case: either the fetch was aligned, the lower word seems to have caused an error
      // or the bits in the lower word are a compressed instruction (so we don't care about the
      // upper 16 bits anyway).
      if (!check_compatible_1(item.address, item.insn_data, item.err, 1'b0)) begin
        void'(check_compatible_1(item.address, item.insn_data, item.err, 1'b1));
        `uvm_error(`gfn,
                   $sformatf("Fetch at address 0x%08h got data incompatible with available seeds.",
                             item.address));
      end
    end
  endtask

  // Check that the busy line isn't low when there are outstanding memory transactions
  //
  // Since we're operating in the world of transactions (with no clock edges to guide us), we have
  // to be careful about ordering: if the device had been quiescent and it is now issuing a memory
  // transaction, we might see the request be granted before we see the busy pin go high.
  //
  // To avoid this problem, we actually run the check when
  //
  //     (a) The busy line goes low
  //     (b) Just before a pending request gets a response
  //
  // Suppose that at some point the check would fail. Then it can only start passing again if either
  // the busy line goes high or if the last pending request gets a response. The times above mean
  // we'll spot immediately if the busy line goes low when there are pending transactions. We'll
  // also spot a bug where a request goes out and gets a response before the busy line goes high.
  //
  // We'll miss cases where the busy line is slow to go high, but still manages to do so before the
  // response comes back.
  //
  // TODO: Is this ok (because sometimes the memory will come back quick enough to catch us) or do
  //       we need to do something cleverer? For example, we could have an SVA property (bound into
  //       the design, or at testbench level) that checked the busy pin was high the cycle after a
  //       request went out.

  task automatic busy_check();
    if (mem_trans_count > 0) begin
      `DV_CHECK(busy,
                $sformatf("Busy line low with %d outstanding memory transactions.",
                          mem_trans_count))
    end
  endtask

endclass
