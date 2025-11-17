
#include "cdecl.h"
#include "macros.i"

.macro mul_long4_Z65536 c0, c1, c2, c3, c4, c5, c6, a0, a1, a2, a3, b0, b1, b2, b3

    mul  \c0\().8H, \a0\().8H, \b0\().8H

    mul  \c1\().8H, \a0\().8H, \b1\().8H
    mla  \c1\().8H, \a1\().8H, \b0\().8H

    mul  \c2\().8H, \a0\().8H, \b2\().8H
    mla  \c2\().8H, \a1\().8H, \b1\().8H
    mla  \c2\().8H, \a2\().8H, \b0\().8H

    mul  \c3\().8H, \a0\().8H, \b3\().8H
    mla  \c3\().8H, \a1\().8H, \b2\().8H
    mla  \c3\().8H, \a2\().8H, \b1\().8H
    mla  \c3\().8H, \a3\().8H, \b0\().8H

    mul  \c4\().8H, \a1\().8H, \b3\().8H
    mla  \c4\().8H, \a2\().8H, \b2\().8H
    mla  \c4\().8H, \a3\().8H, \b1\().8H

    mul  \c5\().8H, \a2\().8H, \b3\().8H
    mla  \c5\().8H, \a3\().8H, \b2\().8H

    mul  \c6\().8H, \a3\().8H, \b3\().8H

.endm

.macro mul_negacyclic4_Z65536 c0, c1, c2, c3, a0, a1, a2, a3, b0, b1, b2, b3

    mul  \c0\().8H, \a0\().8H, \b0\().8H
    mls  \c0\().8H, \a1\().8H, \b3\().8H
    mls  \c0\().8H, \a2\().8H, \b2\().8H
    mls  \c0\().8H, \a3\().8H, \b1\().8H

    mul  \c1\().8H, \a0\().8H, \b1\().8H
    mla  \c1\().8H, \a1\().8H, \b0\().8H
    mls  \c1\().8H, \a2\().8H, \b3\().8H
    mls  \c1\().8H, \a3\().8H, \b2\().8H

    mul  \c2\().8H, \a0\().8H, \b2\().8H
    mla  \c2\().8H, \a1\().8H, \b1\().8H
    mla  \c2\().8H, \a2\().8H, \b0\().8H
    mls  \c2\().8H, \a3\().8H, \b3\().8H

    mul  \c3\().8H, \a0\().8H, \b3\().8H
    mla  \c3\().8H, \a1\().8H, \b2\().8H
    mla  \c3\().8H, \a2\().8H, \b1\().8H
    mla  \c3\().8H, \a3\().8H, \b0\().8H

.endm

.align 6
.global cdecl(__asm_Karatsuba8x8_Z65536_prototype)
cdecl(__asm_Karatsuba8x8_Z65536_prototype):

    push_simd

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x1, #2*16]
    ldr  q3, [x1, #3*16]
    ldr  q4, [x1, #4*16]
    ldr  q5, [x1, #5*16]
    ldr  q6, [x1, #6*16]
    ldr  q7, [x1, #7*16]
    ldr  q8, [x2, #0*16]
    ldr  q9, [x2, #1*16]
    ldr q10, [x2, #2*16]
    ldr q11, [x2, #3*16]
    ldr q12, [x2, #4*16]
    ldr q13, [x2, #5*16]
    ldr q14, [x2, #6*16]
    ldr q15, [x2, #7*16]

    add  v16.8H,  v0.8H,  v4.8H
    add  v17.8H,  v1.8H,  v5.8H
    add  v18.8H,  v2.8H,  v6.8H
    add  v19.8H,  v3.8H,  v7.8H

    add  v20.8H,  v8.8H, v12.8H
    add  v21.8H,  v9.8H, v13.8H
    add  v22.8H, v10.8H, v14.8H
    add  v23.8H, v11.8H, v15.8H

    mul_long4_Z65536 v24, v25, v26, v27, v28, v29, v30,  v0,  v1,  v2,  v3,  v8,  v9, v10, v11
    mul_long4_Z65536  v0,  v1,  v2,  v3,  v8,  v9, v10, v16, v17, v18, v19, v20, v21, v22, v23
    mul_long4_Z65536 v16, v17, v18, v19, v20, v21, v22,  v4,  v5,  v6,  v7, v12, v13, v14, v15

    sub   v0.8H,  v0.8H, v24.8H
    sub   v1.8H,  v1.8H, v25.8H
    sub   v2.8H,  v2.8H, v26.8H
    sub   v3.8H,  v3.8H, v27.8H
    sub   v8.8H,  v8.8H, v28.8H
    sub   v9.8H,  v9.8H, v29.8H
    sub  v10.8H, v10.8H, v30.8H

    sub   v0.8H,  v0.8H, v16.8H
    sub   v1.8H,  v1.8H, v17.8H
    sub   v2.8H,  v2.8H, v18.8H
    sub   v3.8H,  v3.8H, v19.8H
    sub   v8.8H,  v8.8H, v20.8H
    sub   v9.8H,  v9.8H, v21.8H
    sub  v10.8H, v10.8H, v22.8H

    add  v28.8H, v28.8H,  v0.8H
    add  v29.8H, v29.8H,  v1.8H
    add  v30.8H, v30.8H,  v2.8H
    mov v31.16B, v3.16B
    add  v16.8H, v16.8H,  v8.8H
    add  v17.8H, v17.8H,  v9.8H
    add  v18.8H, v18.8H, v10.8H

    str q24, [x0, # 0*16]
    str q25, [x0, # 1*16]
    str q26, [x0, # 2*16]
    str q27, [x0, # 3*16]
    str q28, [x0, # 4*16]
    str q29, [x0, # 5*16]
    str q30, [x0, # 6*16]
    str q31, [x0, # 7*16]
    str q16, [x0, # 8*16]
    str q17, [x0, # 9*16]
    str q18, [x0, #10*16]
    str q19, [x0, #11*16]
    str q20, [x0, #12*16]
    str q21, [x0, #13*16]
    str q22, [x0, #14*16]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Karatsuba_negacyclic8x8_Z65536_prototype)
cdecl(__asm_Karatsuba_negacyclic8x8_Z65536_prototype):

    push_simd

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x1, #2*16]
    ldr  q3, [x1, #3*16]
    ldr  q4, [x1, #4*16]
    ldr  q5, [x1, #5*16]
    ldr  q6, [x1, #6*16]
    ldr  q7, [x1, #7*16]
    ldr  q8, [x2, #0*16]
    ldr  q9, [x2, #1*16]
    ldr q10, [x2, #2*16]
    ldr q11, [x2, #3*16]
    ldr q12, [x2, #4*16]
    ldr q13, [x2, #5*16]
    ldr q14, [x2, #6*16]
    ldr q15, [x2, #7*16]

    add  v16.8H,  v0.8H,  v4.8H
    add  v17.8H,  v1.8H,  v5.8H
    add  v18.8H,  v2.8H,  v6.8H
    add  v19.8H,  v3.8H,  v7.8H

    add  v20.8H,  v8.8H, v12.8H
    add  v21.8H,  v9.8H, v13.8H
    add  v22.8H, v10.8H, v14.8H
    add  v23.8H, v11.8H, v15.8H

    mul_long4_Z65536 v24, v25, v26, v27, v28, v29, v30,  v0,  v1,  v2,  v3,  v8,  v9, v10, v11
    mul_long4_Z65536  v0,  v1,  v2,  v3,  v8,  v9, v10, v16, v17, v18, v19, v20, v21, v22, v23
    mul_long4_Z65536 v16, v17, v18, v19, v20, v21, v22,  v4,  v5,  v6,  v7, v12, v13, v14, v15

    sub   v0.8H,  v0.8H, v24.8H
    sub   v1.8H,  v1.8H, v25.8H
    sub   v2.8H,  v2.8H, v26.8H
    sub   v3.8H,  v3.8H, v27.8H
    sub   v8.8H,  v8.8H, v28.8H
    sub   v9.8H,  v9.8H, v29.8H
    sub  v10.8H, v10.8H, v30.8H

    sub   v0.8H,  v0.8H, v16.8H
    sub   v1.8H,  v1.8H, v17.8H
    sub   v2.8H,  v2.8H, v18.8H
    sub   v3.8H,  v3.8H, v19.8H
    sub   v8.8H,  v8.8H, v20.8H
    sub   v9.8H,  v9.8H, v21.8H
    sub  v10.8H, v10.8H, v22.8H

    add  v28.8H, v28.8H,  v0.8H
    add  v29.8H, v29.8H,  v1.8H
    add  v30.8H, v30.8H,  v2.8H
    mov v31.16B, v3.16B
    add  v16.8H, v16.8H,  v8.8H
    add  v17.8H, v17.8H,  v9.8H
    add  v18.8H, v18.8H, v10.8H

    sub  v24.8H, v24.8H, v16.8H
    sub  v25.8H, v25.8H, v17.8H
    sub  v26.8H, v26.8H, v18.8H
    sub  v27.8H, v27.8H, v19.8H
    sub  v28.8H, v28.8H, v20.8H
    sub  v29.8H, v29.8H, v21.8H
    sub  v30.8H, v30.8H, v22.8H

    str q24, [x0, # 0*16]
    str q25, [x0, # 1*16]
    str q26, [x0, # 2*16]
    str q27, [x0, # 3*16]
    str q28, [x0, # 4*16]
    str q29, [x0, # 5*16]
    str q30, [x0, # 6*16]
    str q31, [x0, # 7*16]

    pop_simd
    ret

.align 6
.global cdecl(__asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype)
cdecl(__asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype):

    push_simd

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x1, #2*16]
    ldr  q3, [x1, #3*16]
    ldr  q4, [x1, #4*16]
    ldr  q5, [x1, #5*16]
    ldr  q6, [x1, #6*16]
    ldr  q7, [x1, #7*16]
    ldr  q8, [x2, #0*16]
    ldr  q9, [x2, #1*16]
    ldr q10, [x2, #2*16]
    ldr q11, [x2, #3*16]
    ldr q12, [x2, #4*16]
    ldr q13, [x2, #5*16]
    ldr q14, [x2, #6*16]
    ldr q15, [x2, #7*16]

    add  v16.8H,  v0.8H,  v1.8H
    add  v17.8H,  v2.8H,  v3.8H
    add  v18.8H,  v4.8H,  v5.8H
    add  v19.8H,  v6.8H,  v7.8H

    add  v20.8H,  v8.8H,  v9.8H
    add  v21.8H, v10.8H, v11.8H
    add  v22.8H, v12.8H, v13.8H
    add  v23.8H, v14.8H, v15.8H

    mul_negacyclic4_Z65536 v24, v25, v26, v27,  v0,  v2,  v4,  v6,  v8, v10, v12, v14
    mul_negacyclic4_Z65536 v28, v29, v30, v31,  v1,  v3,  v5,  v7,  v9, v11, v13, v15
    mul_negacyclic4_Z65536  v0,  v1,  v2,  v3, v16, v17, v18, v19, v20, v21, v22, v23

    sub   v0.8H,  v0.8H, v24.8H
    sub   v1.8H,  v1.8H, v25.8H
    sub   v2.8H,  v2.8H, v26.8H
    sub   v3.8H,  v3.8H, v27.8H

    sub   v0.8H,  v0.8H, v28.8H
    sub   v1.8H,  v1.8H, v29.8H
    sub   v2.8H,  v2.8H, v30.8H
    sub   v3.8H,  v3.8H, v31.8H

    sub  v24.8H, v24.8H, v31.8H
    add  v25.8H, v25.8H, v28.8H
    add  v26.8H, v26.8H, v29.8H
    add  v27.8H, v27.8H, v30.8H

    str q24, [x0, # 0*16]
    str  q0, [x0, # 1*16]
    str q25, [x0, # 2*16]
    str  q1, [x0, # 3*16]
    str q26, [x0, # 4*16]
    str  q2, [x0, # 5*16]
    str q27, [x0, # 6*16]
    str  q3, [x0, # 7*16]

    pop_simd
    ret









