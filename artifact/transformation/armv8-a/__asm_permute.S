
#include "cdecl.h"
#include "macros.i"

.macro trn_8x8 t0, t1, t2, t3, t4, t5, t6, t7, a0, a1, a2, a3, a4, a5, a6, a7

    trn1 \t0\().8H, \a0\().8H, \a1\().8H
    trn2 \t1\().8H, \a0\().8H, \a1\().8H
    trn1 \t2\().8H, \a2\().8H, \a3\().8H
    trn2 \t3\().8H, \a2\().8H, \a3\().8H
    trn1 \t4\().8H, \a4\().8H, \a5\().8H
    trn2 \t5\().8H, \a4\().8H, \a5\().8H
    trn1 \t6\().8H, \a6\().8H, \a7\().8H
    trn2 \t7\().8H, \a6\().8H, \a7\().8H

    trn1 \a0\().4S, \t0\().4S, \t2\().4S
    trn2 \a2\().4S, \t0\().4S, \t2\().4S
    trn1 \a1\().4S, \t1\().4S, \t3\().4S
    trn2 \a3\().4S, \t1\().4S, \t3\().4S
    trn1 \a4\().4S, \t4\().4S, \t6\().4S
    trn2 \a6\().4S, \t4\().4S, \t6\().4S
    trn1 \a5\().4S, \t5\().4S, \t7\().4S
    trn2 \a7\().4S, \t5\().4S, \t7\().4S

    trn1 \t0\().2D, \a0\().2D, \a4\().2D
    trn2 \t4\().2D, \a0\().2D, \a4\().2D
    trn1 \t1\().2D, \a1\().2D, \a5\().2D
    trn2 \t5\().2D, \a1\().2D, \a5\().2D
    trn1 \t2\().2D, \a2\().2D, \a6\().2D
    trn2 \t6\().2D, \a2\().2D, \a6\().2D
    trn1 \t3\().2D, \a3\().2D, \a7\().2D
    trn2 \t7\().2D, \a3\().2D, \a7\().2D

.endm

.align 6
.global cdecl(__asm_trn8x8_prototype)
cdecl(__asm_trn8x8_prototype):

    ldr  q0, [x1, #0*16]
    ldr  q1, [x1, #1*16]
    ldr  q2, [x1, #2*16]
    ldr  q3, [x1, #3*16]
    ldr  q4, [x1, #4*16]
    ldr  q5, [x1, #5*16]
    ldr  q6, [x1, #6*16]
    ldr  q7, [x1, #7*16]

    trn_8x8 v16, v17, v18, v19, v20, v21, v22, v23, v0, v1, v2, v3, v4, v5, v6, v7

    str q16, [x0, #0*16]
    str q17, [x0, #1*16]
    str q18, [x0, #2*16]
    str q19, [x0, #3*16]
    str q20, [x0, #4*16]
    str q21, [x0, #5*16]
    str q22, [x0, #6*16]
    str q23, [x0, #7*16]

    ret

.align 6
.global cdecl(__asm_trn8x8_full)
cdecl(__asm_trn8x8_full):

    push_simd

    counter .req x2

    sub counter, counter, #2

    ldr  q0, [x1, # 0*16]
    ldr  q1, [x1, # 1*16]
    ldr  q2, [x1, # 2*16]
    ldr  q3, [x1, # 3*16]
    ldr  q4, [x1, # 4*16]
    ldr  q5, [x1, # 5*16]
    ldr  q6, [x1, # 6*16]
    ldr  q7, [x1, # 7*16]

    trn1 v16.8H,  v0.8H,  v1.8H
    trn2 v17.8H,  v0.8H,  v1.8H
    ldr  q8, [x1, # 8*16]
    trn1 v18.8H,  v2.8H,  v3.8H
    trn2 v19.8H,  v2.8H,  v3.8H
    ldr  q9, [x1, # 9*16]
    trn1 v20.8H,  v4.8H,  v5.8H
    trn2 v21.8H,  v4.8H,  v5.8H
    ldr q10, [x1, #10*16]
    trn1 v22.8H,  v6.8H,  v7.8H
    trn2 v23.8H,  v6.8H,  v7.8H
    ldr q11, [x1, #11*16]

    trn1  v0.4S, v16.4S, v18.4S
    trn2  v2.4S, v16.4S, v18.4S
    ldr q12, [x1, #12*16]
    trn1  v1.4S, v17.4S, v19.4S
    trn2  v3.4S, v17.4S, v19.4S
    ldr q13, [x1, #13*16]
    trn1  v4.4S, v20.4S, v22.4S
    trn2  v6.4S, v20.4S, v22.4S
    ldr q14, [x1, #14*16]
    trn1  v5.4S, v21.4S, v23.4S
    trn2  v7.4S, v21.4S, v23.4S
    ldr q15, [x1, #15*16]

    add x1, x1, #16*16

    trn1 v16.2D,  v0.2D,  v4.2D
    trn2 v20.2D,  v0.2D,  v4.2D
    trn1 v17.2D,  v1.2D,  v5.2D
    trn2 v21.2D,  v1.2D,  v5.2D
    trn1 v18.2D,  v2.2D,  v6.2D
    trn2 v22.2D,  v2.2D,  v6.2D
    trn1 v19.2D,  v3.2D,  v7.2D
    trn2 v23.2D,  v3.2D,  v7.2D

    str q16, [x0, # 0*16]
    trn1 v24.8H,  v8.8H,  v9.8H
    trn2 v25.8H,  v8.8H,  v9.8H
    str q17, [x0, # 1*16]
    trn1 v26.8H, v10.8H, v11.8H
    trn2 v27.8H, v10.8H, v11.8H
    str q18, [x0, # 2*16]
    trn1 v28.8H, v12.8H, v13.8H
    trn2 v29.8H, v12.8H, v13.8H
    str q19, [x0, # 3*16]
    trn1 v30.8H, v14.8H, v15.8H
    trn2 v31.8H, v14.8H, v15.8H
    str q20, [x0, # 4*16]
    trn1  v8.4S, v24.4S, v26.4S
    trn2 v10.4S, v24.4S, v26.4S
    str q21, [x0, # 5*16]
    trn1  v9.4S, v25.4S, v27.4S
    trn2 v11.4S, v25.4S, v27.4S
    str q22, [x0, # 6*16]
    trn1 v12.4S, v28.4S, v30.4S
    trn2 v14.4S, v28.4S, v30.4S
    str q23, [x0, # 7*16]
    trn1 v13.4S, v29.4S, v31.4S
    trn2 v15.4S, v29.4S, v31.4S

    __asm_trn8x8_full_loop:

    trn1 v24.2D,  v8.2D, v12.2D
    trn2 v28.2D,  v8.2D, v12.2D
    ldr  q0, [x1, # 0*16]
    trn1 v25.2D,  v9.2D, v13.2D
    trn2 v29.2D,  v9.2D, v13.2D
    ldr  q1, [x1, # 1*16]
    trn1 v26.2D, v10.2D, v14.2D
    trn2 v30.2D, v10.2D, v14.2D
    ldr  q2, [x1, # 2*16]
    trn1 v27.2D, v11.2D, v15.2D
    trn2 v31.2D, v11.2D, v15.2D
    ldr  q3, [x1, # 3*16]

    str q24, [x0, # 8*16]
    ldr  q4, [x1, # 4*16]
    str q25, [x0, # 9*16]
    ldr  q5, [x1, # 5*16]
    str q26, [x0, #10*16]
    ldr  q6, [x1, # 6*16]
    str q27, [x0, #11*16]
    ldr  q7, [x1, # 7*16]

    str q28, [x0, #12*16]
    trn1 v16.8H,  v0.8H,  v1.8H
    trn2 v17.8H,  v0.8H,  v1.8H
    ldr  q8, [x1, # 8*16]
    str q29, [x0, #13*16]
    trn1 v18.8H,  v2.8H,  v3.8H
    trn2 v19.8H,  v2.8H,  v3.8H
    ldr  q9, [x1, # 9*16]
    str q30, [x0, #14*16]
    trn1 v20.8H,  v4.8H,  v5.8H
    trn2 v21.8H,  v4.8H,  v5.8H
    ldr q10, [x1, #10*16]
    str q31, [x0, #15*16]
    trn1 v22.8H,  v6.8H,  v7.8H
    trn2 v23.8H,  v6.8H,  v7.8H
    ldr q11, [x1, #11*16]

    add x0, x0, #16*16

    trn1  v0.4S, v16.4S, v18.4S
    trn2  v2.4S, v16.4S, v18.4S
    ldr q12, [x1, #12*16]
    trn1  v1.4S, v17.4S, v19.4S
    trn2  v3.4S, v17.4S, v19.4S
    ldr q13, [x1, #13*16]
    trn1  v4.4S, v20.4S, v22.4S
    trn2  v6.4S, v20.4S, v22.4S
    ldr q14, [x1, #14*16]
    trn1  v5.4S, v21.4S, v23.4S
    trn2  v7.4S, v21.4S, v23.4S
    ldr q15, [x1, #15*16]

    add x1, x1, #16*16

    trn1 v16.2D,  v0.2D,  v4.2D
    trn2 v20.2D,  v0.2D,  v4.2D
    trn1 v17.2D,  v1.2D,  v5.2D
    trn2 v21.2D,  v1.2D,  v5.2D
    trn1 v18.2D,  v2.2D,  v6.2D
    trn2 v22.2D,  v2.2D,  v6.2D
    trn1 v19.2D,  v3.2D,  v7.2D
    trn2 v23.2D,  v3.2D,  v7.2D

    str q16, [x0, # 0*16]
    trn1 v24.8H,  v8.8H,  v9.8H
    trn2 v25.8H,  v8.8H,  v9.8H
    str q17, [x0, # 1*16]
    trn1 v26.8H, v10.8H, v11.8H
    trn2 v27.8H, v10.8H, v11.8H
    str q18, [x0, # 2*16]
    trn1 v28.8H, v12.8H, v13.8H
    trn2 v29.8H, v12.8H, v13.8H
    str q19, [x0, # 3*16]
    trn1 v30.8H, v14.8H, v15.8H
    trn2 v31.8H, v14.8H, v15.8H
    str q20, [x0, # 4*16]
    trn1  v8.4S, v24.4S, v26.4S
    trn2 v10.4S, v24.4S, v26.4S
    str q21, [x0, # 5*16]
    trn1  v9.4S, v25.4S, v27.4S
    trn2 v11.4S, v25.4S, v27.4S
    str q22, [x0, # 6*16]
    trn1 v12.4S, v28.4S, v30.4S
    trn2 v14.4S, v28.4S, v30.4S
    str q23, [x0, # 7*16]
    trn1 v13.4S, v29.4S, v31.4S
    trn2 v15.4S, v29.4S, v31.4S

    sub counter, counter, #2
    cbnz counter, __asm_trn8x8_full_loop

    trn1 v24.2D,  v8.2D, v12.2D
    trn2 v28.2D,  v8.2D, v12.2D
    trn1 v25.2D,  v9.2D, v13.2D
    trn2 v29.2D,  v9.2D, v13.2D
    trn1 v26.2D, v10.2D, v14.2D
    trn2 v30.2D, v10.2D, v14.2D
    trn1 v27.2D, v11.2D, v15.2D
    trn2 v31.2D, v11.2D, v15.2D

    str q24, [x0, # 8*16]
    str q25, [x0, # 9*16]
    str q26, [x0, #10*16]
    str q27, [x0, #11*16]
    str q28, [x0, #12*16]
    str q29, [x0, #13*16]
    str q30, [x0, #14*16]
    str q31, [x0, #15*16]

    pop_simd
    ret


