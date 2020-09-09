# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import logging
import os
from pathlib import Path

import pytest
from . import utils

log = logging.getLogger(__name__)


@pytest.hookimpl(tryfirst=True)
def pytest_exception_interact(node, call, report):
    """Dump all log files in case of a test failure."""
    try:
        if not report.failed:
            return
        if 'tmp_path_factory' not in node.funcargs:
            return
    except Exception:
        return

    utils.dump_temp_files(node.funcargs['tmp_path_factory'].getbasetemp())

@pytest.fixture(scope="session")
def topsrcdir():
    """Return the top-level source directory as Path object."""
    # TODO: Consider making this configurable using a pytest arg.
    path = (Path(os.path.dirname(__file__)) / '..' / '..').resolve()
    assert path.is_dir()
    return path


@pytest.fixture(scope="session")
def bin_dir(topsrcdir):
    """ Return the BIN_DIR (build output directory) """
    if 'BIN_DIR' in os.environ:
        bin_dir = Path(os.environ['BIN_DIR'])
        log.info("Using build outputs from environment variable BIN_DIR={}".format(str(bin_dir)))
    else:
        bin_dir = topsrcdir / 'build-bin'
        log.info("Using build outputs from $REPO_TOP/build-bin ({})".format(str(bin_dir)))

    assert bin_dir.is_dir()
    return bin_dir
