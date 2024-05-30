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
    .word 0x00a4fdad
    .word 0xff280022
    .word 0xfcefffa2
    .word 0xff5805e8
    .word 0x000f01e8
    .word 0x02be01e4
    .word 0xfa7e0239
    .word 0x048dfee6
    .word 0xfeb6fcd0
    .word 0xfe20ff45
    .word 0xfb4dfbc0
    .word 0xfceefc22
    .word 0xfa3c0068
    .word 0x0005face
    .word 0xfb2b007b
    .word 0xfb62f9e4
    .word 0x040304e4
    .word 0x058c0596
    .word 0x02a1fcfc
    .word 0xfc650097
    .word 0x01a5ffca
    .word 0x04d5001d
    .word 0x017e0436
    .word 0x0032fe87
    .word 0x00dffd56
    .word 0xfd9a00a1
    .word 0x065f0046
    .word 0xfffb0522
    .word 0xfd5e0009
    .word 0xfedd003b
    .word 0xfb5bffce
    .word 0x0566fd54
    .word 0x016bf9cc
    .word 0xff520334
    .word 0x028c0462
    .word 0xfee50263
    .word 0x05db053f
    .word 0xfc38f99f
    .word 0x062df999
    .word 0x005bfa25
    .word 0xfdccfc50
    .word 0x0273f9ef
    .word 0xfa9102e8
    .word 0x0128fc94
    .word 0x01a5008a
    .word 0x0459fa57
    .word 0xfa0f0156
    .word 0x02ecfedd
    .word 0xfe6cfade
    .word 0xfdfa01fe
    .word 0x036c014d
    .word 0x027801b9
    .word 0x060dffe1
    .word 0xffb0ff24
    .word 0xfda0fd78
    .word 0x0588ff5e
    .word 0xf995f9ed
    .word 0xfda804da
    .word 0x00ad0609
    .word 0x02300516
    .word 0xfb91fbb1
    .word 0xfa4404c6
    .word 0xfc52f9a7
    .word 0x00f1fc1a
    .word 0xfd1301d8
    .word 0x04cc065e
    .word 0xfcf6fedf
    .word 0x0592fdd5
    .word 0x00030061
    .word 0xfba300a7
    .word 0xfbfafb95
    .word 0xfdfcffdf
    .word 0x03fbfa39
    .word 0x04d8fed8
    .word 0xfbb603e5
    .word 0x0324fb37
    .word 0xfb2605c2
    .word 0xfd670203
    .word 0xfda1f9e6
    .word 0xfd9bfc86
    .word 0xfb900189
    .word 0xfa55fab8
    .word 0xffc0ff2a
    .word 0xfcee02e9
    .word 0xfcf9fdc8
    .word 0xfd3cfd2c
    .word 0x05010552
    .word 0x0044fd61
    .word 0xfcb604ae
    .word 0xf9e2fee9
    .word 0x00c6fa63
    .word 0x0233fe99
    .word 0x02000016
    .word 0xfad0017b
    .word 0xfcaffe56
    .word 0x0007fbcc
    .word 0x008dfecb
    .word 0xfe7200ff
    .word 0x03a5fc2b
    .word 0x064202bb
    .word 0x0539fac7
    .word 0x0232fcce
    .word 0xfdfafbe3
    .word 0xfce7f9a6
    .word 0x03bdffdd
    .word 0xf9dcfa44
    .word 0xfc10fe92
    .word 0xfd8dfbd6
    .word 0xfd00009e
    .word 0x0636035f
    .word 0xfe10ffb9
    .word 0x04e102bb
    .word 0x031204e0
    .word 0xfbf5ff3c
    .word 0xfe31fec6
    .word 0xff94fc8a
    .word 0xffa5fb80
    .word 0x0271fb69
    .word 0x0300ffa0
    .word 0x039d027c
    .word 0xfa8d027b
    .word 0xfe92fc0b
    .word 0x028d00a7
    .word 0xfec1048f
    .word 0xfb78fa95
    .word 0xff49f9bd
    .word 0xfc8e0561
    .word 0x05fc0045


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
