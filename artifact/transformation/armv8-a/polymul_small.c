
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <arm_neon.h>

#include "tools.h"
#include "naive_mult.h"

extern void __asm_trn8x8_prototype(int16_t *des, const int16_t *src);

// iter must even
extern void __asm_trn8x8_full(int16_t *des, const int16_t *src, const size_t iter);

extern void __asm_Karatsuba8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Karatsuba_negacyclic8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Toeplitz_negacyclic8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

// iter must be even > 0
extern void __asm_Toeplitz_negacyclic8_Z65536_flexible(int16_t *c, const int16_t *a, const int16_t *b,
                                                       const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

// iter must be even > 0
extern void __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible(int16_t *c, const int16_t *a, const int16_t *b,
                                                                  const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_CT_cyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);

extern void __asm_Toeplitz_negacyclic8_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
// iter must be even > 0
extern void __asm_Toeplitz_negacyclic8_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_CT_cyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_CT_cyclic16_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                const size_t next_bytes, size_t iter);
extern void __asm_Toeplitz_negacyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                           const size_t next_bytes, size_t iter);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                                    const size_t next_bytes, size_t iter);

#define ARRAY_N 2048
#define VECN 8

#define MASK (0x3ff)

// ================
// Z_{2^16}

void memberZ65536(void *des, const void *src){
    *(int16_t*)des = *(int16_t*)src;
}

void addZ65536(void *des, const void *src1, const void *src2){
    *(int16_t*)des = (*(int16_t*)src1) + (*(int16_t*)src2);
}

void subZ65536(void *des, const void *src1, const void *src2){
    *(int16_t*)des = (*(int16_t*)src1) - (*(int16_t*)src2);
}

void mulZ65536(void *des, const void *src1, const void *src2){
    *(int16_t*)des = (*(int16_t*)src1) * (*(int16_t*)src2);
}

void expZ65536(void *des, const void *src, size_t e){

    int16_t src_v = *(int16_t*)src;
    int16_t tmp_v;

    tmp_v = 1;
    for(; e; e >>= 1){
        if(e & 1){
            tmp_v = tmp_v * src_v;
        }
        src_v = src_v * src_v;
    }

    memmove(des, &tmp_v, sizeof(int16_t));
}

struct ring ringZ65536 = {
    .sizeZ = sizeof(int16_t),
    .memberZ = memberZ65536,
    .addZ = addZ65536,
    .subZ = subZ65536,
    .mulZ = mulZ65536,
    .expZ = expZ65536
};

// ================
// Z_Q

#define Q 4591

// R = 65536 below
// R mod Q
#define RmodQ (1262)
// -Q^{-1} mod R
#define Qprime (-15631)

int16_t mod = Q;

void member_h(void *des, const void *src){
    cmod_int16(des, src, &mod);
}

void add_h(void *des, const void *src1, const void *src2){
    addmod_int16(des, src1, src2, &mod);
}

void sub_h(void *des, const void *src1, const void *src2){
    submod_int16(des, src1, src2, &mod);
}

void mul_h(void *des, const void *src1, const void *src2){
    mulmod_int16(des, src1, src2, &mod);
}

void exp_h(void *des, const void *src, size_t e){
    expmod_int16(des, src, e, &mod);
}

struct ring ring_h = {
    .sizeZ = sizeof(int16_t),
    .memberZ = member_h,
    .addZ = add_h,
    .subZ = sub_h,
    .mulZ = mul_h,
    .expZ = exp_h
};

static const int16_t constants[8] = {
Q, Qprime
};

void insert_lane(int16_t *aNeon, const int16_t *a, const size_t n, const size_t lane_i){
    for(size_t i = 0; i < n; i++){
        aNeon[i * VECN + lane_i] = a[i];
    }
}

void extract_lane(int16_t *a, const int16_t *aNeon, const size_t n, const size_t lane_i){
    for(size_t i = 0; i < n; i++){
        a[i] = aNeon[i * VECN + lane_i];
    }
}

int main(void){

    int16_t a[ARRAY_N], b[ARRAY_N ];
    int16_t aNeon[ARRAY_N], bNeon[ARRAY_N ];
    int16_t ref[2 * ARRAY_N], res[2 * ARRAY_N ];
    int16_t resNeon[2 * ARRAY_N];

    int16_t scale, twiddle, t;

// ================================
// Z65536

    printf("Z65536\n");

// ================
// size-8 polynomial multiplication

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    naive_mul_long(ref, a, b, 8, ringZ65536);

    __asm_trn8x8_prototype(aNeon, a);
    __asm_trn8x8_prototype(bNeon, b);
    __asm_Karatsuba8x8_Z65536_prototype(resNeon, aNeon, bNeon);
    extract_lane(res, resNeon, 15, 0);

    assert(memcmp(ref, res, 15 * sizeof(int16_t)) == 0);

    printf("Karatsuba long Z65536 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 8, &twiddle, ringZ65536);

    __asm_trn8x8_prototype(aNeon, a);
    __asm_trn8x8_prototype(bNeon, b);
    __asm_Karatsuba_negacyclic8x8_Z65536_prototype(resNeon, aNeon, bNeon);
    __asm_trn8x8_prototype(res, resNeon);

    assert(memcmp(ref, res, 8 * sizeof(int16_t)) == 0);

    printf("Karatsuba negacyclic Z65536 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 8, &twiddle, ringZ65536);

    __asm_trn8x8_prototype(aNeon, a);
    __asm_trn8x8_prototype(bNeon, b);
    __asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype(resNeon, aNeon, bNeon);
    __asm_trn8x8_prototype(res, resNeon);

    assert(memcmp(ref, res, 8 * sizeof(int16_t)) == 0);

    printf("Karatsuba striding negacyclic Z65536 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 8){
        naive_mulR(ref + i, a + i, b + i, 8, &twiddle, ringZ65536);
    }

    __asm_trn8x8_full(aNeon, a, ARRAY_N / 64);
    __asm_trn8x8_full(bNeon, b, ARRAY_N / 64);
    for(size_t i = 0; i < ARRAY_N; i += 64){
        __asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype(resNeon + i, aNeon + i, bNeon + i);
    }
    __asm_trn8x8_full(res, resNeon, ARRAY_N / 64);

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("Full Karatsuba striding negacyclic Z65536 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 8, &twiddle, ringZ65536);

    __asm_Toeplitz_negacyclic8_Z65536_prototype(res, a, b);

    assert(memcmp(ref, res, 8 * sizeof(int16_t)) == 0);

    printf("Toeplitz negacyclic Z65536 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 8){
        naive_mulR(ref + i, a + i, b + i, 8, &twiddle, ringZ65536);
    }

    __asm_Toeplitz_negacyclic8_Z65536_flexible(res, a, b, 8 * sizeof(int16_t), ARRAY_N / 8);

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("256 Toeplitz negacyclic Z65536 8 finished!\n");

// ================
// size-16 polynomial multiplication

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 16, &twiddle, ringZ65536);

    __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype(res, a, b);

    assert(memcmp(ref, res, 16 * sizeof(int16_t)) == 0);

    printf("Toeplitz-Karatsuba negacyclic Z65536 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 16){
        naive_mulR(ref + i, a + i, b + i, 16, &twiddle, ringZ65536);
    }

    __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible(res, a, b, 16 * sizeof(int16_t), ARRAY_N / 16);

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("128 Toeplitz-Karatsuba negacyclic Z65536 16 finished!\n");

// ========

// ================================
// Z_Q

    printf("Z_Q\n");

// ================
// size-8 polynomial multiplication

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 8, &twiddle, ring_h);

    __asm_Toeplitz_negacyclic8_prototype(res, a, b, constants);

    scale = RmodQ;
    for(size_t i = 0; i < 8; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, 8 * sizeof(int16_t)) == 0);

    printf("Toeplitz negacyclic 8 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 8){
        naive_mulR(ref + i, a + i, b + i, 8, &twiddle, ring_h);
    }

    __asm_Toeplitz_negacyclic8_flexible(res, a, b, constants, 8 * sizeof(int16_t), ARRAY_N / 8);

    scale = RmodQ;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("256 Toeplitz negacyclic 8 finished!\n");

// ================
// size-16 polynomial multiplication

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = 1;
    naive_mulR(ref, a, b, 16, &twiddle, ring_h);

    __asm_Toeplitz_CT_cyclic16_prototype(res, a, b, constants);

    scale = RmodQ;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    scale = 2;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(ref + i, ref + i, &scale);
    }

    assert(memcmp(ref, res, 16 * sizeof(int16_t)) == 0);

    printf("Toeplitz CT cyclic 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = 1;
    for(size_t i = 0; i < ARRAY_N; i += 16){
        naive_mulR(ref + i, a + i, b + i, 16, &twiddle, ring_h);
    }

    __asm_Toeplitz_CT_cyclic16_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16);

    scale = RmodQ;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    scale = 2;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(ref + i, ref + i, &scale);
    }

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("128 Toeplitz CT cyclic 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 16, &twiddle, ring_h);

    __asm_Toeplitz_negacyclic16_prototype(res, a, b, constants);

    scale = RmodQ;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, 16 * sizeof(int16_t)) == 0);

    printf("Toeplitz negacyclic 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 16, &twiddle, ring_h);

    __asm_Toeplitz_Karatsuba_negacyclic16_prototype(res, a, b, constants);

    scale = RmodQ;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, 16 * sizeof(int16_t)) == 0);

    printf("Toeplitz Karatsuba negacyclic 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 16){
        naive_mulR(ref + i, a + i, b + i, 16, &twiddle, ring_h);
    }

    __asm_Toeplitz_Karatsuba_negacyclic16_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16);

    scale = RmodQ;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("128 Toeplitz Karatsuba negacyclic 16 finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    naive_mulR(ref, a, b, 16, &twiddle, ring_h);

    __asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype(res, a, b, constants);

    scale = RmodQ;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    scale = 2;
    for(size_t i = 0; i < 16; i++){
        ring_h.mulZ(ref + i, ref + i, &scale);
    }

    assert(memcmp(ref, res, 16 * sizeof(int16_t)) == 0);

    printf("Toeplitz Karatsuba negacyclic 16 with doubling finished!\n");

// ========

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        ring_h.memberZ(a + i, &t);
        t = rand();
        ring_h.memberZ(b + i, &t);
    }

    twiddle = -1;
    for(size_t i = 0; i < ARRAY_N; i += 16){
        naive_mulR(ref + i, a + i, b + i, 16, &twiddle, ring_h);
    }

    __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16);

    scale = RmodQ;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(res + i, res + i, &scale);
    }

    scale = 2;
    for(size_t i = 0; i < ARRAY_N; i++){
        ring_h.mulZ(ref + i, ref + i, &scale);
    }

    assert(memcmp(ref, res, ARRAY_N * sizeof(int16_t)) == 0);

    printf("128 Toeplitz Karatsuba negacyclic 16 with doubling finished!\n");

// ========

    printf("Test finished!\n");

}




