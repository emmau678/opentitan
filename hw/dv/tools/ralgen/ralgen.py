#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""FuseSoc generator for UVM RAL package created with either regtool or
topgen tools.
"""
import logging as log
import os
import shlex
import subprocess
import sys
from pathlib import Path

import yaml

try:
    from yaml import CSafeLoader as YamlLoader
except ImportError:
    from yaml import SafeLoader as YamlLoader


# Get the REPO_TOP directory path. This is used to construct full paths below.
def get_repo_top():
    cmd = ["git", "rev-parse", "--show-toplevel"]
    result = subprocess.run(cmd,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    repo_top = result.stdout.decode("utf-8").strip()
    if not repo_top:
        log.error(
            "Attempted to find the root of this GitHub repository by running:\n"
            "{}\n"
            "But this command has failed:\n"
            "{}".format(' '.join(cmd), result.stderr.decode("utf-8")))
        sys.exit(1)
    return repo_top


def main():
    if len(sys.argv) != 2:
        print("ERROR: This script takes a single YAML file as input argument")
        sys.exit(1)

    gapi_filepath = sys.argv[1]
    gapi = yaml.load(open(gapi_filepath), Loader=YamlLoader)

    # The reggen and topgen tools live in REPO_TOP/util area.
    util_path = Path(get_repo_top()) / "util"

    # Retrieve the parameters from the yml.
    root_dir = Path(gapi['files_root'])
    name = gapi['parameters'].get('name')
    alias_hjson = gapi['parameters'].get('alias_hjson')
    ip_hjson = gapi['parameters'].get('ip_hjson')
    top_hjson = gapi['parameters'].get('top_hjson')
    dv_base_names = gapi['parameters'].get('dv_base_names')
    hjson_path = gapi['parameters'].get('hjson_path')

    if not name or (bool(ip_hjson) == bool(top_hjson)):
        print("Error: ralgen requires the \"name\" and exactly one of "
              "{\"ip_hjson\" and \"top_hjson\"} parameters to be set.")
        sys.exit(1)

    # Generate the RAL pkg.
    if ip_hjson:
        ral_spec = root_dir / ip_hjson
        cmd = util_path / "regtool.py"
        if alias_hjson:
            ral_alias = root_dir / alias_hjson
            args = [cmd, "-s", "-a", ral_alias, "-t", os.getcwd(), ral_spec]
        else:
            args = [cmd, "-s", "-t", os.getcwd(), ral_spec]
    else:
        ral_spec = root_dir / top_hjson
        cmd = util_path / "topgen.py"
        args = [cmd, "-r", "-o", os.getcwd(), "-t", ral_spec]
        if hjson_path:
            args += ["--hjson-path", root_dir / hjson_path]

    if dv_base_names:
        args += ["--dv-base-names"] + dv_base_names

    cmd_str = ' '.join([shlex.quote(str(arg)) for arg in args])
    print(f"Calling tool in ralgen.py: {cmd_str}")
    try:
        subprocess.run(args, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error: RAL pkg generation failed:\n{e}")
        sys.exit(e.returncode)

    print(f"RAL pkg for {name} written to {Path.cwd()}.")


if __name__ == '__main__':
    main()
