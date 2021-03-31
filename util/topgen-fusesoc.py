#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""FuseSoC wrapper for Top Module Generator

This wrapper is called by FuseSoC. It extracts the arguments for topgen from the auto-generated
GAPI file and creates a core file for the generated sources.
"""
import sys
import yaml
import subprocess
import os

try:
    from yaml import CSafeLoader as YamlLoader, CSafeDumper as YamlDumper
except ImportError:
    from yaml import SafeLoader as YamlLoader, SafeDumper as YamlDumper


def _check_gapi(gapi):
    if 'cores' not in gapi:
        print("Key 'cores' not found in GAPI structure. "
              "Install a compatible version with "
              "'pip3 install --user -r python-requirements.txt'.")
        return False
    return True


def write_core(core_filepath, generated_core):
    with open(core_filepath, 'w') as f:
        # FuseSoC requires this line to appear first in the YAML file.
        # Inserting this line through the YAML serializer requires ordered dicts
        # to be used everywhere, which is annoying syntax-wise on Python <3.7,
        # where native dicts are not sorted.
        f.write('CAPI=2:\n')
        yaml.dump(generated_core,
                  f,
                  encoding="utf-8",
                  Dumper=YamlDumper)
    print("Core file written to %s" % (core_filepath, ))


def main():

    # Extract arguments from GAPI file.
    gapi_filepath = sys.argv[1]
    with open(gapi_filepath) as f:
        gapi = yaml.load(f, Loader=YamlLoader)

    if not _check_gapi(gapi):
        sys.exit(1)

    files_root = ""
    if 'files_root' in gapi:
        files_root = gapi['files_root']

    topname = ""
    if 'parameters' in gapi and 'topname' in gapi['parameters']:
        topname = gapi['parameters']['topname']

    reg_only = ""
    if 'parameters' in gapi and 'reg-only' in gapi['parameters']:
        reg_only = gapi['parameters']['reg-only']

    # Call topgen.
    files_data = files_root + "/hw/" + topname + "/data/"
    files_out = os.getcwd()
    cmd = [files_root + "/util/topgen.py",  # "--verbose",
           "-t", files_data + topname + ".hjson",
           "-o", files_out]
    try:
        print("Running topgen.")
        subprocess.run(cmd,
                       check=True,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT,
                       universal_newlines=True)

    except subprocess.CalledProcessError as e:
        print("topgen failed: " + str(e))
        print(e.stdout)
        sys.exit(1)

    # Create core files.
    print("Creating core files.")

    # For some cores such IP package files, we need a separate dependency for the register file.
    # Combining this with the generated topgen core file below leads to cyclic dependencies. For
    # example, flash_ctrl depends on topgen but also on pwrmgr_pkg which depends on
    # pwrmgr_reg_pkg generated by topgen.
    reg_top_suffix = {
        'alert_handler': '',
        'clkmgr': '',
        'flash_ctrl': '_core',
        'pinmux': '',
        'pwrmgr': '',
        'rstmgr': '',
        'rv_plic': ''
    }

    if reg_only:
        for ip in ['alert_handler', 'clkmgr', 'flash_ctrl', 'pinmux', 'pwrmgr',
                   'rstmgr', 'rv_plic']:
            core_filepath = os.path.abspath('generated-%s.core' % ip)
            name = 'lowrisc:ip:%s_reggen' % ip,
            files = ['ip/%s/rtl/autogen/%s_reg_pkg.sv' % (ip, ip),
                     'ip/%s/rtl/autogen/%s_reg_top.sv' % (ip, ip + reg_top_suffix[ip])]
            generated_core = {
                'name': '%s' % name,
                'filesets': {
                    'files_rtl': {
                        'depend': [
                            'lowrisc:ip:tlul',
                        ],
                        'files': files,
                        'file_type': 'systemVerilogSource'
                    },
                },
                'targets': {
                    'default': {
                        'filesets': [
                            'files_rtl',
                        ],
                    },
                },
            }
            write_core(core_filepath, generated_core)

    else:
        nameparts = topname.split('_')
        if nameparts[0] == 'top' and len(nameparts) > 1:
            chipname = 'chip_' + '_'.join(nameparts[1:])
        else:
            chipname = topname

        core_filepath = os.path.abspath('generated-topgen.core')
        generated_core = {
            'name': "lowrisc:systems:generated-topgen",
            'filesets': {
                'files_rtl': {
                    'depend': [
                        # Ibex and OTBN constants
                        'lowrisc:ibex:ibex_pkg',
                        'lowrisc:ip:otbn_pkg',
                        # flash_ctrl
                        'lowrisc:constants:top_pkg',
                        'lowrisc:prim:util',
                        'lowrisc:ip:lc_ctrl_pkg',
                        'lowrisc:ip:pwrmgr_pkg',
                        # rstmgr
                        'lowrisc:prim:clock_mux2',
                        # clkmgr
                        'lowrisc:prim:all',
                        'lowrisc:prim:clock_gating',
                        'lowrisc:prim:clock_buf',
                        'lowrisc:prim:clock_div',
                        'lowrisc:ip:clkmgr_components',
                        # Top
                        # ast and sensor_ctrl not auto-generated, re-used from top_earlgrey
                        'lowrisc:systems:sensor_ctrl',
                        'lowrisc:systems:ast_pkg',
                        # TODO: absorb this into AST longerm
                        'lowrisc:systems:clkgen_xil7series',
                    ],
                    'files': [
                        # IPs
                        'ip/clkmgr/rtl/autogen/clkmgr.sv',
                        'ip/flash_ctrl/rtl/autogen/flash_ctrl_pkg.sv',
                        'ip/flash_ctrl/rtl/autogen/flash_ctrl.sv',
                        'ip/rstmgr/rtl/autogen/rstmgr_pkg.sv',
                        'ip/rstmgr/rtl/autogen/rstmgr.sv',
                        'ip/rv_plic/rtl/autogen/rv_plic.sv',
                        # Top
                        'rtl/autogen/%s_rnd_cnst_pkg.sv' % topname,
                        'rtl/autogen/%s_pkg.sv' % topname,
                        'rtl/autogen/%s.sv' % topname,
                        # TODO: this is not ideal. we should extract
                        # this info from the target configuration and
                        # possibly generate separate core files for this.
                        'rtl/autogen/%s_cw305.sv' % chipname,
                    ],
                    'file_type': 'systemVerilogSource'
                },
            },
            'targets': {
                'default': {
                    'filesets': [
                        'files_rtl',
                    ],
                },
            },
        }
        write_core(core_filepath, generated_core)

    return 0


if __name__ == "__main__":
    main()
