

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
.global __asm_dup_w_to_vecB
.global ___asm_dup_w_to_vecB
__asm_dup_w_to_vecB:
___asm_dup_w_to_vecB:

    push_simd

.rept 256

    dup  v0.16B, w0
    dup  v1.16B, w0
    dup  v2.16B, w0
    dup  v3.16B, w0
    dup  v4.16B, w0
    dup  v5.16B, w0
    dup  v6.16B, w0
    dup  v7.16B, w0
    dup  v8.16B, w0
    dup  v9.16B, w0
    dup v10.16B, w0
    dup v11.16B, w0
    dup v12.16B, w0
    dup v13.16B, w0
    dup v14.16B, w0
    dup v15.16B, w0
    dup v16.16B, w0
    dup v17.16B, w0
    dup v18.16B, w0
    dup v19.16B, w0
    dup v20.16B, w0
    dup v21.16B, w0
    dup v22.16B, w0
    dup v23.16B, w0
    dup v24.16B, w0
    dup v25.16B, w0
    dup v26.16B, w0
    dup v27.16B, w0
    dup v28.16B, w0
    dup v29.16B, w0
    dup v30.16B, w0
    dup v31.16B, w0

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_w_to_vecH
.global ___asm_dup_w_to_vecH
__asm_dup_w_to_vecH:
___asm_dup_w_to_vecH:

    push_simd

.rept 256

    dup  v0.8H, w0
    dup  v1.8H, w0
    dup  v2.8H, w0
    dup  v3.8H, w0
    dup  v4.8H, w0
    dup  v5.8H, w0
    dup  v6.8H, w0
    dup  v7.8H, w0
    dup  v8.8H, w0
    dup  v9.8H, w0
    dup v10.8H, w0
    dup v11.8H, w0
    dup v12.8H, w0
    dup v13.8H, w0
    dup v14.8H, w0
    dup v15.8H, w0
    dup v16.8H, w0
    dup v17.8H, w0
    dup v18.8H, w0
    dup v19.8H, w0
    dup v20.8H, w0
    dup v21.8H, w0
    dup v22.8H, w0
    dup v23.8H, w0
    dup v24.8H, w0
    dup v25.8H, w0
    dup v26.8H, w0
    dup v27.8H, w0
    dup v28.8H, w0
    dup v29.8H, w0
    dup v30.8H, w0
    dup v31.8H, w0

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_w_to_vecS
.global ___asm_dup_w_to_vecS
__asm_dup_w_to_vecS:
___asm_dup_w_to_vecS:

    push_simd

.rept 256

    dup  v0.4S, w0
    dup  v1.4S, w0
    dup  v2.4S, w0
    dup  v3.4S, w0
    dup  v4.4S, w0
    dup  v5.4S, w0
    dup  v6.4S, w0
    dup  v7.4S, w0
    dup  v8.4S, w0
    dup  v9.4S, w0
    dup v10.4S, w0
    dup v11.4S, w0
    dup v12.4S, w0
    dup v13.4S, w0
    dup v14.4S, w0
    dup v15.4S, w0
    dup v16.4S, w0
    dup v17.4S, w0
    dup v18.4S, w0
    dup v19.4S, w0
    dup v20.4S, w0
    dup v21.4S, w0
    dup v22.4S, w0
    dup v23.4S, w0
    dup v24.4S, w0
    dup v25.4S, w0
    dup v26.4S, w0
    dup v27.4S, w0
    dup v28.4S, w0
    dup v29.4S, w0
    dup v30.4S, w0
    dup v31.4S, w0

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_x_to_vecD
.global ___asm_dup_x_to_vecD
__asm_dup_x_to_vecD:
___asm_dup_x_to_vecD:

    push_simd

.rept 256

    dup  v0.2D, x0
    dup  v1.2D, x0
    dup  v2.2D, x0
    dup  v3.2D, x0
    dup  v4.2D, x0
    dup  v5.2D, x0
    dup  v6.2D, x0
    dup  v7.2D, x0
    dup  v8.2D, x0
    dup  v9.2D, x0
    dup v10.2D, x0
    dup v11.2D, x0
    dup v12.2D, x0
    dup v13.2D, x0
    dup v14.2D, x0
    dup v15.2D, x0
    dup v16.2D, x0
    dup v17.2D, x0
    dup v18.2D, x0
    dup v19.2D, x0
    dup v20.2D, x0
    dup v21.2D, x0
    dup v22.2D, x0
    dup v23.2D, x0
    dup v24.2D, x0
    dup v25.2D, x0
    dup v26.2D, x0
    dup v27.2D, x0
    dup v28.2D, x0
    dup v29.2D, x0
    dup v30.2D, x0
    dup v31.2D, x0

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_B_to_vecB
.global ___asm_dup_B_to_vecB
__asm_dup_B_to_vecB:
___asm_dup_B_to_vecB:

    push_simd

.rept 256

    dup  v0.16B, v16.B[0]
    dup  v1.16B, v16.B[0]
    dup  v2.16B, v16.B[0]
    dup  v3.16B, v16.B[0]
    dup  v4.16B, v16.B[0]
    dup  v5.16B, v16.B[0]
    dup  v6.16B, v16.B[0]
    dup  v7.16B, v16.B[0]
    dup  v8.16B, v16.B[0]
    dup  v9.16B, v16.B[0]
    dup v10.16B, v16.B[0]
    dup v11.16B, v16.B[0]
    dup v12.16B, v16.B[0]
    dup v13.16B, v16.B[0]
    dup v14.16B, v16.B[0]
    dup v15.16B, v16.B[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_H_to_vecH
.global ___asm_dup_H_to_vecH
__asm_dup_H_to_vecH:
___asm_dup_H_to_vecH:

    push_simd

.rept 256

    dup  v0.8H, v16.H[0]
    dup  v1.8H, v16.H[0]
    dup  v2.8H, v16.H[0]
    dup  v3.8H, v16.H[0]
    dup  v4.8H, v16.H[0]
    dup  v5.8H, v16.H[0]
    dup  v6.8H, v16.H[0]
    dup  v7.8H, v16.H[0]
    dup  v8.8H, v16.H[0]
    dup  v9.8H, v16.H[0]
    dup v10.8H, v16.H[0]
    dup v11.8H, v16.H[0]
    dup v12.8H, v16.H[0]
    dup v13.8H, v16.H[0]
    dup v14.8H, v16.H[0]
    dup v15.8H, v16.H[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_S_to_vecS
.global ___asm_dup_S_to_vecS
__asm_dup_S_to_vecS:
___asm_dup_S_to_vecS:

    push_simd

.rept 256

    dup  v0.4S, v16.S[0]
    dup  v1.4S, v16.S[0]
    dup  v2.4S, v16.S[0]
    dup  v3.4S, v16.S[0]
    dup  v4.4S, v16.S[0]
    dup  v5.4S, v16.S[0]
    dup  v6.4S, v16.S[0]
    dup  v7.4S, v16.S[0]
    dup  v8.4S, v16.S[0]
    dup  v9.4S, v16.S[0]
    dup v10.4S, v16.S[0]
    dup v11.4S, v16.S[0]
    dup v12.4S, v16.S[0]
    dup v13.4S, v16.S[0]
    dup v14.4S, v16.S[0]
    dup v15.4S, v16.S[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_dup_D_to_vecD
.global ___asm_dup_D_to_vecD
__asm_dup_D_to_vecD:
___asm_dup_D_to_vecD:

    push_simd

.rept 256

    dup  v0.2D, v16.D[0]
    dup  v1.2D, v16.D[0]
    dup  v2.2D, v16.D[0]
    dup  v3.2D, v16.D[0]
    dup  v4.2D, v16.D[0]
    dup  v5.2D, v16.D[0]
    dup  v6.2D, v16.D[0]
    dup  v7.2D, v16.D[0]
    dup  v8.2D, v16.D[0]
    dup  v9.2D, v16.D[0]
    dup v10.2D, v16.D[0]
    dup v11.2D, v16.D[0]
    dup v12.2D, v16.D[0]
    dup v13.2D, v16.D[0]
    dup v14.2D, v16.D[0]
    dup v15.2D, v16.D[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_w_to_B
.global ___asm_mov_w_to_B
__asm_mov_w_to_B:
___asm_mov_w_to_B:

    push_simd

.rept 256

    mov  v0.B[0], w0
    mov  v1.B[0], w0
    mov  v2.B[0], w0
    mov  v3.B[0], w0
    mov  v4.B[0], w0
    mov  v5.B[0], w0
    mov  v6.B[0], w0
    mov  v7.B[0], w0
    mov  v8.B[0], w0
    mov  v9.B[0], w0
    mov v10.B[0], w0
    mov v11.B[0], w0
    mov v12.B[0], w0
    mov v13.B[0], w0
    mov v14.B[0], w0
    mov v15.B[0], w0
    mov v16.B[0], w0
    mov v17.B[0], w0
    mov v18.B[0], w0
    mov v19.B[0], w0
    mov v20.B[0], w0
    mov v21.B[0], w0
    mov v22.B[0], w0
    mov v23.B[0], w0
    mov v24.B[0], w0
    mov v25.B[0], w0
    mov v26.B[0], w0
    mov v27.B[0], w0
    mov v28.B[0], w0
    mov v29.B[0], w0
    mov v30.B[0], w0
    mov v31.B[0], w0

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_w_to_H
.global ___asm_mov_w_to_H
__asm_mov_w_to_H:
___asm_mov_w_to_H:

    push_simd

.rept 256

    mov  v0.H[0], w0
    mov  v1.H[0], w0
    mov  v2.H[0], w0
    mov  v3.H[0], w0
    mov  v4.H[0], w0
    mov  v5.H[0], w0
    mov  v6.H[0], w0
    mov  v7.H[0], w0
    mov  v8.H[0], w0
    mov  v9.H[0], w0
    mov v10.H[0], w0
    mov v11.H[0], w0
    mov v12.H[0], w0
    mov v13.H[0], w0
    mov v14.H[0], w0
    mov v15.H[0], w0
    mov v16.H[0], w0
    mov v17.H[0], w0
    mov v18.H[0], w0
    mov v19.H[0], w0
    mov v20.H[0], w0
    mov v21.H[0], w0
    mov v22.H[0], w0
    mov v23.H[0], w0
    mov v24.H[0], w0
    mov v25.H[0], w0
    mov v26.H[0], w0
    mov v27.H[0], w0
    mov v28.H[0], w0
    mov v29.H[0], w0
    mov v30.H[0], w0
    mov v31.H[0], w0

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_w_to_S
.global ___asm_mov_w_to_S
__asm_mov_w_to_S:
___asm_mov_w_to_S:

    push_simd

.rept 256

    mov  v0.S[0], w0
    mov  v1.S[0], w0
    mov  v2.S[0], w0
    mov  v3.S[0], w0
    mov  v4.S[0], w0
    mov  v5.S[0], w0
    mov  v6.S[0], w0
    mov  v7.S[0], w0
    mov  v8.S[0], w0
    mov  v9.S[0], w0
    mov v10.S[0], w0
    mov v11.S[0], w0
    mov v12.S[0], w0
    mov v13.S[0], w0
    mov v14.S[0], w0
    mov v15.S[0], w0
    mov v16.S[0], w0
    mov v17.S[0], w0
    mov v18.S[0], w0
    mov v19.S[0], w0
    mov v20.S[0], w0
    mov v21.S[0], w0
    mov v22.S[0], w0
    mov v23.S[0], w0
    mov v24.S[0], w0
    mov v25.S[0], w0
    mov v26.S[0], w0
    mov v27.S[0], w0
    mov v28.S[0], w0
    mov v29.S[0], w0
    mov v30.S[0], w0
    mov v31.S[0], w0

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_x_to_D
.global ___asm_mov_x_to_D
__asm_mov_x_to_D:
___asm_mov_x_to_D:

    push_simd

.rept 256

    mov  v0.D[0], x0
    mov  v1.D[0], x0
    mov  v2.D[0], x0
    mov  v3.D[0], x0
    mov  v4.D[0], x0
    mov  v5.D[0], x0
    mov  v6.D[0], x0
    mov  v7.D[0], x0
    mov  v8.D[0], x0
    mov  v9.D[0], x0
    mov v10.D[0], x0
    mov v11.D[0], x0
    mov v12.D[0], x0
    mov v13.D[0], x0
    mov v14.D[0], x0
    mov v15.D[0], x0
    mov v16.D[0], x0
    mov v17.D[0], x0
    mov v18.D[0], x0
    mov v19.D[0], x0
    mov v20.D[0], x0
    mov v21.D[0], x0
    mov v22.D[0], x0
    mov v23.D[0], x0
    mov v24.D[0], x0
    mov v25.D[0], x0
    mov v26.D[0], x0
    mov v27.D[0], x0
    mov v28.D[0], x0
    mov v29.D[0], x0
    mov v30.D[0], x0
    mov v31.D[0], x0

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_S_to_w
.global ___asm_mov_S_to_w
__asm_mov_S_to_w:
___asm_mov_S_to_w:

.rept 256

    mov  w0,  v0.S[0]
    mov  w1,  v0.S[0]
    mov  w2,  v0.S[0]
    mov  w3,  v0.S[0]
    mov  w4,  v0.S[0]
    mov  w5,  v0.S[0]
    mov  w6,  v0.S[0]
    mov  w7,  v0.S[0]
    mov  w8,  v0.S[0]
    mov  w9,  v0.S[0]
    mov w10,  v0.S[0]
    mov w11,  v0.S[0]
    mov w12,  v0.S[0]
    mov w13,  v0.S[0]
    mov w14,  v0.S[0]
    mov w15,  v0.S[0]

.endr

    ret

.align 6
.global __asm_mov_D_to_x
.global ___asm_mov_D_to_x
__asm_mov_D_to_x:
___asm_mov_D_to_x:

.rept 256

    mov  x0,  v0.D[0]
    mov  x1,  v0.D[0]
    mov  x2,  v0.D[0]
    mov  x3,  v0.D[0]
    mov  x4,  v0.D[0]
    mov  x5,  v0.D[0]
    mov  x6,  v0.D[0]
    mov  x7,  v0.D[0]
    mov  x8,  v0.D[0]
    mov  x9,  v0.D[0]
    mov x10,  v0.D[0]
    mov x11,  v0.D[0]
    mov x12,  v0.D[0]
    mov x13,  v0.D[0]
    mov x14,  v0.D[0]
    mov x15,  v0.D[0]

.endr

    ret

.align 6
.global __asm_mov_B_to_B
.global ___asm_mov_B_to_B
__asm_mov_B_to_B:
___asm_mov_B_to_B:

    push_simd

.rept 256

    mov  v0.B[0], v16.B[0]
    mov  v1.B[0], v16.B[0]
    mov  v2.B[0], v16.B[0]
    mov  v3.B[0], v16.B[0]
    mov  v4.B[0], v16.B[0]
    mov  v5.B[0], v16.B[0]
    mov  v6.B[0], v16.B[0]
    mov  v7.B[0], v16.B[0]
    mov  v8.B[0], v16.B[0]
    mov  v9.B[0], v16.B[0]
    mov v10.B[0], v16.B[0]
    mov v11.B[0], v16.B[0]
    mov v12.B[0], v16.B[0]
    mov v13.B[0], v16.B[0]
    mov v14.B[0], v16.B[0]
    mov v15.B[0], v16.B[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_H_to_H
.global ___asm_mov_H_to_H
__asm_mov_H_to_H:
___asm_mov_H_to_H:

    push_simd

.rept 256

    mov  v0.H[0], v16.H[0]
    mov  v1.H[0], v16.H[0]
    mov  v2.H[0], v16.H[0]
    mov  v3.H[0], v16.H[0]
    mov  v4.H[0], v16.H[0]
    mov  v5.H[0], v16.H[0]
    mov  v6.H[0], v16.H[0]
    mov  v7.H[0], v16.H[0]
    mov  v8.H[0], v16.H[0]
    mov  v9.H[0], v16.H[0]
    mov v10.H[0], v16.H[0]
    mov v11.H[0], v16.H[0]
    mov v12.H[0], v16.H[0]
    mov v13.H[0], v16.H[0]
    mov v14.H[0], v16.H[0]
    mov v15.H[0], v16.H[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_S_to_S
.global ___asm_mov_S_to_S
__asm_mov_S_to_S:
___asm_mov_S_to_S:

    push_simd

.rept 256

    mov  v0.S[0], v16.S[0]
    mov  v1.S[0], v16.S[0]
    mov  v2.S[0], v16.S[0]
    mov  v3.S[0], v16.S[0]
    mov  v4.S[0], v16.S[0]
    mov  v5.S[0], v16.S[0]
    mov  v6.S[0], v16.S[0]
    mov  v7.S[0], v16.S[0]
    mov  v8.S[0], v16.S[0]
    mov  v9.S[0], v16.S[0]
    mov v10.S[0], v16.S[0]
    mov v11.S[0], v16.S[0]
    mov v12.S[0], v16.S[0]
    mov v13.S[0], v16.S[0]
    mov v14.S[0], v16.S[0]
    mov v15.S[0], v16.S[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_D_to_D
.global ___asm_mov_D_to_D
__asm_mov_D_to_D:
___asm_mov_D_to_D:

    push_simd

.rept 256

    mov  v0.D[0], v16.D[0]
    mov  v1.D[0], v16.D[0]
    mov  v2.D[0], v16.D[0]
    mov  v3.D[0], v16.D[0]
    mov  v4.D[0], v16.D[0]
    mov  v5.D[0], v16.D[0]
    mov  v6.D[0], v16.D[0]
    mov  v7.D[0], v16.D[0]
    mov  v8.D[0], v16.D[0]
    mov  v9.D[0], v16.D[0]
    mov v10.D[0], v16.D[0]
    mov v11.D[0], v16.D[0]
    mov v12.D[0], v16.D[0]
    mov v13.D[0], v16.D[0]
    mov v14.D[0], v16.D[0]
    mov v15.D[0], v16.D[0]

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_16B_to_16B
.global ___asm_mov_16B_to_16B
__asm_mov_16B_to_16B:
___asm_mov_16B_to_16B:

    push_simd

.rept 256

    mov  v0.16B, v16.16B
    mov  v1.16B, v16.16B
    mov  v2.16B, v16.16B
    mov  v3.16B, v16.16B
    mov  v4.16B, v16.16B
    mov  v5.16B, v16.16B
    mov  v6.16B, v16.16B
    mov  v7.16B, v16.16B
    mov  v8.16B, v16.16B
    mov  v9.16B, v16.16B
    mov v10.16B, v16.16B
    mov v11.16B, v16.16B
    mov v12.16B, v16.16B
    mov v13.16B, v16.16B
    mov v14.16B, v16.16B
    mov v15.16B, v16.16B

.endr

    pop_simd
    ret

.align 6
.global __asm_mov_8B_to_8B
.global ___asm_mov_8B_to_8B
__asm_mov_8B_to_8B:
___asm_mov_8B_to_8B:

    push_simd

.rept 256

    mov  v0.8B, v16.8B
    mov  v1.8B, v16.8B
    mov  v2.8B, v16.8B
    mov  v3.8B, v16.8B
    mov  v4.8B, v16.8B
    mov  v5.8B, v16.8B
    mov  v6.8B, v16.8B
    mov  v7.8B, v16.8B
    mov  v8.8B, v16.8B
    mov  v9.8B, v16.8B
    mov v10.8B, v16.8B
    mov v11.8B, v16.8B
    mov v12.8B, v16.8B
    mov v13.8B, v16.8B
    mov v14.8B, v16.8B
    mov v15.8B, v16.8B

.endr

    pop_simd
    ret



