// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This contains some obvious exclusions the UNR tool didn't flag.

//==================================================
// This file contains the Excluded objects
// Generated By User: maturana
// Format Version: 2
// Date: Thu Sep 29 13:57:41 2022
// ExclMode: default
//==================================================
CHECKSUM: "2301929872 1660332954"
INSTANCE: tb.dut.u_clk_main_aes_trans.u_idle_cnt
ANNOTATION: "[UNR] Input tied to a constant, and unr doesn't detect it."
Toggle step_i "net step_i[3:0]"
CHECKSUM: "2301929872 1660332954"
INSTANCE: tb.dut.u_clk_main_hmac_trans.u_idle_cnt
ANNOTATION: "[UNR] Input tied to a constant, and unr doesn't detect it."
Toggle step_i "net step_i[3:0]"
CHECKSUM: "2301929872 1660332954"
INSTANCE: tb.dut.u_clk_main_kmac_trans.u_idle_cnt
ANNOTATION: "[UNR] Input tied to a constant, and unr doesn't detect it."
Toggle step_i "net step_i[3:0]"
CHECKSUM: "2301929872 1660332954"
INSTANCE: tb.dut.u_clk_main_otbn_trans.u_idle_cnt
ANNOTATION: "[UNR] Input tied to a constant, and unr doesn't detect it."
Toggle step_i "net step_i[3:0]"
CHECKSUM: "953655365 3155586170"
INSTANCE: tb.dut
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.aon_powerup "logic cg_en_o.aon_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.usb_powerup "logic cg_en_o.usb_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.main_powerup "logic cg_en_o.main_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.io_powerup "logic cg_en_o.io_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.io_div2_powerup "logic cg_en_o.io_div2_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.io_div4_powerup "logic cg_en_o.io_div4_powerup[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.aon_peri "logic cg_en_o.aon_peri[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.aon_timers "logic cg_en_o.aon_timers[3:0]"
ANNOTATION: "[UNR] This is driven by a constant, and unr doesn't detect it."
Toggle cg_en_o.aon_secure "logic cg_en_o.aon_secure[3:0]"
