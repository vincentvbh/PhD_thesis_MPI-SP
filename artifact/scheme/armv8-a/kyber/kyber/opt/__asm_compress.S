

#include "macros.i"

.global __asm_compress1x8_prototype
.global ___asm_compress1x8_prototype
__asm_compress1x8_prototype:
___asm_compress1x8_prototype:

    mov w4, #315
    mov w7, #1

    mov     v0.H[0], w4
    dup       v3.8H, w7

    ldr q4, [x1]

    sqdmulh   v4.8H,   v4.8H, v0.H[0]
    srshr     v4.8H,   v4.8H, #4
    and      v4.16B,  v4.16B, v3.16B

    str q4, [x0]

    ret

.global __asm_compress4x8_prototype
.global ___asm_compress4x8_prototype
__asm_compress4x8_prototype:
___asm_compress4x8_prototype:

    mov w4, #315
    mov w5, #1
    mov w7, #0xf

    mov     v0.H[0], w4
    dup       v2.8H, w5
    dup       v3.8H, w7

    ldr q4, [x1]

    sqdmulh   v4.8H,   v4.8H, v0.H[0]
    shadd     v4.8H,   v4.8H,  v2.8H
    and      v4.16B,  v4.16B, v3.16B

    str q4, [x0]

    ret

.global __asm_compress5x8_prototype
.global ___asm_compress5x8_prototype
__asm_compress5x8_prototype:
___asm_compress5x8_prototype:

    mov w4, #315
    mov w7, #0x1f

    mov     v0.H[0], w4
    dup       v3.8H, w7

    ldr q4, [x1]

    sqrdmulh  v4.8H,   v4.8H, v0.H[0]
    and      v4.16B,  v4.16B, v3.16B

    str q4, [x0]

    ret

.global __asm_compress10x8_prototype
.global ___asm_compress10x8_prototype
__asm_compress10x8_prototype:
___asm_compress10x8_prototype:

    mov w4, #-20553
    mov w5, #20
    mov w7, #0x3ff

    mov     v0.H[0], w4
    mov     v0.H[1], w5
    eor      v2.16B,  v2.16B, v2.16B
    dup       v3.8H, w7

    ldr q4, [x1]

    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    shadd     v5.8H,   v5.8H, v2.8H
    mla       v5.8H,   v4.8H, v0.H[1]
    srshr     v4.8H,   v5.8H, #6
    and      v4.16B,  v4.16B, v3.16B

    str q4, [x0]

    ret

.global __asm_compress11x8_prototype
.global ___asm_compress11x8_prototype
__asm_compress11x8_prototype:
___asm_compress11x8_prototype:

    mov w4, #-20553
    mov w5, #20
    mov w7, #0x7ff

    mov     v0.H[0], w4
    mov     v0.H[1], w5
    eor      v2.16B, v2.16B, v2.16B
    dup       v3.8H, w7

    ldr q4, [x1]

    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    shadd     v5.8H,   v5.8H, v2.8H
    mla       v5.8H,   v4.8H, v0.H[1]
    srshr     v4.8H,   v5.8H, #5
    and      v4.16B,  v4.16B, v3.16B

    str q4, [x0]

    ret

.global __asm_pack1x128_prototype
.global ___asm_pack1x128_prototype
__asm_pack1x128_prototype:
___asm_pack1x128_prototype:

    push_simd

    mov w4, #1
    lsl w5, w4, #8
    mov w6, #3
    lsl w7, w6, #8
    mov w8, #0xf
    lsl w9, w8, #8

    dup      v20.8H, w4
    dup      v21.8H, w5
    dup      v22.8H, w6
    dup      v23.8H, w7
    dup      v24.8H, w8
    dup      v25.8H, w9

    ldr  q4, [x1, # 0*16]
    ldr  q5, [x1, # 1*16]
    ldr  q6, [x1, # 2*16]
    ldr  q7, [x1, # 3*16]
    ldr  q8, [x1, # 4*16]
    ldr  q9, [x1, # 5*16]
    ldr q10, [x1, # 6*16]
    ldr q11, [x1, # 7*16]
    ldr q12, [x1, # 8*16]
    ldr q13, [x1, # 9*16]
    ldr q14, [x1, #10*16]
    ldr q15, [x1, #11*16]
    ldr q16, [x1, #12*16]
    ldr q17, [x1, #13*16]
    ldr q18, [x1, #14*16]
    ldr q19, [x1, #15*16]

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v5.8H
    xtn       v6.8B,   v6.8H
    xtn2     v6.16B,   v7.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,   v9.8H
    xtn      v10.8B,  v10.8H
    xtn2    v10.16B,  v11.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v13.8H
    xtn      v14.8B,  v14.8H
    xtn2    v14.16B,  v15.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v17.8H
    xtn      v18.8B,  v18.8H
    xtn2    v18.16B,  v19.8H

    ushr      v5.8H,   v4.8H, #7
    orr      v4.16B,  v4.16B,  v5.16B
    ushr      v7.8H,   v6.8H, #7
    orr      v6.16B,  v6.16B,  v7.16B
    ushr      v9.8H,   v8.8H, #7
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v11.8H,  v10.8H, #7
    orr     v10.16B, v10.16B, v11.16B
    ushr     v13.8H,  v12.8H, #7
    orr     v12.16B, v12.16B, v13.16B
    ushr     v15.8H,  v14.8H, #7
    orr     v14.16B, v14.16B, v15.16B
    ushr     v17.8H,  v16.8H, #7
    orr     v16.16B, v16.16B, v17.16B
    ushr     v19.8H,  v18.8H, #7
    orr     v18.16B, v18.16B, v19.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v6.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,  v10.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v14.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v18.8H

    ushr      v5.8H,   v4.8H, #6
    orr      v4.16B,  v4.16B,  v5.16B
    ushr      v9.8H,   v8.8H, #6
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v13.8H,  v12.8H, #6
    orr     v12.16B, v12.16B, v13.16B
    ushr     v17.8H,  v16.8H, #6
    orr     v16.16B, v16.16B, v17.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v8.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v16.8H

    ushr      v5.8H,   v4.8H, #4
    orr      v4.16B,  v4.16B,  v5.16B
    ushr     v13.8H,  v12.8H, #4
    orr     v12.16B, v12.16B, v13.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,  v12.8H

    str q4, [x0]

    pop_simd
    ret

.global __asm_pack4x32_prototype
.global ___asm_pack4x32_prototype
__asm_pack4x32_prototype:
___asm_pack4x32_prototype:

    push_simd

    mov w4, #0xf
    lsl w5, w4, #8

    ldr  q4, [x1, # 0*16]
    ldr  q5, [x1, # 1*16]
    ldr  q6, [x1, # 2*16]
    ldr  q7, [x1, # 3*16]

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v5.8H
    xtn       v6.8B,   v6.8H
    xtn2     v6.16B,   v7.8H

    ushr      v5.8H,   v4.8H, #4
    orr      v4.16B,  v4.16B,  v5.16B
    ushr      v7.8H,   v6.8H, #4
    orr      v6.16B,  v6.16B,  v7.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v6.8H

    str q4, [x0]

    pop_simd
    ret

.global __asm_pack5x16_prototype
.global ___asm_pack5x16_prototype
__asm_pack5x16_prototype:
___asm_pack5x16_prototype:

    push_all

    mov w4, #0x1f
    lsl w5, w4, #8
    mov w6, #0x3ff
    lsl w7, w6, #16
    mov x8, #0xfffff
    lsl x9, x8, #32

    dup      v16.8H, w4
    dup      v17.8H, w5
    dup      v18.4S, w6
    dup      v19.4S, w7
    dup      v20.2D, x8
    dup      v21.2D, x9

    ldr  q4, [x1, # 0*16]
    ldr  q5, [x1, # 1*16]

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v5.8H

    and      v7.16B,  v4.16B, v17.16B
    and      v6.16B,  v4.16B, v16.16B
    ushr      v7.8H,   v7.8H, #3
    orr      v6.16B,  v6.16B,  v7.16B
    and      v5.16B,  v6.16B, v19.16B
    and      v4.16B,  v6.16B, v18.16B
    ushr      v5.4S,   v5.4S, #6
    orr      v4.16B,  v4.16B,  v5.16B
    and      v7.16B,  v4.16B, v21.16B
    and      v6.16B,  v4.16B, v20.16B
    ushr      v7.2D,   v7.2D, #12
    orr      v6.16B,  v6.16B,  v7.16B

    str s6, [x0]
    mov w5, v6.S[1]
    mov w6, v6.S[2]
    mov w7, v6.S[3]

    strb w5, [x0, #4]
    str  w6, [x0, #5]
    strb w7, [x0, #9]

    pop_all
    ret

.global __asm_pack10x8_prototype
.global ___asm_pack10x8_prototype
__asm_pack10x8_prototype:
___asm_pack10x8_prototype:

    push_simd

    mov       w4, #0x3ff
    lsl       w5, w4, #16
    mov       x6, #0xfffff
    lsl       x7, x6, #32

    dup      v16.4S, w4
    dup      v17.4S, w5
    dup      v18.2D, x6
    dup      v19.2D, x7

    ldr  q4, [x1]

    and      v7.16B,  v4.16B, v17.16B
    and      v6.16B,  v4.16B, v16.16B
    ushr      v7.4S,   v7.4S, #6
    orr      v6.16B,  v6.16B,  v7.16B
    and      v5.16B,  v6.16B, v19.16B
    and      v4.16B,  v6.16B, v18.16B
    ushr      v5.2D,   v5.2D, #12
    orr      v4.16B,  v4.16B,  v5.16B

    str s4, [x0]
    mov w5, v4.S[1]
    mov w6, v4.S[2]
    mov w7, v4.S[3]

    strb w5, [x0, #4]
    str  w6, [x0, #5]
    strb w7, [x0, #9]

    pop_simd
    ret

.global __asm_pack11x8_prototype
.global ___asm_pack11x8_prototype
__asm_pack11x8_prototype:
___asm_pack11x8_prototype:

    push_simd

    mov       w4, #0x7ff
    lsl       w5, w4, #16
    mov       x6, #0x3ffffff
    lsl       x7, x6, #32

    dup      v16.4S, w4
    dup      v17.4S, w5
    dup      v18.2D, x6
    dup      v19.2D, x7

    ldr  q4, [x1]

    and      v7.16B,  v4.16B, v17.16B
    and      v6.16B,  v4.16B, v16.16B
    ushr      v7.4S,   v7.4S, #5
    orr      v6.16B,  v6.16B,  v7.16B
    and      v5.16B,  v6.16B, v19.16B
    and      v4.16B,  v6.16B, v18.16B
    ushr      v5.2D,   v5.2D, #10
    orr      v4.16B,  v4.16B,  v5.16B

    str s4, [x0]
    mov w5, v4.S[1]
    mov w6, v4.S[2]
    mov w7, v4.S[3]

    orr  w5, w5, w6, lsl #12
    str  w5, [x0, #4]
    lsr  w6, w6, #20
    orr  w6, w6, w7, lsl #12
    strh w6, [x0, #8]
    lsr  w7, w6, #16
    strb w7, [x0, #10]

    pop_simd
    ret

.global __asm_poly_compress1x128_core
.global ___asm_poly_compress1x128_core
__asm_poly_compress1x128_core:
___asm_poly_compress1x128_core:

    push_simd

    counter .req x2

    mov w4, #315
    mov w7, #1

    mov     v0.H[0], w4
    dup       v3.8H, w7

    mov w5, #1
    orr w5, w5, w5, lsl #9
    orr w5, w5, w5, lsl #18

    mov w6, #1
    movk w6, #0x10, lsl #16

    mov     v2.S[0], w5
    mov     v2.S[1], w6

    __asm_poly_compress1x128_core_loop:

    ldr  q4, [x1, # 0*16]
    ldr  q5, [x1, # 1*16]
    ldr  q6, [x1, # 2*16]
    ldr  q7, [x1, # 3*16]
    ldr  q8, [x1, # 4*16]
    ldr  q9, [x1, # 5*16]
    ldr q10, [x1, # 6*16]
    ldr q11, [x1, # 7*16]
    ldr q12, [x1, # 8*16]
    sqdmulh   v4.8H,   v4.8H, v0.H[0]
    ldr q13, [x1, # 9*16]
    sqdmulh   v5.8H,   v5.8H, v0.H[0]
    ldr q14, [x1, #10*16]
    sqdmulh   v6.8H,   v6.8H, v0.H[0]
    ldr q15, [x1, #11*16]
    sqdmulh   v7.8H,   v7.8H, v0.H[0]
    ldr q16, [x1, #12*16]
    sqdmulh   v8.8H,   v8.8H, v0.H[0]
    ldr q17, [x1, #13*16]
    sqdmulh   v9.8H,   v9.8H, v0.H[0]
    ldr q18, [x1, #14*16]
    sqdmulh  v10.8H,  v10.8H, v0.H[0]
    ldr q19, [x1, #15*16]
    sqdmulh  v11.8H,  v11.8H, v0.H[0]

    add x1, x1, #256

    sqdmulh  v12.8H,  v12.8H, v0.H[0]
    srshr     v4.8H,   v4.8H, #4
    sqdmulh  v13.8H,  v13.8H, v0.H[0]
    srshr     v5.8H,   v5.8H, #4
    sqdmulh  v14.8H,  v14.8H, v0.H[0]
    srshr     v6.8H,   v6.8H, #4
    sqdmulh  v15.8H,  v15.8H, v0.H[0]
    srshr     v7.8H,   v7.8H, #4
    sqdmulh  v16.8H,  v16.8H, v0.H[0]
    srshr     v8.8H,   v8.8H, #4
    sqdmulh  v17.8H,  v17.8H, v0.H[0]
    srshr     v9.8H,   v9.8H, #4
    sqdmulh  v18.8H,  v18.8H, v0.H[0]
    srshr    v10.8H,  v10.8H, #4
    sqdmulh  v19.8H,  v19.8H, v0.H[0]
    srshr    v11.8H,  v11.8H, #4

    srshr    v12.8H,  v12.8H, #4
    and      v4.16B,  v4.16B, v3.16B
    srshr    v13.8H,  v13.8H, #4
    and      v5.16B,  v5.16B, v3.16B
    srshr    v14.8H,  v14.8H, #4
    and      v6.16B,  v6.16B, v3.16B
    srshr    v15.8H,  v15.8H, #4
    and      v7.16B,  v7.16B, v3.16B
    srshr    v16.8H,  v16.8H, #4
    and      v8.16B,  v8.16B, v3.16B
    srshr    v17.8H,  v17.8H, #4
    and      v9.16B,  v9.16B, v3.16B
    srshr    v18.8H,  v18.8H, #4
    and     v10.16B, v10.16B, v3.16B
    srshr    v19.8H,  v19.8H, #4
    and     v11.16B, v11.16B, v3.16B

    and     v12.16B, v12.16B, v3.16B
    and     v13.16B, v13.16B, v3.16B
    and     v14.16B, v14.16B, v3.16B
    and     v15.16B, v15.16B, v3.16B
    and     v16.16B, v16.16B, v3.16B
    and     v17.16B, v17.16B, v3.16B
    and     v18.16B, v18.16B, v3.16B
    and     v19.16B, v19.16B, v3.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v5.8H
    xtn       v6.8B,   v6.8H
    xtn2     v6.16B,   v7.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,   v9.8H
    xtn      v10.8B,  v10.8H
    xtn2    v10.16B,  v11.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v13.8H
    xtn      v14.8B,  v14.8H
    xtn2    v14.16B,  v15.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v17.8H
    xtn      v18.8B,  v18.8H
    xtn2    v18.16B,  v19.8H

    ushr      v5.8H,   v4.8H, #7
    orr      v4.16B,  v4.16B,  v5.16B
    ushr      v7.8H,   v6.8H, #7
    orr      v6.16B,  v6.16B,  v7.16B
    ushr      v9.8H,   v8.8H, #7
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v11.8H,  v10.8H, #7
    orr     v10.16B, v10.16B, v11.16B
    ushr     v13.8H,  v12.8H, #7
    orr     v12.16B, v12.16B, v13.16B
    ushr     v15.8H,  v14.8H, #7
    orr     v14.16B, v14.16B, v15.16B
    ushr     v17.8H,  v16.8H, #7
    orr     v16.16B, v16.16B, v17.16B
    ushr     v19.8H,  v18.8H, #7
    orr     v18.16B, v18.16B, v19.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v6.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,  v10.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v14.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v18.8H

    ushr      v5.8H,   v4.8H, #6
    orr      v4.16B,  v4.16B,  v5.16B
    ushr      v9.8H,   v8.8H, #6
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v13.8H,  v12.8H, #6
    orr     v12.16B, v12.16B, v13.16B
    ushr     v17.8H,  v16.8H, #6
    orr     v16.16B, v16.16B, v17.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v8.8H
    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v16.8H

    ushr      v5.8H,   v4.8H, #4
    orr      v4.16B,  v4.16B,  v5.16B
    ushr     v13.8H,  v12.8H, #4
    orr     v12.16B, v12.16B, v13.16B

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,  v12.8H

    str q4, [x0], #16

    sub counter, counter, #1
    cbnz counter, __asm_poly_compress1x128_core_loop

    .unreq counter

    pop_simd
    ret

.global __asm_poly_compress4x32_core
.global ___asm_poly_compress4x32_core
__asm_poly_compress4x32_core:
___asm_poly_compress4x32_core:

    push_simd

    counter .req x2

    sub counter, counter, #4

    mov w4, #315
    mov w5, #1
    mov w7, #0xf

    mov     v0.H[0], w4
    dup       v2.8H, w5
    dup       v3.8H, w7

    ldr  q4, [x1, #(0*64+0*16)]
    ldr  q5, [x1, #(0*64+1*16)]
    ldr  q6, [x1, #(0*64+2*16)]
    ldr  q7, [x1, #(0*64+3*16)]
    ldr  q8, [x1, #(1*64+0*16)]
    ldr  q9, [x1, #(1*64+1*16)]
    ldr q10, [x1, #(1*64+2*16)]
    ldr q11, [x1, #(1*64+3*16)]

    sqdmulh   v4.8H,   v4.8H,  v0.H[0]
    sqdmulh   v5.8H,   v5.8H,  v0.H[0]
    sqdmulh   v6.8H,   v6.8H,  v0.H[0]
    sqdmulh   v7.8H,   v7.8H,  v0.H[0]
    sqdmulh   v8.8H,   v8.8H,  v0.H[0]
    sqdmulh   v9.8H,   v9.8H,  v0.H[0]
    sqdmulh  v10.8H,  v10.8H,  v0.H[0]
    sqdmulh  v11.8H,  v11.8H,  v0.H[0]

    shadd     v4.8H,   v4.8H,  v2.8H
    shadd     v5.8H,   v5.8H,  v2.8H
    shadd     v6.8H,   v6.8H,  v2.8H
    shadd     v7.8H,   v7.8H,  v2.8H
    shadd     v8.8H,   v8.8H,  v2.8H
    shadd     v9.8H,   v9.8H,  v2.8H
    shadd    v10.8H,  v10.8H,  v2.8H
    shadd    v11.8H,  v11.8H,  v2.8H

    __asm_poly_compress4x32_core_loop:

    and      v4.16B,  v4.16B, v3.16B
    ldr q12, [x1, #(2*64+0*16)]
    and      v5.16B,  v5.16B, v3.16B
    ldr q13, [x1, #(2*64+1*16)]
    and      v6.16B,  v6.16B, v3.16B
    ldr q14, [x1, #(2*64+2*16)]
    and      v7.16B,  v7.16B, v3.16B
    ldr q15, [x1, #(2*64+3*16)]
    and      v8.16B,  v8.16B, v3.16B
    ldr q16, [x1, #(3*64+0*16)]
    and      v9.16B,  v9.16B, v3.16B
    ldr q17, [x1, #(3*64+1*16)]
    and     v10.16B, v10.16B, v3.16B
    ldr q18, [x1, #(3*64+2*16)]
    and     v11.16B, v11.16B, v3.16B
    ldr q19, [x1, #(3*64+3*16)]

    add x1, x1, #4*64

    xtn       v4.8B,   v4.8H
    sqdmulh  v12.8H,  v12.8H,  v0.H[0]
    xtn2     v4.16B,   v5.8H
    sqdmulh  v13.8H,  v13.8H,  v0.H[0]
    xtn       v6.8B,   v6.8H
    sqdmulh  v14.8H,  v14.8H,  v0.H[0]
    xtn2     v6.16B,   v7.8H
    sqdmulh  v15.8H,  v15.8H,  v0.H[0]
    xtn       v8.8B,   v8.8H
    sqdmulh  v16.8H,  v16.8H,  v0.H[0]
    xtn2     v8.16B,   v9.8H
    sqdmulh  v17.8H,  v17.8H,  v0.H[0]
    xtn      v10.8B,  v10.8H
    sqdmulh  v18.8H,  v18.8H,  v0.H[0]
    xtn2    v10.16B,  v11.8H
    sqdmulh  v19.8H,  v19.8H,  v0.H[0]

    ushr      v5.8H,   v4.8H, #4
    shadd    v12.8H,  v12.8H,  v2.8H
    orr      v4.16B,  v4.16B,  v5.16B
    shadd    v13.8H,  v13.8H,  v2.8H
    ushr      v7.8H,   v6.8H, #4
    shadd    v14.8H,  v14.8H,  v2.8H
    orr      v6.16B,  v6.16B,  v7.16B
    shadd    v15.8H,  v15.8H,  v2.8H
    ushr      v9.8H,   v8.8H, #4
    shadd    v16.8H,  v16.8H,  v2.8H
    orr      v8.16B,  v8.16B,  v9.16B
    shadd    v17.8H,  v17.8H,  v2.8H
    ushr     v11.8H,  v10.8H, #4
    shadd    v18.8H,  v18.8H,  v2.8H
    orr     v10.16B, v10.16B, v11.16B
    shadd    v19.8H,  v19.8H,  v2.8H

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v6.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,  v10.8H

    str  q4, [x0, #0*16]
    str  q8, [x0, #1*16]

    and     v12.16B, v12.16B, v3.16B
    ldr  q4, [x1, #(0*64+0*16)]
    and     v13.16B, v13.16B, v3.16B
    ldr  q5, [x1, #(0*64+1*16)]
    and     v14.16B, v14.16B, v3.16B
    ldr  q6, [x1, #(0*64+2*16)]
    and     v15.16B, v15.16B, v3.16B
    ldr  q7, [x1, #(0*64+3*16)]
    and     v16.16B, v16.16B, v3.16B
    ldr  q8, [x1, #(1*64+0*16)]
    and     v17.16B, v17.16B, v3.16B
    ldr  q9, [x1, #(1*64+1*16)]
    and     v18.16B, v18.16B, v3.16B
    ldr q10, [x1, #(1*64+2*16)]
    and     v19.16B, v19.16B, v3.16B
    ldr q11, [x1, #(1*64+3*16)]

    xtn      v12.8B,  v12.8H
    sqdmulh   v4.8H,   v4.8H,  v0.H[0]
    xtn2    v12.16B,  v13.8H
    sqdmulh   v5.8H,   v5.8H,  v0.H[0]
    xtn      v14.8B,  v14.8H
    sqdmulh   v6.8H,   v6.8H,  v0.H[0]
    xtn2    v14.16B,  v15.8H
    sqdmulh   v7.8H,   v7.8H,  v0.H[0]
    xtn      v16.8B,  v16.8H
    sqdmulh   v8.8H,   v8.8H,  v0.H[0]
    xtn2    v16.16B,  v17.8H
    sqdmulh   v9.8H,   v9.8H,  v0.H[0]
    xtn      v18.8B,  v18.8H
    sqdmulh  v10.8H,  v10.8H,  v0.H[0]
    xtn2    v18.16B,  v19.8H
    sqdmulh  v11.8H,  v11.8H,  v0.H[0]

    ushr     v13.8H,  v12.8H, #4
    shadd     v4.8H,   v4.8H,  v2.8H
    orr     v12.16B, v12.16B, v13.16B
    shadd     v5.8H,   v5.8H,  v2.8H
    ushr     v15.8H,  v14.8H, #4
    shadd     v6.8H,   v6.8H,  v2.8H
    orr     v14.16B, v14.16B, v15.16B
    shadd     v8.8H,   v8.8H,  v2.8H
    ushr     v17.8H,  v16.8H, #4
    shadd     v7.8H,   v7.8H,  v2.8H
    orr     v16.16B, v16.16B, v17.16B
    shadd     v9.8H,   v9.8H,  v2.8H
    ushr     v19.8H,  v18.8H, #4
    shadd    v10.8H,  v10.8H,  v2.8H
    orr     v18.16B, v18.16B, v19.16B
    shadd    v11.8H,  v11.8H,  v2.8H

    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v14.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v18.8H

    str q12, [x0, #2*16]
    str q16, [x0, #3*16]

    add x0, x0, #4*16

    sub counter, counter, #4
    cbnz counter, __asm_poly_compress4x32_core_loop

    and      v4.16B,  v4.16B, v3.16B
    ldr q12, [x1, #(2*64+0*16)]
    and      v5.16B,  v5.16B, v3.16B
    ldr q13, [x1, #(2*64+1*16)]
    and      v6.16B,  v6.16B, v3.16B
    ldr q14, [x1, #(2*64+2*16)]
    and      v7.16B,  v7.16B, v3.16B
    ldr q15, [x1, #(2*64+3*16)]
    and      v8.16B,  v8.16B, v3.16B
    ldr q16, [x1, #(3*64+0*16)]
    and      v9.16B,  v9.16B, v3.16B
    ldr q17, [x1, #(3*64+1*16)]
    and     v10.16B, v10.16B, v3.16B
    ldr q18, [x1, #(3*64+2*16)]
    and     v11.16B, v11.16B, v3.16B
    ldr q19, [x1, #(3*64+3*16)]

    xtn       v4.8B,   v4.8H
    sqdmulh  v12.8H,  v12.8H,  v0.H[0]
    xtn2     v4.16B,   v5.8H
    sqdmulh  v13.8H,  v13.8H,  v0.H[0]
    xtn       v6.8B,   v6.8H
    sqdmulh  v14.8H,  v14.8H,  v0.H[0]
    xtn2     v6.16B,   v7.8H
    sqdmulh  v15.8H,  v15.8H,  v0.H[0]
    xtn       v8.8B,   v8.8H
    sqdmulh  v16.8H,  v16.8H,  v0.H[0]
    xtn2     v8.16B,   v9.8H
    sqdmulh  v17.8H,  v17.8H,  v0.H[0]
    xtn      v10.8B,  v10.8H
    sqdmulh  v18.8H,  v18.8H,  v0.H[0]
    xtn2    v10.16B,  v11.8H
    sqdmulh  v19.8H,  v19.8H,  v0.H[0]

    ushr      v5.8H,   v4.8H, #4
    shadd    v12.8H,  v12.8H,  v2.8H
    orr      v4.16B,  v4.16B,  v5.16B
    shadd    v13.8H,  v13.8H,  v2.8H
    ushr      v7.8H,   v6.8H, #4
    shadd    v14.8H,  v14.8H,  v2.8H
    orr      v6.16B,  v6.16B,  v7.16B
    shadd    v15.8H,  v15.8H,  v2.8H
    ushr      v9.8H,   v8.8H, #4
    shadd    v16.8H,  v16.8H,  v2.8H
    orr      v8.16B,  v8.16B,  v9.16B
    shadd    v17.8H,  v17.8H,  v2.8H
    ushr     v11.8H,  v10.8H, #4
    shadd    v18.8H,  v18.8H,  v2.8H
    orr     v10.16B, v10.16B, v11.16B
    shadd    v19.8H,  v19.8H,  v2.8H

    xtn       v4.8B,   v4.8H
    xtn2     v4.16B,   v6.8H
    xtn       v8.8B,   v8.8H
    xtn2     v8.16B,  v10.8H

    str  q4, [x0, #0*16]
    str  q8, [x0, #1*16]

    and     v12.16B, v12.16B, v3.16B
    and     v13.16B, v13.16B, v3.16B
    and     v14.16B, v14.16B, v3.16B
    and     v15.16B, v15.16B, v3.16B
    and     v16.16B, v16.16B, v3.16B
    and     v17.16B, v17.16B, v3.16B
    and     v18.16B, v18.16B, v3.16B
    and     v19.16B, v19.16B, v3.16B

    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v13.8H
    xtn      v14.8B,  v14.8H
    xtn2    v14.16B,  v15.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v17.8H
    xtn      v18.8B,  v18.8H
    xtn2    v18.16B,  v19.8H

    ushr     v13.8H,  v12.8H, #4
    orr     v12.16B, v12.16B, v13.16B
    ushr     v15.8H,  v14.8H, #4
    orr     v14.16B, v14.16B, v15.16B
    ushr     v17.8H,  v16.8H, #4
    orr     v16.16B, v16.16B, v17.16B
    ushr     v19.8H,  v18.8H, #4
    orr     v18.16B, v18.16B, v19.16B

    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v14.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v18.8H

    str q12, [x0, #2*16]
    str q16, [x0, #3*16]

    // add x0, x0, #4*16

    .unreq counter

    pop_simd
    ret


.global __asm_poly_compress5x16_core
.global ___asm_poly_compress5x16_core
__asm_poly_compress5x16_core:
___asm_poly_compress5x16_core:

    push_all

    counter .req x2

    sub counter, counter, #4

    mov w4, #315
    mov w7, #0x1f

    mov     v0.H[0], w4
    dup       v3.8H, w7

    mov w4, #0x1f
    lsl w5, w4, #8
    mov w6, #0x3ff
    lsl w7, w6, #16
    mov x8, #0xfffff
    lsl x9, x8, #32

    dup      v20.8H, w4
    dup      v21.8H, w5
    dup      v22.4S, w6
    dup      v23.4S, w7
    dup      v24.2D, x8
    dup      v25.2D, x9

    ldr  q4, [x1, #(0*32+0*16)]
    ldr  q5, [x1, #(0*32+1*16)]
    ldr  q8, [x1, #(1*32+0*16)]
    ldr  q9, [x1, #(1*32+1*16)]

    sqrdmulh  v4.8H,   v4.8H, v0.H[0]
    sqrdmulh  v5.8H,   v5.8H, v0.H[0]
    sqrdmulh  v8.8H,   v8.8H, v0.H[0]
    sqrdmulh  v9.8H,   v9.8H, v0.H[0]

    and      v4.16B,  v4.16B, v3.16B
    and      v5.16B,  v5.16B, v3.16B
    and      v8.16B,  v8.16B, v3.16B
    and      v9.16B,  v9.16B, v3.16B

    xtn       v4.8B,   v4.8H
    ldr q12, [x1, #(2*32+0*16)]
    xtn2     v4.16B,   v5.8H
    ldr q13, [x1, #(2*32+1*16)]
    xtn       v8.8B,   v8.8H
    ldr q16, [x1, #(3*32+0*16)]
    xtn2     v8.16B,   v9.8H
    ldr q17, [x1, #(3*32+1*16)]

    and      v7.16B,  v4.16B, v21.16B
    sqrdmulh v12.8H,  v12.8H, v0.H[0]
    and      v6.16B,  v4.16B, v20.16B
    sqrdmulh v13.8H,  v13.8H, v0.H[0]
    ushr      v7.8H,   v7.8H, #3
    sqrdmulh v16.8H,  v16.8H, v0.H[0]
    orr      v6.16B,  v6.16B,  v7.16B
    sqrdmulh v17.8H,  v17.8H, v0.H[0]
    and      v5.16B,  v6.16B, v23.16B
    and      v4.16B,  v6.16B, v22.16B
    ushr      v5.4S,   v5.4S, #6
    orr      v4.16B,  v4.16B,  v5.16B
    and      v7.16B,  v4.16B, v25.16B
    and      v6.16B,  v4.16B, v24.16B
    ushr      v7.2D,   v7.2D, #12
    orr      v6.16B,  v6.16B,  v7.16B

    and     v11.16B,  v8.16B, v21.16B
    and     v10.16B,  v8.16B, v20.16B
    ushr     v11.8H,  v11.8H, #3
    orr     v10.16B, v10.16B, v11.16B
    and      v9.16B, v10.16B, v23.16B
    and      v8.16B, v10.16B, v22.16B
    ushr      v9.4S,   v9.4S, #6
    orr      v8.16B,  v8.16B,  v9.16B
    and     v11.16B,  v8.16B, v25.16B
    and     v10.16B,  v8.16B, v24.16B
    ushr     v11.2D,  v11.2D, #12
    orr     v10.16B, v10.16B, v11.16B

    str   s6, [x0, #(0*10+0)]
    mov   w5,  v6.S[1]
    mov   w6,  v6.S[2]
    mov   w7,  v6.S[3]
    and     v12.16B, v12.16B, v3.16B

    strb  w5, [x0, #(0*10+4)]
    str   w6, [x0, #(0*10+5)]
    strb  w7, [x0, #(0*10+9)]
    and     v13.16B, v13.16B, v3.16B

    str  s10, [x0, #(1*10+0)]
    mov   w5, v10.S[1]
    mov   w6, v10.S[2]
    mov   w7, v10.S[3]
    and     v16.16B, v16.16B, v3.16B

    strb  w5, [x0, #(1*10+4)]
    str   w6, [x0, #(1*10+5)]
    strb  w7, [x0, #(1*10+9)]
    and     v17.16B, v17.16B, v3.16B

    add x1, x1, #4*32

    __asm_poly_compress5x16_core_loop:

    xtn      v12.8B,  v12.8H
    ldr  q4, [x1, #(0*32+0*16)]
    xtn2    v12.16B,  v13.8H
    ldr  q5, [x1, #(0*32+1*16)]
    xtn      v16.8B,  v16.8H
    ldr  q8, [x1, #(1*32+0*16)]
    xtn2    v16.16B,  v17.8H
    ldr  q9, [x1, #(1*32+1*16)]

    and     v15.16B, v12.16B, v21.16B
    sqrdmulh  v4.8H,   v4.8H, v0.H[0]
    and     v14.16B, v12.16B, v20.16B
    sqrdmulh  v5.8H,   v5.8H, v0.H[0]
    ushr     v15.8H,  v15.8H, #3
    sqrdmulh  v8.8H,   v8.8H, v0.H[0]
    orr     v14.16B, v14.16B, v15.16B
    sqrdmulh  v9.8H,   v9.8H, v0.H[0]
    and     v13.16B, v14.16B, v23.16B
    and     v12.16B, v14.16B, v22.16B
    ushr     v13.4S,  v13.4S, #6
    orr     v12.16B, v12.16B, v13.16B
    and     v15.16B, v12.16B, v25.16B
    and     v14.16B, v12.16B, v24.16B
    ushr     v15.2D,  v15.2D, #12
    orr     v14.16B, v14.16B, v15.16B

    and     v19.16B, v16.16B, v21.16B
    and     v18.16B, v16.16B, v20.16B
    ushr     v19.8H,  v19.8H, #3
    orr     v18.16B, v18.16B, v19.16B
    and     v17.16B, v18.16B, v23.16B
    and     v16.16B, v18.16B, v22.16B
    ushr     v17.4S,  v17.4S, #6
    orr     v16.16B, v16.16B, v17.16B
    and     v19.16B, v16.16B, v25.16B
    and     v18.16B, v16.16B, v24.16B
    ushr     v19.2D,  v19.2D, #12
    orr     v18.16B, v18.16B, v19.16B

    str  s14, [x0, #(2*10+0)]
    mov   w5, v14.S[1]
    mov   w6, v14.S[2]
    mov   w7, v14.S[3]
    and      v4.16B,  v4.16B, v3.16B

    strb  w5, [x0, #(2*10+4)]
    str   w6, [x0, #(2*10+5)]
    strb  w7, [x0, #(2*10+9)]
    and      v5.16B,  v5.16B, v3.16B

    str  s18, [x0, #(3*10+0)]
    mov   w5, v18.S[1]
    mov   w6, v18.S[2]
    mov   w7, v18.S[3]
    and      v8.16B,  v8.16B, v3.16B

    strb  w5, [x0, #(3*10+4)]
    str   w6, [x0, #(3*10+5)]
    strb  w7, [x0, #(3*10+9)]
    and      v9.16B,  v9.16B, v3.16B

    add x0, x0, #4*10

    xtn       v4.8B,   v4.8H
    ldr q12, [x1, #(2*32+0*16)]
    xtn2     v4.16B,   v5.8H
    ldr q13, [x1, #(2*32+1*16)]
    xtn       v8.8B,   v8.8H
    ldr q16, [x1, #(3*32+0*16)]
    xtn2     v8.16B,   v9.8H
    ldr q17, [x1, #(3*32+1*16)]

    and      v7.16B,  v4.16B, v21.16B
    sqrdmulh v12.8H,  v12.8H, v0.H[0]
    and      v6.16B,  v4.16B, v20.16B
    sqrdmulh v13.8H,  v13.8H, v0.H[0]
    ushr      v7.8H,   v7.8H, #3
    sqrdmulh v16.8H,  v16.8H, v0.H[0]
    orr      v6.16B,  v6.16B,  v7.16B
    sqrdmulh v17.8H,  v17.8H, v0.H[0]
    and      v5.16B,  v6.16B, v23.16B
    and      v4.16B,  v6.16B, v22.16B
    ushr      v5.4S,   v5.4S, #6
    orr      v4.16B,  v4.16B,  v5.16B
    and      v7.16B,  v4.16B, v25.16B
    and      v6.16B,  v4.16B, v24.16B
    ushr      v7.2D,   v7.2D, #12
    orr      v6.16B,  v6.16B,  v7.16B

    and     v11.16B,  v8.16B, v21.16B
    and     v10.16B,  v8.16B, v20.16B
    ushr     v11.8H,  v11.8H, #3
    orr     v10.16B, v10.16B, v11.16B
    and      v9.16B, v10.16B, v23.16B
    and      v8.16B, v10.16B, v22.16B
    ushr      v9.4S,   v9.4S, #6
    orr      v8.16B,  v8.16B,  v9.16B
    and     v11.16B,  v8.16B, v25.16B
    and     v10.16B,  v8.16B, v24.16B
    ushr     v11.2D,  v11.2D, #12
    orr     v10.16B, v10.16B, v11.16B

    str   s6, [x0, #(0*10+0)]
    mov   w5,  v6.S[1]
    mov   w6,  v6.S[2]
    mov   w7,  v6.S[3]
    and     v12.16B, v12.16B, v3.16B

    strb  w5, [x0, #(0*10+4)]
    str   w6, [x0, #(0*10+5)]
    strb  w7, [x0, #(0*10+9)]
    and     v13.16B, v13.16B, v3.16B

    str  s10, [x0, #(1*10+0)]
    mov   w5, v10.S[1]
    mov   w6, v10.S[2]
    mov   w7, v10.S[3]
    and     v16.16B, v16.16B, v3.16B

    strb  w5, [x0, #(1*10+4)]
    str   w6, [x0, #(1*10+5)]
    strb  w7, [x0, #(1*10+9)]
    and     v17.16B, v17.16B, v3.16B

    add x1, x1, #4*32

    sub counter, counter, #4
    cbnz counter, __asm_poly_compress5x16_core_loop

    xtn      v12.8B,  v12.8H
    xtn2    v12.16B,  v13.8H
    xtn      v16.8B,  v16.8H
    xtn2    v16.16B,  v17.8H

    and     v15.16B, v12.16B, v21.16B
    and     v14.16B, v12.16B, v20.16B
    ushr     v15.8H,  v15.8H, #3
    orr     v14.16B, v14.16B, v15.16B
    and     v13.16B, v14.16B, v23.16B
    and     v12.16B, v14.16B, v22.16B
    ushr     v13.4S,  v13.4S, #6
    orr     v12.16B, v12.16B, v13.16B
    and     v15.16B, v12.16B, v25.16B
    and     v14.16B, v12.16B, v24.16B
    ushr     v15.2D,  v15.2D, #12
    orr     v14.16B, v14.16B, v15.16B

    and     v19.16B, v16.16B, v21.16B
    and     v18.16B, v16.16B, v20.16B
    ushr     v19.8H,  v19.8H, #3
    orr     v18.16B, v18.16B, v19.16B
    and     v17.16B, v18.16B, v23.16B
    and     v16.16B, v18.16B, v22.16B
    ushr     v17.4S,  v17.4S, #6
    orr     v16.16B, v16.16B, v17.16B
    and     v19.16B, v16.16B, v25.16B
    and     v18.16B, v16.16B, v24.16B
    ushr     v19.2D,  v19.2D, #12
    orr     v18.16B, v18.16B, v19.16B

    str  s14, [x0, #(2*10+0)]
    mov   w5, v14.S[1]
    mov   w6, v14.S[2]
    mov   w7, v14.S[3]

    strb  w5, [x0, #(2*10+4)]
    str   w6, [x0, #(2*10+5)]
    strb  w7, [x0, #(2*10+9)]

    str  s18, [x0, #(3*10+0)]
    mov   w5, v18.S[1]
    mov   w6, v18.S[2]
    mov   w7, v18.S[3]

    strb  w5, [x0, #(3*10+4)]
    str   w6, [x0, #(3*10+5)]
    strb  w7, [x0, #(3*10+9)]

    // add x0, x0, #4*10

    .unreq counter

    pop_all
    ret

.global __asm_poly_compress10x8_core
.global ___asm_poly_compress10x8_core
__asm_poly_compress10x8_core:
___asm_poly_compress10x8_core:

    push_simd

    counter .req x2

    sub counter, counter, #4

    mov w4, #-20553
    mov w5, #20
    mov w7, #0x3ff

    mov     v0.H[0], w4
    mov     v0.H[1], w5
    eor      v2.16B, v2.16B, v2.16B
    dup       v3.8H, w7

    mov w4, #0x3ff
    lsl w5, w4, #16
    mov x6, #0xfffff
    lsl x7, x6, #32

    dup      v20.4S, w4
    dup      v21.4S, w5
    dup      v22.2D, x6
    dup      v23.2D, x7

    ldr  q4, [x1, #0*16]
    ldr  q8, [x1, #1*16]

    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    ldr q12, [x1, #2*16]
    sqdmulh   v9.8H,   v8.8H, v0.H[0]
    ldr q16, [x1, #3*16]
    shadd     v5.8H,   v5.8H,  v2.8H
    sqdmulh  v13.8H,  v12.8H, v0.H[0]
    shadd     v9.8H,   v9.8H,  v2.8H
    sqdmulh  v17.8H,  v16.8H, v0.H[0]
    mla       v5.8H,   v4.8H, v0.H[1]
    shadd    v13.8H,  v13.8H,  v2.8H
    mla       v9.8H,   v8.8H, v0.H[1]
    shadd    v17.8H,  v17.8H,  v2.8H
    srshr     v4.8H,   v5.8H, #6
    mla      v13.8H,  v12.8H, v0.H[1]
    srshr     v8.8H,   v9.8H, #6
    mla      v17.8H,  v16.8H, v0.H[1]
    and      v4.16B,  v4.16B,  v3.16B
    srshr    v12.8H,  v13.8H, #6
    and      v8.16B,  v8.16B,  v3.16B
    srshr    v16.8H,  v17.8H, #6

    and      v7.16B,  v4.16B, v21.16B
    and     v12.16B, v12.16B,  v3.16B
    and     v11.16B,  v8.16B, v21.16B
    and     v16.16B, v16.16B,  v3.16B
    and      v6.16B,  v4.16B, v20.16B
    and     v15.16B, v12.16B, v21.16B
    and     v10.16B,  v8.16B, v20.16B
    and     v19.16B, v16.16B, v21.16B
    ushr      v7.4S,   v7.4S, #6
    and     v14.16B, v12.16B, v20.16B
    ushr     v11.4S,  v11.4S, #6
    and     v18.16B, v16.16B, v20.16B
    orr      v6.16B,  v6.16B,  v7.16B
    ushr     v15.4S,  v15.4S, #6
    orr     v10.16B, v10.16B, v11.16B
    ushr     v19.4S,  v19.4S, #6
    and      v5.16B,  v6.16B, v23.16B
    orr     v14.16B, v14.16B, v15.16B
    and      v9.16B, v10.16B, v23.16B
    orr     v18.16B, v18.16B, v19.16B
    and      v4.16B,  v6.16B, v22.16B
    and     v13.16B, v14.16B, v23.16B
    and      v8.16B, v10.16B, v22.16B
    and     v17.16B, v18.16B, v23.16B
    ushr      v5.2D,   v5.2D, #12
    and     v12.16B, v14.16B, v22.16B
    ushr      v9.2D,   v9.2D, #12
    and     v16.16B, v18.16B, v22.16B
    orr      v4.16B,  v4.16B,  v5.16B
    ushr     v13.2D,  v13.2D, #12
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v17.2D,  v17.2D, #12

    orr     v12.16B, v12.16B, v13.16B
    orr     v16.16B, v16.16B, v17.16B

    str   s4, [x0, #(0*10+0)]
    mov   w5,  v4.S[1]
    mov   w6,  v4.S[2]
    mov   w7,  v4.S[3]

    str   s8, [x0, #(1*10+0)]
    strb  w5, [x0, #(0*10+4)]
    mov   w9,  v8.S[1]
    str   w6, [x0, #(0*10+5)]
    mov  w10,  v8.S[2]
    strb  w7, [x0, #(0*10+9)]
    mov  w11,  v8.S[3]

    __asm_poly_compress10x8_core_loop:

    str  s12, [x0, #(2*10+0)]
    ldr  q4, [x1, #(4+0)*16]
    strb  w9, [x0, #(1*10+4)]
    ldr  q8, [x1, #(4+1)*16]
    mov   w5, v12.S[1]
    str  w10, [x0, #(1*10+5)]
    mov   w6, v12.S[2]
    strb w11, [x0, #(1*10+9)]
    mov   w7, v12.S[3]

    str  s16, [x0, #(3*10+0)]
    ldr q12, [x1, #(4+2)*16]
    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    strb  w5, [x0, #(2*10+4)]
    mov   w9, v16.S[1]
    sqdmulh   v9.8H,   v8.8H, v0.H[0]
    str   w6, [x0, #(2*10+5)]
    mov  w10, v16.S[2]
    strb  w7, [x0, #(2*10+9)]
    mov  w11, v16.S[3]

    strb  w9, [x0, #(3*10+4)]
    ldr q16, [x1, #(4+3)*16]
    sqdmulh  v13.8H,  v12.8H, v0.H[0]
    str  w10, [x0, #(3*10+5)]
    strb w11, [x0, #(3*10+9)]
    sqdmulh  v17.8H,  v16.8H, v0.H[0]

    shadd     v5.8H,   v5.8H,  v2.8H
    shadd     v9.8H,   v9.8H,  v2.8H
    mla       v5.8H,   v4.8H, v0.H[1]
    shadd    v13.8H,  v13.8H,  v2.8H
    mla       v9.8H,   v8.8H, v0.H[1]
    shadd    v17.8H,  v17.8H,  v2.8H
    srshr     v4.8H,   v5.8H, #6
    mla      v13.8H,  v12.8H, v0.H[1]
    srshr     v8.8H,   v9.8H, #6
    mla      v17.8H,  v16.8H, v0.H[1]
    and      v4.16B,  v4.16B,  v3.16B
    srshr    v12.8H,  v13.8H, #6
    and      v8.16B,  v8.16B,  v3.16B
    srshr    v16.8H,  v17.8H, #6

    add x1, x1, #4*16
    add x0, x0, #4*10

    and      v7.16B,  v4.16B, v21.16B
    and     v12.16B, v12.16B,  v3.16B
    and     v11.16B,  v8.16B, v21.16B
    and     v16.16B, v16.16B,  v3.16B
    and      v6.16B,  v4.16B, v20.16B
    and     v15.16B, v12.16B, v21.16B
    and     v10.16B,  v8.16B, v20.16B
    and     v19.16B, v16.16B, v21.16B
    ushr      v7.4S,   v7.4S, #6
    and     v14.16B, v12.16B, v20.16B
    ushr     v11.4S,  v11.4S, #6
    and     v18.16B, v16.16B, v20.16B
    orr      v6.16B,  v6.16B,  v7.16B
    ushr     v15.4S,  v15.4S, #6
    orr     v10.16B, v10.16B, v11.16B
    ushr     v19.4S,  v19.4S, #6
    and      v5.16B,  v6.16B, v23.16B
    orr     v14.16B, v14.16B, v15.16B
    and      v9.16B, v10.16B, v23.16B
    orr     v18.16B, v18.16B, v19.16B
    and      v4.16B,  v6.16B, v22.16B
    and     v13.16B, v14.16B, v23.16B
    and      v8.16B, v10.16B, v22.16B
    and     v17.16B, v18.16B, v23.16B
    ushr      v5.2D,   v5.2D, #12
    and     v12.16B, v14.16B, v22.16B
    ushr      v9.2D,   v9.2D, #12
    and     v16.16B, v18.16B, v22.16B
    orr      v4.16B,  v4.16B,  v5.16B
    ushr     v13.2D,  v13.2D, #12
    orr      v8.16B,  v8.16B,  v9.16B
    ushr     v17.2D,  v17.2D, #12

    orr     v12.16B, v12.16B, v13.16B
    orr     v16.16B, v16.16B, v17.16B

    str   s4, [x0, #(0*10+0)]
    mov   w5,  v4.S[1]
    mov   w6,  v4.S[2]
    mov   w7,  v4.S[3]

    str   s8, [x0, #(1*10+0)]
    strb  w5, [x0, #(0*10+4)]
    mov   w9,  v8.S[1]
    str   w6, [x0, #(0*10+5)]
    mov  w10,  v8.S[2]
    strb  w7, [x0, #(0*10+9)]
    mov  w11,  v8.S[3]

    sub counter, counter, #4
    cbnz counter, __asm_poly_compress10x8_core_loop

    str  s12, [x0, #(2*10+0)]
    strb  w9, [x0, #(1*10+4)]
    mov   w5, v12.S[1]
    str  w10, [x0, #(1*10+5)]
    mov   w6, v12.S[2]
    strb w11, [x0, #(1*10+9)]
    mov   w7, v12.S[3]

    str  s16, [x0, #(3*10+0)]
    strb  w5, [x0, #(2*10+4)]
    mov   w9, v16.S[1]
    str   w6, [x0, #(2*10+5)]
    mov  w10, v16.S[2]
    strb  w7, [x0, #(2*10+9)]
    mov  w11, v16.S[3]

    strb  w9, [x0, #(3*10+4)]
    str  w10, [x0, #(3*10+5)]
    strb w11, [x0, #(3*10+9)]

    add x1, x1, #4*16
    add x0, x0, #4*10

    .unreq counter

    pop_simd
    ret

.global __asm_poly_compress11x8_core
.global ___asm_poly_compress11x8_core
__asm_poly_compress11x8_core:
___asm_poly_compress11x8_core:

    push_simd

    counter .req x2

    sub counter, counter, #4

    mov w4, #-20553
    mov w5, #20
    mov w7, #0x7ff

    mov     v0.H[0], w4
    mov     v0.H[1], w5
    eor      v2.16B, v2.16B, v2.16B
    dup       v3.8H, w7

    mov w4, #0x7ff
    lsl w5, w4, #16
    mov x6, #0x3ffffff
    lsl x7, x6, #32

    dup      v20.4S, w4
    dup      v21.4S, w5
    dup      v22.2D, x6
    dup      v23.2D, x7

    ldr  q4, [x1, #0*16]
    ldr  q8, [x1, #1*16]
    ldr q12, [x1, #2*16]
    ldr q16, [x1, #3*16]

    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    shadd     v5.8H,   v5.8H,  v2.8H
    mla       v5.8H,   v4.8H, v0.H[1]
    srshr     v4.8H,   v5.8H, #5
    and      v4.16B,  v4.16B, v3.16B

    and      v7.16B,  v4.16B, v21.16B
    and      v6.16B,  v4.16B, v20.16B
    ushr      v7.4S,   v7.4S, #5
    orr      v6.16B,  v6.16B,  v7.16B
    and      v5.16B,  v6.16B, v23.16B
    and      v4.16B,  v6.16B, v22.16B
    ushr      v5.2D,   v5.2D, #10
    orr      v4.16B,  v4.16B,  v5.16B

    sqdmulh   v9.8H,   v8.8H, v0.H[0]
    str   s4, [x0, #(0*11+0)]
    shadd     v9.8H,   v9.8H,  v2.8H
    mov   w5,  v4.S[1]
    mla       v9.8H,   v8.8H, v0.H[1]
    mov   w6,  v4.S[2]
    srshr     v8.8H,   v9.8H, #5
    mov   w7,  v4.S[3]
    and      v8.16B,  v8.16B, v3.16B

    and     v11.16B,  v8.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v10.16B,  v8.16B, v20.16B
    str   w5, [x0, #(0*11+4)]
    ushr     v11.4S,  v11.4S, #5
    lsr   w6, w6, #20
    orr     v10.16B, v10.16B, v11.16B
    orr   w6, w6, w7, lsl #12
    and      v9.16B, v10.16B, v23.16B
    strh  w6, [x0, #(0*11+8)]
    and      v8.16B, v10.16B, v22.16B
    lsr   w7, w6, #16
    ushr      v9.2D,   v9.2D, #10
    strb  w7, [x0, #(0*11+10)]
    orr      v8.16B,  v8.16B,  v9.16B

    sqdmulh  v13.8H,  v12.8H, v0.H[0]
    str   s8, [x0, #(1*11+0)]
    shadd    v13.8H,  v13.8H,  v2.8H
    mov   w5,  v8.S[1]
    mla      v13.8H,  v12.8H, v0.H[1]
    mov   w6,  v8.S[2]
    srshr    v12.8H,  v13.8H, #5
    mov   w7,  v8.S[3]
    and     v12.16B, v12.16B, v3.16B

    and     v15.16B, v12.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v14.16B, v12.16B, v20.16B
    str   w5, [x0, #(1*11+4)]
    ushr     v15.4S,  v15.4S, #5
    lsr   w6, w6, #20
    orr     v14.16B, v14.16B, v15.16B
    orr   w6, w6, w7, lsl #12
    and     v13.16B, v14.16B, v23.16B
    strh  w6, [x0, #(1*11+8)]
    and     v12.16B, v14.16B, v22.16B
    lsr   w7, w6, #16
    ushr     v13.2D,  v13.2D, #10
    strb  w7, [x0, #(1*11+10)]
    orr     v12.16B, v12.16B, v13.16B

    sqdmulh  v17.8H,  v16.8H, v0.H[0]
    str  s12, [x0, #(2*11+0)]
    shadd    v17.8H,  v17.8H,  v2.8H
    mov   w5, v12.S[1]
    mla      v17.8H,  v16.8H, v0.H[1]
    mov   w6, v12.S[2]
    srshr    v16.8H,  v17.8H, #5
    mov   w7, v12.S[3]
    and     v16.16B, v16.16B, v3.16B

    and     v19.16B, v16.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v18.16B, v16.16B, v20.16B
    str   w5, [x0, #(2*11+4)]
    ushr     v19.4S,  v19.4S, #5
    lsr   w6, w6, #20
    orr     v18.16B, v18.16B, v19.16B
    orr   w6, w6, w7, lsl #12
    and     v17.16B, v18.16B, v23.16B
    strh  w6, [x0, #(2*11+8)]
    and     v16.16B, v18.16B, v22.16B
    lsr   w7, w6, #16
    ushr     v17.2D,  v17.2D, #10
    strb  w7, [x0, #(2*11+10)]
    orr     v16.16B, v16.16B, v17.16B

    __asm_poly_compress11x8_core_loop:

    ldr  q4, [x1, #(4+0)*16]
    ldr  q8, [x1, #(4+1)*16]

    sqdmulh   v5.8H,   v4.8H, v0.H[0]
    str  s16, [x0, #(3*11+0)]
    shadd     v5.8H,   v5.8H,  v2.8H
    mov   w5, v16.S[1]
    mla       v5.8H,   v4.8H, v0.H[1]
    mov   w6, v16.S[2]
    srshr     v4.8H,   v5.8H, #5
    mov   w7, v16.S[3]
    and      v4.16B,  v4.16B, v3.16B

    and      v7.16B,  v4.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and      v6.16B,  v4.16B, v20.16B
    str   w5, [x0, #(3*11+4)]
    ushr      v7.4S,   v7.4S, #5
    lsr   w6, w6, #20
    orr      v6.16B,  v6.16B,  v7.16B
    orr   w6, w6, w7, lsl #12
    and      v5.16B,  v6.16B, v23.16B
    strh  w6, [x0, #(3*11+8)]
    and      v4.16B,  v6.16B, v22.16B
    lsr   w7, w6, #16
    ushr      v5.2D,   v5.2D, #10
    strb  w7, [x0, #(3*11+10)]
    orr      v4.16B,  v4.16B,  v5.16B

    add x0, x0, #4*11

    ldr q12, [x1, #(4+2)*16]
    ldr q16, [x1, #(4+3)*16]

    add x1, x1, #4*16

    sqdmulh   v9.8H,   v8.8H, v0.H[0]
    str   s4, [x0, #(0*11+0)]
    shadd     v9.8H,   v9.8H,  v2.8H
    mov   w5,  v4.S[1]
    mla       v9.8H,   v8.8H, v0.H[1]
    mov   w6,  v4.S[2]
    srshr     v8.8H,   v9.8H, #5
    mov   w7,  v4.S[3]
    and      v8.16B,  v8.16B, v3.16B

    and     v11.16B,  v8.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v10.16B,  v8.16B, v20.16B
    str   w5, [x0, #(0*11+4)]
    ushr     v11.4S,  v11.4S, #5
    lsr   w6, w6, #20
    orr     v10.16B, v10.16B, v11.16B
    orr   w6, w6, w7, lsl #12
    and      v9.16B, v10.16B, v23.16B
    strh  w6, [x0, #(0*11+8)]
    and      v8.16B, v10.16B, v22.16B
    lsr   w7, w6, #16
    ushr      v9.2D,   v9.2D, #10
    strb  w7, [x0, #(0*11+10)]
    orr      v8.16B,  v8.16B,  v9.16B

    sqdmulh  v13.8H,  v12.8H, v0.H[0]
    str   s8, [x0, #(1*11+0)]
    shadd    v13.8H,  v13.8H,  v2.8H
    mov   w5,  v8.S[1]
    mla      v13.8H,  v12.8H, v0.H[1]
    mov   w6,  v8.S[2]
    srshr    v12.8H,  v13.8H, #5
    mov   w7,  v8.S[3]
    and     v12.16B, v12.16B, v3.16B

    and     v15.16B, v12.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v14.16B, v12.16B, v20.16B
    str   w5, [x0, #(1*11+4)]
    ushr     v15.4S,  v15.4S, #5
    lsr   w6, w6, #20
    orr     v14.16B, v14.16B, v15.16B
    orr   w6, w6, w7, lsl #12
    and     v13.16B, v14.16B, v23.16B
    strh  w6, [x0, #(1*11+8)]
    and     v12.16B, v14.16B, v22.16B
    lsr   w7, w6, #16
    ushr     v13.2D,  v13.2D, #10
    strb  w7, [x0, #(1*11+10)]
    orr     v12.16B, v12.16B, v13.16B

    sqdmulh  v17.8H,  v16.8H, v0.H[0]
    str  s12, [x0, #(2*11+0)]
    shadd    v17.8H,  v17.8H,  v2.8H
    mov   w5, v12.S[1]
    mla      v17.8H,  v16.8H, v0.H[1]
    mov   w6, v12.S[2]
    srshr    v16.8H,  v17.8H, #5
    mov   w7, v12.S[3]
    and     v16.16B, v16.16B, v3.16B

    and     v19.16B, v16.16B, v21.16B
    orr   w5, w5, w6, lsl #12
    and     v18.16B, v16.16B, v20.16B
    str   w5, [x0, #(2*11+4)]
    ushr     v19.4S,  v19.4S, #5
    lsr   w6, w6, #20
    orr     v18.16B, v18.16B, v19.16B
    orr   w6, w6, w7, lsl #12
    and     v17.16B, v18.16B, v23.16B
    strh  w6, [x0, #(2*11+8)]
    and     v16.16B, v18.16B, v22.16B
    lsr   w7, w6, #16
    ushr     v17.2D,  v17.2D, #10
    strb  w7, [x0, #(2*11+10)]
    orr     v16.16B, v16.16B, v17.16B

    sub counter, counter, #4
    cbnz counter, __asm_poly_compress11x8_core_loop

    str  s16, [x0, #(3*11+0)]
    mov   w5, v16.S[1]
    mov   w6, v16.S[2]
    mov   w7, v16.S[3]

    orr   w5, w5, w6, lsl #12
    str   w5, [x0, #(3*11+4)]
    lsr   w6, w6, #20
    orr   w6, w6, w7, lsl #12
    strh  w6, [x0, #(3*11+8)]
    lsr   w7, w6, #16
    strb  w7, [x0, #(3*11+10)]

    add x1, x1, #4*16
    add x0, x0, #4*11

    .unreq counter

    pop_simd
    ret

