// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// ---------------------------------------------
// Xbar environment configuration class
// ---------------------------------------------
class xbar_env_cfg extends dv_base_env_cfg;

  rand tl_agent_cfg  host_agent_cfg[];
  rand tl_agent_cfg  device_agent_cfg[];
  uint               num_hosts;
  uint               num_devices;
  uint               num_enabled_hosts;
  uint               min_host_req_delay   = 0;
  uint               max_host_req_delay   = 20;
  uint               min_host_rsp_delay   = 0;
  uint               max_host_rsp_delay   = 20;
  uint               min_device_req_delay = 0;
  uint               max_device_req_delay = 20;
  uint               min_device_rsp_delay = 0;
  uint               max_device_rsp_delay = 20;

  `uvm_object_utils_begin(xbar_env_cfg)
    `uvm_field_array_object(host_agent_cfg,    UVM_DEFAULT)
    `uvm_field_array_object(device_agent_cfg,  UVM_DEFAULT)
    `uvm_field_int(num_hosts,                  UVM_DEFAULT)
    `uvm_field_int(num_devices,                UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

  virtual function void initialize(bit [TL_AW-1:0] csr_base_addr = '1,
                                   bit [TL_AW-1:0] csr_addr_map_size = 2048);
    has_ral = 0; // no csr in xbar
    // Host TL agent cfg
    num_hosts         = xbar_hosts.size();
    num_enabled_hosts = xbar_hosts.size();
    host_agent_cfg    = new[num_hosts];
    foreach (host_agent_cfg[i]) begin
      host_agent_cfg[i] = tl_agent_cfg::type_id::
                          create($sformatf("%0s_agent_cfg", xbar_hosts[i].host_name));
      host_agent_cfg[i].is_host = 1;
    end
    // Device TL agent cfg
    num_devices      = xbar_devices.size();
    device_agent_cfg = new[num_devices];
    foreach (device_agent_cfg[i]) begin
      device_agent_cfg[i] = tl_agent_cfg::type_id::
                            create($sformatf("%0s_agent_cfg", xbar_devices[i].device_name));
      device_agent_cfg[i].is_host = 0;
    end
  endfunction
endclass
