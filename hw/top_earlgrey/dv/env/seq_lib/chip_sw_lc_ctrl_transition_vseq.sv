// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class chip_sw_lc_ctrl_transition_vseq extends chip_sw_base_vseq;
  `uvm_object_utils(chip_sw_lc_ctrl_transition_vseq)

  `uvm_object_new

  // LC sends two 64-bit msg as input token.
  localparam uint ExitTokenWidthBit  = kmac_pkg::MsgWidth * 2;
  localparam uint ExitTokenWidthByte = ExitTokenWidthBit / 8;

  rand bit [7:0] lc_exit_token[ExitTokenWidthByte];

  constraint num_trans_c {
    num_trans inside {[2:3]};
  }

  virtual function void backdoor_override_otp();
    bit [otp_ctrl_reg_pkg::TestUnlockTokenSize-1:0] rand_unlock_token;
    `DV_CHECK_STD_RANDOMIZE_FATAL(rand_unlock_token)

    // Override the LC partition to TestUnlocked2.
    cfg.mem_bkdr_util_h[Otp].otp_write_lc_partition(lc_ctrl_state_pkg::LcStTestUnlocked2);

    // Override the test exit token to match SW test's input token.
    cfg.mem_bkdr_util_h[Otp].otp_write_secret0_partition(
        .unlock_token(rand_unlock_token),
        .exit_token(get_otp_exit_token(lc_exit_token)));
  endfunction

  virtual task dut_init(string reset_kind = "HARD");
    super.dut_init(reset_kind);
    backdoor_override_otp();
  endtask

  // This function takes the token value from LC_CTRL token CSRs, then runs through cshake128 to
  // get a 768-bit XORed token output.
  // The first 128 bits of the decoded token should match the OTP's secret0 paritition's
  // descrambled exit token value.
  virtual function bit [ExitTokenWidthBit-1:0] get_otp_exit_token(
      bit [7:0] token_in[ExitTokenWidthByte]);

    bit [7:0]                      dpi_digest[kmac_pkg::AppDigestW/8];
    bit [kmac_pkg::AppDigestW-1:0] digest_bits;

    digestpp_dpi_pkg::c_dpi_cshake128(token_in, "", "LC_CTRL", ExitTokenWidthByte,
                                      kmac_pkg::AppDigestW/8, dpi_digest);

    digest_bits = {<< byte {dpi_digest}};
    return (digest_bits[ExitTokenWidthBit-1:0]);
  endfunction

  virtual task body();
    super.body();

    for (int trans_i = 1; trans_i <= num_trans; trans_i++) begin
      // sw_symbol_backdoor_overwrite takes an array as the input
      bit [7:0] trans_i_array[] = {trans_i};
      sw_symbol_backdoor_overwrite("kTestIterationCount", trans_i_array);

      if (trans_i > 1) begin
        apply_reset();
        backdoor_override_otp();
      end

      // Override the C test kLcExitToken with random data.
      sw_symbol_backdoor_overwrite("kLcExitToken", lc_exit_token);

      // Wait for SW to finish power on set up.
      wait (cfg.sw_logger_vif.printed_log == "Start LC_CTRL transition test.");

      // Select LC jtag.
      cfg.tap_straps_vif.drive(SelectLCJtagTap);

      while(1) begin
        bit [TL_DW-1:0]  status_val;
        lc_ctrl_status_e dummy;
        cfg.clk_rst_vif.wait_clks($urandom_range(0, 10));
        jtag_riscv_agent_pkg::jtag_read_csr(ral.lc_ctrl.status.get_offset(),
                                            p_sequencer.jtag_sequencer_h,
                                            status_val);

        // Ensure that none of the other status bits are set.
        `DV_CHECK_EQ(status_val >> dummy.num(), 0,
                     $sformatf("Unexpected status error %0h", status_val))
        if (status_val[LcTransitionSuccessful]) break;
      end

      // LC state transition requires a chip reset.
      apply_reset();

      // Wait for SW test finishes with a pass/fail status.
      wait (cfg.sw_test_status_vif.sw_test_status inside {SwTestStatusPassed,
                                                          SwTestStatusFailed});
      `uvm_info(`gfn, $sformatf("Sequence %0d/%0d finished!", trans_i, num_trans), UVM_LOW)
    end
  endtask

endclass
