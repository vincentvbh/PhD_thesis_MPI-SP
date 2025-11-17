
.syntax unified


.align 4
.global __asm_TMVP_mul_4x4_full
.type __asm_TMVP_mul_4x4_full, %function
__asm_TMVP_mul_4x4_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TMVP_mul_4x4_loop:
#else
.rept 32
#endif

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(indx*8+0)*4]
    ldr.w r5, [r1, #(indx*8+1)*4]
    ldr.w r6, [r1, #(indx*8+2)*4]
    ldr.w r7, [r1, #(indx*8+3)*4]
    ldr.w r8, [r1, #(indx*8+4)*4]
    ldr.w r10, [r2, #(indx*4+0)*4]
    ldr.w r11, [r2, #(indx*4+1)*4]
    ldr.w r12, [r2, #(indx*4+2)*4]
    ldr.w r14, [r2, #(indx*4+3)*4]

    mul r9, r4, r10
    mla r9, r5, r11, r9
    mla r9, r6, r12, r9
    mla r9, r7, r14, r9

    str.w r9, [r0, #(indx*4+3)*4]

    mul r9, r5, r10
    mla r9, r6, r11, r9
    mla r9, r7, r12, r9
    mla r9, r8, r14, r9

    str.w r9, [r0, #(indx*4+2)*4]

    ldr.w r4, [r1, #(indx*8+5)*4]
    ldr.w r5, [r1, #(indx*8+6)*4]

    mul r9, r6, r10
    mla r9, r7, r11, r9
    mla r9, r8, r12, r9
    mla r9, r4, r14, r9

    str.w r9, [r0, #(indx*4+1)*4]

    mul r9, r7, r10
    mla r9, r8, r11, r9
    mla r9, r4, r12, r9
    mla r9, r5, r14, r9

    str.w r9, [r0, #(indx*4+0)*4]

.set indx, indx+1
.endr

    add.w r1, r1, #7*8*4
    add.w r2, r2, #7*4*4
    add.w r0, r0, #7*4*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TMVP_mul_4x4_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}

.align 4
.global __asm_TMVP_mla_4x4_full
.type __asm_TMVP_mla_4x4_full, %function
__asm_TMVP_mla_4x4_full:
    push.w {r4-r12, lr}

#ifdef LOOP
    mov r3, #32
    _TMVP_mla_4x4_loop:
#else
.rept 32
#endif

.set indx, 0
.rept 7

    ldr.w r4, [r1, #(indx*8+0)*4]
    ldr.w r5, [r1, #(indx*8+1)*4]
    ldr.w r6, [r1, #(indx*8+2)*4]
    ldr.w r7, [r1, #(indx*8+3)*4]
    ldr.w r8, [r1, #(indx*8+4)*4]
    ldr.w r9, [r0, #(indx*4+3)*4]
    ldr.w r10, [r2, #(indx*4+0)*4]
    ldr.w r11, [r2, #(indx*4+1)*4]
    ldr.w r12, [r2, #(indx*4+2)*4]
    ldr.w r14, [r2, #(indx*4+3)*4]

    mla r9, r4, r10, r9
    mla r9, r5, r11, r9
    mla r9, r6, r12, r9
    mla r9, r7, r14, r9

    str.w r9, [r0, #(indx*4+3)*4]
    ldr.w r9, [r0, #(indx*4+2)*4]

    mla r9, r5, r10, r9
    mla r9, r6, r11, r9
    mla r9, r7, r12, r9
    mla r9, r8, r14, r9

    str.w r9, [r0, #(indx*4+2)*4]

    ldr.w r4, [r1, #(indx*8+5)*4]
    ldr.w r9, [r0, #(indx*4+1)*4]
    ldr.w r5, [r1, #(indx*8+6)*4]

    mla r9, r6, r10, r9
    mla r9, r7, r11, r9
    mla r9, r8, r12, r9
    mla r9, r4, r14, r9

    str.w r9, [r0, #(indx*4+1)*4]
    ldr.w r9, [r0, #(indx*4+0)*4]

    mla r9, r7, r10, r9
    mla r9, r8, r11, r9
    mla r9, r4, r12, r9
    mla r9, r5, r14, r9

    str.w r9, [r0, #(indx*4+0)*4]

.set indx, indx+1
.endr

    add.w r1, r1, #7*8*4
    add.w r2, r2, #7*4*4
    add.w r0, r0, #7*4*4

#ifdef LOOP
    subs.w r3, #1
    bne.w _TMVP_mla_4x4_loop
#else
.endr
#endif

    pop.w {r4-r12, pc}
