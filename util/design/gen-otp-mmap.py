#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""Generate RTL and documentation collateral from OTP memory
map definition file (hjson).
"""
import argparse
import logging as log
import sys
from pathlib import Path
from typing import Dict

import hjson
from lib.common import wrapped_docstring
from lib.OtpMemMap import OtpMemMap
from mako import exceptions
from mako.template import Template

# This makes topgen libraries available to template files.
sys.path.append(Path(__file__).parent)

TABLE_HEADER_COMMENT = '''<!--
DO NOT EDIT THIS FILE DIRECTLY.
It has been generated with ./util/design/gen-otp-mmap.py
-->

'''

TPL_GEN_COMMENT = '''// DO NOT EDIT THIS FILE DIRECTLY.
// It has been generated with ./util/design/gen-otp-mmap.py
'''

# memory map source
MMAP_DEFINITION_FILE = "hw/ip/otp_ctrl/data/otp_ctrl_mmap.hjson"
# documentation tables to generate
PARTITIONS_TABLE_FILE = "hw/ip/otp_ctrl/doc/otp_ctrl_partitions.md"
DIGESTS_TABLE_FILE = "hw/ip/otp_ctrl/doc/otp_ctrl_digests.md"
MMAP_TABLE_FILE = "hw/ip/otp_ctrl/doc/otp_ctrl_mmap.md"

# code templates to render
COV_TEMPLATES = ["hw/ip/otp_ctrl/data/otp_ctrl_cov_bind.sv.tpl"]
DATA_TEMPLATES = ["hw/ip/otp_ctrl/data/otp_ctrl.hjson.tpl"]
ENV_TEMPLATES = [
    "hw/ip/otp_ctrl/data/otp_ctrl_env_cov.sv.tpl",
    "hw/ip/otp_ctrl/data/otp_ctrl_env_pkg.sv.tpl",
    "hw/ip/otp_ctrl/data/otp_ctrl_if.sv.tpl",
    "hw/ip/otp_ctrl/data/otp_ctrl_scoreboard.sv.tpl"
]
RTL_TEMPLATES = ["hw/ip/otp_ctrl/data/otp_ctrl_part_pkg.sv.tpl"]
SEQ_TEMPLATES = [
    "hw/ip/otp_ctrl/data/otp_ctrl_base_vseq.sv.tpl",
    "hw/ip/otp_ctrl/data/otp_ctrl_dai_lock_vseq.sv.tpl",
    "hw/ip/otp_ctrl/data/otp_ctrl_smoke_vseq.sv.tpl"
]


def check_in_repo_top():
    dot_git_path = Path.cwd() / ".git"
    if not dot_git_path.exists():
        log.error('This utility must be run from repo_top')
        exit(1)


def render_template(template: str, target_path: Path, otp_mmap: Dict,
                    gen_comment: str):
    with open(template, 'r') as tplfile:
        tpl = Template(tplfile.read())
        try:
            expansion = tpl.render(otp_mmap=otp_mmap, gen_comment=gen_comment)
        except exceptions.MakoException:
            log.error(exceptions.text_error_template().render())

    with target_path.open(mode='w', encoding='UTF-8') as outfile:
        outfile.write(expansion)


def main():
    log.basicConfig(level=log.WARNING, format="%(levelname)s: %(message)s")

    parser = argparse.ArgumentParser(
        prog="gen-otp-mmap",
        description=wrapped_docstring(),
        formatter_class=argparse.RawDescriptionHelpFormatter)

    # Generator options for compile time random netlist constants
    parser.add_argument('--seed',
                        type=int,
                        metavar='<seed>',
                        help='Custom seed for RNG to compute default values.')

    args = parser.parse_args()

    # The placement of sw difs requires this be run from repo_top.
    check_in_repo_top()

    with open(MMAP_DEFINITION_FILE, 'r') as infile:
        config = hjson.load(infile)

        # If specified, override the seed for random netlist constant computation.
        if args.seed:
            log.warning('Commandline override of seed with {}.'.format(
                args.seed))
            config['seed'] = args.seed
        # Otherwise we make sure a seed exists in the HJSON config file.
        elif 'seed' not in config:
            log.error('Seed not found in configuration HJSON.')
            exit(1)

        try:
            otp_mmap = OtpMemMap(config)
        except RuntimeError as err:
            log.error(err)
            exit(1)

        with open(PARTITIONS_TABLE_FILE, 'wb', buffering=2097152) as outfile:
            outfile.write(TABLE_HEADER_COMMENT.encode('utf-8'))
            outfile.write(otp_mmap.create_partitions_table().encode('utf-8'))
            outfile.write('\n'.encode('utf-8'))

        with open(DIGESTS_TABLE_FILE, 'wb', buffering=2097152) as outfile:
            outfile.write(TABLE_HEADER_COMMENT.encode('utf-8'))
            outfile.write(otp_mmap.create_digests_table().encode('utf-8'))
            outfile.write('\n'.encode('utf-8'))

        with open(MMAP_TABLE_FILE, 'wb', buffering=2097152) as outfile:
            outfile.write(TABLE_HEADER_COMMENT.encode('utf-8'))
            outfile.write(otp_mmap.create_mmap_table().encode('utf-8'))
            outfile.write('\n'.encode('utf-8'))

        # render all templates
        for template in COV_TEMPLATES:
            stem_path = Path(template).stem
            target_path = Path(template).parents[1] / "dv" / "cov" / stem_path
            render_template(template, target_path, otp_mmap, TPL_GEN_COMMENT)
        for template in DATA_TEMPLATES:
            stem_path = Path(template).stem
            target_path = Path(template).parent / stem_path
            render_template(template, target_path, otp_mmap, TPL_GEN_COMMENT)
        for template in ENV_TEMPLATES:
            stem_path = Path(template).stem
            target_path = Path(template).parents[1] / "dv" / "env" / stem_path
            render_template(template, target_path, otp_mmap, TPL_GEN_COMMENT)
        for template in RTL_TEMPLATES:
            stem_path = Path(template).stem
            target_path = Path(template).parents[1] / "rtl" / stem_path
            render_template(template, target_path, otp_mmap, TPL_GEN_COMMENT)
        for template in SEQ_TEMPLATES:
            stem_path = Path(template).stem
            target_path = (Path(template).parents[1] / "dv" / "env" /
                           "seq_lib" / stem_path)
            render_template(template, target_path, otp_mmap, TPL_GEN_COMMENT)


if __name__ == "__main__":
    main()
