#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""make_new_dif.py is a script for instantiating templates needed to begin
development on a new DIF.

To instantiate the files for a new IP named my_ip, run the command
$ util/make_new_dif.py --ip my_ip --peripheral "my peripheral"
where "my peripheral" is a documentation-friendly name for your peripheral.
Compare "pwrmgr" and "power manager".

It will instantiate:
- `sw/device/lib/dif/dif_template.h.tpl` as the DIF Header (into dif_<ip>.h).
- `sw/device/lib/dif/templates/dif_autogen.h.tpl` as the autogenerated DIF
   Header (into dif_<ip>_autogen.h).
- `doc/project/sw_checklist.md.tpl` as the DIF Checklist (into dif_<ip>.md).

See both templates for more information.

You can also use the `--only=header`, `--only=autogen`, `--only=checklist` to
instantiate a subset of the templates. This can be passed multiple times, and
including `--only=all` will instantiate every template.

Note: the non-autogenerated files will still need some cleaning up before they
can be used.
"""

import argparse
import logging
import shutil
import subprocess
import sys
from collections import OrderedDict
from pathlib import Path

import hjson
from mako.template import Template

# This file is $REPO_TOP/util/make_new_dif.py, so it takes two parent()
# calls to get back to the top.
REPO_TOP = Path(__file__).resolve().parent.parent

ALL_PARTS = ["header", "checklist", "autogen"]


class Irq:
    """Holds IRQ information for populating DIF code templates.

    Attributes:
        name_snake (str): IRQ short name in lower snake case.
        name_upper (str): IRQ short name in upper snake case.
        name_camel (str): IRQ short name in camel case.
        description (str): full description of the IRQ.

    """
    def __init__(self, irq: OrderedDict) -> None:
        self.name_snake = irq["name"]
        self.name_upper = self.name_snake.upper()
        self.name_camel = "".join(
            [word.capitalize() for word in self.name_snake.split("_")])
        _multiline_description = irq["desc"][0].upper() + irq["desc"][1:]
        self.description = _multiline_description.replace("\n", " ")


class Ip:
    """Holds all IP metadata mined from an IP's name and HJSON file.

    Attributes:
        name_snake (str): IP short name in lower snake case.
        name_upper (str): IP short name in upper snake case.
        name_camel (str): IP short name in camel case.
        name_long_lower (str): IP full name in lower case.
        name_long_upper (str): IP full name with first letter capitalized.
        hjson_data (OrderedDict): IP metadata from hw/ip/<ip>/data/<ip>.hjson.
        irqs (List[Irq]): List of Irq objects constructed from hjson_data.

    """
    def __init__(self, name_snake: str, name_long_lower: str) -> None:
        """Mines metadata to populate this Ip object.

        Args:
            name_snake: IP short name in lower snake case (e.g., pwrmgr).
            name_long_lower: IP full name in lower case (e.g., power manager).
        """
        # Generate various IP name formats.
        self.name_snake = name_snake
        self.name_upper = self.name_snake.upper()
        self.name_camel = "".join(
            [word.capitalize() for word in self.name_snake.split("_")])
        self.name_long_lower = name_long_lower
        # We just want to set the first character to title case. In particular,
        # .capitalize() does not do the right thing, since it would convert
        # UART to Uart.
        self.name_long_upper = self.name_long_lower[0].upper(
        ) + self.name_long_lower[1:]
        # Load HJSON data.
        _hjson_file = REPO_TOP / "hw/ip/{0}/data/{0}.hjson".format(
            self.name_snake)
        with _hjson_file.open("r") as f:
            _hjson_str = f.read()
        self.hjson_data = hjson.loads(_hjson_str)
        # Load IRQ data from HJSON.
        self.irqs = self._load_irqs()

    def _load_irqs(self):
        assert (self.hjson_data and
                "ERROR: must load IP HJSON before loarding IRQs")
        irqs = []
        for irq in self.hjson_data["interrupt_list"]:
            irqs.append(Irq(irq))
        return irqs


def main():
    dif_dir = REPO_TOP / "sw/device/lib/dif"
    autogen_dif_dir = dif_dir / "autogen"

    parser = argparse.ArgumentParser()
    parser.add_argument("--ip",
                        "-i",
                        required=True,
                        help="the short name of the IP, in snake_case")
    parser.add_argument("--peripheral",
                        "-p",
                        required=True,
                        help="the documentation-friendly name of the IP")
    parser.add_argument("--only",
                        choices=ALL_PARTS,
                        default=[],
                        action="append",
                        help="only create some files; defaults to all.")
    args = parser.parse_args()

    # Parse CMD line args.
    ip = Ip(args.ip, args.peripheral)
    # Default to generating all parts.
    if len(args.only) == 0:
        args.only += ALL_PARTS

    # Create output directories if needed.
    if len(args.only) > 0:
        dif_dir.mkdir(exist_ok=True)
        autogen_dif_dir.mkdir(exist_ok=True)

    if "header" in args.only:
        header_template_file = (REPO_TOP /
                                "util/make_new_dif/dif_template.h.tpl")

        with header_template_file.open("r") as f:
            header_template = Template(f.read())

        header_out_file = dif_dir / "dif_{}.h".format(ip.name_snake)
        with header_out_file.open("w") as f:
            f.write(header_template.render(ip=ip))

        print("DIF header successfully written to {}.".format(
            str(header_out_file)))

    if "autogen" in args.only:
        # Render all templates
        for filetype in ["inc", "c", "unittest"]:
            assert (ip.irqs and "ERROR: this IP generates no interrupts.")
            # Build input/output file names.
            if filetype == "unittest":
                template_file = (
                    REPO_TOP /
                    f"util/make_new_dif/dif_autogen_{filetype}.cc.tpl")
                out_file = (autogen_dif_dir /
                            f"dif_{ip.name_snake}_autogen_unittest.cc")
            else:
                template_file = (
                    REPO_TOP / f"util/make_new_dif/dif_autogen.{filetype}.tpl")
                out_file = (autogen_dif_dir /
                            f"dif_{ip.name_snake}_autogen.{filetype}")

            # Read in template.
            with template_file.open("r") as f:
                template = Template(f.read())

            # Generate output file.
            with out_file.open("w") as f:
                f.write(template.render(
                    ip=ip,
                    irqs=ip.irqs,
                ))

            # Format autogenerated file with clang-format.
            assert (
                shutil.which("clang-format") and
                "ERROR: clang-format must be installed to format autogenerated"
                " code to pass OpenTitan CI checks.")
            try:
                subprocess.check_call(["clang-format", "-i", out_file])
            except subprocess.CalledProcessError:
                logging.error(
                    f"""failed to format {out_file} with clang-format.""")
                sys.exit(1)

            print("Autogenerated DIF successfully written to {}.".format(
                out_file))

    if "checklist" in args.only:
        checklist_template_file = REPO_TOP / "doc/project/sw_checklist.md.tpl"

        with checklist_template_file.open("r") as f:
            markdown_template = Template(f.read())

        checklist_out_file = dif_dir / "dif_{}.md".format(ip.name_snake)
        with checklist_out_file.open("w") as f:
            f.write(markdown_template.render(ip=ip))

        print("DIF Checklist successfully written to {}.".format(
            str(checklist_out_file)))


if __name__ == "__main__":
    main()
