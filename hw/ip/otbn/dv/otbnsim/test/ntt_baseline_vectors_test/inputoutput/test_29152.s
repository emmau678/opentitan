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
    .word 0x0b1806e5
    .word 0x05b00147
    .word 0x052e0a31
    .word 0x033b0757
    .word 0x0a210acd
    .word 0x08a80863
    .word 0x03ba0803
    .word 0x00ed013f
    .word 0x060f0325
    .word 0x07ac0877
    .word 0x02820614
    .word 0x05fe04a9
    .word 0x050300f9
    .word 0x0a7401fe
    .word 0x08180bdb
    .word 0x00db04f1
    .word 0x07c90a9b
    .word 0x076f0a48
    .word 0x0b2b0c12
    .word 0x055e03d3
    .word 0x0a4006e0
    .word 0x06c207e4
    .word 0x0c4607d3
    .word 0x0b4f060a
    .word 0x088f06c5
    .word 0x025e07ed
    .word 0x009107b0
    .word 0x070108ae
    .word 0x09e50892
    .word 0x05030448
    .word 0x0a430723
    .word 0x07060344
    .word 0x000a08be
    .word 0x05ad084b
    .word 0x00c6002e
    .word 0x070707d4
    .word 0x02f40421
    .word 0x09b50cf1
    .word 0x0c400478
    .word 0x013f006d
    .word 0x09900699
    .word 0x06d20432
    .word 0x0cbd0015
    .word 0x09de07a5
    .word 0x041f08d3
    .word 0x06e200ec
    .word 0x02850507
    .word 0x006b021c
    .word 0x0829086b
    .word 0x09db0439
    .word 0x05780689
    .word 0x07960b5c
    .word 0x05610036
    .word 0x03b503b9
    .word 0x056e042a
    .word 0x04b4034f
    .word 0x046d0c5a
    .word 0x09740a8e
    .word 0x03790a65
    .word 0x0ccd07b0
    .word 0x039006da
    .word 0x02a30b4f
    .word 0x079205dc
    .word 0x043903b7
    .word 0x061d0c2a
    .word 0x0b140514
    .word 0x0a7408ff
    .word 0x00660993
    .word 0x04770385
    .word 0x02c80b74
    .word 0x068501ca
    .word 0x01c6049f
    .word 0x03cf026a
    .word 0x067802c6
    .word 0x0a2a0c22
    .word 0x08d20b07
    .word 0x06370567
    .word 0x02f20065
    .word 0x05a70191
    .word 0x07920cac
    .word 0x0af70374
    .word 0x04e501fa
    .word 0x06c601fe
    .word 0x0923007f
    .word 0x021f04b3
    .word 0x07470938
    .word 0x017e0cc3
    .word 0x067d0602
    .word 0x030b0b9b
    .word 0x01bc025e
    .word 0x056702e2
    .word 0x0b1903ac
    .word 0x0993070b
    .word 0x06b00456
    .word 0x019b070c
    .word 0x07d401ce
    .word 0x06b50785
    .word 0x029e0932
    .word 0x039b09db
    .word 0x040003b0
    .word 0x07cf044c
    .word 0x09db0588
    .word 0x0a3e07fb
    .word 0x066a0964
    .word 0x0c070111
    .word 0x0bf20200
    .word 0x0b780617
    .word 0x07e00b10
    .word 0x0cbb0a99
    .word 0x0ad20275
    .word 0x07420232
    .word 0x08f60980
    .word 0x09cf0405
    .word 0x01cc01cf
    .word 0x02a70973
    .word 0x05c90907
    .word 0x09aa0bd3
    .word 0x0b1d0253
    .word 0x00f90c22
    .word 0x02320262
    .word 0x09440250
    .word 0x095905d4
    .word 0x08a40abe
    .word 0x009a0080
    .word 0x022e046f
    .word 0x08400313
    .word 0x0b4409dc
    .word 0x0c9e0537


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
