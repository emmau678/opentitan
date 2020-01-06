// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tb__xbar_connect generated by `tlgen.py` tool


xbar_${xbar.name} dut(
  // TODO temp use same clk to avoid failure due to new feature (multi-clk #903)
% for c in xbar.clocks:
  .${c}(clk),
% endfor
% for r in xbar.resets:
  .${r}(rst_n)${"," if not loop.last else ""}
% endfor
);

// Host TileLink interface connections
% for node in xbar.hosts:
`CONNECT_TL_HOST_IF(${node.name})
% endfor

// Device TileLink interface connections
% for node in xbar.devices:
`CONNECT_TL_DEVICE_IF(${node.name})
% endfor
