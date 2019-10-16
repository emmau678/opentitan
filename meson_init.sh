#!/bin/bash
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o nounset

readonly BUILD_DIR_PREFIX="build"
readonly TARGET_VERILATOR="verilator"
readonly TARGET_FPGA="fpga"

function usage() {
  cat << USAGE
Configure Meson build targets.

Usage: $0 [-r|-f]

  -f: Remove build directories before running Meson.
  -r: Force reconfiguration of build directories.
  -K: Keep include search paths as generated by Meson.

USAGE
}

FLAGS_force=false
FLAGS_reconfigure=""
FLAGS_keep_includes=false
while getopts 'r?:f?:K?' flag; do
  case "${flag}" in
    f) FLAGS_force=true;;
    r) FLAGS_reconfigure="--reconfigure";;
    K) FLAGS_keep_includes=true;;
    ?) usage && exit 1;;
    *) usage
       error "Unexpected option ${flag}"
       ;;
  esac
done

if [[ "${FLAGS_force}" == true && -n "${FLAGS_reconfigure}" ]]; then
  usage >&2
  echo "Error: -r and -f cannont be used at the same time." >&2
  exit 1
fi

if [[ ! -n "$(command -v meson)" ]]; then
  echo "Unable to find meson. Please install meson before running this command." >&2
  exit 1
fi

if [[ ! -n "$(command -v ninja)" ]]; then
  echo "Unable to find ninja. Please install ninja before running this command." >&2
  exit 1
fi

if [[ "${FLAGS_force}" == true ]]; then
  for target_suffix in "${TARGET_VERILATOR}" "${TARGET_FPGA}"; do
    rm -rf "${BUILD_DIR_PREFIX}-${target_suffix}"
  done
fi

if [[ ! -n "${FLAGS_reconfigure}" ]] ; then
  for target_suffix in "${TARGET_VERILATOR}" "${TARGET_FPGA}"; do
    if [[ -d "${BUILD_DIR_PREFIX}-${target_suffix}" ]]; then
      usage >&2
      echo "Error: ${BUILD_DIR_PREFIX}-${target_suffix} already exists. " \
           "Remove directory, or rerun $0 with the -r option" >&2
      exit 1
    fi
  done
fi

# purge_includes $target deletes any -I command line arguments that are not
# - Absolute paths.
# - Ephemeral build directories.
#
# This function is necessary because Meson does not give adequate
# control over what directories are passed in as -I search directories
# to the C compiler. While Meson does provide |implicit_include_directories|,
# support for this option is poor: empirically, Meson ignores this option for
# some targerts. Doing it as a post-processing step ensures that Meson does
# not allow improper #includes to compile successfully.
function purge_includes() {
  if [[ "${FLAGS_keep_includes}" == "true" ]]; then
    return
  fi
  echo "Purging superfluous -I arguments from $1."
  local ninja_file="${BUILD_DIR_PREFIX}-$1/build.ninja"
  perl -pi -e 's#-I[^/][^@ ]+ # #g' -- "$ninja_file"
}

meson ${FLAGS_reconfigure} "-Dtarget=${TARGET_VERILATOR}" --cross-file=toolchain.txt \
    --buildtype=plain "${BUILD_DIR_PREFIX}-${TARGET_VERILATOR}"
purge_includes ${TARGET_VERILATOR}

meson ${FLAGS_reconfigure} "-Dtarget=${TARGET_FPGA}" --cross-file=toolchain.txt \
    --buildtype=plain "${BUILD_DIR_PREFIX}-${TARGET_FPGA}"
purge_includes ${TARGET_FPGA}
