
#include "cdecl.h"
#include "macros.i"

.align 6
.global cdecl(__asm_poly_pointwise_montgomery)
cdecl(__asm_poly_pointwise_montgomery):

    push_all

    ldr w20, [x3, #0]
    ldr w21, [x3, #4]

    dup v30.4S, w20
    dup v31.4S, w21

    ld1 { v0.4S}, [x1], #16
    ld1 { v1.4S}, [x1], #16
    ld1 { v2.4S}, [x1], #16
    ld1 { v3.4S}, [x1], #16
    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    mov x16, #15
    _poly_pointwise_montgomery_loop:

    st1 {v24.4S}, [x0], #16
    ld1 { v0.4S}, [x1], #16
    st1 {v25.4S}, [x0], #16
    ld1 { v1.4S}, [x1], #16
    st1 {v26.4S}, [x0], #16
    ld1 { v2.4S}, [x1], #16
    st1 {v27.4S}, [x0], #16
    ld1 { v3.4S}, [x1], #16

    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    sub x16, x16, #1
    cbnz x16, _poly_pointwise_montgomery_loop

    st1 {v24.4S}, [x0], #16
    st1 {v25.4S}, [x0], #16
    st1 {v26.4S}, [x0], #16
    st1 {v27.4S}, [x0], #16

    pop_all
    ret

#ifdef L

.align 6
.global cdecl(__asm_polyvecl_pointwise_acc_montgomery)
cdecl(__asm_polyvecl_pointwise_acc_montgomery):

    push_all

    ldr w20, [x3, #0]
    ldr w21, [x3, #4]

    add  x5,  x1, #1024*1
    add  x6,  x2, #1024*1

    add  x7,  x1, #1024*2
    add  x8,  x2, #1024*2

    add  x9,  x1, #1024*3
    add x10,  x2, #1024*3

#if L > 4
    add x11,  x1, #1024*4
    add x12,  x2, #1024*4
#endif

#if L > 5
    add x13,  x11, #1024*1
    add x14,  x12, #1024*1

    add x15,  x11, #1024*2
    add x19,  x12, #1024*2
#endif

    dup v30.4S, w20
    dup v31.4S, w21

    ld1 { v0.4S}, [x1], #16
    ld1 { v1.4S}, [x1], #16
    ld1 { v2.4S}, [x1], #16
    ld1 { v3.4S}, [x1], #16
    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x5], #16
    ld1 { v4.4S}, [ x6], #16
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x5], #16
    ld1 { v5.4S}, [ x6], #16
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x5], #16
    ld1 { v6.4S}, [ x6], #16
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x5], #16
    ld1 { v7.4S}, [ x6], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x7], #16
    ld1 { v4.4S}, [ x8], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x7], #16
    ld1 { v5.4S}, [ x8], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x7], #16
    ld1 { v6.4S}, [ x8], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x7], #16
    ld1 { v7.4S}, [ x8], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x9], #16
    ld1 { v4.4S}, [x10], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x9], #16
    ld1 { v5.4S}, [x10], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x9], #16
    ld1 { v6.4S}, [x10], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x9], #16
    ld1 { v7.4S}, [x10], #16

#if L > 4
    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x11], #16
    ld1 { v4.4S}, [x12], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x11], #16
    ld1 { v5.4S}, [x12], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x11], #16
    ld1 { v6.4S}, [x12], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x11], #16
    ld1 { v7.4S}, [x12], #16
#endif

#if L > 5
    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x13], #16
    ld1 { v4.4S}, [x14], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x13], #16
    ld1 { v5.4S}, [x14], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x13], #16
    ld1 { v6.4S}, [x14], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x13], #16
    ld1 { v7.4S}, [x14], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x15], #16
    ld1 { v4.4S}, [x19], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x15], #16
    ld1 { v5.4S}, [x19], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x15], #16
    ld1 { v6.4S}, [x19], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x15], #16
    ld1 { v7.4S}, [x19], #16
#endif

    mov x16, #15
    _polyvecl_pointwise_acc_montgomery_loop:

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    ld1 { v0.4S}, [x1], #16
    uzp1   v21.4S, v13.4S, v17.4S
    ld1 { v1.4S}, [x1], #16
    uzp1   v22.4S, v14.4S, v18.4S
    ld1 { v2.4S}, [x1], #16
    uzp1   v23.4S, v15.4S, v19.4S
    ld1 { v3.4S}, [x1], #16

    mul    v24.4S, v20.4S, v31.4S
    ld1 { v4.4S}, [x2], #16
    mul    v25.4S, v21.4S, v31.4S
    ld1 { v5.4S}, [x2], #16
    mul    v26.4S, v22.4S, v31.4S
    ld1 { v6.4S}, [x2], #16
    mul    v27.4S, v23.4S, v31.4S
    ld1 { v7.4S}, [x2], #16

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x5], #16
    st1 {v24.4S}, [x0], #16
    ld1 { v4.4S}, [ x6], #16
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x5], #16
    st1 {v25.4S}, [x0], #16
    ld1 { v5.4S}, [ x6], #16
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x5], #16
    st1 {v26.4S}, [x0], #16
    ld1 { v6.4S}, [ x6], #16
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x5], #16
    st1 {v27.4S}, [x0], #16
    ld1 { v7.4S}, [ x6], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x7], #16
    ld1 { v4.4S}, [ x8], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x7], #16
    ld1 { v5.4S}, [ x8], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x7], #16
    ld1 { v6.4S}, [ x8], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x7], #16
    ld1 { v7.4S}, [ x8], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x9], #16
    ld1 { v4.4S}, [x10], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x9], #16
    ld1 { v5.4S}, [x10], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x9], #16
    ld1 { v6.4S}, [x10], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x9], #16
    ld1 { v7.4S}, [x10], #16

#if L > 4
    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x11], #16
    ld1 { v4.4S}, [x12], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x11], #16
    ld1 { v5.4S}, [x12], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x11], #16
    ld1 { v6.4S}, [x12], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x11], #16
    ld1 { v7.4S}, [x12], #16
#endif

#if L > 5
    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x13], #16
    ld1 { v4.4S}, [x14], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x13], #16
    ld1 { v5.4S}, [x14], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x13], #16
    ld1 { v6.4S}, [x14], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x13], #16
    ld1 { v7.4S}, [x14], #16

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [x15], #16
    ld1 { v4.4S}, [x19], #16
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [x15], #16
    ld1 { v5.4S}, [x19], #16
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [x15], #16
    ld1 { v6.4S}, [x19], #16
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [x15], #16
    ld1 { v7.4S}, [x19], #16
#endif

    sub x16, x16, #1
    cbnz x16, _polyvecl_pointwise_acc_montgomery_loop

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    st1 {v24.4S}, [x0], #16
    st1 {v25.4S}, [x0], #16
    st1 {v26.4S}, [x0], #16
    st1 {v27.4S}, [x0], #16

    pop_all
    ret

#endif

