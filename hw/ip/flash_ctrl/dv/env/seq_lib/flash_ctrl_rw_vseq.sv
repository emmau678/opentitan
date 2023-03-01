// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class flash_ctrl_rw_vseq extends flash_ctrl_otf_base_vseq;
  `uvm_object_utils(flash_ctrl_rw_vseq)
  `uvm_object_new
  flash_op_t ctrl;
  int num, bank;

  virtual task body();
    int otf_wr_pct_temp;
    cfg.clk_rst_vif.wait_clks(5);

    fork
      begin
        repeat(cfg.otf_num_rw) begin
          `DV_CHECK_RANDOMIZE_FATAL(this)
          ctrl = rand_op;
          bank = rand_op.addr[OTFBankId];
          if (ctrl.partition == FlashPartData) begin
            num = ctrl_num;
          end else begin
            num = ctrl_info_num;
          end
          // If the partition that selected configured as read-only, skip the program
          if ((cfg.otf_wr_pct != 0) &&
              ((cfg.seq_cfg.op_readonly_on_info_partition &&
                rand_op.partition == FlashPartInfo) ||
               (cfg.seq_cfg.op_readonly_on_info1_partition &&
                rand_op.partition == FlashPartInfo1))) begin
            otf_wr_pct_temp = cfg.otf_wr_pct;
            cfg.otf_wr_pct = 0;
          end else begin
            cfg.otf_wr_pct = otf_wr_pct_temp;
          end
          randcase
            cfg.otf_wr_pct:prog_flash(ctrl, bank, num, fractions);
            cfg.otf_rd_pct:read_flash(ctrl, bank, num, fractions);
          endcase
        end
      end
      begin
        launch_host_rd();
      end
    join
  endtask

  virtual task launch_host_rd();
    for (int i = 0; i < cfg.otf_num_hr; ++i) begin
      fork
        send_rand_host_rd();
      join_none
      #0;
    end
    csr_utils_pkg::wait_no_outstanding_access();
  endtask
endclass // flash_ctrl_rw_vseq
