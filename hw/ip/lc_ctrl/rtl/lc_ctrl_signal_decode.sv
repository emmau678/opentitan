// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Life cycle signal decoder and sender module.

module lc_ctrl_signal_decode
  import lc_ctrl_pkg::*;
(
  input                  clk_i,
  input                  rst_ni,
  // Life cycle state vector.
  input  logic           lc_state_valid_i,
  input  lc_state_e      lc_state_i,
  input  lc_id_state_e   lc_id_state_i,
  input  fsm_state_e     fsm_state_i,
  // Escalation enable from escalation receiver.
  input                  esc_wipe_secrets_i,
  // Life cycle broadcast outputs.
  output lc_tx_t         lc_dft_en_o,
  output lc_tx_t         lc_nvm_debug_en_o,
  output lc_tx_t         lc_hw_debug_en_o,
  output lc_tx_t         lc_cpu_en_o,
  output lc_tx_t         lc_provision_wr_en_o,
  output lc_tx_t         lc_provision_rd_en_o,
  output lc_tx_t         lc_keymgr_en_o,
  output lc_tx_t         lc_escalate_en_o
);

  //////////////////////////
  // Signal Decoder Logic //
  //////////////////////////

  lc_tx_t lc_dft_en_d, lc_dft_en_q;
  lc_tx_t lc_nvm_debug_en_d, lc_nvm_debug_en_q;
  lc_tx_t lc_hw_debug_en_d, lc_hw_debug_en_q;
  lc_tx_t lc_cpu_en_d, lc_cpu_en_q;
  lc_tx_t lc_provision_wr_en_d, lc_provision_wr_en_q;
  lc_tx_t lc_provision_rd_en_d, lc_provision_rd_en_q;
  lc_tx_t lc_keymgr_en_d, lc_keymgr_en_q;
  lc_tx_t lc_escalate_en_d, lc_escalate_en_q;

  always_comb begin : p_lc_signal_decode
    // Life cycle control signal defaults
    lc_dft_en_d          = Off;
    lc_nvm_debug_en_d    = Off;
    lc_hw_debug_en_d     = Off;
    lc_cpu_en_d          = Off;
    lc_provision_wr_en_d = Off;
    lc_provision_rd_en_d = Off;
    lc_keymgr_en_d       = Off;
    lc_escalate_en_d     = Off;

    // The escalation life cycle signal is always decoded, no matter
    // which state we currently are in.
    if (esc_wipe_secrets_i) begin
      lc_escalate_en_d = On;
    end

    // Only broadcast during the following main FSM states
    if (lc_state_valid_i && fsm_state_i inside {IdleSt,
                                                ClkMuxSt,
                                                CntIncrSt,
                                                CntProgSt,
                                                TransCheckSt,
                                                FlashRmaSt,
                                                TokenHashSt,
                                                TokenCheck0St,
                                                TokenCheck1St,
                                                TransProgSt}) begin
      unique case (lc_state_i)
        ///////////////////////////////////////////////////////////////////
        // Enable DFT and debug functionality, including the CPU in the
        // test unlocked states.
        LcStTestUnlocked0,
        LcStTestUnlocked1,
        LcStTestUnlocked2,
        LcStTestUnlocked3: begin
          lc_dft_en_d       = On;
          lc_nvm_debug_en_d = On;
          lc_hw_debug_en_d  = On;
          lc_cpu_en_d       = On;
        end
        ///////////////////////////////////////////////////////////////////
        // Enable production functions
        LcStProd, LcStProdEnd: begin
          lc_cpu_en_d          = On;
          lc_keymgr_en_d       = On;
          lc_provision_rd_en_d = On;
          // Only allow provisioning if the defice has not yet been personalized.
          if (lc_id_state_i == LcIdBlank) begin
            lc_provision_wr_en_d = On;
          end
        end
        ///////////////////////////////////////////////////////////////////
        // Same functions as PROD, but with additional debug functionality.
        LcStDev: begin
          lc_hw_debug_en_d     = On;
          lc_cpu_en_d          = On;
          lc_keymgr_en_d       = On;
          lc_provision_rd_en_d = On;
          // Only allow provisioning if the defice has not yet been personalized.
          if (lc_id_state_i == LcIdBlank) begin
            lc_provision_wr_en_d = On;
          end
        end
        ///////////////////////////////////////////////////////////////////
        // Enable all test and production functions.
        LcStRma: begin
          lc_dft_en_d          = On;
          lc_nvm_debug_en_d    = On;
          lc_hw_debug_en_d     = On;
          lc_cpu_en_d          = On;
          lc_keymgr_en_d       = On;
          lc_provision_rd_en_d = On;
          // Only allow provisioning if the defice has not yet been personalized.
          if (lc_id_state_i == LcIdBlank) begin
            lc_provision_wr_en_d = On;
          end
        end
        ///////////////////////////////////////////////////////////////////
        // Invalid or scrapped life cycle state, do not assert
        // any signals other than escalate_en and clk_byp_en.
        default: ;
      endcase // lc_state_i
    end
  end

  /////////////////////////////////
  // Control signal output flops //
  /////////////////////////////////

  assign lc_dft_en_o          = lc_dft_en_q;
  assign lc_nvm_debug_en_o    = lc_nvm_debug_en_q;
  assign lc_hw_debug_en_o     = lc_hw_debug_en_q;
  assign lc_cpu_en_o          = lc_cpu_en_q;
  assign lc_provision_wr_en_o = lc_provision_wr_en_q;
  assign lc_provision_rd_en_o = lc_provision_rd_en_q;
  assign lc_keymgr_en_o       = lc_keymgr_en_q;
  assign lc_escalate_en_o     = lc_escalate_en_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      lc_dft_en_q          <= Off;
      lc_nvm_debug_en_q    <= Off;
      lc_hw_debug_en_q     <= Off;
      lc_cpu_en_q          <= Off;
      lc_provision_wr_en_q <= Off;
      lc_provision_rd_en_q <= Off;
      lc_keymgr_en_q       <= Off;
      lc_escalate_en_q     <= Off;
    end else begin
      lc_dft_en_q          <= lc_dft_en_d;
      lc_nvm_debug_en_q    <= lc_nvm_debug_en_d;
      lc_hw_debug_en_q     <= lc_hw_debug_en_d;
      lc_cpu_en_q          <= lc_cpu_en_d;
      lc_provision_wr_en_q <= lc_provision_wr_en_d;
      lc_provision_rd_en_q <= lc_provision_rd_en_d;
      lc_keymgr_en_q       <= lc_keymgr_en_d;
      lc_escalate_en_q     <= lc_escalate_en_d;
    end
  end

  ////////////////
  // Assertions //
  ////////////////

  `ASSERT(SignalsAreOffWhenNotEnabled_A,
      !lc_state_valid_i
      |=>
      lc_dft_en_o == Off &&
      lc_nvm_debug_en_o == Off &&
      lc_hw_debug_en_o == Off &&
      lc_cpu_en_o == Off &&
      lc_provision_wr_en_o == Off &&
      lc_provision_rd_en_o == Off &&
      lc_keymgr_en_o == Off &&
      lc_dft_en_o == Off)

  `ASSERT(EscalationAlwaysDecoded_A,
      (lc_escalate_en_o == On) == $past(esc_wipe_secrets_i))

endmodule : lc_ctrl_signal_decode
