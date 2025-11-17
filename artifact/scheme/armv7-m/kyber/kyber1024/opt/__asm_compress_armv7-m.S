
.syntax unified

#define LOOP

.macro compressx1 a, m, round, pos, width
    mla \a, \a, \m, \round
    ubfx \a, \a, #\pos, #\width
.endm

.macro compress_longx1 a, m, round, pos, width
    mul   \a, \a, \m
    add.w \a, \round, \a, asr #1
    ubfx  \a, \a, #\pos, #\width
.endm

.align 4
.global __asm_compress1
.type __asm_compress1, %function
__asm_compress1:
    push.w {lr}

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #18

    ldrsh.w r3, [r1]
    compressx1 r3, r2, r12, 19, 1

    strh.w r3, [r0]

    pop.w {pc}

.align 4
.global __asm_compress4
.type __asm_compress4, %function
__asm_compress4:
    push.w {lr}

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #15

    ldrsh.w r3, [r1]
    compressx1 r3, r2, r12, 16, 4

    strh.w r3, [r0]

    pop.w {pc}

.align 4
.global __asm_compress5
.type __asm_compress5, %function
__asm_compress5:
    push.w {lr}

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #14

    ldrsh.w r3, [r1]
    compressx1 r3, r2, r12, 15, 5

    strh.w r3, [r0]

    pop.w {pc}

.align 4
.global __asm_compress10
.type __asm_compress10, %function
__asm_compress10:
    push.w {lr}

    movw r2, #:lower16:1290167
    movt r2, #:upper16:1290167
    mov.w r12, #1
    lsl.w r12, r12, #20

    ldrsh.w r3, [r1]
    compress_longx1 r3, r2, r12, 21, 10

    strh.w r3, [r0]

    pop.w {pc}

.align 4
.global __asm_compress11
.type __asm_compress11, %function
__asm_compress11:
    push.w {lr}

    movw r2, #:lower16:1290167
    movt r2, #:upper16:1290167
    mov.w r12, #1
    lsl.w r12, r12, #19

    ldrsh.w r3, [r1]
    compress_longx1 r3, r2, r12, 20, 11

    strh.w r3, [r0]

    pop.w {pc}

.align 4
.global __asm_compress1_core
.type __asm_compress1_core, %function
__asm_compress1_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #18

    __asm_compress1_core_loop:

    ldrsh.w  r4, [r1, # 0]
    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]

    add.w r1, r1, #16

    compressx1  r4, r2, r12, 19, 1
    compressx1  r5, r2, r12, 19, 1
    compressx1  r6, r2, r12, 19, 1
    compressx1  r7, r2, r12, 19, 1
    compressx1  r8, r2, r12, 19, 1
    compressx1  r9, r2, r12, 19, 1
    compressx1 r10, r2, r12, 19, 1
    compressx1 r11, r2, r12, 19, 1

    orr.w  r4,  r4,  r5, lsl #1
    orr.w  r4,  r4,  r6, lsl #2
    orr.w  r4,  r4,  r7, lsl #3
    orr.w  r4,  r4,  r8, lsl #4
    orr.w  r4,  r4,  r9, lsl #5
    orr.w  r4,  r4, r10, lsl #6
    orr.w  r4,  r4, r11, lsl #7

    strb.w r4, [r0], #1

    cmp.w r3, r1
    bne.w __asm_compress1_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress4_core
.type __asm_compress4_core, %function
__asm_compress4_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #15

    __asm_compress4_core_loop:

    ldrsh.w  r4, [r1, # 0]
    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]

    add.w r1, r1, #16

    compressx1  r4, r2, r12, 16, 4
    compressx1  r5, r2, r12, 16, 4
    compressx1  r6, r2, r12, 16, 4
    compressx1  r7, r2, r12, 16, 4
    compressx1  r8, r2, r12, 16, 4
    compressx1  r9, r2, r12, 16, 4
    compressx1 r10, r2, r12, 16, 4
    compressx1 r11, r2, r12, 16, 4

    orr.w  r4,  r4,  r5, lsl # 4
    orr.w  r4,  r4,  r6, lsl # 8
    orr.w  r4,  r4,  r7, lsl #12
    orr.w  r4,  r4,  r8, lsl #16
    orr.w  r4,  r4,  r9, lsl #20
    orr.w  r4,  r4, r10, lsl #24
    orr.w  r4,  r4, r11, lsl #28

    str.w  r4, [r0], #4

    cmp.w r3, r1
    bne.w __asm_compress4_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress5_core
.type __asm_compress5_core, %function
__asm_compress5_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    mov.w r2, #315
    mov.w r12, #1
    lsl.w r12, r12, #14

    __asm_compress5_core_loop:

    ldrsh.w  r4, [r1, # 0]
    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]

    add.w r1, r1, #16

    compressx1  r4, r2, r12, 15, 5
    compressx1  r5, r2, r12, 15, 5
    compressx1  r6, r2, r12, 15, 5
    compressx1  r7, r2, r12, 15, 5
    compressx1  r8, r2, r12, 15, 5
    compressx1  r9, r2, r12, 15, 5
    compressx1 r10, r2, r12, 15, 5
    compressx1 r11, r2, r12, 15, 5

    orr.w  r4,  r4,  r5, lsl # 5
    orr.w  r4,  r4,  r6, lsl #10
    orr.w  r4,  r4,  r7, lsl #15
    orr.w  r4,  r4,  r8, lsl #20
    orr.w  r4,  r4,  r9, lsl #25
    orr.w  r4,  r4, r10, lsl #30
    lsr.w r10, r10, #2
    orr.w r10, r10, r11, lsl #3

    strb.w r10, [r0, #4]
    str.w  r4, [r0], #5

    cmp.w r3, r1
    bne.w __asm_compress5_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress10_core
.type __asm_compress10_core, %function
__asm_compress10_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:1290167
    movt r2, #:upper16:1290167
    mov.w r12, #1
    lsl.w r12, r12, #20

    __asm_compress10_core_loop:

    ldrsh.w  r4, [r1, # 0]
    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]

    add.w r1, r1, #16

    compress_longx1  r4, r2, r12, 21, 10
    compress_longx1  r5, r2, r12, 21, 10
    compress_longx1  r6, r2, r12, 21, 10
    compress_longx1  r7, r2, r12, 21, 10
    compress_longx1  r8, r2, r12, 21, 10
    compress_longx1  r9, r2, r12, 21, 10
    compress_longx1 r10, r2, r12, 21, 10
    compress_longx1 r11, r2, r12, 21, 10

    orr.w  r4,  r4,  r5, lsl #10
    orr.w  r4,  r4,  r6, lsl #20
    orr.w  r4,  r4,  r7, lsl #30
    lsr.w  r7,  r7, #2
    orr.w  r7,  r7,  r8, lsl #8
    orr.w  r7,  r7,  r9, lsl #18
    orr.w  r7,  r7, r10, lsl #28
    lsr.w r10, r10, #4
    orr.w r10, r10, r11, lsl #6

    str.w r7, [r0, #4]
    strh.w r10, [r0, #8]
    str.w  r4, [r0], #10

    cmp.w r3, r1
    bne.w __asm_compress10_core_loop

    pop.w {r4-r12, pc}

.align 4
.global __asm_compress11_core
.type __asm_compress11_core, %function
__asm_compress11_core:
    push.w {r4-r12, lr}

    add.w r3, r1, r2, lsl #4

    movw r2, #:lower16:1290167
    movt r2, #:upper16:1290167
    mov.w r12, #1
    lsl.w r12, r12, #19

    __asm_compress11_core_loop:

    ldrsh.w  r4, [r1, # 0]
    ldrsh.w  r5, [r1, # 2]
    ldrsh.w  r6, [r1, # 4]
    ldrsh.w  r7, [r1, # 6]
    ldrsh.w  r8, [r1, # 8]
    ldrsh.w  r9, [r1, #10]
    ldrsh.w r10, [r1, #12]
    ldrsh.w r11, [r1, #14]

    add.w r1, r1, #16

    compress_longx1  r4, r2, r12, 20, 11
    compress_longx1  r5, r2, r12, 20, 11
    compress_longx1  r6, r2, r12, 20, 11
    compress_longx1  r7, r2, r12, 20, 11
    compress_longx1  r8, r2, r12, 20, 11
    compress_longx1  r9, r2, r12, 20, 11
    compress_longx1 r10, r2, r12, 20, 11
    compress_longx1 r11, r2, r12, 20, 11

    orr.w  r4,  r4,  r5, lsl #11
    orr.w  r4,  r4,  r6, lsl #22
    lsr.w  r6,  r6, #10
    orr.w  r6,  r6,  r7, lsl #1
    orr.w  r6,  r6,  r8, lsl #12
    orr.w  r6,  r6,  r9, lsl #23
    lsr.w  r9,  r9, #9
    orr.w  r9,  r9, r10, lsl #2
    orr.w  r9,  r9, r11, lsl #13
    lsr.w r10,  r9, #16


    str.w r6, [r0, #4]
    strh.w r9, [r0, #8]
    strb.w r10, [r0, #10]
    str.w  r4, [r0], #11

    cmp.w r3, r1
    bne.w __asm_compress11_core_loop

    pop.w {r4-r12, pc}
