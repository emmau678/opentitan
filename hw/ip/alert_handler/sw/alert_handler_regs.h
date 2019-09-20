// Generated register defines for ALERT_HANDLER

// Copyright information found in source file:
// Copyright lowRISC contributors.

// Licensing information found in source file:
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef _ALERT_HANDLER_REG_DEFS_
#define _ALERT_HANDLER_REG_DEFS_

// Interrupt State Register
#define ALERT_HANDLER_INTR_STATE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x0)
#define ALERT_HANDLER_INTR_STATE_CLASSA 0
#define ALERT_HANDLER_INTR_STATE_CLASSB 1
#define ALERT_HANDLER_INTR_STATE_CLASSC 2
#define ALERT_HANDLER_INTR_STATE_CLASSD 3

// Interrupt Enable Register
#define ALERT_HANDLER_INTR_ENABLE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x4)
#define ALERT_HANDLER_INTR_ENABLE_CLASSA 0
#define ALERT_HANDLER_INTR_ENABLE_CLASSB 1
#define ALERT_HANDLER_INTR_ENABLE_CLASSC 2
#define ALERT_HANDLER_INTR_ENABLE_CLASSD 3

// Interrupt Test Register
#define ALERT_HANDLER_INTR_TEST(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x8)
#define ALERT_HANDLER_INTR_TEST_CLASSA 0
#define ALERT_HANDLER_INTR_TEST_CLASSB 1
#define ALERT_HANDLER_INTR_TEST_CLASSC 2
#define ALERT_HANDLER_INTR_TEST_CLASSD 3

// Register write enable for all control registers.
#define ALERT_HANDLER_REGEN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xc)
#define ALERT_HANDLER_REGEN 0

// Ping timeout cycle count.
#define ALERT_HANDLER_PING_TIMEOUT_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x10)
#define ALERT_HANDLER_PING_TIMEOUT_CYC_MASK 0xffffff
#define ALERT_HANDLER_PING_TIMEOUT_CYC_OFFSET 0

// Enable register for alerts.
#define ALERT_HANDLER_ALERT_EN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x14)
#define ALERT_HANDLER_ALERT_EN_EN_A0 0
#define ALERT_HANDLER_ALERT_EN_EN_A1 1
#define ALERT_HANDLER_ALERT_EN_EN_A2 2
#define ALERT_HANDLER_ALERT_EN_EN_A3 3

// Class assignment of alerts.
#define ALERT_HANDLER_ALERT_CLASS(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x18)
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_MASK 0x3
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_OFFSET 0
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_CLASSA 0
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_CLASSB 1
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_CLASSC 2
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A0_CLASSD 3
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A1_MASK 0x3
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A1_OFFSET 2
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A2_MASK 0x3
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A2_OFFSET 4
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A3_MASK 0x3
#define ALERT_HANDLER_ALERT_CLASS_CLASS_A3_OFFSET 6

// Alert Cause Register
#define ALERT_HANDLER_ALERT_CAUSE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x1c)
#define ALERT_HANDLER_ALERT_CAUSE_A0 0
#define ALERT_HANDLER_ALERT_CAUSE_A1 1
#define ALERT_HANDLER_ALERT_CAUSE_A2 2
#define ALERT_HANDLER_ALERT_CAUSE_A3 3

// Enable register for the aggregated local alerts "alert
#define ALERT_HANDLER_LOC_ALERT_EN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x20)
#define ALERT_HANDLER_LOC_ALERT_EN_EN_LA0 0
#define ALERT_HANDLER_LOC_ALERT_EN_EN_LA1 1
#define ALERT_HANDLER_LOC_ALERT_EN_EN_LA2 2
#define ALERT_HANDLER_LOC_ALERT_EN_EN_LA3 3

// Class assignment of local alerts. "alert
#define ALERT_HANDLER_LOC_ALERT_CLASS(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x24)
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_MASK 0x3
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_OFFSET 0
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_CLASSA 0
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_CLASSB 1
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_CLASSC 2
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA0_CLASSD 3
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA1_MASK 0x3
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA1_OFFSET 2
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA2_MASK 0x3
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA2_OFFSET 4
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA3_MASK 0x3
#define ALERT_HANDLER_LOC_ALERT_CLASS_CLASS_LA3_OFFSET 6

// Alert Cause Register for Local Alerts
#define ALERT_HANDLER_LOC_ALERT_CAUSE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x28)
#define ALERT_HANDLER_LOC_ALERT_CAUSE_LA0 0
#define ALERT_HANDLER_LOC_ALERT_CAUSE_LA1 1
#define ALERT_HANDLER_LOC_ALERT_CAUSE_LA2 2
#define ALERT_HANDLER_LOC_ALERT_CAUSE_LA3 3

// Escalation control register for alert Class A. Can not be modified if !!REGEN is false.
#define ALERT_HANDLER_CLASSA_CTRL(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x2c)
#define ALERT_HANDLER_CLASSA_CTRL_EN 0
#define ALERT_HANDLER_CLASSA_CTRL_LOCK 1
#define ALERT_HANDLER_CLASSA_CTRL_EN_E0 2
#define ALERT_HANDLER_CLASSA_CTRL_EN_E1 3
#define ALERT_HANDLER_CLASSA_CTRL_EN_E2 4
#define ALERT_HANDLER_CLASSA_CTRL_EN_E3 5
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E0_MASK 0x3
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E0_OFFSET 6
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E1_MASK 0x3
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E1_OFFSET 8
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E2_MASK 0x3
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E2_OFFSET 10
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E3_MASK 0x3
#define ALERT_HANDLER_CLASSA_CTRL_MAP_E3_OFFSET 12

// Clear enable for escalation protocol of class A alerts.
#define ALERT_HANDLER_CLASSA_CLREN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x30)
#define ALERT_HANDLER_CLASSA_CLREN 0

// Clear for esclation protocol of class A.
#define ALERT_HANDLER_CLASSA_CLR(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x34)
#define ALERT_HANDLER_CLASSA_CLR 0

// Current accumulation value for alert Class A. Software can clear this register
#define ALERT_HANDLER_CLASSA_ACCUM_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x38)
#define ALERT_HANDLER_CLASSA_ACCUM_CNT_MASK 0xffff
#define ALERT_HANDLER_CLASSA_ACCUM_CNT_OFFSET 0

// Accumulation threshold value for alert Class A.
#define ALERT_HANDLER_CLASSA_ACCUM_THRESH(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x3c)
#define ALERT_HANDLER_CLASSA_ACCUM_THRESH_MASK 0xffff
#define ALERT_HANDLER_CLASSA_ACCUM_THRESH_OFFSET 0

// Interrupt timeout in cycles.
#define ALERT_HANDLER_CLASSA_TIMEOUT_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x40)

// Duration of escalation phase 0 for class A.
#define ALERT_HANDLER_CLASSA_PHASE0_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x44)

// Duration of escalation phase 1 for class A.
#define ALERT_HANDLER_CLASSA_PHASE1_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x48)

// Duration of escalation phase 2 for class A.
#define ALERT_HANDLER_CLASSA_PHASE2_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x4c)

// Duration of escalation phase 3 for class A.
#define ALERT_HANDLER_CLASSA_PHASE3_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x50)

// Escalation counter in cycles for class A.
#define ALERT_HANDLER_CLASSA_ESC_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x54)

// Current escalation state of Class A. See also !!CLASSA_ESC_CNT.
#define ALERT_HANDLER_CLASSA_STATE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x58)
#define ALERT_HANDLER_CLASSA_STATE_MASK 0x7
#define ALERT_HANDLER_CLASSA_STATE_OFFSET 0
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_IDLE 0b000
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_TIMEOUT 0b001
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_TERMINAL 0b011
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_PHASE0 0b100
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_PHASE1 0b101
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_PHASE2 0b110
#define ALERT_HANDLER_CLASSA_STATE_CLASSA_STATE_PHASE3 0b111

// Escalation control register for alert Class B. Can not be modified if !!REGEN is false.
#define ALERT_HANDLER_CLASSB_CTRL(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x5c)
#define ALERT_HANDLER_CLASSB_CTRL_EN 0
#define ALERT_HANDLER_CLASSB_CTRL_LOCK 1
#define ALERT_HANDLER_CLASSB_CTRL_EN_E0 2
#define ALERT_HANDLER_CLASSB_CTRL_EN_E1 3
#define ALERT_HANDLER_CLASSB_CTRL_EN_E2 4
#define ALERT_HANDLER_CLASSB_CTRL_EN_E3 5
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E0_MASK 0x3
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E0_OFFSET 6
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E1_MASK 0x3
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E1_OFFSET 8
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E2_MASK 0x3
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E2_OFFSET 10
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E3_MASK 0x3
#define ALERT_HANDLER_CLASSB_CTRL_MAP_E3_OFFSET 12

// Clear enable for escalation protocol of class B alerts.
#define ALERT_HANDLER_CLASSB_CLREN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x60)
#define ALERT_HANDLER_CLASSB_CLREN 0

// Clear for esclation protocol of class B.
#define ALERT_HANDLER_CLASSB_CLR(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x64)
#define ALERT_HANDLER_CLASSB_CLR 0

// Current accumulation value for alert Class B. Software can clear this register
#define ALERT_HANDLER_CLASSB_ACCUM_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x68)
#define ALERT_HANDLER_CLASSB_ACCUM_CNT_MASK 0xffff
#define ALERT_HANDLER_CLASSB_ACCUM_CNT_OFFSET 0

// Accumulation threshold value for alert Class B.
#define ALERT_HANDLER_CLASSB_ACCUM_THRESH(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x6c)
#define ALERT_HANDLER_CLASSB_ACCUM_THRESH_MASK 0xffff
#define ALERT_HANDLER_CLASSB_ACCUM_THRESH_OFFSET 0

// Interrupt timeout in cycles.
#define ALERT_HANDLER_CLASSB_TIMEOUT_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x70)

// Duration of escalation phase 0 for class B.
#define ALERT_HANDLER_CLASSB_PHASE0_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x74)

// Duration of escalation phase 1 for class B.
#define ALERT_HANDLER_CLASSB_PHASE1_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x78)

// Duration of escalation phase 2 for class B.
#define ALERT_HANDLER_CLASSB_PHASE2_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x7c)

// Duration of escalation phase 3 for class B.
#define ALERT_HANDLER_CLASSB_PHASE3_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x80)

// Escalation counter in cycles for class B.
#define ALERT_HANDLER_CLASSB_ESC_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x84)

// Current escalation state of Class B. See also !!CLASSB_ESC_CNT.
#define ALERT_HANDLER_CLASSB_STATE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x88)
#define ALERT_HANDLER_CLASSB_STATE_MASK 0x7
#define ALERT_HANDLER_CLASSB_STATE_OFFSET 0
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_IDLE 0b000
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_TIMEOUT 0b001
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_TERMINAL 0b011
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_PHASE0 0b100
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_PHASE1 0b101
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_PHASE2 0b110
#define ALERT_HANDLER_CLASSB_STATE_CLASSB_STATE_PHASE3 0b111

// Escalation control register for alert Class C. Can not be modified if !!REGEN is false.
#define ALERT_HANDLER_CLASSC_CTRL(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x8c)
#define ALERT_HANDLER_CLASSC_CTRL_EN 0
#define ALERT_HANDLER_CLASSC_CTRL_LOCK 1
#define ALERT_HANDLER_CLASSC_CTRL_EN_E0 2
#define ALERT_HANDLER_CLASSC_CTRL_EN_E1 3
#define ALERT_HANDLER_CLASSC_CTRL_EN_E2 4
#define ALERT_HANDLER_CLASSC_CTRL_EN_E3 5
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E0_MASK 0x3
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E0_OFFSET 6
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E1_MASK 0x3
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E1_OFFSET 8
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E2_MASK 0x3
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E2_OFFSET 10
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E3_MASK 0x3
#define ALERT_HANDLER_CLASSC_CTRL_MAP_E3_OFFSET 12

// Clear enable for escalation protocol of class C alerts.
#define ALERT_HANDLER_CLASSC_CLREN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x90)
#define ALERT_HANDLER_CLASSC_CLREN 0

// Clear for esclation protocol of class C.
#define ALERT_HANDLER_CLASSC_CLR(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x94)
#define ALERT_HANDLER_CLASSC_CLR 0

// Current accumulation value for alert Class C. Software can clear this register
#define ALERT_HANDLER_CLASSC_ACCUM_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x98)
#define ALERT_HANDLER_CLASSC_ACCUM_CNT_MASK 0xffff
#define ALERT_HANDLER_CLASSC_ACCUM_CNT_OFFSET 0

// Accumulation threshold value for alert Class C.
#define ALERT_HANDLER_CLASSC_ACCUM_THRESH(id) (ALERT_HANDLER##id##_BASE_ADDR + 0x9c)
#define ALERT_HANDLER_CLASSC_ACCUM_THRESH_MASK 0xffff
#define ALERT_HANDLER_CLASSC_ACCUM_THRESH_OFFSET 0

// Interrupt timeout in cycles.
#define ALERT_HANDLER_CLASSC_TIMEOUT_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xa0)

// Duration of escalation phase 0 for class C.
#define ALERT_HANDLER_CLASSC_PHASE0_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xa4)

// Duration of escalation phase 1 for class C.
#define ALERT_HANDLER_CLASSC_PHASE1_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xa8)

// Duration of escalation phase 2 for class C.
#define ALERT_HANDLER_CLASSC_PHASE2_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xac)

// Duration of escalation phase 3 for class C.
#define ALERT_HANDLER_CLASSC_PHASE3_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xb0)

// Escalation counter in cycles for class C.
#define ALERT_HANDLER_CLASSC_ESC_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xb4)

// Current escalation state of Class C. See also !!CLASSC_ESC_CNT.
#define ALERT_HANDLER_CLASSC_STATE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xb8)
#define ALERT_HANDLER_CLASSC_STATE_MASK 0x7
#define ALERT_HANDLER_CLASSC_STATE_OFFSET 0
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_IDLE 0b000
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_TIMEOUT 0b001
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_TERMINAL 0b011
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_PHASE0 0b100
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_PHASE1 0b101
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_PHASE2 0b110
#define ALERT_HANDLER_CLASSC_STATE_CLASSC_STATE_PHASE3 0b111

// Escalation control register for alert Class D. Can not be modified if !!REGEN is false.
#define ALERT_HANDLER_CLASSD_CTRL(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xbc)
#define ALERT_HANDLER_CLASSD_CTRL_EN 0
#define ALERT_HANDLER_CLASSD_CTRL_LOCK 1
#define ALERT_HANDLER_CLASSD_CTRL_EN_E0 2
#define ALERT_HANDLER_CLASSD_CTRL_EN_E1 3
#define ALERT_HANDLER_CLASSD_CTRL_EN_E2 4
#define ALERT_HANDLER_CLASSD_CTRL_EN_E3 5
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E0_MASK 0x3
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E0_OFFSET 6
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E1_MASK 0x3
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E1_OFFSET 8
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E2_MASK 0x3
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E2_OFFSET 10
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E3_MASK 0x3
#define ALERT_HANDLER_CLASSD_CTRL_MAP_E3_OFFSET 12

// Clear enable for escalation protocol of class D alerts.
#define ALERT_HANDLER_CLASSD_CLREN(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xc0)
#define ALERT_HANDLER_CLASSD_CLREN 0

// Clear for esclation protocol of class D.
#define ALERT_HANDLER_CLASSD_CLR(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xc4)
#define ALERT_HANDLER_CLASSD_CLR 0

// Current accumulation value for alert Class D. Software can clear this register
#define ALERT_HANDLER_CLASSD_ACCUM_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xc8)
#define ALERT_HANDLER_CLASSD_ACCUM_CNT_MASK 0xffff
#define ALERT_HANDLER_CLASSD_ACCUM_CNT_OFFSET 0

// Accumulation threshold value for alert Class D.
#define ALERT_HANDLER_CLASSD_ACCUM_THRESH(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xcc)
#define ALERT_HANDLER_CLASSD_ACCUM_THRESH_MASK 0xffff
#define ALERT_HANDLER_CLASSD_ACCUM_THRESH_OFFSET 0

// Interrupt timeout in cycles.
#define ALERT_HANDLER_CLASSD_TIMEOUT_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xd0)

// Duration of escalation phase 0 for class D.
#define ALERT_HANDLER_CLASSD_PHASE0_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xd4)

// Duration of escalation phase 1 for class D.
#define ALERT_HANDLER_CLASSD_PHASE1_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xd8)

// Duration of escalation phase 2 for class D.
#define ALERT_HANDLER_CLASSD_PHASE2_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xdc)

// Duration of escalation phase 3 for class D.
#define ALERT_HANDLER_CLASSD_PHASE3_CYC(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xe0)

// Escalation counter in cycles for class D.
#define ALERT_HANDLER_CLASSD_ESC_CNT(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xe4)

// Current escalation state of Class D. See also !!CLASSD_ESC_CNT.
#define ALERT_HANDLER_CLASSD_STATE(id) (ALERT_HANDLER##id##_BASE_ADDR + 0xe8)
#define ALERT_HANDLER_CLASSD_STATE_MASK 0x7
#define ALERT_HANDLER_CLASSD_STATE_OFFSET 0
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_IDLE 0b000
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_TIMEOUT 0b001
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_TERMINAL 0b011
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_PHASE0 0b100
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_PHASE1 0b101
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_PHASE2 0b110
#define ALERT_HANDLER_CLASSD_STATE_CLASSD_STATE_PHASE3 0b111

#endif  // _ALERT_HANDLER_REG_DEFS_
// End generated register defines for ALERT_HANDLER
