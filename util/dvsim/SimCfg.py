# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""
Class describing simulation configuration object
"""

import logging as log
import os
import shutil
import subprocess
import sys
from collections import OrderedDict

from Deploy import CompileSim, CovAnalyze, CovMerge, CovReport, CovUnr, RunTest
from FlowCfg import FlowCfg
from Modes import BuildModes, Modes, Regressions, RunModes, Tests
from SimResults import SimResults
from tabulate import tabulate
from testplanner.class_defs import Testplan
from testplanner.testplan_utils import parse_testplan
from utils import VERBOSE, rm_path

_MAX_TESTS_PER_BUCKET = 10


def pick_wave_format(fmts):
    '''Pick a supported wave format from a list.

    fmts is a list of formats that the chosen tool supports. Return the first
    that we think is possible (e.g. not fsdb if Verdi is not installed).

    '''
    assert fmts
    fmt = fmts[0]
    # TODO: This will not work if the EDA tools are expected to be launched
    # in a separate sandboxed environment such as Docker /  LSF. In such case,
    # Verdi may be installed in that environment, but it may not be visible in
    # the current repo environment where dvsim is invoked.
    if fmt == 'fsdb' and not shutil.which('verdi'):
        log.log(VERBOSE, "Skipping fsdb since verdi is not found in $PATH")
        return pick_wave_format(fmts[1:])

    return fmt


class SimCfg(FlowCfg):
    """Simulation configuration object

    A simulation configuration class holds key information required for building a DV
    regression framework.
    """

    flow = 'sim'

    # TODO: Find a way to set these in sim cfg instead
    ignored_wildcards = [
        "build_mode", "index", "test", "seed", "uvm_test", "uvm_test_seq",
        "cov_db_dirs", "sw_images", "sw_build_device"
    ]

    def __init__(self, flow_cfg_file, hjson_data, args, mk_config):
        # Options set from command line
        self.tool = args.tool
        self.build_opts = []
        self.build_opts.extend(args.build_opts)
        self.en_build_modes = args.build_modes.copy()
        self.run_opts = []
        self.run_opts.extend(args.run_opts)
        self.en_run_modes = []
        self.en_run_modes.extend(args.run_modes)
        self.build_unique = args.build_unique
        self.build_only = args.build_only
        self.run_only = args.run_only
        self.reseed_ovrd = args.reseed
        self.reseed_multiplier = args.reseed_multiplier
        # Waves must be of type string, since it may be used as substitution
        # variable in the HJson cfg files.
        self.waves = args.waves or 'none'
        self.max_waves = args.max_waves
        self.cov = args.cov
        self.cov_merge_previous = args.cov_merge_previous
        self.profile = args.profile or '(cfg uses profile without --profile)'
        self.xprop_off = args.xprop_off
        self.no_rerun = args.no_rerun
        self.verbosity = None  # set in _expand
        self.verbose = args.verbose
        self.dry_run = args.dry_run
        self.map_full_testplan = args.map_full_testplan

        # Set default sim modes for unpacking
        if args.gui:
            self.en_build_modes.append("gui")
        if args.waves is not None:
            self.en_build_modes.append("waves")
        if self.cov is True:
            self.en_build_modes.append("cov")
        if args.profile is not None:
            self.en_build_modes.append("profile")
        if self.xprop_off is not True:
            self.en_build_modes.append("xprop")

        # Options built from cfg_file files
        self.project = ""
        self.flow = ""
        self.flow_makefile = ""
        self.pre_build_cmds = []
        self.post_build_cmds = []
        self.build_dir = ""
        self.pre_run_cmds = []
        self.post_run_cmds = []
        self.run_dir = ""
        self.sw_build_dir = ""
        self.sw_images = []
        self.pass_patterns = []
        self.fail_patterns = []
        self.name = ""
        self.dut = ""
        self.tb = ""
        self.testplan = ""
        self.fusesoc_core = ""
        self.ral_spec = ""
        self.build_modes = []
        self.run_modes = []
        self.regressions = []
        self.supported_wave_formats = None

        # Options from tools - for building and running tests
        self.build_cmd = ""
        self.flist_gen_cmd = ""
        self.flist_gen_opts = []
        self.flist_file = ""
        self.run_cmd = ""

        # Generated data structures
        self.links = {}
        self.build_list = []
        self.run_list = []
        self.cov_merge_deploy = None
        self.cov_report_deploy = None
        self.results_summary = OrderedDict()

        super().__init__(flow_cfg_file, hjson_data, args, mk_config)

    def _expand(self):
        # Choose a wave format now. Note that this has to happen after parsing
        # the configuration format because our choice might depend on the
        # chosen tool.
        self.waves = self._resolve_waves()

        # If build_unique is set, then add current timestamp to uniquify it
        if self.build_unique:
            self.build_dir += "_" + self.timestamp

        # If the user specified a verbosity on the command line then
        # self.args.verbosity will be n, l, m, h or d. Set self.verbosity now.
        # We will actually have loaded some other verbosity level from the
        # config file, but that won't have any effect until expansion so we can
        # safely switch it out now.
        if self.args.verbosity is not None:
            self.verbosity = self.args.verbosity

        super()._expand()

        # Set the title for simulation results.
        self.results_title = self.name.upper() + " Simulation Results"

        # Stuff below only pertains to individual cfg (not primary cfg)
        # or individual selected cfgs (if select_cfgs is configured via command line)
        # TODO: find a better way to support select_cfgs
        if not self.is_primary_cfg and (not self.select_cfgs or
                                        self.name in self.select_cfgs):
            # If self.tool is None at this point, there was no --tool argument on
            # the command line, and there is no default tool set in the config
            # file. That's ok if this is a primary config (where the
            # sub-configurations can choose tools themselves), but not otherwise.
            if self.tool is None:
                log.error(
                    'Config file does not specify a default tool, '
                    'and there was no --tool argument on the command line.')
                sys.exit(1)

            # Print scratch_path at the start:
            log.info("[scratch_path]: [%s] [%s]", self.name, self.scratch_path)

            # Set directories with links for ease of debug / triage.
            self.links = {
                "D": self.scratch_path + "/" + "dispatched",
                "P": self.scratch_path + "/" + "passed",
                "F": self.scratch_path + "/" + "failed",
                "K": self.scratch_path + "/" + "killed"
            }

            # Use the default build mode for tests that do not specify it
            if not hasattr(self, "build_mode"):
                self.build_mode = 'default'

            # Create objects from raw dicts - build_modes, sim_modes, run_modes,
            # tests and regressions, only if not a primary cfg obj
            self._create_objects()

    def _resolve_waves(self):
        '''Choose and return a wave format, if waves are enabled.

        This is called after reading the config file. This method is used to
        update the value of class member 'waves', which must be of type string,
        since it is used as a substitution variable in the parsed HJson dict.
        If waves are not enabled, or if this is a primary cfg, then return
        'none'. 'tool', which must be set at this point, supports a limited
        list of wave formats (supplied with 'supported_wave_formats' key). If
        waves is set to 'default', then pick the first item on that list; else
        pick the desired format.
        '''
        if self.waves == 'none' or self.is_primary_cfg:
            return 'none'

        assert self.tool is not None

        # If the user hasn't specified a wave format (No argument supplied
        # to --waves), we need to decide on a format for them. The supported
        # list of wave formats is set in the tool's HJson configuration using
        # the `supported_wave_formats` key. If that list is not set, we use
        # 'vpd' by default and hope for the best. It that list if set, then we
        # pick the first available format for which the waveform viewer exists.
        if self.waves == 'default':
            if self.supported_wave_formats:
                return pick_wave_format(self.supported_wave_formats)
            else:
                return 'vpd'

        # If the user has specified their preferred wave format, use it. As
        # a sanity check, error out if the chosen tool doesn't support the
        # format, but only if we know about the tool. If not, we'll just assume
        # they know what they're doing.
        if self.supported_wave_formats and \
           self.waves not in self.supported_wave_formats:
            log.error('Chosen tool ({}) does not support wave format '
                      '{!r}.'.format(self.tool, self.waves))
            sys.exit(1)

        return self.waves

    # Purge the output directories. This operates on self.
    def _purge(self):
        assert self.scratch_path
        log.info("Purging scratch path %s", self.scratch_path)
        rm_path(self.scratch_path)

    def _create_objects(self):
        # Create build and run modes objects
        self.build_modes = Modes.create_modes(BuildModes, self.build_modes)
        self.run_modes = Modes.create_modes(RunModes, self.run_modes)

        # Walk through build modes enabled on the CLI and append the opts
        for en_build_mode in self.en_build_modes:
            build_mode_obj = Modes.find_mode(en_build_mode, self.build_modes)
            if build_mode_obj is not None:
                self.pre_build_cmds.extend(build_mode_obj.pre_build_cmds)
                self.post_build_cmds.extend(build_mode_obj.post_build_cmds)
                self.build_opts.extend(build_mode_obj.build_opts)
                self.pre_run_cmds.extend(build_mode_obj.pre_run_cmds)
                self.post_run_cmds.extend(build_mode_obj.post_run_cmds)
                self.run_opts.extend(build_mode_obj.run_opts)
                self.sw_images.extend(build_mode_obj.sw_images)
            else:
                log.error(
                    "Mode \"%s\" enabled on the the command line is not defined",
                    en_build_mode)
                sys.exit(1)

        # Walk through run modes enabled on the CLI and append the opts
        for en_run_mode in self.en_run_modes:
            run_mode_obj = Modes.find_mode(en_run_mode, self.run_modes)
            if run_mode_obj is not None:
                self.pre_run_cmds.extend(run_mode_obj.pre_run_cmds)
                self.post_run_cmds.extend(run_mode_obj.post_run_cmds)
                self.run_opts.extend(run_mode_obj.run_opts)
                self.sw_images.extend(run_mode_obj.sw_images)
            else:
                log.error(
                    "Mode \"%s\" enabled on the the command line is not defined",
                    en_run_mode)
                sys.exit(1)

        # Create tests from given list of items
        self.tests = Tests.create_tests(self.tests, self)

        # Regressions
        # Parse testplan if provided.
        if self.testplan != "":
            self.testplan = parse_testplan(self.testplan)
            # Extract tests in each milestone and add them as regression target.
            self.regressions.extend(self.testplan.get_milestone_regressions())
        else:
            # Create a dummy testplan with no entries.
            self.testplan = Testplan(name=self.name)

        # Create regressions
        self.regressions = Regressions.create_regressions(
            self.regressions, self, self.tests)

    def _print_list(self):
        for list_item in self.list_items:
            log.info("---- List of %s in %s ----", list_item, self.name)
            if hasattr(self, list_item):
                items = getattr(self, list_item)
                for item in items:
                    log.info(item)
            else:
                log.error("Item %s does not exist!", list_item)

    def _create_build_and_run_list(self):
        # Walk through the list of items to run and create the build and run
        # objects.
        # Allow multiple regressions to run as long as the do not enable
        # sim_modes or run_modes
        def get_overlapping_tests(tests, run_list_names):
            overlapping_tests = []
            for test in tests:
                if test.name in run_list_names:
                    overlapping_tests.append(test)
            return overlapping_tests

        def prune_items(items, marked_items):
            pruned_items = []
            for item in items:
                if item not in marked_items:
                    pruned_items.append(item)
            return pruned_items

        # Check if there are items to run
        if self.items == []:
            log.error(
                "No items provided for running this simulation / regression")
            sys.exit(1)

        items_list = self.items
        run_list_names = []
        marked_items = []
        # Process regressions first
        for regression in self.regressions:
            if regression.name in items_list:
                overlapping_tests = get_overlapping_tests(
                    regression.tests, run_list_names)
                if overlapping_tests != []:
                    log.error(
                        "Regression \"%s\" added for run contains tests that overlap with "
                        "other regressions added. This can result in conflicting "
                        "build / run_opts to be set causing unexpected results.",
                        regression.name)
                    sys.exit(1)

                self.run_list.extend(regression.tests)
                # Merge regression's build and run opts with its tests and their
                # build_modes
                regression.merge_regression_opts()
                run_list_names.extend(regression.test_names)
                marked_items.append(regression.name)
        items_list = prune_items(items_list, marked_items)

        # Process individual tests
        for test in self.tests:
            if test.name in items_list:
                overlapping_tests = get_overlapping_tests([test],
                                                          run_list_names)
                if overlapping_tests == []:
                    self.run_list.append(test)
                    run_list_names.append(test.name)
                    marked_items.append(test.name)
        items_list = prune_items(items_list, marked_items)

        # Merge the global build and run opts
        Tests.merge_global_opts(self.run_list, self.pre_build_cmds,
                                self.post_build_cmds, self.build_opts,
                                self.pre_run_cmds, self.post_run_cmds,
                                self.run_opts, self.sw_images)

        # Check if all items have been processed
        if items_list != []:
            log.error(
                "The items %s added for run were not found in \n%s!\n "
                "Use the --list switch to see a list of available "
                "tests / regressions.", items_list, self.flow_cfg_file)

        # Process reseed override and create the build_list
        build_list_names = []
        for test in self.run_list:
            # Override reseed if available.
            if self.reseed_ovrd is not None:
                test.reseed = self.reseed_ovrd

            # Apply reseed multiplier if set on the command line.
            test.reseed *= self.reseed_multiplier

            # Create the unique set of builds needed.
            if test.build_mode.name not in build_list_names:
                self.build_list.append(test.build_mode)
                build_list_names.append(test.build_mode.name)

    def _create_dirs(self):
        '''Create initial set of directories
        '''
        for link in self.links.keys():
            rm_path(self.links[link])
            os.makedirs(self.links[link])

    def _expand_run_list(self, build_map):
        '''Generate a list of tests to be run

        For each test in tests, we add it test.reseed times. The ordering is
        interleaved so that we run through all of the tests as soon as
        possible. If there are multiple tests and they have different reseed
        values, they are "fully interleaved" at the start (so if there are
        tests A, B with reseed values of 5 and 2, respectively, then the list
        will be ABABAAA).

        build_map is a dictionary mapping a build mode to a CompileSim object.
        '''
        tagged = []

        for test in self.run_list:
            build_job = build_map[test.build_mode]
            for idx in range(test.reseed):
                tagged.append((idx, RunTest(idx, test, build_job, self)))

        # Stably sort the tagged list by the 1st coordinate.
        tagged.sort(key=lambda x: x[0])

        # Return the sorted list of RunTest objects, discarding the indices by
        # which we sorted it.
        return [run for _, run in tagged]

    def _create_deploy_objects(self):
        '''Create deploy objects from the build and run lists.
        '''

        # Create the build and run list first
        self._create_build_and_run_list()

        self.builds = []
        build_map = {}
        for build_mode_obj in self.build_list:
            new_build = CompileSim(build_mode_obj, self)

            # It is possible for tests to supply different build modes, but
            # those builds may differ only under specific circumstances,
            # such as coverage being enabled. If coverage is not enabled,
            # then they may be completely identical. In that case, we can
            # save compute resources by removing the extra duplicated
            # builds. We discard the new_build if it is equivalent to an
            # existing one.
            is_unique = True
            for build in self.builds:
                if build.is_equivalent_job(new_build):
                    new_build = build
                    is_unique = False
                    break

            if is_unique:
                self.builds.append(new_build)
            build_map[build_mode_obj] = new_build

        # Update all tests to use the updated (uniquified) build modes.
        for test in self.run_list:
            if test.build_mode.name != build_map[test.build_mode].name:
                test.build_mode = Modes.find_mode(
                    build_map[test.build_mode].name, self.build_modes)

        self.runs = ([]
                     if self.build_only else self._expand_run_list(build_map))

        # In GUI mode, only allow one test to run.
        if self.gui and len(self.runs) > 1:
            self.runs = self.runs[:1]
            log.warning("In GUI mode, only one test is allowed to run. "
                        "Picking {}".format(self.runs[0].full_name))

        # Add builds to the list of things to run, only if --run-only switch
        # is not passed.
        self.deploy = []
        if not self.run_only:
            self.deploy += self.builds

        if not self.build_only:
            self.deploy += self.runs

            # Create cov_merge and cov_report objects, so long as we've got at
            # least one run to do.
            if self.cov and self.runs:
                self.cov_merge_deploy = CovMerge(self.runs, self)
                self.cov_report_deploy = CovReport(self.cov_merge_deploy, self)
                self.deploy += [self.cov_merge_deploy, self.cov_report_deploy]

        # Create initial set of directories before kicking off the regression.
        self._create_dirs()

    def _cov_analyze(self):
        '''Use the last regression coverage data to open up the GUI tool to
        analyze the coverage.
        '''
        # Create initial set of directories, such as dispatched, passed etc.
        self._create_dirs()

        cov_analyze_deploy = CovAnalyze(self)
        self.deploy = [cov_analyze_deploy]

    def cov_analyze(self):
        '''Public facing API for analyzing coverage.
        '''
        for item in self.cfgs:
            item._cov_analyze()

    def _cov_unr(self):
        '''Use the last regression coverage data to generate unreachable
        coverage exclusions.
        '''
        # TODO, Only support VCS
        if self.tool not in ['vcs', 'xcelium']:
            log.error("Only VCS and Xcelium are supported for the UNR flow.")
            sys.exit(1)
        # Create initial set of directories, such as dispatched, passed etc.
        self._create_dirs()

        cov_unr_deploy = CovUnr(self)
        self.deploy = [cov_unr_deploy]

    def cov_unr(self):
        '''Public facing API for analyzing coverage.
        '''
        for item in self.cfgs:
            item._cov_unr()

    def _gen_results(self, run_results):
        '''
        The function is called after the regression has completed. It collates the
        status of all run targets and generates a dict. It parses the testplan and
        maps the generated result to the testplan entries to generate a final table
        (list). It also prints the full list of failures for debug / triage. If cov
        is enabled, then the summary coverage report is also generated. The final
        result is in markdown format.
        '''

        def create_failure_message(test, line, context):
            message = [f"    * {test.qual_name}"]
            if line:
                message.append(
                    f"      Line {line}, in log {test.get_log_path()}<br>")
            else:
                message.append(f"      Log {test.get_log_path()}<br>")
            if context:
                message.extend([f"      {c.rstrip()}<br>" for c in context])
            message.append("")
            return message

        deployed_items = self.deploy
        results = SimResults(deployed_items, run_results)

        # Generate results table for runs.
        results_str = "## " + self.results_title + "\n"
        results_str += "### " + self.timestamp_long + "\n"
        if self.revision:
            results_str += "### " + self.revision + "\n"
        results_str += "### Branch: " + self.branch + "\n"

        # Add path to testplan, only if it has entries (i.e., its not dummy).
        if self.testplan.entries:
            if hasattr(self, "testplan_doc_path"):
                testplan = "https://{}/{}".format(self.doc_server,
                                                  self.testplan_doc_path)
            else:
                testplan = "https://{}/{}".format(self.doc_server,
                                                  self.rel_path)
                testplan = testplan.replace("/dv", "/doc/dv_plan/#testplan")

            results_str += "### [Testplan](" + testplan + ")\n"

        results_str += "### Simulator: " + self.tool.upper() + "\n\n"

        if not results.table:
            results_str += "No results to display.\n"

        else:
            # Map regr results to the testplan entries.
            results_str += self.testplan.results_table(
                test_results=results.table,
                map_full_testplan=self.map_full_testplan)
            results_str += "\n"
            self.results_summary = self.testplan.results_summary

            # Append coverage results if coverage was enabled.
            if self.cov_report_deploy is not None:
                report_status = run_results[self.cov_report_deploy]
                if report_status == "P":
                    results_str += "\n## Coverage Results\n"
                    # Link the dashboard page using "cov_report_page" value.
                    if hasattr(self, "cov_report_page"):
                        results_str += "\n### [Coverage Dashboard]"
                        if self.args.publish:
                            cov_report_page_path = "cov_report"
                        else:
                            cov_report_page_path = self.cov_report_dir
                        cov_report_page_path += "/" + self.cov_report_page
                        results_str += "({})\n\n".format(cov_report_page_path)
                    results_str += self.cov_report_deploy.cov_results
                    self.results_summary[
                        "Coverage"] = self.cov_report_deploy.cov_total
                else:
                    self.results_summary["Coverage"] = "--"

            # append link of detail result to block name
            self.results_summary["Name"] = self._get_results_page_link(
                self.results_summary["Name"])

        # Append bucketized failures for triage, sorted by descending number
        # of failures.
        if results.buckets:
            self.errors_seen = True
            by_tests = sorted(results.buckets.items(),
                              key=lambda i: len(i[1]),
                              reverse=True)
            fail_msgs = ["\n## Failure Buckets", ""]
            for bucket, tests in by_tests:
                fail_msgs.append(f"* ```{bucket}```:")
                # The tests could be sorted by ascending wall clock time.
                for count, (test, line, context) in enumerate(tests):
                    if count == _MAX_TESTS_PER_BUCKET:
                        fail_msgs.append(
                            f"    * ... {len(tests) - count} more tests.")
                        break
                    fail_msgs.extend(create_failure_message(
                        test, line, context))
            fail_msgs.append("")
            results_str += "\n".join(fail_msgs)

        self.results_md = results_str

        # Write results to the scratch area
        results_path = self.scratch_path + "/results_" + self.timestamp + ".md"
        with open(results_path, 'w') as results_file:
            results_file.write(self.results_md)

        # Return only the tables
        log.log(VERBOSE, "[results page]: [%s] [%s]", self.name, results_path)
        return results_str

    def gen_results_summary(self):

        # sim summary result has 5 columns from each SimCfg.results_summary
        header = ["Name", "Passing", "Total", "Pass Rate"]
        if self.cov_report_deploy is not None:
            header.append('Coverage')
        table = []
        colalign = ("center", ) * len(header)
        for item in self.cfgs:
            row = []
            for title in item.results_summary:
                row.append(item.results_summary[title])
            if row:
                table.append(row)
        self.results_summary_md = "## " + self.results_title + " (Summary)\n"
        self.results_summary_md += "### " + self.timestamp_long + "\n"
        if self.revision:
            self.results_summary_md += "### " + self.revision + "\n"
        self.results_summary_md += "### Branch: " + self.branch + "\n"
        if table:
            self.results_summary_md += tabulate(table,
                                                headers=header,
                                                tablefmt="pipe",
                                                colalign=colalign)
        else:
            self.results_summary_md += "\nNo results to display.\n"

        print(self.results_summary_md)
        return self.results_summary_md

    def _publish_results(self):
        '''Publish coverage results to the opentitan web server.'''
        super()._publish_results()

        if self.cov_report_deploy is not None:
            results_server_dir_url = self.results_server_dir.replace(
                self.results_server_prefix, self.results_server_url_prefix)

            log.info("Publishing coverage results to %s",
                     results_server_dir_url)
            cmd = (self.results_server_cmd + " -m cp -R " +
                   self.cov_report_dir + " " + self.results_server_dir)
            try:
                cmd_output = subprocess.run(args=cmd,
                                            shell=True,
                                            stdout=subprocess.PIPE,
                                            stderr=subprocess.STDOUT)
                log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
            except Exception as e:
                log.error("%s: Failed to publish results:\n\"%s\"", e,
                          str(cmd))
