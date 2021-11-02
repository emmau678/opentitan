# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
'''Generate DV code for an IP block'''

import logging as log
import os
import sys
<<<<<<< Updated upstream
from typing import List, Union, Dict
=======
from collections import defaultdict
from typing import Dict, List, Union
>>>>>>> Stashed changes

import yaml

from mako import exceptions  # type: ignore
from mako.lookup import TemplateLookup  # type: ignore
from pkg_resources import resource_filename

from .ip_block import IpBlock
from .multi_register import MultiRegister
from .register import Register
from .window import Window


class DvBaseNames:
    # Class global attributes
    valid_types = ["pkg", "block", "reg", "field", "mem", "all"]

    def __init__(self) -> None:
        self.with_prefix("dv_base")

    def with_prefix(self, prefix: str) -> None:
        self.pkg = prefix + "_reg_pkg"
        self.block = prefix + "_reg_block"
        self.reg = prefix + "_reg"
        self.field = prefix + "_reg_field"
        self.mem = prefix + "_mem"

    def set_entity(self, base_type: str, entity: str) -> None:
        assert base_type in self.valid_types, f"Invalid argument type: {base_type}"
        if base_type == "all":
            self.with_prefix(entity)
        else:
            setattr(self, base_type, entity)


def bcname(esc_if_name: str) -> str:
    '''Get the name of the dv_base_reg_block subclass for this device interface'''
    return esc_if_name + "_reg_block"


def rcname(esc_if_name: str, r: Union[Register, MultiRegister]) -> str:
    '''Get the name of the dv_base_reg subclass for this register'''
    return '{}_reg_{}'.format(esc_if_name, r.name.lower())


def mcname(esc_if_name: str, m: Window) -> str:
    '''Get the name of the dv_base_mem subclass for this memory'''
    return '{}_mem_{}'.format(esc_if_name, m.name.lower())


def miname(m: Window) -> str:
    '''Get the lower-case name of a memory block'''
    return m.name.lower()


def gen_core_file(outdir: str,
                  lblock: str,
                  dv_base_names: str,
                  paths: List[str]) -> None:
    depends = ["lowrisc:dv:dv_base_reg"]
    blocks_base_names = get_dv_base_names_objects(dv_base_names)
    # Assume the core file naming convetion is the package name without `_pkg`
    # suffix.
    for block in blocks_base_names:
        pkg_name = blocks_base_names[block].pkg
        depends.append("lowrisc:dv:{}".format(pkg_name[:-4]))

    # Generate a fusesoc core file that points at the files we've just
    # generated.
    core_data = {
        'name': "lowrisc:dv:{}_ral_pkg".format(lblock),
        'filesets': {
            'files_dv': {
                'depend': depends,
                'files': paths,
                'file_type': 'systemVerilogSource'
            },
        },
        'targets': {
            'default': {
                'filesets': [
                    'files_dv',
                ],
            },
        },
    }
    core_file_path = os.path.join(outdir, lblock + '_ral_pkg.core')
    with open(core_file_path, 'w') as core_file:
        core_file.write('CAPI=2:\n')
        yaml.dump(core_data, core_file, encoding='utf-8')


def get_dv_base_names_objects(dv_base_names: str) -> Dict[str, DvBaseNames]:
    ''' Convert the dv_base_names from string to a list of DvBaseNames objects.

    If the `dv_base_names` matches the default argument, returns default DvBaseNames object.
    If the `dv_bave_names` has customerized input, it should follow this format of a list:
    ['block-1:type:entity-name', 'block-2:type:entity-name',...].
    This method will parse the list and return customerized DvBaseNames ojects.
    '''
    dv_base_names_dict = defaultdict(DvBaseNames)

    if dv_base_names == "dv_base":
        return dv_base_names_dict

    for item in dv_base_names.split(","):
        try:
            block, base_type, entity = item.split(":")
        except ValueError:
            log.error(f"Bad input arg: {item}")
            sys.exit(1)
        dv_base_names_dict[block].set_entity(base_type, entity)
    return dv_base_names_dict


def get_block_base_name(dv_base_names: str, block: str) -> DvBaseNames:
    ''' Given a string of dv_base_names and return a DvBaseNames object for a specific block.
    '''
    blocks_dv_base_names = get_dv_base_names_objects(dv_base_names)
    if block in blocks_dv_base_names:
        return blocks_dv_base_names[block]
    return DvBaseNames()


def gen_dv(block: IpBlock, dv_base_names: str, outdir: str) -> int:
    '''Generate DV files for an IpBlock'''

    lookup = TemplateLookup(directories=[resource_filename('reggen', '.')])
    uvm_reg_tpl = lookup.get_template('uvm_reg.sv.tpl')

    # Generate the RAL package(s). For a device interface with no name we
    # generate the package "<block>_ral_pkg" (writing to <block>_ral_pkg.sv).
    # In any other case, we also need the interface name, giving
    # <block>_<ifname>_ral_pkg.
    generated = []

    lblock = block.name.lower()
    block_dv_base_names = get_block_base_name(dv_base_names, lblock)

    for if_name, rb in block.reg_blocks.items():
        hier_path = '' if block.hier_path is None else block.hier_path + '.'
        if_suffix = '' if if_name is None else '_' + if_name.lower()
        mod_base = lblock + if_suffix
        reg_block_path = hier_path + 'u_reg' + if_suffix

        file_name = mod_base + '_ral_pkg.sv'
        generated.append(file_name)
        reg_top_path = os.path.join(outdir, file_name)

        with open(reg_top_path, 'w', encoding='UTF-8') as fout:
            try:
                fout.write(uvm_reg_tpl.render(rb=rb,
                                              block=block,
                                              esc_if_name=mod_base,
                                              reg_block_path=reg_block_path,
                                              dv_base_names=block_dv_base_names))
            except:  # noqa F722 for template Exception handling
                log.error(exceptions.text_error_template().render())
                return 1

    gen_core_file(outdir, lblock, dv_base_names, generated)
    return 0
