
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"

#include "hal.h"

char out[128];

#define ARRAY_N 256
#define INNER_N 16

#define Q (1 << 19)
#define COEFF_SIZE (sizeof(int32_t))

int32_t mod = Q;

void memberZ(void *des, const void *src){
    *(int32_t*)des = *(const int32_t*)src;
}

void addZ(void *des, const void *src1, const void *src2){
    *(int32_t*)des = (*(const int32_t*)src1) + (*(const int32_t*)src2);
}

void subZ(void *des, const void *src1, const void *src2){
    *(int32_t*)des = (*(const int32_t*)src1) - (*(const int32_t*)src2);
}

void mulZ(void *des, const void *src1, const void *src2){
    *(int32_t*)des = (*(const int32_t*)src1) * (*(const int32_t*)src2);
}

void expZ(void *des, const void *src, size_t e){

    int32_t src_v = *(const int32_t*)src;
    int32_t tmp_v;

    tmp_v = 1;
    for(; e; e >>= 1){
        if(e & 1){
            tmp_v = tmp_v * src_v;
        }
        src_v = src_v * src_v;
    }

    memmove(des, &tmp_v, sizeof(int32_t));
}

struct ring coeff_ring = {
    .sizeZ = sizeof(int32_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

void memberZ_negacyclic(void *des, const void *src){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.memberZ(des + i * COEFF_SIZE, src + i * COEFF_SIZE);
    }
}

void addZ_negacyclic(void *des, const void *src1, const void *src2){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.addZ(des + i * COEFF_SIZE, src1 + i * COEFF_SIZE, src2 + i * COEFF_SIZE);
    }
}

void subZ_negacyclic(void *des, const void *src1, const void *src2){
    for(size_t i = 0; i < INNER_N; i++){
        coeff_ring.subZ(des + i * COEFF_SIZE, src1 + i * COEFF_SIZE, src2 + i * COEFF_SIZE);
    }
}

void mulZ_negacyclic(void *des, const void *src1, const void *src2){
    int32_t twiddle = -1;
    naive_mulR(des, src1, src2, INNER_N, &twiddle, coeff_ring);
}

void expZ_negacyclic(void *des, const void *src, size_t e){

    int32_t src_v[INNER_N];
    int32_t tmp_v[INNER_N];
    int32_t twiddle = -1;

    memmove(src_v, src, INNER_N * coeff_ring.sizeZ);

    memset(tmp_v, 0, INNER_N * coeff_ring.sizeZ);
    tmp_v[0] = 1;

    for(; e; e >>= 1){
        if(e & 1){
            naive_mulR(tmp_v, tmp_v, src_v, INNER_N, &twiddle, coeff_ring);
        }
        naive_mulR(src_v, src_v, src_v, INNER_N, &twiddle, coeff_ring);
    }

    memmove(des, tmp_v, INNER_N * coeff_ring.sizeZ);
}

struct ring negacyclic_ring = {
    .sizeZ = COEFF_SIZE * INNER_N,
    .memberZ = memberZ_negacyclic,
    .addZ = addZ_negacyclic,
    .subZ = subZ_negacyclic,
    .mulZ = mulZ_negacyclic,
    .expZ = expZ_negacyclic
};

extern
void __asm_Nussbaumer_neg256_0_1_2_3_4(int32_t*, int32_t*, int32_t*);

extern
void __asm_iNussbaumer_neg256_0_1_2_3(int32_t*, int32_t*);

extern
void __asm_iNussbaumer_neg256_4_last(int32_t*, int32_t*);

extern
void __asm_TC4_16_full(int32_t*, int32_t*);

extern
void __asm_TC4_T_16_full(int32_t*, int32_t*);

extern
void __asm_iTC4_T_7x7_full(int32_t*, int32_t*);

extern
void __asm_TMVP_mul_4x4_full(int32_t*, int32_t*, int32_t*);

extern
void __asm_TMVP_mla_4x4_full(int32_t*, int32_t*, int32_t*);

void Hom_M(int32_t *src_Hom_M, int32_t *src){

    int32_t src_NTT[32 * INNER_N];
    int32_t buff_NTT[32 * INNER_N];

    __asm_Nussbaumer_neg256_0_1_2_3_4(src_NTT, buff_NTT, src);
    __asm_iTC4_T_7x7_full(src_Hom_M, src_NTT);

}

void Hom_V(int32_t *src_Hom_V, int32_t *src){

    int32_t src_NTT[32 * INNER_N];
    int32_t buff_NTT[32 * INNER_N];

    __asm_Nussbaumer_neg256_0_1_2_3_4(src_NTT, buff_NTT, src);
    __asm_TC4_16_full(src_Hom_V, src_NTT);

}

void Hom_I(int32_t *des, int32_t *src){

    int32_t buff_NTT[32 * INNER_N];
    int32_t des_NTT[32 * INNER_N];

    __asm_TC4_T_16_full(buff_NTT, src);
    __asm_iNussbaumer_neg256_0_1_2_3(des_NTT, buff_NTT);
    __asm_iNussbaumer_neg256_4_last(des, des_NTT);

}

int main(void){

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t poly_Hom_M[32][7][8];
    int32_t poly_Hom_V[32][7][4];
    int32_t res_MV[32][7][4];
    int32_t ref[ARRAY_N], res[ARRAY_N];

    int32_t twiddle, t;

    hal_setup(CLOCK_FAST);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        cmod_int32(poly1 + i, &t, &mod);
        t = rand();
        cmod_int32(poly2 + i, &t, &mod);
    }

    twiddle = -1;
    naive_mulR(ref, poly1, poly2, ARRAY_N, &twiddle, coeff_ring);
    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(ref + i, ref + i, &mod);
    }

    Hom_M((int32_t*)&poly_Hom_M[0][0][0], poly2);
    Hom_V((int32_t*)&poly_Hom_V[0][0][0], poly1);
    __asm_TMVP_mul_4x4_full((int32_t*)&res_MV[0][0][0], (int32_t*)&poly_Hom_M[0][0][0], (int32_t*)&poly_Hom_V[0][0][0]);
    Hom_I(res, (int32_t*)&res_MV[0][0][0]);

    for(size_t i = 0; i < ARRAY_N; i++){
        cmod_int32(res + i, res + i, &mod);
    }

    for(size_t i = 0; i < ARRAY_N; i++){
        if(ref[i] != res[i]){
            sprintf(out, "%4zu: %12lx, %12lx\n", i, ref[i], res[i]);
            hal_send_str(out);
        }
    }

    hal_send_str("Test finished!\n");

}






