#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

'''A helper script to generate a default set of binaries for OTBN testing

This is intended for use with dvsim, which should call this script as
part of the test build phase.

'''

import argparse
import os
import subprocess
import sys
from typing import Dict, List, Optional, TextIO, Union


def read_positive(val: str) -> int:
    ival = -1
    try:
        ival = int(val, 0)
    except ValueError:
        pass

    if ival <= 0:
        raise argparse.ArgumentTypeError('{!r} is not a positive integer.'
                                         .format(val))
    return ival


def read_jobs(val: Optional[str]) -> Optional[Union[str, int]]:
    if val == 'unlimited':
        return 'unlimited'
    if val is None:
        return None

    return read_positive(val)


class Toolchain:
    def __init__(self, env_data: Dict[str, str]) -> None:
        self.otbn_as = self.get_tool(env_data, 'OTBN_AS')
        self.otbn_ld = self.get_tool(env_data, 'OTBN_LD')
        self.rv32_tool_as = self.get_tool(env_data, 'RV32_TOOL_AS')
        self.rv32_tool_ld = self.get_tool(env_data, 'RV32_TOOL_LD')

    @staticmethod
    def get_tool(env_data: Dict[str, str], tool: str) -> str:
        path = env_data.get(tool)
        if path is None:
            raise RuntimeError('No entry for {} in .env file'.format(tool))
        return path

    def run(self, cmd: List[str]) -> None:
        '''Wrapper around subprocess.run that sets needed environment vars'''
        env = os.environ.copy()
        env['RV32_TOOL_AS'] = self.rv32_tool_as
        env['RV32_TOOL_LD'] = self.rv32_tool_ld
        subprocess.run(cmd, env=env)


def take_env_line(dst: Dict[str, str],
                  path: str, line_number: int, line: str) -> None:
    '''Read one line from a .env file, updating dst.'''
    line = line.split('#', 1)[0].strip()
    if not line:
        return

    parts = line.split('=', 1)
    if len(parts) != 2:
        raise RuntimeError('{}:{}: No equals sign in line {!r}.'
                           .format(path, line_number, line))

    dst[parts[0]] = parts[1]


def read_toolchain(obj_dir_arg: Optional[str], otbn_dir: str) -> Toolchain:
    '''Read Meson's dumped .env file to get toolchain info'''
    if obj_dir_arg is not None:
        obj_dir = obj_dir_arg
        source = 'specified by an --obj-dir argument'
    else:
        obj_dir_env = os.getenv('OBJ_DIR')
        if obj_dir_env is not None:
            obj_dir = obj_dir_env
            source = ('inferred from OBJ_DIR environment variable; '
                      'have you run meson_init.sh?')
        else:
            git_dir = os.path.normpath(os.path.join(otbn_dir, '../' * 3))
            obj_dir = os.path.normpath(os.path.join(git_dir, 'build-out'))
            source = ('inferred from script location; '
                      'have you run meson_init.sh?')

    env_path = os.path.join(obj_dir, '.env')
    try:
        with open(env_path) as env_file:
            env_dict = {}  # type: Dict[str, str]
            for idx, line in enumerate(env_file):
                take_env_line(env_dict, env_path, idx + 1, line)

            return Toolchain(env_dict)
    except OSError as ose:
        raise RuntimeError('Failed to read .env file at {!r} '
                           '(at a path {}): {}.'
                           .format(env_path, source, ose)) from None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--obj-dir',
                        help=('Object directory configured with Meson (used '
                              'to find tool configuration). If not supplied, '
                              'defaults to the OBJ_DIR environment variable '
                              'if set, or build-out at the top of the '
                              'repository if not.'))
    parser.add_argument('--count', type=read_positive,
                        help='Number of binaries to generate (default: 10)')
    parser.add_argument('--seed', type=read_positive)
    parser.add_argument('--size', type=read_positive)
    parser.add_argument('--src-dir',
                        help=('If supplied, gen-binaries.py will not generate '
                              'random binaries. Instead, it will assemble and '
                              'link each .s file that it can find in the '
                              'given directory. This is useful for building '
                              'the smoke test or other directed tests.'))
    parser.add_argument('--verbose', '-v', action='store_true')
    parser.add_argument('--jobs', '-j', type=read_jobs, nargs='?',
                        const='unlimited', help='Number of parallel jobs.')
    parser.add_argument('--gen-only', action='store_true',
                        help="Generate the ninja file but don't run it")
    parser.add_argument('--ninja-suffix', type=str)
    parser.add_argument('destdir',
                        help='Destination directory')

    args = parser.parse_args()

    # Argument consistency checks
    if args.src_dir is None:
        if args.count is None:
            args.count = 10
        if args.seed is None:
            args.seed = 1
        if args.size is None:
            args.size = 100
    else:
        if args.count is not None:
            raise RuntimeError('Invalid combination: --count and --src-dir '
                               'both supplied.')
        if args.seed is not None:
            raise RuntimeError('Invalid combination: --seed and --src-dir '
                               'both supplied.')
        if args.size is not None:
            raise RuntimeError('Invalid combination: --size and --src-dir '
                               'both supplied.')

    script_dir = os.path.dirname(__file__)
    otbn_dir = os.path.normpath(os.path.join(script_dir, '../' * 2))

    try:
        toolchain = read_toolchain(args.obj_dir, otbn_dir)
    except RuntimeError as err:
        print(err, file=sys.stderr)
        return 1

    os.makedirs(args.destdir, exist_ok=True)

    ninja_fname = 'build.ninja'
    if args.ninja_suffix is not None:
        ninja_fname += '.' + args.ninja_suffix

    with open(os.path.join(args.destdir, ninja_fname), 'w') as ninja_handle:
        if args.src_dir is None:
            write_ninja_rnd(ninja_handle, toolchain, otbn_dir,
                            args.count, args.seed, args.size)
        else:
            write_ninja_fixed(ninja_handle, toolchain, otbn_dir, args.src_dir)

    if args.gen_only:
        return 0

    # Handle the -j argument like Make does, defaulting to 1 thread. This
    # behaves a bit more reasonably than ninja's default (# cores) if we're
    # running underneath something else.
    if args.jobs is None:
        j_arg = 1
    elif args.jobs == 'unlimited':
        j_arg = 0
    else:
        j_arg = args.jobs

    cmd = ['ninja', '-j', str(j_arg)]
    if args.verbose:
        cmd.append('-v')

    return subprocess.run(cmd, cwd=args.destdir, check=False).returncode


def write_ninja_rnd(handle: TextIO,
                    toolchain: Toolchain,
                    otbn_dir: str,
                    count: int,
                    start_seed: int,
                    size: int) -> None:
    '''Write a build.ninja to build random binaries

    The rules build everything in the same directory as the build.ninja file.
    OTBN tooling is found through the toolchain argument.

    '''
    assert count > 0
    assert start_seed >= 0
    assert size > 0

    otbn_rig = os.path.join(otbn_dir, 'dv/rig/otbn-rig')

    handle.write('rule rig-gen\n'
                 '  command = {rig} gen --size {size} --seed $seed -o $out\n\n'
                 .format(rig=otbn_rig, size=size))

    handle.write('rule rig-asm\n'
                 '  command = {rig} asm -o $seed $in\n\n'
                 .format(rig=otbn_rig))

    handle.write('rule as\n'
                 '  command = RV32_TOOL_AS={rv32_as} {otbn_as} -o $out $in\n\n'
                 .format(rv32_as=toolchain.rv32_tool_as,
                         otbn_as=toolchain.otbn_as))

    handle.write('rule ld\n'
                 '  command = RV32_TOOL_LD={rv32_ld} '
                 '{otbn_ld} -o $out -T $ldscript $in\n'
                 .format(rv32_ld=toolchain.rv32_tool_ld,
                         otbn_ld=toolchain.otbn_ld))

    for seed in range(start_seed, start_seed + count):
        # Generate the .s and .ld files.
        handle.write('build {seed}.json: rig-gen\n'
                     '  seed = {seed}\n'
                     .format(seed=seed))

        handle.write('build {seed}.s {seed}.ld: rig-asm {seed}.json\n'
                     '  seed = {seed}\n'
                     .format(seed=seed))

        # Assemble the asm file to an object
        handle.write('build {seed}.o: as {seed}.s\n'.format(seed=seed))

        # Link the object to an ELF, using the relevant LD file
        handle.write('build {seed}.elf: ld {seed}.o\n'
                     '  ldscript = {seed}.ld\n\n'
                     .format(seed=seed))


def write_ninja_fixed(handle: TextIO,
                      toolchain: Toolchain,
                      otbn_dir: str,
                      src_dir: str) -> None:
    '''Write a build.ninja to build a fixed set of binaries

    The rules build everything in the same directory as the build.ninja file.
    OTBN tooling is found through the toolchain argument.

    '''

    handle.write('rule as\n'
                 '  command = RV32_TOOL_AS={rv32_as} {otbn_as} -o $out $in\n\n'
                 .format(rv32_as=toolchain.rv32_tool_as,
                         otbn_as=toolchain.otbn_as))

    handle.write('rule ld\n'
                 '  command = RV32_TOOL_LD={rv32_ld} {otbn_ld} -o $out $in\n\n'
                 .format(rv32_ld=toolchain.rv32_tool_ld,
                         otbn_ld=toolchain.otbn_ld))

    count = 0
    for fname in os.listdir(src_dir):
        if not fname.endswith('.s'):
            continue

        abs_path = os.path.abspath(os.path.join(src_dir, fname))
        basename = fname[:-2]

        handle.write(f'build {basename}.o: as {abs_path}\n')
        handle.write(f'build {basename}.elf: ld {basename}.o\n\n')
        count += 1

    if not count:
        raise RuntimeError(f'No .s files in {src_dir}')


if __name__ == '__main__':
    sys.exit(main())
