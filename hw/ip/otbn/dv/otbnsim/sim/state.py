# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from enum import IntEnum
from typing import Dict, List, Optional

from shared.mem_layout import get_memory_layout

from .csr import CSRFile
from .dmem import Dmem
from .constants import ErrBits, Status
from .ext_regs import OTBNExtRegs
from .flags import FlagReg
from .gpr import GPRs
from .loop import LoopStack
from .reg import RegFile
from .trace import Trace, TracePC
from .wsr import WSRFile


class FsmState(IntEnum):
    r'''State of the internal start/stop FSM

    The FSM diagram looks like:

        IDLE  ->  PRE_EXEC  ->  EXEC  -\
                                       |
          ^                            |
          +----------------------------/
          v

        LOCKED

    IDLE represents the state when nothing is going on but there have been no
    fatal errors. It matches Status.IDLE. LOCKED represents the state when
    there has been a fatal error. It matches Status.LOCKED.

    PRE_EXEC and EXEC correspond to Status.BUSY_EXECUTE. PRE_EXEC is the period
    after starting OTBN where we're still waiting for an EDN value to seed
    URND. EXEC is the period where we start fetching and executing
    instructions.

    This is a refinement of the Status enum and the integer values are picked
    so that you can divide by 10 to get the corresponding Status entry. (This
    isn't used in the code, but makes debugging slightly more convenient when
    you just have the numeric values available).

    '''
    IDLE = 0
    PRE_EXEC = 10
    EXEC = 11
    LOCKED = 2550


class OTBNState:
    def __init__(self) -> None:
        self.gprs = GPRs()
        self.wdrs = RegFile('w', 256, 32)

        self.wsrs = WSRFile()
        self.csrs = CSRFile()

        self.pc = 0
        self._pc_next_override = None  # type: Optional[int]

        _, imem_size = get_memory_layout()['IMEM']
        self.imem_size = imem_size

        self.dmem = Dmem()

        self.fsm_state = FsmState.IDLE

        self.loop_stack = LoopStack()
        self.ext_regs = OTBNExtRegs()

        self._err_bits = 0
        self.pending_halt = False

        self._urnd_reseed_complete = False

        self.rnd_256b_counter = 0
        self.rnd_cdc_pending = False
        self.rnd_cdc_counter = 0
        self.rnd_256b = 0
        self.rnd_cached_tmp = None  # type: Optional[int]
        self.counter = 0

        # This flag is set to true if we've injected integrity errors, trashing
        # the whole of IMEM. The next fetch should fail.
        self.invalidated_imem = False

    def get_next_pc(self) -> int:
        if self._pc_next_override is not None:
            return self._pc_next_override
        return self.pc + 4

    def set_next_pc(self, next_pc: int) -> None:
        '''Overwrite the next program counter, e.g. as result of a jump.'''
        assert(self.is_pc_valid(next_pc))
        self._pc_next_override = next_pc

    def step_edn(self, rnd_data: int) -> None:
        # Take the new data
        assert 0 <= rnd_data < (1 << 32)

        # There should not be a pending RND result before an EDN step.
        assert not self.rnd_cdc_pending

        # Collect 32b packages in a 256b variable
        shift_num = 32 * self.rnd_256b_counter
        self.rnd_256b = (self.rnd_256b | (rnd_data << shift_num)) & ((1 << 256) - 1)

        if self.rnd_256b_counter == 7:
            # Reset the 32b package counter and wait until receiving done
            # signal from RTL
            self.rnd_256b_counter = 0
            self.rnd_cdc_pending = True
        else:
            # Count until 8 valid packages are received
            self.rnd_256b_counter += 1
            return

        # Reset the 32b package counter and wait until receiving done
        # signal from RTL
        self.rnd_256b_counter = 0
        self.rnd_cdc_pending = True

    def rnd_completed(self) -> None:
        # This will be called when all the packages are received and processed
        # by RTL. Model will set RND register, pending flag and internal
        # variables will be cleared.

        # These must be true since model calculates RND data faster than RTL.
        # But the synchronisation of the data should not take more than
        # 5 cycles ideally.
        assert self.rnd_cdc_pending
        assert self.rnd_cdc_counter < 6

        self.wsrs.RND.set_unsigned(self.rnd_256b)
        self.rnd_256b = 0
        self.rnd_cdc_pending = False
        self.rnd_cdc_counter = 0

    def set_urnd_reseed_complete(self) -> None:
        assert self.fsm_state == FsmState.PRE_EXEC
        self._urnd_reseed_complete = True

    def loop_start(self, iterations: int, bodysize: int) -> None:
        self.loop_stack.start_loop(self.pc + 4, iterations, bodysize)

    def loop_step(self, loop_warps: Dict[int, int]) -> None:
        back_pc = self.loop_stack.step(self.pc, loop_warps)
        if back_pc is not None:
            self.set_next_pc(back_pc)

    def in_loop(self) -> bool:
        '''The processor is currently executing a loop.'''

        # A loop is executed if the loop stack is not empty.
        return bool(self.loop_stack.stack)

    def changes(self) -> List[Trace]:
        c = []  # type: List[Trace]
        c += self.gprs.changes()
        if self._pc_next_override is not None:
            # Only append the next program counter to the trace if it is special
            c.append(TracePC(self.get_next_pc()))
        c += self.dmem.changes()
        c += self.loop_stack.changes()
        c += self.ext_regs.changes()
        c += self.wsrs.changes()
        c += self.csrs.flags.changes()
        c += self.wdrs.changes()
        return c

    def running(self) -> bool:
        return self.fsm_state not in [FsmState.IDLE, FsmState.LOCKED]

    def commit(self, sim_stalled: bool) -> None:
        # We shouldn't be running commit() in IDLE or LOCKED mode
        assert self.running()

        # If model is waiting for the RND register to cross CDC, increment a
        # counter to say how long we've waited. This lets us spot if the CDC
        # gets stuck for some reason.
        if self.rnd_cdc_pending:
            self.rnd_cdc_counter += 1

        # If we are in PRE_EXEC mode, we should commit external registers
        # (which lets us reflect things like the update to the STATUS
        # register). Then we wait until _urnd_reseed_complete, at which point,
        # we'll switch to EXEC mode.
        if self.fsm_state == FsmState.PRE_EXEC:
            self.ext_regs.commit()
            if self._urnd_reseed_complete:
                self.fsm_state = FsmState.EXEC

            return

        # Otherwise, we're in EXEC mode.
        assert self.fsm_state == FsmState.EXEC

        # In case of a pending halt, commit the external registers, which
        # contain e.g. the ERR_BITS field, but nothing else. Then switch to
        # IDLE or LOCKED, depending on whether there are any bits set in the
        # upper half of _err_bits.
        if self.pending_halt:
            self.ext_regs.commit()
            self.fsm_state = (FsmState.LOCKED
                              if self._err_bits >> 16 else FsmState.IDLE)
            return

        # As pending_halt wasn't set, there shouldn't be any pending error bits
        assert self._err_bits == 0

        self.ext_regs.commit()

        # If we're stalled, there's nothing more to do: we only commit the rest
        # of the architectural state when we finish our stall cycles.
        if sim_stalled:
            return

        self.dmem.commit()
        self.gprs.commit()
        self.pc = self.get_next_pc()
        self._pc_next_override = None
        self.loop_stack.commit()
        self.ext_regs.commit()
        self.wsrs.commit()
        self.csrs.flags.commit()
        self.wdrs.commit()

    def _abort(self) -> None:
        '''Abort any pending state changes'''
        self.gprs.abort()
        self._pc_next_override = None
        self.dmem.abort()
        self.loop_stack.abort()
        self.ext_regs.abort()
        self.wsrs.abort()
        self.csrs.flags.abort()
        self.wdrs.abort()

    def start(self) -> None:
        '''Start running; perform state init'''
        self.ext_regs.write('STATUS', Status.BUSY_EXECUTE, True)
        self.pending_halt = False
        self._err_bits = 0
        self._urnd_reseed_complete = False

        self.fsm_state = FsmState.PRE_EXEC

        self.pc = 0

        # Reset CSRs, WSRs, loop stack and call stack
        self.csrs = CSRFile()

        # Save the RND value when starting another run because when a SW
        # run finishes we still keep RND data.
        old_rnd = self.wsrs.RND._random_value

        self.wsrs = WSRFile()
        if old_rnd is not None:
            self.wsrs.RND.set_unsigned(old_rnd)

        self.loop_stack = LoopStack()
        self.gprs.start()

    def stop(self) -> None:
        '''Set flags to stop the processor and maybe abort the instruction.

        If the current instruction has caused an error (so self._err_bits is
        nonzero), abort all its pending changes, including changes to external
        registers.

        If not, we've just executed an ECALL. The only pending change will be
        the increment of INSN_CNT that we want to keep.

        Either way, set the appropriate bits in the external ERR_CODE register,
        clear the busy flag and write STOP_PC.

        '''

        if self._err_bits:
            # Abort all pending changes, including changes to external registers.
            self._abort()

        # INTR_STATE is the interrupt state register. Bit 0 (which is being
        # set) is the 'done' flag.
        self.ext_regs.set_bits('INTR_STATE', 1 << 0)

        # STATUS is a status register. If there are any pending error bits
        # greater than 16, this was a fatal error so we should lock ourselves.
        # Otherwise, go back to IDLE.
        new_status = Status.LOCKED if self._err_bits >> 16 else Status.IDLE
        self.ext_regs.write('STATUS', new_status, True)

        # Make any error bits visible
        self.ext_regs.write('ERR_BITS', self._err_bits, True)

        # Make the final PC visible. This isn't currently in the RTL, but is
        # useful in simulations that want to track whether we stopped where we
        # expected to stop.
        self.ext_regs.write('STOP_PC', self.pc, True)

    def set_flags(self, fg: int, flags: FlagReg) -> None:
        '''Update flags for a flag group'''
        self.csrs.flags[fg] = flags

    def set_mlz_flags(self, fg: int, result: int) -> None:
        '''Update M, L, Z flags for a flag group using the given result'''
        self.csrs.flags[fg] = \
            FlagReg.mlz_for_result(self.csrs.flags[fg].C, result)

    def pre_insn(self, insn_affects_control: bool) -> None:
        '''Run before running an instruction'''
        self.loop_stack.check_insn(self.pc, insn_affects_control)

    def is_pc_valid(self, pc: int) -> bool:
        '''Return whether pc is a valid program counter.'''
        # The PC should always be non-negative since it's represented as an
        # unsigned value. (It's an error in the simulator if that's come
        # unstuck)
        assert 0 <= pc

        # Check the new PC is word-aligned
        if pc & 3:
            return False

        # Check the new PC lies in instruction memory
        if pc >= self.imem_size:
            return False

        return True

    def post_insn(self, loop_warps: Dict[int, int]) -> None:
        '''Update state after running an instruction but before commit'''
        self.ext_regs.increment_insn_cnt()
        self.loop_step(loop_warps)
        self.gprs.post_insn()

        self._err_bits |= self.gprs.err_bits() | self.loop_stack.err_bits()
        if self._err_bits:
            self.pending_halt = True

        # Check that the next PC is valid, but only if we're not stopping
        # anyway. This handles the case where we have a straight-line
        # instruction at the top of memory. Jumps and branches to invalid
        # addresses are handled in the instruction definition.
        #
        # This check is squashed if we're already halting, which avoids a
        # problem when you have an ECALL instruction at the top of memory (the
        # next address is bogus, but we don't care because we're stopping
        # anyway).
        if not self.is_pc_valid(self.get_next_pc()) and not self.pending_halt:
            self._err_bits |= ErrBits.BAD_INSN_ADDR
            self.pending_halt = True

    def read_csr(self, idx: int) -> int:
        '''Read the CSR with index idx as an unsigned 32-bit number'''
        return self.csrs.read_unsigned(self.wsrs, idx)

    def write_csr(self, idx: int, value: int) -> None:
        '''Write value (an unsigned 32-bit number) to the CSR with index idx'''
        self.csrs.write_unsigned(self.wsrs, idx, value)

    def peek_call_stack(self) -> List[int]:
        '''Return the current call stack, bottom-first'''
        return self.gprs.peek_call_stack()

    def stop_at_end_of_cycle(self, err_bits: int) -> None:
        '''Tell the simulation to stop at the end of the cycle

        Any bits set in err_bits will be set in the ERR_BITS register when
        we're done.

        '''
        self._err_bits |= err_bits
        self.pending_halt = True
