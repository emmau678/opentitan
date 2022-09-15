/* Copyright lowRISC contributors. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/**
 * Elliptic curve P-256 ECDSA
 *
 * Uses OTBN ECC P-256 lib to perform an ECDSA operations.
 */

.section .text.start
.globl start
start:
  /* Read mode, then tail-call either p256_ecdsa_sign or p256_ecdsa_verify */
  la    x2, mode
  lw    x2, 0(x2)

  li    x3, 1
  beq   x2, x3, p256_ecdsa_sign

  li    x3, 2
  beq   x2, x3, p256_ecdsa_verify

  /* Mode is neither 1 (= sign) nor 2 (= verify). Fail. */
  unimp

.text
p256_ecdsa_sign:
  jal      x1, p256_ecdsa_setup_rand
  jal      x1, p256_sign
  ecall

p256_ecdsa_verify:
  jal      x1, p256_verify
  ecall

/**
 * Populate the variables rnd and k with randomness, and setup data pointers.
 */
p256_ecdsa_setup_rand:
  /* Obtain the blinding constant from URND, and write it to `rnd` in DMEM. */
  bn.wsrr   w0, 0x2 /* URND */
  la        x10, rnd
  bn.sid    x0, 0(x10)

  /* Obtain the nonce (k) from RND. */
  bn.wsrr   w0, 0x1 /* RND */
  la        x10, k
  bn.sid    x0, 0(x10)

  ret

.bss

/* Operation mode (1 = sign; 2 = verify) */
.globl mode
.balign 4
mode:
  .zero 4

/* Message digest. */
.globl msg
.balign 32
msg:
  .zero 32

/* Signature R. */
.globl r
.balign 32
r:
  .zero 32

/* Signature S. */
.globl s
.balign 32
s:
  .zero 32

/* Public key x-coordinate. */
.globl x
.balign 32
x:
  .zero 32

/* Public key y-coordinate. */
.globl y
.balign 32
y:
  .zero 32

/* Private key (d). */
.globl d
.balign 32
d:
  .zero 32

/* Verification result x_r (aka x_1). */
.globl x_r
.balign 32
x_r:
  .zero 32

.section .scratchpad

/* Secret scalar k. */
.globl k
.balign 32
k:
  .zero 32

/* Random number for blinding. */
.globl rnd
.balign 32
rnd:
  .zero 32
