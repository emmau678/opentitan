// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// otp_ctrl_dai_lock_vseq is developed to read/write lock DAI interface by partitions, and request
// read/write access to check if correct status and error code is triggered
class otp_ctrl_dai_lock_vseq extends otp_ctrl_smoke_vseq;
  `uvm_object_utils(otp_ctrl_dai_lock_vseq)

  `uvm_object_new

  // enable access_err for each cycle
  constraint no_access_err_c {access_locked_parts == 1;}

endclass
