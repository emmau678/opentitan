// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class push_pull_agent_cfg #(parameter int HostDataWidth = 32,
                            parameter int DeviceDataWidth = HostDataWidth)
  extends dv_base_agent_cfg;

  // interface handle used by driver, monitor & the sequencer, via cfg handle
  virtual push_pull_if#(HostDataWidth, DeviceDataWidth) vif;

  // Determines whether this agent is configured as push or pull.
  // Should be set from the IP level environment.
  push_pull_agent_e agent_type;

  // Configures the agent to act in bidirectional mode,
  // transferring data on both sides of the handshake.
  bit in_bidirectional_mode = 1'b0;

  // A knob to keep the data until next req, rather than driving unknown after handshake
  // completes. See #4465 for the detailed discussion
  bit hold_h_data_until_next_req = 0;
  bit hold_d_data_until_next_req = 0;

  // Device-side delay range for both Push/Pull protocols.
  rand int unsigned device_delay_min;
  rand int unsigned device_delay_max;
  rand int unsigned large_device_delay_max_weight = 10; // max 100

  // Host-side delay range for both Push/Pull protocols.
  rand int unsigned host_delay_min;
  rand int unsigned host_delay_max;
  rand int unsigned large_host_delay_max_weight = 10; // max 100

  // Enables/disable all protocol delays.
  rand bit zero_delays;

  // Enable starting the device sequence by default if configured in Device mode.
  bit start_default_device_seq = 1;

  // These data queues allows users to specify data to be driven by the sequence at a higher level.
  //
  // To specify some Host data to be sent, `set_h_user_data()` should be called from a higher layer
  // to push the specified user data into the `h_user_data_q` queue.
  // The Host sequence will then check if the queue has any data in it, if so it will pop off the
  // first entry and drive that data value.
  //
  // Similarly, `set_d_user_data()` should be called from a higher layer to push some specified
  // user data into the `d_user_data_q` queue, which will then be popped off and driven by the
  // Device sequence.
  local bit [HostDataWidth-1:0]   h_user_data_q[$];
  local bit [DeviceDataWidth-1:0] d_user_data_q[$];

  constraint device_delay_min_c {
    device_delay_min == 0;
  }

  constraint device_delay_max_c {
    device_delay_max dist {1000 :/ large_device_delay_max_weight,
                           100  :/ 100 - large_device_delay_max_weight};
  }

  constraint host_delay_min_c {
    host_delay_min == 0;
  }

  constraint host_delay_max_c {
    host_delay_max dist {1000 :/ large_host_delay_max_weight,
                         100  :/ 100 - large_host_delay_max_weight};
  }

  // Bias randomization in favor of enabling zero delays less often.
  constraint zero_delays_c {
    zero_delays dist { 0 := 7,
                       1 := 3 };
  }

  // Setter method for the user data queues - must be called externally to place specific user-data
  // to be sent by the driver.
  function void add_h_user_data(bit [HostDataWidth-1:0] data);
    h_user_data_q.push_back(data);
  endfunction

  // Setter method for the user data queues - must be called externally to place specific user-data
  // to be sent by the driver.
  function void add_d_user_data(bit [DeviceDataWidth-1:0] data);
    d_user_data_q.push_back(data);
  endfunction

  // Clear method for the user data queues - must be called externally to clear user-data queue
  // which was being set by add_h_user_data method.
  function void clear_h_user_data();
    h_user_data_q.delete();
  endfunction

  // Clear method for the user data queues - must be called externally to clear user-data queue
  // which was being set by add_d_user_data method.
  function void clear_d_user_data();
    d_user_data_q.delete();
  endfunction

  // Getter method for the user data queues - returns the first data entry.
  function bit [HostDataWidth-1:0] get_h_user_data();
    `DV_CHECK_NE_FATAL(has_h_user_data(), 0, "h_user_data_q is empty!")
    return h_user_data_q.pop_front();
  endfunction

  // Getter method for the user data queues - returns the first data entry.
  function bit [DeviceDataWidth-1:0] get_d_user_data();
    `DV_CHECK_NE_FATAL(has_d_user_data(), 0, "d_user_data_q is empty!")
    return d_user_data_q.pop_front();
  endfunction

  // Getter method for the user data queues - must be called externally to check whether there is
  // any user data in the queues.
  function bit has_h_user_data();
    return (h_user_data_q.size() > 0);
  endfunction

  // Getter method for the user data queues - must be called externally to check whether there is
  // any user data in the queues.
  function bit has_d_user_data();
    return (d_user_data_q.size() > 0);
  endfunction

  `uvm_object_param_utils_begin(push_pull_agent_cfg#(HostDataWidth, DeviceDataWidth))
    `uvm_field_enum(push_pull_agent_e, agent_type, UVM_DEFAULT)
    `uvm_field_int(in_bidirectional_mode,          UVM_DEFAULT)
    `uvm_field_int(device_delay_min,               UVM_DEFAULT)
    `uvm_field_int(device_delay_max,               UVM_DEFAULT)
    `uvm_field_int(host_delay_min,                 UVM_DEFAULT)
    `uvm_field_int(host_delay_max,                 UVM_DEFAULT)
    `uvm_field_int(zero_delays,                    UVM_DEFAULT)
    `uvm_field_int(start_default_device_seq,       UVM_DEFAULT)
    `uvm_field_queue_int(h_user_data_q,            UVM_DEFAULT)
    `uvm_field_queue_int(d_user_data_q,            UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

endclass
