/* Copyright lowRISC contributors. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

.text
/**
 * Compute the inverse of an odd number modulo 2^{256}.
 *
 *   Returns -m^{-1} mod 2^{256} given odd m
 *
 * This routine runs in constant time.
 *
 * @param[in]:   w0:     odd 256-bit number m
 * @param[out]:  w0:     m0' = -m^{-1} mod 2^{256}
 * clobbered registers:    w1-w2
 * clobbered flag groups:  FG0
 * called subroutines:     -
 */
 .section .text.compute_m0inv2to256
 .balign 4
 .global compute_m0inv2to256
 .type compute_m0inv2to256, @function

compute_m0inv2to256:
  /* As odd numbers are their own inverse mod 8, the input is taken as
      start value for a Newton iteration (quadratic Hensel lifting)
      doubling the precision in each step.
     The code can be adapted to calculate -m^-1 mod 3*2^k by
      increasing the precision of the last round of first loop to
      96 bit, and of the following loops to 192 rsp. 384 bit. */
  bn.mov          w1, w0  /* w0 is its own inverse with 3-bit precision */
  /* double precision via Newton in each round from 2^1 to 2^6 bit */
  loopi           5, 4
    bn.mulqacc.wo.z w2, w1.0, w0.0, 0
    bn.mulqacc.wo.z w2, w1.0, w2.0, 0
    bn.add          w1, w1, w1
    bn.sub          w1, w1, w2
  /* double precision from 64 to 128 bit */
  bn.mov          w2, w0
  loopi           2, 3
    bn.mulqacc.z    w1.0, w2.0, 0
    bn.mulqacc      w1.0, w2.1, 64
    bn.mulqacc.wo   w2, w1.1, w2.0, 64
  bn.add          w1, w1, w1
  bn.sub          w1, w1, w2
  /* double precision from 128 to 256 bit */
  loopi           2, 10
    bn.mulqacc.z    w1.0, w0.0, 0
    bn.mulqacc      w1.0, w0.1, 64
    bn.mulqacc      w1.1, w0.0, 64
    bn.mulqacc      w1.0, w0.2, 128
    bn.mulqacc      w1.1, w0.1, 128
    bn.mulqacc      w1.2, w0.0, 128
    bn.mulqacc      w1.0, w0.3, 192
    bn.mulqacc      w1.1, w0.2, 192
    bn.mulqacc      w1.2, w0.1, 192
    bn.mulqacc.wo   w0, w1.3, w0.0, 192
  bn.add          w1, w1, w1
  bn.sub          w0, w0, w1
  ret
 .size compute_m0inv2to256, .-compute_m0inv2to256

/* Calculate r^2 mod m, where r = 2^{256 k} and 2^{256*k-1} < m < r.
 *
 *   Returns 4^{256*k} mod m given m with 2^{256*k-1} < m < 2^{256*k}
 *
 * This routine runs in constant time (for fixed k).
 *
 * @param[in]:   x10:    pointer to m, the most significant limb of m must be >=2^255
 * @param[in]:   x11:    length k of m in 256-bit-limbs
 * @param[in]:   x12:    pointer to output buffer for r^2 mod m, same size as m
 *
 * @param[out]:  x10:    0 if everything went ok, otherwise 1
 *
 * clobbered registers:    w0-w[3+k-1], x8-x10
 * clobbered flag groups:  FG0, FG1
 * called subroutines:     -
 */
  /* TODO: Montgomery squaring might be faster at some k, as soon r*2^k is known. */
  /* TODO: If a fast long division is available, it might be faster to simply divide. */
  /* TODO: Support for bitlength(m) not a multiple of 256, if necessary. */
 .section .text.compute_rr_sample
 .balign 4
 .global compute_rr_sample
 .type compute_rr_sample, @function

compute_rr_sample:
  /* Load m into registers starting at w3 */
  /*  and write its 2-complement to output buffer */
  li          x8, 3           /* -> w3 */
  add         x9, x12, x0     /* -> output buffer */
  bn.sub      w1, w1, w1      /* Clear w1 and carry FG0.C */
  loop        x11, 4
    bn.lid      x0, 0(x10++)    /* load next limp of m to w0 */
    bn.movr     x8++, x0        /*  and copy it to registers w3, w4, ... */
    bn.subb     w0, w1, w0      /* calculate m's 2-complement */
    bn.sid      x0, 0(x9++)     /*  and store it in output buffer */
  /* Check that the most significant limb of m is >=2^255 */
  csrrs       x8, 0x7c0, x0   /* FG0 flags from calculating highest limp of 2-complement */
  andi        x9, x8, 2       /* isolate MSB flag */
  beq         x9, x0, m_ok    /*  that is complemented with respect to highest limp of m */
  li          x10, 1          /* Return 1 if error. */
  ret
m_ok:
  /* Now double r repeatedly subtracting or adding m depending on its current sign */
  slli        x10, x11, 8     /* k<<8 = 256*k rounds */
  bn.subi     w1, w1, 1, FG1  /* set FG1.C and set w1=-1 to start with sub */
  loop        x10, 13
    li          x8, 3           /* -> m in w3 */
    add         x9, x12, x0     /* -> intermediate value in output buffer */
    bn.sub      w0, w0, w0, FG0 /* Clear FG0.C */
    loop        x11, 6
      bn.lid      x0, 0(x9)       /* get intermediate value */
      bn.addc     w2, w0, w0, FG0 /*  and shift it by 1 bit */
      bn.movr     x0, x8++        /* get next limb of the shifted modulus in w0 */
      /* TODO: check if w1=0/-1 is visible in power trace and if it matters */
      bn.xor      w0, w0, w1      /*  complementing it when subtracting */
      bn.addc     w0, w2, w0, FG1 /* add/sub m from intermediate value */
      bn.sid      x0, 0(x9++)     /*  and write it to output buffer */
    /* need the majority of three carries given by FG0.C, FG1.C and -w1 */
    bn.subb     w0, w0, w0, FG0 /* -1 if FG0.C=1, otherwise 0 */
    bn.addc     w1, w1, w0, FG1 /* FG1.C is the majority we want */
    bn.subb     w1, w1, w1, FG1 /*  so set w1 accordingly for next round add/sub */
  /* if FG1.C=0/w1=0 then result is negative, so add m to make it positive */
  li          x8, 3           /* -> m in w3 */
  add         x9, x12, x0     /* -> output buffer */
  bn.sub      w1, w1, w1, FG0 /* clear w1 and FG0.C */
  loop        x11, 5
    bn.movr   x0, x8++          /* get next limb of the shifted modulus in w0 */
    bn.sel    w2, w1, w0, FG1.C /* C=1 means already positive, so add 0 */
    bn.lid    x0, 0(x9)         /* get intermediate value */
    bn.addc   w0, w0, w2, FG0   /*  and add m to it, unless already positive */
    bn.sid    x0, 0(x9++)       /* write result */
  add       x10, x0, x0       /* return 0 */
  ret
 .size compute_rr_sample, .-compute_rr_sample

/* Calculate 2*x +/- m, where -m <= x <= m. The maximal bitlength of m is 3072, for
 *  shorter values the entry point of the function is at
 *    compute_rr_unrolled_inner_loop_0bit - 12*k,
 *  where k*256 is the bitlength of m (and x).
 *
 *   Returns 2*x +/- m for given -m <= x <= m.
 *
 * This routine runs in constant time.
 *
 * @param[in]:   w1:                -1 (and FG1.C=1) if x < 0, otherwise 0 (and FG1.C=0)
 * @param[in]:   FG0.C              0
 * @param[in]:   w[..14]            m (for 3072 bit m: w[3..14])
 * @param[in]:   w[..26]            x (for 3072 bit m: w[15..26])
 *
 * @param[out]:  w[..26]            2*x +- m (for 3072 bit m: w[15..26])
 * @param[out]:  -w1, FG0.C, FG1.C  If the majority of these three values is 1, the value
 *                                   returned in w[15..26] is positive, otherwise negative.
 *
 * clobbered registers:    w0, w[15..26]
 * clobbered flag groups:  FG0, FG1
 * called subroutines:     -
 */
 /* If constant time is not needed, the code can be split into two routines called
     depending on FG1.C, where one is adding and the other is subtracting m from 2*r */
compute_rr_unrolled_inner_loop:
compute_rr_unrolled_inner_loop_3072bit:
  bn.addc     w15, w15, w15, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w3, w1          /* switch between add/sub depending on w1 */
  bn.addc     w15, w15, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_2816bit:
  bn.addc     w16, w16, w16, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w4, w1          /* switch between add/sub depending on w1 */
  bn.addc     w16, w16, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_2560bit:
  bn.addc     w17, w17, w17, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w5, w1          /* switch between add/sub depending on w1 */
  bn.addc     w17, w17, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_2304bit:
  bn.addc     w18, w18, w18, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w6, w1          /* switch between add/sub depending on w1 */
  bn.addc     w18, w18, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_2048bit:
  bn.addc     w19, w19, w19, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w7, w1          /* switch between add/sub depending on w1 */
  bn.addc     w19, w19, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_1792bit:
  bn.addc     w20, w20, w20, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w8, w1          /* switch between add/sub depending on w1 */
  bn.addc     w20, w20, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_1536bit:
  bn.addc     w21, w21, w21, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w9, w1          /* switch between add/sub depending on w1 */
  bn.addc     w21, w21, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_1280bit:
  bn.addc     w22, w22, w22, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w10, w1         /* switch between add/sub depending on w1 */
  bn.addc     w22, w22, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_1024bit:
  bn.addc     w23, w23, w23, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w11, w1         /* switch between add/sub depending on w1 */
  bn.addc     w23, w23, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_768bit:
  bn.addc     w24, w24, w24, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w12, w1         /* switch between add/sub depending on w1 */
  bn.addc     w24, w24, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_512bit:
  bn.addc     w25, w25, w25, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w13, w1         /* switch between add/sub depending on w1 */
  bn.addc     w25, w25, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_256bit:
  bn.addc     w26, w26, w26, FG0  /* double r[i] keeping carry in FG0.C */
  bn.xor      w0, w14, w1         /* switch between add/sub depending on w1 */
  bn.addc     w26, w26, w0, FG1   /* add/sub m for updating r[i] */
compute_rr_unrolled_inner_loop_0bit:
  ret
 .size compute_rr_unrolled_inner_loop, .-compute_rr_unrolled_inner_loop

/* Calculate r^2 mod m, where r = 2^{256 k} and 2^{256*k-1} < m < r.
 *
 *   Returns 4^{256*k} mod m given m with 2^{256*k-1} < m < 2^{256*k}
 *
 * This routine runs in constant time (for fixed k).
 *
 * @param[in]:   x10:    pointer to m, the most significant limb of m must be >=2^255
 * @param[in]:   x11:    length k of m in 256-bit-limbs
 * @param[in]:   x12:    pointer to output buffer for r^2 mod m, same size as m
 *
 * @param[out]:  x10:    0 if everything went ok, otherwise 1
 *
 * clobbered registers:    w0-w2, w[14-(k-1)..14], w[26-(k-1)..26], x8-x10
 * clobbered flag groups:  FG0, FG1
 * called subroutines:     compute_rr_unrolled_inner_loop
 */
  /* TODO: Montgomery squaring might be faster at some k, as soon r*2^k is known. */
  /* TODO: If a fast long division is available, it might be faster to simply divide. */
  /* TODO: Support for bitlength(m) not a multiple of 256, if necessary. */
 .section .text.compute_rr_sample_fast
 .balign 4
 .global compute_rr_sample_fast
 .type compute_rr_sample_fast, @function

compute_rr_sample_fast:
  /* Load m and its 2-complement into registers ending in w14 rsp. w26 */
  li          x8, 15          /* -> w15 */
  sub         x8, x8, x11     /* -> w[14-(k-1)] */
  addi        x9, x8, 12      /* -> w[26-(k-1)] */
  bn.sub      w1, w1, w1      /* Clear w1 and carry FG0.C */
  loop        x11, 4
    bn.lid      x0, 0(x10++)    /* load next limp of m to w0 */
    bn.movr     x8++, x0        /*  and copy it to registers ..., w13, w14 */
    bn.subb     w0, w1, w0      /* calculate m's 2-complement */
    bn.movr     x9++, x0        /*  and store it in registers ..., w25, w26 */
  /* Check that the most significant limb of m is >=2^255 */
  csrrs       x8, 0x7c0, x0   /* FG0 flags from calculating highest limp of 2-complement */
  andi        x9, x8, 2       /* isolate MSB flag */
  beq         x9, x0, m_OK    /*  that is complemented with respect to highest limp of m */
  li          x10, 1          /* Return 1 if error. */
  ret
m_OK:
  /* Now double r repeatedly subtracting or adding m depending on its current sign */
  la          x8, compute_rr_unrolled_inner_loop_0bit
  slli        x9, x11, 1      /* 2*k */
  add         x9, x9, x11     /* 3*k */
  slli        x9, x9, 2       /* 12*k */
  sub         x8, x8, x9      /* -> compute_rr_unrolled_inner_loop_(k*256)bit */
  bn.subi     w1, w1, 1, FG1  /* set FG1.C and set w1=-1 to start with sub */
  slli        x10, x11, 8     /* k<<8 = 256*k rounds */
  loop        x10, 5
    bn.sub      w0, w0, w0, FG0 /* Clear FG0.C */
    jalr        x1, x8, 0       /* r = 2*r +- m */
    /* need the majority of three carries given by FG0.C, FG1.C and -w1 */
    bn.subb     w0, w0, w0, FG0 /* -1 if FG0.C=1, otherwise 0 */
    bn.addc     w1, w1, w0, FG1 /* FG1.C is the majority we want */
    bn.subb     w1, w1, w1, FG1 /*  so set w1 accordingly for next round add/sub */
  /* if FG1.C=0/w1=0 then result is negative, so add m to make it positive */
  li          x8, 15          /* -> w15 */
  sub         x8, x8, x11     /* -> w[14-(k-1)] */
  addi        x9, x8, 12      /* -> w[26-(k-1)] */
  bn.sub      w1, w1, w1, FG0 /* clear w1 and FG0.C */
  loop        x11, 5
    bn.movr   x0, x8++          /* get next limb of the shifted modulus in w0 */
    bn.sel    w2, w1, w0, FG1.C /* C=1 means already positive, so add 0 */
    bn.movr   x0, x9++          /* get intermediate value */
    bn.addc   w0, w0, w2, FG0   /*  and add m to it, unless already positive */
    bn.sid    x0, 0(x12++)       /* write result */
  add       x10, x0, x0       /* return 0 */
  ret
 .size compute_rr_sample_fast, .-compute_rr_sample_fast
