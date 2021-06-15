// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//==================================================
// This file contains the Excluded objects
// Generated By User: udij
// Format Version: 2
// Date: Wed Jul  7 16:58:06 2021
// ExclMode: default
//==================================================
CHECKSUM: "3161267887 1427585211"
INSTANCE: tb.dut.u_sha3.u_keccak
Fsm keccak_st "1427585211"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Transition StPhase3->StPhase1 "4->2"
Fsm keccak_st "1427585211"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Transition StIdle->StPhase1 "0->2"
Fsm keccak_st "1427585211"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Transition StPhase1->StPhase2 "2->3"
Fsm keccak_st "1427585211"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Transition StPhase2->StPhase3 "3->4"
Fsm keccak_st "1427585211"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Transition StPhase3->StIdle "4->0"
CHECKSUM: "2694308369 2983568807"
INSTANCE: tb.dut
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Toggle entropy_i.edn_ack "logic entropy_i.edn_ack"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Toggle entropy_i.edn_bus "logic entropy_i.edn_bus[31:0]"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Toggle entropy_i.edn_fips "logic entropy_i.edn_fips"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Toggle entropy_o.edn_req "logic entropy_o.edn_req"
ANNOTATION: "[UNSUPPORTED] tied to '0 in unmasked KMAC configuration"
Toggle app_o[2].digest_share1 "logic app_o[2].digest_share1[255:0]"
ANNOTATION: "[UNSUPPORTED] tied to '0 in unmasked KMAC configuration"
Toggle app_o[1].digest_share1 "logic app_o[1].digest_share1[255:0]"
ANNOTATION: "[UNSUPPORTED] tied to '0 in unmasked KMAC configuration"
Toggle app_o[0].digest_share1 "logic app_o[0].digest_share1[255:0]"
CHECKSUM: "2224922822 2147291809"
INSTANCE: tb.dut.u_app_intf
ANNOTATION: "[UNSUPPORTED] nothing uses SHA3 application interface as of right now"
Branch 10 "4188171746" "(!rst_ni)" (4) "(!rst_ni) 0,0,1,-,1,-"
ANNOTATION: "[UNSUPPORTED] nothing uses SHA3 application interface as of right now"
Branch 10 "4188171746" "(!rst_ni)" (5) "(!rst_ni) 0,0,1,-,0,-"
CHECKSUM: "3161267887 2218749583"
INSTANCE: tb.dut.u_sha3.u_keccak
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Branch 2 "3493554538" "keccak_st" (9) "keccak_st StPhase2 ,-,-,-,-,-,0,-"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Branch 2 "3493554538" "keccak_st" (10) "keccak_st StPhase3 ,-,-,-,-,-,-,1"
ANNOTATION: "[UNSUPPORTED] unused in unmasked KMAC configuration"
Branch 2 "3493554538" "keccak_st" (2) "keccak_st StIdle ,0,0,1,-,-,-,-"
