// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class cip_base_scoreboard #(type RAL_T = dv_base_reg_block,
                            type CFG_T = cip_base_env_cfg,
                            type COV_T = cip_base_env_cov)
                            extends dv_base_scoreboard #(RAL_T, CFG_T, COV_T);
  `uvm_component_param_utils(cip_base_scoreboard #(RAL_T, CFG_T, COV_T))

  // TLM fifos to pick up the packets
  uvm_tlm_analysis_fifo #(tl_seq_item)  tl_a_chan_fifo;
  uvm_tlm_analysis_fifo #(tl_seq_item)  tl_d_chan_fifo;

  // Alert_fifo to notify scb if DUT sends an alert
  uvm_tlm_analysis_fifo #(alert_esc_seq_item) alert_fifos[string];

  // EDN fifo
  uvm_tlm_analysis_fifo #(push_pull_item#(.DeviceDataWidth(EDN_DATA_WIDTH))) edn_fifo;

  mem_model#() exp_mem;

  `uvm_component_new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tl_a_chan_fifo = new("tl_a_chan_fifo", this);
    tl_d_chan_fifo = new("tl_d_chan_fifo", this);
    foreach(cfg.list_of_alerts[i]) begin
      string alert_name = cfg.list_of_alerts[i];
      alert_fifos[alert_name] = new($sformatf("alert_fifo[%s]", alert_name), this);
    end
    if (cfg.has_edn) edn_fifo = new("edn_fifo", this);
    exp_mem = mem_model#()::type_id::create("exp_mem", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      process_tl_a_chan_fifo();
      process_tl_d_chan_fifo();
      if (cfg.list_of_alerts.size()) process_alert_fifos();
    join_none
  endtask

  virtual task process_tl_a_chan_fifo();
    tl_seq_item item;
    forever begin
      tl_a_chan_fifo.get(item);

      if (cfg.en_scb_tl_err_chk) begin
        if (predict_tl_err(item, AddrChannel)) continue;
      end
      if (cfg.en_scb_mem_chk && item.is_write() && is_mem_addr(item)) process_mem_write(item);

      if (!cfg.en_scb) continue;
      process_tl_access(item, AddrChannel);
    end
  endtask

  virtual task process_tl_d_chan_fifo();
    tl_seq_item item;
    forever begin
      tl_d_chan_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received tl d_chan item:\n%0s", item.sprint()), UVM_HIGH)

      if (cfg.en_scb_tl_err_chk) begin
        // check tl packet integrity
        void'(item.is_ok());
        if (predict_tl_err(item, DataChannel)) continue;
      end
      if (cfg.en_scb_mem_chk && !item.is_write() && is_mem_addr(item)) process_mem_read(item);

      if (!cfg.en_scb) continue;
      process_tl_access(item, DataChannel);
    end
  endtask

  virtual task process_alert_fifos();
    foreach (alert_fifos[i]) begin
      automatic string alert_name = i;
      fork
        forever begin
          alert_esc_seq_item item;
          alert_fifos[alert_name].get(item);
          if (!cfg.en_scb) continue;
          if (item.alert_esc_type == AlertEscSigTrans && !item.ping_timeout &&
              item.alert_handshake_sta inside {AlertReceived, AlertAckComplete}) begin
            process_alert(alert_name, item);
          // IP level alert protocol does not drive any sig_int_err or ping response
          end else if (item.alert_esc_type == AlertEscIntFail) begin
            `uvm_error(`gfn, $sformatf("alert %s has unexpected signal int error", alert_name))
          end else if (item.ping_timeout) begin
            `uvm_error(`gfn, $sformatf("alert %s has unexpected timeout error", alert_name))
          end else if (item.alert_esc_type == AlertEscPingTrans) begin
            `uvm_error(`gfn, $sformatf("alert %s has unexpected alert ping response", alert_name))
          end
        end
      join_none
    end
  endtask

  virtual function void process_alert(string alert_name, alert_esc_seq_item item);
    `uvm_info(`gfn, $sformatf("alert %0s detected, alert_status is %s", alert_name,
                              item.alert_handshake_sta), UVM_DEBUG)
  endfunction

  // task to process tl access
  virtual task process_tl_access(tl_seq_item item, tl_channels_e channel = DataChannel);
    `uvm_fatal(`gfn, "this method is not supposed to be called directly!")
  endtask

  virtual task process_mem_write(tl_seq_item item);
    uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
    if (!cfg.under_reset)  exp_mem.write(addr, item.a_data, item.a_mask);
  endtask

  virtual task process_mem_read(tl_seq_item item);
    uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
    if (!cfg.under_reset && get_mem_access_by_addr(ral, addr) == "RW") begin
      exp_mem.compare(addr, item.d_data, item.a_mask);
    end
  endtask

  // check if it's mem addr
  virtual function bit is_mem_addr(tl_seq_item item);
    uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
    foreach (cfg.mem_ranges[i]) begin
      if (addr inside {[cfg.mem_ranges[i].start_addr : cfg.mem_ranges[i].end_addr]}) begin
        return 1;
      end
    end
    return 0;
  endfunction

  // check if there is any tl error, return 1 in case of error or if it is an unmapped addr
  // if it is data channel, will check if d_error is set correctly
  //  - access unmapped address
  //  - memory/register write addr isn't word-aligned
  //  - memory write isn't full word
  //  - register write size is less than actual register width
  //  - TL protocol violation
  virtual function bit predict_tl_err(tl_seq_item item, tl_channels_e channel);
    bit is_tl_unmapped_addr, is_tl_err, mem_access_err;
    bit csr_aligned_err, csr_size_err, tl_item_err;

    if (!is_tl_access_mapped_addr(item)) begin
      is_tl_unmapped_addr = 1;
      // if devmode is enabled, d_error will be set
      if (cfg.en_devmode || cfg.devmode_vif.sample()) begin
        is_tl_err = 1;
      end
    end

    mem_access_err  = !is_tl_mem_access_allowed(item);
    csr_aligned_err = !is_tl_csr_write_addr_word_aligned(item);
    csr_size_err    = !is_tl_csr_write_size_gte_csr_width(item);
    tl_item_err     = item.get_exp_d_error();
    if (!is_tl_err && (mem_access_err || csr_aligned_err || csr_size_err || tl_item_err)) begin
      is_tl_err = 1;
    end
    if (channel == DataChannel) begin
      `DV_CHECK_EQ(item.d_error, is_tl_err,
          $sformatf("unmapped: %0d, mem_access_err: %0d, csr_aligned_err: %0d, csr_size_err: %0d, \
                    item_err: %0d", is_tl_unmapped_addr, mem_access_err, csr_aligned_err,
                    csr_size_err, tl_item_err))
    end
    return (is_tl_unmapped_addr || is_tl_err);
  endfunction

  // check if address is mapped
  virtual function bit is_tl_access_mapped_addr(tl_seq_item item);
    uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
    // check if it's mem addr or reg addr
    if (is_mem_addr(item) || addr inside {cfg.csr_addrs}) return 1;
    else                                                  return 0;
  endfunction

  // check if tl mem access will trigger error or not
  virtual function bit is_tl_mem_access_allowed(tl_seq_item item);
    if (is_mem_addr(item)) begin
      bit mem_partial_write_support;
      dv_base_mem mem;
      uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
      string mem_access = get_mem_access_by_addr(ral, addr);

      `downcast(mem, get_mem_by_addr(ral, addr))
      mem_partial_write_support = mem.get_mem_partial_write_support();

      // check if write isn't full word for mem that doesn't allow byte access
      if (!mem_partial_write_support && (item.a_size != 2 || item.a_mask != '1) &&
           item.a_opcode inside {tlul_pkg::PutFullData, tlul_pkg::PutPartialData}) begin
        return 0;
      end
      // check if mem read happens while mem doesn't allow read (WO)
      if (mem_access == "WO" && (item.a_opcode == tlul_pkg::Get)) return 0;
    end
    return 1;
  endfunction

  // check if csr write word-aligned
  virtual function bit is_tl_csr_write_addr_word_aligned(tl_seq_item item);
    if (item.is_write() && item.a_addr[1:0] != 0 && !is_mem_addr(item)) return 0;
    else                                                                return 1;
  endfunction

  // check if csr write size greater or equal to csr width
  virtual function bit is_tl_csr_write_size_gte_csr_width(tl_seq_item item);
    if (!is_tl_access_mapped_addr(item) || is_mem_addr(item)) return 1;
    if (item.is_write()) begin
      dv_base_reg    csr;
      uvm_reg_addr_t addr = ral.get_word_aligned_addr(item.a_addr);
      `DV_CHECK_FATAL($cast(csr,
                            ral.default_map.get_reg_by_offset(addr)))
      if (csr.get_msb_pos >= 24 && item.a_mask[3:0] != 'b1111 ||
          csr.get_msb_pos >= 16 && item.a_mask[2:0] != 'b111  ||
          csr.get_msb_pos >= 8  && item.a_mask[1:0] != 'b11   ||
          item.a_mask[0] != 'b1) begin
        return 0;
      end
    end
    return 1;
  endfunction

  virtual function void reset(string kind = "HARD");
    tl_a_chan_fifo.flush();
    tl_d_chan_fifo.flush();
  endfunction

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(tl_seq_item, tl_a_chan_fifo)
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(tl_seq_item, tl_d_chan_fifo)
  endfunction

endclass
