// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// ---------------------------------------------
// Alert sender receiver sequence item
// ---------------------------------------------

class alert_seq_item extends uvm_sequence_item;

  // prefix 's' for sender, 'r' for receiver
  rand bit s_alert_send;
  rand bit s_alert_ping_rsp; // sender response to ping using alert
  rand bit r_alert_rsp;      // receiver response to alert using ack
  rand bit r_alert_ping_send;
  rand bit r_esc_rsp;
  rand bit int_err;
  rand bit timeout;

  // for monitor only
  rand alert_esc_trans_type_e alert_esc_type;
  rand alert_handshake_e      alert_handshake_sta;
  rand esc_handshake_e        esc_handshake_sta;

  // delays
  rand int unsigned ping_delay;
  rand int unsigned ack_delay;
  rand int unsigned ack_stable;
  rand int unsigned alert_delay;

  constraint delay_c {
    soft ping_delay  dist {0 :/ 5, [1:10] :/ 5};
    soft ack_delay   dist {0 :/ 5, [1:10] :/ 5};
    soft alert_delay dist {0 :/ 5, [1:10] :/ 5};
    soft ack_stable  dist {1 :/ 5, [2:10] :/ 5};
  }

  // if agent is alert mode, cannot send any esc_rsp signal
  // if agent is esc mode, cannot send any alert related signals
  constraint alert_esc_mode_c {
    r_esc_rsp == 1 -> (!s_alert_send && !r_alert_rsp && !r_alert_ping_send && !s_alert_ping_rsp);
    (s_alert_send || r_alert_rsp || r_alert_ping_send || s_alert_ping_rsp) -> !r_esc_rsp;
  }

  // temp constraint
  constraint disable_int_err_c {
    int_err == 0;
  }

  `uvm_object_utils_begin(alert_seq_item)
    `uvm_field_int (s_alert_send,      UVM_DEFAULT)
    `uvm_field_int (s_alert_ping_rsp,  UVM_DEFAULT)
    `uvm_field_int (r_alert_rsp,       UVM_DEFAULT)
    `uvm_field_int (r_alert_ping_send, UVM_DEFAULT)
    `uvm_field_int (r_esc_rsp,         UVM_DEFAULT)
    `uvm_field_int (int_err,           UVM_DEFAULT)
    `uvm_field_int (timeout,           UVM_DEFAULT)
    `uvm_field_enum(alert_esc_trans_type_e, alert_esc_type,      UVM_DEFAULT)
    `uvm_field_enum(alert_handshake_e,      alert_handshake_sta, UVM_DEFAULT)
    `uvm_field_enum(esc_handshake_e,        esc_handshake_sta,   UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "");
    super.new(name);
  endfunction : new

endclass : alert_seq_item
