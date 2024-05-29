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

    /* Set looping variables to constants while iteratively building */
    addi       x7, x0, 1          /* x7 : k */
    addi       x8, x0, 128          /* x8 : len */
    addi       x25, x0, 256         /* lim start */
    addi       x15, x0, 1         /* lim len */

looplen:
    addi       x9, x0, 0          /* x9 : start */

    /* loopi          1, 2 */
loopstart:
    jal        x0, body
    /* nop */

body:
    add        x11, x0, x9         /* x11 : j = start */

    /* Load zeta into x20 */
    la         x1, zetas              /* Load base address of zetas from memory */
    srai       x13, x7, 1
    slli       x13, x13, 2        /* x13 : k*2 ... offset to element in zetas */
    add        x2, x1, x13        /* x1 : base address of zetas plus offset to element */
    lw         x20, 0(x2)         /* load word 32 bits */
    and        x18, x7, 1        /* k mod 2 */
    xor        x17, x18, 1        /* inverse */
    slli       x23, x18, 4        /* shift idx left by 4 */
    slli       x24, x17, 4
    srl        x20, x20, x24
    sll        x20, x20, x23
    srl        x20, x20, x23

    addi       x7, x7, 1            /* k++ */

    loop       x8, 102
    
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
    and        x26, x26, x28      /* isolate the opposite sub-block in position */

    /* Load r[j] into x19 */
    la         x1, r              /* Load base address of r from memory */
    srai       x13, x11, 1
    slli       x13, x13, 2        /* x13 : j*2 ... offset to element in r */
    add        x2, x1, x13        /* x1 : base address of r plus offset to element */
    lw         x5, 0(x2)         /* load word 32 bits */
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
    
    /* Store zeta and r[j+len] in memory as params */
    la         x1, zeta
    sw         x20, 0(x1)
    la         x1, r_j_len
    sw         x16, 0(x1)

    /* Read zeta and r[j+len] into WDRs for processing */
    la         x1, zeta
    addi       x3, x0, 1
    BN.LID     x3, 0(x1)          /*  w1 should now contain zeta */

    /* Load inputs from memory */
    la         x1, r_j_len
    addi       x3, x0, 2
    BN.LID     x3, 0(x1)          /*  w2 should now contain r_j_len */

    BN.RSHI     w11, w0, w1 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w1, w11, w1

    BN.RSHI     w11, w0, w2 >> 15
    BN.AND      w11, w11, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w2, w11, w2

    BN.MULQACC.WO.Z  w10, w1.0, w2.0, 0     /* w1 = a */


    BN.AND     w9, w5, w10         /*  (int16_t)a */

    BN.MULQACC.WO.Z  w3, w9.0, w4.0, 0     /* t = (int16_t)a * QINV */
    BN.AND           w3, w3, w5           /* (int32_t)t */ 

    BN.RSHI     w18, w0, w3 >> 15 
    BN.AND      w11, w18, w12       /* w11 is 0 if positive, 1 if negative */
    BN.MULQACC.WO.Z  w11, w13.0, w11.0, 0 
    BN.XOR      w3, w11, w3

    BN.MULQACC.WO.Z  w8, w3.0, w6.0, 0     /* (int32_t)t * KYBER_Q */

    BN.SUB           w7, w10, w8            /* a - (int32_t)t*KYBER_Q */
    BN.RSHI          w7, w0, w7 >> 16 
    BN.AND           w7, w7, w5             /* w7 = (int16t)((a - t*Q)>>16) */

    /* Store result t to memory */
    la         x1, t
    addi       x3, x0, 7                   /* reference to w7, which holds the result */
    BN.SID     x3, 0(x1)

    /* Load t into x21 */
    la         x1, t
    lw         x21, 0(x1)         /* load word 32 bits */

    /* Subtract: r[j] - t into x22 */
    sub        x22, x19, x21

    /* construct the block for overwriting r[j + len] in memory */
    sll        x28, x27, x23
    sll        x22, x22, x23
    and        x22, x22, x28
    xor        x3, x22, x26

    /* overwrite r[j + len] */
    la         x1, r              /* Load base address of r from memory */
    add        x12, x11, x8       /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13
    sw         x3, 0(x2)

    /* load r[j + len] into r4 for testing purposes */
    lw         x4, 0(x2)

    /* Add: r[j] + t into x22 */
    add        x22, x19, x21

    /* construct the block for overwriting r[j] in memory */
    sll        x28, x27, x18
    sll        x24, x22, x18
    and        x24, x24, x28
    xor        x18, x24, x5

    /* overwrite r[j] */
    la         x1, r              /* Load base address of r from memory */
    addi       x12, x11, 0       /* x12 : j + len */
    srai       x13, x12, 1        /* floor divide (j + len)//2 */
    slli       x13, x13, 2        /* x13 : (j + len)*2 ... offset to element in r */
    add        x2, x1, x13
    sw         x18, 0(x2)

    /* load r[j] into r4 for testing purposes */
    lw         x5, 0(x2)
    addi       x11, x11, 1

    add        x9, x11, x8          /* start = j + len */
    bne        x9, x25, loopstart

    srli       x8, x8, 1            /* len >>= 1 */
    bne        x8, x15, looplen

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
    .word 0x083c0ab3
    .word 0x013806c0
    .word 0x067207c1
    .word 0x04490a03
    .word 0x090b06d2
    .word 0x08b30a6b
    .word 0x0a44072a
    .word 0x0504000a
    .word 0x0b4809c1
    .word 0x05470b2a
    .word 0x08a9087c
    .word 0x05bd083b
    .word 0x0aac061d
    .word 0x0b9a06a8
    .word 0x07b500dd
    .word 0x015404b0
    .word 0x041c07b5
    .word 0x0a6f0a26
    .word 0x020d0cca
    .word 0x071d01f0
    .word 0x045103c9
    .word 0x06b00340
    .word 0x035903e3
    .word 0x01a509cb
    .word 0x0ac309a7
    .word 0x0c7d01ac
    .word 0x0c5a0282
    .word 0x09670689
    .word 0x09110914
    .word 0x0c2102b3
    .word 0x092a0c3b
    .word 0x072e02c6
    .word 0x09e60a56
    .word 0x004c01d3
    .word 0x0c920b9a
    .word 0x005902ed
    .word 0x044109f5
    .word 0x0aa100fe
    .word 0x00cb0048
    .word 0x0c410362
    .word 0x07ad083b
    .word 0x04d30957
    .word 0x040700b8
    .word 0x053808b1
    .word 0x07cf0cb6
    .word 0x0bba0974
    .word 0x02e807a3
    .word 0x0ab30a1c
    .word 0x0ced0378
    .word 0x0b880b4d
    .word 0x0a430a75
    .word 0x096e0b63
    .word 0x0c4006f7
    .word 0x07160ae5
    .word 0x006b05e8
    .word 0x00210c9f
    .word 0x09ac0961
    .word 0x04250718
    .word 0x026f0059
    .word 0x0cb6075a
    .word 0x08fa0846
    .word 0x041706b6
    .word 0x0333006a
    .word 0x07ce0612
    .word 0x05a70203
    .word 0x0cc805fa
    .word 0x059606c0
    .word 0x098b0367
    .word 0x07af0118
    .word 0x043e0c72
    .word 0x04e70774
    .word 0x07e8029f
    .word 0x036f06fa
    .word 0x00100ca3
    .word 0x0bad008c
    .word 0x067d07d4
    .word 0x07b9007a
    .word 0x0002008d
    .word 0x080b079a
    .word 0x07550a7f
    .word 0x0b3804bd
    .word 0x062906ff
    .word 0x038e064c
    .word 0x01b700dd
    .word 0x09140655
    .word 0x09950380
    .word 0x027707ba
    .word 0x0003045e
    .word 0x052d0533
    .word 0x0acb0c1c
    .word 0x01b00037
    .word 0x05c703a7
    .word 0x0329020d
    .word 0x05960c82
    .word 0x08dd047a
    .word 0x05fe0258
    .word 0x07e60bc9
    .word 0x09440bc1
    .word 0x09ad0573
    .word 0x05ac037e
    .word 0x003f033b
    .word 0x02cd0070
    .word 0x01e80aca
    .word 0x09d30bc7
    .word 0x09760a0a
    .word 0x0cf60455
    .word 0x00b3064b
    .word 0x0be602e0
    .word 0x021703b9
    .word 0x0429067c
    .word 0x0b6b09e9
    .word 0x04440c08
    .word 0x03400465
    .word 0x075e0adf
    .word 0x00c80b20
    .word 0x00c108a8
    .word 0x0029075f
    .word 0x077e08b8
    .word 0x0561088a
    .word 0x02a40581
    .word 0x0a530bd3
    .word 0x0a1000e2
    .word 0x00070456
    .word 0x02d00210
    .word 0x0326025e
    .word 0x0ccb0653
    .word 0x072e0b14
    .word 0x06590cea


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
