`DEFINE_INSTR(LWU,     I_FORMAT, LOAD, RV64I)
`DEFINE_INSTR(LD,      I_FORMAT, LOAD, RV64I)
`DEFINE_INSTR(SD,      S_FORMAT, STORE, RV64I)
// SHIFT intructions
`DEFINE_INSTR(SLLW,    R_FORMAT, SHIFT, RV64I)
`DEFINE_INSTR(SLLIW,   I_FORMAT, SHIFT, RV64I)
`DEFINE_INSTR(SRLW,    R_FORMAT, SHIFT, RV64I)
`DEFINE_INSTR(SRLIW,   I_FORMAT, SHIFT, RV64I)
`DEFINE_INSTR(SRAW,    R_FORMAT, SHIFT, RV64I)
`DEFINE_INSTR(SRAIW,   I_FORMAT, SHIFT, RV64I)
// ARITHMETIC intructions
`DEFINE_INSTR(ADDW,    R_FORMAT, ARITHMETIC, RV64I)
`DEFINE_INSTR(ADDIW,   I_FORMAT, ARITHMETIC, RV64I)
`DEFINE_INSTR(SUBW,    R_FORMAT, ARITHMETIC, RV64I)
