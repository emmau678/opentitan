# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################

all: collect_results

# Build Stages
.PHONY: core_config            # riscvdv
.PHONY: instr_gen_build
.PHONY: instr_gen_run
.PHONY: compile_riscvdv_tests
.PHONY: compile_directed_tests # directed
.PHONY: rtl_tb_compile         # simulation
.PHONY: rtl_sim_run
.PHONY: check_logs             # post-checks and coverage merging
.PHONY: riscv_dv_fcov
.PHONY: merge_cov
.PHONY: collect_results

###############################################################################
# Environment variables

TOOLCHAIN           := ${RISCV_TOOLCHAIN}

export IBEX_ROOT      := $(realpath ../../../)
export PRJ_DIR        := $(realpath ../../..)
export LOWRISC_IP_DIR := $(realpath ${PRJ_DIR}/vendor/lowrisc_ip)

# Needed for tcl files that are used with Cadence tools.
export dv_root := $(realpath ../../../vendor/lowrisc_ip/dv)
export DUT_TOP := ibex_top

###############################################################################
# Here we express the different build artifacts that the Makefile uses to
# establish the dependency tree, as well as which jobs depend on which
# top-level configuration knobs when deciding what to rebuild.
# Use build artifacts as targets where appropriate, otherwise use stamp-files.

# TODO Evaluate input variables to more-cleverly schedule partial-rebuilds
# This would allow us to use Make to handle build scheduling and to calculate rebuilds,
# while keeping all the structured-data in the land of Python.
-include scripts/get_meta.mk

OUT-DIR := $(call get-meta,dir_out)
TESTS-DIR := $(call get-meta,dir_tests)
BUILD-DIR := $(call get-meta,dir_build)
RUN-DIR := $(call get-meta,dir_run)
METADATA-DIR := $(call get-meta,dir_metadata)

# This is a list of directories that are automatically generated by some
# targets. To ensure the directory has been built, add an order-only dependency
# (with the pipe symbol before it) on the directory name and add the directory
# to this list.
$(BUILD-DIR):
	@mkdir -p $@

riscvdv-ts := $(call get-meta,riscvdv_tds)
directed-ts := $(call get-meta,directed_tds)

asm-stem := test.S
bin-stem := test.bin
rtl-sim-logfile := rtl_sim.log
trr-stem := trr.yaml

riscvdv-dirs = $(foreach ts,$(riscvdv-ts),$(TESTS-DIR)/$(ts)/)
riscvdv-test-asms = $(addsuffix $(asm-stem),$(riscvdv-dirs))
riscvdv-test-bins = $(addsuffix $(bin-stem),$(riscvdv-dirs))

directed-dirs = $(foreach ts,$(directed-ts),$(TESTS-DIR)/$(ts)/)
directed-test-bins = $(addsuffix $(bin-stem),$(directed-dirs))

test-bins := $(riscvdv-test-bins) $(directed-test-bins)

ts-dirs := $(riscvdv-dirs) $(directed-dirs)
rtl-sim-logs = $(addsuffix $(rtl-sim-logfile),$(ts-dirs))
comp-results = $(addsuffix $(trr-stem),$(ts-dirs))

###############################################################################
# Other groups of files we may depend on are...

# A variable containing a file list for the riscv-dv vendored-in module.
# Depending on these files gives a safe over-approximation that will ensure we
# rebuild things if that module changes.
GEN_DIR := $(realpath ../../../vendor/google_riscv-dv)
riscv-dv-files := \
  $(shell find $(GEN_DIR) -type f)

all-verilog = \
  $(shell find ../../../rtl -name '*.v' -o -name '*.sv' -o -name '*.svh') \
  $(shell find ../.. -name '*.v' -o -name '*.sv' -o -name '*.svh')
all-cpp = \
  $(shell find ../.. -name '*.cc' -o -name '*.h')
# The compiled ibex testbench (obviously!) also depends on the design and the
# DV code. The clever way of doing this would be to look at a dependency
# listing generated by the simulator as a side-effect of doing the compile (a
# bit like using the -M flags with a C compiler). Unfortunately, that doesn't
# look like it's particularly easy, so we'll just depend on every .v, .sv or
# .svh file in the dv or rtl directories. Note that this variable is set with
# '=', rather than ':='. This means that we don't bother running the find
# commands unless we need the compiled testbench.
-include scripts/util.mk # VARIABLE DUMPING UTILS (see file for example)

###############################################################################
###############################################################################
# Include steps to build riscv-dv, then run to generate test.S files
-include scripts/riscvdv.mk

###############################################################################
# Compile all test assembly/sources
# This has different targets/dependencies because the directed tests may not
# follow an identical test.S-in-the-test-dir format.
#
# We don't explicitly track dependencies on the RISCV toolchain here.

compile_riscvdv_tests: $(riscvdv-test-bins)
$(riscvdv-test-bins): $(TESTS-DIR)/%/test.bin: \
  $(TESTS-DIR)/%/test.S scripts/compile_test.py
	@echo Compiling riscvdv test assembly to create binary at $@
	$(verb)env PYTHONPATH=$(PYTHONPATH) \
	scripts/compile_test.py \
	  --dir-metadata $(METADATA-DIR) \
	  --test-dot-seed $*

# NB. The directed test builder does not (yet) depend on the directed sources
compile_directed_tests: $(directed-test-bins)
$(directed-test-bins): scripts/compile_test.py
	@echo Compiling directed test to create binary at $@
	$(verb)env PYTHONPATH=$(PYTHONPATH) \
	scripts/compile_test.py \
	  --dir-metadata $(METADATA-DIR) \
	  --test-dot-seed $(shell basename $(dir $@))

###############################################################################
# Include rtl-simulation and logfile generation steps
-include scripts/ibex_sim.mk

###############################################################################
# Extras (for convenience)
.PHONY: prettify
prettify:
	@./scripts/prettify.sh

.PHONY: dump
dump:
	@./scripts/objdump.sh
