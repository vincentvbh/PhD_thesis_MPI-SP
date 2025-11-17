
#include "cdecl.h"

.macro push_all

    sub sp, sp, #(9*16)
    stp x19, x20, [sp, #0*16]
    stp x21, x22, [sp, #1*16]
    stp x23, x24, [sp, #2*16]
    stp x25, x26, [sp, #3*16]
    stp x27, x28, [sp, #4*16]
    stp  d8,  d9, [sp, #5*16]
    stp d10, d11, [sp, #6*16]
    stp d12, d13, [sp, #7*16]
    stp d14, d15, [sp, #8*16]

.endm

.macro pop_all

    ldp x19, x20, [sp, #0*16]
    ldp x21, x22, [sp, #1*16]
    ldp x23, x24, [sp, #2*16]
    ldp x25, x26, [sp, #3*16]
    ldp x27, x28, [sp, #4*16]
    ldp  d8,  d9, [sp, #5*16]
    ldp d10, d11, [sp, #6*16]
    ldp d12, d13, [sp, #7*16]
    ldp d14, d15, [sp, #8*16]
    add sp, sp, #(9*16)

.endm

.macro push_simd

    sub sp, sp, #(4*16)
    stp  d8,  d9, [sp, #0*16]
    stp d10, d11, [sp, #1*16]
    stp d12, d13, [sp, #2*16]
    stp d14, d15, [sp, #3*16]

.endm

.macro pop_simd

    ldp  d8,  d9, [sp, #0*16]
    ldp d10, d11, [sp, #1*16]
    ldp d12, d13, [sp, #2*16]
    ldp d14, d15, [sp, #3*16]
    add sp, sp, #(4*16)

.endm

.align 6
.global cdecl(__asm_Toeplitz_negacyclic8_Z65536_prototype)
cdecl(__asm_Toeplitz_negacyclic8_Z65536_prototype):

    push_simd

    ldr  q0, [x1]
    ldr  q1, [x2]

    neg    v10.8H,  v1.8H
    ext    v2.16B, v10.16B,  v1.16B, #14
    ext    v3.16B, v10.16B,  v1.16B, #12
    ext    v4.16B, v10.16B,  v1.16B, #10
    ext    v5.16B, v10.16B,  v1.16B, # 8
    ext    v6.16B, v10.16B,  v1.16B, # 6
    ext    v7.16B, v10.16B,  v1.16B, # 4
    ext    v8.16B, v10.16B,  v1.16B, # 2

    mul     v9.8H,   v1.8H,  v0.H[0]
    mla     v9.8H,   v2.8H,  v0.H[1]
    mla     v9.8H,   v3.8H,  v0.H[2]
    mla     v9.8H,   v4.8H,  v0.H[3]
    mla     v9.8H,   v5.8H,  v0.H[4]
    mla     v9.8H,   v6.8H,  v0.H[5]
    mla     v9.8H,   v7.8H,  v0.H[6]
    mla     v9.8H,   v8.8H,  v0.H[7]

    str  q9, [x0]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_negacyclic8_Z65536_flexible)
cdecl(__asm_Toeplitz_negacyclic8_Z65536_flexible):

    push_simd

    next_bytes .req x3
    counter    .req x4

    sub counter, counter, #2

    ldr  q0, [x1]
    ldr  q1, [x2]

    add x1, x1, next_bytes
    add x2, x2, next_bytes

    neg  v11.8H,   v1.8H
    ext  v4.16B, v11.16B,  v1.16B, #14
    ldr  q2, [x1]
    add x1, x1, next_bytes
    ext  v5.16B, v11.16B,  v1.16B, #12
    ext  v6.16B, v11.16B,  v1.16B, #10
    ldr  q3, [x2]
    add x2, x2, next_bytes
    ext  v7.16B, v11.16B,  v1.16B, # 8
    ext  v8.16B, v11.16B,  v1.16B, # 6
    ext  v9.16B, v11.16B,  v1.16B, # 4
    ext v10.16B, v11.16B,  v1.16B, # 2

    mul  v28.8H,   v1.8H,  v0.H[0]
    neg  v19.8H,   v3.8H
    mla  v28.8H,   v4.8H,  v0.H[1]
    ext v12.16B, v19.16B,  v3.16B, #14
    mla  v28.8H,   v5.8H,  v0.H[2]
    ext v13.16B, v19.16B,  v3.16B, #12
    mla  v28.8H,   v6.8H,  v0.H[3]
    ext v14.16B, v19.16B,  v3.16B, #10
    mla  v28.8H,   v7.8H,  v0.H[4]
    ext v15.16B, v19.16B,  v3.16B, # 8
    mla  v28.8H,   v8.8H,  v0.H[5]
    ext v16.16B, v19.16B,  v3.16B, # 6
    mla  v28.8H,   v9.8H,  v0.H[6]
    ext v17.16B, v19.16B,  v3.16B, # 4
    mla  v28.8H,  v10.8H,  v0.H[7]
    ext v18.16B, v19.16B,  v3.16B, # 2

    str q28, [x0]
    add x0, x0, next_bytes

    __asm_Toeplitz_negacyclic8_Z65536_flexible_loop:

    ldr  q0, [x1]
    add x1, x1, next_bytes
    ldr  q1, [x2]
    add x2, x2, next_bytes

    mul  v29.8H,   v3.8H,  v2.H[0]
    neg  v11.8H,   v1.8H
    mla  v29.8H,  v12.8H,  v2.H[1]
    ext  v4.16B, v11.16B,  v1.16B, #14
    mla  v29.8H,  v13.8H,  v2.H[2]
    ext  v5.16B, v11.16B,  v1.16B, #12
    mla  v29.8H,  v14.8H,  v2.H[3]
    ext  v6.16B, v11.16B,  v1.16B, #10
    mla  v29.8H,  v15.8H,  v2.H[4]
    ext  v7.16B, v11.16B,  v1.16B, # 8
    mla  v29.8H,  v16.8H,  v2.H[5]
    ext  v8.16B, v11.16B,  v1.16B, # 6
    mla  v29.8H,  v17.8H,  v2.H[6]
    ext  v9.16B, v11.16B,  v1.16B, # 4
    mla  v29.8H,  v18.8H,  v2.H[7]
    ext v10.16B, v11.16B,  v1.16B, # 2

    str q29, [x0]
    add x0, x0, next_bytes

    ldr  q2, [x1]
    add x1, x1, next_bytes
    ldr  q3, [x2]
    add x2, x2, next_bytes

    mul  v28.8H,   v1.8H,  v0.H[0]
    neg  v19.8H,   v3.8H
    mla  v28.8H,   v4.8H,  v0.H[1]
    ext v12.16B, v19.16B,  v3.16B, #14
    mla  v28.8H,   v5.8H,  v0.H[2]
    ext v13.16B, v19.16B,  v3.16B, #12
    mla  v28.8H,   v6.8H,  v0.H[3]
    ext v14.16B, v19.16B,  v3.16B, #10
    mla  v28.8H,   v7.8H,  v0.H[4]
    ext v15.16B, v19.16B,  v3.16B, # 8
    mla  v28.8H,   v8.8H,  v0.H[5]
    ext v16.16B, v19.16B,  v3.16B, # 6
    mla  v28.8H,   v9.8H,  v0.H[6]
    ext v17.16B, v19.16B,  v3.16B, # 4
    mla  v28.8H,  v10.8H,  v0.H[7]
    ext v18.16B, v19.16B,  v3.16B, # 2

    str q28, [x0]
    add x0, x0, next_bytes

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_negacyclic8_Z65536_flexible_loop

    mul  v29.8H,  v3.8H,  v2.H[0]
    mla  v29.8H, v12.8H,  v2.H[1]
    mla  v29.8H, v13.8H,  v2.H[2]
    mla  v29.8H, v14.8H,  v2.H[3]
    mla  v29.8H, v15.8H,  v2.H[4]
    mla  v29.8H, v16.8H,  v2.H[5]
    mla  v29.8H, v17.8H,  v2.H[6]
    mla  v29.8H, v18.8H,  v2.H[7]

    str q29, [x0]
    // add x0, x0, next_bytes

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype):

    push_simd

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x2, #0*16]
    ldr  q3, [x2, #1*16]

    neg  v14.8H, v2.8H
    neg  v15.8H, v3.8H

    sub   v8.8H,   v2.8H,  v15.8H
    sub   v9.8H,   v3.8H,   v2.8H
    mov v10.16B, v15.16B
    mov v11.16B,  v2.16B
    sub  v12.8H,  v14.8H,  v15.8H
    sub  v13.8H,  v15.8H,   v2.8H

    add   v2.8H,   v0.8H,   v1.8H

    mov v16.16B,  v9.16B
    ext v17.16B,  v8.16B,  v9.16B, #14
    ext v18.16B,  v8.16B,  v9.16B, #12
    ext v19.16B,  v8.16B,  v9.16B, #10
    ext v20.16B,  v8.16B,  v9.16B, # 8
    ext v21.16B,  v8.16B,  v9.16B, # 6
    ext v22.16B,  v8.16B,  v9.16B, # 4
    ext v23.16B,  v8.16B,  v9.16B, # 2

    mul  v14.8H,  v16.8H,  v0.H[0]
    mla  v14.8H,  v17.8H,  v0.H[1]
    mla  v14.8H,  v18.8H,  v0.H[2]
    mla  v14.8H,  v19.8H,  v0.H[3]
    mla  v14.8H,  v20.8H,  v0.H[4]
    mla  v14.8H,  v21.8H,  v0.H[5]
    mla  v14.8H,  v22.8H,  v0.H[6]
    mla  v14.8H,  v23.8H,  v0.H[7]

    mov v24.16B, v11.16B
    ext v25.16B, v10.16B, v11.16B, #14
    ext v26.16B, v10.16B, v11.16B, #12
    ext v27.16B, v10.16B, v11.16B, #10
    ext v28.16B, v10.16B, v11.16B, # 8
    ext v29.16B, v10.16B, v11.16B, # 6
    ext v30.16B, v10.16B, v11.16B, # 4
    ext v31.16B, v10.16B, v11.16B, # 2

    mul   v3.8H,  v24.8H,  v2.H[0]
    mla   v3.8H,  v25.8H,  v2.H[1]
    mla   v3.8H,  v26.8H,  v2.H[2]
    mla   v3.8H,  v27.8H,  v2.H[3]
    mla   v3.8H,  v28.8H,  v2.H[4]
    mla   v3.8H,  v29.8H,  v2.H[5]
    mla   v3.8H,  v30.8H,  v2.H[6]
    mla   v3.8H,  v31.8H,  v2.H[7]

    mov v16.16B, v13.16B
    ext v17.16B, v12.16B, v13.16B, #14
    ext v18.16B, v12.16B, v13.16B, #12
    ext v19.16B, v12.16B, v13.16B, #10
    ext v20.16B, v12.16B, v13.16B, # 8
    ext v21.16B, v12.16B, v13.16B, # 6
    ext v22.16B, v12.16B, v13.16B, # 4
    ext v23.16B, v12.16B, v13.16B, # 2

    mul  v15.8H,  v16.8H,  v1.H[0]
    mla  v15.8H,  v17.8H,  v1.H[1]
    mla  v15.8H,  v18.8H,  v1.H[2]
    mla  v15.8H,  v19.8H,  v1.H[3]
    mla  v15.8H,  v20.8H,  v1.H[4]
    mla  v15.8H,  v21.8H,  v1.H[5]
    mla  v15.8H,  v22.8H,  v1.H[6]
    mla  v15.8H,  v23.8H,  v1.H[7]

    add  v14.8H,  v14.8H,   v3.8H
    add  v15.8H,  v15.8H,   v3.8H

    str q14, [x0, #1*16]
    str q15, [x0, #0*16]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible):

    push_simd

    next_bytes .req x3
    counter    .req x4

    sub counter, counter, #2

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x2, #0*16]
    ldr  q3, [x2, #1*16]

    add x1, x1, next_bytes
    add x2, x2, next_bytes

    neg v14.8H, v2.8H
    neg v15.8H, v3.8H

    sub   v8.8H,   v2.8H,  v15.8H
    sub   v9.8H,   v3.8H,   v2.8H
    mov v10.16B, v15.16B
    mov v11.16B,  v2.16B
    sub  v12.8H,  v14.8H,  v15.8H
    sub  v13.8H,  v15.8H,   v2.8H

    add   v2.8H,   v0.8H,   v1.8H

    mov v16.16B,  v9.16B
    ext v17.16B,  v8.16B,  v9.16B, #14
    ext v18.16B,  v8.16B,  v9.16B, #12
    ext v19.16B,  v8.16B,  v9.16B, #10
    ext v20.16B,  v8.16B,  v9.16B, # 8
    ext v21.16B,  v8.16B,  v9.16B, # 6
    ext v22.16B,  v8.16B,  v9.16B, # 4
    ext v23.16B,  v8.16B,  v9.16B, # 2

    mul  v14.8H,  v16.8H,  v0.H[0]
    mov v24.16B, v11.16B
    mla  v14.8H,  v17.8H,  v0.H[1]
    ext v25.16B, v10.16B, v11.16B, #14
    mla  v14.8H,  v18.8H,  v0.H[2]
    ext v26.16B, v10.16B, v11.16B, #12
    mla  v14.8H,  v19.8H,  v0.H[3]
    ext v27.16B, v10.16B, v11.16B, #10
    mla  v14.8H,  v20.8H,  v0.H[4]
    ext v28.16B, v10.16B, v11.16B, # 8
    mla  v14.8H,  v21.8H,  v0.H[5]
    ext v29.16B, v10.16B, v11.16B, # 6
    mla  v14.8H,  v22.8H,  v0.H[6]
    ext v30.16B, v10.16B, v11.16B, # 4
    mla  v14.8H,  v23.8H,  v0.H[7]
    ext v31.16B, v10.16B, v11.16B, # 2

    mul   v3.8H,  v24.8H,  v2.H[0]
    mov v16.16B, v13.16B
    mla   v3.8H,  v25.8H,  v2.H[1]
    ext v17.16B, v12.16B, v13.16B, #14
    mla   v3.8H,  v26.8H,  v2.H[2]
    ext v18.16B, v12.16B, v13.16B, #12
    mla   v3.8H,  v27.8H,  v2.H[3]
    ext v19.16B, v12.16B, v13.16B, #10
    mla   v3.8H,  v28.8H,  v2.H[4]
    ext v20.16B, v12.16B, v13.16B, # 8
    mla   v3.8H,  v29.8H,  v2.H[5]
    ext v21.16B, v12.16B, v13.16B, # 6
    mla   v3.8H,  v30.8H,  v2.H[6]
    ext v22.16B, v12.16B, v13.16B, # 4
    mla   v3.8H,  v31.8H,  v2.H[7]
    ext v23.16B, v12.16B, v13.16B, # 2

    mul v15.8H, v16.8H,  v1.H[0]
    ldr  q4, [x1, #0*16]
    mla v15.8H, v17.8H,  v1.H[1]
    ldr  q5, [x1, #1*16]
    mla v15.8H, v18.8H,  v1.H[2]
    ldr  q6, [x2, #0*16]
    mla v15.8H, v19.8H,  v1.H[3]
    ldr  q7, [x2, #1*16]
    mla v15.8H, v20.8H,  v1.H[4]
    add x1, x1, next_bytes
    mla v15.8H, v21.8H,  v1.H[5]
    add x2, x2, next_bytes
    mla v15.8H, v22.8H,  v1.H[6]
    mla v15.8H, v23.8H,  v1.H[7]

    add v14.8H, v14.8H,  v3.8H
    add v15.8H, v15.8H,  v3.8H

    str q14, [x0, #1*16]
    neg v14.8H, v6.8H
    str q15, [x0, #0*16]
    neg v15.8H, v7.8H

    add x0, x0, next_bytes

    sub   v8.8H,  v6.8H, v15.8H
    sub   v9.8H,  v7.8H,  v6.8H
    mov v10.16B, v15.16B
    mov v11.16B,  v6.16B
    sub  v12.8H, v14.8H, v15.8H
    sub  v13.8H, v15.8H,  v6.8H

    add   v6.8H,  v4.8H,  v5.8H

    mov v16.16B,  v9.16B
    ext v17.16B,  v8.16B,  v9.16B, #14
    ext v18.16B,  v8.16B,  v9.16B, #12
    ext v19.16B,  v8.16B,  v9.16B, #10
    ext v20.16B,  v8.16B,  v9.16B, # 8
    ext v21.16B,  v8.16B,  v9.16B, # 6
    ext v22.16B,  v8.16B,  v9.16B, # 4
    ext v23.16B,  v8.16B,  v9.16B, # 2

    mul  v14.8H,  v16.8H,  v4.H[0]
    mov v24.16B, v11.16B
    mla  v14.8H,  v17.8H,  v4.H[1]
    ext v25.16B, v10.16B, v11.16B, #14
    mla  v14.8H,  v18.8H,  v4.H[2]
    ext v26.16B, v10.16B, v11.16B, #12
    mla  v14.8H,  v19.8H,  v4.H[3]
    ext v27.16B, v10.16B, v11.16B, #10
    mla  v14.8H,  v20.8H,  v4.H[4]
    ext v28.16B, v10.16B, v11.16B, # 8
    mla  v14.8H,  v21.8H,  v4.H[5]
    ext v29.16B, v10.16B, v11.16B, # 6
    mla  v14.8H,  v22.8H,  v4.H[6]
    ext v30.16B, v10.16B, v11.16B, # 4
    mla  v14.8H,  v23.8H,  v4.H[7]
    ext v31.16B, v10.16B, v11.16B, # 2

    mul   v7.8H,  v24.8H,  v6.H[0]
    mov v16.16B, v13.16B
    mla   v7.8H,  v25.8H,  v6.H[1]
    ext v17.16B, v12.16B, v13.16B, #14
    mla   v7.8H,  v26.8H,  v6.H[2]
    ext v18.16B, v12.16B, v13.16B, #12
    mla   v7.8H,  v27.8H,  v6.H[3]
    ext v19.16B, v12.16B, v13.16B, #10
    mla   v7.8H,  v28.8H,  v6.H[4]
    ext v20.16B, v12.16B, v13.16B, # 8
    mla   v7.8H,  v29.8H,  v6.H[5]
    ext v21.16B, v12.16B, v13.16B, # 6
    mla   v7.8H,  v30.8H,  v6.H[6]
    ext v22.16B, v12.16B, v13.16B, # 4
    mla   v7.8H,  v31.8H,  v6.H[7]
    ext v23.16B, v12.16B, v13.16B, # 2

    __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible_loop:

    mul  v15.8H, v16.8H,  v5.H[0]
    ldr  q0, [x1, #0*16]
    mla  v15.8H, v17.8H,  v5.H[1]
    ldr  q1, [x1, #1*16]
    mla  v15.8H, v18.8H,  v5.H[2]
    ldr  q2, [x2, #0*16]
    mla  v15.8H, v19.8H,  v5.H[3]
    ldr  q3, [x2, #1*16]
    mla  v15.8H, v20.8H,  v5.H[4]
    add x1, x1, next_bytes
    mla  v15.8H, v21.8H,  v5.H[5]
    add x2, x2, next_bytes
    mla  v15.8H, v22.8H,  v5.H[6]
    mla  v15.8H, v23.8H,  v5.H[7]

    add  v14.8H, v14.8H,  v7.8H
    add  v15.8H, v15.8H,  v7.8H

    str q14, [x0, #1*16]
    neg  v14.8H, v2.8H
    str q15, [x0, #0*16]
    neg  v15.8H, v3.8H

    add x0, x0, next_bytes

    sub   v8.8H,  v2.8H, v15.8H
    sub   v9.8H,  v3.8H,  v2.8H
    mov v10.16B, v15.16B
    mov v11.16B,  v2.16B
    sub  v12.8H, v14.8H, v15.8H
    sub  v13.8H, v15.8H,  v2.8H

    add   v2.8H,   v0.8H,   v1.8H

    mov v16.16B,  v9.16B
    ext v17.16B,  v8.16B,  v9.16B, #14
    ext v18.16B,  v8.16B,  v9.16B, #12
    ext v19.16B,  v8.16B,  v9.16B, #10
    ext v20.16B,  v8.16B,  v9.16B, # 8
    ext v21.16B,  v8.16B,  v9.16B, # 6
    ext v22.16B,  v8.16B,  v9.16B, # 4
    ext v23.16B,  v8.16B,  v9.16B, # 2

    mul  v14.8H,  v16.8H,  v0.H[0]
    mov v24.16B, v11.16B
    mla  v14.8H,  v17.8H,  v0.H[1]
    ext v25.16B, v10.16B, v11.16B, #14
    mla  v14.8H,  v18.8H,  v0.H[2]
    ext v26.16B, v10.16B, v11.16B, #12
    mla  v14.8H,  v19.8H,  v0.H[3]
    ext v27.16B, v10.16B, v11.16B, #10
    mla  v14.8H,  v20.8H,  v0.H[4]
    ext v28.16B, v10.16B, v11.16B, # 8
    mla  v14.8H,  v21.8H,  v0.H[5]
    ext v29.16B, v10.16B, v11.16B, # 6
    mla  v14.8H,  v22.8H,  v0.H[6]
    ext v30.16B, v10.16B, v11.16B, # 4
    mla  v14.8H,  v23.8H,  v0.H[7]
    ext v31.16B, v10.16B, v11.16B, # 2

    mul   v3.8H,  v24.8H,  v2.H[0]
    mov v16.16B, v13.16B
    mla   v3.8H,  v25.8H,  v2.H[1]
    ext v17.16B, v12.16B, v13.16B, #14
    mla   v3.8H,  v26.8H,  v2.H[2]
    ext v18.16B, v12.16B, v13.16B, #12
    mla   v3.8H,  v27.8H,  v2.H[3]
    ext v19.16B, v12.16B, v13.16B, #10
    mla   v3.8H,  v28.8H,  v2.H[4]
    ext v20.16B, v12.16B, v13.16B, # 8
    mla   v3.8H,  v29.8H,  v2.H[5]
    ext v21.16B, v12.16B, v13.16B, # 6
    mla   v3.8H,  v30.8H,  v2.H[6]
    ext v22.16B, v12.16B, v13.16B, # 4
    mla   v3.8H,  v31.8H,  v2.H[7]
    ext v23.16B, v12.16B, v13.16B, # 2

    mul  v15.8H, v16.8H,  v1.H[0]
    ldr  q4, [x1, #0*16]
    mla  v15.8H, v17.8H,  v1.H[1]
    ldr  q5, [x1, #1*16]
    mla  v15.8H, v18.8H,  v1.H[2]
    ldr  q6, [x2, #0*16]
    mla  v15.8H, v19.8H,  v1.H[3]
    ldr  q7, [x2, #1*16]
    mla  v15.8H, v20.8H,  v1.H[4]
    add x1, x1, next_bytes
    mla  v15.8H, v21.8H,  v1.H[5]
    add x2, x2, next_bytes
    mla  v15.8H, v22.8H,  v1.H[6]
    mla  v15.8H, v23.8H,  v1.H[7]

    add   v14.8H,  v14.8H,   v3.8H
    add   v15.8H,  v15.8H,   v3.8H

    str q14, [x0, #1*16]
    neg    v14.8H,   v6.8H
    str q15, [x0, #0*16]
    neg    v15.8H,   v7.8H

    add x0, x0, next_bytes

    sub     v8.8H,   v6.8H,  v15.8H
    sub     v9.8H,   v7.8H,   v6.8H
    mov   v10.16B, v15.16B
    mov   v11.16B,  v6.16B
    sub    v12.8H,  v14.8H,  v15.8H
    sub    v13.8H,  v15.8H,   v6.8H

    add     v6.8H,   v4.8H,   v5.8H

    mov   v16.16B,  v9.16B
    ext   v17.16B,  v8.16B,  v9.16B, #14
    ext   v18.16B,  v8.16B,  v9.16B, #12
    ext   v19.16B,  v8.16B,  v9.16B, #10
    ext   v20.16B,  v8.16B,  v9.16B, # 8
    ext   v21.16B,  v8.16B,  v9.16B, # 6
    ext   v22.16B,  v8.16B,  v9.16B, # 4
    ext   v23.16B,  v8.16B,  v9.16B, # 2

    mul    v14.8H,  v16.8H,  v4.H[0]
    mov   v24.16B, v11.16B
    mla    v14.8H,  v17.8H,  v4.H[1]
    ext   v25.16B, v10.16B, v11.16B, #14
    mla    v14.8H,  v18.8H,  v4.H[2]
    ext   v26.16B, v10.16B, v11.16B, #12
    mla    v14.8H,  v19.8H,  v4.H[3]
    ext   v27.16B, v10.16B, v11.16B, #10
    mla    v14.8H,  v20.8H,  v4.H[4]
    ext   v28.16B, v10.16B, v11.16B, # 8
    mla    v14.8H,  v21.8H,  v4.H[5]
    ext   v29.16B, v10.16B, v11.16B, # 6
    mla    v14.8H,  v22.8H,  v4.H[6]
    ext   v30.16B, v10.16B, v11.16B, # 4
    mla    v14.8H,  v23.8H,  v4.H[7]
    ext   v31.16B, v10.16B, v11.16B, # 2

    mul     v7.8H,  v24.8H,  v6.H[0]
    mov   v16.16B, v13.16B
    mla     v7.8H,  v25.8H,  v6.H[1]
    ext   v17.16B, v12.16B, v13.16B, #14
    mla     v7.8H,  v26.8H,  v6.H[2]
    ext   v18.16B, v12.16B, v13.16B, #12
    mla     v7.8H,  v27.8H,  v6.H[3]
    ext   v19.16B, v12.16B, v13.16B, #10
    mla     v7.8H,  v28.8H,  v6.H[4]
    ext   v20.16B, v12.16B, v13.16B, # 8
    mla     v7.8H,  v29.8H,  v6.H[5]
    ext   v21.16B, v12.16B, v13.16B, # 6
    mla     v7.8H,  v30.8H,  v6.H[6]
    ext   v22.16B, v12.16B, v13.16B, # 4
    mla     v7.8H,  v31.8H,  v6.H[7]
    ext   v23.16B, v12.16B, v13.16B, # 2

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible_loop

    mul    v15.8H,  v16.8H,  v5.H[0]
    mla    v15.8H,  v17.8H,  v5.H[1]
    mla    v15.8H,  v18.8H,  v5.H[2]
    mla    v15.8H,  v19.8H,  v5.H[3]
    mla    v15.8H,  v20.8H,  v5.H[4]
    mla    v15.8H,  v21.8H,  v5.H[5]
    mla    v15.8H,  v22.8H,  v5.H[6]
    mla    v15.8H,  v23.8H,  v5.H[7]

    add    v14.8H,  v14.8H,   v7.8H
    add    v15.8H,  v15.8H,   v7.8H

    str q14, [x0, #1*16]
    str q15, [x0, #0*16]

    // add x0, x0, next_bytes

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_negacyclic8_prototype)
cdecl(__asm_Toeplitz_negacyclic8_prototype):

    push_simd

    ldr s0, [x3]
    ldr q1, [x1]
    ldr q2, [x2]

    neg    v10.8H,   v2.8H
    ext    v3.16B, v10.16B,  v2.16B, #14
    ext    v4.16B, v10.16B,  v2.16B, #12
    ext    v5.16B, v10.16B,  v2.16B, #10
    ext    v6.16B, v10.16B,  v2.16B, # 8
    ext    v7.16B, v10.16B,  v2.16B, # 6
    ext    v8.16B, v10.16B,  v2.16B, # 4
    ext    v9.16B, v10.16B,  v2.16B, # 2

    smull  v10.4S,  v2.4H,  v1.H[0]
    smull2 v11.4S,  v2.8H,  v1.H[0]
    smlal  v10.4S,  v3.4H,  v1.H[1]
    smlal2 v11.4S,  v3.8H,  v1.H[1]
    smlal  v10.4S,  v4.4H,  v1.H[2]
    smlal2 v11.4S,  v4.8H,  v1.H[2]
    smlal  v10.4S,  v5.4H,  v1.H[3]
    smlal2 v11.4S,  v5.8H,  v1.H[3]
    smlal  v10.4S,  v6.4H,  v1.H[4]
    smlal2 v11.4S,  v6.8H,  v1.H[4]
    smlal  v10.4S,  v7.4H,  v1.H[5]
    smlal2 v11.4S,  v7.8H,  v1.H[5]
    smlal  v10.4S,  v8.4H,  v1.H[6]
    smlal2 v11.4S,  v8.8H,  v1.H[6]
    smlal  v10.4S,  v9.4H,  v1.H[7]
    smlal2 v11.4S,  v9.8H,  v1.H[7]

    uzp1   v12.8H, v10.8H, v11.8H
    mul    v12.8H, v12.8H,  v0.H[1]
    smlal  v10.4S, v12.4H,  v0.H[0]
    smlal2 v11.4S, v12.8H,  v0.H[0]
    uzp2   v12.8H, v10.8H, v11.8H

    str q12, [x0]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_negacyclic8_flexible)
cdecl(__asm_Toeplitz_negacyclic8_flexible):

    push_simd

    counter    .req x5
    next_bytes .req x4

    sub counter, counter, #2

    ldr s0, [x3]

    ldr q1, [x1]
    ldr q2, [x2]
    ldr q13, [x1, next_bytes]
    ldr q14, [x2, next_bytes]

    neg    v10.8H,   v2.8H
    ext    v3.16B, v10.16B,  v2.16B, #14
    ext    v4.16B, v10.16B,  v2.16B, #12
    ext    v5.16B, v10.16B,  v2.16B, #10
    ext    v6.16B, v10.16B,  v2.16B, # 8
    ext    v7.16B, v10.16B,  v2.16B, # 6
    ext    v8.16B, v10.16B,  v2.16B, # 4
    ext    v9.16B, v10.16B,  v2.16B, # 2

    smull  v10.4S,  v2.4H,  v1.H[0]
    neg    v22.8H,  v14.8H
    smull2 v11.4S,  v2.8H,  v1.H[0]
    ext   v15.16B, v22.16B, v14.16B, #14
    smlal  v10.4S,  v3.4H,  v1.H[1]
    ext   v16.16B, v22.16B, v14.16B, #12
    smlal2 v11.4S,  v3.8H,  v1.H[1]
    ext   v17.16B, v22.16B, v14.16B, #10
    smlal  v10.4S,  v4.4H,  v1.H[2]
    ext   v18.16B, v22.16B, v14.16B, # 8
    smlal2 v11.4S,  v4.8H,  v1.H[2]
    ext   v19.16B, v22.16B, v14.16B, # 6
    smlal  v10.4S,  v5.4H,  v1.H[3]
    ext   v20.16B, v22.16B, v14.16B, # 4
    smlal2 v11.4S,  v5.8H,  v1.H[3]
    ext   v21.16B, v22.16B, v14.16B, # 2
    smlal  v10.4S,  v6.4H,  v1.H[4]
    smlal2 v11.4S,  v6.8H,  v1.H[4]
    smlal  v10.4S,  v7.4H,  v1.H[5]
    smlal2 v11.4S,  v7.8H,  v1.H[5]
    smlal  v10.4S,  v8.4H,  v1.H[6]
    smlal2 v11.4S,  v8.8H,  v1.H[6]
    smlal  v10.4S,  v9.4H,  v1.H[7]
    smlal2 v11.4S,  v9.8H,  v1.H[7]

    uzp1   v12.8H, v10.8H, v11.8H
    smull  v23.4S, v14.4H, v13.H[0]
    mul    v12.8H, v12.8H,  v0.H[1]
    smull2 v24.4S, v14.8H, v13.H[0]
    smlal  v10.4S, v12.4H,  v0.H[0]
    smlal  v23.4S, v15.4H, v13.H[1]
    smlal2 v11.4S, v12.8H,  v0.H[0]
    smlal2 v24.4S, v15.8H, v13.H[1]
    uzp2   v12.8H, v10.8H, v11.8H

    str q12, [x0]

    smlal  v23.4S, v16.4H, v13.H[2]
    smlal2 v24.4S, v16.8H, v13.H[2]
    smlal  v23.4S, v17.4H, v13.H[3]
    smlal2 v24.4S, v17.8H, v13.H[3]

    __asm_Toeplitz_negacyclic_flexible_loop:

    add x1, x1, next_bytes, lsl #1
    add x2, x2, next_bytes, lsl #1

    ldr q1, [x1]
    ldr q2, [x2]

    smlal  v23.4S, v18.4H, v13.H[4]
    neg    v10.8H,   v2.8H
    smlal2 v24.4S, v18.8H, v13.H[4]
    ext    v3.16B, v10.16B,  v2.16B, #14
    smlal  v23.4S, v19.4H, v13.H[5]
    ext    v4.16B, v10.16B,  v2.16B, #12
    smlal2 v24.4S, v19.8H, v13.H[5]
    ext    v5.16B, v10.16B,  v2.16B, #10
    smlal  v23.4S, v20.4H, v13.H[6]
    ext    v6.16B, v10.16B,  v2.16B, # 8
    smlal2 v24.4S, v20.8H, v13.H[6]
    ext    v7.16B, v10.16B,  v2.16B, # 6
    smlal  v23.4S, v21.4H, v13.H[7]
    ext    v8.16B, v10.16B,  v2.16B, # 4
    smlal2 v24.4S, v21.8H, v13.H[7]
    ext    v9.16B, v10.16B,  v2.16B, # 2

    uzp1   v25.8H, v23.8H, v24.8H
    mul    v25.8H, v25.8H,  v0.H[1]
    smlal  v23.4S, v25.4H,  v0.H[0]
    smlal2 v24.4S, v25.8H,  v0.H[0]
    uzp2   v25.8H, v23.8H, v24.8H

    str q25, [x0, next_bytes]

    add x0, x0, next_bytes, lsl #1

    ldr q13, [x1, next_bytes]
    ldr q14, [x2, next_bytes]

    smull  v10.4S,  v2.4H,  v1.H[0]
    neg    v22.8H,  v14.8H
    smull2 v11.4S,  v2.8H,  v1.H[0]
    ext   v15.16B, v22.16B, v14.16B, #14
    smlal  v10.4S,  v3.4H,  v1.H[1]
    ext   v16.16B, v22.16B, v14.16B, #12
    smlal2 v11.4S,  v3.8H,  v1.H[1]
    ext   v17.16B, v22.16B, v14.16B, #10
    smlal  v10.4S,  v4.4H,  v1.H[2]
    ext   v18.16B, v22.16B, v14.16B, # 8
    smlal2 v11.4S,  v4.8H,  v1.H[2]
    ext   v19.16B, v22.16B, v14.16B, # 6
    smlal  v10.4S,  v5.4H,  v1.H[3]
    ext   v20.16B, v22.16B, v14.16B, # 4
    smlal2 v11.4S,  v5.8H,  v1.H[3]
    ext   v21.16B, v22.16B, v14.16B, # 2
    smlal  v10.4S,  v6.4H,  v1.H[4]
    smlal2 v11.4S,  v6.8H,  v1.H[4]
    smlal  v10.4S,  v7.4H,  v1.H[5]
    smlal2 v11.4S,  v7.8H,  v1.H[5]
    smlal  v10.4S,  v8.4H,  v1.H[6]
    smlal2 v11.4S,  v8.8H,  v1.H[6]
    smlal  v10.4S,  v9.4H,  v1.H[7]
    smlal2 v11.4S,  v9.8H,  v1.H[7]

    uzp1   v12.8H, v10.8H, v11.8H
    smull  v23.4S, v14.4H, v13.H[0]
    mul    v12.8H, v12.8H,  v0.H[1]
    smull2 v24.4S, v14.8H, v13.H[0]
    smlal  v10.4S, v12.4H,  v0.H[0]
    smlal  v23.4S, v15.4H, v13.H[1]
    smlal2 v11.4S, v12.8H,  v0.H[0]
    smlal2 v24.4S, v15.8H, v13.H[1]
    uzp2   v12.8H, v10.8H, v11.8H

    str q12, [x0]

    smlal  v23.4S, v16.4H, v13.H[2]
    smlal2 v24.4S, v16.8H, v13.H[2]
    smlal  v23.4S, v17.4H, v13.H[3]
    smlal2 v24.4S, v17.8H, v13.H[3]

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_negacyclic_flexible_loop

    smlal  v23.4S, v18.4H, v13.H[4]
    smlal2 v24.4S, v18.8H, v13.H[4]
    smlal  v23.4S, v19.4H, v13.H[5]
    smlal2 v24.4S, v19.8H, v13.H[5]
    smlal  v23.4S, v20.4H, v13.H[6]
    smlal2 v24.4S, v20.8H, v13.H[6]
    smlal  v23.4S, v21.4H, v13.H[7]
    smlal2 v24.4S, v21.8H, v13.H[7]

    uzp1   v25.8H, v23.8H, v24.8H
    mul    v25.8H, v25.8H,  v0.H[1]
    smlal  v23.4S, v25.4H,  v0.H[0]
    smlal2 v24.4S, v25.8H,  v0.H[0]
    uzp2   v25.8H, v23.8H, v24.8H

    str q25, [x0, next_bytes]

    // add x0, x0, next_bytes, lsl #1

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_CT_cyclic16_prototype)
cdecl(__asm_Toeplitz_CT_cyclic16_prototype):

    push_simd

    ldr s4, [x3]

    ldr  q8, [x1, #0*16]
    ldr  q9, [x1, #1*16]

    add  v0.8H,  v8.8H,  v9.8H
    sub  v1.8H,  v8.8H,  v9.8H

    ldr q24, [x2, #0*16]
    ldr q25, [x2, #1*16]

    add v16.8H, v24.8H, v25.8H
    sub v17.8H, v24.8H, v25.8H
    neg v18.8H, v17.8H

    ext v25.16B, v16.16B, v16.16B, #14
    ext v26.16B, v16.16B, v16.16B, #12
    ext v27.16B, v16.16B, v16.16B, #10
    ext v28.16B, v16.16B, v16.16B,  #8
    ext v29.16B, v16.16B, v16.16B,  #6
    ext v30.16B, v16.16B, v16.16B,  #4
    ext v31.16B, v16.16B, v16.16B,  #2

    smull  v12.4S, v16.4H,  v0.H[0]
    smull2 v13.4S, v16.8H,  v0.H[0]
    smlal  v12.4S, v25.4H,  v0.H[1]
    smlal2 v13.4S, v25.8H,  v0.H[1]
    smlal  v12.4S, v26.4H,  v0.H[2]
    smlal2 v13.4S, v26.8H,  v0.H[2]
    smlal  v12.4S, v27.4H,  v0.H[3]
    smlal2 v13.4S, v27.8H,  v0.H[3]
    smlal  v12.4S, v28.4H,  v0.H[4]
    smlal2 v13.4S, v28.8H,  v0.H[4]
    smlal  v12.4S, v29.4H,  v0.H[5]
    smlal2 v13.4S, v29.8H,  v0.H[5]
    smlal  v12.4S, v30.4H,  v0.H[6]
    smlal2 v13.4S, v30.8H,  v0.H[6]
    smlal  v12.4S, v31.4H,  v0.H[7]
    smlal2 v13.4S, v31.8H,  v0.H[7]

    uzp1    v8.8H, v12.8H, v13.8H
    mul     v8.8H,  v8.8H,  v4.H[1]
    smlal  v12.4S,  v8.4H,  v4.H[0]
    smlal2 v13.4S,  v8.8H,  v4.H[0]
    uzp2    v8.8H, v12.8H, v13.8H

    ext v25.16B, v18.16B, v17.16B, #14
    ext v26.16B, v18.16B, v17.16B, #12
    ext v27.16B, v18.16B, v17.16B, #10
    ext v28.16B, v18.16B, v17.16B,  #8
    ext v29.16B, v18.16B, v17.16B,  #6
    ext v30.16B, v18.16B, v17.16B,  #4
    ext v31.16B, v18.16B, v17.16B,  #2

    smull  v12.4S, v17.4H,  v1.H[0]
    smull2 v13.4S, v17.8H,  v1.H[0]
    smlal  v12.4S, v25.4H,  v1.H[1]
    smlal2 v13.4S, v25.8H,  v1.H[1]
    smlal  v12.4S, v26.4H,  v1.H[2]
    smlal2 v13.4S, v26.8H,  v1.H[2]
    smlal  v12.4S, v27.4H,  v1.H[3]
    smlal2 v13.4S, v27.8H,  v1.H[3]
    smlal  v12.4S, v28.4H,  v1.H[4]
    smlal2 v13.4S, v28.8H,  v1.H[4]
    smlal  v12.4S, v29.4H,  v1.H[5]
    smlal2 v13.4S, v29.8H,  v1.H[5]
    smlal  v12.4S, v30.4H,  v1.H[6]
    smlal2 v13.4S, v30.8H,  v1.H[6]
    smlal  v12.4S, v31.4H,  v1.H[7]
    smlal2 v13.4S, v31.8H,  v1.H[7]

    uzp1    v9.8H, v12.8H, v13.8H
    mul     v9.8H,  v9.8H,  v4.H[1]
    smlal  v12.4S,  v9.4H,  v4.H[0]
    smlal2 v13.4S,  v9.8H,  v4.H[0]
    uzp2    v9.8H, v12.8H, v13.8H

    add  v0.8H,  v8.8H,  v9.8H
    sub  v1.8H,  v8.8H,  v9.8H

    str  q0, [x0, #0*16]
    str  q1, [x0, #1*16]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_CT_cyclic16_flexible)
cdecl(__asm_Toeplitz_CT_cyclic16_flexible):

    push_simd

    counter    .req x5
    next_bytes .req x4

    sub counter, counter, #2

    ldr s0, [x3]

    ldr  q8, [x1]
    ldr  q9, [x1, #16]
    add  x1, x1, next_bytes

    ldr q10, [x1]
    ldr q11, [x1, #16]
    add  x1, x1, next_bytes

    add  v4.8H,  v8.8H,  v9.8H
    sub  v5.8H,  v8.8H,  v9.8H
    add  v6.8H, v10.8H, v11.8H
    sub  v7.8H, v10.8H, v11.8H

    ldr  q8, [x2]
    ldr  q9, [x2, #16]
    add  x2, x2, next_bytes

    ldr q10, [x2]
    ldr q11, [x2, #16]
    add  x2, x2, next_bytes

    add v16.8H,  v8.8H,  v9.8H
    sub v17.8H,  v8.8H,  v9.8H
    neg v18.8H, v17.8H

    add v20.8H, v10.8H, v11.8H
    sub v21.8H, v10.8H, v11.8H
    neg v22.8H, v21.8H

    ext   v25.16B, v16.16B, v16.16B, #14
    ext   v26.16B, v16.16B, v16.16B, #12
    ext   v27.16B, v16.16B, v16.16B, #10
    ext   v28.16B, v16.16B, v16.16B,  #8
    ext   v29.16B, v16.16B, v16.16B,  #6
    ext   v30.16B, v16.16B, v16.16B,  #4
    ext   v31.16B, v16.16B, v16.16B,  #2

    smull  v12.4S, v16.4H,  v4.H[0]
    ext    v8.16B, v20.16B, v20.16B, #14
    smull2 v13.4S, v16.8H,  v4.H[0]
    ext    v9.16B, v20.16B, v20.16B, #12
    smlal  v12.4S, v25.4H,  v4.H[1]
    ext   v10.16B, v20.16B, v20.16B, #10
    smlal2 v13.4S, v25.8H,  v4.H[1]
    ext   v11.16B, v20.16B, v20.16B,  #8
    smlal  v12.4S, v26.4H,  v4.H[2]
    ext   v19.16B, v20.16B, v20.16B,  #6
    smlal2 v13.4S, v26.8H,  v4.H[2]
    ext   v23.16B, v20.16B, v20.16B,  #4
    smlal  v12.4S, v27.4H,  v4.H[3]
    ext   v24.16B, v20.16B, v20.16B,  #2
    smlal2 v13.4S, v27.8H,  v4.H[3]

    smlal  v12.4S, v28.4H,  v4.H[4]
    smlal2 v13.4S, v28.8H,  v4.H[4]
    smlal  v12.4S, v29.4H,  v4.H[5]
    smlal2 v13.4S, v29.8H,  v4.H[5]
    smlal  v12.4S, v30.4H,  v4.H[6]
    smlal2 v13.4S, v30.8H,  v4.H[6]
    smlal  v12.4S, v31.4H,  v4.H[7]
    smlal2 v13.4S, v31.8H,  v4.H[7]

    uzp1   v16.8H, v12.8H, v13.8H
    smull  v14.4S, v20.4H,  v6.H[0]
    mul    v16.8H, v16.8H,  v0.H[1]
    smull2 v15.4S, v20.8H,  v6.H[0]
    smlal  v12.4S, v16.4H,  v0.H[0]
    smlal  v14.4S,  v8.4H,  v6.H[1]
    smlal2 v13.4S, v16.8H,  v0.H[0]
    smlal2 v15.4S,  v8.8H,  v6.H[1]
    uzp2   v16.8H, v12.8H, v13.8H

    smlal  v14.4S,  v9.4H,  v6.H[2]
    smlal2 v15.4S,  v9.8H,  v6.H[2]
    smlal  v14.4S, v10.4H,  v6.H[3]
    smlal2 v15.4S, v10.8H,  v6.H[3]

    ext   v25.16B, v18.16B, v17.16B, #14
    smlal  v14.4S, v11.4H,  v6.H[4]
    ext   v26.16B, v18.16B, v17.16B, #12
    smlal2 v15.4S, v11.8H,  v6.H[4]
    ext   v27.16B, v18.16B, v17.16B, #10
    smlal  v14.4S, v19.4H,  v6.H[5]
    ext   v28.16B, v18.16B, v17.16B,  #8
    smlal2 v15.4S, v19.8H,  v6.H[5]
    ext   v29.16B, v18.16B, v17.16B,  #6
    smlal  v14.4S, v23.4H,  v6.H[6]
    ext   v30.16B, v18.16B, v17.16B,  #4
    smlal2 v15.4S, v23.8H,  v6.H[6]
    ext   v31.16B, v18.16B, v17.16B,  #2
    smlal  v14.4S, v24.4H,  v6.H[7]
    smlal2 v15.4S, v24.8H,  v6.H[7]

    smull  v12.4S, v17.4H,  v5.H[0]
    uzp1   v20.8H, v14.8H, v15.8H
    smull2 v13.4S, v17.8H,  v5.H[0]
    mul    v20.8H, v20.8H,  v0.H[1]
    smlal  v12.4S, v25.4H,  v5.H[1]
    smlal  v14.4S, v20.4H,  v0.H[0]
    smlal2 v13.4S, v25.8H,  v5.H[1]
    smlal2 v15.4S, v20.8H,  v0.H[0]
    smlal  v12.4S, v26.4H,  v5.H[2]
    uzp2   v20.8H, v14.8H, v15.8H

    smlal2 v13.4S, v26.8H,  v5.H[2]
    ext    v8.16B, v22.16B, v21.16B, #14
    smlal  v12.4S, v27.4H,  v5.H[3]
    ext    v9.16B, v22.16B, v21.16B, #12
    smlal2 v13.4S, v27.8H,  v5.H[3]
    ext   v10.16B, v22.16B, v21.16B, #10
    smlal  v12.4S, v28.4H,  v5.H[4]
    ext   v11.16B, v22.16B, v21.16B,  #8
    smlal2 v13.4S, v28.8H,  v5.H[4]
    ext   v19.16B, v22.16B, v21.16B,  #6
    smlal  v12.4S, v29.4H,  v5.H[5]
    ext   v23.16B, v22.16B, v21.16B,  #4
    smlal2 v13.4S, v29.8H,  v5.H[5]
    ext   v24.16B, v22.16B, v21.16B,  #2

    smlal  v12.4S, v30.4H,  v5.H[6]
    smlal2 v13.4S, v30.8H,  v5.H[6]
    smlal  v12.4S, v31.4H,  v5.H[7]
    smlal2 v13.4S, v31.8H,  v5.H[7]

    uzp1   v17.8H, v12.8H, v13.8H
    smull  v14.4S, v21.4H,  v7.H[0]
    mul    v17.8H, v17.8H,  v0.H[1]
    smull2 v15.4S, v21.8H,  v7.H[0]
    smlal  v12.4S, v17.4H,  v0.H[0]
    smlal  v14.4S,  v8.4H,  v7.H[1]
    smlal2 v13.4S, v17.8H,  v0.H[0]
    smlal2 v15.4S,  v8.8H,  v7.H[1]
    uzp2   v17.8H, v12.8H, v13.8H

    __asm_Toeplitz_CT_cyclic16_flexible_loop:

    smlal  v14.4S,  v9.4H,  v7.H[2]
    smlal2 v15.4S,  v9.8H,  v7.H[2]
    smlal  v14.4S, v10.4H,  v7.H[3]
    smlal2 v15.4S, v10.8H,  v7.H[3]
    smlal  v14.4S, v11.4H,  v7.H[4]
    smlal2 v15.4S, v11.8H,  v7.H[4]

    smlal  v14.4S, v19.4H,  v7.H[5]
    ldr  q8, [x1]
    smlal2 v15.4S, v19.8H,  v7.H[5]
    ldr  q9, [x1, #16]
    smlal  v14.4S, v23.4H,  v7.H[6]
    add  x1, x1, next_bytes
    smlal2 v15.4S, v23.8H,  v7.H[6]
    ldr q10, [x1]
    smlal  v14.4S, v24.4H,  v7.H[7]
    ldr q11, [x1, #16]
    smlal2 v15.4S, v24.8H,  v7.H[7]
    add  x1, x1, next_bytes

    uzp1   v21.8H, v14.8H, v15.8H
    mul    v21.8H, v21.8H,  v0.H[1]
    smlal  v14.4S, v21.4H,  v0.H[0]
    smlal2 v15.4S, v21.8H,  v0.H[0]
    uzp2   v21.8H, v14.8H, v15.8H

    add     v4.8H, v16.8H, v17.8H
    sub     v5.8H, v16.8H, v17.8H
    add     v6.8H, v20.8H, v21.8H
    sub     v7.8H, v20.8H, v21.8H

    str  q4, [x0]
    add  v4.8H,  v8.8H,  v9.8H
    str  q5, [x0, #16]
    sub  v5.8H,  v8.8H,  v9.8H
    add  x0, x0, next_bytes

    str  q6, [x0]
    add  v6.8H, v10.8H, v11.8H
    str  q7, [x0, #16]
    sub  v7.8H, v10.8H, v11.8H
    add  x0, x0, next_bytes

    ldr  q8, [x2]
    ldr  q9, [x2, #16]
    add  x2, x2, next_bytes

    ldr q10, [x2]
    ldr q11, [x2, #16]
    add  x2, x2, next_bytes

    add v16.8H,  v8.8H,  v9.8H
    sub v17.8H,  v8.8H,  v9.8H
    neg v18.8H, v17.8H

    add v20.8H, v10.8H, v11.8H
    sub v21.8H, v10.8H, v11.8H
    neg v22.8H, v21.8H

    ext   v25.16B, v16.16B, v16.16B, #14
    ext   v26.16B, v16.16B, v16.16B, #12
    ext   v27.16B, v16.16B, v16.16B, #10
    ext   v28.16B, v16.16B, v16.16B,  #8
    ext   v29.16B, v16.16B, v16.16B,  #6
    ext   v30.16B, v16.16B, v16.16B,  #4
    ext   v31.16B, v16.16B, v16.16B,  #2

    smull  v12.4S, v16.4H,  v4.H[0]
    ext    v8.16B, v20.16B, v20.16B, #14
    smull2 v13.4S, v16.8H,  v4.H[0]
    ext    v9.16B, v20.16B, v20.16B, #12
    smlal  v12.4S, v25.4H,  v4.H[1]
    ext   v10.16B, v20.16B, v20.16B, #10
    smlal2 v13.4S, v25.8H,  v4.H[1]
    ext   v11.16B, v20.16B, v20.16B,  #8
    smlal  v12.4S, v26.4H,  v4.H[2]
    ext   v19.16B, v20.16B, v20.16B,  #6
    smlal2 v13.4S, v26.8H,  v4.H[2]
    ext   v23.16B, v20.16B, v20.16B,  #4
    smlal  v12.4S, v27.4H,  v4.H[3]
    ext   v24.16B, v20.16B, v20.16B,  #2
    smlal2 v13.4S, v27.8H,  v4.H[3]

    smlal  v12.4S, v28.4H,  v4.H[4]
    smlal2 v13.4S, v28.8H,  v4.H[4]
    smlal  v12.4S, v29.4H,  v4.H[5]
    smlal2 v13.4S, v29.8H,  v4.H[5]
    smlal  v12.4S, v30.4H,  v4.H[6]
    smlal2 v13.4S, v30.8H,  v4.H[6]
    smlal  v12.4S, v31.4H,  v4.H[7]
    smlal2 v13.4S, v31.8H,  v4.H[7]

    uzp1   v16.8H, v12.8H, v13.8H
    smull  v14.4S, v20.4H,  v6.H[0]
    mul    v16.8H, v16.8H,  v0.H[1]
    smull2 v15.4S, v20.8H,  v6.H[0]
    smlal  v12.4S, v16.4H,  v0.H[0]
    smlal  v14.4S,  v8.4H,  v6.H[1]
    smlal2 v13.4S, v16.8H,  v0.H[0]
    smlal2 v15.4S,  v8.8H,  v6.H[1]
    uzp2   v16.8H, v12.8H, v13.8H

    smlal  v14.4S,  v9.4H,  v6.H[2]
    smlal2 v15.4S,  v9.8H,  v6.H[2]
    smlal  v14.4S, v10.4H,  v6.H[3]
    smlal2 v15.4S, v10.8H,  v6.H[3]

    ext   v25.16B, v18.16B, v17.16B, #14
    smlal  v14.4S, v11.4H,  v6.H[4]
    ext   v26.16B, v18.16B, v17.16B, #12
    smlal2 v15.4S, v11.8H,  v6.H[4]
    ext   v27.16B, v18.16B, v17.16B, #10
    smlal  v14.4S, v19.4H,  v6.H[5]
    ext   v28.16B, v18.16B, v17.16B,  #8
    smlal2 v15.4S, v19.8H,  v6.H[5]
    ext   v29.16B, v18.16B, v17.16B,  #6
    smlal  v14.4S, v23.4H,  v6.H[6]
    ext   v30.16B, v18.16B, v17.16B,  #4
    smlal2 v15.4S, v23.8H,  v6.H[6]
    ext   v31.16B, v18.16B, v17.16B,  #2
    smlal  v14.4S, v24.4H,  v6.H[7]
    smlal2 v15.4S, v24.8H,  v6.H[7]

    smull  v12.4S, v17.4H,  v5.H[0]
    uzp1   v20.8H, v14.8H, v15.8H
    smull2 v13.4S, v17.8H,  v5.H[0]
    mul    v20.8H, v20.8H,  v0.H[1]
    smlal  v12.4S, v25.4H,  v5.H[1]
    smlal  v14.4S, v20.4H,  v0.H[0]
    smlal2 v13.4S, v25.8H,  v5.H[1]
    smlal2 v15.4S, v20.8H,  v0.H[0]
    smlal  v12.4S, v26.4H,  v5.H[2]
    uzp2   v20.8H, v14.8H, v15.8H

    smlal2 v13.4S, v26.8H,  v5.H[2]
    ext    v8.16B, v22.16B, v21.16B, #14
    smlal  v12.4S, v27.4H,  v5.H[3]
    ext    v9.16B, v22.16B, v21.16B, #12
    smlal2 v13.4S, v27.8H,  v5.H[3]
    ext   v10.16B, v22.16B, v21.16B, #10
    smlal  v12.4S, v28.4H,  v5.H[4]
    ext   v11.16B, v22.16B, v21.16B,  #8
    smlal2 v13.4S, v28.8H,  v5.H[4]
    ext   v19.16B, v22.16B, v21.16B,  #6
    smlal  v12.4S, v29.4H,  v5.H[5]
    ext   v23.16B, v22.16B, v21.16B,  #4
    smlal2 v13.4S, v29.8H,  v5.H[5]
    ext   v24.16B, v22.16B, v21.16B,  #2

    smlal  v12.4S, v30.4H,  v5.H[6]
    smlal2 v13.4S, v30.8H,  v5.H[6]
    smlal  v12.4S, v31.4H,  v5.H[7]
    smlal2 v13.4S, v31.8H,  v5.H[7]

    uzp1   v17.8H, v12.8H, v13.8H
    smull  v14.4S, v21.4H,  v7.H[0]
    mul    v17.8H, v17.8H,  v0.H[1]
    smull2 v15.4S, v21.8H,  v7.H[0]
    smlal  v12.4S, v17.4H,  v0.H[0]
    smlal  v14.4S,  v8.4H,  v7.H[1]
    smlal2 v13.4S, v17.8H,  v0.H[0]
    smlal2 v15.4S,  v8.8H,  v7.H[1]
    uzp2   v17.8H, v12.8H, v13.8H

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_CT_cyclic16_flexible_loop

    smlal  v14.4S,  v9.4H,  v7.H[2]
    smlal2 v15.4S,  v9.8H,  v7.H[2]
    smlal  v14.4S, v10.4H,  v7.H[3]
    smlal2 v15.4S, v10.8H,  v7.H[3]
    smlal  v14.4S, v11.4H,  v7.H[4]
    smlal2 v15.4S, v11.8H,  v7.H[4]
    smlal  v14.4S, v19.4H,  v7.H[5]
    smlal2 v15.4S, v19.8H,  v7.H[5]
    smlal  v14.4S, v23.4H,  v7.H[6]
    smlal2 v15.4S, v23.8H,  v7.H[6]
    smlal  v14.4S, v24.4H,  v7.H[7]
    smlal2 v15.4S, v24.8H,  v7.H[7]

    uzp1   v21.8H, v14.8H, v15.8H
    mul    v21.8H, v21.8H,  v0.H[1]
    smlal  v14.4S, v21.4H,  v0.H[0]
    smlal2 v15.4S, v21.8H,  v0.H[0]
    uzp2   v21.8H, v14.8H, v15.8H

    add     v4.8H, v16.8H, v17.8H
    sub     v5.8H, v16.8H, v17.8H
    add     v6.8H, v20.8H, v21.8H
    sub     v7.8H, v20.8H, v21.8H

    str  q4, [x0]
    str  q5, [x0, #16]
    add  x0, x0, next_bytes

    str  q6, [x0]
    str  q7, [x0, #16]
    // add  x0, x0, next_bytes

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_negacyclic16_prototype)
cdecl(__asm_Toeplitz_negacyclic16_prototype):

    push_simd

    ldr s4, [x3]

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]

    ldr q16, [x2, #0*16]
    ldr q17, [x2, #1*16]

    neg    v11.8H, v17.8H

    ext   v18.16B, v11.16B, v16.16B, #14
    ext   v19.16B, v16.16B, v17.16B, #14
    ext   v20.16B, v11.16B, v16.16B, #12
    ext   v21.16B, v16.16B, v17.16B, #12
    ext   v22.16B, v11.16B, v16.16B, #10
    ext   v23.16B, v16.16B, v17.16B, #10
    ext   v24.16B, v11.16B, v16.16B,  #8
    ext   v25.16B, v16.16B, v17.16B,  #8
    ext   v26.16B, v11.16B, v16.16B,  #6
    ext   v27.16B, v16.16B, v17.16B,  #6
    ext   v28.16B, v11.16B, v16.16B,  #4
    ext   v29.16B, v16.16B, v17.16B,  #4
    ext   v30.16B, v11.16B, v16.16B,  #2
    ext   v31.16B, v16.16B, v17.16B,  #2

    smull  v12.4S, v16.4H,  v0.H[0]
    smull2 v13.4S, v16.8H,  v0.H[0]
    smull  v14.4S, v17.4H,  v0.H[0]
    smull2 v15.4S, v17.8H,  v0.H[0]

    smlal  v12.4S, v18.4H,  v0.H[1]
    smlal2 v13.4S, v18.8H,  v0.H[1]
    smlal  v14.4S, v19.4H,  v0.H[1]
    smlal2 v15.4S, v19.8H,  v0.H[1]

    smlal  v12.4S, v20.4H,  v0.H[2]
    smlal2 v13.4S, v20.8H,  v0.H[2]
    smlal  v14.4S, v21.4H,  v0.H[2]
    smlal2 v15.4S, v21.8H,  v0.H[2]

    smlal  v12.4S, v22.4H,  v0.H[3]
    smlal2 v13.4S, v22.8H,  v0.H[3]
    smlal  v14.4S, v23.4H,  v0.H[3]
    smlal2 v15.4S, v23.8H,  v0.H[3]

    smlal  v12.4S, v24.4H,  v0.H[4]
    smlal2 v13.4S, v24.8H,  v0.H[4]
    smlal  v14.4S, v25.4H,  v0.H[4]
    smlal2 v15.4S, v25.8H,  v0.H[4]

    smlal  v12.4S, v26.4H,  v0.H[5]
    smlal2 v13.4S, v26.8H,  v0.H[5]
    smlal  v14.4S, v27.4H,  v0.H[5]
    smlal2 v15.4S, v27.8H,  v0.H[5]

    smlal  v12.4S, v28.4H,  v0.H[6]
    smlal2 v13.4S, v28.8H,  v0.H[6]
    smlal  v14.4S, v29.4H,  v0.H[6]
    smlal2 v15.4S, v29.8H,  v0.H[6]

    smlal  v12.4S, v30.4H,  v0.H[7]
    smlal2 v13.4S, v30.8H,  v0.H[7]
    smlal  v14.4S, v31.4H,  v0.H[7]
    smlal2 v15.4S, v31.8H,  v0.H[7]

    smlsl  v12.4S, v17.4H,  v1.H[0]
    smlsl2 v13.4S, v17.8H,  v1.H[0]
    smlal  v14.4S, v16.4H,  v1.H[0]
    smlal2 v15.4S, v16.8H,  v1.H[0]

    smlsl  v12.4S, v19.4H,  v1.H[1]
    smlsl2 v13.4S, v19.8H,  v1.H[1]
    smlal  v14.4S, v18.4H,  v1.H[1]
    smlal2 v15.4S, v18.8H,  v1.H[1]

    smlsl  v12.4S, v21.4H,  v1.H[2]
    smlsl2 v13.4S, v21.8H,  v1.H[2]
    smlal  v14.4S, v20.4H,  v1.H[2]
    smlal2 v15.4S, v20.8H,  v1.H[2]

    smlsl  v12.4S, v23.4H,  v1.H[3]
    smlsl2 v13.4S, v23.8H,  v1.H[3]
    smlal  v14.4S, v22.4H,  v1.H[3]
    smlal2 v15.4S, v22.8H,  v1.H[3]

    smlsl  v12.4S, v25.4H,  v1.H[4]
    smlsl2 v13.4S, v25.8H,  v1.H[4]
    smlal  v14.4S, v24.4H,  v1.H[4]
    smlal2 v15.4S, v24.8H,  v1.H[4]

    smlsl  v12.4S, v27.4H,  v1.H[5]
    smlsl2 v13.4S, v27.8H,  v1.H[5]
    smlal  v14.4S, v26.4H,  v1.H[5]
    smlal2 v15.4S, v26.8H,  v1.H[5]

    smlsl  v12.4S, v29.4H,  v1.H[6]
    smlsl2 v13.4S, v29.8H,  v1.H[6]
    smlal  v14.4S, v28.4H,  v1.H[6]
    smlal2 v15.4S, v28.8H,  v1.H[6]

    smlsl  v12.4S, v31.4H,  v1.H[7]
    smlsl2 v13.4S, v31.8H,  v1.H[7]
    smlal  v14.4S, v30.4H,  v1.H[7]
    smlal2 v15.4S, v30.8H,  v1.H[7]

    uzp1    v8.8H, v12.8H, v13.8H
    mul     v8.8H,  v8.8H,  v4.H[1]
    smlal  v12.4S,  v8.4H,  v4.H[0]
    smlal2 v13.4S,  v8.8H,  v4.H[0]
    uzp2    v8.8H, v12.8H, v13.8H

    str q8, [x0, #0*16]

    uzp1    v9.8H, v14.8H, v15.8H
    mul     v9.8H,  v9.8H,  v4.H[1]
    smlal  v14.4S,  v9.4H,  v4.H[0]
    smlal2 v15.4S,  v9.8H,  v4.H[0]
    uzp2    v9.8H, v14.8H, v15.8H

    str q9, [x0, #1*16]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_prototype)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_prototype):

    push_simd

    ldr s0, [x3]

    ldr  q1, [x1]
    ldr  q2, [x1, #16]
    ldr  q5, [x2]
    ldr  q6, [x2, #16]

    add     v7.8H,   v5.8H,  v6.8H
    sub     v8.8H,   v6.8H,  v5.8H

    ext   v13.16B,  v7.16B,  v8.16B, #14
    ext   v14.16B,  v7.16B,  v8.16B, #12
    ext   v15.16B,  v7.16B,  v8.16B, #10
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    smull  v20.4S,   v8.4H,  v1.H[0]
    smull2 v21.4S,   v8.8H,  v1.H[0]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal  v20.4S,  v14.4H,  v1.H[2]
    smlal2 v21.4S,  v14.8H,  v1.H[2]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    smlal2 v21.4S,  v15.8H,  v1.H[3]
    smlal  v20.4S,  v16.4H,  v1.H[4]
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    smlal  v20.4S,  v17.4H,  v1.H[5]
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    smlal  v20.4S,  v18.4H,  v1.H[6]
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    smlal  v20.4S,  v19.4H,  v1.H[7]
    smlal2 v21.4S,  v19.8H,  v1.H[7]

    neg     v6.8H,   v6.8H

    ext   v13.16B,  v6.16B,  v5.16B, #14
    ext   v14.16B,  v6.16B,  v5.16B, #12
    ext   v15.16B,  v6.16B,  v5.16B, #10
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]
    smlal  v22.4S,  v16.4H,  v1.H[4]
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    smlal  v22.4S,  v17.4H,  v1.H[5]
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    smlal  v22.4S,  v18.4H,  v1.H[6]
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    smlal  v22.4S,  v19.4H,  v1.H[7]
    smlal2 v23.4S,  v19.8H,  v1.H[7]

    neg     v8.8H,   v8.8H

    ext   v13.16B,  v8.16B,  v7.16B, #14
    ext   v14.16B,  v8.16B,  v7.16B, #12
    ext   v15.16B,  v8.16B,  v7.16B, #10
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    smlal  v24.4S,  v15.4H,  v2.H[3]
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    smlal  v24.4S,  v17.4H,  v2.H[5]
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    smlal  v24.4S,  v18.4H,  v2.H[6]
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    smlal  v24.4S,  v19.4H,  v2.H[7]
    smlal2 v25.4S,  v19.8H,  v2.H[7]

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    uzp1   v23.8H,  v24.8H, v25.8H
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H

    str q22, [x0, #16]
    str q23, [x0]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_flexible)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_flexible):

    push_simd

    counter    .req x5
    next_bytes .req x4

    sub counter, counter, #2

    ldr s0, [x3]

    ldr  q1, [x1]
    ldr  q2, [x1, #16]
    ldr  q5, [x2]
    ldr  q6, [x2, #16]

    add x1, x1, next_bytes
    add x2, x2, next_bytes

    add     v7.8H,   v5.8H,  v6.8H
    sub     v8.8H,   v6.8H,  v5.8H

    ext   v13.16B,  v7.16B,  v8.16B, #14
    ext   v14.16B,  v7.16B,  v8.16B, #12
    ext   v15.16B,  v7.16B,  v8.16B, #10
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    smull  v20.4S,   v8.4H,  v1.H[0]
    smull2 v21.4S,   v8.8H,  v1.H[0]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal  v20.4S,  v14.4H,  v1.H[2]
    smlal2 v21.4S,  v14.8H,  v1.H[2]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    smlal2 v21.4S,  v15.8H,  v1.H[3]

    smlal  v20.4S,  v16.4H,  v1.H[4]
    neg     v6.8H,   v6.8H
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v6.16B,  v5.16B, #14
    smlal  v20.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v6.16B,  v5.16B, #12
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v6.16B,  v5.16B, #10
    smlal  v20.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    smlal  v20.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    smlal2 v21.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]

    smlal  v22.4S,  v16.4H,  v1.H[4]
    neg     v8.8H,   v8.8H
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v8.16B,  v7.16B, #14
    smlal  v22.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v8.16B,  v7.16B, #12
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v8.16B,  v7.16B, #10
    smlal  v22.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    smlal  v22.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    smlal2 v23.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    ldr  q3, [x1]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    ldr  q4, [x1, #16]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    ldr  q9, [x2]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    ldr q10, [x2, #16]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v2.H[3]
    add    v11.8H,   v9.8H, v10.8H
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    sub    v12.8H,  v10.8H,  v9.8H

    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    ext   v13.16B, v11.16B, v12.16B, #14
    smlal  v24.4S,  v17.4H,  v2.H[5]
    ext   v14.16B, v11.16B, v12.16B, #12
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    ext   v15.16B, v11.16B, v12.16B, #10
    smlal  v24.4S,  v18.4H,  v2.H[6]
    ext   v16.16B, v11.16B, v12.16B, # 8
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    ext   v17.16B, v11.16B, v12.16B, # 6
    smlal  v24.4S,  v19.4H,  v2.H[7]
    ext   v18.16B, v11.16B, v12.16B, # 4
    smlal2 v25.4S,  v19.8H,  v2.H[7]
    ext   v19.16B, v11.16B, v12.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,  v12.4H,  v3.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,  v12.8H,  v3.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v3.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v3.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    smlal  v20.4S,  v14.4H,  v3.H[2]
    uzp2   v23.8H,  v24.8H, v25.8H

    smlal2 v21.4S,  v14.8H,  v3.H[2]
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v3.H[3]
    str q23, [x0]

    smlal2 v21.4S,  v15.8H,  v3.H[3]
    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v3.H[4]
    neg    v10.8H,  v10.8H
    smlal2 v21.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v10.16B,  v9.16B, #14
    smlal  v20.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v10.16B,  v9.16B, #12
    smlal2 v21.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v10.16B,  v9.16B, #10
    smlal  v20.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v10.16B,  v9.16B, # 8
    smlal2 v21.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v10.16B,  v9.16B, # 6
    smlal  v20.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v10.16B,  v9.16B, # 4
    smlal2 v21.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v10.16B,  v9.16B, # 2

    add     v3.8H,   v3.8H,  v4.8H

    smull  v22.4S,   v9.4H,  v3.H[0]
    smull2 v23.4S,   v9.8H,  v3.H[0]
    smlal  v22.4S,  v13.4H,  v3.H[1]
    smlal2 v23.4S,  v13.8H,  v3.H[1]
    smlal  v22.4S,  v14.4H,  v3.H[2]
    smlal2 v23.4S,  v14.8H,  v3.H[2]
    smlal  v22.4S,  v15.4H,  v3.H[3]
    smlal2 v23.4S,  v15.8H,  v3.H[3]

    smlal  v22.4S,  v16.4H,  v3.H[4]
    neg    v12.8H,  v12.8H
    smlal2 v23.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v12.16B, v11.16B, #14
    smlal  v22.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v12.16B, v11.16B, #12
    smlal2 v23.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v12.16B, v11.16B, #10
    smlal  v22.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v12.16B, v11.16B, # 8
    smlal2 v23.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v12.16B, v11.16B, # 6
    smlal  v22.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v12.16B, v11.16B, # 4
    smlal2 v23.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v12.16B, v11.16B, # 2

    __asm_Toeplitz_Karatsuba_negacyclic16_flexible_loop:

    smull  v24.4S,  v11.4H,  v4.H[0]
    ldr  q1, [x1]
    smull2 v25.4S,  v11.8H,  v4.H[0]
    ldr  q2, [x1, #16]
    smlal  v24.4S,  v13.4H,  v4.H[1]
    ldr  q5, [x2]
    smlal2 v25.4S,  v13.8H,  v4.H[1]
    ldr  q6, [x2, #16]
    smlal  v24.4S,  v14.4H,  v4.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v4.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v4.H[3]
    add     v7.8H,   v5.8H,  v6.8H
    smlal2 v25.4S,  v15.8H,  v4.H[3]
    sub     v8.8H,   v6.8H,  v5.8H

    smlal  v24.4S,  v16.4H,  v4.H[4]
    smlal2 v25.4S,  v16.8H,  v4.H[4]
    ext   v13.16B,  v7.16B,  v8.16B, #14
    smlal  v24.4S,  v17.4H,  v4.H[5]
    ext   v14.16B,  v7.16B,  v8.16B, #12
    smlal2 v25.4S,  v17.8H,  v4.H[5]
    ext   v15.16B,  v7.16B,  v8.16B, #10
    smlal  v24.4S,  v18.4H,  v4.H[6]
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    smlal2 v25.4S,  v18.8H,  v4.H[6]
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    smlal  v24.4S,  v19.4H,  v4.H[7]
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    smlal2 v25.4S,  v19.8H,  v4.H[7]
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,   v8.4H,  v1.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,   v8.8H,  v1.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H
    smlal  v20.4S,  v14.4H,  v1.H[2]

    smlal2 v21.4S,  v14.8H,  v1.H[2]
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    str q23, [x0]
    smlal2 v21.4S,  v15.8H,  v1.H[3]

    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v1.H[4]
    neg     v6.8H,   v6.8H
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v6.16B,  v5.16B, #14
    smlal  v20.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v6.16B,  v5.16B, #12
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v6.16B,  v5.16B, #10
    smlal  v20.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    smlal  v20.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    smlal2 v21.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]

    smlal  v22.4S,  v16.4H,  v1.H[4]
    neg     v8.8H,   v8.8H
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v8.16B,  v7.16B, #14
    smlal  v22.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v8.16B,  v7.16B, #12
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v8.16B,  v7.16B, #10
    smlal  v22.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    smlal  v22.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    smlal2 v23.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    ldr  q3, [x1]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    ldr  q4, [x1, #16]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    ldr  q9, [x2]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    ldr q10, [x2, #16]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v2.H[3]
    add    v11.8H,   v9.8H, v10.8H
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    sub    v12.8H,  v10.8H,  v9.8H

    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    ext   v13.16B, v11.16B, v12.16B, #14
    smlal  v24.4S,  v17.4H,  v2.H[5]
    ext   v14.16B, v11.16B, v12.16B, #12
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    ext   v15.16B, v11.16B, v12.16B, #10
    smlal  v24.4S,  v18.4H,  v2.H[6]
    ext   v16.16B, v11.16B, v12.16B, # 8
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    ext   v17.16B, v11.16B, v12.16B, # 6
    smlal  v24.4S,  v19.4H,  v2.H[7]
    ext   v18.16B, v11.16B, v12.16B, # 4
    smlal2 v25.4S,  v19.8H,  v2.H[7]
    ext   v19.16B, v11.16B, v12.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,  v12.4H,  v3.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,  v12.8H,  v3.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v3.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v3.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    smlal  v20.4S,  v14.4H,  v3.H[2]
    uzp2   v23.8H,  v24.8H, v25.8H

    smlal2 v21.4S,  v14.8H,  v3.H[2]
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v3.H[3]
    str q23, [x0]

    smlal2 v21.4S,  v15.8H,  v3.H[3]
    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v3.H[4]
    neg    v10.8H,  v10.8H
    smlal2 v21.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v10.16B,  v9.16B, #14
    smlal  v20.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v10.16B,  v9.16B, #12
    smlal2 v21.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v10.16B,  v9.16B, #10
    smlal  v20.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v10.16B,  v9.16B, # 8
    smlal2 v21.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v10.16B,  v9.16B, # 6
    smlal  v20.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v10.16B,  v9.16B, # 4
    smlal2 v21.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v10.16B,  v9.16B, # 2

    add     v3.8H,   v3.8H,  v4.8H

    smull  v22.4S,   v9.4H,  v3.H[0]
    smull2 v23.4S,   v9.8H,  v3.H[0]
    smlal  v22.4S,  v13.4H,  v3.H[1]
    smlal2 v23.4S,  v13.8H,  v3.H[1]
    smlal  v22.4S,  v14.4H,  v3.H[2]
    smlal2 v23.4S,  v14.8H,  v3.H[2]
    smlal  v22.4S,  v15.4H,  v3.H[3]
    smlal2 v23.4S,  v15.8H,  v3.H[3]

    smlal  v22.4S,  v16.4H,  v3.H[4]
    neg    v12.8H,  v12.8H
    smlal2 v23.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v12.16B, v11.16B, #14
    smlal  v22.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v12.16B, v11.16B, #12
    smlal2 v23.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v12.16B, v11.16B, #10
    smlal  v22.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v12.16B, v11.16B, # 8
    smlal2 v23.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v12.16B, v11.16B, # 6
    smlal  v22.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v12.16B, v11.16B, # 4
    smlal2 v23.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v12.16B, v11.16B, # 2

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_Karatsuba_negacyclic16_flexible_loop

    smull  v24.4S,  v11.4H,  v4.H[0]
    smull2 v25.4S,  v11.8H,  v4.H[0]
    smlal  v24.4S,  v13.4H,  v4.H[1]
    smlal2 v25.4S,  v13.8H,  v4.H[1]
    smlal  v24.4S,  v14.4H,  v4.H[2]
    smlal2 v25.4S,  v14.8H,  v4.H[2]
    smlal  v24.4S,  v15.4H,  v4.H[3]
    smlal2 v25.4S,  v15.8H,  v4.H[3]

    smlal  v24.4S,  v16.4H,  v4.H[4]
    smlal2 v25.4S,  v16.8H,  v4.H[4]
    smlal  v24.4S,  v17.4H,  v4.H[5]
    smlal2 v25.4S,  v17.8H,  v4.H[5]
    smlal  v24.4S,  v18.4H,  v4.H[6]
    smlal2 v25.4S,  v18.8H,  v4.H[6]
    smlal  v24.4S,  v19.4H,  v4.H[7]
    smlal2 v25.4S,  v19.8H,  v4.H[7]

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    uzp1   v23.8H,  v24.8H, v25.8H
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H

    str q22, [x0, #16]
    str q23, [x0]
    // add x0, x0, next_bytes

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype):

    push_simd

    ldr s0, [x3]

    ldr  q1, [x1]
    ldr  q2, [x1, #16]
    ldr  q5, [x2]
    ldr  q6, [x2, #16]

    add     v7.8H,   v5.8H,  v6.8H
    sub     v8.8H,   v6.8H,  v5.8H

    ext   v13.16B,  v7.16B,  v8.16B, #14
    ext   v14.16B,  v7.16B,  v8.16B, #12
    ext   v15.16B,  v7.16B,  v8.16B, #10
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    smull  v20.4S,   v8.4H,  v1.H[0]
    smull2 v21.4S,   v8.8H,  v1.H[0]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal  v20.4S,  v14.4H,  v1.H[2]
    smlal2 v21.4S,  v14.8H,  v1.H[2]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    smlal2 v21.4S,  v15.8H,  v1.H[3]
    smlal  v20.4S,  v16.4H,  v1.H[4]
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    smlal  v20.4S,  v17.4H,  v1.H[5]
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    smlal  v20.4S,  v18.4H,  v1.H[6]
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    smlal  v20.4S,  v19.4H,  v1.H[7]
    smlal2 v21.4S,  v19.8H,  v1.H[7]

    neg     v6.8H,   v6.8H

    ext   v13.16B,  v6.16B,  v5.16B, #14
    ext   v14.16B,  v6.16B,  v5.16B, #12
    ext   v15.16B,  v6.16B,  v5.16B, #10
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]
    smlal  v22.4S,  v16.4H,  v1.H[4]
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    smlal  v22.4S,  v17.4H,  v1.H[5]
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    smlal  v22.4S,  v18.4H,  v1.H[6]
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    smlal  v22.4S,  v19.4H,  v1.H[7]
    smlal2 v23.4S,  v19.8H,  v1.H[7]

    neg     v8.8H,   v8.8H

    ext   v13.16B,  v8.16B,  v7.16B, #14
    ext   v14.16B,  v8.16B,  v7.16B, #12
    ext   v15.16B,  v8.16B,  v7.16B, #10
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    smlal  v24.4S,  v15.4H,  v2.H[3]
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    smlal  v24.4S,  v17.4H,  v2.H[5]
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    smlal  v24.4S,  v18.4H,  v2.H[6]
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    smlal  v24.4S,  v19.4H,  v2.H[7]
    smlal2 v25.4S,  v19.8H,  v2.H[7]

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H
    add v22.8H, v22.8H, v22.8H

    uzp1   v23.8H,  v24.8H, v25.8H
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H
    add v23.8H, v23.8H, v23.8H

    str q22, [x0, #16]
    str q23, [x0]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible)
cdecl(__asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible):

    push_simd

    counter    .req x5
    next_bytes .req x4

    sub counter, counter, #2

    ldr s0, [x3]

    ldr  q1, [x1]
    ldr  q2, [x1, #16]
    ldr  q5, [x2]
    ldr  q6, [x2, #16]

    add x1, x1, next_bytes
    add x2, x2, next_bytes

    add     v7.8H,   v5.8H,  v6.8H
    sub     v8.8H,   v6.8H,  v5.8H

    ext   v13.16B,  v7.16B,  v8.16B, #14
    ext   v14.16B,  v7.16B,  v8.16B, #12
    ext   v15.16B,  v7.16B,  v8.16B, #10
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    smull  v20.4S,   v8.4H,  v1.H[0]
    smull2 v21.4S,   v8.8H,  v1.H[0]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal  v20.4S,  v14.4H,  v1.H[2]
    smlal2 v21.4S,  v14.8H,  v1.H[2]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    smlal2 v21.4S,  v15.8H,  v1.H[3]

    smlal  v20.4S,  v16.4H,  v1.H[4]
    neg     v6.8H,   v6.8H
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v6.16B,  v5.16B, #14
    smlal  v20.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v6.16B,  v5.16B, #12
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v6.16B,  v5.16B, #10
    smlal  v20.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    smlal  v20.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    smlal2 v21.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]

    smlal  v22.4S,  v16.4H,  v1.H[4]
    neg     v8.8H,   v8.8H
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v8.16B,  v7.16B, #14
    smlal  v22.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v8.16B,  v7.16B, #12
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v8.16B,  v7.16B, #10
    smlal  v22.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    smlal  v22.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    smlal2 v23.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    ldr  q3, [x1]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    ldr  q4, [x1, #16]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    ldr  q9, [x2]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    ldr q10, [x2, #16]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v2.H[3]
    add    v11.8H,   v9.8H, v10.8H
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    sub    v12.8H,  v10.8H,  v9.8H

    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    ext   v13.16B, v11.16B, v12.16B, #14
    smlal  v24.4S,  v17.4H,  v2.H[5]
    ext   v14.16B, v11.16B, v12.16B, #12
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    ext   v15.16B, v11.16B, v12.16B, #10
    smlal  v24.4S,  v18.4H,  v2.H[6]
    ext   v16.16B, v11.16B, v12.16B, # 8
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    ext   v17.16B, v11.16B, v12.16B, # 6
    smlal  v24.4S,  v19.4H,  v2.H[7]
    ext   v18.16B, v11.16B, v12.16B, # 4
    smlal2 v25.4S,  v19.8H,  v2.H[7]
    ext   v19.16B, v11.16B, v12.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,  v12.4H,  v3.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,  v12.8H,  v3.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v3.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v3.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    smlal  v20.4S,  v14.4H,  v3.H[2]
    uzp2   v23.8H,  v24.8H, v25.8H

    smlal2 v21.4S,  v14.8H,  v3.H[2]
    add v22.8H, v22.8H, v22.8H
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v3.H[3]
    add v23.8H, v23.8H, v23.8H
    str q23, [x0]

    smlal2 v21.4S,  v15.8H,  v3.H[3]
    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v3.H[4]
    neg    v10.8H,  v10.8H
    smlal2 v21.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v10.16B,  v9.16B, #14
    smlal  v20.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v10.16B,  v9.16B, #12
    smlal2 v21.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v10.16B,  v9.16B, #10
    smlal  v20.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v10.16B,  v9.16B, # 8
    smlal2 v21.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v10.16B,  v9.16B, # 6
    smlal  v20.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v10.16B,  v9.16B, # 4
    smlal2 v21.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v10.16B,  v9.16B, # 2

    add     v3.8H,   v3.8H,  v4.8H

    smull  v22.4S,   v9.4H,  v3.H[0]
    smull2 v23.4S,   v9.8H,  v3.H[0]
    smlal  v22.4S,  v13.4H,  v3.H[1]
    smlal2 v23.4S,  v13.8H,  v3.H[1]
    smlal  v22.4S,  v14.4H,  v3.H[2]
    smlal2 v23.4S,  v14.8H,  v3.H[2]
    smlal  v22.4S,  v15.4H,  v3.H[3]
    smlal2 v23.4S,  v15.8H,  v3.H[3]

    smlal  v22.4S,  v16.4H,  v3.H[4]
    neg    v12.8H,  v12.8H
    smlal2 v23.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v12.16B, v11.16B, #14
    smlal  v22.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v12.16B, v11.16B, #12
    smlal2 v23.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v12.16B, v11.16B, #10
    smlal  v22.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v12.16B, v11.16B, # 8
    smlal2 v23.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v12.16B, v11.16B, # 6
    smlal  v22.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v12.16B, v11.16B, # 4
    smlal2 v23.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v12.16B, v11.16B, # 2

    __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible_loop:

    smull  v24.4S,  v11.4H,  v4.H[0]
    ldr  q1, [x1]
    smull2 v25.4S,  v11.8H,  v4.H[0]
    ldr  q2, [x1, #16]
    smlal  v24.4S,  v13.4H,  v4.H[1]
    ldr  q5, [x2]
    smlal2 v25.4S,  v13.8H,  v4.H[1]
    ldr  q6, [x2, #16]
    smlal  v24.4S,  v14.4H,  v4.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v4.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v4.H[3]
    add     v7.8H,   v5.8H,  v6.8H
    smlal2 v25.4S,  v15.8H,  v4.H[3]
    sub     v8.8H,   v6.8H,  v5.8H

    smlal  v24.4S,  v16.4H,  v4.H[4]
    smlal2 v25.4S,  v16.8H,  v4.H[4]
    ext   v13.16B,  v7.16B,  v8.16B, #14
    smlal  v24.4S,  v17.4H,  v4.H[5]
    ext   v14.16B,  v7.16B,  v8.16B, #12
    smlal2 v25.4S,  v17.8H,  v4.H[5]
    ext   v15.16B,  v7.16B,  v8.16B, #10
    smlal  v24.4S,  v18.4H,  v4.H[6]
    ext   v16.16B,  v7.16B,  v8.16B, # 8
    smlal2 v25.4S,  v18.8H,  v4.H[6]
    ext   v17.16B,  v7.16B,  v8.16B, # 6
    smlal  v24.4S,  v19.4H,  v4.H[7]
    ext   v18.16B,  v7.16B,  v8.16B, # 4
    smlal2 v25.4S,  v19.8H,  v4.H[7]
    ext   v19.16B,  v7.16B,  v8.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,   v8.4H,  v1.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,   v8.8H,  v1.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v1.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v1.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H
    smlal  v20.4S,  v14.4H,  v1.H[2]

    smlal2 v21.4S,  v14.8H,  v1.H[2]
    add v22.8H, v22.8H, v22.8H
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v1.H[3]
    add v23.8H, v23.8H, v23.8H
    str q23, [x0]
    smlal2 v21.4S,  v15.8H,  v1.H[3]

    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v1.H[4]
    neg     v6.8H,   v6.8H
    smlal2 v21.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v6.16B,  v5.16B, #14
    smlal  v20.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v6.16B,  v5.16B, #12
    smlal2 v21.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v6.16B,  v5.16B, #10
    smlal  v20.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v6.16B,  v5.16B, # 8
    smlal2 v21.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v6.16B,  v5.16B, # 6
    smlal  v20.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v6.16B,  v5.16B, # 4
    smlal2 v21.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v6.16B,  v5.16B, # 2

    add     v1.8H,   v1.8H,  v2.8H

    smull  v22.4S,   v5.4H,  v1.H[0]
    smull2 v23.4S,   v5.8H,  v1.H[0]
    smlal  v22.4S,  v13.4H,  v1.H[1]
    smlal2 v23.4S,  v13.8H,  v1.H[1]
    smlal  v22.4S,  v14.4H,  v1.H[2]
    smlal2 v23.4S,  v14.8H,  v1.H[2]
    smlal  v22.4S,  v15.4H,  v1.H[3]
    smlal2 v23.4S,  v15.8H,  v1.H[3]

    smlal  v22.4S,  v16.4H,  v1.H[4]
    neg     v8.8H,   v8.8H
    smlal2 v23.4S,  v16.8H,  v1.H[4]
    ext   v13.16B,  v8.16B,  v7.16B, #14
    smlal  v22.4S,  v17.4H,  v1.H[5]
    ext   v14.16B,  v8.16B,  v7.16B, #12
    smlal2 v23.4S,  v17.8H,  v1.H[5]
    ext   v15.16B,  v8.16B,  v7.16B, #10
    smlal  v22.4S,  v18.4H,  v1.H[6]
    ext   v16.16B,  v8.16B,  v7.16B, # 8
    smlal2 v23.4S,  v18.8H,  v1.H[6]
    ext   v17.16B,  v8.16B,  v7.16B, # 6
    smlal  v22.4S,  v19.4H,  v1.H[7]
    ext   v18.16B,  v8.16B,  v7.16B, # 4
    smlal2 v23.4S,  v19.8H,  v1.H[7]
    ext   v19.16B,  v8.16B,  v7.16B, # 2

    smull  v24.4S,   v7.4H,  v2.H[0]
    ldr  q3, [x1]
    smull2 v25.4S,   v7.8H,  v2.H[0]
    ldr  q4, [x1, #16]
    smlal  v24.4S,  v13.4H,  v2.H[1]
    ldr  q9, [x2]
    smlal2 v25.4S,  v13.8H,  v2.H[1]
    ldr q10, [x2, #16]
    smlal  v24.4S,  v14.4H,  v2.H[2]
    add x1, x1, next_bytes
    smlal2 v25.4S,  v14.8H,  v2.H[2]
    add x2, x2, next_bytes
    smlal  v24.4S,  v15.4H,  v2.H[3]
    add    v11.8H,   v9.8H, v10.8H
    smlal2 v25.4S,  v15.8H,  v2.H[3]
    sub    v12.8H,  v10.8H,  v9.8H

    smlal  v24.4S,  v16.4H,  v2.H[4]
    smlal2 v25.4S,  v16.8H,  v2.H[4]
    ext   v13.16B, v11.16B, v12.16B, #14
    smlal  v24.4S,  v17.4H,  v2.H[5]
    ext   v14.16B, v11.16B, v12.16B, #12
    smlal2 v25.4S,  v17.8H,  v2.H[5]
    ext   v15.16B, v11.16B, v12.16B, #10
    smlal  v24.4S,  v18.4H,  v2.H[6]
    ext   v16.16B, v11.16B, v12.16B, # 8
    smlal2 v25.4S,  v18.8H,  v2.H[6]
    ext   v17.16B, v11.16B, v12.16B, # 6
    smlal  v24.4S,  v19.4H,  v2.H[7]
    ext   v18.16B, v11.16B, v12.16B, # 4
    smlal2 v25.4S,  v19.8H,  v2.H[7]
    ext   v19.16B, v11.16B, v12.16B, # 2

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    smull  v20.4S,  v12.4H,  v3.H[0]
    uzp1   v23.8H,  v24.8H, v25.8H
    smull2 v21.4S,  v12.8H,  v3.H[0]
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v20.4S,  v13.4H,  v3.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v21.4S,  v13.8H,  v3.H[1]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    smlal  v20.4S,  v14.4H,  v3.H[2]
    uzp2   v23.8H,  v24.8H, v25.8H

    smlal2 v21.4S,  v14.8H,  v3.H[2]
    add v22.8H, v22.8H, v22.8H
    str q22, [x0, #16]
    smlal  v20.4S,  v15.4H,  v3.H[3]
    add v23.8H, v23.8H, v23.8H
    str q23, [x0]

    smlal2 v21.4S,  v15.8H,  v3.H[3]
    add x0, x0, next_bytes

    smlal  v20.4S,  v16.4H,  v3.H[4]
    neg    v10.8H,  v10.8H
    smlal2 v21.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v10.16B,  v9.16B, #14
    smlal  v20.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v10.16B,  v9.16B, #12
    smlal2 v21.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v10.16B,  v9.16B, #10
    smlal  v20.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v10.16B,  v9.16B, # 8
    smlal2 v21.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v10.16B,  v9.16B, # 6
    smlal  v20.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v10.16B,  v9.16B, # 4
    smlal2 v21.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v10.16B,  v9.16B, # 2

    add     v3.8H,   v3.8H,  v4.8H

    smull  v22.4S,   v9.4H,  v3.H[0]
    smull2 v23.4S,   v9.8H,  v3.H[0]
    smlal  v22.4S,  v13.4H,  v3.H[1]
    smlal2 v23.4S,  v13.8H,  v3.H[1]
    smlal  v22.4S,  v14.4H,  v3.H[2]
    smlal2 v23.4S,  v14.8H,  v3.H[2]
    smlal  v22.4S,  v15.4H,  v3.H[3]
    smlal2 v23.4S,  v15.8H,  v3.H[3]

    smlal  v22.4S,  v16.4H,  v3.H[4]
    neg    v12.8H,  v12.8H
    smlal2 v23.4S,  v16.8H,  v3.H[4]
    ext   v13.16B, v12.16B, v11.16B, #14
    smlal  v22.4S,  v17.4H,  v3.H[5]
    ext   v14.16B, v12.16B, v11.16B, #12
    smlal2 v23.4S,  v17.8H,  v3.H[5]
    ext   v15.16B, v12.16B, v11.16B, #10
    smlal  v22.4S,  v18.4H,  v3.H[6]
    ext   v16.16B, v12.16B, v11.16B, # 8
    smlal2 v23.4S,  v18.8H,  v3.H[6]
    ext   v17.16B, v12.16B, v11.16B, # 6
    smlal  v22.4S,  v19.4H,  v3.H[7]
    ext   v18.16B, v12.16B, v11.16B, # 4
    smlal2 v23.4S,  v19.8H,  v3.H[7]
    ext   v19.16B, v12.16B, v11.16B, # 2

    sub counter, counter, #2
    cbnz counter, __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible_loop

    smull  v24.4S,  v11.4H,  v4.H[0]
    smull2 v25.4S,  v11.8H,  v4.H[0]
    smlal  v24.4S,  v13.4H,  v4.H[1]
    smlal2 v25.4S,  v13.8H,  v4.H[1]
    smlal  v24.4S,  v14.4H,  v4.H[2]
    smlal2 v25.4S,  v14.8H,  v4.H[2]
    smlal  v24.4S,  v15.4H,  v4.H[3]
    smlal2 v25.4S,  v15.8H,  v4.H[3]

    smlal  v24.4S,  v16.4H,  v4.H[4]
    smlal2 v25.4S,  v16.8H,  v4.H[4]
    smlal  v24.4S,  v17.4H,  v4.H[5]
    smlal2 v25.4S,  v17.8H,  v4.H[5]
    smlal  v24.4S,  v18.4H,  v4.H[6]
    smlal2 v25.4S,  v18.8H,  v4.H[6]
    smlal  v24.4S,  v19.4H,  v4.H[7]
    smlal2 v25.4S,  v19.8H,  v4.H[7]

    add    v20.4S,  v20.4S, v22.4S
    add    v21.4S,  v21.4S, v23.4S
    sub    v24.4S,  v22.4S, v24.4S
    sub    v25.4S,  v23.4S, v25.4S

    uzp1   v22.8H,  v20.8H, v21.8H
    mul    v22.8H,  v22.8H,  v0.H[1]
    smlal  v20.4S,  v22.4H,  v0.H[0]
    smlal2 v21.4S,  v22.8H,  v0.H[0]
    uzp2   v22.8H,  v20.8H, v21.8H

    add v22.8H, v22.8H, v22.8H

    uzp1   v23.8H,  v24.8H, v25.8H
    mul    v23.8H,  v23.8H,  v0.H[1]
    smlal  v24.4S,  v23.4H,  v0.H[0]
    smlal2 v25.4S,  v23.8H,  v0.H[0]
    uzp2   v23.8H,  v24.8H, v25.8H

    add v23.8H, v23.8H, v23.8H

    str q22, [x0, #16]
    str q23, [x0]
    // add x0, x0, next_bytes

    .unreq counter
    .unreq next_bytes

    pop_simd
    ret



