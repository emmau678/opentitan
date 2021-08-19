# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import random
from typing import Optional, Tuple

from shared.insn_yaml import InsnsFile
from shared.operand import RegOperandType

from ..config import Config
from ..program import ProgInsn, Program
from ..model import Model
from ..snippet import ProgSnippet
from ..snippet_gen import GenCont, GenRet, SnippetGen


class CallStackRW(SnippetGen):
    '''A snippet generator that tries to exercise the call stack

    We already have code that can exercise the call stack (e.g.
    StraightLineInsn), but there are certain things that it will never do (pop
    & push when the stack is full, for example) and other multiple uses of x1
    aren't particularly frequent. Generate more here!

    '''

    def __init__(self, cfg: Config, insns_file: InsnsFile) -> None:
        super().__init__()

        # Grab instructions like "add" or "sub", which take two GPRs as inputs
        # and write one GPR as an output.
        self.insns = []
        self.indices = []
        self.weights = []

        for insn in insns_file.insns:
            gpr_dsts = []
            gpr_srcs = []

            for idx, op in enumerate(insn.operands):
                if not isinstance(op.op_type, RegOperandType):
                    continue
                is_gpr = op.op_type.reg_type == 'gpr'
                is_dst = op.op_type.is_dest()

                if is_gpr:
                    if is_dst:
                        gpr_dsts.append(idx)
                    else:
                        gpr_srcs.append(idx)

            if len(gpr_dsts) == 1 and len(gpr_srcs) == 2 and insn.lsu is None:
                weight = cfg.insn_weights.get(insn.mnemonic)
                if weight > 0:
                    self.insns.append(insn)
                    self.indices.append((gpr_dsts[0], gpr_srcs[0], gpr_srcs[1]))
                    self.weights.append(weight)

        if not self.insns:
            # All the weights for the instructions we can use are zero
            self.disabled = True

    def _pick_insn(self, model: Model, pat_idx: int) -> Optional[ProgInsn]:
        '''Return a filled-in instruction for the given pattern.

        Known patterns are:

            (0)  add   x1, ??, ??
            (1)  add   x1, x1, ??
            (2)  add   x1, ??, x1
            (3)  add   x1, x1, x1
            (4)  add   ??, x1, x1
            (5)  add   ??, x1, ??  (**)
            (6)  add   ??, ??, x1  (**)

        Instructions matching the (**) patterns can also be generated by the
        StraightLineInsn generator, so aren't used by CallStackRW directly.
        These are only used by the BadCallStackRW generator below.

        '''

        # Pick an instruction
        insn_idx = random.choices(range(len(self.weights)), weights=self.weights)[0]

        grd_idx, grs1_idx, grs2_idx = self.indices[insn_idx]
        insn = self.insns[insn_idx]
        assert 0 <= pat_idx <= 6

        x1_grd = pat_idx <= 3
        x1_grs1 = pat_idx not in [0, 2, 6]
        x1_grs2 = pat_idx not in [0, 1, 5]

        op_vals = []
        for idx, operand in enumerate(insn.operands):
            use_x1 = ((x1_grd and idx == grd_idx) or
                      (x1_grs1 and idx == grs1_idx) or
                      (x1_grs2 and idx == grs2_idx))
            if use_x1:
                op_vals.append(1)
            else:
                # Make sure we don't use x1 when we're not expecting to
                if not isinstance(operand.op_type, RegOperandType):
                    weights = None
                else:
                    weights = {1: 0.0}

                enc_op_val = model.pick_operand_value(operand.op_type, weights)
                if enc_op_val is None:
                    return None
                op_vals.append(enc_op_val)

        return ProgInsn(insn, op_vals, None)

    def gen(self,
            cont: GenCont,
            model: Model,
            program: Program) -> Optional[GenRet]:

        # We can't read or write x1 when it's marked const.
        if model.is_const('gpr', 1):
            return None

        # Make sure we don't get paint ourselves into a corner
        if program.get_insn_space_at(model.pc) <= 1:
            return None

        # Pick a pattern (see _pick_insn). We can generate any of 1-4 as long
        # as the call stack is nonempty (which we've already guaranteed with
        # pick_weight). We can generate 0 if the stack is not full.
        pat_idxs = []
        if not model.call_stack.empty():
            pat_idxs += [1, 2, 3, 4]
        if not model.call_stack.full():
            pat_idxs += [0]

        if not pat_idxs:
            # This is possible (call stack both empty and full) because we
            # might not have full knowledge of the state of the call stack.
            return None
        pat_idx = random.choice(pat_idxs)

        prog_insn = self._pick_insn(model, pat_idx)
        if prog_insn is None:
            return None

        snippet = ProgSnippet(model.pc, [prog_insn])
        snippet.insert_into_program(program)

        model.update_for_insn(prog_insn)
        model.pc += 4

        return (snippet, False, model)


class BadCallStackRW(CallStackRW):
    '''Generate errors by over- or under-flowing the callstack'''

    ends_program = True

    def _pick_mode(self, model: Model) -> Optional[Tuple[bool, int]]:
        '''Pick whether to over- or under-flow

        Returns a pair (dir, steps) where dir is the direction to go (True for
        overflow; False for underflow) and steps is the number of instructions
        to generate (including the bad one).

        Returns None if the stack depth isn't known.

        '''
        min_depth, max_depth = model.call_stack.depth_range()
        if min_depth != max_depth:
            return None

        depth = min_depth
        if depth == 8:
            # Full call stack: overflow!
            return (True, 1)

        if depth == 0:
            # Empty call stack: underflow!
            return (False, 1)

        # Partially-full call stack. Pick over/underflow arbitrarily, but
        # underflowing more often (we have more interesting coverage points for
        # that)
        is_overflow = random.randint(0, 7) == 7
        steps = 1 + (8 - depth if is_overflow else depth)
        assert 2 <= steps <= 8
        return (is_overflow, steps)

    def gen(self,
            cont: GenCont,
            model: Model,
            program: Program) -> Optional[GenRet]:

        mode_ret = self._pick_mode(model)
        if mode_ret is None:
            print('boo (unknown)')
            return None

        is_overflow, steps = mode_ret

        # We will generate steps instructions in a straight line: make sure
        # we've got space.
        if program.get_insn_space_at(model.pc) < steps:
            print('boo (squashed)')
            return None

        assert steps > 0
        prog_insns = []
        for _ in range(steps - 1):
            # Pattern 0 causes an overflow. To actually pop something off the
            # stack, we use pattern 5 or 6.
            pat_idx = 0 if is_overflow else random.randint(5, 6)
            prog_insn = self._pick_insn(model, pat_idx)
            if prog_insn is None:
                return None
            prog_insns.append(prog_insn)

        # For the final (bad) instruction, we use pattern 0 for an overflow or
        # one of patterns 1..6 for an underflow.
        pat_idx = 0 if is_overflow else random.randint(1, 6)
        prog_insn = self._pick_insn(model, pat_idx)
        if prog_insn is None:
            return None
        prog_insns.append(prog_insn)

        snippet = ProgSnippet(model.pc, prog_insns)
        snippet.insert_into_program(program)

        # Don't bother updating model properly (since we're causing an
        # exception, the result doesn't matter). But move PC to the final
        # instruction.
        model.pc += 4 * (len(prog_insns) - 1)

        print('success!')

        return (snippet, True, model)
