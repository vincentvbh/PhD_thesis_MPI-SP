
.syntax unified

#define LOOP

.align 4
.global __asm_compress1
.type __asm_compress1, %function
__asm_compress1:
    push.w {lr}

    movw r3, #:lower16:2580335
    movt r3, #:upper16:2580335

    ldrsh.w r2, [r1]

    smmulr r2, r2, r3
    ubfx.w r2, r2, #0, #1

    strh.w r2, [r0]

    pop.w {pc}

.align 4
.global __asm_compress4
.type __asm_compress4, %function
__asm_compress4:
    push.w {lr}

    movw r3, #:lower16:20642679
    movt r3, #:upper16:20642679

    ldrsh.w r2, [r1]

    smmulr r2, r2, r3
    ubfx.w r2, r2, #0, #4

    strh.w r2, [r0]

    pop.w {pc}

.align 4
.global __asm_compress5
.type __asm_compress5, %function
__asm_compress5:
    push.w {lr}

    movw r3, #:lower16:41285357
    movt r3, #:upper16:41285357

    ldrsh.w r2, [r1]

    smmulr r2, r2, r3
    ubfx.w r2, r2, #0, #5

    strh.w r2, [r0]

    pop.w {pc}

.align 4
.global __asm_compress10
.type __asm_compress10, %function
__asm_compress10:
    push.w {lr}

    movw r3, #:lower16:1321131424
    movt r3, #:upper16:1321131424

    ldrsh.w r2, [r1]

    smmulr r2, r2, r3
    ubfx.w r2, r2, #0, #10

    strh.w r2, [r0]

    pop.w {pc}

.align 4
.global __asm_compress11
.type __asm_compress11, %function
__asm_compress11:
    push.w {r4, lr}

    movw r3, #:lower16:1290167
    movt r3, #:upper16:1290167

    mov r4, #16

    ldrsh.w r2, [r1]

    smlawb r2, r3, r2, r4
    ubfx.w r2, r2, #5, #11

    strh.w r2, [r0]

    pop.w {r4, pc}

.align 4
.global __asm_compress1_smmulr_core
.type __asm_compress1_smmulr_core, %function
__asm_compress1_smmulr_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:2580335
    movt r2, #:upper16:2580335
    mov.w r14, #0x10001

    __asm_compress1_smmulr_core_loop:

    ldrsh.w r5, [r1, #2]
    ldrsh.w r6, [r1, #4]
    ldrsh.w r7, [r1, #6]
    ldrsh.w r8, [r1, #8]
    ldrsh.w r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]
    ldrsh.w r4, [r1], #16

    smmulr r4, r4, r2
    smmulr r5, r5, r2
    smmulr r6, r6, r2
    smmulr r7, r7, r2
    smmulr r8, r8, r2
    smmulr r9, r9, r2
    smmulr r10, r10, r2
    smmulr r11, r11, r2

    pkhbt r4, r4, r5, lsl #16
    pkhbt r6, r6, r7, lsl #16
    pkhbt r8, r8, r9, lsl #16
    pkhbt r10, r10, r11, lsl #16

    and.w r4, r4, r14
    and.w r6, r6, r14
    and.w r8, r8, r14
    and.w r10, r10, r14

    orr.w r4, r4, r6, lsl #2
    orr.w r4, r4, r8, lsl #4
    orr.w r4, r4, r10, lsl #6
    orr.w r4, r4, r4, lsr #15

    strb.w r4, [r0], #1

    cmp.w r3, r1
    bne.w __asm_compress1_smmulr_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress4_smmulr_core
.type __asm_compress4_smmulr_core, %function
__asm_compress4_smmulr_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:20642679
    movt r2, #:upper16:20642679
    mov.w r14, #0xf000f

    __asm_compress4_smmulr_core_loop:

    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]
    ldrsh.w  r4, [r1], #16

    smmulr  r4,  r4, r2
    smmulr  r5,  r5, r2
    smmulr  r6,  r6, r2
    smmulr  r7,  r7, r2
    smmulr  r8,  r8, r2
    smmulr  r9,  r9, r2
    smmulr r10, r10, r2
    smmulr r11, r11, r2

    pkhbt  r4,  r4,  r5, lsl #16
    pkhbt  r6,  r6,  r7, lsl #16
    pkhbt  r8,  r8,  r9, lsl #16
    pkhbt r10, r10, r11, lsl #16

    and.w  r4,  r4,  r14
    and.w  r6,  r6,  r14
    and.w  r8,  r8,  r14
    and.w r10, r10,  r14

    orr.w  r4,  r4,  r6, lsl #8
    orr.w  r4,  r4,  r4, lsr #12
    orr.w  r8,  r8, r10, lsl #8
    orr.w  r8,  r8,  r8, lsr #12

    pkhbt  r4,  r4,  r8, lsl #16

    str.w r4, [r0], #4

    cmp.w r3, r1
    bne.w __asm_compress4_smmulr_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress5_smmulr_core
.type __asm_compress5_smmulr_core, %function
__asm_compress5_smmulr_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:41285357
    movt r2, #:upper16:41285357

    __asm_compress5_smmulr_core_loop:

    ldrsh.w r5, [r1, #2]
    ldrsh.w r6, [r1, #4]
    ldrsh.w r7, [r1, #6]
    ldrsh.w r8, [r1, #8]
    ldrsh.w r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]
    ldrsh.w r4, [r1], #16

    smmulr r4, r4, r2
    smmulr r5, r5, r2
    smmulr r6, r6, r2
    smmulr r7, r7, r2
    smmulr r8, r8, r2
    smmulr r9, r9, r2
    smmulr r10, r10, r2
    smmulr r11, r11, r2

    ubfx.w r4, r4, #0, #5
    ubfx.w r5, r5, #0, #5
    ubfx.w r6, r6, #0, #5
    ubfx.w r7, r7, #0, #5
    ubfx.w r8, r8, #0, #5
    ubfx.w r9, r9, #0, #5
    ubfx.w r10, r10, #0, #5
    ubfx.w r11, r11, #0, #5

    orr.w r4, r4, r5, lsl #5
    orr.w r4, r4, r6, lsl #10
    orr.w r4, r4, r7, lsl #15
    orr.w r4, r4, r8, lsl #20
    orr.w r4, r4, r9, lsl #25
    orr.w r4, r4, r10, lsl #30
    lsr.w r10, r10, #2
    orr.w r10, r10, r11, lsl #3

    strb.w r10, [r0, #4]
    str.w r4, [r0], #5

    cmp.w r3, r1
    bne.w __asm_compress5_smmulr_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress10_smmulr_core
.type __asm_compress10_smmulr_core, %function
__asm_compress10_smmulr_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:1321131424
    movt r2, #:upper16:1321131424

    __asm_compress10_smmulr_core_loop:

    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]
    ldrsh.w  r4, [r1], #16

    smmulr  r4,  r4, r2
    smmulr  r5,  r5, r2
    smmulr  r6,  r6, r2
    smmulr  r7,  r7, r2
    smmulr  r8,  r8, r2
    smmulr  r9,  r9, r2
    smmulr r10, r10, r2
    smmulr r11, r11, r2

    ubfx.w  r4,  r4, #0, #10
    ubfx.w  r5,  r5, #0, #10
    ubfx.w  r6,  r6, #0, #10
    ubfx.w  r7,  r7, #0, #10
    ubfx.w  r8,  r8, #0, #10
    ubfx.w  r9,  r9, #0, #10
    ubfx.w r10, r10, #0, #10
    ubfx.w r11, r11, #0, #10

    orr.w  r4,  r4,  r5, lsl #10
    orr.w  r4,  r4,  r6, lsl #20
    orr.w  r4,  r4,  r7, lsl #30
    lsr.w  r7,  r7, #2

    orr.w  r8,  r8,  r9, lsl #10
    orr.w  r8,  r8, r10, lsl #20
    orr.w  r8,  r8, r11, lsl #30
    lsr.w r11, r11, #2

    strb.w r7, [r0, #4]
    str.w r8, [r0, #5]
    strb.w r11, [r0, #9]
    str.w r4, [r0], #10

    cmp.w r3, r1
    bne.w __asm_compress10_smmulr_core_loop

    pop.w {r4-r12, pc}

.macro compressx2 a, m, round, t
    smlawt \t, \m, \a, \round
    smlawb \a, \m, \a, \round
    pkhtb  \a, \t, \a, asr #16
.endm

.align 4
.global __asm_compress1_core
.type __asm_compress1_core, %function
__asm_compress1_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #5

    movw r2, #:lower16:2580335
    movt r2, #:upper16:2580335
    mov.w r12, #1
    lsl.w r12, r12, #15

    __asm_compress1_core_loop:

    ldr.w  r5, [r1, # 4]
    ldr.w  r6, [r1, # 8]
    ldr.w  r7, [r1, #12]
    ldr.w  r8, [r1, #16]
    ldr.w  r9, [r1, #20]
    ldr.w r10, [r1, #24]
    ldr.w r11, [r1, #28]
    ldr.w  r4, [r1], #32

    compressx2  r4, r2, r12, r14
    compressx2  r5, r2, r12, r14
    compressx2  r6, r2, r12, r14
    compressx2  r7, r2, r12, r14
    compressx2  r8, r2, r12, r14
    compressx2  r9, r2, r12, r14
    compressx2 r10, r2, r12, r14
    compressx2 r11, r2, r12, r14

    mov.w r14, #0x10001
    and.w  r4,  r4, r14
    and.w  r5,  r5, r14
    and.w  r6,  r6, r14
    and.w  r7,  r7, r14
    and.w  r8,  r8, r14
    and.w  r9,  r9, r14
    and.w r10, r10, r14
    and.w r11, r11, r14

    orr.w  r4,  r4,  r5, lsl #2
    orr.w  r4,  r4,  r6, lsl #4
    orr.w  r4,  r4,  r7, lsl #6
    orr.w  r4,  r4,  r4, lsr #15
    orr.w  r8,  r8,  r9, lsl #2
    orr.w  r8,  r8, r10, lsl #4
    orr.w  r8,  r8, r11, lsl #6
    orr.w  r8,  r8,  r8, lsr #15

    orr.w  r4,  r4,  r8, lsl #8

    strh.w r4, [r0], #2

    cmp.w r3, r1
    bne.w __asm_compress1_core_loop

    pop.w {r4-r12, pc}

.macro pack4x4 a, b, t
    and.w \a, \a, \t
    and.w \b, \b, \t
    orr.w \a, \a, \b, lsl #8
    orr.w \a, \a, \a, lsr #12
.endm

.align 4
.global __asm_compress4_core
.type __asm_compress4_core, %function
__asm_compress4_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #5

    movw r2, #:lower16:20642679
    movt r2, #:upper16:20642679

    mov.w r12, #1
    lsl.w r12, r12, #15

    __asm_compress4_core_loop:

    ldr.w  r5, [r1, # 4]
    ldr.w  r6, [r1, # 8]
    ldr.w  r7, [r1, #12]
    ldr.w  r8, [r1, #16]
    ldr.w  r9, [r1, #20]
    ldr.w r10, [r1, #24]
    ldr.w r11, [r1, #28]
    ldr.w  r4, [r1], #32

    compressx2  r4, r2, r12, r14
    compressx2  r5, r2, r12, r14
    compressx2  r6, r2, r12, r14
    compressx2  r7, r2, r12, r14
    compressx2  r8, r2, r12, r14
    compressx2  r9, r2, r12, r14
    compressx2 r10, r2, r12, r14
    compressx2 r11, r2, r12, r14

    mov.w r14, #0xf000f
    pack4x4  r4,  r5, r14
    pack4x4  r6,  r7, r14
    pack4x4  r8,  r9, r14
    pack4x4 r10, r11, r14

    strh.w  r6, [r0, #2]
    strh.w  r8, [r0, #4]
    strh.w r10, [r0, #6]
    strh.w  r4, [r0], #8

    cmp.w r3, r1
    bne.w __asm_compress4_core_loop

    pop.w {r4-r12, pc}

.macro pack_compress5x8 a0, a1, a2, a3, m, round, t

    smlawt  \t,  \m, \a0, \round
    smlawb \a0,  \m, \a0, \round

    ubfx.w \a0, \a0, #16, #5
    ubfx.w  \t,  \t, #16, #5

    orr.w \a0, \a0,  \t, lsl #5

    smlawt  \t,  \m, \a1, \round
    smlawb \a1,  \m, \a1, \round

    ubfx.w \a1, \a1, #16, #5
    ubfx.w  \t,  \t, #16, #5

    orr.w  \a0, \a0, \a1, lsl #10
    orr.w  \a0, \a0,  \t, lsl #15

    smlawt  \t,  \m, \a2, \round
    smlawb \a2,  \m, \a2, \round

    ubfx.w \a2, \a2, #16, #5
    ubfx.w  \t,  \t, #16, #5

    orr.w  \a0, \a0, \a2, lsl #20
    orr.w  \a0, \a0,  \t, lsl #25

    smlawt  \t,  \m, \a3, \round
    smlawb \a3,  \m, \a3, \round

    ubfx.w \a3, \a3, #16, #5
    ubfx.w  \t,  \t, #16, #5

    orr.w \a0, \a0, \a3, lsl #30
    lsr.w \a1, \a3, #2
    orr.w \a1, \a1,  \t, lsl #3

.endm

.align 4
.global __asm_compress5_core
.type __asm_compress5_core, %function
__asm_compress5_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #5

    movw r2, #:lower16:41285357
    movt r2, #:upper16:41285357

    mov.w r12, #1
    lsl.w r12, r12, #15

    __asm_compress5_core_loop:

    ldr.w  r5, [r1, # 4]
    ldr.w  r6, [r1, # 8]
    ldr.w  r7, [r1, #12]
    ldr.w  r8, [r1, #16]
    ldr.w  r9, [r1, #20]
    ldr.w r10, [r1, #24]
    ldr.w r11, [r1, #28]
    ldr.w  r4, [r1], #32

    pack_compress5x8  r4,  r5,  r6,  r7, r2, r12, r14
    pack_compress5x8  r8,  r9, r10, r11, r2, r12, r14

    strb.w r5, [r0, #4]
    str.w r8, [r0, #5]
    strb.w r9, [r0, #9]
    str.w r4, [r0], #10

    cmp.w r3, r1
    bne.w __asm_compress5_core_loop

    pop.w {r4-r12, pc}

.macro pack_compress10x4 a0, a1, m, round, t

    smlawt  \t,  \m, \a0, \round
    smlawb \a0,  \m, \a0, \round

    ubfx.w \a0, \a0, #16, #10
    ubfx.w  \t,  \t, #16, #10

    orr.w  \a0, \a0,  \t, lsl #10

    smlawt  \t,  \m, \a1, \round
    smlawb \a1,  \m, \a1, \round

    ubfx.w \a1, \a1, #16, #10
    ubfx.w  \t,  \t, #16, #10

    orr.w  \a0, \a0, \a1, lsl #20
    orr.w  \a0, \a0,  \t, lsl #30
    lsr.w  \a1,  \t, #2

.endm

.align 4
.global __asm_compress10_core
.type __asm_compress10_core, %function
__asm_compress10_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #5

    movw r2, #:lower16:1321131424
    movt r2, #:upper16:1321131424
    mov.w r12, #1
    lsl.w r12, r12, #15

    __asm_compress10_core_loop:

    ldr.w  r5, [r1, # 4]
    ldr.w  r6, [r1, # 8]
    ldr.w  r7, [r1, #12]
    ldr.w  r8, [r1, #16]
    ldr.w  r9, [r1, #20]
    ldr.w r10, [r1, #24]
    ldr.w r11, [r1, #28]
    ldr.w  r4, [r1], #32

    pack_compress10x4  r4,  r5, r2, r12, r14
    pack_compress10x4  r6,  r7, r2, r12, r14
    pack_compress10x4  r8,  r9, r2, r12, r14
    pack_compress10x4 r10, r11, r2, r12, r14

    strb.w r5, [r0, #4]
    str.w r6, [r0, #5]
    strb.w r7, [r0, #9]
    str.w r8, [r0, #10]
    strb.w r9, [r0, #14]
    str.w r10, [r0, #15]
    strb.w r11, [r0, #19]
    str.w r4, [r0], #20

    cmp.w r3, r1
    bne.w __asm_compress10_core_loop

    pop.w {r4-r12, pc}

.macro pack_compress11x8 a0, a1, a2, a3, m, round, t

    smlawt \t, \m, \a0, \round
    smlawb \a0, \m, \a0, \round
    ubfx.w \a0, \a0, #5, #11
    ubfx.w \t, \t, #5, #11
    orr.w \a0, \a0, \t, lsl #11

    smlawt \t, \m, \a1, \round
    smlawb \a1, \m, \a1, \round
    ubfx.w \a1, \a1, #5, #11
    ubfx.w \t, \t, #5, #11
    orr.w \a0, \a0, \a1, lsl #22
    lsr.w \a1, \a1, #10
    orr.w \a1, \a1, \t, lsl #1

    smlawt \t, \m, \a2, \round
    smlawb \a2, \m, \a2, \round
    ubfx.w \a2, \a2, #5, #11
    ubfx.w \t, \t, #5, #11
    orr.w \a1, \a1, \a2, lsl #12
    orr.w \a1, \a1, \t, lsl #23
    lsr.w \a2, \t, #9

    smlawt \t, \m, \a3, \round
    smlawb \a3, \m, \a3, \round
    ubfx.w \a3, \a3, #5, #11
    ubfx.w \t, \t, #5, #11
    orr.w \a2, \a2, \a3, lsl #2
    orr.w \a2, \a2, \t, lsl #13
    lsr.w \a3, \a2, #16

.endm

.align 4
.global __asm_compress11_core
.type __asm_compress11_core, %function
__asm_compress11_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #5

    movw r2, #:lower16:1290167
    movt r2, #:upper16:1290167
    mov.w r12, #16

    __asm_compress11_core_loop:

    ldr.w  r5, [r1, # 4]
    ldr.w  r6, [r1, # 8]
    ldr.w  r7, [r1, #12]
    ldr.w  r8, [r1, #16]
    ldr.w  r9, [r1, #20]
    ldr.w r10, [r1, #24]
    ldr.w r11, [r1, #28]
    ldr.w  r4, [r1], #32

    pack_compress11x8  r4,  r5,  r6,  r7, r2, r12, r14
    pack_compress11x8  r8,  r9, r10, r11, r2, r12, r14

    str.w r5, [r0, #4]
    strh.w r6, [r0, #8]
    strb.w r7, [r0, #10]
    str.w r8, [r0, #11]
    str.w r9, [r0, #15]
    strh.w r10, [r0, #19]
    strb.w r11, [r0, #21]
    str.w r4, [r0], #22

    cmp.w r3, r1
    bne.w __asm_compress11_core_loop

    pop.w {r4-r12, pc}












