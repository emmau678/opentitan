// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class csrng_cmds_vseq extends csrng_base_vseq;
  `uvm_object_utils(csrng_cmds_vseq)
  `uvm_object_new

  bit [entropy_src_pkg::FIPS_BUS_WIDTH - 1:0]     fips;
  bit [entropy_src_pkg::CSRNG_BUS_WIDTH - 1:0]    entropy;
  csrng_item                                      cs_item_q[NUM_HW_APPS + 1][$];
  uint                                            num_cmds, cmds_gen, cmds_sent;
  bit [csrng_pkg::GENBITS_BUS_WIDTH-1:0]          genbits;

  function void create_cmds(uint app);
    bit          uninstantiate;
    csrng_item   cs_item;

    cs_item = new();
    // Start with instantiate command
    `DV_CHECK_RANDOMIZE_WITH_FATAL(cs_item,
                                   cs_item.acmd == csrng_pkg::INS;)
    cs_item_q[app].push_back(cs_item);

    // Randomize num_cmds and generate other commands
    `DV_CHECK_STD_RANDOMIZE_WITH_FATAL(num_cmds, num_cmds inside
        { [cfg.num_cmds_min:cfg.num_cmds_max] };)
    `uvm_info(`gfn, $sformatf("num_cmds(%0d) = %0d", app, num_cmds), UVM_DEBUG)

    // Generate other commands
    for (int i = 0; i < num_cmds; i++) begin
       cs_item = new();
      `DV_CHECK_RANDOMIZE_WITH_FATAL(cs_item,
                                     cs_item.acmd inside { csrng_pkg::GEN,
                                                           csrng_pkg::RES,
                                                           csrng_pkg::UPD };)
      cs_item_q[app].push_back(cs_item);
    end

    // Generate uninstantiate command only some of the time so final internal state is non-zero.
    `DV_CHECK_STD_RANDOMIZE_FATAL(uninstantiate)

    if (uninstantiate) begin
       cs_item = new();
      `DV_CHECK_RANDOMIZE_WITH_FATAL(cs_item,
                                     cs_item.acmd  == csrng_pkg::UNI;
                                     cs_item.clen  == 'h0;)
      cs_item_q[app].push_back(cs_item);
    end

    cmds_gen += cs_item_q[app].size();
  endfunction

  task body();
    // Create entropy_src sequence
    m_entropy_src_pull_seq = push_pull_device_seq#(entropy_src_pkg::FIPS_CSRNG_BUS_WIDTH)::type_id::
         create("m_entropy_src_pull_seq");
    // Create edn host sequences
    for (int i = 0; i < NUM_HW_APPS; i++) begin
      m_edn_push_seq[i] = push_pull_host_seq#(csrng_pkg::CSRNG_CMD_WIDTH)::type_id::create
           ($sformatf("m_edn_push_seq[%0d]", i));
    end

    // Generate queues of csrng commands
    for (int i = 0; i < NUM_HW_APPS + 1; i++) begin
      `uvm_info(`gfn, $sformatf("create_cmds(%0d)", i), UVM_DEBUG)
      create_cmds(i);
    end

    // Print cs_items
    for (int i = 0; i < NUM_HW_APPS + 1; i++) begin
      foreach (cs_item_q[i][j]) begin
        `uvm_info(`gfn, $sformatf("cs_item_q[%0d][%0d]: %s", i, j,
            cs_item_q[i][j].convert2string()), UVM_DEBUG)
      end
    end

    // Start entropy_src
    fork
      begin
        for (int i = 0; i < 32; i++) begin
          `DV_CHECK_STD_RANDOMIZE_FATAL(fips)
          `DV_CHECK_STD_RANDOMIZE_FATAL(entropy)
          cfg.m_entropy_src_agent_cfg.add_d_user_data({fips, entropy});
        end
        m_entropy_src_pull_seq.start(p_sequencer.entropy_src_sequencer_h);
      end
    join_none

    // Send commands
    fork
      for (int i = 0; i < NUM_HW_APPS + 1; i++) begin
        automatic int j = i;
        fork
          begin
            foreach (cs_item_q[j][k]) begin
              send_cmd_req(j, cs_item_q[j][k]);
              cmds_sent += 1;
            end
          end
        join_none;
      end

      wait (cmds_sent == cmds_gen);
    join

    // Check internal state
    if (cfg.check_int_state) begin
      for (int i = 0; i < NUM_HW_APPS + 1; i++)
        cfg.check_internal_state(.app(i), .compare(1));
    end
  endtask : body
endclass : csrng_cmds_vseq
