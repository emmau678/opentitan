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
    .word 0x07a80051
    .word 0x01bd0c44
    .word 0x073a0523
    .word 0x058d073d
    .word 0x06530a6b
    .word 0x03bd04df
    .word 0x093f0480
    .word 0x034f03c2
    .word 0x078507b5
    .word 0x01b20981
    .word 0x05fd0713
    .word 0x01590132
    .word 0x0b7b0b21
    .word 0x048004ff
    .word 0x0b5a0988
    .word 0x09dc0878
    .word 0x0bee0cfa
    .word 0x082f079f
    .word 0x00550a50
    .word 0x0173082e
    .word 0x082a0392
    .word 0x0639049c
    .word 0x041f0a60
    .word 0x07670610
    .word 0x059f01a3
    .word 0x06d702e4
    .word 0x06510b07
    .word 0x07060a89
    .word 0x04c50b38
    .word 0x05890bbf
    .word 0x02e804c0
    .word 0x051308d3
    .word 0x03980302
    .word 0x07900080
    .word 0x0b14040d
    .word 0x060a0246
    .word 0x0051034d
    .word 0x00730155
    .word 0x034d097c
    .word 0x0b450673
    .word 0x033b0c97
    .word 0x01fb07f5
    .word 0x05a80b67
    .word 0x05060607
    .word 0x0c100ae4
    .word 0x0c440005
    .word 0x056f041d
    .word 0x03670385
    .word 0x0cf1004b
    .word 0x0b23058e
    .word 0x008c07e1
    .word 0x06e40c4e
    .word 0x016c0566
    .word 0x036405cc
    .word 0x01840716
    .word 0x00b40142
    .word 0x00a60262
    .word 0x04e90b4c
    .word 0x01e30cb5
    .word 0x056f0cf2
    .word 0x011e06ae
    .word 0x015d0393
    .word 0x01770622
    .word 0x000b05fb
    .word 0x08ca0393
    .word 0x00390059
    .word 0x02ac04fc
    .word 0x0c9705d7
    .word 0x09a80b4c
    .word 0x02bd02ea
    .word 0x0636041d
    .word 0x00140029
    .word 0x0188053d
    .word 0x0504019e
    .word 0x01160689
    .word 0x02500c9e
    .word 0x06d30237
    .word 0x03b70217
    .word 0x0bfa065d
    .word 0x0c1400be
    .word 0x046a080b
    .word 0x04b40be0
    .word 0x05fd0246
    .word 0x0bfb0603
    .word 0x034c041c
    .word 0x0bc20c7d
    .word 0x066b0429
    .word 0x04f60684
    .word 0x0a8a025e
    .word 0x07ee0229
    .word 0x09810005
    .word 0x052504b1
    .word 0x0a3b06df
    .word 0x064c0596
    .word 0x02d20c40
    .word 0x0bc704ab
    .word 0x081a0352
    .word 0x0ab5007a
    .word 0x0acf0484
    .word 0x0a370239
    .word 0x09260a77
    .word 0x06dc0a44
    .word 0x0732046a
    .word 0x02620699
    .word 0x040b0106
    .word 0x01d601a8
    .word 0x05db0586
    .word 0x01b70826
    .word 0x0c810450
    .word 0x0403081c
    .word 0x095502b6
    .word 0x045003e3
    .word 0x0c8a035e
    .word 0x02db0648
    .word 0x052e0395
    .word 0x09400ced
    .word 0x08e0037c
    .word 0x08fa02e2
    .word 0x034709d8
    .word 0x04220656
    .word 0x0710087d
    .word 0x0cb807ca
    .word 0x023206b9
    .word 0x093d0307
    .word 0x010100df
    .word 0x036201c6
    .word 0x0589087d
    .word 0x01a20829


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
