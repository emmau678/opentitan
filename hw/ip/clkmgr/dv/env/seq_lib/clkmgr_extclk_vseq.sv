// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// The extclk vseq causes the external clock selection to be triggered. More details
// in the clkmgr_testplan.hjson file.
class clkmgr_extclk_vseq extends clkmgr_base_vseq;
  `uvm_object_utils(clkmgr_extclk_vseq)

  `uvm_object_new

  // When extclk_ctrl_regwen is clear it is not possible to select external clocks.
  // This is tested in regular csr_rw, so here this register is simply set to 1.

  // lc_debug_en is set according to sel_lc_debug_en, which is randomized with weights.
  lc_tx_t            lc_debug_en;
  rand lc_tx_t       lc_debug_en_other;
  rand lc_tx_t_sel_e sel_lc_debug_en;

  constraint lc_debug_en_c {
    sel_lc_debug_en dist {
      LcTxTSelOn    := 8,
      LcTxTSelOff   := 2,
      LcTxTSelOther := 2
    };
    !(lc_debug_en_other inside {On, Off});
  }

  // lc_clk_byp_req is set according to sel_lc_clk_byp_req, which is randomized with weights.
  lc_tx_t            lc_clk_byp_req;
  rand lc_tx_t       lc_clk_byp_req_other;
  rand lc_tx_t_sel_e sel_lc_clk_byp_req;

  constraint lc_clk_byp_req_c {
    sel_lc_clk_byp_req dist {
      LcTxTSelOn    := 8,
      LcTxTSelOff   := 2,
      LcTxTSelOther := 2
    };
    !(lc_clk_byp_req_other inside {On, Off});
  }

  // The extclk cannot be manipulated in low power mode.
  constraint io_ip_clk_en_on_c {io_ip_clk_en == 1'b1;}
  constraint main_ip_clk_en_on_c {main_ip_clk_en == 1'b1;}
  constraint usb_ip_clk_en_on_c {usb_ip_clk_en == 1'b1;}

  // This randomizes the time when the extclk_ctrl CSR write and the lc_clk_byp_req
  // input is asserted for good measure. Of course, there is a good chance only a single
  // one of these trigger a request, so they are also independently tested.
  rand int cycles_before_extclk_ctrl_sel;
  rand int cycles_before_lc_clk_byp_req;
  rand int cycles_before_lc_clk_byp_ack;
  rand int cycles_before_all_clk_byp_ack;
  rand int cycles_before_io_clk_byp_ack;
  rand int cycles_before_next_trans;

  constraint cycles_to_stim_c {
    cycles_before_extclk_ctrl_sel inside {[4 : 20]};
    cycles_before_lc_clk_byp_req inside {[4 : 20]};
    cycles_before_lc_clk_byp_ack inside {[12 : 20]};
    cycles_before_all_clk_byp_ack inside {[3 : 11]};
    cycles_before_io_clk_byp_ack inside {[3 : 11]};
    cycles_before_next_trans inside {[15 : 25]};
  }

  function void post_randomize();
    super.post_randomize();
    lc_debug_en = get_lc_tx_t_from_sel(sel_lc_debug_en, lc_debug_en_other);
    lc_clk_byp_req = get_lc_tx_t_from_sel(sel_lc_clk_byp_req, lc_clk_byp_req_other);
  endfunction

  task body();
    update_csrs_with_reset_values();
    set_scanmode_on_low_weight();
    csr_wr(.ptr(ral.extclk_ctrl_regwen), .value(1));
    fork
      forever
        // Notice only all_clk_byp_req Mubi4True and Mubi4False cause transitions.
        @cfg.clkmgr_vif.all_clk_byp_req begin : all_clk_byp_ack
          if (cfg.clkmgr_vif.all_clk_byp_req == prim_mubi_pkg::MuBi4True) begin
            `uvm_info(`gfn, "Got all_clk_byp_req on", UVM_MEDIUM)
            cfg.clk_rst_vif.wait_clks(cycles_before_all_clk_byp_ack);
            cfg.clkmgr_vif.update_all_clk_byp_ack(prim_mubi_pkg::MuBi4True);
          end else if (cfg.clkmgr_vif.all_clk_byp_req == prim_mubi_pkg::MuBi4False) begin
            `uvm_info(`gfn, "Got all_clk_byp_req off", UVM_MEDIUM)
            cfg.clk_rst_vif.wait_clks(cycles_before_all_clk_byp_ack);
            cfg.clkmgr_vif.update_all_clk_byp_ack(prim_mubi_pkg::MuBi4False);
          end
        end
      forever
        @cfg.clkmgr_vif.io_clk_byp_req begin : io_clk_byp_ack
          if (cfg.clkmgr_vif.io_clk_byp_req == prim_mubi_pkg::MuBi4True) begin
            `uvm_info(`gfn, "Got io_clk_byp_req on", UVM_MEDIUM)
            cfg.clk_rst_vif.wait_clks(cycles_before_io_clk_byp_ack);
            cfg.clkmgr_vif.update_io_clk_byp_ack(prim_mubi_pkg::MuBi4True);
          end else begin
            `uvm_info(`gfn, "Got io_clk_byp_req off", UVM_MEDIUM)
            cfg.clk_rst_vif.wait_clks(cycles_before_io_clk_byp_ack);
            cfg.clkmgr_vif.update_io_clk_byp_ack(prim_mubi_pkg::MuBi4False);
          end
        end
      forever
        @cfg.clkmgr_vif.lc_clk_byp_ack begin : lc_clk_byp_ack
          if (cfg.clkmgr_vif.lc_clk_byp_ack == lc_ctrl_pkg::On) begin
            `uvm_info(`gfn, "Got lc_clk_byp_ack on", UVM_MEDIUM)
          end
        end
    join_none
    for (int i = 0; i < num_trans; ++i) begin
      `DV_CHECK_RANDOMIZE_FATAL(this)
      // Init needs to be synchronous.
      @cfg.clk_rst_vif.cb begin
        cfg.clkmgr_vif.init(.idle(idle), .scanmode(scanmode), .lc_debug_en(lc_debug_en));
        control_ip_clocks();
      end
      fork
        begin
          cfg.clk_rst_vif.wait_clks(cycles_before_extclk_ctrl_sel);
          csr_wr(.ptr(ral.extclk_ctrl), .value({extclk_ctrl_low_speed_sel, extclk_ctrl_sel}));
        end
        begin
          cfg.clk_rst_vif.wait_clks(cycles_before_lc_clk_byp_req);
          cfg.clkmgr_vif.update_lc_clk_byp_req(lc_clk_byp_req);
        end
      join
      `uvm_info(`gfn, $sformatf(
                {"extclk_ctrl_sel=0x%0x, extclk_ctrl_low_speed_sel=0x%0x, lc_clk_byp_req=0x%0x, ",
                 "lc_debug_en=0x%0x, scanmode=0x%0x"},
                extclk_ctrl_sel,
                extclk_ctrl_low_speed_sel,
                lc_clk_byp_req,
                lc_debug_en,
                scanmode
                ), UVM_MEDIUM)
      csr_rd_check(.ptr(ral.extclk_ctrl),
                   .compare_value({extclk_ctrl_low_speed_sel, extclk_ctrl_sel}));
      if (lc_clk_byp_req == lc_ctrl_pkg::On) begin
        wait(cfg.clkmgr_vif.lc_clk_byp_req == lc_ctrl_pkg::On);
        cfg.clk_rst_vif.wait_clks(cycles_before_lc_clk_byp_ack);
        cfg.clkmgr_vif.update_lc_clk_byp_req(lc_ctrl_pkg::Off);
      end
      cfg.clk_rst_vif.wait_clks(cycles_before_next_trans);
    end
    disable fork;
  endtask

endclass
