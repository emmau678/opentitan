#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

'''A simulator that runs one instruction at a time, reading from a REPL

The input language is simple (and intended to be generated by another program).
Input should appear with one command per line.

The valid commands are as follows. All arguments are shown here as <argname>.
The integer arguments are read with Python's int() function, so should be
prefixed with "0x" if they are hexadecimal.

    start <addr>         Set the PC to <addr> and start OTBN

    step                 Run one instruction. Print trace information to
                         stdout.

    run                  Run instructions until ecall or error. No trace
                         information.

    load_elf <path>      Load the ELF file at <path>, replacing current
                         contents of DMEM and IMEM.

    load_d <path>        Replace the current contents of DMEM with <path>
                         (read as an array of 32-bit little-endian words)

    load_i <path>        Replace the current contents of IMEM with <path>
                         (read as an array of 32-bit little-endian words)

    dump_d <path>        Write the current contents of DMEM to <path> (same
                         format as for load).

    print_regs           Write the contents of all registers to stdout (in hex)

'''

import sys
from typing import List

from sim.decode import decode_file
from sim.elf import load_elf
from sim.sim import OTBNSim


def read_word(arg_name: str, word_data: str, bits: int) -> int:
    '''Try to read an unsigned word of the specified bit length'''
    try:
        value = int(word_data, 0)
    except ValueError:
        raise ValueError('Failed to read {!r} as an integer for <{}> argument.'
                         .format(word_data, arg_name)) from None

    if value < 0 or value >> bits:
        raise ValueError('<{}> argument is {!r}: not representable in {!r} bits.'
                         .format(arg_name, word_data, bits))

    return value


def end_command() -> None:
    '''Print a single '.' to stdout and flush, ending the output for command'''
    print('.')
    sys.stdout.flush()


def on_start(sim: OTBNSim, args: List[str]) -> None:
    '''Jump to an address given as the (only) argument and start running'''
    if len(args) != 1:
        raise ValueError('start expects exactly 1 argument. Got {}.'
                         .format(args))

    addr = read_word('addr', args[0], 32)
    if addr & 3:
        raise ValueError('start address must be word-aligned. Got {:#08x}.'
                         .format(addr))
    print('START {:#08x}'.format(addr))
    sim.state.ext_regs.write('START_ADDR', addr, False)
    sim.state.ext_regs.commit()
    sim.start()


def on_step(sim: OTBNSim, args: List[str]) -> None:
    '''Step one instruction'''
    if len(args):
        raise ValueError('step expects zero arguments. Got {}.'
                         .format(args))

    pc = sim.state.pc
    assert 0 == pc & 3

    insn, changes = sim.step(verbose=False, collect_stats=False)

    if insn is None:
        hdr = 'STALL'
    else:
        hdr = 'E PC: {:#010x}, insn: {:#010x}'.format(pc, insn.raw)
    print(hdr)
    for change in changes:
        entry = change.rtl_trace()
        if entry is not None:
            print(entry)


def on_run(sim: OTBNSim, args: List[str]) -> None:
    '''Run until ecall or error'''
    if len(args):
        raise ValueError('run expects zero arguments. Got {}.'
                         .format(args))

    num_cycles = sim.run(verbose=False, collect_stats=False)
    print(' ran for {} cycles'.format(num_cycles))


def on_load_elf(sim: OTBNSim, args: List[str]) -> None:
    '''Load contents of ELF at path given by only argument'''
    if len(args) != 1:
        raise ValueError('load_elf expects exactly 1 argument. Got {}.'
                         .format(args))
    path = args[0]

    print('LOAD_ELF {!r}'.format(path))
    load_elf(sim, path)


def on_load_d(sim: OTBNSim, args: List[str]) -> None:
    '''Load contents of data memory from file at path given by only argument'''
    if len(args) != 1:
        raise ValueError('load_d expects exactly 1 argument. Got {}.'
                         .format(args))
    path = args[0]

    print('LOAD_D {!r}'.format(path))
    with open(path, 'rb') as handle:
        sim.load_data(handle.read())


def on_load_i(sim: OTBNSim, args: List[str]) -> None:
    '''Load contents of insn memory from file at path given by only argument'''
    if len(args) != 1:
        raise ValueError('load_i expects exactly 1 argument. Got {}.'
                         .format(args))
    path = args[0]

    print('LOAD_I {!r}'.format(path))
    sim.load_program(decode_file(0, path))


def on_dump_d(sim: OTBNSim, args: List[str]) -> None:
    '''Dump contents of data memory to file at path given by only argument'''
    if len(args) != 1:
        raise ValueError('dump_d expects exactly 1 argument. Got {}.'
                         .format(args))
    path = args[0]

    print('DUMP_D {!r}'.format(path))

    with open(path, 'wb') as handle:
        handle.write(sim.state.dmem.dump_le_words())


def on_print_regs(sim: OTBNSim, args: List[str]) -> None:
    '''Print registers to stdout'''
    if len(args):
        raise ValueError('print_regs expects zero arguments. Got {}.'
                         .format(args))

    print('PRINT_REGS')
    for idx, value in enumerate(sim.state.gprs.peek_unsigned_values()):
        print(' x{:<2} = 0x{:08x}'.format(idx, value))
    for idx, value in enumerate(sim.state.wdrs.peek_unsigned_values()):
        print(' w{:<2} = 0x{:064x}'.format(idx, value))


def on_print_call_stack(sim: OTBNSim, args: List[str]) -> None:
    '''Print call stack to stdout. First element is the bottom of the stack'''
    if len(args):
        raise ValueError('print_call_stack expects zero arguments. Got {}.'
                         .format(args))

    print('PRINT_CALL_STACK')
    for value in sim.state.peek_call_stack():
        print('0x{:08x}'.format(value))


def on_edn_rnd_data(sim: OTBNSim, args: List[str]) -> None:
    if len(args) != 1:
        raise ValueError('edn_rnd_data expects exactly 1 argument. Got {}.'
                         .format(args))

    edn_rnd_data = read_word('edn_rnd_data', args[0], 256)
    sim.state.set_rnd_data(edn_rnd_data)


def on_edn_urnd_reseed_complete(sim: OTBNSim, args: List[str]) -> None:
    if args:
        raise ValueError('edn_urnd_reseed_complete expects zero arguments. Got {}.'
                         .format(args))

    sim.state.set_urnd_reseed_complete()


_HANDLERS = {
    'start': on_start,
    'step': on_step,
    'run': on_run,
    'load_elf': on_load_elf,
    'load_d': on_load_d,
    'load_i': on_load_i,
    'dump_d': on_dump_d,
    'print_regs': on_print_regs,
    'print_call_stack': on_print_call_stack,
    'edn_rnd_data': on_edn_rnd_data,
    'edn_urnd_reseed_complete': on_edn_urnd_reseed_complete
}


def on_input(sim: OTBNSim, line: str) -> None:
    '''Process an input command'''
    words = line.split()

    # Just ignore empty lines
    if not words:
        return

    verb = words[0]
    handler = _HANDLERS.get(verb)
    if handler is None:
        raise RuntimeError('Unknown command: {!r}'.format(verb))

    handler(sim, words[1:])
    print('.')
    sys.stdout.flush()


def main() -> int:
    sim = OTBNSim()
    try:
        for line in sys.stdin:
            on_input(sim, line)
    except KeyboardInterrupt:
        print("Received shutdown request, ending OTBN simulation.")
        return 0
    return 0


if __name__ == '__main__':
    sys.exit(main())
