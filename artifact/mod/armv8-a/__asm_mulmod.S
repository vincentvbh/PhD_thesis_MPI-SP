
#include "cdecl.h"

.align 6
.global cdecl(__asm_montgomery_mul_sub_s_prototype)
cdecl(__asm_montgomery_mul_sub_s_prototype):

    ldr q0, [x3]

    ldr q1, [x1]
    ldr q2, [x2]

    mul     v3.4S, v2.4S, v0.S[2]
    sqdmulh v5.4S, v1.4S, v2.4S
    mul     v4.4S, v1.4S, v3.4S
    sqdmulh v4.4S, v4.4S, v0.S[0]
    shsub   v5.4S, v5.4S, v4.4S

    str q5, [x0]

    ret

.align 6
.global cdecl(__asm_montgomery_mul_sub_pre_s_prototype)
cdecl(__asm_montgomery_mul_sub_pre_s_prototype):

    ldr s0, [x4]

    ldr q1, [x1]
    ldr q2, [x2]
    ldr q3, [x3]

    sqdmulh v5.4S, v1.4S, v2.4S
    mul     v4.4S, v1.4S, v3.4S
    sqdmulh v4.4S, v4.4S, v0.S[0]
    shsub   v5.4S, v5.4S, v4.4S

    str q5, [x0]

    ret

.align 6
.global cdecl(__asm_barrett_mul_pre_s_prototype)
cdecl(__asm_barrett_mul_pre_s_prototype):

    ldr s0, [x4]

    ldr q1, [x1]
    ldr q2, [x2]
    ldr q3, [x3]

    mul       v4.4S,  v1.4S,  v2.4S
    sqrdmulh  v5.4S,  v1.4S,  v3.4S
    mls       v4.4S,  v5.4S,  v0.S[0]

    str q4, [x0]

    ret



