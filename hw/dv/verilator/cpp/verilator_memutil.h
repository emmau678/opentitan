// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_HW_DV_VERILATOR_CPP_VERILATOR_MEMUTIL_H_
#define OPENTITAN_HW_DV_VERILATOR_CPP_VERILATOR_MEMUTIL_H_

#include <map>
#include <string>
#include <vltstd/svdpi.h>

#include "sim_ctrl_extension.h"

enum MemImageType {
  kMemImageUnknown = 0,
  kMemImageElf,
  kMemImageVmem,
};

struct MemArea {
  std::string name;      // Unique identifier
  std::string location;  // Design scope location
  size_t width_bit;      // Memory width
};

/**
 * Provide various memory loading utilities for Verilator simulations
 *
 * These utilities require the corresponding DPI functions:
 * simutil_verilator_memload()
 * simutil_verilator_set_mem()
 * to be defined somewhere as SystemVerilog functions.
 */
class VerilatorMemUtil : public SimCtrlExtension {
 public:
  /**
   * Register a memory as instantiated by generic ram
   *
   * The |name| must be a unique identifier. The function will return false
   * if |name| is already used. |location| is the path to the scope of the
   * instantiated memory, which needs to support the DPI-C interfaces
   * 'simutil_verilator_memload' and 'simutil_verilator_set_mem' used for
   * 'vmem' and 'elf' files, respectively.
   * The |width_bit| argument specifies the with in bits of the target memory
   * instance (used for packing data).
   *
   * Memories must be registered before command arguments are parsed by
   * ParseCommandArgs() in order for them to be known.
   */
  bool RegisterMemoryArea(const std::string name, const std::string location,
                          size_t width_bit);

  /**
   * Register a memory with default width (32bits)
   */
  bool RegisterMemoryArea(const std::string name, const std::string location);

  /**
   * Parse command line arguments
   *
   * Process all recognized command-line arguments from argc/argv.
   *
   * @param argc, argv Standard C command line arguments
   * @param exit_app Indicate that program should terminate
   * @return Return code, true == success
   */
  virtual bool ParseCLIArguments(int argc, char **argv, bool &exit_app);

 private:
  std::map<std::string, MemArea> mem_register_;

  /**
   * Print a list of all registered memory regions
   *
   * @see RegisterMemoryArea()
   */
  void PrintMemRegions() const;

  bool MemWrite(const std::string &name, const std::string &filepath);
  bool MemWrite(const std::string &name, const std::string &filepath,
                MemImageType type);
};

#endif  // OPENTITAN_HW_DV_VERILATOR_CPP_VERILATOR_MEMUTIL_H_
