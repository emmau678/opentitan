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
    .word 0x0cd30bb5
    .word 0x04d70b78
    .word 0x0cb30263
    .word 0x07d3081a
    .word 0x0a840092
    .word 0x0966061f
    .word 0x06910a49
    .word 0x07d60545
    .word 0x062200dd
    .word 0x02ab0448
    .word 0x03c90af6
    .word 0x08d00a67
    .word 0x021505a7
    .word 0x09180be3
    .word 0x0a870bfd
    .word 0x013b02d5
    .word 0x06180a12
    .word 0x0b030ce4
    .word 0x011b01a3
    .word 0x098d0b2a
    .word 0x0650093b
    .word 0x02e50302
    .word 0x07d90899
    .word 0x04340b1d
    .word 0x0b5a0b03
    .word 0x06cf0085
    .word 0x0b740938
    .word 0x0c9903e0
    .word 0x0a67068e
    .word 0x0ac807bc
    .word 0x057306a1
    .word 0x0684066d
    .word 0x0b8b0acb
    .word 0x007c0a0c
    .word 0x0ce408fa
    .word 0x0b670ced
    .word 0x04620017
    .word 0x0c170792
    .word 0x0cb90a29
    .word 0x00cd09de
    .word 0x0a390455
    .word 0x0ae90155
    .word 0x04da05ba
    .word 0x04a60104
    .word 0x00ed0085
    .word 0x097c058d
    .word 0x04fa036b
    .word 0x0bf3092b
    .word 0x0bcf00c6
    .word 0x07510a19
    .word 0x035e0b5a
    .word 0x0309003e
    .word 0x05ee0b9b
    .word 0x0cd000c0
    .word 0x008903fa
    .word 0x028d0962
    .word 0x08b6094c
    .word 0x03020a19
    .word 0x01e40697
    .word 0x014f03a5
    .word 0x09aa00c3
    .word 0x07920650
    .word 0x0b370155
    .word 0x064c0336
    .word 0x078b0834
    .word 0x009f0b7e
    .word 0x04e40169
    .word 0x05de06d8
    .word 0x00b303cc
    .word 0x0c140ba8
    .word 0x06b50b78
    .word 0x00340ab5
    .word 0x086b045e
    .word 0x0c440754
    .word 0x037802ec
    .word 0x06ae069b
    .word 0x06be00fa
    .word 0x00b30bf0
    .word 0x02f9010e
    .word 0x003b0827
    .word 0x09110be9
    .word 0x0b6e091e
    .word 0x06dc0b67
    .word 0x001d0bb9
    .word 0x028406d2
    .word 0x09110cd7
    .word 0x054509ff
    .word 0x05420027
    .word 0x0068023c
    .word 0x00bd0a97
    .word 0x003104b0
    .word 0x03e60333
    .word 0x04440169
    .word 0x050b0c31
    .word 0x08b90a50
    .word 0x04ed0b92
    .word 0x05f50101
    .word 0x0c3b094f
    .word 0x05040302
    .word 0x0af2081d
    .word 0x02430bb9
    .word 0x055900a3
    .word 0x03cc0562
    .word 0x020f0cc0
    .word 0x09380837
    .word 0x0a5a0bd3
    .word 0x05c70a1c
    .word 0x01c40817
    .word 0x02bb0c78
    .word 0x010b079f
    .word 0x0b920c92
    .word 0x0cbd0c7c
    .word 0x0b540691
    .word 0x0468017c
    .word 0x0ced0a94
    .word 0x015503b2
    .word 0x02250b5e
    .word 0x0af90666
    .word 0x03950205
    .word 0x029a020b
    .word 0x028d07fa
    .word 0x0a26074d
    .word 0x03fa0284
    .word 0x00da00fe
    .word 0x0cd70189
    .word 0x04780125
    .word 0x08a909c7
    .word 0x061506ab


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
