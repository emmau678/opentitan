// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class flash_ctrl_base_vseq extends cip_base_vseq #(
    .RAL_T               (flash_ctrl_reg_block),
    .CFG_T               (flash_ctrl_env_cfg),
    .COV_T               (flash_ctrl_env_cov),
    .VIRTUAL_SEQUENCER_T (flash_ctrl_virtual_sequencer)
  );
  `uvm_object_utils(flash_ctrl_base_vseq)

  // flash ctrl configuration settings.

  constraint num_trans_c {
    num_trans inside {[1:cfg.seq_cfg.max_num_trans]};
  }

  `uvm_object_new

  virtual task dut_shutdown();
    // check for pending flash_ctrl operations and wait for them to complete
    // TODO
  endtask

  virtual task apply_reset(string kind = "HARD");
    super.apply_reset(kind);
    if (kind == "HARD") begin
      cfg.clk_rst_vif.wait_clks(cfg.post_reset_delay_clks);
    end
  endtask

  // Configure the memory protection regions.
  virtual task flash_ctrl_mp_region_cfg(uint index, flash_ctrl_mp_region_t region_cfg);
    uvm_reg_data_t data;
    uvm_reg csr;
    data =
        get_csr_val_with_updated_field(ral.mp_region_cfg0.en0, data, region_cfg.en) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.rd_en0, data, region_cfg.read_en) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.prog_en0, data, region_cfg.program_en) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.erase_en0, data, region_cfg.erase_en) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.base0, data, region_cfg.start_page) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.size0, data, region_cfg.num_pages) |
        get_csr_val_with_updated_field(ral.mp_region_cfg0.partition0, data, region_cfg.partition);
    csr = ral.get_reg_by_name($sformatf("mp_region_cfg%0d", index));
    csr_wr(.csr(csr), .value(data));
  endtask

  // Configure the protection for the "default" region (all pages that do not fall into one
  // of the memory protection regions).
  virtual task flash_ctrl_default_region_cfg(bit read_en, bit program_en, bit erase_en);
    uvm_reg_data_t data;

    data = get_csr_val_with_updated_field(ral.default_region.rd_en, data, read_en) |
           get_csr_val_with_updated_field(ral.default_region.prog_en, data, program_en) |
           get_csr_val_with_updated_field(ral.default_region.erase_en, data, erase_en);
    csr_wr(.csr(ral.default_region), .value(data));
  endtask

  // Configure bank erasability.
  virtual task flash_ctrl_bank_erase_cfg(bit [FLASH_CTRL_NUM_BANKS-1:0] bank_erase_en);
    csr_wr(.csr(ral.mp_bank_cfg), .value(bank_erase_en));
  endtask

  // Configure read and program fifo levels for interrupt.
  virtual task flash_ctrl_fifo_levels_cfg_intr(uint read_fifo_intr_level,
                                               uint program_fifo_intr_level);
    uvm_reg_data_t data;

    data = get_csr_val_with_updated_field(ral.fifo_lvl.prog, data, program_fifo_intr_level) |
           get_csr_val_with_updated_field(ral.fifo_lvl.rd, data, read_fifo_intr_level);
    csr_wr(.csr(ral.fifo_lvl), .value(data));
  endtask

  // Reset the program and read fifos.
  virtual task flash_ctrl_fifo_reset(bit reset = 1'b1);
    csr_wr(.csr(ral.fifo_rst), .value(reset));
  endtask

  // Wait for flash_ctrl op to finish.
  virtual task wait_flash_ctrl_op_done(bit clear_op_status = 1'b1);
    uvm_reg_data_t data;
    bit done;
    `DV_SPINWAIT(
      do begin
        csr_rd(.ptr(ral.op_status), .value(data));
        done = get_field_val(ral.op_status.done, data);
      end while (done == 1'b0);,
      "wait_flash_ctrl_op_done timeout occurred!"
    )
    if (clear_op_status) begin
      data = get_csr_val_with_updated_field(ral.op_status.done, data, 0);
      csr_wr(.csr(ral.op_status), .value(data));
    end
  endtask

  // Wait for flash_ctrl op to finish with error.
  virtual task wait_flash_ctrl_op_err(bit clear_op_status = 1'b1);
    uvm_reg_data_t data;
    bit err;
    `DV_SPINWAIT(
      do begin
        csr_rd(.ptr(ral.op_status), .value(data));
        err = get_field_val(ral.op_status.err, data);
      end while (err == 1'b0);,
      "wait_flash_ctrl_op_err timeout occurred!"
    )
    if (clear_op_status) begin
      data = get_csr_val_with_updated_field(ral.op_status.err, data, 0);
      csr_wr(.csr(ral.op_status), .value(data));
    end
  endtask

  // Wait for prog fifo to not be full.
  virtual task wait_flash_ctrl_prog_fifo_not_full();
    bit prog_full;
    `DV_SPINWAIT(
      do begin
        csr_rd(.ptr(ral.status.prog_full), .value(prog_full));
      end while (prog_full);,
      "wait_flash_ctrl_prog_fifo_not_full timeout occurred!"
    )
  endtask

  // Wait for rd fifo to not be empty.
  virtual task wait_flash_ctrl_rd_fifo_not_empty();
    bit read_empty;
    `DV_SPINWAIT(
      do begin
        csr_rd(.ptr(ral.status.rd_empty), .value(read_empty));
      end while (read_empty);,
      "wait_flash_ctrl_rd_fifo_not_empty timeout occurred!"
    )
  endtask

  virtual task flash_ctrl_start_op(flash_ctrl_single_op_t flash_ctrl_op);
    uvm_reg_data_t data;

    csr_wr(.csr(ral.addr), .value(flash_ctrl_op.addr));

    data =
        get_csr_val_with_updated_field(ral.control.start, data, 1'b1) |
        get_csr_val_with_updated_field(ral.control.op, data, flash_ctrl_op.op) |
        get_csr_val_with_updated_field(ral.control.erase_sel, data, flash_ctrl_op.erase_type) |
        get_csr_val_with_updated_field(ral.control.partition_sel, data, flash_ctrl_op.partition) |
        get_csr_val_with_updated_field(ral.control.num, data, flash_ctrl_op.num_words - 1);
    csr_wr(.csr(ral.control), .value(data));
  endtask

  // Program data into flash, stopping whenever full.
  // The flash op is assumed to have already commenced.
  virtual task flash_ctrl_write(bit [TL_DW-1:0] data[$]);
    foreach (data[i]) begin
      // Check if prog fifo is full. If yes, then wait for space to become available.
      // TODO: interface is backpressure enabled, so the above check is not needed atm.
      // TODO: if intr enabled, then check interrupt, else check status.
      // wait_flash_ctrl_prog_fifo_not_full();
      mem_wr(.ptr(ral.prog_fifo), .offset(0), .data(data[i]));
      `uvm_info(`gfn, $sformatf("flash_ctrl_write: 0x%0h", data[i]), UVM_HIGH)
    end
  endtask

  // Read data from flash, stopping whenever empty.
  // The flash op is assumed to have already commenced.
  virtual task flash_ctrl_read(uint num_words, ref bit [TL_DW-1:0] data[$]);
    for (int i = 0; i < num_words; i++) begin
      // Check if rd fifo is empty. If yes, then wait for data to become available.
      // TODO: interface is backpressure enabled, so the above check is not needed atm.
      // TODO: if intr enabled, then check interrupt, else check status.
      // wait_flash_ctrl_rd_fifo_not_empty();
      mem_rd(.ptr(ral.rd_fifo), .offset(0), .data(data[i]));
      `uvm_info(`gfn, $sformatf("flash_ctrl_read: 0x%0h", data[i]), UVM_HIGH)
    end
  endtask

  // Convenience function to clear / set / randomize flash memory. Operates in the entire
  // flash memory.
  virtual function void flash_mem_bkdr_init(flash_mem_init_e flash_mem_init);
    case (flash_mem_init)
      FlashMemInitSet: begin
        foreach (cfg.mem_bkdr_vifs[i]) cfg.mem_bkdr_vifs[i].set_mem();
      end
      FlashMemInitClear: begin
        foreach (cfg.mem_bkdr_vifs[i]) cfg.mem_bkdr_vifs[i].clear_mem();
      end
      FlashMemInitRandomize: begin
        foreach (cfg.mem_bkdr_vifs[i]) cfg.mem_bkdr_vifs[i].randomize_mem();
      end
      FlashMemInitInvalidate: begin
        foreach (cfg.mem_bkdr_vifs[i]) cfg.mem_bkdr_vifs[i].invalidate_mem();
      end
    endcase
  endfunction

  // Reads flash mem contents via backdoor.
  // The addr arg need not be word aligned- its the same addr programmed into the `control` CSR.
  // TODO: support for partition.
  virtual function void flash_mem_bkdr_read(flash_ctrl_single_op_t flash_ctrl_op,
                                            ref logic [TL_DW-1:0] data[$]);
    flash_mem_addr_attrs addr_attrs = new(flash_ctrl_op.addr);
    data.delete();
    for (int i = 0; i < flash_ctrl_op.num_words; i++) begin
      data[i] = cfg.mem_bkdr_vifs[addr_attrs.bank].read32(addr_attrs.bank_addr);
      `uvm_info(`gfn, $sformatf("flash_mem_bkdr_read: {%s} = 0x%0h",
                                addr_attrs.sprint(), data[i]), UVM_LOW)
      addr_attrs.incr(TL_DBW);
    end
  endfunction

  // Helper macro for the `flash_mem_bkdr_write` function below.
`define FLASH_MEM_BKDR_WRITE_CASE(_data) \
  for (int i = 0; i < flash_ctrl_op.num_words; i++) begin \
    logic [TL_DW-1:0] loc_data = _data; \
    cfg.mem_bkdr_vifs[addr_attrs.bank].write32(addr_attrs.bank_addr, loc_data); \
    `uvm_info(`gfn, $sformatf("flash_mem_bkdr_write: {%s} = 0x%0h", \
                              addr_attrs.sprint(), loc_data), UVM_LOW) \
    addr_attrs.incr(TL_DBW); \
  end

  // Writes the flash mem contents via backdoor.
  // The addr arg need not be word aligned- its the same addr programmed into the `control` CSR.
  // TODO: support for partition.
  virtual function void flash_mem_bkdr_write(flash_ctrl_single_op_t flash_ctrl_op,
                                             flash_mem_init_e flash_mem_init,
                                             logic [TL_DW-1:0] data[$] = {});
    flash_mem_addr_attrs addr_attrs = new(flash_ctrl_op.addr);
    case (flash_mem_init)
      FlashMemInitCustom: begin
        flash_ctrl_op.num_words = data.size();
        `FLASH_MEM_BKDR_WRITE_CASE(data[i])
      end
      FlashMemInitSet: begin
        `FLASH_MEM_BKDR_WRITE_CASE({TL_DW{1'b1}})
      end
      FlashMemInitClear: begin
        `FLASH_MEM_BKDR_WRITE_CASE({TL_DW{1'b0}})
      end
      FlashMemInitRandomize: begin
        `FLASH_MEM_BKDR_WRITE_CASE($urandom)
      end
      FlashMemInitInvalidate: begin
        `FLASH_MEM_BKDR_WRITE_CASE({TL_DW{1'bx}})
      end
    endcase
  endfunction

`undef FLASH_MEM_BKDR_WRITE_CASE

  // Checks flash mem contents via backdoor.
  // The addr arg need not be word aligned- its the same addr programmed into the `control` CSR.
  // TODO: support for partition.
  virtual function void flash_mem_bkdr_read_check(flash_ctrl_single_op_t flash_ctrl_op,
                                                  bit [TL_DW-1:0] exp_data[$]);
    logic [TL_DW-1:0] data[$];
    flash_mem_bkdr_read(flash_ctrl_op, data);
    foreach (data[i]) begin
      `DV_CHECK_CASE_EQ(data[i], exp_data[i])
    end
  endfunction

  // Ensure that the flash page / bank has indeed been erased.
  virtual function void flash_mem_bkdr_erase_check(flash_ctrl_single_op_t flash_ctrl_op);
    flash_mem_addr_attrs    addr_attrs = new(flash_ctrl_op.addr);
    bit [TL_AW-1:0]         start_addr;
    uint                    num_words;

    case (flash_ctrl_op.erase_type)
      FlashCtrlErasePage: begin
        start_addr = addr_attrs.page_start_addr;
        num_words = FLASH_CTRL_PAGE_NUM_BUS_WORDS;
      end
      FlashCtrlEraseBank: begin
        // TODO: check if bank erase was supported
        start_addr = addr_attrs.bank_start_addr;
        num_words = FLASH_CTRL_BANK_NUM_BUS_WORDS;
      end
      default: begin
        `uvm_fatal(`gfn, $sformatf("Invalid erase_type: %0s", flash_ctrl_op.erase_type.name()))
      end
    endcase

    for (int i = 0; i < num_words; i++) begin
      logic [TL_DW-1:0] data;
      addr_attrs.incr(TL_DBW);
      data = cfg.mem_bkdr_vifs[addr_attrs.bank].read32(addr_attrs.bank_addr);
      `DV_CHECK_CASE_EQ(data, '1)
    end
  endfunction

endclass : flash_ctrl_base_vseq
