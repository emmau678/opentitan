# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""Audit the registers that are used with sec_mmio functions.

For context, see <https://github.com/lowRISC/opentitan/issues/18634>.

Example usage:
    ./bazelisk.sh run //util/py/scripts:audit_sec_mmio_calls

This script finds relevant C/C++ targets and builds them with a special Bazel
aspect enabled. The aspect runs bazel_aspect_tool_audit_sec_mmio_calls.py for
each compilation unit, which produces one serialized report per compilation
unit. This script scoops up those reports and merges them.

It also determines which registers are hardware-writable by reading OpenTitan's
register definitions.  Finally, it categorizes each call-site and prints a
report to stdout before exiting.

"""

import collections
import subprocess
import sys
from pathlib import Path

import rich
import typer

from util.py.packages.lib import bazel, ot_logging, run
from util.py.packages.lib.register_usage_report import (
    RegisterUsageReport, RegisterUsageReportGroup, SingleFileSourceRange)

# The modules under util.reggen use relative imports, which do not play well
# with this package's absolute imports. For instance, util.reggen.ip_block
# contains `from reggen.alert import Alert`. If we used a relative import here,
# like `from ...reggen.ip_block import IpBlock`, we would see ip_block's import
# fail like so: `ModuleNotFoundError: No module named 'reggen'`.
sys.path.append('util/')
from util.reggen.ip_block import IpBlock  # noqa: E402
from util.reggen.reg_block import RegBlock  # noqa: E402
from util.reggen.register import Register  # noqa:E402

# This Bazel query pattern selects the targets to audit. Originally, this
# pattern was "//sw/device/...", but this led to some aspect analysis errors
# related to english_breakfast targets. For the purposes of this audit, it
# should be sufficient to simply select dependencies of the ROM and ROM_EXT.
BAZEL_PATTERN = """
kind("^cc_(binary|library) rule$",
     deps("//sw/device/silicon_creator/rom:rom_with_fake_keys") union
     deps("//sw/device/silicon_creator/rom_ext:rom_ext"))
""".strip()

app = typer.Typer(pretty_exceptions_enable=False, add_completion=False)
log = ot_logging.log


class BazelTool:
    """A collection of Bazel operations that are useful for the sec_mmio audit.
    """
    def __init__(self):
        log.info("Escaping Bazel sandbox")
        bazel.try_escape_sandbox()

    def query_hjson_sources(self) -> list[Path]:
        """Find hjson files associated with autogen_hjson_header targets."""
        log.info("Querying Bazel for autogen_hjson_header srcs")
        query_lines = run.run(
            "./bazelisk.sh",
            "cquery",
            "labels(srcs, kind(autogen_hjson_header, //...))",
            "--output=starlark",
            "--starlark:expr='\\n'.join([f.path for f in target.files.to_list()])",
        )
        return [Path(line) for line in query_lines]

    def build_cc_targets_with_aspect(self):
        """Build all C/C++ targets with our custom aspect enabled.

        This produces one register usage report for each compilation unit.
        """
        log.info("Querying Bazel for CC build targets")
        targets = run.run("./bazelisk.sh", "query", BAZEL_PATTERN)
        build_command = [
            "./bazelisk.sh",
            "build",
            "--config=riscv32",
            "--aspects",
            "rules/quality.bzl%audit_sec_mmio_calls_aspect",
            "--output_groups=audit_sec_mmio",
        ] + targets
        subprocess.run(build_command, check=True)

    def get_merged_report_group(self) -> RegisterUsageReportGroup:
        """Merge all reports generated by our custom aspect."""
        report_paths = self._query_audit_report_paths()
        log.info("Processing %d audit reports", len(report_paths))

        all_reports: list[RegisterUsageReportGroup] = []
        for path in report_paths:
            if not path.exists():
                log.warning(f"Path does not exist: {path}")
                continue
            report_bytes = path.read_bytes()
            report = RegisterUsageReportGroup.deserialize(report_bytes)
            if report is None:
                continue
            all_reports.append(report)

        # Group reports by function name.
        report_group = RegisterUsageReportGroup.merge(all_reports)
        return report_group

    def _query_audit_report_paths(self) -> list[Path]:
        """Find all the reports generated by `audit_sec_mmio_calls_aspect`."""
        log.info("Querying Bazel for audit reports")
        aquery_lines = run.run(
            "./bazelisk.sh",
            "aquery",
            "--config=riscv32",
            "--aspects",
            "rules/quality.bzl%audit_sec_mmio_calls_aspect",
            "--output_groups=audit_sec_mmio",
            f"outputs('.*\\.clang-audit\\.out', {BAZEL_PATTERN})",
        )
        # Hack apart output of a Bazel action query to extract paths to reports
        # generated during the build by the "audit_sec_mmio_calls_aspect" aspect.
        report_paths = []
        for line in aquery_lines:
            columns = line.split()
            if len(columns) == 0:
                continue
            if columns[0] != "Outputs:":
                continue
            for col in columns[1:]:
                if col.startswith('['):
                    col = col[1:]
                if col.endswith(']'):
                    col = col[:-1]
                report_paths.append(Path(col))

        return report_paths


class RegisterDatabase:
    """An index of registers built by parsing `IpBlock`s from hjson files.
    """
    def __init__(self, hjson_sources: list[Path]):
        self._all_reg_names = set()
        self._hw_writable_reg_names = set()
        self._build(hjson_sources)

    def is_known_reg_token(self, token: str) -> bool:
        """Returns true iff `token` names a known register.
        """
        return token in self._all_reg_names

    def is_hw_writable_reg_token(self, token: str) -> bool:
        """Returns true iff `token` names a known register that is hw-writable.
        """
        return token in self._hw_writable_reg_names

    def _build(self, hjson_sources: list[Path]) -> tuple[set, set]:
        for hjson_path in hjson_sources:
            hjson_str = hjson_path.read_text()
            ip_block = IpBlock.from_text(hjson_str, [], hjson_path.name)
            log.info(f"Processing IpBlock from {hjson_path} ({ip_block.name})")

            for reg_block in ip_block.reg_blocks.values():
                self._process_reg_block(ip_block, reg_block)

    def _process_reg_block(self, ip_block: IpBlock, reg_block: RegBlock):
        def make_reg_name(*pieces):
            prefix = [ip_block.name.upper()]
            suffix = [str(p) for p in pieces]
            return "_".join(prefix + suffix)

        register: Register
        for register in reg_block.registers:
            for field in register.fields:
                reg_name = make_reg_name(register.name)

                self._all_reg_names.add(reg_name)

                if field.hwaccess.allows_write():
                    self._hw_writable_reg_names.add(reg_name)

        for multireg in reg_block.multiregs:
            for field in multireg.get_field_list():
                for i in range(multireg.count):
                    reg_name = make_reg_name(multireg.name, str(i))

                    self._all_reg_names.add(reg_name)

                    if field.hwaccess.allows_write():
                        self._hw_writable_reg_names.add(reg_name)

            for subreg in multireg.regs:
                reg_name = make_reg_name(subreg.name)
                self._all_reg_names.add(reg_name)

                if any([f.hwaccess.allows_write() for f in subreg.fields]):
                    self._hw_writable_reg_names.add(reg_name)

        for window in reg_block.windows:
            reg_name = make_reg_name(window.name)
            self._all_reg_names.add(reg_name)

        for write_enable_name in reg_block.wennames:
            reg_name = make_reg_name(write_enable_name)
            self._all_reg_names.add(reg_name)


def _callsite_preview(callsite: SingleFileSourceRange, keyword: str) -> str:
    preview = callsite.preview()
    preview = rich.markup.escape(preview)
    preview = preview.replace(keyword, f"[purple]{keyword}[/purple]")
    return preview


@app.command(help=__doc__)
def main(log_level: ot_logging.LogLevel = ot_logging.LogLevel.WARNING) -> None:

    ot_logging.init(log_level)
    console = rich.console.Console(highlight=False)

    bazel_tool = BazelTool()

    hjson_sources = bazel_tool.query_hjson_sources()
    register_db = RegisterDatabase(hjson_sources)

    bazel_tool.build_cc_targets_with_aspect()
    report_group = bazel_tool.get_merged_report_group()

    for function_name in sorted(report_group.reports.keys()):
        report: RegisterUsageReport = report_group.reports[function_name]

        report_lines = []
        unknown_regs: dict[
            str, set[SingleFileSourceRange]] = collections.defaultdict(set)

        for register_token in sorted(report.registers_to_callsites.keys()):
            callsites: set[
                SingleFileSourceRange] = report.registers_to_callsites[
                    register_token]

            register_token = register_token.removesuffix("_REG_OFFSET")

            if not register_db.is_known_reg_token(register_token):
                unknown_regs[register_token] |= callsites
                continue

            if register_db.is_hw_writable_reg_token(register_token):
                report_lines.append("")
                report_lines.append("Callsites where "
                                    f"[bold]{function_name}[/bold] " +
                                    "is called with hw-writable register " +
                                    f"[purple]{register_token}[/purple]:")
                report_lines.append("")

                for loc in sorted(callsites, key=lambda c: c.path):
                    report_lines.append(_callsite_preview(loc, register_token))
                    report_lines.append("")

        if len(report.unparsed_callsites) > 0:
            report_lines.append("")
            report_lines.append(
                "[bold]Callsites requiring human review:[/bold]")
            report_lines.append("")
            for loc in sorted(report.unparsed_callsites, key=lambda c: c.path):
                report_lines.append(_callsite_preview(loc, function_name))
                report_lines.append("")

        if len(unknown_regs) > 0:
            report_lines.append("")
            report_lines.append(
                "[bold]Callsites with unrecognized registers:[/bold]")
            report_lines.append("")
            for register_token in sorted(unknown_regs.keys()):
                callsites = unknown_regs[register_token]
                for loc in sorted(callsites, key=lambda c: c.path):
                    report_lines.append(_callsite_preview(loc, register_token))
                    report_lines.append("")

        report_str = "\n".join(report_lines)
        panel = rich.panel.Panel(report_str, title=function_name)
        console.print(panel)


if __name__ == "__main__":
    app()
