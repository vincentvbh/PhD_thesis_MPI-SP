

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "tools.h"
#include "naive_mult.h"

#include "hal.h"

uint64_t oldcount, newcount;
char out[128];

#define ITERATIONS 10000

#define K 4

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

// ================

int main(void){

    hal_setup(CLOCK_BENCHMARK);
    hal_send_str("\n============ IGNORE OUTPUT BEFORE THIS LINE ============\n");

    int32_t poly1[ARRAY_N], poly2[ARRAY_N];
    int32_t res[ARRAY_N];

    int32_t poly1_NTT[32 * INNER_N], poly2_NTT[32 * INNER_N];
    int32_t res_NTT[32 * INNER_N];
    int32_t poly_Hom_M[32 * 7 * 8], poly_Hom_V[32 * 7 * 4];
    int32_t res_MV[32 * 7 * 4];
    int32_t acc[4][ARRAY_N];
    int32_t acc_Hom[4][32 * 7 * 4];
    int32_t poly_V[K][32 * 7 * 4];
    int32_t poly_MV[K][32 * 7 * 4];
    int32_t poly_res[K][ARRAY_N];

    hal_send_str("\n============ Nussbaumer + TMVP-TC benchmark ============\n");

    hal_send_str("\n============ Assembly benchmark ============\n");

    oldcount = hal_get_time();
    __asm_TMVP_mul_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "__asm_TMVP_mul_4x4_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TMVP_mla_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "__asm_TMVP_mla_4x4_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TC4_16_full(res, poly1);
    newcount = hal_get_time();
    sprintf(out, "__asm_TC4_16_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TC4_T_16_full(res_NTT, res_MV);
    newcount = hal_get_time();
    sprintf(out, "__asm_TC4_T_16_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iTC4_T_7x7_full(poly_Hom_M, poly2_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iTC4_T_7x7_full cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_Nussbaumer_neg256_0_1_2_3_4(poly1_NTT, poly2_NTT, poly1);
    newcount = hal_get_time();
    sprintf(out, "__asm_Nussbaumer_neg256_0_1_2_3_4 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iNussbaumer_neg256_0_1_2_3(poly1_NTT, poly2_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iNussbaumer_neg256_0_1_2_3 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_iNussbaumer_neg256_4_last(poly1, poly1_NTT);
    newcount = hal_get_time();
    sprintf(out, "__asm_iNussbaumer_neg256_4_last cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    hal_send_str("\n============ Polynomial Multiplication ============\n");

    oldcount = hal_get_time();
    Hom_M(poly_Hom_M, poly2);
    newcount = hal_get_time();
    sprintf(out, "Hom_M cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    Hom_V(poly_Hom_V, poly1);
    newcount = hal_get_time();
    sprintf(out, "Hom_V cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    __asm_TMVP_mul_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    sprintf(out, "BiHom cycles: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    Hom_I(res, res_MV);
    newcount = hal_get_time();
    sprintf(out, "Hom_I cycles: %lld", newcount - oldcount);
    hal_send_str(out);

// ================

    hal_send_str("\n============ Dilithium 2 ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < K; i++){
        __asm_TMVP_mul_4x4_full((int32_t*)&poly_MV[i][0], poly_Hom_M, (int32_t*)&poly_V[i][0]);
    }
    for(size_t i = 0; i < K; i++){
        Hom_I((int32_t*)&poly_res[i][0], (int32_t*)&poly_MV[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "Dilithium 2 c t0 cycles: %lld", newcount - oldcount);
    hal_send_str(out);

// ================

    hal_send_str("\n============ Saber Matrix Vector Multiplication ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 2; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }

    for(size_t i = 0; i < 2; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "lightsaber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 3; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }

    for(size_t i = 0; i < 3; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }
    newcount = hal_get_time();
    sprintf(out, "saber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < 4; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }
    for(size_t i = 0; i < 4; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }

    newcount = hal_get_time();
    sprintf(out, "firesaber matrix-vector product: %lld", newcount - oldcount);
    hal_send_str(out);

// ================
// IP (Enc)

    hal_send_str("\n============ Saber Inner Product (Encrypt) ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "lightsaber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "saber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "firesaber inner product (Enc): %lld", newcount - oldcount);
    hal_send_str(out);

// ================
// IP (Dec)

    hal_send_str("\n============ Saber Inner Product (Decrypt) ============\n");

    oldcount = hal_get_time();
    for(size_t i = 0; i < 2; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "lightsaber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 3; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "saber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

    oldcount = hal_get_time();
    for(size_t i = 0; i < 4; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    sprintf(out, "firesaber inner product (Dec): %lld", newcount - oldcount);
    hal_send_str(out);

}



