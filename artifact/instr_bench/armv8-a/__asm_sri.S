
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
.global __asm_sri_D
.global ___asm_sri_D
__asm_sri_D:
___asm_sri_D:

    push_simd

.rept 256

    sri  d0,  d0, #5
    sri  d1,  d1, #5
    sri  d2,  d2, #5
    sri  d3,  d3, #5
    sri  d4,  d4, #5
    sri  d5,  d5, #5
    sri  d6,  d6, #5
    sri  d7,  d7, #5
    sri  d8,  d8, #5
    sri  d9,  d9, #5
    sri d10, d10, #5
    sri d11, d11, #5
    sri d12, d12, #5
    sri d13, d13, #5
    sri d14, d14, #5
    sri d15, d15, #5
    sri d16, d16, #5
    sri d17, d17, #5
    sri d18, d18, #5
    sri d19, d19, #5
    sri d20, d20, #5
    sri d21, d21, #5
    sri d22, d22, #5
    sri d23, d23, #5
    sri d24, d24, #5
    sri d25, d25, #5
    sri d26, d26, #5
    sri d27, d27, #5
    sri d28, d28, #5
    sri d29, d29, #5
    sri d30, d30, #5
    sri d31, d31, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_8B
.global ___asm_sri_8B
__asm_sri_8B:
___asm_sri_8B:

    push_simd

.rept 256

    sri   v0.8B,   v0.8B, #5
    sri   v1.8B,   v1.8B, #5
    sri   v2.8B,   v2.8B, #5
    sri   v3.8B,   v3.8B, #5
    sri   v4.8B,   v4.8B, #5
    sri   v5.8B,   v5.8B, #5
    sri   v6.8B,   v6.8B, #5
    sri   v7.8B,   v7.8B, #5
    sri   v8.8B,   v8.8B, #5
    sri   v9.8B,   v9.8B, #5
    sri  v10.8B,  v10.8B, #5
    sri  v11.8B,  v11.8B, #5
    sri  v12.8B,  v12.8B, #5
    sri  v13.8B,  v13.8B, #5
    sri  v14.8B,  v14.8B, #5
    sri  v15.8B,  v15.8B, #5
    sri  v16.8B,  v16.8B, #5
    sri  v17.8B,  v17.8B, #5
    sri  v18.8B,  v18.8B, #5
    sri  v19.8B,  v19.8B, #5
    sri  v20.8B,  v20.8B, #5
    sri  v21.8B,  v21.8B, #5
    sri  v22.8B,  v22.8B, #5
    sri  v23.8B,  v23.8B, #5
    sri  v24.8B,  v24.8B, #5
    sri  v25.8B,  v25.8B, #5
    sri  v26.8B,  v26.8B, #5
    sri  v27.8B,  v27.8B, #5
    sri  v28.8B,  v28.8B, #5
    sri  v29.8B,  v29.8B, #5
    sri  v30.8B,  v30.8B, #5
    sri  v31.8B,  v31.8B, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_16B
.global ___asm_sri_16B
__asm_sri_16B:
___asm_sri_16B:

    push_simd

.rept 256

    sri   v0.16B,   v0.16B, #5
    sri   v1.16B,   v1.16B, #5
    sri   v2.16B,   v2.16B, #5
    sri   v3.16B,   v3.16B, #5
    sri   v4.16B,   v4.16B, #5
    sri   v5.16B,   v5.16B, #5
    sri   v6.16B,   v6.16B, #5
    sri   v7.16B,   v7.16B, #5
    sri   v8.16B,   v8.16B, #5
    sri   v9.16B,   v9.16B, #5
    sri  v10.16B,  v10.16B, #5
    sri  v11.16B,  v11.16B, #5
    sri  v12.16B,  v12.16B, #5
    sri  v13.16B,  v13.16B, #5
    sri  v14.16B,  v14.16B, #5
    sri  v15.16B,  v15.16B, #5
    sri  v16.16B,  v16.16B, #5
    sri  v17.16B,  v17.16B, #5
    sri  v18.16B,  v18.16B, #5
    sri  v19.16B,  v19.16B, #5
    sri  v20.16B,  v20.16B, #5
    sri  v21.16B,  v21.16B, #5
    sri  v22.16B,  v22.16B, #5
    sri  v23.16B,  v23.16B, #5
    sri  v24.16B,  v24.16B, #5
    sri  v25.16B,  v25.16B, #5
    sri  v26.16B,  v26.16B, #5
    sri  v27.16B,  v27.16B, #5
    sri  v28.16B,  v28.16B, #5
    sri  v29.16B,  v29.16B, #5
    sri  v30.16B,  v30.16B, #5
    sri  v31.16B,  v31.16B, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_4H
.global ___asm_sri_4H
__asm_sri_4H:
___asm_sri_4H:

    push_simd

.rept 256

    sri   v0.4H,   v0.4H, #5
    sri   v1.4H,   v1.4H, #5
    sri   v2.4H,   v2.4H, #5
    sri   v3.4H,   v3.4H, #5
    sri   v4.4H,   v4.4H, #5
    sri   v5.4H,   v5.4H, #5
    sri   v6.4H,   v6.4H, #5
    sri   v7.4H,   v7.4H, #5
    sri   v8.4H,   v8.4H, #5
    sri   v9.4H,   v9.4H, #5
    sri  v10.4H,  v10.4H, #5
    sri  v11.4H,  v11.4H, #5
    sri  v12.4H,  v12.4H, #5
    sri  v13.4H,  v13.4H, #5
    sri  v14.4H,  v14.4H, #5
    sri  v15.4H,  v15.4H, #5
    sri  v16.4H,  v16.4H, #5
    sri  v17.4H,  v17.4H, #5
    sri  v18.4H,  v18.4H, #5
    sri  v19.4H,  v19.4H, #5
    sri  v20.4H,  v20.4H, #5
    sri  v21.4H,  v21.4H, #5
    sri  v22.4H,  v22.4H, #5
    sri  v23.4H,  v23.4H, #5
    sri  v24.4H,  v24.4H, #5
    sri  v25.4H,  v25.4H, #5
    sri  v26.4H,  v26.4H, #5
    sri  v27.4H,  v27.4H, #5
    sri  v28.4H,  v28.4H, #5
    sri  v29.4H,  v29.4H, #5
    sri  v30.4H,  v30.4H, #5
    sri  v31.4H,  v31.4H, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_8H
.global ___asm_sri_8H
__asm_sri_8H:
___asm_sri_8H:

    push_simd

.rept 256

    sri   v0.8H,   v0.8H, #5
    sri   v1.8H,   v1.8H, #5
    sri   v2.8H,   v2.8H, #5
    sri   v3.8H,   v3.8H, #5
    sri   v4.8H,   v4.8H, #5
    sri   v5.8H,   v5.8H, #5
    sri   v6.8H,   v6.8H, #5
    sri   v7.8H,   v7.8H, #5
    sri   v8.8H,   v8.8H, #5
    sri   v9.8H,   v9.8H, #5
    sri  v10.8H,  v10.8H, #5
    sri  v11.8H,  v11.8H, #5
    sri  v12.8H,  v12.8H, #5
    sri  v13.8H,  v13.8H, #5
    sri  v14.8H,  v14.8H, #5
    sri  v15.8H,  v15.8H, #5
    sri  v16.8H,  v16.8H, #5
    sri  v17.8H,  v17.8H, #5
    sri  v18.8H,  v18.8H, #5
    sri  v19.8H,  v19.8H, #5
    sri  v20.8H,  v20.8H, #5
    sri  v21.8H,  v21.8H, #5
    sri  v22.8H,  v22.8H, #5
    sri  v23.8H,  v23.8H, #5
    sri  v24.8H,  v24.8H, #5
    sri  v25.8H,  v25.8H, #5
    sri  v26.8H,  v26.8H, #5
    sri  v27.8H,  v27.8H, #5
    sri  v28.8H,  v28.8H, #5
    sri  v29.8H,  v29.8H, #5
    sri  v30.8H,  v30.8H, #5
    sri  v31.8H,  v31.8H, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_2S
.global ___asm_sri_2S
__asm_sri_2S:
___asm_sri_2S:

    push_simd

.rept 256

    sri   v0.2S,   v0.2S, #5
    sri   v1.2S,   v1.2S, #5
    sri   v2.2S,   v2.2S, #5
    sri   v3.2S,   v3.2S, #5
    sri   v4.2S,   v4.2S, #5
    sri   v5.2S,   v5.2S, #5
    sri   v6.2S,   v6.2S, #5
    sri   v7.2S,   v7.2S, #5
    sri   v8.2S,   v8.2S, #5
    sri   v9.2S,   v9.2S, #5
    sri  v10.2S,  v10.2S, #5
    sri  v11.2S,  v11.2S, #5
    sri  v12.2S,  v12.2S, #5
    sri  v13.2S,  v13.2S, #5
    sri  v14.2S,  v14.2S, #5
    sri  v15.2S,  v15.2S, #5
    sri  v16.2S,  v16.2S, #5
    sri  v17.2S,  v17.2S, #5
    sri  v18.2S,  v18.2S, #5
    sri  v19.2S,  v19.2S, #5
    sri  v20.2S,  v20.2S, #5
    sri  v21.2S,  v21.2S, #5
    sri  v22.2S,  v22.2S, #5
    sri  v23.2S,  v23.2S, #5
    sri  v24.2S,  v24.2S, #5
    sri  v25.2S,  v25.2S, #5
    sri  v26.2S,  v26.2S, #5
    sri  v27.2S,  v27.2S, #5
    sri  v28.2S,  v28.2S, #5
    sri  v29.2S,  v29.2S, #5
    sri  v30.2S,  v30.2S, #5
    sri  v31.2S,  v31.2S, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_4S
.global ___asm_sri_4S
__asm_sri_4S:
___asm_sri_4S:

    push_simd

.rept 256

    sri   v0.4S,   v0.4S, #5
    sri   v1.4S,   v1.4S, #5
    sri   v2.4S,   v2.4S, #5
    sri   v3.4S,   v3.4S, #5
    sri   v4.4S,   v4.4S, #5
    sri   v5.4S,   v5.4S, #5
    sri   v6.4S,   v6.4S, #5
    sri   v7.4S,   v7.4S, #5
    sri   v8.4S,   v8.4S, #5
    sri   v9.4S,   v9.4S, #5
    sri  v10.4S,  v10.4S, #5
    sri  v11.4S,  v11.4S, #5
    sri  v12.4S,  v12.4S, #5
    sri  v13.4S,  v13.4S, #5
    sri  v14.4S,  v14.4S, #5
    sri  v15.4S,  v15.4S, #5
    sri  v16.4S,  v16.4S, #5
    sri  v17.4S,  v17.4S, #5
    sri  v18.4S,  v18.4S, #5
    sri  v19.4S,  v19.4S, #5
    sri  v20.4S,  v20.4S, #5
    sri  v21.4S,  v21.4S, #5
    sri  v22.4S,  v22.4S, #5
    sri  v23.4S,  v23.4S, #5
    sri  v24.4S,  v24.4S, #5
    sri  v25.4S,  v25.4S, #5
    sri  v26.4S,  v26.4S, #5
    sri  v27.4S,  v27.4S, #5
    sri  v28.4S,  v28.4S, #5
    sri  v29.4S,  v29.4S, #5
    sri  v30.4S,  v30.4S, #5
    sri  v31.4S,  v31.4S, #5

.endr

    pop_simd
    ret

.align 6
.global __asm_sri_2D
.global ___asm_sri_2D
__asm_sri_2D:
___asm_sri_2D:

    push_simd

.rept 256

    sri   v0.2D,   v0.2D, #5
    sri   v1.2D,   v1.2D, #5
    sri   v2.2D,   v2.2D, #5
    sri   v3.2D,   v3.2D, #5
    sri   v4.2D,   v4.2D, #5
    sri   v5.2D,   v5.2D, #5
    sri   v6.2D,   v6.2D, #5
    sri   v7.2D,   v7.2D, #5
    sri   v8.2D,   v8.2D, #5
    sri   v9.2D,   v9.2D, #5
    sri  v10.2D,  v10.2D, #5
    sri  v11.2D,  v11.2D, #5
    sri  v12.2D,  v12.2D, #5
    sri  v13.2D,  v13.2D, #5
    sri  v14.2D,  v14.2D, #5
    sri  v15.2D,  v15.2D, #5
    sri  v16.2D,  v16.2D, #5
    sri  v17.2D,  v17.2D, #5
    sri  v18.2D,  v18.2D, #5
    sri  v19.2D,  v19.2D, #5
    sri  v20.2D,  v20.2D, #5
    sri  v21.2D,  v21.2D, #5
    sri  v22.2D,  v22.2D, #5
    sri  v23.2D,  v23.2D, #5
    sri  v24.2D,  v24.2D, #5
    sri  v25.2D,  v25.2D, #5
    sri  v26.2D,  v26.2D, #5
    sri  v27.2D,  v27.2D, #5
    sri  v28.2D,  v28.2D, #5
    sri  v29.2D,  v29.2D, #5
    sri  v30.2D,  v30.2D, #5
    sri  v31.2D,  v31.2D, #5

.endr

    pop_simd
    ret

