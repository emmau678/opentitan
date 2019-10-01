// Generated register defines for FLASH_CTRL

// Copyright information found in source file:
// Copyright lowRISC contributors.

// Licensing information found in source file:
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef _FLASH_CTRL_REG_DEFS_
#define _FLASH_CTRL_REG_DEFS_

// Interrupt State Register
#define FLASH_CTRL_INTR_STATE(id) (FLASH_CTRL##id##_BASE_ADDR + 0x0)
#define FLASH_CTRL_INTR_STATE_PROG_EMPTY 0
#define FLASH_CTRL_INTR_STATE_PROG_LVL 1
#define FLASH_CTRL_INTR_STATE_RD_FULL 2
#define FLASH_CTRL_INTR_STATE_RD_LVL 3
#define FLASH_CTRL_INTR_STATE_OP_DONE 4
#define FLASH_CTRL_INTR_STATE_OP_ERROR 5

// Interrupt Enable Register
#define FLASH_CTRL_INTR_ENABLE(id) (FLASH_CTRL##id##_BASE_ADDR + 0x4)
#define FLASH_CTRL_INTR_ENABLE_PROG_EMPTY 0
#define FLASH_CTRL_INTR_ENABLE_PROG_LVL 1
#define FLASH_CTRL_INTR_ENABLE_RD_FULL 2
#define FLASH_CTRL_INTR_ENABLE_RD_LVL 3
#define FLASH_CTRL_INTR_ENABLE_OP_DONE 4
#define FLASH_CTRL_INTR_ENABLE_OP_ERROR 5

// Interrupt Test Register
#define FLASH_CTRL_INTR_TEST(id) (FLASH_CTRL##id##_BASE_ADDR + 0x8)
#define FLASH_CTRL_INTR_TEST_PROG_EMPTY 0
#define FLASH_CTRL_INTR_TEST_PROG_LVL 1
#define FLASH_CTRL_INTR_TEST_RD_FULL 2
#define FLASH_CTRL_INTR_TEST_RD_LVL 3
#define FLASH_CTRL_INTR_TEST_OP_DONE 4
#define FLASH_CTRL_INTR_TEST_OP_ERROR 5

// Control register
#define FLASH_CTRL_CONTROL(id) (FLASH_CTRL##id##_BASE_ADDR + 0xc)
#define FLASH_CTRL_CONTROL_START 0
#define FLASH_CTRL_CONTROL_OP_MASK 0x3
#define FLASH_CTRL_CONTROL_OP_OFFSET 4
#define FLASH_CTRL_CONTROL_OP_READ 0
#define FLASH_CTRL_CONTROL_OP_PROG 1
#define FLASH_CTRL_CONTROL_OP_ERASE 2
#define FLASH_CTRL_CONTROL_ERASE_SEL 6
#define FLASH_CTRL_CONTROL_FIFO_RST 7
#define FLASH_CTRL_CONTROL_NUM_MASK 0xfff
#define FLASH_CTRL_CONTROL_NUM_OFFSET 16

// Address for flash operation
#define FLASH_CTRL_ADDR(id) (FLASH_CTRL##id##_BASE_ADDR + 0x10)

// Memory region registers configuration enable.
#define FLASH_CTRL_REGION_CFG_REGWEN(id) (FLASH_CTRL##id##_BASE_ADDR + 0x14)
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION0 0
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION1 1
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION2 2
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION3 3
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION4 4
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION5 5
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION6 6
#define FLASH_CTRL_REGION_CFG_REGWEN_REGION7 7

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG0(id) (FLASH_CTRL##id##_BASE_ADDR + 0x18)
#define FLASH_CTRL_MP_REGION_CFG0_EN0 0
#define FLASH_CTRL_MP_REGION_CFG0_RD_EN0 1
#define FLASH_CTRL_MP_REGION_CFG0_PROG_EN0 2
#define FLASH_CTRL_MP_REGION_CFG0_ERASE_EN0 3
#define FLASH_CTRL_MP_REGION_CFG0_BASE0_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG0_BASE0_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG0_SIZE0_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG0_SIZE0_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG1(id) (FLASH_CTRL##id##_BASE_ADDR + 0x1c)
#define FLASH_CTRL_MP_REGION_CFG1_EN1 0
#define FLASH_CTRL_MP_REGION_CFG1_RD_EN1 1
#define FLASH_CTRL_MP_REGION_CFG1_PROG_EN1 2
#define FLASH_CTRL_MP_REGION_CFG1_ERASE_EN1 3
#define FLASH_CTRL_MP_REGION_CFG1_BASE1_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG1_BASE1_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG1_SIZE1_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG1_SIZE1_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG2(id) (FLASH_CTRL##id##_BASE_ADDR + 0x20)
#define FLASH_CTRL_MP_REGION_CFG2_EN2 0
#define FLASH_CTRL_MP_REGION_CFG2_RD_EN2 1
#define FLASH_CTRL_MP_REGION_CFG2_PROG_EN2 2
#define FLASH_CTRL_MP_REGION_CFG2_ERASE_EN2 3
#define FLASH_CTRL_MP_REGION_CFG2_BASE2_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG2_BASE2_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG2_SIZE2_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG2_SIZE2_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG3(id) (FLASH_CTRL##id##_BASE_ADDR + 0x24)
#define FLASH_CTRL_MP_REGION_CFG3_EN3 0
#define FLASH_CTRL_MP_REGION_CFG3_RD_EN3 1
#define FLASH_CTRL_MP_REGION_CFG3_PROG_EN3 2
#define FLASH_CTRL_MP_REGION_CFG3_ERASE_EN3 3
#define FLASH_CTRL_MP_REGION_CFG3_BASE3_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG3_BASE3_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG3_SIZE3_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG3_SIZE3_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG4(id) (FLASH_CTRL##id##_BASE_ADDR + 0x28)
#define FLASH_CTRL_MP_REGION_CFG4_EN4 0
#define FLASH_CTRL_MP_REGION_CFG4_RD_EN4 1
#define FLASH_CTRL_MP_REGION_CFG4_PROG_EN4 2
#define FLASH_CTRL_MP_REGION_CFG4_ERASE_EN4 3
#define FLASH_CTRL_MP_REGION_CFG4_BASE4_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG4_BASE4_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG4_SIZE4_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG4_SIZE4_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG5(id) (FLASH_CTRL##id##_BASE_ADDR + 0x2c)
#define FLASH_CTRL_MP_REGION_CFG5_EN5 0
#define FLASH_CTRL_MP_REGION_CFG5_RD_EN5 1
#define FLASH_CTRL_MP_REGION_CFG5_PROG_EN5 2
#define FLASH_CTRL_MP_REGION_CFG5_ERASE_EN5 3
#define FLASH_CTRL_MP_REGION_CFG5_BASE5_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG5_BASE5_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG5_SIZE5_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG5_SIZE5_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG6(id) (FLASH_CTRL##id##_BASE_ADDR + 0x30)
#define FLASH_CTRL_MP_REGION_CFG6_EN6 0
#define FLASH_CTRL_MP_REGION_CFG6_RD_EN6 1
#define FLASH_CTRL_MP_REGION_CFG6_PROG_EN6 2
#define FLASH_CTRL_MP_REGION_CFG6_ERASE_EN6 3
#define FLASH_CTRL_MP_REGION_CFG6_BASE6_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG6_BASE6_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG6_SIZE6_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG6_SIZE6_OFFSET 16

// Memory protection configuration
#define FLASH_CTRL_MP_REGION_CFG7(id) (FLASH_CTRL##id##_BASE_ADDR + 0x34)
#define FLASH_CTRL_MP_REGION_CFG7_EN7 0
#define FLASH_CTRL_MP_REGION_CFG7_RD_EN7 1
#define FLASH_CTRL_MP_REGION_CFG7_PROG_EN7 2
#define FLASH_CTRL_MP_REGION_CFG7_ERASE_EN7 3
#define FLASH_CTRL_MP_REGION_CFG7_BASE7_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG7_BASE7_OFFSET 4
#define FLASH_CTRL_MP_REGION_CFG7_SIZE7_MASK 0x1ff
#define FLASH_CTRL_MP_REGION_CFG7_SIZE7_OFFSET 16

// Default region permissions
#define FLASH_CTRL_DEFAULT_REGION(id) (FLASH_CTRL##id##_BASE_ADDR + 0x38)
#define FLASH_CTRL_DEFAULT_REGION_RD_EN 0
#define FLASH_CTRL_DEFAULT_REGION_PROG_EN 1
#define FLASH_CTRL_DEFAULT_REGION_ERASE_EN 2

// Bank configuration registers configuration enable.
#define FLASH_CTRL_BANK_CFG_REGWEN(id) (FLASH_CTRL##id##_BASE_ADDR + 0x3c)
#define FLASH_CTRL_BANK_CFG_REGWEN_BANK 0

// Memory protect bank configuration
#define FLASH_CTRL_MP_BANK_CFG(id) (FLASH_CTRL##id##_BASE_ADDR + 0x40)
#define FLASH_CTRL_MP_BANK_CFG_ERASE_EN0 0
#define FLASH_CTRL_MP_BANK_CFG_ERASE_EN1 1

// Flash Operation Status
#define FLASH_CTRL_OP_STATUS(id) (FLASH_CTRL##id##_BASE_ADDR + 0x44)
#define FLASH_CTRL_OP_STATUS_DONE 0
#define FLASH_CTRL_OP_STATUS_ERR 1

// Flash Controller Status
#define FLASH_CTRL_STATUS(id) (FLASH_CTRL##id##_BASE_ADDR + 0x48)
#define FLASH_CTRL_STATUS_RD_FULL 0
#define FLASH_CTRL_STATUS_RD_EMPTY 1
#define FLASH_CTRL_STATUS_PROG_FULL 2
#define FLASH_CTRL_STATUS_PROG_EMPTY 3
#define FLASH_CTRL_STATUS_INIT_WIP 4
#define FLASH_CTRL_STATUS_ERROR_PAGE_MASK 0x1ff
#define FLASH_CTRL_STATUS_ERROR_PAGE_OFFSET 8
#define FLASH_CTRL_STATUS_ERROR_BANK 17

// Flash Controller Scratch
#define FLASH_CTRL_SCRATCH(id) (FLASH_CTRL##id##_BASE_ADDR + 0x4c)

// Programmable depth where fifos should generate interrupts
#define FLASH_CTRL_FIFO_LVL(id) (FLASH_CTRL##id##_BASE_ADDR + 0x50)
#define FLASH_CTRL_FIFO_LVL_PROG_MASK 0x1f
#define FLASH_CTRL_FIFO_LVL_PROG_OFFSET 0
#define FLASH_CTRL_FIFO_LVL_RD_MASK 0x1f
#define FLASH_CTRL_FIFO_LVL_RD_OFFSET 8

// Memory area: Flash program fifo.
#define FLASH_CTRL_PROG_FIFO(id) (FLASH_CTRL##id##_BASE_ADDR + 0x54)
#define FLASH_CTRL_PROG_FIFO_SIZE_WORDS 1
#define FLASH_CTRL_PROG_FIFO_SIZE_BYTES 4
// Memory area: Flash read fifo.
#define FLASH_CTRL_RD_FIFO(id) (FLASH_CTRL##id##_BASE_ADDR + 0x58)
#define FLASH_CTRL_RD_FIFO_SIZE_WORDS 1
#define FLASH_CTRL_RD_FIFO_SIZE_BYTES 4
#endif  // _FLASH_CTRL_REG_DEFS_
// End generated register defines for FLASH_CTRL
