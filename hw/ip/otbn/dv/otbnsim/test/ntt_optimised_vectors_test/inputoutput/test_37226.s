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
    .word 0x01110596
    .word 0x076409e8
    .word 0x0b4a05f1
    .word 0x09b7085e
    .word 0x031c04b9
    .word 0x0c07087c
    .word 0x025d0aa1
    .word 0x062f0c4b
    .word 0x0ad50c10
    .word 0x0c0a0566
    .word 0x06cb0b44
    .word 0x02320514
    .word 0x08620851
    .word 0x043e013f
    .word 0x09730a4d
    .word 0x0a490576
    .word 0x06660392
    .word 0x08ed0bf0
    .word 0x06fc07fd
    .word 0x082a01db
    .word 0x062f000d
    .word 0x0bf00cf4
    .word 0x07d305e8
    .word 0x08dd025d
    .word 0x08780bcf
    .word 0x0c580cf4
    .word 0x07a8003b
    .word 0x040d0259
    .word 0x03670952
    .word 0x0ad5074a
    .word 0x0b3d049c
    .word 0x03f3021c
    .word 0x07160abe
    .word 0x01d70aff
    .word 0x052e0b06
    .word 0x0b470514
    .word 0x045b002a
    .word 0x01480596
    .word 0x00a305b4
    .word 0x0a530807
    .word 0x09e80612
    .word 0x060200ed
    .word 0x0b540684
    .word 0x0af60489
    .word 0x0a3606f9
    .word 0x0c340096
    .word 0x042105d7
    .word 0x0c820179
    .word 0x0a8707b2
    .word 0x05e4060b
    .word 0x06730121
    .word 0x0b7806b1
    .word 0x00e70c31
    .word 0x07a80a2f
    .word 0x031303b2
    .word 0x02df0a87
    .word 0x09ce02c5
    .word 0x02d8041d
    .word 0x068e021c
    .word 0x067d02df
    .word 0x03bc025d
    .word 0x07d30111
    .word 0x088f0baf
    .word 0x07090ba2
    .word 0x00bd0b2d
    .word 0x045b0478
    .word 0x03e000b6
    .word 0x060b046f
    .word 0x0bcc071d
    .word 0x03950c1a
    .word 0x0c7c0593
    .word 0x041009c1
    .word 0x0b060865
    .word 0x02430cb6
    .word 0x003b09eb
    .word 0x00ac06d5
    .word 0x056c0baf
    .word 0x06870058
    .word 0x09960b33
    .word 0x034a0a0c
    .word 0x06d50c85
    .word 0x003e063f
    .word 0x077b09b0
    .word 0x03a8027d
    .word 0x0b7e0989
    .word 0x02bb0489
    .word 0x069107dc
    .word 0x03af0625
    .word 0x039f0ba8
    .word 0x036b0792
    .word 0x09180ab1
    .word 0x0be60798
    .word 0x01960cc6
    .word 0x0ba802d5
    .word 0x094200cd
    .word 0x0ae90225
    .word 0x09860b23
    .word 0x09c405aa
    .word 0x08920885
    .word 0x0be90371
    .word 0x0cc606f9
    .word 0x0b3d00a9
    .word 0x0a2c033a
    .word 0x02ff0acb
    .word 0x02ab0bd9
    .word 0x035e05fe
    .word 0x0bbc06f2
    .word 0x071d0c4b
    .word 0x038b061f
    .word 0x0b1603d9
    .word 0x04a60c75
    .word 0x07950af6
    .word 0x07470a74
    .word 0x082108d7
    .word 0x006b0955
    .word 0x01b7042e
    .word 0x040308c0
    .word 0x06d806dc
    .word 0x054208f4
    .word 0x03710496
    .word 0x0bb5081d
    .word 0x0a7a0121
    .word 0x080d0670
    .word 0x057c0858
    .word 0x07c9068e
    .word 0x05de02bb
    .word 0x039f0681
    .word 0x084406e9


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
