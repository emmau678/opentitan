#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""make_new_dif.py is a script for instantiating templates needed to begin
development on a new DIF.

To instantiate the files for a new IP named ip_ctrl, run the command:

$ util/make_new_dif.py --ip-name-snake "ip_ctrl" --ip-name-long "IP Controller"

where "IP Controller" is a documentation-friendly name for the IP.
For example, compare "pwrmgr" and "Power Manager".

It will instantiate:
- `sw/device/lib/dif/dif_template.h.tpl` as the DIF Header boilerplate
  (into `dif_<ip>.h`), which should be manually edited/enhanced.
- `sw/device/lib/dif/templates/dif_autogen.h.tpl` as the autogenerated DIF
  Header (into `dif_<ip>_autogen.h`).
- `sw/device/lib/dif/templates/dif_autogen.c.tpl` as the autogenerated DIF
  implementation (into `dif_<ip>_autogen.c`).
- `sw/device/lib/dif/templates/dif_autogen_unittest.cc.tpl` as the
  autogenerated DIF unit tests (into `dif_<ip>_autogen_unittest.cc`).
- `doc/project/sw_checklist.md.tpl` as the DIF Checklist (into dif_<ip>.md),
  which should be manually edited.

See both templates for more information.

You can also use the `--only=header`, `--only=autogen`, `--only=checklist` to
instantiate a subset of the templates. This can be passed multiple times, and
including `--only=all` will instantiate every template.

Note: the non-autogenerated files will still need some cleaning up before they
can be used.
"""

import argparse
import glob
import logging
import shutil
import subprocess
import sys
from pathlib import Path

import hjson
from mako.template import Template

import topgen.lib as lib
from autogen_banner import get_autogen_banner
from make_new_dif.ip import Ip

# This file is $REPO_TOP/util/make_new_dif.py, so it takes two parent()
# calls to get back to the top.
REPO_TOP = Path(__file__).resolve().parent.parent

ALL_PARTS = ["header", "checklist", "autogen"]


def main():
    dif_dir = REPO_TOP / "sw/device/lib/dif"
    autogen_dif_dir = dif_dir / "autogen"

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--mode",
        "-m",
        choices=["new", "regen"],
        default="new",
        required=True,
        help="mode to generate DIF code. Use 'new' if no DIF code exists."
        "Use 'rege' to regenerate all auto-generated DIFs for all IPs.")
    parser.add_argument("--topcfg", "-t", help="path of the top hjson file.")
    parser.add_argument("--ip-name-snake",
                        "-i",
                        help="the short name of the IP, in snake_case.")
    parser.add_argument("--ip-name-long",
                        "-l",
                        help="the documentation-friendly name of the IP.")
    parser.add_argument("--only",
                        choices=ALL_PARTS,
                        default=[],
                        action="append",
                        help="only create some files; defaults to all.")
    args = parser.parse_args()

    # Parse CMD line args.
    ips = []

    # hjson path
    topcfg_path = REPO_TOP / "hw/top_earlgrey/data/top_earlgrey.hjson"
    if args.topcfg:
        topcfg_path = args.topcfg

    try:
        with open(topcfg_path, 'r') as ftop:
            topcfg = hjson.load(ftop, use_decimal=True)
    except FileNotFoundError:
        print(f"hjson {topcfg_path} could not be found")
        sys.exit(1)

    templated_modules = lib.get_templated_modules(topcfg)
    ipgen_modules = lib.get_ipgen_modules(topcfg)
    print(f"modules {templated_modules} {ipgen_modules}")

    # Check for regeneration mode (used in CI check:
    # ci/scripts/check-generated.sh)
    if args.mode == "regen":
        if len(args.only) != 1 or args.only[0] != "autogen":
            raise RuntimeError(
                "can only regenerate DIF code that is auto-generated.")
        # Create list of IPs to re-generate DIF code for.
        for autogen_src_filename in glob.iglob(
                str(REPO_TOP / "sw/device/lib/dif/autogen/*.c")):
            # NOTE: the line below takes as input a file path
            # (/path/to/dif_uart_autogen.c) and returns the IP name in lower
            # case snake mode (i.e., uart).
            ip_name_snake = Path(autogen_src_filename).stem[4:-8]
            # NOTE: ip.name_long_* not needed for auto-generated files which
            # are the only files (re-)generated in regen mode.
            ips.append(
                Ip(ip_name_snake, "AUTOGEN", templated_modules, ipgen_modules))
    else:
        assert args.ip_name_snake and args.ip_name_long, \
            "ERROR: pass --ip-name-snake and --ip-name-long when --mode=new."
        ips.append(
            Ip(args.ip_name_snake, args.ip_name_long, templated_modules,
               ipgen_modules))

    # Default to generating all parts.
    if len(args.only) == 0:
        args.only += ALL_PARTS

    # Create output directories if needed.
    if len(args.only) > 0:
        dif_dir.mkdir(exist_ok=True)
        autogen_dif_dir.mkdir(exist_ok=True)

    for ip in ips:
        if "header" in args.only:
            header_template_file = (
                REPO_TOP / "util/make_new_dif/templates/dif_template.h.tpl")
            header_out_file = dif_dir / "dif_{}.h".format(ip.name_snake)
            if header_out_file.is_file():
                raise FileExistsError(
                    "DIF header already exists for the IP. To overwrite, "
                    "delete existing header and try again.")
            header_template = Template(header_template_file.read_text())
            header_out_file.write_text(header_template.render(ip=ip))
            print("DIF header successfully written to {}.".format(
                str(header_out_file)))

        if "autogen" in args.only:
            # Render all templates
            for filetype in [".h", ".c", "_unittest.cc"]:
                # Build input/output file names.
                template_file = (
                    REPO_TOP /
                    f"util/make_new_dif/templates/dif_autogen{filetype}.tpl")
                out_file = (autogen_dif_dir /
                            f"dif_{ip.name_snake}_autogen{filetype}")

                # Read in template.
                template = Template(template_file.read_text(),
                                    strict_undefined=True)

                # Generate output file.
                out_file.write_text(
                    template.render(
                        ip=ip,
                        autogen_banner=get_autogen_banner(
                            "util/make_new_dif.py --mode=regen --only=autogen",
                            "//")))

                # Format autogenerated file with clang-format.
                assert (shutil.which("clang-format") and
                        "ERROR: clang-format must be installed to format "
                        " autogenerated code to pass OpenTitan CI checks.")
                try:
                    subprocess.check_call(["clang-format", "-i", out_file])
                except subprocess.CalledProcessError:
                    logging.error(
                        f"failed to format {out_file} with clang-format.")
                    sys.exit(1)

                print("Autogenerated DIF successfully written to {}.".format(
                    out_file))

        if "checklist" in args.only:
            checklist_template_file = REPO_TOP / "doc/project/sw_checklist.md.tpl"
            checklist_out_file = dif_dir / "dif_{}.md".format(ip.name_snake)
            if checklist_out_file.is_file():
                raise FileExistsError(
                    "DIF checklist already exists for the IP. To "
                    "overwrite, delete existing checklist and try again.")
            markdown_template = Template(checklist_template_file.read_text())
            checklist_out_file.write_text(markdown_template.render(ip=ip))
            print("DIF Checklist successfully written to {}.".format(
                str(checklist_out_file)))


if __name__ == "__main__":
    main()
