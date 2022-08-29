/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// LOAD instructions
`DEFINE_INSTR(LB,     I_FORMAT, LOAD, RV32I)
`DEFINE_INSTR(LH,     I_FORMAT, LOAD, RV32I)
`DEFINE_INSTR(LW,     I_FORMAT, LOAD, RV32I)
`DEFINE_INSTR(LBU,    I_FORMAT, LOAD, RV32I)
`DEFINE_INSTR(LHU,    I_FORMAT, LOAD, RV32I)
// STORE instructions
`DEFINE_INSTR(SB,     S_FORMAT, STORE, RV32I)
`DEFINE_INSTR(SH,     S_FORMAT, STORE, RV32I)
`DEFINE_INSTR(SW,     S_FORMAT, STORE, RV32I)
// SHIFT intructions
`DEFINE_INSTR(SLL,    R_FORMAT, SHIFT, RV32I)
`DEFINE_INSTR(SLLI,   I_FORMAT, SHIFT, RV32I)
`DEFINE_INSTR(SRL,    R_FORMAT, SHIFT, RV32I)
`DEFINE_INSTR(SRLI,   I_FORMAT, SHIFT, RV32I)
`DEFINE_INSTR(SRA,    R_FORMAT, SHIFT, RV32I)
`DEFINE_INSTR(SRAI,   I_FORMAT, SHIFT, RV32I)
// ARITHMETIC intructions
`DEFINE_INSTR(ADD,    R_FORMAT, ARITHMETIC, RV32I)
`DEFINE_INSTR(ADDI,   I_FORMAT, ARITHMETIC, RV32I)
`DEFINE_INSTR(NOP,    I_FORMAT, ARITHMETIC, RV32I)
`DEFINE_INSTR(SUB,    R_FORMAT, ARITHMETIC, RV32I)
`DEFINE_INSTR(LUI,    U_FORMAT, ARITHMETIC, RV32I, UIMM)
`DEFINE_INSTR(AUIPC,  U_FORMAT, ARITHMETIC, RV32I, UIMM)
// LOGICAL instructions
`DEFINE_INSTR(XOR,    R_FORMAT, LOGICAL, RV32I)
`DEFINE_INSTR(XORI,   I_FORMAT, LOGICAL, RV32I)
`DEFINE_INSTR(OR,     R_FORMAT, LOGICAL, RV32I)
`DEFINE_INSTR(ORI,    I_FORMAT, LOGICAL, RV32I)
`DEFINE_INSTR(AND,    R_FORMAT, LOGICAL, RV32I)
`DEFINE_INSTR(ANDI,   I_FORMAT, LOGICAL, RV32I)
// COMPARE instructions
`DEFINE_INSTR(SLT,    R_FORMAT, COMPARE, RV32I)
`DEFINE_INSTR(SLTI,   I_FORMAT, COMPARE, RV32I)
`DEFINE_INSTR(SLTU,   R_FORMAT, COMPARE, RV32I)
`DEFINE_INSTR(SLTIU,  I_FORMAT, COMPARE, RV32I)
// BRANCH instructions
`DEFINE_INSTR(BEQ,    B_FORMAT, BRANCH, RV32I)
`DEFINE_INSTR(BNE,    B_FORMAT, BRANCH, RV32I)
`DEFINE_INSTR(BLT,    B_FORMAT, BRANCH, RV32I)
`DEFINE_INSTR(BGE,    B_FORMAT, BRANCH, RV32I)
`DEFINE_INSTR(BLTU,   B_FORMAT, BRANCH, RV32I)
`DEFINE_INSTR(BGEU,   B_FORMAT, BRANCH, RV32I)
// JUMP instructions
`DEFINE_INSTR(JAL,    J_FORMAT, JUMP, RV32I)
`DEFINE_INSTR(JALR,   I_FORMAT, JUMP, RV32I)
// SYNCH instructions
`DEFINE_INSTR(FENCE,  I_FORMAT, SYNCH, RV32I)
`DEFINE_INSTR(FENCE_I, I_FORMAT, SYNCH, RV32I)
`DEFINE_INSTR(SFENCE_VMA, R_FORMAT, SYNCH, RV32I)
// SYSTEM instructions
`DEFINE_INSTR(ECALL,   I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(EBREAK,  I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(URET,    I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(SRET,    I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(MRET,    I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(DRET,    I_FORMAT, SYSTEM, RV32I)
`DEFINE_INSTR(WFI,     I_FORMAT, INTERRUPT, RV32I)
// CSR instructions
`DEFINE_CSR_INSTR(CSRRW,  R_FORMAT, CSR, RV32I, UIMM)
`DEFINE_CSR_INSTR(CSRRS,  R_FORMAT, CSR, RV32I, UIMM)
`DEFINE_CSR_INSTR(CSRRC,  R_FORMAT, CSR, RV32I, UIMM)
`DEFINE_CSR_INSTR(CSRRWI, I_FORMAT, CSR, RV32I, UIMM)
`DEFINE_CSR_INSTR(CSRRSI, I_FORMAT, CSR, RV32I, UIMM)
`DEFINE_CSR_INSTR(CSRRCI, I_FORMAT, CSR, RV32I, UIMM)
