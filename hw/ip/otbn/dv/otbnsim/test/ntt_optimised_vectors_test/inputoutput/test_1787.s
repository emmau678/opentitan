.text

    /* Load Q from memory */
    la         x1, q
    lw         x2, 0(x1)
    BN.BROADCAST    w1, x2       /* broadcast KYBER_Q across w1 */

    /* Load QINV from memory */
    la         x1, qinv
    lw         x2, 0(x1)
    BN.BROADCAST    w2, x2       /* broadcast QINV across w2. correct but only sign-extended to 16b, not 32 */

    /* Load mask with low 16 bits set */
    la         x1, mask_low16
    addi       x3, x0, 3
    BN.LID     x3, 0(x1)         /* w3 has mask with the low 16 bits of each 32-bit word set only. correct */

    la         x1, mask_16b
    lw         x26, 0(x1)

    addi       x20, x0, 8        /* x20: inner loop_j lim */
    addi       x14, x0, 256      /* x14: len */
    addi       x17, x0, 16        /* x17: loop_len lim */
    addi       x25, x0, 512         /* lim start */

/************************************************LEN=128****************************************************/

    add        x6, x0, 0       /* x6 : offset to next block */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    addi       x4, x0, 4         /* k++ */
    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_len128:

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 6
    BN.LID     x3, 0(x1)         /* r[j] elements are in w6 */

    BN.LSHIFTVEC    w7, w5, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w5, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7   /* fqmul arg: a = a*b */
    BN.MULVEC32     w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29
    BN.RSHIFTVEC    w21, w20, 16

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32     w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16
    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w6, w12
    BN.ADDVEC       w22, w6, w12

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 13
    BN.SID     x3, 0(x1)

    /* r[j] = r[j] + t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_len128

    add        x19, x19, x14
    add        x19, x19, x14

    srli       x20, x20, 1
    srli       x14, x14, 1            /* len >>= 1 */

/************************************************LEN={64,32,16}****************************************************/

looplen_mul16:

    addi       x19, x0, 0        /* x19 : start */

loopstart_mul16:

    add        x6, x0, x19       /* x6 : offset to next block */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16
    add        x29, x8, x0

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    addi       x4, x4, 4         /* k++ */
    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_mul16:

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 6
    BN.LID     x3, 0(x1)         /* r[j] elements are in w6 */

    BN.LSHIFTVEC    w7, w5, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w5, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7   /* fqmul arg: a = a*b */
    BN.MULVEC32     w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29
    BN.RSHIFTVEC    w21, w20, 16

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32     w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16
    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w6, w12
    BN.ADDVEC       w22, w6, w12

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 13
    BN.SID     x3, 0(x1)

    /* r[j] = r[j] + t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_mul16

    add        x19, x19, x14
    add        x19, x19, x14
    add        x6, x0, x19       /* x6 : offset to next block */

    /* load zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_mul16b:

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 6
    BN.LID     x3, 0(x1)         /* r[j] elements are in w6 */

    BN.LSHIFTVEC    w7, w5, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w5, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7   /* fqmul arg: a = a*b */
    BN.MULVEC32     w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29
    BN.RSHIFTVEC    w21, w20, 16

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32     w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16
    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w6, w12
    BN.ADDVEC       w22, w6, w12

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 13
    BN.SID     x3, 0(x1)

    /* r[j] = r[j] + t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_mul16b

    add        x19, x19, x14
    add        x19, x19, x14
    bne        x19, x25, loopstart_mul16

    srli       x20, x20, 1
    srli       x14, x14, 1            /* len >>= 1 */
    bne        x14, x17, looplen_mul16

/******************************************LEN=8*******************************************************/

    /* Load mask with low 128 bits set */
    la         x1, mask_128b
    addi       x3, x0, 24
    BN.LID     x3, 0(x1)         /* w24 has mask with the low 128 bits set */
    BN.NOT     w25, w24          /* w25 has mask with the upper 128 bits set */

    addi       x20, x0, 7       /* x20: inner looplim */
    addi       x6, x0, 0         /* x6 : offset to next block */
    addi       x5, x0, 0         /* x5 : inner loop ctr */
    
loopj:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8

    addi       x4, x4, 4         /* k += 1 */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w26, w5 >> 128

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.LSHI         w13, w0, w13 >> 128
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w24

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1

    /* load zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w26, w5 >> 128

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.LSHI         w13, w0, w13 >> 128
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w24

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32

    bne        x5, x20, loopj

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8

    addi       x4, x4, 4

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w26, w5 >> 128

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.LSHI         w13, w0, w13 >> 128
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w24

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    
    /* load zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w0, w5 >> 128

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.LSHI         w13, w0, w13 >> 128
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w24

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

/******************************************LEN=4*******************************************************/

    /* Load mask with low 64 bits of each 128 bits set */
    la         x1, len4mask
    addi       x3, x0, 17
    BN.LID     x3, 0(x1)

    addi       x5, x0, 0         /* x5 : inner loop ctr */
    addi       x6, x0, 0
    addi       x20, x0, 15       /* x20: inner looplim */

loopj_len4:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w24 /* limit to the lower 128 bits */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w25   /* limit to the upper 128 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w26, w5 >> 64

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.AND          w13, w13, w17
    BN.LSHI         w13, w0, w13 >> 64
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w17

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_len4

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w24 /* limit to the lower 128 bits */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w25   /* limit to the upper 128 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] */
    BN.RSHI    w26, w0, w5 >> 64

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.AND          w13, w13, w17
    BN.LSHI         w13, w0, w13 >> 64
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w17

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

/******************************************LEN=2*******************************************************/

    /* Load mask with low 32 bits of each 64 bits set */
    la         x1, len2mask
    addi       x3, x0, 17
    BN.LID     x3, 0(x1)

    /* Load mask with low 64 bits set */
    la         x1, mask_64b
    addi       x3, x0, 25
    BN.LID     x3, 0(x1)         /* w24 has mask with the low 64 bits set */

    addi       x5, x0, 0         /* x5 : inner loop ctr */
    addi       x6, x0, 0

loopj_len2:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w25 /* limit to the lower 64 bits */
    BN.LSHI         w24, w0, w25 >> 64      /* shift 64-bit mask to next z */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* load next zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w26, w5 >> 32

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.AND          w13, w13, w17
    BN.LSHI         w13, w0, w13 >> 32
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w17

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_len2

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w25 /* limit to the lower 64 bits */
    BN.LSHI         w24, w0, w25 >> 64      /* shift 64-bit mask to next z */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* load next zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    addi       x4, x4, 4         /* k += 1 */

    /* load next zeta and broadcast */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w6 */
    BN.RSHI    w26, w0, w5 >> 32

    BN.LSHIFTVEC    w7, w26, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w26, 16   /* w8: rjlenupp16vec */

    /* compute tl = fqmul_simd(zeta32vec, rjlenlow16vec); */
    BN.MULVEC       w9, w4, w7    /* w9: a = a*b */
    BN.MULVEC32       w19, w9, w2     /* t = a*QINV */
    BN.MULVEC       w29, w19, w1    /* t = t*KYBER_Q */
    BN.SUBVEC       w20, w9, w29    /* t = a - (int32_t)t*KYBER_Q */
    BN.RSHIFTVEC    w21, w20, 16    /* t = t >> 16 */

    BN.AND          w21, w21, w3

    /* compute tu = fqmul_simd(zeta32vec, rjlenupp16vec); */
    BN.MULVEC       w10, w4, w8
    BN.MULVEC32       w14, w10, w2
    BN.MULVEC       w14, w14, w1
    BN.SUBVEC       w10, w10, w14
    BN.RSHIFTVEC    w10, w10, 16

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16

    BN.XOR          w12, w11, w21

    BN.SUBVEC       w13, w5, w12    /* rjlennew = _mm256_sub_epi16(rj16vec, t) */
    BN.AND          w13, w13, w17
    BN.LSHI         w13, w0, w13 >> 32
    BN.ADDVEC       w22, w5, w12
    BN.AND          w22, w22, w17

    BN.XOR          w12, w13, w22

    /* r[j + len] = r[j] - t */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    /* Load r array into WDR registers */
    /* Read zeta and r[j+len] into WDRs for processing */
    la         x1, r
    addi       x3, x0, 1
    BN.LID     x3, 0(x1)          /*  w1 should now contain zeta */
    addi       x2, x0, 0

loopi   15, 6
    la         x1, r
    addi       x2, x2, 32
    add        x1, x1, x2
    addi       x3, x3, 1
    BN.LID     x3, 0(x1)

end:
    ecall

.data

    .balign 32
    r:
    .data
    .word 0x06c8059d
    .word 0x0bb5054f
    .word 0x07030021
    .word 0x05c70a40
    .word 0x04340ce4
    .word 0x012e06b8
    .word 0x0aff002e
    .word 0x00ca0800
    .word 0x079208b9
    .word 0x010b0273
    .word 0x08210b51
    .word 0x04310225
    .word 0x08850798
    .word 0x054f0b33
    .word 0x0a3c01d7
    .word 0x08d00c82
    .word 0x09e80542
    .word 0x0c550851
    .word 0x0c0a0ad8
    .word 0x073a0716
    .word 0x0b400990
    .word 0x073306f9
    .word 0x0014019d
    .word 0x09f8003e
    .word 0x0afc010b
    .word 0x05210918
    .word 0x09ce0336
    .word 0x03330294
    .word 0x022f084e
    .word 0x025d014c
    .word 0x000d01e8
    .word 0x017605a7
    .word 0x0b570b0c
    .word 0x090105f5
    .word 0x043e0055
    .word 0x07130660
    .word 0x00d00273
    .word 0x03470082
    .word 0x066a064c
    .word 0x0bed0024
    .word 0x057902ff
    .word 0x05c40cfa
    .word 0x09aa00d7
    .word 0x082109a0
    .word 0x045509c7
    .word 0x00340027
    .word 0x0a4307a8
    .word 0x0bf60072
    .word 0x0b51012b
    .word 0x0c370bf0
    .word 0x00d006f6
    .word 0x0af60c34
    .word 0x07670be6
    .word 0x02cb0a6a
    .word 0x03d90c17
    .word 0x08b30b61
    .word 0x01b7055c
    .word 0x0a840872
    .word 0x0681050b
    .word 0x089c0424
    .word 0x0cc607a5
    .word 0x0abe0af9
    .word 0x062c0774
    .word 0x08990c14
    .word 0x0027072a
    .word 0x06500c89
    .word 0x01070354
    .word 0x0cfe0adc
    .word 0x0996008f
    .word 0x099a0b2a
    .word 0x002e04f7
    .word 0x04960cd3
    .word 0x004809e8
    .word 0x046f085e
    .word 0x075e0a5d
    .word 0x00f10969
    .word 0x02870889
    .word 0x060f034d
    .word 0x04a30785
    .word 0x00030659
    .word 0x0ca90451
    .word 0x013b0aa8
    .word 0x07d90545
    .word 0x007f08b6
    .word 0x032003b9
    .word 0x09e809d1
    .word 0x09210a49
    .word 0x010404bd
    .word 0x07d307b5
    .word 0x079209f8
    .word 0x024c08d0
    .word 0x06770976
    .word 0x0abe082a
    .word 0x08c0015c
    .word 0x05d105ba
    .word 0x02250538
    .word 0x00b0075a
    .word 0x01d70636
    .word 0x0b9b0027
    .word 0x07f3079b
    .word 0x0b9b03f3
    .word 0x0b44069b
    .word 0x03d30333
    .word 0x057c0bb5
    .word 0x02bb0c5e
    .word 0x0c3e0a56
    .word 0x092e04da
    .word 0x0b09091e
    .word 0x0bf30a12
    .word 0x007c039f
    .word 0x0ae50336
    .word 0x0ce00395
    .word 0x049909f5
    .word 0x027d0525
    .word 0x0344061f
    .word 0x0104003e
    .word 0x0ad8007f
    .word 0x08170229
    .word 0x00410559
    .word 0x022f0adc
    .word 0x0a700c2a
    .word 0x05800b5a
    .word 0x0c3700b9
    .word 0x043b0733
    .word 0x02f9036e
    .word 0x046b0c00
    .word 0x0b16030f
    .word 0x0ca9042e


    .balign 32
    zetas:
    .word 0xfbecfd0a
    .word 0xfe99fa13
    .word 0x05d5058e
    .word 0x011f00ca
    .word 0xff55026e
    .word 0x062900b6
    .word 0x03c2fb4e
    .word 0xfa3e05bc
    .word 0x023dfad3
    .word 0x0108017f
    .word 0xfcc305b2
    .word 0xf9beff7e
    .word 0xfd5703f9
    .word 0x02dc0260
    .word 0xf9fa019b
    .word 0xff33f9dd
    .word 0x04c7028c
    .word 0xfdd803f7
    .word 0xfaf305d3
    .word 0xfee6f9f8
    .word 0x0204fff8
    .word 0xfec0fd66
    .word 0xf9aefb76
    .word 0x007e05bd
    .word 0xfcabffa6
    .word 0xfef1033e
    .word 0x006bfa73
    .word 0xff09fc49
    .word 0xfe7203c1
    .word 0xfa1cfd2b
    .word 0x01c0fbd7
    .word 0x02a5fb05
    .word 0xfbb101ae
    .word 0x022b034b
    .word 0xfb1d0367
    .word 0x060e0069
    .word 0x01a6024b
    .word 0x00b1ff15
    .word 0xfeddfe34
    .word 0x06260675
    .word 0xff0a030a
    .word 0x0487ff6d
    .word 0xfcf705cb
    .word 0xfda6045f
    .word 0xf9ca0284
    .word 0xfc98015d
    .word 0x01a20149
    .word 0xff64ffb5
    .word 0x03310449
    .word 0x025b0262
    .word 0x052afafb
    .word 0xfa470180
    .word 0xfb41ff78
    .word 0x04c2fac9
    .word 0xfc9600dc
    .word 0xfb5df985
    .word 0xfb5ffa06
    .word 0xfb02031a
    .word 0xfa1afcaa
    .word 0xfc9a01de
    .word 0xff94fecc
    .word 0x03e403df
    .word 0x03befa4c
    .word 0x05f2065c

    .balign 32
    mask_low16:
    .dword 0x0000ffff0000ffff
    .dword 0x0000ffff0000ffff
    .dword 0x0000ffff0000ffff
    .dword 0x0000ffff0000ffff

    .balign 32
    q:
    .word  0xd01  /* Q = 3329 */
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    one:
    .word  0x1  /* Q = 3329 */
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    z:
    .dword 0xfffffffffffffd0a  /* Q = 3329 */
    .dword 0xffffffffffffffff
    .dword 0xffffffffffffffff
    .dword 0xffffffffffffffff

    .balign 32
    ropp:
    .dword 0xffffffffffff9d83  /* Q = 3329 */
    .dword 0xffffffffffffffff
    .dword 0xffffffffffffffff
    .dword 0xffffffffffffffff

    .balign 32
    qinv:
    .dword  0xfffff301  /* -3327 in 32-bit two's complement */
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_16b:
    .word  0xffff  /* 16 set bits */
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_32b:
    .dword  0xffffffff  /* 32 set bits */
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_64b:
    .dword  0xffffffffffffffff  /* 64 set bits */
    .dword  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_128b:
    .dword  0xffffffffffffffff  /* 32 set bits */
    .dword  0xffffffffffffffff
    .dword 0x0
    .dword 0x0

    .balign 32
    len2mask:
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff

    .balign 32
    len4mask:
    .dword 0xffffffffffffffff
    .dword 0x0
    .dword 0xffffffffffffffff
    .dword 0x0

    .balign 32
    zeta:
    .word  0x0
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    r_j_len:
    .word  0x0
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    t:
    .dword 0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0
