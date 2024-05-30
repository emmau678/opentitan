/* The input placeholders will be overwritten by the actual input values */

.text

    /* Load Q from memory */
    la         x1, q
    addi       x3, x0, 6
    BN.LID     x3, 0(x1)          /*  w6 should now contain Q */

    /* Load QINV from memory */
    la         x1, qinv
    addi       x3, x0, 4
    BN.LID     x3, 0(x1)          /*  w4 should now contain QINV */

    /* Load one from memory */
    la         x1, one
    addi       x3, x0, 12
    BN.LID     x3, 0(x1)          /*  w12 should now contain 1b mask */

    /* Load 16-bit mask from memory */
    la         x1, mask_16b
    addi       x3, x0, 5
    BN.LID     x3, 0(x1)          /*  w5 should now contain 16-bit mask */
    la         x1, mask_16b
    lw         x27, 0(x1)

    /* Load 32-bit mask from memory */
    la         x1, mask_32b
    addi       x3, x0, 21
    BN.LID     x3, 0(x1)          /*  w21 should now contain 32-bit mask */

    /* Load 64-bit mask from memory */
    la         x1, mask_64b
    addi       x3, x0, 13
    BN.LID     x3, 0(x1)          /*  w13 should now contain 64-bit mask */

    /* Load 256-bit mask from memory */
    la         x1, mask_256b
    addi       x3, x0, 25
    BN.LID     x3, 0(x1)          /*  w25 should now contain 256-bit mask */

    /* Load 64-bit mask from memory */
    la         x1, mask_64
    addi       x3, x0, 19
    BN.LID     x3, 0(x1)          /*  w19 should now contain 64-bit mask */

    la         x1, mask_upper26
    addi       x3, x0, 20
    BN.LID     x3, 0(x1)

    /* Load v into w30 */
    la         x1, v
    addi       x3, x0, 30
    BN.LID     x3, 0(x1)

    /* Load 1<<25 into w16 */
    la         x1, barrett_add_vec
    addi       x3, x0, 16
    BN.LID     x3, 0(x1)

    /* Initialise variables */
    addi       x7, x0, 127        /* x7 : k */
    addi       x8, x0, 2          /* x8 : len */
    addi       x25, x0, 256       /* lim start */
    addi       x15, x0, 1         /* lim len */

looplen:
    addi       x9, x0, 0          /* x9 : start */

loopstart:
    add        x11, x0, x9        /* x11 : j = start */

    /* Load zeta into x20 */
    la         x1, zetas          /* Load base address of zetas from memory */
    srai       x13, x7, 1
    slli       x13, x13, 2        /* x13 : k*2 ... offset to element in zetas */
    add        x2, x1, x13        /* x1 : base address of zetas plus offset to element */
    lw         x20, 0(x2)         /* load word 32 bits */
    and        x18, x7, 1         /* k mod 2 */
    xor        x17, x18, 1        /* inverse */
    slli       x23, x18, 4        /* shift idx left by 4 */
    slli       x24, x17, 4
    srl        x20, x20, x24
    sll        x20, x20, x23
    srl        x20, x20, x23

    addi       x7, x7, -1
    BN.ADDI     w17, w0, 0

    add        x31, x9, x8          /* x31: start + len */
loopj_init:

    /* Load r[j + len] into x16 */
    la         x1, r              /* Load base address of r from memory */
    add        x12, x11, x8       /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13        /* x1 : base address of r plus offset to element */
    lw         x26, 0(x2)
    and        x18, x12, 1        /* (j + len) mod 2 */
    xor        x17, x18, 1        /* inverse */
    slli       x23, x18, 4        /* shift idx left by 4 */
    slli       x24, x17, 4        /* shift idx inverse left by 4 */
    srl        x16, x26, x23
    sll        x16, x16, x24
    srl        x16, x16, x24

    sll        x28, x27, x24
    add        x29, x0, x26
    and        x26, x26, x28      /* isolate the opposite sub-block */

    /* Load r[j] into x19 */
    la         x1, r              /* Load base address of r from memory */
    srai       x13, x11, 1
    slli       x13, x13, 2        /* x13 : j*2 ... offset to element in r */
    add        x2, x1, x13        /* x1 : base address of r plus offset to element */
    lw         x5, 0(x2)          /* load word 32 bits */
    and        x18, x11, 1        /* j mod 2 */
    xor        x17, x18, 1        /* inverse */
    slli       x18, x18, 4        /* shift idx left by 4 */
    slli       x17, x17, 4        /* shift idx inverse left by 4 */
    srl        x19, x5, x18
    sll        x19, x19, x17
    srl        x19, x19, x17

    sll        x28, x27, x17
    add        x29, x0, x5
    and        x5, x5, x28
    
    /* Store zeta, r[j] and r[j+len] in memory as params */
    la         x1, zeta
    sw         x20, 0(x1)
    la         x1, r_j
    sw         x19, 0(x1)
    la         x1, r_j_len
    sw         x16, 0(x1)
    sub        x13, x16, x19
    and        x13, x13, x27
    la         x1, r_j_len_sub_r_j
    sw         x13, 0(x1)

    /* Read zeta, r[j] and r[j+len] into WDRs for processing */
    la         x1, zeta
    addi       x3, x0, 1
    BN.LID     x3, 0(x1)          /*  w1 should now contain zeta */

    /* Load inputs from memory */
    la         x1, r_j
    addi       x3, x0, 14
    BN.LID     x3, 0(x1)          /*  w14 should now contain r_j */

    /* Load inputs from memory */
    la         x1, r_j_len
    addi       x3, x0, 2
    BN.LID     x3, 0(x1)          /*  w2 should now contain r_j_len */

    la         x1, r_j_len_sub_r_j
    addi       x3, x0, 26
    BN.LID     x3, 0(x1)          /* w26 = r[j + len] - r[j] */

    /* sign extend these numbers */

    BN.RSHI     w11, w0, w1 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w1, w11, w1

    BN.RSHI     w11, w0, w14 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w14, w11, w14

    BN.RSHI     w11, w0, w2 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w2, w11, w2

    BN.RSHI     w11, w0, w26 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0
    BN.XOR      w26, w11, w26

    BN.ADD           w15, w14, w2   /* w15 (barrett_arg): t + r[j+len] */
    BN.AND           w15, w15, w5
    BN.RSHI     w11, w0, w15 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0
    BN.XOR      w15, w11, w15


    /* barrett reduction */
    BN.MULQACC.WO.Z  w22, w15.0, w30.0, 0
    BN.ADD           w22, w22, w16
    BN.AND           w22, w22, w21
    BN.RSHI          w22, w0, w22 >> 26
    BN.RSHI          w11, w0, w22 >> 5
    BN.AND           w11, w11, w12          /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w20.0, w11.0, 0 
    BN.XOR           w23, w11, w22

    BN.MULQACC.WO.Z  w22, w23.0, w6.0, 0    /* w22: t *= KYBER_Q */
    BN.AND           w23, w22, w5

    BN.SUB           w22, w15, w23
    /* barrett reduction complete */

    BN.MULQACC.WO.Z  w10, w1.0, w26.0, 0    /* fqmul(zeta, r[j+len]) => w1 = a */

    BN.AND     w9, w5, w10                  /*  (int16_t)a */

    BN.MULQACC.WO.Z  w3, w9.0, w4.0, 0      /* t = (int16_t)a * QINV */
    BN.AND           w3, w3, w5             /* (int32_t)t */

    BN.RSHI     w18, w0, w3 >> 15 
    BN.AND      w11, w18, w12               /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w3, w11, w3

    BN.MULQACC.WO.Z  w8, w3.0, w6.0, 0      /* (int32_t)t * KYBER_Q */

    BN.SUB           w7, w10, w8            /* a - (int32_t)t*KYBER_Q */
    BN.RSHI          w7, w0, w7 >> 16
    BN.AND           w7, w7, w5             /* w7 = (int16t)((a - t*Q)>>16) */

    /* Store result t to memory */
    la         x1, t
    addi       x3, x0, 7                    /* reference to w7, which holds the result */
    BN.SID     x3, 0(x1)

    /* Store result to memory */
    la         x1, r_j_new
    addi       x3, x0, 22                   /* reference to w22, which holds new value of r[j] */
    BN.SID     x3, 0(x1)

    /* Load t into x21 */
    la         x1, t
    lw         x21, 0(x1)                   /* load word 32 bits */

    /* Load r_j_new into x22 */
    la         x1, r_j_new
    lw         x22, 0(x1)                   /* load word 32 bits */

    /* construct the block for overwriting r[j + len] in memory */
    sll        x28, x27, x23
    sll        x21, x21, x23
    and        x21, x21, x28
    xor        x3, x21, x26

    /* overwrite r[j + len] */
    la         x1, r              /* Load base address of r from memory */
    add        x12, x11, x8       /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13
    sw         x3, 0(x2)

    /* construct the block for overwriting r[j] in memory */
    sll        x28, x27, x18
    sll        x24, x22, x18
    and        x24, x24, x28
    xor        x18, x24, x5

    /* overwrite r[j] */
    la         x1, r              /* Load base address of r from memory */
    addi       x12, x11, 0        /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13
    sw         x18, 0(x2)

    addi       x11, x11, 1
    bne        x11, x31, loopj_init

    add        x9, x11, x8          /* start = j + len */
    bne        x9, x25, loopstart

    slli       x8, x8, 1            /* len >>= 1 */
    bne        x8, x25, looplen

    /* Final loop */

    addi       x11, x0, 0         /* j = 0 */
    la         x1, f
    addi       x3, x0, 2
    BN.LID     x3, 0(x1)          /*  w2 should now contain f */

loop_all_els_end:

    /* Load r[j] into x19 */
    la         x1, r              /* Load base address of r from memory */
    srai       x13, x11, 1
    slli       x13, x13, 2        /* x13 : j*2 ... offset to element in r */
    add        x2, x1, x13        /* x1 : base address of r plus offset to element */
    lw         x5, 0(x2)          /* load word 32 bits */
    and        x18, x11, 1        /* j mod 2 */
    xor        x17, x18, 1        /* inverse */
    slli       x18, x18, 4        /* shift idx left by 4 */
    slli       x17, x17, 4        /* shift idx inverse left by 4 */
    srl        x19, x5, x18
    sll        x19, x19, x17
    srl        x19, x19, x17

    sll        x28, x27, x17
    add        x29, x0, x5
    and        x5, x5, x28

    la         x1, r_jtmp
    sw         x19, 0(x1)

    /* Load r[j] from memory */
    la         x1, r_jtmp
    addi       x3, x0, 1
    BN.LID     x3, 0(x1)          /*  w1 should now contain r_j */

    BN.RSHI     w11, w0, w1 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w1, w11, w1

    BN.RSHI     w11, w0, w2 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w2, w11, w2

    BN.MULQACC.WO.Z  w10, w1.0, w2.0, 0    /* w1 = a */


    BN.AND     w9, w5, w10                 /*  (int16_t)a */

    BN.MULQACC.WO.Z  w3, w9.0, w4.0, 0     /* t = (int16_t)a * QINV */
    BN.AND           w3, w3, w5            /* (int32_t)t */

    BN.RSHI     w18, w0, w3 >> 15 
    BN.AND      w11, w18, w12              /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w3, w11, w3

    BN.MULQACC.WO.Z  w8, w3.0, w6.0, 0     /* (int32_t)t * KYBER_Q */

    BN.SUB           w7, w10, w8           /* a - (int32_t)t*KYBER_Q */
    BN.RSHI          w7, w0, w7 >> 16 
    BN.AND           w7, w7, w5            /* w7 = (int16t)((a - t*Q)>>16) */

    /* Store result t to memory */
    la         x1, t
    addi       x3, x0, 7                   /* reference to w7, which holds the result */
    BN.SID     x3, 0(x1)

    /* Load t into x21 */
    la         x1, t
    lw         x22, 0(x1)                  /* load word 32 bits */

    /* construct the block for overwriting r[j] in memory */
    sll        x28, x27, x18
    sll        x24, x22, x18
    and        x24, x24, x28
    xor        x18, x24, x5

    /* overwrite r[j] */
    la         x1, r              /* Load base address of r from memory */
    addi       x12, x11, 0        /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13
    sw         x18, 0(x2)

    addi       x11, x11, 1
    bne        x11, x25, loop_all_els_end


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
    .word 0xfef103c2
    .word 0x02bd05a4
    .word 0xfde0fb73
    .word 0x065cfa68
    .word 0xfbc5fd55
    .word 0xfe8801e9
    .word 0xfccbfecc
    .word 0xfff5fb72
    .word 0x049f055e
    .word 0xfe9202a1
    .word 0xfe96ff1f
    .word 0x038cfe50
    .word 0x001e0097
    .word 0x01cffb92
    .word 0x067c004a
    .word 0xfeaafa87
    .word 0xfd73fed4
    .word 0x0249045d
    .word 0x05b80404
    .word 0xfc1dfa49
    .word 0xfc67055b
    .word 0x02050567
    .word 0xfde9f9a5
    .word 0xf986ff43
    .word 0x030d0452
    .word 0x0020fb41
    .word 0x060702bb
    .word 0xfa4b0141
    .word 0xfb800036
    .word 0xfa2e03fe
    .word 0xffe4fc3d
    .word 0xffd303a8
    .word 0x061b01a5
    .word 0x04a602ad
    .word 0xfca1fe00
    .word 0xfdb104b1
    .word 0xfaf3fe6e
    .word 0xfa22ffa1
    .word 0xfa4dfc2b
    .word 0x020d064f
    .word 0xfac105b2
    .word 0xfaaafdd8
    .word 0x010301d7
    .word 0x05b2fa69
    .word 0xfa96faef
    .word 0x011fff5c
    .word 0xfcadfae0
    .word 0xfd420126
    .word 0x01400440
    .word 0xfe2e063d
    .word 0x053803e0
    .word 0xfe70fbb0
    .word 0xfb35019b
    .word 0x003d052b
    .word 0xfe99fea1
    .word 0xfa3c0557
    .word 0x04c7f9d9
    .word 0xff8cff35
    .word 0xfc280492
    .word 0xfedc00c6
    .word 0x0406fe1c
    .word 0xfb500157
    .word 0xf9cd0100
    .word 0xfa57004f
    .word 0xfed0056b
    .word 0x0003fbeb
    .word 0x065102f6
    .word 0x02d5f988
    .word 0xfc7201cf
    .word 0xfc35fe89
    .word 0x031504a5
    .word 0x048d0253
    .word 0x06530661
    .word 0x05bc032e
    .word 0xfec7fbad
    .word 0x02e50399
    .word 0x0222ff85
    .word 0xfad2ff77
    .word 0xfa78feda
    .word 0xfa93fecf
    .word 0xffd90029
    .word 0x02b20117
    .word 0x0177fddc
    .word 0xfd92fc2d
    .word 0xff1e04c9
    .word 0xff28fea8
    .word 0x05b6fefc
    .word 0xfe67007b
    .word 0x0085fb2a
    .word 0xfc31fe23
    .word 0xff880511
    .word 0xfed2ff1d
    .word 0xffd8fdec
    .word 0xfbcd047b
    .word 0xfe5805b6
    .word 0xf9cffe36
    .word 0x05acfa6e
    .word 0xfb96faab
    .word 0xff6c0440
    .word 0x050dfe9b
    .word 0xfe8efddc
    .word 0xfa790109
    .word 0x01d0fda8
    .word 0xfe1dfc55
    .word 0x008200a3
    .word 0x00120390
    .word 0xfb70fcf8
    .word 0xfefbff03
    .word 0x0382fb4a
    .word 0x009e0399
    .word 0x005e03c3
    .word 0xfa44062e
    .word 0x02fffcb1
    .word 0xfc1503a8
    .word 0x0542fced
    .word 0xfa7702a9
    .word 0xffd5fc82
    .word 0x035afb7e
    .word 0xfc60f9e2
    .word 0xfcd3ff3e
    .word 0x042efe29
    .word 0x0195fe64
    .word 0x066afc27
    .word 0x0424f9b3
    .word 0xfe8f021d
    .word 0x00e9fc0c
    .word 0xff90f9bc
    .word 0xfdf80352


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
    .word  0xf301  /* -3327 in 32-bit two's complement */
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    f:
    .word  0x05a1  /* -3327 in 32-bit two's complement */
    .word  0x0
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
    .dword  0xffffffffffff0000  /* 32 set bits */
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_64:
    .dword  0xffffffffffffffff  /* 32 set bits */
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    mask_upper26:
    .dword  0xffffffffffffffc0  /* 32 set bits */
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
    mask_256b:
    .dword  0xffffffffffffffff
    .dword  0xffffffffffffffff
    .dword  0xffffffffffffffff
    .dword  0xffffffffffffffff

    .balign 32
    len4mask:
    .dword 0xffffffffffffffff
    .dword 0x0
    .dword 0xffffffffffffffff
    .dword 0x0

    .balign 32
    len2mask:
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff
    .dword 0x00000000ffffffff

    .balign 32
    v:
    .dword 0x0000000000004ebf
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    barrett_add_vec:
    .dword 0x0000000002000000
    .dword 0x0
    .dword 0x0
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
    r_j:
    .word  0x0
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    r_jtmp:
    .word  0x0
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    r_j_len_sub_r_j:
    .word  0x0
    .word  0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    r_j_new:
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
    tmp:
    .dword 0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0

    .balign 32
    a:
    .dword 0x0
    .dword 0x0
    .dword 0x0
    .dword 0x0
