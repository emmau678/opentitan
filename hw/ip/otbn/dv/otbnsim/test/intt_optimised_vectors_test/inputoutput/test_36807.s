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

    /* Load v_vec into w30 */
    la         x1, v_vec
    addi       x3, x0, 30
    BN.LID     x3, 0(x1)

    /* Load barrett_add_vec into w31 */
    la         x1, barrett_add_vec
    addi       x3, x0, 31
    BN.LID     x3, 0(x1)

    /* Load mask with low 64 bits of each 128 bits set */
    la         x1, len4mask
    addi       x3, x0, 17
    BN.LID     x3, 0(x1)

    /* Load mask with low 128 bits set */
    la         x1, mask_128b
    addi       x3, x0, 24
    BN.LID     x3, 0(x1)         /* w24 has mask with the low 128 bits set */
    BN.NOT     w25, w24          /* w25 has mask with the upper 128 bits set */
    
    la         x1, mask_16b
    lw         x26, 0(x1)

    addi       x4, x0, 252         /* x4 : k */
    addi       x6, x0, 0         /* x6 : offset to next block */
    addi       x14, x0, 32      /* x14: len(*2) */
    addi       x29, x0, 16
    addi       x5, x0, 0         /* x5: loop ctr */

    addi       x17, x0, 256        /* x17: loop_len lim */
    addi       x25, x0, 512         /* lim start */
    addi       x21, x0, 4

/******************************************LEN=2*******************************************************/

    addi       x20, x0, 15       /* x20: inner looplim */

    /* Load mask with low 32 bits of each 64 bits set */
    la         x1, len2mask
    addi       x3, x0, 17
    BN.LID     x3, 0(x1)

    /* Load mask with low 64 bits set */
    la         x1, mask_64b
    addi       x3, x0, 25
    BN.LID     x3, 0(x1)         /* w25 has mask with the low 64 bits set */

    addi       x5, x0, 0         /* x5 : inner loop ctr */
    addi       x6, x0, 0

loopj_len2:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w25 /* limit to the lower 64 bits */
    BN.LSHI         w24, w0, w25 >> 64      /* shift 64-bit mask to next z */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24 /* limit to the lower 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64      /* shift 64-bit mask to next z */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 32

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.AND          w12, w12, w17
    BN.LSHI         w12, w0, w12 >> 32
    BN.AND          w22, w22, w17

    BN.XOR          w12, w12, w22

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
    and        x8, x28, x26

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w25 /* limit to the lower 64 bits */
    BN.LSHI         w24, w0, w25 >> 64      /* shift 64-bit mask to next z */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24 /* limit to the lower 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64      /* shift 64-bit mask to next z */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w24   /* limit to the relevant 64 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    BN.LSHI         w24, w0, w24 >> 64    /* shift 64-bit mask to next z */

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 32

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.AND          w12, w12, w17
    BN.LSHI         w12, w0, w12 >> 32
    BN.AND          w22, w22, w17

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    /****************************************************LEN=4*********************************************************/

    /* Load mask with low 64 bits of each 128 bits set */
    la         x1, len4mask
    addi       x3, x0, 17
    BN.LID     x3, 0(x1)

    /* Load mask with low 128 bits set */
    la         x1, mask_128b
    addi       x3, x0, 24
    BN.LID     x3, 0(x1)         /* w24 has mask with the low 128 bits set */
    BN.NOT     w25, w24          /* w25 has mask with the upper 128 bits set */

    addi       x6, x0, 0         /* x6 : offset to next block */
    addi       x5, x0, 0         /* x5 : inner loop ctr */

loopj_len4:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w24 /* limit to the lower 128 bits */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w25   /* limit to the upper 128 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 64

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.AND          w12, w12, w17
    BN.LSHI         w12, w0, w12 >> 64
    BN.AND          w22, w22, w17

    BN.XOR          w12, w12, w22

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
    and        x8, x28, x26

    BN.BROADCAST    w4, x8
    BN.AND          w4, w4, w24 /* limit to the lower 128 bits */

    sub        x4, x4, x21         /* k-- */

    /* load next zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w15, x8
    BN.AND          w15, w15, w25   /* limit to the upper 128 bits */
    BN.XOR          w4, w4, w15     /* combine the zetas */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    BN.RSHI    w5, w0, w12 >> 64

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.AND          w12, w12, w17
    BN.LSHI         w12, w0, w12 >> 64
    BN.AND          w22, w22, w17

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)
    

/****************************************************LEN=8*********************************************************/

    addi       x20, x0, 7       /* x20: inner looplim */
    addi       x6, x0, 0         /* x6 : offset to next block */
    addi       x5, x0, 0         /* x5 : inner loop ctr */

loopj_len8:

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8

    sub        x4, x4, x21         /* k-- */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 128

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.LSHI         w12, w0, w12 >> 128
    BN.AND          w22, w22, w24

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1

    /* load zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 128

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.LSHI         w12, w0, w12 >> 128
    BN.AND          w22, w22, w24

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32

    bne        x5, x20, loopj_len8

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8

    sub        x4, x4, x21         /* k-- */
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 128

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.LSHI         w12, w0, w12 >> 128
    BN.AND          w22, w22, w24

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1

    /* load zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8
    
    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] (next block) */
    la         x1, r
    add        x1, x1, x6
    addi       x1, x1, 32
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] (next block) elements are in w5 */
    BN.RSHI    w5, w5, w12 >> 128

    BN.ADDVEC       w6, w12, w5

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16    /* w7: rjlenlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjlenupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    BN.LSHI         w12, w0, w12 >> 128
    BN.AND          w22, w22, w24

    BN.XOR          w12, w12, w22

    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

/************************************************LEN={16,32,64}****************************************************/

    addi       x20, x0, 1        /* x20: inner looplim */

looplen_mul16:

    addi       x19, x0, 0        /* x19 : start */

loopstart_mul16:

    add        x6, x0, x19       /* x6 : offset to next block */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    sub        x4, x4, x21         /* k-- */
    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_mul16:

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    BN.ADDVEC       w6, w12, w5   /* w6: rjvec + rjlenvec (barrett arg) */

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    /* r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    /* r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_mul16

    add        x19, x19, x14
    add        x19, x19, x14
    add        x6, x0, x19       /* x6 : offset to next block */

    /* load zeta and broadcast */
    srli       x8, x28, 16

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_mul16b:

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    BN.ADDVEC       w6, w12, w5   /* w6: rjvec + rjlenvec (barrett arg) */

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    /* r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    /* r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_mul16b

    add        x19, x19, x14
    add        x19, x19, x14
    bne        x19, x25, loopstart_mul16

    slli       x20, x20, 1
    slli       x14, x14, 1            /* len >>= 1 */
    bne        x14, x17, looplen_mul16

/******************************************************LEN=128********************************************************/

    add        x6, x0, x0       /* x6 : offset to next block */

    /* load zeta and broadcast */
    la         x1, zetas         /* Load base address of zetas from memory */
    add        x2, x1, x4        /* x1 : base address of zetas plus offset to element */
    lw         x28, 0(x2)         /* load word 32 bits */
    and        x8, x28, x26

    BN.BROADCAST    w4, x8       /* broadcast zeta across w4 */

    sub        x4, x4, x21         /* k-- */
    addi       x5, x0, 0         /* x5: loop_j ctr */

loopj_len128:

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)         /* r[j] elements are in w12 */

    /* Load r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j + len] elements are in w5 */

    BN.ADDVEC       w6, w12, w5   /* w6: rjvec + rjlenvec (barrett arg) */

    BN.LSHIFTVEC    w7, w6, 16
    BN.RSHIFTVEC    w7, w7, 16   /* w7: rjlow16vec */
    BN.RSHIFTVEC    w8, w6, 16   /* w8: rjupp16vec */

    /* barrett reduction */

    /* barrett reduction for tl */
    BN.MULVEC       w21, w7, w30     /* rjlow16vec*v_vec */
    BN.ADDVEC       w21, w21, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w21, w21, 26
    BN.MULVEC       w21, w21, w1

    BN.AND          w21, w21, w3

    /* barrett reduction for tu */
    BN.MULVEC       w10, w8, w30
    BN.ADDVEC       w10, w10, w31    /* (rjlow16vec*v_vec) + (1<<25) */
    BN.ARSHIFTVEC    w10, w10, 26
    BN.MULVEC       w10, w10, w1

    BN.AND          w10, w10, w3
    BN.LSHIFTVEC    w11, w10, 16
    BN.XOR          w22, w11, w21
    BN.SUBVEC       w22, w6, w22

    /* full barrett reduction done */

    BN.SUBVEC       w5, w5, w12  /* w5: r[j+len] - t */

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

    /* r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 22
    BN.SID     x3, 0(x1)

    /* r[j + len] */
    la         x1, r
    add        x1, x1, x6
    add        x1, x1, x14
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loopj_len128

/*****************************************FINAL LOOP************************************************/

    add        x6, x0, x0       /* x6 : offset to next block */

    addi       x8, x0, 1441

    BN.BROADCAST    w4, x8       /* broadcast f across w4 */

    addi       x20, x0, 16
    addi       x5, x0, 0         /* x5: loop_j ctr */

loop_final:

    /* Load r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)         /* r[j] elements are in w5 */

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

    /* r[j] */
    la         x1, r
    add        x1, x1, x6
    addi       x3, x0, 12
    BN.SID     x3, 0(x1)

    addi       x6, x6, 32
    addi       x5, x5, 1
    bne        x5, x20, loop_final

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
    .word 0xfa7ffccd
    .word 0xffecfcc6
    .word 0xfa86ff8a
    .word 0x0065ff79
    .word 0x01daffab
    .word 0xfbf002ad
    .word 0xfbb1028f
    .word 0xffd3fa27
    .word 0x0418ff43
    .word 0xff24ff54
    .word 0xf994fcd5
    .word 0x00ddfda1
    .word 0x05ad0409
    .word 0xfeb8ff76
    .word 0xfe940517
    .word 0x0412ff74
    .word 0xf9bf0619
    .word 0x031003d7
    .word 0xfddc0188
    .word 0xfad705c3
    .word 0x0523066b
    .word 0x02ec00ac
    .word 0x035c0324
    .word 0xfba6fc1a
    .word 0xfc94fcb5
    .word 0x05a1fe39
    .word 0x03adfb23
    .word 0xfe55fa28
    .word 0x067702f4
    .word 0x04330102
    .word 0x00780266
    .word 0x03580394
    .word 0x0185ffe7
    .word 0x0014044a
    .word 0xfc08fdac
    .word 0xfbfc0607
    .word 0xfa870680
    .word 0x03e9fdd5
    .word 0x001f0125
    .word 0xffaa03ad
    .word 0xfa610280
    .word 0x02b5feb2
    .word 0x04dcfd69
    .word 0x065aff85
    .word 0xfd1cff4a
    .word 0xff23ff5d
    .word 0xfc90fc03
    .word 0x01e40067
    .word 0x04e903c6
    .word 0xfc84fedd
    .word 0xff88fed5
    .word 0x0379fd2e
    .word 0x0413010b
    .word 0x035f0545
    .word 0xfd1105d9
    .word 0x033003ef
    .word 0xfa2f0596
    .word 0xff6c04c0
    .word 0x0632fb76
    .word 0x0289f9af
    .word 0xfad9faa6
    .word 0x03a4ff17
    .word 0xfdfafb4e
    .word 0xfe11fb06
    .word 0xfa17fae4
    .word 0x03cb0237
    .word 0xff860342
    .word 0x019a024c
    .word 0x026dffa3
    .word 0x03eb0228
    .word 0xfb13fe93
    .word 0x0600fff7
    .word 0x023dfeab
    .word 0x00f0fc5c
    .word 0xf9900255
    .word 0xff6afca2
    .word 0xf9d902af
    .word 0xfbf805f0
    .word 0x0654ff0c
    .word 0x000bfe68
    .word 0x01c902fa
    .word 0xfd130664
    .word 0xf99d059c
    .word 0x000601ed
    .word 0x02db05ca
    .word 0xfff8fcdc
    .word 0xff990518
    .word 0x01330002
    .word 0xff59fbdc
    .word 0xff23049d
    .word 0x00d80580
    .word 0x002000b7
    .word 0x031cfc06
    .word 0x019dfc95
    .word 0xfe3102ad
    .word 0x022d0016
    .word 0x04e10675
    .word 0x0039ffcd
    .word 0xfa790398
    .word 0xfd2a0579
    .word 0x0590fc1d
    .word 0x016afefb
    .word 0x050b020f
    .word 0x018dfff2
    .word 0xfb2701f0
    .word 0xffb10335
    .word 0xfe77fa31
    .word 0xffbffc46
    .word 0xffdffcd9
    .word 0x01fa0618
    .word 0xff680119
    .word 0xfa1204e0
    .word 0xfeb0fc1a
    .word 0x023705a4
    .word 0xfb37fa2e
    .word 0x0422fbbd
    .word 0x018afc8d
    .word 0x0502049f
    .word 0xfbcc065c
    .word 0x021bfed5
    .word 0xfc2cf994
    .word 0xffe2fb1f
    .word 0x00c50211
    .word 0xff7a02f9
    .word 0xfea004f2
    .word 0x059a00f9
    .word 0x0148fa83
    .word 0x01f4fec1


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

    .balign 32
    v_vec:
    .dword 0x00004ebf00004ebf
    .dword 0x00004ebf00004ebf
    .dword 0x00004ebf00004ebf
    .dword 0x00004ebf00004ebf

    .balign 32
    barrett_add_vec:
    .dword 0x0200000002000000
    .dword 0x0200000002000000
    .dword 0x0200000002000000
    .dword 0x0200000002000000
