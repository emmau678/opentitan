###############################################################################
# @generated
# This file is auto-generated by the cargo-bazel tool.
#
# DO NOT MODIFY: Local changes may be replaced in future executions.
###############################################################################
"""Rules for defining repositories for remote `crates_vendor` repositories"""

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# buildifier: disable=bzl-visibility
load("@lowrisc_opentitan//third_party/tock/crates:defs.bzl", _crate_repositories = "crate_repositories")

# buildifier: disable=bzl-visibility
load("@rules_rust//crate_universe/private:crates_vendor.bzl", "crates_vendor_remote_repository")

def crate_repositories():
    maybe(
        crates_vendor_remote_repository,
        name = "tock_index",
        build_file = Label("@lowrisc_opentitan//third_party/tock/crates:BUILD.bazel"),
        defs_module = Label("@lowrisc_opentitan//third_party/tock/crates:defs.bzl"),
    )

    _crate_repositories()
