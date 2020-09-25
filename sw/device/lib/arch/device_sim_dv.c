// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/arch/device.h"

/**
 * Device-specific symbol definitions for the Verilator device.
 */

const device_type_t kDeviceType = kDeviceSimDV;

// TODO: DV testbench completely randomizes these. Need to add code to
// retrieve these from a preloaded memory location set by the testbench.

const uint64_t kClockFreqCpuHz = 100 * 1000 * 1000;  // 100MHz

const uint64_t kClockFreqPeripheralHz = 24 * 1000 * 1000;  // 24MHz

const uint64_t kClockFreqUsbHz = 48 * 1000 * 1000;  // 48MHz

const uint64_t kUartBaudrate = 1 * (1 << 20);  // 1Mbps

// No Device Stop Address in our DV simulator.
const uintptr_t kDeviceStopAddress = 0;

const uintptr_t kDeviceTestStatusAddress = 0x1000fff8;

const uintptr_t kDeviceLogBypassUartAddress = 0x1000fffc;
