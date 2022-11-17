// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
//==================================================
// This file contains the Excluded objects
// Generated By User: maturana
// Format Version: 2
// Date: Wed Nov 16 20:32:58 2022
// ExclMode: default
//==================================================
CHECKSUM: "1154881809 722956608"
INSTANCE: tb.dut
ANNOTATION: "VC_COV_UNR"
Condition 4 "1172916134" "(sync_child_rst && ((!sync_parent_rst))) 1 -1" (2 "10")
ANNOTATION: "VC_COV_UNR"
Condition 5 "1866172979" "(sync_parent_rst && ((!sync_child_rst))) 1 -1" (2 "10")
CHECKSUM: "1154881809 1429583852"
INSTANCE: tb.dut
ANNOTATION: "VC_COV_UNR"
Branch 4 "1978977957" "state_q" (16) "state_q WaitForChildRelease ,-,-,-,-,-,-,-,-,-,-,1,0,1,-"
CHECKSUM: "1154881809 3315250342"
INSTANCE: tb.dut
Fsm state_q "975684374"
ANNOTATION: "VC_COV_UNR"
Transition WaitForChildRelease->Error "58->22"
