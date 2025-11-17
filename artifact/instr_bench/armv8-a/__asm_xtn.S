
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
.global __asm_xtn_xtn2_8H
.global ___asm_xtn_xtn2_8H
__asm_xtn_xtn2_8H:
___asm_xtn_xtn2_8H:

    push_simd

.rept 256

    xtn    v0.8B,  v16.8H
    xtn2  v1.16B,  v17.8H
    xtn    v2.8B,  v18.8H
    xtn2  v3.16B,  v19.8H
    xtn    v4.8B,  v20.8H
    xtn2  v5.16B,  v21.8H
    xtn    v6.8B,  v22.8H
    xtn2  v7.16B,  v23.8H
    xtn    v8.8B,  v24.8H
    xtn2  v9.16B,  v25.8H
    xtn   v10.8B,  v26.8H
    xtn2 v11.16B,  v27.8H
    xtn   v12.8B,  v28.8H
    xtn2 v13.16B,  v29.8H
    xtn   v14.8B,  v30.8H
    xtn2 v15.16B,  v31.8H

.endr

    pop_simd
    ret

.align 6
.global __asm_xtn_xtn2_4S
.global ___asm_xtn_xtn2_4S
__asm_xtn_xtn2_4S:
___asm_xtn_xtn2_4S:

    push_simd

.rept 256

    xtn    v0.4H,  v16.4S
    xtn2   v1.8H,  v17.4S
    xtn    v2.4H,  v18.4S
    xtn2   v3.8H,  v19.4S
    xtn    v4.4H,  v20.4S
    xtn2   v5.8H,  v21.4S
    xtn    v6.4H,  v22.4S
    xtn2   v7.8H,  v23.4S
    xtn    v8.4H,  v24.4S
    xtn2   v9.8H,  v25.4S
    xtn   v10.4H,  v26.4S
    xtn2  v11.8H,  v27.4S
    xtn   v12.4H,  v28.4S
    xtn2  v13.8H,  v29.4S
    xtn   v14.4H,  v30.4S
    xtn2  v15.8H,  v31.4S

.endr

    pop_simd
    ret

.align 6
.global __asm_xtn_xtn2_2D
.global ___asm_xtn_xtn2_2D
__asm_xtn_xtn2_2D:
___asm_xtn_xtn2_2D:

    push_simd

.rept 256

    xtn    v0.2S,  v16.2D
    xtn2   v1.4S,  v17.2D
    xtn    v2.2S,  v18.2D
    xtn2   v3.4S,  v19.2D
    xtn    v4.2S,  v20.2D
    xtn2   v5.4S,  v21.2D
    xtn    v6.2S,  v22.2D
    xtn2   v7.4S,  v23.2D
    xtn    v8.2S,  v24.2D
    xtn2   v9.4S,  v25.2D
    xtn   v10.2S,  v26.2D
    xtn2  v11.4S,  v27.2D
    xtn   v12.2S,  v28.2D
    xtn2  v13.4S,  v29.2D
    xtn   v14.2S,  v30.2D
    xtn2  v15.4S,  v31.2D

.endr

    pop_simd
    ret


