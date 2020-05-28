#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

'''A tool to copy source code from upstream into this repository.

For an introduction to using this tool, see doc/ug/vendor_hw.md in this
repository (on the internet at https://docs.opentitan.org/doc/ug/vendor_hw/).

For full documentation, see doc/rm/vendor_in_tool.md (on the internet at
https://docs.opentitan.org/doc/rm/vendor_in_tool).

'''

import argparse
import fnmatch
import logging as log
import os
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path

import hjson

EXCLUDE_ALWAYS = ['.git']

LOCK_FILE_HEADER = """// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This file is generated by the util/vendor script. Please do not modify it
// manually.

"""

verbose = False


def git_is_clean_workdir(git_workdir):
    """Check if the git working directory is clean (no unstaged or staged changes)"""
    cmd = ['git', 'status', '--untracked-files=no', '--porcelain']
    modified_files = subprocess.run(cmd,
                                    cwd=str(git_workdir),
                                    check=True,
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE).stdout.strip()
    return not modified_files


def github_qualify_references(log, repo_userorg, repo_name):
    """ Replace "unqualified" GitHub references with "fully qualified" one

    GitHub automatically links issues and pull requests if they have a specific
    format. Links can be qualified with the user/org name and the repository
    name, or unqualified, if they only contain the issue or pull request number.

    This function converts all unqualified references to qualified ones.

    See https://help.github.com/en/articles/autolinked-references-and-urls#issues-and-pull-requests
    for a documentation of all supported formats.
    """

    r = re.compile(r"(^|[^\w])(?:#|[gG][hH]-)(\d+)\b")
    repl_str = r'\1%s/%s#\2' % (repo_userorg, repo_name)
    return [r.sub(repl_str, l) for l in log]


def test_github_qualify_references():
    repo_userorg = 'lowRISC'
    repo_name = 'ibex'

    # Unqualified references, should be replaced
    items_unqualified = [
        '#28',
        'GH-27',
        'klaus #27',
        'Fixes #27',
        'Fixes #27 and #28',
        '(#27)',
        'something (#27) done',
        '#27 and (GH-38)',
    ]
    exp_items_unqualified = [
        'lowRISC/ibex#28',
        'lowRISC/ibex#27',
        'klaus lowRISC/ibex#27',
        'Fixes lowRISC/ibex#27',
        'Fixes lowRISC/ibex#27 and lowRISC/ibex#28',
        '(lowRISC/ibex#27)',
        'something (lowRISC/ibex#27) done',
        'lowRISC/ibex#27 and (lowRISC/ibex#38)',
    ]
    assert github_qualify_references(items_unqualified, repo_userorg,
                                     repo_name) == exp_items_unqualified

    # Qualified references, should stay as they are
    items_qualified = [
        'Fixes lowrisc/ibex#27',
        'lowrisc/ibex#2',
    ]
    assert github_qualify_references(items_qualified, repo_userorg,
                                     repo_name) == items_qualified

    # Invalid references, should stay as they are
    items_invalid = [
        'something#27',
        'lowrisc/ibex#',
    ]
    assert github_qualify_references(items_invalid, repo_userorg,
                                     repo_name) == items_invalid


def test_github_parse_url():
    assert github_parse_url('https://example.com/something/asdf.git') is None
    assert github_parse_url('https://github.com/lowRISC/ibex.git') == (
        'lowRISC', 'ibex')
    assert github_parse_url('https://github.com/lowRISC/ibex') == ('lowRISC',
                                                                   'ibex')
    assert github_parse_url('git@github.com:lowRISC/ibex.git') == ('lowRISC',
                                                                   'ibex')


def github_parse_url(github_repo_url):
    """Parse a GitHub repository URL into its parts.

    Return a tuple (userorg, name), or None if the parsing failed.
    """

    regex = r"(?:@github\.com\:|\/github\.com\/)([a-zA-Z\d-]+)\/([a-zA-Z\d-]+)(?:\.git)?$"
    m = re.search(regex, github_repo_url)
    if m is None:
        return None
    return (m.group(1), m.group(2))


def produce_shortlog(clone_dir, mapping, old_rev, new_rev):
    """ Produce a list of changes between two revisions, one revision per line

    Merges are excluded"""

    # If mapping is None, we want to list all changes below clone_dir.
    # Otherwise, we want to list changes in each 'source' in the mapping. Since
    # these strings are paths relative to clone_dir, we can just pass them all
    # to git and let it figure out what to do.
    subdirs = (['.'] if mapping is None
               else [src for (src, _) in mapping.items])

    cmd = (['git', '-C', str(clone_dir), 'log',
           '--pretty=format:%s (%aN)', '--no-merges',
            old_rev + '..' + new_rev] +
           subdirs)
    try:
        proc = subprocess.run(cmd,
                              cwd=str(clone_dir),
                              check=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE,
                              universal_newlines=True)
        return proc.stdout.splitlines()
    except subprocess.CalledProcessError as e:
        log.error("Unable to capture shortlog: %s", e.stderr)
        return ""


def format_list_to_str(list, width=70):
    """ Create Markdown-style formatted string from a list of strings """
    wrapper = textwrap.TextWrapper(initial_indent="* ",
                                   subsequent_indent="  ",
                                   width=width)
    return '\n'.join([wrapper.fill(s) for s in list])


class JsonError(Exception):
    '''An error class for when data in the source HJSON is bad'''
    def __init__(self, path, msg):
        self.path = path
        self.msg = msg

    def __str__(self):
        return 'In hjson at {}, {}'.format(self.path, self.msg)


def get_field(path, where, data, name, expected_type=dict, optional=False, constructor=None):
    value = data.get(name)
    if value is None:
        if not optional:
            raise JsonError(path, '{}, missing {!r} field.'.format(where, name))
        return None

    if not isinstance(value, expected_type):
        raise JsonError(path,
                        '{}, the {!r} field is {!r}, but should be of type {!r}.'
                        .format(where, name, value, expected_type.__name__))

    return value if constructor is None else constructor(value)


class Upstream:
    '''A class representing the 'upstream' field in a config or lock file'''
    def __init__(self, path, data):
        # Fields: 'url', 'rev', 'only_subdir' (optional). All should be strings.
        where = 'in upstream dict'
        self.url = get_field(path, where, data, 'url', str)
        self.rev = get_field(path, where, data, 'rev', str)
        self.only_subdir = get_field(path, where, data,
                                     'only_subdir', str, optional=True)

    def as_dict(self):
        data = {'url': self.url, 'rev': self.rev}
        if self.only_subdir is not None:
            data['only_subdir'] = self.only_subdir
        return data


class PatchRepo:
    '''A class representing the 'patch_repo' field in a config file'''
    def __init__(self, path, data):
        # Fields: 'url', 'rev_base', 'rev_patched'. All should be strings.
        where = 'in patch_repo dict'
        self.url = get_field(path, where, data, 'url', str)
        self.rev_base = get_field(path, where, data, 'rev_base', str)
        self.rev_patched = get_field(path, where, data, 'rev_patched', str)


class Mapping1:
    '''A class to represent a single item in the 'mapping' field in a config file'''
    def __init__(self, from_path, to_path, patch_dir):
        self.from_path = from_path
        self.to_path = to_path
        self.patch_dir = patch_dir

    @staticmethod
    def make(path, idx, data):
        assert isinstance(data, dict)

        def get_path(name, optional=False):
            val = get_field(path, 'in mapping entry {}'.format(idx + 1),
                            data, name, expected_type=str, optional=optional)
            if val is None:
                return None

            # Check that the paths aren't evil ('../../../foo' or '/etc/passwd'
            # are *not* ok!)
            val = os.path.normpath(val)
            if val.startswith('/') or val.startswith('..'):
                raise JsonError(path,
                                'Mapping entry {} has a bad path for {!r} '
                                '(must be a relative path that doesn\'t '
                                'escape the directory)'
                                .format(idx + 1, name))

            return Path(val)

        from_path = get_path('from')
        to_path = get_path('to')
        patch_dir = get_path('patch_dir', optional=True)

        return Mapping1(from_path, to_path, patch_dir)

    @staticmethod
    def make_default(have_patch_dir):
        '''Make a default mapping1, which copies everything straight through'''
        return Mapping1(Path('.'), Path('.'),
                        Path('.') if have_patch_dir else None)

    @staticmethod
    def apply_patch(basedir, patchfile):
        cmd = ['git', 'apply', '--directory', str(basedir), '-p1',
               str(patchfile)]
        if verbose:
            cmd += ['--verbose']
        subprocess.run(cmd, check=True)

    def import_from_upstream(self, upstream_path,
                             target_path, exclude_files, patch_dir):
        '''Copy from the upstream checkout to target_path'''
        from_path = upstream_path / self.from_path
        to_path = target_path / self.to_path

        # Make sure the target directory actually exists
        to_path.parent.mkdir(exist_ok=True, parents=True)

        # Copy src to dst recursively. For directories, we can use
        # shutil.copytree. This doesn't support files, though, so we have to
        # check for them first.
        if from_path.is_file():
            shutil.copy(str(from_path), str(to_path))
        else:
            ignore = ignore_patterns(str(upstream_path), *exclude_files)
            shutil.copytree(str(from_path), str(to_path), ignore=ignore)

        # Apply any patches to the copied files. If self.patch_dir is None,
        # there are none to apply. Otherwise, resolve it relative to patch_dir.
        if self.patch_dir is not None:
            patches = (patch_dir / self.patch_dir).glob('*.patch')
            for patch in sorted(patches):
                log.info("Applying patch {} at {}".format(patch, to_path))
                Mapping1.apply_patch(to_path, patch)


class Mapping:
    '''A class representing the 'mapping' field in a config file

    This should be a list of dicts.
    '''
    def __init__(self, items):
        self.items = items

    @staticmethod
    def make(path, data):
        items = []
        assert isinstance(data, list)
        for idx, elt in enumerate(data):
            if not isinstance(elt, dict):
                raise JsonError(path, 'Mapping element {!r} is not a dict.'.format(elt))
            items.append(Mapping1.make(path, idx, elt))

        return Mapping(items)

    def has_patch_dir(self):
        '''Check whether at least one item defines a patch dir'''
        for item in self.items:
            if item.patch_dir is not None:
                return True
        return False


class LockDesc:
    '''A class representing the contents of a lock file'''
    def __init__(self, handle):
        data = hjson.loads(handle.read(), use_decimal=True)
        self.upstream = get_field(handle.name, 'at top-level', data, 'upstream',
                                  constructor=lambda data: Upstream(handle.name, data))


class Desc:
    '''A class representing the configuration file'''
    def __init__(self, handle):

        # Ensure description file matches our naming rules (otherwise we don't
        # know the name for the lockfile). This regex checks that we have the
        # right suffix and a nonempty name.
        if not re.match(r'.+\.vendor\.hjson', handle.name):
            raise ValueError("Description file names must have a .vendor.hjson suffix.")

        data = hjson.loads(handle.read(), use_decimal=True)
        where = 'at top-level'

        path = Path(handle.name)

        def take_path(p):
            return path.parent / p

        self.path = path
        self.name = get_field(path, where, data, 'name', expected_type=str)
        self.target_dir = get_field(path, where, data, 'target_dir',
                                    expected_type=str, constructor=take_path)
        self.upstream = get_field(path, where, data, 'upstream',
                                  constructor=lambda data: Upstream(path, data))
        self.patch_dir = get_field(path, where, data, 'patch_dir',
                                   optional=True, expected_type=str, constructor=take_path)
        self.patch_repo = get_field(path, where, data, 'patch_repo',
                                    optional=True,
                                    constructor=lambda data: PatchRepo(path, data))
        self.exclude_from_upstream = (get_field(path, where, data, 'exclude_from_upstream',
                                                optional=True, expected_type=list) or
                                      [])
        self.mapping = get_field(path, where, data, 'mapping', optional=True,
                                 expected_type=list,
                                 constructor=lambda data: Mapping.make(path, data))

        # Add default exclusions
        self.exclude_from_upstream += EXCLUDE_ALWAYS

        # It doesn't make sense to define a patch_repo, but not a patch_dir
        # (where should we put the patches that we get?)
        if self.patch_repo is not None and self.patch_dir is None:
            raise JsonError(path, 'Has patch_repo but not patch_dir.')

        # We don't currently support a patch_repo and a mapping (just because
        # we haven't written the code to generate the patches across subdirs
        # yet). Tracked in issue #2317.
        if self.patch_repo is not None and self.mapping is not None:
            raise JsonError(path,
                            "vendor.py doesn't currently support patch_repo "
                            "and mapping at the same time (see issue #2317).")

        # If a patch_dir is defined and there is no mapping, we will look in
        # that directory for patches and apply them in (the only) directory
        # that we copy stuff into.
        #
        # If there is a mapping check that there is a patch_dir if and only if
        # least one mapping entry uses it.
        if self.mapping is not None:
            if self.patch_dir is not None:
                if not self.mapping.has_patch_dir():
                    raise JsonError(path, 'Has patch_dir, but no mapping item uses it.')
            else:
                if self.mapping.has_patch_dir():
                    raise JsonError(path,
                                    'Has a mapping item with a patch directory, '
                                    'but there is no global patch_dir key.')

        # Check that exclude_from_upstream really is a list of strings. Most of
        # this type-checking is in the constructors for field types, but we
        # don't have a "ExcludeList" class, so have to do it explicitly here.
        for efu in self.exclude_from_upstream:
            if not isinstance(efu, str):
                raise JsonError(path,
                                'exclude_from_upstream has entry {}, which is not a string.'
                                .format(efu))

    def lock_file_path(self):
        desc_file_stem = self.path.name.rsplit('.', 2)[0]
        return self.path.with_name(desc_file_stem + '.lock.hjson')

    def import_from_upstream(self, upstream_path):
        log.info('Copying upstream sources to {}'.format(self.target_dir))

        # Remove existing directories before importing them again
        shutil.rmtree(str(self.target_dir), ignore_errors=True)

        items = (self.mapping.items if self.mapping is not None
                 else [Mapping1.make_default(self.patch_dir is not None)])
        for map1 in items:
            map1.import_from_upstream(upstream_path,
                                      self.target_dir,
                                      self.exclude_from_upstream,
                                      self.patch_dir)


def refresh_patches(desc):
    if desc.patch_repo is None:
        log.fatal('Unable to refresh patches, patch_repo not set in config.')
        sys.exit(1)

    log.info('Refreshing patches in {}'.format(desc.patch_dir))

    # remove existing patches
    for patch in desc.patch_dir.glob('*.patch'):
        os.unlink(str(patch))

    # get current patches
    _export_patches(desc.patch_repo.url, desc.patch_dir,
                    desc.patch_repo.rev_base,
                    desc.patch_repo.rev_patched)


def _export_patches(patchrepo_clone_url, target_patch_dir, upstream_rev,
                    patched_rev):
    with tempfile.TemporaryDirectory() as clone_dir:
        clone_git_repo(patchrepo_clone_url, clone_dir, patched_rev)
        rev_range = 'origin/' + upstream_rev + '..' + 'origin/' + patched_rev
        cmd = ['git', 'format-patch', '-o', str(target_patch_dir), rev_range]
        if not verbose:
            cmd += ['-q']
        subprocess.run(cmd, cwd=str(clone_dir), check=True)


def ignore_patterns(base_dir, *patterns):
    """Similar to shutil.ignore_patterns, but with support for directory excludes."""
    def _rel_to_base(path, name):
        return os.path.relpath(os.path.join(path, name), base_dir)

    def _ignore_patterns(path, names):
        ignored_names = []
        for pattern in patterns:
            pattern_matches = [
                n for n in names
                if fnmatch.fnmatch(_rel_to_base(path, n), pattern)
            ]
            ignored_names.extend(pattern_matches)
        return set(ignored_names)

    return _ignore_patterns


def clone_git_repo(repo_url, clone_dir, rev='master'):
    log.info('Cloning upstream repository %s @ %s', repo_url, rev)

    # Clone the whole repository
    cmd = ['git', 'clone', '--no-single-branch']
    if not verbose:
        cmd += ['-q']
    cmd += [repo_url, str(clone_dir)]
    subprocess.run(cmd, check=True)

    # Check out exactly the revision requested
    cmd = ['git', '-C', str(clone_dir), 'checkout', '--force', rev]
    if not verbose:
        cmd += ['-q']
    subprocess.run(cmd, check=True)

    # Get revision information
    cmd = ['git', '-C', str(clone_dir), 'rev-parse', 'HEAD']
    rev = subprocess.run(cmd,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         check=True,
                         universal_newlines=True).stdout.strip()
    log.info('Cloned at revision %s', rev)
    return rev


def git_get_short_rev(clone_dir, rev):
    """ Get the shortened SHA-1 hash for a revision """
    cmd = ['git', '-C', str(clone_dir), 'rev-parse', '--short', rev]
    short_rev = subprocess.run(cmd,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE,
                               check=True,
                               universal_newlines=True).stdout.strip()
    return short_rev


def git_add_commit(paths, commit_msg):
    """ Stage and commit all changes in paths"""

    assert paths
    base_dir = paths[0].parent

    # Stage all changes
    #
    # Rather than figuring out GIT_DIR properly, we cheat and use "git -C" to
    # pretend that we're running in base_dir. Of course, the elements of paths
    # are relative to our actual working directory. Rather than do anything
    # clever, we just resolve them to absolute paths as we go.
    abs_paths = [p.resolve() for p in paths]
    subprocess.run(['git', '-C', base_dir, 'add'] + abs_paths, check=True)

    cmd_commit = ['git', '-C', base_dir, 'commit', '-s', '-F', '-']
    try:
        subprocess.run(cmd_commit,
                       check=True,
                       universal_newlines=True,
                       input=commit_msg)
    except subprocess.CalledProcessError:
        log.warning("Unable to create commit. Are there no changes?")


def main(argv):
    parser = argparse.ArgumentParser(prog="vendor", description=__doc__)
    parser.add_argument(
        '--update',
        '-U',
        dest='update',
        action='store_true',
        help='Update locked version of repository with upstream changes')
    parser.add_argument('--refresh-patches',
                        action='store_true',
                        help='Refresh the patches from the patch repository')
    parser.add_argument('--commit',
                        '-c',
                        action='store_true',
                        help='Commit the changes')
    parser.add_argument('desc_file',
                        metavar='file',
                        type=argparse.FileType('r', encoding='UTF-8'),
                        help='vendoring description file (*.vendor.hjson)')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose')
    args = parser.parse_args()

    global verbose
    verbose = args.verbose
    if (verbose):
        log.basicConfig(format="%(levelname)s: %(message)s", level=log.DEBUG)
    else:
        log.basicConfig(format="%(levelname)s: %(message)s")

    # Load input files (desc file; lock file) and check syntax etc.
    try:
        # Load description file
        desc = Desc(args.desc_file)
        lock_file_path = desc.lock_file_path()

        # Try to load lock file (which might not exist)
        try:
            with open(str(lock_file_path), 'r') as lock_file:
                lock = LockDesc(lock_file)
        except FileNotFoundError:
            lock = None
    except (JsonError, ValueError) as err:
        log.fatal(str(err))
        raise SystemExit(1)

    # Check for a clean working directory when commit is requested
    if args.commit:
        if not git_is_clean_workdir(desc.path.parent):
            log.fatal("A clean git working directory is required for "
                      "--commit/-c. git stash your changes and try again.")
            raise SystemExit(1)

    if lock is None and not args.update:
        log.warning("No lock file at {}, so will update upstream repo."
                    .format(str(desc.lock_file_path())))
        args.update = True

    # If we have a lock file and we're not in update mode, override desc's
    # upstream field with the one from the lock file. Keep track of whether the
    # URL differs (in which case, we can't get a shortlog)
    changed_url = False
    if lock is not None:
        changed_url = desc.upstream.url != lock.upstream.url
        if not args.update:
            desc.upstream = lock.upstream

    if args.refresh_patches:
        refresh_patches(desc)

    with tempfile.TemporaryDirectory() as clone_dir:
        # clone upstream repository
        upstream_new_rev = clone_git_repo(desc.upstream.url, clone_dir, rev=desc.upstream.rev)

        if not args.update:
            if upstream_new_rev != lock.upstream.rev:
                log.fatal(
                    "Revision mismatch. Unable to re-clone locked version of repository."
                )
                log.fatal("Attempted revision: %s", desc.upstream.rev)
                log.fatal("Re-cloned revision: %s", upstream_new_rev)
                raise SystemExit(1)

        clone_subdir = Path(clone_dir)
        if desc.upstream.only_subdir is not None:
            clone_subdir = clone_subdir / desc.upstream.only_subdir
            if not clone_subdir.is_dir():
                log.fatal("subdir '{}' does not exist in repo"
                          .format(desc.upstream.only_subdir))
                raise SystemExit(1)

        # copy selected files from upstream repo and apply patches as necessary
        desc.import_from_upstream(clone_subdir)

        # get shortlog
        get_shortlog = args.update
        if args.update:
            if lock is None:
                get_shortlog = False
                log.warning("No lock file %s: unable to summarize changes.", str(lock_file_path))
            elif changed_url:
                get_shortlog = False
                log.warning("The repository URL changed since the last run. "
                            "Unable to get log of changes.")

        shortlog = None
        if get_shortlog:
            shortlog = produce_shortlog(clone_subdir, desc.mapping,
                                        lock.upstream.rev, upstream_new_rev)

            # Ensure fully-qualified issue/PR references for GitHub repos
            gh_repo_info = github_parse_url(desc.upstream.url)
            if gh_repo_info:
                shortlog = github_qualify_references(shortlog, gh_repo_info[0],
                                                     gh_repo_info[1])

            log.info("Changes since the last import:\n" +
                     format_list_to_str(shortlog))

        # write lock file
        if args.update:
            lock_data = {}
            lock_data['upstream'] = desc.upstream.as_dict()
            lock_data['upstream']['rev'] = upstream_new_rev
            with open(str(lock_file_path), 'w', encoding='UTF-8') as f:
                f.write(LOCK_FILE_HEADER)
                hjson.dump(lock_data, f)
                f.write("\n")
                log.info("Wrote lock file %s", str(lock_file_path))

        # Commit changes
        if args.commit:
            sha_short = git_get_short_rev(clone_subdir, upstream_new_rev)

            repo_info = github_parse_url(desc.upstream.url)
            if repo_info is not None:
                sha_short = "%s/%s@%s" % (repo_info[0], repo_info[1],
                                          sha_short)

            commit_msg_subject = 'Update %s to %s' % (desc.name, sha_short)
            intro = ('Update code from {}upstream repository {} to revision {}'
                     .format(('' if desc.upstream.only_subdir is None else
                              'subdir {} in '.format(desc.upstream.only_subdir)),
                             desc.upstream.url,
                             upstream_new_rev))
            commit_msg_body = textwrap.fill(intro, width=70)

            if shortlog:
                commit_msg_body += "\n\n"
                commit_msg_body += format_list_to_str(shortlog, width=70)

            commit_msg = commit_msg_subject + "\n\n" + commit_msg_body

            commit_paths = []
            commit_paths.append(desc.target_dir)
            if args.refresh_patches:
                commit_paths.append(desc.patch_dir)
            commit_paths.append(lock_file_path)

            git_add_commit(commit_paths, commit_msg)

    log.info('Import finished')


if __name__ == '__main__':
    try:
        main(sys.argv)
    except subprocess.CalledProcessError as e:
        log.fatal("Called program '%s' returned with %d.\n"
                  "STDOUT:\n%s\n"
                  "STDERR:\n%s\n" %
                  (" ".join(e.cmd), e.returncode, e.stdout, e.stderr))
        raise
