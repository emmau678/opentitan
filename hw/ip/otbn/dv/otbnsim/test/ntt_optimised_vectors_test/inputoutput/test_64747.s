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
    .word 0x04ac0b44
    .word 0x074d013b
    .word 0x04f409cb
    .word 0x092e05ce
    .word 0x01280aec
    .word 0x06f908a6
    .word 0x0a700810
    .word 0x08b90aff
    .word 0x017300ca
    .word 0x0b060218
    .word 0x06120166
    .word 0x079b007c
    .word 0x0a1c07e3
    .word 0x088201c1
    .word 0x012e098d
    .word 0x0b4d0c1a
    .word 0x01070aff
    .word 0x06b50ca3
    .word 0x071d04e4
    .word 0x07dc03c9
    .word 0x063902fc
    .word 0x06870a6a
    .word 0x0239028a
    .word 0x04c009d8
    .word 0x0659081d
    .word 0x0c1404fe
    .word 0x008206cf
    .word 0x0be00cb6
    .word 0x0ce00c21
    .word 0x09b405ad
    .word 0x00920361
    .word 0x04820162
    .word 0x0385080a
    .word 0x016f0089
    .word 0x07710ae2
    .word 0x083403c9
    .word 0x0cac0aab
    .word 0x001a096f
    .word 0x0b260c55
    .word 0x05bd00dd
    .word 0x09bd08f4
    .word 0x00d70579
    .word 0x08170410
    .word 0x020b0229
    .word 0x07bc02c1
    .word 0x04b0005b
    .word 0x0bc60263
    .word 0x0a3609c4
    .word 0x0514098d
    .word 0x048c082a
    .word 0x04990653
    .word 0x0b7b058d
    .word 0x0ce4090b
    .word 0x051e04e7
    .word 0x05690085
    .word 0x0a67013f
    .word 0x05aa002e
    .word 0x0a460ccd
    .word 0x0b1d0cb0
    .word 0x0ae20186
    .word 0x011809d8
    .word 0x05d703ed
    .word 0x0c55026d
    .word 0x02560a6a
    .word 0x04cd0b03
    .word 0x0183077b
    .word 0x01760142
    .word 0x0aef07d6
    .word 0x0ac80c0d
    .word 0x04d000dd
    .word 0x009904cd
    .word 0x07c6080d
    .word 0x0a6700b0
    .word 0x0a05080d
    .word 0x07c9058d
    .word 0x0c0005f5
    .word 0x043b0b37
    .word 0x0914044e
    .word 0x0ba805ee
    .word 0x09b708c6
    .word 0x060f091b
    .word 0x00f7070c
    .word 0x009c0496
    .word 0x06cb0bfd
    .word 0x09bd00c0
    .word 0x066003a2
    .word 0x0baf02e8
    .word 0x04d3034d
    .word 0x010b02e5
    .word 0x08340932
    .word 0x0b9b0048
    .word 0x0a3309fb
    .word 0x066008dd
    .word 0x01de013b
    .word 0x02c80b2d
    .word 0x0a5a0455
    .word 0x07100acb
    .word 0x0a9b0966
    .word 0x09f50169
    .word 0x06c2086b
    .word 0x0309030c
    .word 0x07370407
    .word 0x06ae0a02
    .word 0x083e07d3
    .word 0x03d60af6
    .word 0x076708da
    .word 0x0a3304bd
    .word 0x051803e3
    .word 0x0bbf0751
    .word 0x02ae0c2e
    .word 0x08d30b5a
    .word 0x05fe0807
    .word 0x083e03ac
    .word 0x0ab5007f
    .word 0x09aa05a7
    .word 0x00f105ad
    .word 0x08bd0a70
    .word 0x07030a36
    .word 0x07f301f5
    .word 0x0aa40c8f
    .word 0x0bdc085e
    .word 0x01fe02be
    .word 0x065d07c9
    .word 0x04c604a9
    .word 0x06f603f0
    .word 0x00850a77
    .word 0x0c2109ce
    .word 0x08370a40


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
