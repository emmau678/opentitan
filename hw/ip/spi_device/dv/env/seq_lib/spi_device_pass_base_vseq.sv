// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Passthrough base sequence
class spi_device_pass_base_vseq extends spi_device_base_vseq;
  // only enable this in 1-2 tests
  bit allow_set_cmd_info_invalid;
  bit allow_use_invalid_opcode;

  // knob to enable testing addr/payload swap
  bit allow_addr_swap;
  bit allow_payload_swap;
  int addr_payload_swap_pct = 30;

  bit allow_intercept;
  bit allow_upload;

  bit allow_write_enable_disable;
  bit allow_addr_cfg_cmd;
  // we can only hold one payload, set it busy to avoid payload is overwritten before read out.
  bit always_set_busy_when_upload_contain_payload;

  // knob to control read_buffer_update thread
  bit stop_forever_read_buffer_update;
  bit read_buffer_update_ongoing;

  rand device_mode_e device_mode;

  // overide this to enable other modes
  constraint device_mode_c {
    device_mode == PassthroughMode;
  }

  bit [7:0] valid_opcode_q[$];
  rand bit valid_op;
  rand bit [7:0] opcode;
  constraint opcode_c {
    solve valid_op before opcode;
    if (allow_use_invalid_opcode) {
      valid_op dist {1 :/ 4, 0 :/ 1};
    } else {
      valid_op == 1;
    }

    if (valid_op && valid_opcode_q.size > 0) {
      opcode inside {valid_opcode_q};
    } else {
      !(opcode inside {valid_opcode_q});
    }
  }
  // the start addr and payload size matter to the read command
  // for program or other cmd, addr and payload size don't matter,
  // but we could still use this constraint for them
  bit [31:0] mbx_start_addr;
  bit [31:0] mbx_end_addr;
  rand bit [31:0] read_start_addr;
  rand bit [31:0] read_end_addr;
  rand uint payload_size;
  rand read_addr_size_type_e read_addr_size_type;

  int large_payload_weight = 1;
  constraint payload_size_c {
    payload_size dist {
        [0:5]    :/ 2,
        128      :/ 1,
        256      :/ 2, // typical value for a flash page size
        512      :/ 1,
        [6:3000] :/ 1};
  }

  constraint read_addr_size_type_c {
    read_start_addr + payload_size == read_end_addr;

    if (read_addr_size_type == ReadAddrWithinMailbox) {
      read_start_addr inside {[mbx_start_addr:mbx_end_addr]} &&
      read_end_addr inside {[mbx_start_addr:mbx_end_addr]};
    } else if (read_addr_size_type == ReadAddrCrossIntoMailbox) {
      read_start_addr inside {[mbx_start_addr:mbx_end_addr]} && read_end_addr > mbx_end_addr;
    } else if (read_addr_size_type == ReadAddrCrossOutOfMailbox) {
      read_start_addr < mbx_start_addr && read_end_addr inside {[mbx_start_addr:mbx_end_addr]};
    } else if (read_addr_size_type == ReadAddrCrossAllMailbox) {
      read_start_addr < mbx_start_addr && read_end_addr > mbx_end_addr;
    } else { // ReadAddrOutsideMailbox
      // both start and end addr are less than mbx_start_addr
      (read_start_addr < mbx_start_addr &&
       (read_start_addr + payload_size) < mbx_start_addr) ||
      // read end addr is bigger than mbx_end_addr. And not cross all 1s boundary, or
      // read end addr is less than mbx_start_addr if crossing boundary
      (read_start_addr > mbx_end_addr &&
       (read_start_addr + payload_size <= {32{1'b1}} || read_end_addr < mbx_start_addr));
    }
  }

  constraint addr_size_and_device_mode_c {
    // flash mode doesn't support mailbox boundary crossing.
    device_mode == FlashMode ->
      read_addr_size_type inside {ReadAddrWithinMailbox, ReadAddrOutsideMailbox};
  }

  rand bit [9:0] read_threshold_val;
  constraint read_threshold_val_c {
    read_threshold_val dist {
        0         :/ 1,
        [1:4]     :/ 1,
        [5:'h3fe] :/ 3,
        'h3ff     :/ 1};
  }
  `uvm_object_utils(spi_device_pass_base_vseq)
  `uvm_object_new

  function void randomize_op_addr_size();
    mbx_start_addr = get_mbx_base_addr(ral);
    mbx_end_addr   = mbx_start_addr + MAILBOX_BUFFER_SIZE;

    `DV_CHECK(this.randomize(opcode, valid_op,
      read_start_addr, read_end_addr, payload_size, read_addr_size_type))
  endfunction

  // Task for adding cmd info
  virtual task config_all_cmd_infos();
    spi_flash_cmd_info info = spi_flash_cmd_info::type_id::create("info");

    // clean up previous configure cmd_infos
    cfg.spi_host_agent_cfg.cmd_infos.delete();
    cfg.spi_device_agent_cfg.cmd_infos.delete();

    // Configure the first 11 commands which are fixed
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode == SpiFlashAddrDisabled &&
      info.opcode == READ_STATUS_1 &&
      info.num_lanes == 1 &&
      info.dummy_cycles == 0 &&
      info.write_command == 0;)
    add_cmd_info(info, 0);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode == SpiFlashAddrDisabled &&
      info.opcode == READ_STATUS_2;
      info.num_lanes == 1 &&
      info.dummy_cycles == 0 &&
      info.write_command == 0;)
    add_cmd_info(info, 1);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode == SpiFlashAddrDisabled &&
      info.opcode == READ_STATUS_3 &&
      info.num_lanes == 1 &&
      info.dummy_cycles == 0 &&
      info.write_command == 0;)
    add_cmd_info(info, 2);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode == SpiFlashAddrDisabled &&
      info.opcode == READ_JEDEC &&
      info.num_lanes == 1 &&
      info.dummy_cycles == 0 &&
      info.write_command == 0;)
    add_cmd_info(info, 3);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode == SpiFlashAddr3b &&
      info.opcode == READ_SFDP;
      info.num_lanes == 1 &&
      info.write_command == 0;)
    add_cmd_info(info, 4);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_NORMAL &&
      info.num_lanes == 1 &&
      info.write_command == 0;)
    add_cmd_info(info, 5);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_FAST &&
      info.num_lanes == 1 &&
      info.write_command == 0;)
    add_cmd_info(info, 6);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_DUAL &&
      info.write_command == 0 &&
      info.num_lanes == 2;)
    add_cmd_info(info, 7);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_QUAD &&
      info.write_command == 0 &&
      info.num_lanes == 4;)
    add_cmd_info(info, 8);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_DUALIO &&
      info.write_command == 0 &&
      info.num_lanes == 2;)
    add_cmd_info(info, 9);
    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      info.addr_mode != SpiFlashAddrDisabled &&
      info.opcode == READ_QUADIO &&
      info.write_command == 0 &&
      info.num_lanes == 4;)
    add_cmd_info(info, 10);


    if (allow_write_enable_disable) begin
      bit valid;
      randomize_cfg_cmd_info(info, WREN, valid);
      ral.cmd_info_wren.valid.set(valid);
      if (valid) ral.cmd_info_wren.opcode.set(info.opcode);
      else       `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info_wren.opcode)
      csr_update(ral.cmd_info_wren);

      randomize_cfg_cmd_info(info, WRDI, valid);
      ral.cmd_info_wrdi.valid.set(valid);
      if (valid) ral.cmd_info_wrdi.opcode.set(info.opcode);
      else       `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info_wrdi.opcode)
      csr_update(ral.cmd_info_wrdi);
    end

    if (allow_addr_cfg_cmd) begin
      bit valid;
      randomize_cfg_cmd_info(info, EN4B, valid);
      ral.cmd_info_en4b.valid.set(valid);
      if (valid) ral.cmd_info_en4b.opcode.set(info.opcode);
      else       `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info_en4b.opcode)
      csr_update(ral.cmd_info_en4b);

      randomize_cfg_cmd_info(info, EX4B, valid);
      ral.cmd_info_ex4b.valid.set(valid);
      if (valid) ral.cmd_info_ex4b.opcode.set(info.opcode);
      else       `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info_ex4b.opcode)
      csr_update(ral.cmd_info_ex4b);
    end

    for (int i = 11; i < 24; i++) begin
      info = spi_flash_cmd_info::type_id::create("info");
      `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
        foreach (cfg.spi_host_agent_cfg.cmd_infos[j]) {info.opcode != j;})
      add_cmd_info(info, i);
    end

    valid_opcode_q = cfg.spi_host_agent_cfg.cmd_infos.find_index() with ('1);
  endtask : config_all_cmd_infos

  // Task for configuring 4 special cmd info slot - wren, wrdi, en4b, ex4b.
  // use ref as info is re-created in the function
  virtual function void randomize_cfg_cmd_info(ref spi_flash_cmd_info info,
                                               input bit [7:0] opcode,
                                               output bit valid);
    if (allow_set_cmd_info_invalid) valid = $urandom_range(0, 1);
    else valid = 1;

    if (!valid) return;

    info = spi_flash_cmd_info::type_id::create("info");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(info,
      opcode == local::opcode;
      // no addr, no payload
      addr_mode == SpiFlashAddrDisabled;
      num_lanes == 0;
      write_command == 0;
    )

    cfg.spi_host_agent_cfg.add_cmd_info(info);
    cfg.spi_device_agent_cfg.add_cmd_info(info);
    `uvm_info(`gfn, $sformatf("Add this cfg cmd_info \n%s", info.sprint()), UVM_MEDIUM)
  endfunction

  // Task for flash or pass init
  virtual task spi_device_flash_pass_init();
    spi_device_init();
    `uvm_info(`gfn, "Initialize flash/passthrough mode", UVM_MEDIUM)
    // TODO, fixed config for now
    cfg.spi_host_agent_cfg.sck_polarity[0] = 0;
    cfg.spi_host_agent_cfg.sck_phase[0] = 0;
    cfg.spi_device_agent_cfg.sck_polarity[0] = 0;
    cfg.spi_device_agent_cfg.sck_phase[0] = 0;

    // bit dir is only supported in fw mode. Need to be 0 for other modes
    cfg.spi_host_agent_cfg.host_bit_dir = 0;
    cfg.spi_host_agent_cfg.device_bit_dir = 0;
    cfg.spi_device_agent_cfg.host_bit_dir = 0;
    cfg.spi_device_agent_cfg.device_bit_dir = 0;

    cfg.spi_host_agent_cfg.num_bytes_per_trans_in_mon = 1;
    cfg.spi_device_agent_cfg.num_bytes_per_trans_in_mon = 1;
    cfg.spi_host_agent_cfg.is_flash_mode = 1;
    cfg.spi_device_agent_cfg.is_flash_mode = 1;
    ral.cfg.tx_order.set(cfg.spi_host_agent_cfg.host_bit_dir);
    ral.cfg.rx_order.set(cfg.spi_host_agent_cfg.device_bit_dir);

    `DV_CHECK_RANDOMIZE_FATAL(ral.cfg.addr_4b_en)
    cfg.spi_host_agent_cfg.flash_addr_4b_en = ral.cfg.addr_4b_en.get();
    cfg.spi_device_agent_cfg.flash_addr_4b_en = ral.cfg.addr_4b_en.get();

    ral.cfg.cpol.set(1'b0);
    ral.cfg.cpha.set(1'b0);
    csr_update(.csr(ral.cfg)); // TODO check if randomization possible
    // Set the passthrough or flash mode mode
    `DV_CHECK(device_mode inside {FlashMode, PassthroughMode});
    ral.control.mode.set(device_mode);
    csr_update(.csr(ral.control));

    // addr/payload swap settting
    `DV_CHECK_RANDOMIZE_FATAL(ral.addr_swap_mask)
    csr_update(.csr(ral.addr_swap_mask));
    `DV_CHECK_RANDOMIZE_FATAL(ral.addr_swap_data)
    csr_update(.csr(ral.addr_swap_data));
    `DV_CHECK_RANDOMIZE_FATAL(ral.payload_swap_mask)
    csr_update(.csr(ral.payload_swap_mask));
    `DV_CHECK_RANDOMIZE_FATAL(ral.payload_swap_data)
    csr_update(.csr(ral.payload_swap_data));

    // configure intercept_en
    if (allow_intercept) begin
      // TODO, only support status intercept
      `DV_CHECK_RANDOMIZE_FATAL(ral.intercept_en.status)
      `DV_CHECK_RANDOMIZE_FATAL(ral.intercept_en.jedec)
      `DV_CHECK_RANDOMIZE_FATAL(ral.intercept_en.sfdp)
      ral.intercept_en.mbx.set(1); // TODO, randomize it
      csr_update(ral.intercept_en);
    end

    // in passthrough, if upload is enabled, need to enable status intercept, so that host side
    // can know if spi_device is busy or not
    if (allow_upload && device_mode == PassthroughMode && (`gmv(ral.intercept_en.status) == 0))
    begin
      ral.intercept_en.status.set(1);
      csr_update(ral.intercept_en);
    end

    `DV_CHECK_RANDOMIZE_WITH_FATAL(ral.mailbox_addr.addr,
        // the 4th byte needs to be 0 if the cmd only contains 3 bytes address
        // constrain this byte 50% to be 0.
        value[31:24] dist {0 :/ 1, [1:$] :/ 1};)
    csr_update(ral.mailbox_addr);
    ral.cfg.mailbox_en.set(1); // TODO, randomize it
    csr_update(ral.cfg);

    // randomize jedec
    `DV_CHECK_RANDOMIZE_FATAL(ral.jedec_cc.cc)
    `DV_CHECK_RANDOMIZE_WITH_FATAL(ral.jedec_cc.num_cc,
                                   value dist {0 :/ 2, [1:254] :/ 2, 255 :/ 1};)
    csr_update(.csr(ral.jedec_cc));
    `DV_CHECK_RANDOMIZE_FATAL(ral.jedec_id)
    csr_update(.csr(ral.jedec_id));

    // disable watermark event
    ral.read_threshold.set(read_threshold_val);
    csr_update(ral.read_threshold);

    config_all_cmd_infos();

    spi_device_flash_auto_rsp_nonblocking();
    random_write_spi_mem(.start_addr(0), .end_addr(SRAM_SIZE - 1));
    randomize_all_cmd_filters();
  endtask : spi_device_flash_pass_init

  // Task for configuring enable/disable of command opcode
  virtual task cfg_cmd_filter(bit not_enable, bit [7:0] cmd);
    bit [7:0] cmd_index;
    bit [7:0] cmd_offset;
    // Calculate filter bit position
    cmd_index = get_cmd_filter_index(cmd);
    cmd_offset = get_cmd_filter_offset(cmd);
    ral.cmd_filter[cmd_index].filter[cmd_offset].set(not_enable);
    csr_update(.csr(ral.cmd_filter[cmd_index]));
  endtask : cfg_cmd_filter

  virtual task randomize_all_cmd_filters();
    foreach (ral.cmd_filter[idx]) begin
      `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_filter[idx])
      csr_update(.csr(ral.cmd_filter[idx]));
    end
  endtask : randomize_all_cmd_filters

  // Task for configuring cmd info slot
  virtual task add_cmd_info(spi_flash_cmd_info info, bit [4:0] idx);
    bit [3:0] lanes_en;
    bit valid;
    bit swap;

    if (allow_set_cmd_info_invalid) valid = $urandom_range(0, 1);
    else valid = 1;

    if (valid) begin
      cfg.spi_host_agent_cfg.add_cmd_info(info);
      cfg.spi_device_agent_cfg.add_cmd_info(info);
    end

    `uvm_info(`gfn, $sformatf("Add this cmd_info \n%s", info.sprint()), UVM_MEDIUM)
    case (info.num_lanes)
      0: lanes_en = 0;
      1: lanes_en = info.write_command ? 4'h1 : 4'h2;
      2: lanes_en = 4'h3;
      4: lanes_en = 4'hF;
      default : `uvm_fatal(`gfn, $sformatf("Unsupported lanes num 0x%0h", info.num_lanes))
    endcase

    ral.cmd_info[idx].addr_mode.set(info.addr_mode);
    ral.cmd_info[idx].valid.set(valid); // Enable this OPCODE
    ral.cmd_info[idx].opcode.set(info.opcode);
    ral.cmd_info[idx].payload_en.set(lanes_en);
    ral.cmd_info[idx].payload_dir.set(!info.write_command);

    // set dummy cycles
    if (info.dummy_cycles > 0) begin
      ral.cmd_info[idx].dummy_en.set(1);
      ral.cmd_info[idx].dummy_size.set(info.dummy_cycles - 1);
    end else begin
      ral.cmd_info[idx].dummy_en.set(0);
      `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info[idx].dummy_size)
    end

    if (allow_addr_swap) begin
      swap = $urandom_range(0, 99) < addr_payload_swap_pct;
      if (swap) `uvm_info(`gfn, $sformatf("addr_swap is set for opcode 0x%0x", info.opcode),
                          UVM_MEDIUM)
    end else begin
      swap = 0;
    end
    ral.cmd_info[idx].addr_swap_en.set(swap);

    // only write and single mode allows payload swap
    if (allow_payload_swap && info.write_command && info.num_lanes == 1) begin
      swap = $urandom_range(0, 99) < addr_payload_swap_pct;
      if (swap) `uvm_info(`gfn, $sformatf("payload_swap is set for opcode 0x%0x", info.opcode),
                          UVM_MEDIUM)
    end else begin
      swap = 0;
    end
    ral.cmd_info[idx].payload_swap_en.set(swap);

    // configure upload
    // first 11 cmd doesn't support upload
    if (idx >= NUM_INTERNAL_PROCESSED_CMD && allow_upload) begin
      // upload only applies to program or no data
      if (ral.cmd_info[idx].payload_en.get() == 0 ||
          ral.cmd_info[idx].payload_dir.get() == PayloadIn) begin
        `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info[idx].upload)
      end else begin
        ral.cmd_info[idx].upload.set(0);
      end
    end

    // set busy enabled, when this flas is set and cmd is updated with payload
    if (always_set_busy_when_upload_contain_payload && ral.cmd_info[idx].upload.get()
       && (ral.cmd_info[idx].payload_en.get() == 0 ||
           ral.cmd_info[idx].payload_dir.get() == PayloadIn)) begin
      ral.cmd_info[idx].busy.set(1);
    end else begin
      `DV_CHECK_RANDOMIZE_FATAL(ral.cmd_info[idx].busy)
    end
    csr_update(.csr(ral.cmd_info[idx]));
  endtask : add_cmd_info

  virtual task random_access_flash_status(bit write = $urandom_range(0, 1),
                                          bit busy  = $urandom_range(0, 1),
                                          bit wel   = $urandom_range(0, 1),
                                          bit [21:0] other_status = $urandom());
    if (write) begin
      bit [23:0] status_val = {other_status, wel, busy};
      `uvm_info(`gfn, $sformatf("program flash_status: 0x%0h", ral.flash_status.get()), UVM_MEDIUM)
      csr_wr(.ptr(ral.flash_status), .value(status_val));

      cfg.clk_rst_vif.wait_clks(10);
    end else begin
      bit[TL_DW-1:0] val;
      csr_rd(ral.flash_status, val);
    end
  endtask

  virtual task clear_flash_busy_bit();
    `uvm_info(`gfn, "Clearing flash busy bit", UVM_MEDIUM)
    csr_wr(ral.flash_status.busy, 0);
    csr_spinwait(ral.flash_status.busy, 0);
  endtask

  // check if 3 upload fifo (cmd, addr, payload) are empty. If so, read all of them
  // if busy is set, clear it
  virtual task read_upload_fifos();
    bit [TL_DW-1:0] intr_state_val, status_val, status2_val;
    int cmdfifo_depth_val, addrfifo_depth_val, payload_depth_val;
    int payload_base_offset;
    bit busy_val;

    csr_rd(ral.intr_state, intr_state_val);
    csr_rd(ral.upload_status, status_val);
    csr_rd(ral.upload_status2, status2_val);

    cmdfifo_depth_val = get_field_val(ral.upload_status.cmdfifo_depth, status_val);
    addrfifo_depth_val = get_field_val(ral.upload_status.addrfifo_depth, status_val);
    payload_depth_val = get_field_val(ral.upload_status2.payload_depth, status2_val);

    if (`gmv(ral.intr_state.upload_cmdfifo_not_empty) == 0 &&
        `gmv(ral.intr_state.upload_payload_not_empty) == 0) begin
      return;
    end

    for (int i = 0; i < cmdfifo_depth_val; i++) begin
      bit [TL_DW-1:0] val;
      csr_rd(ral.upload_cmdfifo, val);
      `uvm_info(`gfn, $sformatf("read upload_cmdfifo: idx: %0d, data: 0x%0x", i, val), UVM_MEDIUM)
    end

    for (int i = 0; i < addrfifo_depth_val; i++) begin
      bit [TL_DW-1:0] val;
      csr_rd(ral.upload_addrfifo, val);
      `uvm_info(`gfn, $sformatf("read upload_addrfifo: idx: %0d, data: 0x%0x", i, val), UVM_MEDIUM)
    end

    if (payload_depth_val > PAYLOAD_FIFO_SIZE) payload_depth_val = PAYLOAD_FIFO_SIZE;
    // need to shift by 2 for the offset used at mem_rd
    payload_base_offset = (READ_BUFFER_SIZE + MAILBOX_BUFFER_SIZE + SFDP_SIZE) / 4;
    payload_depth_val = payload_depth_val / 4;
    for (int i = 0; i < payload_depth_val; i++) begin
      bit [TL_DW-1:0] val;
      int offset = i + payload_base_offset;
      mem_rd(.ptr(ral.buffer), .offset(offset), .data(val));
      `uvm_info(`gfn, $sformatf("read upload_payloadfifo: idx: %0d, data: 0x%0x", i, val),
                UVM_MEDIUM)
    end

    // clear interrupt
    csr_wr(ral.intr_state, intr_state_val);

    // clear busy bit
    csr_rd(ral.flash_status.busy, busy_val);
    if (busy_val == 1) clear_flash_busy_bit();
  endtask

  task post_start();
    super.post_start();
    // read flash_status for check
    random_access_flash_status(.write(0));

    // stop the read buffer thread and allow it to complete gracefully
    if (read_buffer_update_ongoing) begin
      stop_forever_read_buffer_update = 1;
      `DV_WAIT(!read_buffer_update_ongoing)
    end
  endtask

  virtual task read_and_check_4b_en();
    cfg.clk_rst_vif.wait_clks(10);
    csr_rd_check(.ptr(ral.cfg.addr_4b_en),
                 .compare_value(cfg.spi_device_agent_cfg.flash_addr_4b_en));
  endtask

  // read buffer can be divided into 2 half by flip events if threshold isn't set
  // |____________half0___________|____________half1___________|
  // |                          flip                         flip
  //
  // if threshold isn't 0, read buffer can be divided into 4 regions by watermark and flip events
  // |___region0___|___region1____|___region2___|___region3____|
  // |           watermark      flip          watermark      flip
  // once SW receives an interrupt, update the previous region, so that it won't affect SPI read
  // e.g. when 1st watermark occurs, update region0, then flip occurs, update 2nd region.
  virtual task  update_read_buffer(
      bit is_watermark_event, bit[TL_AW-1:0] last_read_addr);
    bit [TL_AW-1:0] start_addr;
    bit [TL_AW-1:0] end_addr;
    int threshold = `gmv(ral.read_threshold);
    int half_size = READ_BUFFER_SIZE / 2;

    if (threshold == 0) begin // 2 halfs
      if (last_read_addr inside {[half_size : READ_BUFFER_SIZE - 1]}) begin
        // half0
        start_addr = 0;
        end_addr   = half_size - 1;
      end else begin
        // half1
        start_addr = half_size;
        end_addr   = READ_BUFFER_SIZE - 1;
      end
    end else begin // 4 regions
      if (is_watermark_event) begin
        if (last_read_addr inside {[threshold : threshold + half_size - 1]}) begin
          // region0
          start_addr = 0;
          end_addr   = threshold - 1;
        end else begin
          // region2
          start_addr = half_size;
          end_addr   = half_size + threshold - 1;
        end
      end else begin // flip event
        if (last_read_addr inside {[half_size : READ_BUFFER_SIZE - 1]}) begin
          // region1
          start_addr = threshold;
          end_addr   = half_size - 1;
        end else begin
          // region3
          start_addr = half_size + threshold;
          end_addr   = READ_BUFFER_SIZE - 1;
        end
      end
    end
    random_write_spi_mem(start_addr, end_addr, "read buffer");
  endtask : update_read_buffer

  virtual task random_write_spi_mem(int start_addr, int end_addr, string msg_region = "mem");
    for (int i = start_addr / 4; i <= end_addr / 4; i++) begin
      bit [TL_DW-1:0] data = $urandom();
      mem_wr(.ptr(ral.buffer), .offset(i), .data(data));
      `uvm_info(`gfn, $sformatf("write %s offset 0x%0x: 0x%0x", msg_region, i << 2, data),
                UVM_MEDIUM)
    end
  endtask : random_write_spi_mem

  virtual task forever_read_buffer_update_nonblocking();
    fork
      begin
        read_buffer_update_ongoing = 1;
        while (!stop_forever_read_buffer_update) begin
          bit [TL_DW-1] intr_state_val, last_read_addr;
          bit is_watermark;
          bit is_flip;

          cfg.clk_rst_vif.wait_clks($urandom_range(10, 200));

          csr_rd(ral.intr_state, intr_state_val);
          is_watermark = get_field_val(ral.intr_state.readbuf_watermark, intr_state_val);
          is_flip = get_field_val(ral.intr_state.readbuf_flip, intr_state_val);
          csr_rd(ral.last_read_addr, last_read_addr);
          if (!is_watermark && !is_flip) continue;

          if (is_watermark) begin
            update_read_buffer(.is_watermark_event(1), .last_read_addr(last_read_addr));
          end
          // we may receive both watermark and flip if watermark threshold is close to half size
          if (is_flip) update_read_buffer(.is_watermark_event(0), .last_read_addr(last_read_addr));

          csr_wr(ral.intr_state, intr_state_val);
        end
        read_buffer_update_ongoing = 0;
      end
    join_none
  endtask : forever_read_buffer_update_nonblocking
endclass : spi_device_pass_base_vseq
