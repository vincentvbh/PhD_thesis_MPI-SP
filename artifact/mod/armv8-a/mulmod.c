
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "tools.h"

// R = 2^32 below
#define DILITHIUM_Q 8380417
// RmodQ = R mod^+- Q
#define DILITHIUM_RmodQ (-4186625)
// Qprime = -Q^{-1} mod^+- R
#define DILITHIUM_Qprime (-58728449)

#define NTESTS 1000

// ================
// Definition of Z_Q with signed arithmetic.
// See "tools.h" for explanations.

int32_t mod = DILITHIUM_Q;

void memberZ_s(void *des, const void *src){
    cmod_int32(des, src, &mod);
}

void addZ_s(void *des, const void *src1, const void *src2){
    addmod_int32(des, src1, src2, &mod);
}

void subZ_s(void *des, const void *src1, const void *src2){
    submod_int32(des, src1, src2, &mod);
}

void mulZ_s(void *des, const void *src1, const void *src2){
    mulmod_int32(des, src1, src2, &mod);
}

void expZ_s(void *des, const void *src, size_t e){
    expmod_int32(des, src, e, &mod);
}

struct ring ring_s = {
    .sizeZ = sizeof(int32_t),
    .memberZ = memberZ_s,
    .addZ = addZ_s,
    .subZ = subZ_s,
    .mulZ = mulZ_s,
    .expZ = expZ_s
};

const int32_t DILITHIUM_constants[8] = {
DILITHIUM_Q, DILITHIUM_Qprime, -DILITHIUM_Qprime
};

#define VECN 4

extern
void __asm_montgomery_mul_sub_s_prototype(int32_t *c, const int32_t *a, const int32_t *b, const int32_t *_constants);

extern
void __asm_montgomery_mul_sub_pre_s_prototype(int32_t *c, const int32_t *a, const int32_t *bp, const int32_t *bpp, const int32_t *_constants);

extern
void __asm_barrett_mul_pre_s_prototype(int32_t *c, const int32_t *a, const int32_t *b, const int32_t *bp, const int32_t *_constants);

void montgomery_sub_precompute(int32_t *ap, int32_t *app, const int32_t a, const int32_t Qprime, const int32_t RmodQ, struct ring _ring_s){
    _ring_s.mulZ(ap, &a, &RmodQ);
    *app = *ap * -Qprime;
}

int32_t barrett_precompute(int32_t a, const int32_t Q, const int32_t Qprime, const int32_t RmodQ, struct ring _ring_s){

    int32_t t;

    _ring_s.mulZ(&t, &a, &RmodQ);

    if(( t & 1) == 0){
        if(t < 0){
            t += Q;
        }
        if(t > 0){
            t -= Q;
        }
    }

    t *= Qprime;
    t >>= 1;

    return t;

}

int main(void){

    int32_t a[VECN], b[VECN], bp[VECN], bpp[VECN];
    int32_t ref[VECN], res[VECN];

    int32_t scale, t;

    for(size_t i = 0; i < VECN; i++){
        t = rand();
        ring_s.memberZ(a + i, &t);
        t = rand();
        ring_s.memberZ(b + i, &t);
    }

// ================

    for(size_t i = 0; i < VECN; i++){
        ring_s.mulZ(ref + i, a + i, b + i);
    }

    __asm_montgomery_mul_sub_s_prototype(res, a, b, DILITHIUM_constants);

    scale = DILITHIUM_RmodQ;
    for(size_t i = 0; i < VECN; i++){
        ring_s.mulZ(res + i, res + i, &scale);
    }

    assert(memcmp(ref, res, VECN * sizeof(int32_t)) == 0);

    printf("Subtractive Montgomery multiplication finished!\n");

// ========

    for(size_t i = 0; i < VECN; i++){
        ring_s.mulZ(ref + i, a + i, b + i);
        montgomery_sub_precompute(bp + i, bpp + i, b[i], DILITHIUM_Qprime, DILITHIUM_RmodQ, ring_s);
    }

    __asm_montgomery_mul_sub_pre_s_prototype(res, a, bp, bpp, DILITHIUM_constants);

    for(size_t i = 0; i < VECN; i++){
        ring_s.memberZ(res + i, res + i);
    }

    assert(memcmp(ref, res, VECN * sizeof(int32_t)) == 0);

    printf("Subtractive Montgomery multiplication with precomputation finished!\n");

// ========

    for(size_t i = 0; i < VECN; i++){
        ring_s.mulZ(ref + i, a + i, b + i);
        bp[i] = barrett_precompute(b[i], DILITHIUM_Q, DILITHIUM_Qprime, DILITHIUM_RmodQ, ring_s);
    }

    __asm_barrett_mul_pre_s_prototype(res, a, b, bp, DILITHIUM_constants);

    for(size_t i = 0; i < VECN; i++){
        ring_s.memberZ(res + i, res + i);
    }

    assert(memcmp(ref, res, VECN * sizeof(int32_t)) == 0);

    printf("Barrett multiplication with precomputation finished!\n");

// ================

    printf("Test finished!\n");

}








