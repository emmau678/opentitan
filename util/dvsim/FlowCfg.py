# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import json
import logging as log
import os
import pprint
import re
import subprocess
import sys
from pathlib import Path
from shutil import which

import hjson
from results_server import NoGCPError, ResultsServer
from CfgJson import set_target_attribute
from LauncherFactory import get_launcher_cls
from Scheduler import Scheduler
from utils import (VERBOSE, clean_odirs, find_and_substitute_wildcards,
                   md_results_to_html, mk_path, rm_path, subst_wildcards)


# Interface class for extensions.
class FlowCfg():
    '''Base class for the different flows supported by dvsim.py

    The constructor expects some parsed hjson data. Create these objects with
    the factory function in CfgFactory.py, which loads the hjson data and picks
    a subclass of FlowCfg based on its contents.
    '''

    # Set in subclasses. This is the key that must be used in an hjson file to
    # tell dvsim.py which subclass to use.
    flow = None

    # Can be overridden in subclasses to configure which wildcards to ignore
    # when expanding hjson.
    ignored_wildcards = []

    def __str__(self):
        return pprint.pformat(self.__dict__)

    def __init__(self, flow_cfg_file, hjson_data, args, mk_config):
        # Options set from command line
        # Uniquify input items, while preserving the order.
        self.items = list(dict.fromkeys(args.items))
        self.list_items = args.list
        self.select_cfgs = args.select_cfgs
        self.flow_cfg_file = flow_cfg_file
        self.args = args
        self.scratch_root = args.scratch_root
        self.branch = args.branch
        self.job_prefix = args.job_prefix
        self.gui = args.gui

        self.interactive = args.interactive

        # Options set from hjson cfg.
        self.project = ""
        self.scratch_path = ""
        self.scratch_base_path = ""

        # Add exports using 'exports' keyword - these are exported to the child
        # process' environment.
        self.exports = []

        # Add overrides using the overrides keyword - existing attributes
        # are overridden with the override values.
        self.overrides = []

        # List of cfgs if the parsed cfg is a primary cfg list
        self.cfgs = []

        # Add a notion of "primary" cfg - this is indicated using
        # a special key 'use_cfgs' within the hjson cfg.
        self.is_primary_cfg = False

        # For a primary cfg, it is the aggregated list of all deploy objects
        # under self.cfgs. For a non-primary cfg, it is the list of items
        # slated for dispatch.
        self.deploy = []

        # Timestamp
        self.timestamp_long = args.timestamp_long
        self.timestamp = args.timestamp

        # Results
        self.errors_seen = False
        self.rel_path = ""
        self.results_title = ""
        self.revision = ""
        self.results_server_prefix = ""
        self.results_server_cmd = ""
        self.css_file = os.path.join(
            os.path.dirname(os.path.realpath(__file__)), "style.css")
        # `self.results_*` below will be updated after `self.rel_path` and
        # `self.scratch_base_root` variables are updated.
        self.results_dir = ""
        self.results_page = ""
        self.results_server_path = ""
        self.results_server_dir = ""
        self.results_server_page = ""
        self.results_server_url = ""
        self.results_html_name = ""

        # Full results in md text
        self.results_md = ""
        # Selectively sanitized md results to be published
        self.publish_results_md = ""
        self.sanitize_publish_results = False
        # Summary results, generated by over-arching cfg
        self.results_summary_md = ""

        # Merge in the values from the loaded hjson file. If subclasses want to
        # add other default parameters that depend on the parameters above,
        # they can override _merge_hjson and add their parameters at the start
        # of that.
        self._merge_hjson(hjson_data)

        # Is this a primary config? If so, we need to load up all the child
        # configurations at this point. If not, we place ourselves into
        # self.cfgs and consider ourselves a sort of "degenerate primary
        # configuration".
        self.is_primary_cfg = 'use_cfgs' in hjson_data

        if not self.is_primary_cfg:
            self.cfgs.append(self)
        else:
            for entry in self.use_cfgs:
                self._load_child_cfg(entry, mk_config)

        if self.rel_path == "":
            self.rel_path = os.path.dirname(self.flow_cfg_file).replace(
                self.proj_root + '/', '')

        # Process overrides before substituting wildcards
        self._process_overrides()

        # Expand wildcards. If subclasses need to mess around with parameters
        # after merging the hjson but before expansion, they can override
        # _expand and add the code at the start.
        self._expand()

        # Construct the path variables after variable expansion.
        self.results_dir = (Path(self.scratch_base_path) / "reports" /
                            self.rel_path / "latest")
        self.results_page = (self.results_dir / self.results_html_name)

        tmp_path = self.results_server + "/" + self.rel_path
        self.results_server_path = self.results_server_prefix + tmp_path
        tmp_path += "/latest"
        self.results_server_dir = self.results_server_prefix + tmp_path
        tmp_path += "/" + self.results_html_name
        self.results_server_page = self.results_server_prefix + tmp_path
        self.results_server_url = "https://" + tmp_path

        # Run any final checks
        self._post_init()

    def _merge_hjson(self, hjson_data):
        '''Take hjson data and merge it into self.__dict__

        Subclasses that need to do something just before the merge should
        override this method and call super()._merge_hjson(..) at the end.

        '''
        for key, value in hjson_data.items():
            set_target_attribute(self.flow_cfg_file, self.__dict__, key, value)

    def _expand(self):
        '''Called to expand wildcards after merging hjson

        Subclasses can override this to do something just before expansion.

        '''
        # If this is a primary configuration, it doesn't matter if we don't
        # manage to expand everything.
        partial = self.is_primary_cfg

        # If custom dump script is exist, replace with run_script attribute.
        if self.args.dump_script is not None:
            self.run_script = '{proj_root}/' + self.args.dump_script

        self.__dict__ = find_and_substitute_wildcards(self.__dict__,
                                                      self.__dict__,
                                                      self.ignored_wildcards,
                                                      ignore_error=partial)

    def _post_init(self):
        # Run some post init checks
        if not self.is_primary_cfg:
            # Check if self.cfgs is a list of exactly 1 item (self)
            if not (len(self.cfgs) == 1 and self.cfgs[0].name == self.name):
                log.error("Parse error!\n%s", self.cfgs)
                sys.exit(1)

    def create_instance(self, mk_config, flow_cfg_file):
        '''Create a new instance of this class for the given config file.

        mk_config is a factory method (passed explicitly to avoid a circular
        dependency between this file and CfgFactory.py).

        '''
        new_instance = mk_config(flow_cfg_file)

        # Sanity check to make sure the new object is the same class as us: we
        # don't yet support heterogeneous primary configurations.
        if type(self) is not type(new_instance):
            log.error("{}: Loading child configuration at {!r}, but the "
                      "resulting flow types don't match: ({} vs. {}).".format(
                          self.flow_cfg_file, flow_cfg_file,
                          type(self).__name__,
                          type(new_instance).__name__))
            sys.exit(1)

        return new_instance

    def _load_child_cfg(self, entry, mk_config):
        '''Load a child configuration for a primary cfg'''
        if type(entry) is str:
            # Treat this as a file entry. Substitute wildcards in cfg_file
            # files since we need to process them right away.
            cfg_file = subst_wildcards(entry, self.__dict__, ignore_error=True)
            self.cfgs.append(self.create_instance(mk_config, cfg_file))

        elif type(entry) is dict:
            # Treat this as a cfg expanded in-line
            temp_cfg_file = self._conv_inline_cfg_to_hjson(entry)
            if not temp_cfg_file:
                return
            self.cfgs.append(self.create_instance(mk_config, temp_cfg_file))

            # Delete the temp_cfg_file once the instance is created
            log.log(VERBOSE, "Deleting temp cfg file:\n%s", temp_cfg_file)
            rm_path(temp_cfg_file, ignore_error=True)

        else:
            log.error(
                "Type of entry \"%s\" in the \"use_cfgs\" key is invalid: %s",
                entry, str(type(entry)))
            sys.exit(1)

    def _conv_inline_cfg_to_hjson(self, idict):
        '''Dump a temp hjson file in the scratch space from input dict.
        This method is to be called only by a primary cfg'''

        if not self.is_primary_cfg:
            log.fatal("This method can only be called by a primary cfg")
            sys.exit(1)

        name = idict["name"] if "name" in idict.keys() else None
        if not name:
            log.error("In-line entry in use_cfgs list does not contain a "
                      "\"name\" key (will be skipped!):\n%s", idict)
            return None

        # Check if temp cfg file already exists
        temp_cfg_file = (self.scratch_root + "/." + self.branch + "__" + name +
                         "_cfg.hjson")

        # Create the file and dump the dict as hjson
        log.log(VERBOSE, "Dumping inline cfg \"%s\" in hjson to:\n%s", name,
                temp_cfg_file)
        try:
            with open(temp_cfg_file, "w") as f:
                f.write(hjson.dumps(idict, for_json=True))
        except Exception as e:
            log.error("Failed to hjson-dump temp cfg file\"%s\" for \"%s\""
                      "(will be skipped!) due to:\n%s", temp_cfg_file, name, e)
            return None

        # Return the temp cfg file created
        return temp_cfg_file

    def _process_overrides(self):
        # Look through the dict and find available overrides.
        # If override is available, check if the type of the value for existing
        # and the overridden keys are the same.
        overrides_dict = {}
        if hasattr(self, "overrides"):
            overrides = getattr(self, "overrides")
            if type(overrides) is not list:
                log.error("The type of key \"overrides\" is %s - it should be "
                          "a list", type(overrides))
                sys.exit(1)

            # Process override one by one
            for item in overrides:
                if type(item) is dict and set(
                        item.keys()) == {"name", "value"}:
                    ov_name = item["name"]
                    ov_value = item["value"]
                    if ov_name not in overrides_dict.keys():
                        overrides_dict[ov_name] = ov_value
                        self._do_override(ov_name, ov_value)
                    else:
                        log.error("Override for key \"%s\" already exists!\n"
                                  "Old: %s\nNew: %s", ov_name,
                                  overrides_dict[ov_name], ov_value)
                        sys.exit(1)
                else:
                    log.error("\"overrides\" is a list of dicts with "
                              "{\"name\": <name>, \"value\": <value>} pairs. "
                              "Found this instead:\n%s", str(item))
                    sys.exit(1)

    def _do_override(self, ov_name, ov_value):
        # Go through self attributes and replace with overrides
        if hasattr(self, ov_name):
            orig_value = getattr(self, ov_name)
            if type(orig_value) == type(ov_value):
                log.debug("Overriding \"%s\" value \"%s\" with \"%s\"",
                          ov_name, orig_value, ov_value)
                setattr(self, ov_name, ov_value)
            else:
                log.error("The type of override value \"%s\" for \"%s\" "
                          "mismatches the type of original value \"%s\"",
                          ov_value, ov_name, orig_value)
                sys.exit(1)
        else:
            log.error("Override key \"%s\" not found in the cfg!", ov_name)
            sys.exit(1)

    def _purge(self):
        '''Purge the existing scratch areas in preperation for the new run.'''
        return

    def purge(self):
        '''Public facing API for _purge().'''
        for item in self.cfgs:
            item._purge()

    def _print_list(self):
        '''Print the list of available items that can be kicked off.'''
        return

    def print_list(self):
        '''Public facing API for _print_list().'''

        for item in self.cfgs:
            item._print_list()

    def prune_selected_cfgs(self):
        '''Prune the list of configs for a primary config file.'''

        # This should run after self.cfgs has been set
        assert self.cfgs

        # If the user didn't pass --select-cfgs, we don't do anything.
        if self.select_cfgs is None:
            return

        # If the user passed --select-cfgs, but this isn't a primary config
        # file, we should probably complain.
        if not self.is_primary_cfg:
            log.error('The configuration file at {!r} is not a primary '
                      'config, but --select-cfgs was passed on the command '
                      'line.'.format(self.flow_cfg_file))
            sys.exit(1)

        # Filter configurations
        self.cfgs = [c for c in self.cfgs if c.name in self.select_cfgs]

    def _create_deploy_objects(self):
        '''Create deploy objects from items that were passed on for being run.
        The deploy objects for build and run are created from the objects that
        were created from the create_objects() method.
        '''
        return

    def create_deploy_objects(self):
        '''Public facing API for _create_deploy_objects().
        '''
        self.prune_selected_cfgs()

        # GUI or Interactive mode is allowed only for one cfg.
        if (self.gui or self.interactive) and len(self.cfgs) > 1:
            log.fatal("In GUI mode, only one cfg can be run.")
            sys.exit(1)

        for item in self.cfgs:
            item._create_deploy_objects()

    def deploy_objects(self):
        '''Public facing API for deploying all available objects.

        Runs each job and returns a map from item to status.
        '''
        deploy = []
        for item in self.cfgs:
            deploy.extend(item.deploy)

        if not deploy:
            log.error("Nothing to run!")
            sys.exit(1)

        return Scheduler(deploy, get_launcher_cls(), self.interactive).run()

    def _gen_results(self, results):
        '''
        The function is called after the flow has completed. It collates
        the status of all run targets and generates a dict. It parses the log
        to identify the errors, warnings and failures as applicable. It also
        prints the full list of failures for debug / triage to the final
        report, which is in markdown format.

        results should be a dictionary mapping deployed item to result.
        '''
        return

    def gen_results(self, results):
        '''Public facing API for _gen_results().

        results should be a dictionary mapping deployed item to result.

        '''
        for item in self.cfgs:
            json_str = (item._gen_json_results(results)
                        if hasattr(item, '_gen_json_results')
                        else None)
            result = item._gen_results(results)
            log.info("[results]: [%s]:\n%s\n", item.name, result)
            log.info("[scratch_path]: [%s] [%s]", item.name, item.scratch_path)
            item.write_results(self.results_html_name, item.results_md,
                               json_str)
            log.log(VERBOSE, "[report]: [%s] [%s/report.html]", item.name,
                    item.results_dir)
            self.errors_seen |= item.errors_seen

        if self.is_primary_cfg:
            self.gen_results_summary()
            self.write_results(self.results_html_name,
                               self.results_summary_md)

    def gen_results_summary(self):
        '''Public facing API to generate summary results for each IP/cfg file
        '''
        return

    def write_results(self, html_filename, text_md, json_str=None):
        """Write results to files.

        This function converts text_md to HTML and writes the result to a file
        in self.results_dir with the file name given by html_filename.  If
        json_str is not None, this function additionally writes json_str to a
        file with the same path and base name as the HTML file but with '.json'
        as suffix.
        """

        # Prepare reports directory, keeping 90 day history.
        clean_odirs(odir=self.results_dir, max_odirs=89)
        mk_path(self.results_dir)

        # Write results to the report area.
        with open(self.results_dir / html_filename, "w") as f:
            f.write(
                md_results_to_html(self.results_title, self.css_file, text_md))

        if json_str is not None:
            filename = Path(html_filename).with_suffix('.json')
            with open(self.results_dir / filename, "w") as f:
                f.write(json_str)

    def _get_results_page_link(self, relative_to, link_text=''):
        """Create a relative markdown link to the results page."""

        link_text = self.name.upper() if not link_text else link_text
        relative_link = os.path.relpath(self.results_page,
                                        relative_to)
        return "[%s](%s)" % (link_text, relative_link)

    def _publish_results(self, results_server: ResultsServer):
        '''Publish results to the opentitan web server.

        Results are uploaded to {results_server_page}.
        If the 'latest' directory exists, then it is renamed to its 'timestamp'
        directory. If the list of directories in this area is > 14, then the
        oldest entry is removed. Links to the last 7 regression results are
        appended at the end if the results page.
        '''
        # Timeformat for moving the dir
        tf = "%Y.%m.%d_%H.%M.%S"

        # We're going to try to put things in a directory called "latest". But
        # there's probably something with that name already. If so, we want to
        # move the thing that's there already to be at a path based on its
        # creation time.

        # Try to get the creation time of any existing "latest/report.html"
        latest_dir = '{}/latest'.format(self.rel_path)
        latest_report_path = '{}/report.html'.format(latest_dir)
        old_results_time = results_server.get_creation_time(latest_report_path)

        if old_results_time is not None:
            # If there is indeed a creation time, we will need to move the
            # "latest" directory to a path based on that time.
            old_results_ts = old_results_time.strftime(tf)
            backup_dir = '{}/{}'.format(self.rel_path, old_results_ts)

            results_server.mv(latest_dir, backup_dir)

        # Do an ls in the results root dir to check what directories exist.
        results_dirs = []
        cmd = self.results_server_cmd + " ls " + self.results_server_path
        log.log(VERBOSE, cmd)
        cmd_output = subprocess.run(args=cmd,
                                    shell=True,
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.DEVNULL)
        log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        if cmd_output.returncode == 0:
            # Some directories exist. Check if 'latest' is one of them
            results_dirs = cmd_output.stdout.decode("utf-8").strip()
            results_dirs = results_dirs.split("\n")
        else:
            log.log(VERBOSE, "Failed to run \"%s\"!", cmd)

        # Start pruning
        log.log(VERBOSE, "Pruning %s area to limit last 7 results",
                self.results_server_path)

        rdirs = []
        for rdir in results_dirs:
            dirname = rdir.replace(self.results_server_path, '')
            dirname = dirname.replace('/', '')
            # Only track history directories with format
            # "year.month.date_hour.min.sec".
            if not bool(re.match(r"[\d*.]*_[\d*.]*", dirname)):
                continue
            rdirs.append(dirname)
        rdirs.sort(reverse=True)

        rm_cmd = ""
        history_txt = "\n## Past Results\n"
        history_txt += "- [Latest](../latest/" + self.results_html_name + ")\n"
        if len(rdirs) > 0:
            for i in range(len(rdirs)):
                if i < 7:
                    rdir_url = '../' + rdirs[i] + "/" + self.results_html_name
                    history_txt += "- [{}]({})\n".format(rdirs[i], rdir_url)
                elif i > 14:
                    rm_cmd += self.results_server_path + '/' + rdirs[i] + " "

        if rm_cmd != "":
            rm_cmd = self.results_server_cmd + " -m rm -r " + rm_cmd + "; "

        # Append the history to the results.
        publish_results_md = self.publish_results_md or self.results_md
        publish_results_md = publish_results_md + history_txt

        # Publish the results page.
        # First, write the results html and json files to the scratch area.
        json_str = (json.dumps(self.results_dict)
                    if hasattr(self, 'results_dict')
                    else None)
        self.write_results("publish.html", publish_results_md, json_str)
        results_html_file = self.results_dir / "publish.html"

        # Second, copy the files to the server.
        log.info("Publishing results to %s", self.results_server_url)
        suffixes = ['html'] + (['json'] if json_str is not None else [])
        for suffix in suffixes:
            src = str(Path(results_html_file).with_suffix('.' + suffix))
            dst = self.results_server_page
            # results_server_page has '.html' as suffix.  If that does not match
            # suffix, change it.
            if suffix != 'html':
                assert dst[-5:] == '.html'
                dst = dst[:-5] + '.json'
            cmd = f"{self.results_server_cmd} cp {src} {dst}"
            log.log(VERBOSE, cmd)
            try:
                cmd_output = subprocess.run(args=cmd,
                                            shell=True,
                                            stdout=subprocess.PIPE,
                                            stderr=subprocess.STDOUT)
                log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
            except Exception as e:
                log.error("%s: Failed to publish results:\n\"%s\"", e, str(cmd))

    def publish_results(self):
        """Publish these results to the opentitan web server."""
        try:
            server_handle = ResultsServer(self.results_server)
        except NoGCPError:
            # We failed to create a results server object at all, so we're not going to be able
            # to publish any results right now.
            log.error("Google Cloud SDK not installed. Cannot access the "
                      "results server")
            return

        for item in self.cfgs:
            item._publish_results(server_handle)

        if self.is_primary_cfg:
            self.publish_results_summary()

        # Trigger a rebuild of the site/docs which may pull new data from
        # the published results.
        self.rebuild_site()

    def publish_results_summary(self):
        '''Public facing API for publishing md format results to the opentitan
        web server.
        '''
        # Publish the results page.
        log.info("Publishing results summary to %s", self.results_server_url)
        cmd = (self.results_server_cmd + " cp " +
               str(self.results_page) + " " +
               self.results_server_page)
        log.log(VERBOSE, cmd)
        try:
            cmd_output = subprocess.run(args=cmd,
                                        shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT)
            log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        except Exception as e:
            log.error("%s: Failed to publish results:\n\"%s\"", e, str(cmd))

    def rebuild_site(self):
        '''Trigger a rebuild of the opentitan.org site using a Cloud Build trigger.

        The Gcloud project which builds and deploys the site ("gold-hybrid-255131") uses
        a cloudbuild yaml file (util/site/site-builder/cloudbuild-deploy-docs.yaml) to define
        the rebuilding of the site.
        A manually-triggered job ('site-builder-manual') has been created, which can be
        triggered through an appropriately-authenticated Google Cloud SDK command. This
        function calls that command.
        '''
        if which('gsutil') is None or which('gcloud') is None:
            log.error("Google Cloud SDK not installed!"
                      "Cannot access the Cloud Build API to trigger a site rebuild.")
            return

        project = 'gold-hybrid-255313'
        trigger_name = 'site-builder-manual'
        cmd = f"gcloud beta --project {project} builds triggers run {trigger_name}".split(' ')
        try:
            cmd_output = subprocess.run(args=cmd,
                                        shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT)
            log.log(VERBOSE, cmd_output.stdout.decode("utf-8"))
        except Exception as e:
            log.error(f"{e}: Failed to trigger Cloud Build job to rebuild site:\n\"{cmd}\"")

    def has_errors(self):
        return self.errors_seen
