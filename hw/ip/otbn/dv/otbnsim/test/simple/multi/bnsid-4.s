/* Copyright lowRISC contributors (OpenTitan project). */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */
/*
  Double increment and bad address
*/
  addi   x2, x0, 1
  bn.sid x0++, 0(x2++)
