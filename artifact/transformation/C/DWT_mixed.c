
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "tools.h"
#include "naive_mult.h"
#include "gen_table.h"
#include "ntt_c.h"

// ================
// This file computes the discrete weighted transformation (DWT) and its inversion for Z_Q[x] / (x^512 + 1)
// via Cooley--Tukey and Gentlemand--Sande FFT.

// ================
// Theory.

// ================
// A small example.

// ================
// Optimization guide.
/*

 See the file DWT_merged_layers.c

*/

// ================
// Applications to lattice-based cryptosystems.
// Generally speaking, DWT is definable for polynomial rings of the form R[x] / (x^n - zeta^n) as long as the following
// hold:
// 1. The positive integer n, encoded as the sum of n copies of the identity of R, is invertible.
// 2. There is a principal n-th root of unity in R. A root of unity w is called a principal n-th root of unity if
//    Phi_n(w) = 0 in R where Phi_n(x) is the n-th cyclotomic polynomial.
// For the DWT to be invertible when R is commutative, we also require zeta to be invertible.
// If R is non-commutative, we ask zeta to commute with all the elements in R (so zeta belongs
// to the center of R by definition).
// When R takes the form Z_Q, the definability of an invertible DWT reduces to
// 1. n | gcd(q_1 - 1, ..., q_d - 1) where Q = prod_i q_i (see [Pol71]).
// 2. zeta must be invertible in R.
// We summarize below real-world examples for the power-of-two-size DWTs.
// 1. Kyber
//    - Polynomial ring: Z_3329[x] / (x^256 + 1).
//    - DWT: Z_3329[x] / (x^256 + 1) with size 128. This transformation is written into the specification of Kyber.
// 2. Dilithium:
//    - Polynomial ring: Z_8380417[x] / (x^256 + 1).
//    - DWT: Z_8380417[x] / (x^256 + 1) with size 256. This transformation is written into the specification of Dilithium.
// 3. Saber:
//    - Polynomial ring: Z_8192[x] / (x^256 + 1) where one of the input polynomials has small coefficients.
//    - DWT:
//      (a) Z_25166081[x] / (x^256 + 1) ([CHK+21]).
//      (b) Z_20972417[x] / (x^256 + 1) ([CHK+21]).
//      (c) Z_{3329 x 7681}[x] / (x^256 + 1) ([ACC+22]).
//      (d) (Z_3329 x Z_7681)[x] / (x^256 + 1) ([ACC+22]).

// ================
// Below are the parameters for this file.
// We demonstrate how to compute products of two polynomials in Z_8380417[x] / (x^256 + 1) with size-256 DWT.
// The DWT is implemented with Cooley--Tukey FFT and its inverse is implemented with Gentleman--Sande FFT.

#define ARRAY_N 256
#define NTT_N 128
#define LOGNTT_N 7

#define Q (3329)

// OMEGA is a principal (2 NTT_N)-th root of unity in Z_Q (OMEGA^NTT_N = -1 in Z_Q since NTT_N is a power of two).
#define OMEGA (17)
#define OMEGA_INV (1175)

// ================
// Z_Q

int16_t mod = Q;

void memberZ(void *des, const void *src){
    cmod_int16(des, src, &mod);
}

void addZ(void *des, const void *src1, const void *src2){
    addmod_int16(des, src1, src2, &mod);
}

void subZ(void *des, const void *src1, const void *src2){
    submod_int16(des, src1, src2, &mod);
}

void mulZ(void *des, const void *src1, const void *src2){
    mulmod_int16(des, src1, src2, &mod);
}

void expZ(void *des, const void *src, size_t e){
    expmod_int16(des, src, e, &mod);
}

struct ring coeff_ring = {
    .sizeZ = sizeof(int16_t),
    .memberZ = memberZ,
    .addZ = addZ,
    .subZ = subZ,
    .mulZ = mulZ,
    .expZ = expZ
};

// ================

int16_t streamlined_NTT_table[NTT_N - 1];

int16_t streamlined_iNTT_table[NTT_N - 1];

int16_t streamlined_twiddle_table[NTT_N];

void CT_4_layer_plain(int16_t *des, const int16_t *src, const int16_t *twiddle_table){

    int16_t buff0[16], buff1[16];
    int16_t t;

    memmove(buff0, src, 16 * sizeof(int16_t));

    for(size_t step = 8, twiddle_i = 0; step > 0; step >>= 1){

        for(size_t i = 0; i < 16; i += 2 * step){
            t = twiddle_table[twiddle_i++];
            for(size_t j = 0; j < step; j++){
                // printf("%zu, %zu, %zu\n", i + j + 0, i + j + step, twiddle_i);
                buff0[i + j + step] *= t;
                buff1[i + j +    0]  = buff0[i + j +    0] + buff0[i + j + step];
                buff1[i + j + step]  = buff0[i + j +    0] - buff0[i + j + step];
                buff0[i + j +    0]  = buff1[i + j +    0];
                buff0[i + j + step]  = buff1[i + j + step];
            }
        }
    }

    memmove(des, buff0, 16 * sizeof(int16_t));

}

void matmul_i16xi16(int16_t *des, const int16_t *src1, const int16_t *src2){

    memset(des, 0, 256 * sizeof(int16_t));

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            for(size_t k = 0; k < 16; k++){
                des[i * 16 + j] += src1[i * 16 + k] * src2[k * 16 + j];
            }
        }
    }

}

void matmul_f32xf32(float *des, const float *src1, const float *src2){

    memset(des, 0, 256 * sizeof(float));

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            for(size_t k = 0; k < 16; k++){
                des[i * 16 + j] += src1[i * 16 + k] * src2[k * 16 + j];
            }
        }
    }

}

void mixed_CT_4_layer(int16_t *des, const int16_t *src, const int16_t *twiddle_table, const size_t len){

    int16_t twiddle_M[16][16];
    float twiddle_M_f[16][16];
    int16_t src_buff_i16[256];
    float src_buff_f32[256];
    int16_t des_buff_i16[256];
    float des_buff_f32[256];
    int16_t zeta, omega;

    if(len < 16){
        return;
    }
    if((len & 0xf)){
        return;
    }

    for(size_t i = 0; i < 16; i++){
        twiddle_M[i][0] = 1;
    }

    //  0,  1,  2,  3,  4,  5,  6,  7,
    //  8,  9, 10, 11, 12, 13, 14, 15,

    //  0,  8,  4, 12,  2, 10,  6, 14,
    //  1,  9,  5, 13,  3, 11,  7, 15

    zeta = twiddle_table[7];
    twiddle_M[0][1] = zeta;
    coeff_ring.expZ(&omega, &zeta, 2);
    coeff_ring.mulZ(&twiddle_M[ 8][1], &twiddle_M[ 0][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 4][1], &twiddle_M[ 8][1], &omega);
    coeff_ring.mulZ(&twiddle_M[12][1], &twiddle_M[ 4][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 2][1], &twiddle_M[12][1], &omega);
    coeff_ring.mulZ(&twiddle_M[10][1], &twiddle_M[ 2][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 6][1], &twiddle_M[10][1], &omega);
    coeff_ring.mulZ(&twiddle_M[14][1], &twiddle_M[ 6][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 1][1], &twiddle_M[14][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 9][1], &twiddle_M[ 1][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 5][1], &twiddle_M[ 9][1], &omega);
    coeff_ring.mulZ(&twiddle_M[13][1], &twiddle_M[ 5][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 3][1], &twiddle_M[13][1], &omega);
    coeff_ring.mulZ(&twiddle_M[11][1], &twiddle_M[ 3][1], &omega);
    coeff_ring.mulZ(&twiddle_M[ 7][1], &twiddle_M[11][1], &omega);
    coeff_ring.mulZ(&twiddle_M[15][1], &twiddle_M[ 7][1], &omega);

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 2; j < 16; j++){
            coeff_ring.mulZ(&twiddle_M[i][j], &twiddle_M[i][j - 1], &twiddle_M[i][1]);
        }
    }

    for(size_t i = 0; i < 16; i++){
        for(size_t j = 0; j < 16; j++){
            twiddle_M_f[i][j] = (float)((double)twiddle_M[i][j] / mod);
        }
    }

    for(size_t i = 0; i < 256; i++){
        src_buff_i16[i] = src[i];
        src_buff_f32[i] = (float)src[i];
    }

    matmul_i16xi16(des_buff_i16, &twiddle_M[0][0], src_buff_i16);
    matmul_f32xf32(des_buff_f32, &twiddle_M_f[0][0], src_buff_f32);

    for(size_t i = 0; i < 256; i++){
        des[i] = des_buff_i16[i] - ((int16_t)des_buff_f32[i]) * mod;
    }

}

int main(void){

    int16_t poly1[ARRAY_N], poly2[ARRAY_N];
    int16_t ref[ARRAY_N], res[ARRAY_N];

    int16_t omega, zeta, twiddle, scale, t;

    for(size_t i = 0; i < ARRAY_N; i++){
        t = rand();
        coeff_ring.memberZ(poly1 + i, &t);
        t = rand();
        coeff_ring.memberZ(poly2 + i, &t);
    }

// ================
// Compute the product in Z_Q[x] / (x^256 + 1).

    twiddle = -1;
    naive_mulR(ref,
        poly1, poly2, ARRAY_N, &twiddle, coeff_ring);

// ================
// Specify the layer-merging strategy.

    struct compress_profile profile = {
        ARRAY_N, NTT_N, LOGNTT_N, LOGNTT_N
    };

    for(size_t i = 0; i < profile.compressed_layers; i++){
        profile.merged_layers[i] = 1;
    }

// ================
// Generate twiddle factors for Cooley--Tukey FFT.

    zeta = OMEGA;
    coeff_ring.expZ(&omega, &zeta, 2);
    scale = 1;
    gen_streamlined_DWT_table(streamlined_twiddle_table,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    // assert(memcmp(streamlined_NTT_table, streamlined_twiddle_table, (NTT_N - 1) * sizeof(int16_t)) == 0);

// ================
// Apply Cooley--Tukey FFT.

    mixed_CT_4_layer(poly1, poly1, streamlined_twiddle_table, ARRAY_N);

    // compressed_CT_NTT(poly1,
    //     0, 3, streamlined_twiddle_table, profile, coeff_ring);
    compressed_CT_NTT(poly1,
        4, 6, streamlined_twiddle_table, profile, coeff_ring);
    compressed_CT_NTT(poly2,
        0, 6, streamlined_twiddle_table, profile, coeff_ring);

// ================

    scale = OMEGA;
    coeff_ring.expZ(&omega, &scale, 2);
    gen_mul_table(streamlined_twiddle_table, &scale, &omega, profile, coeff_ring);

    for(size_t i = 0; i < 256; i += 4){
        twiddle = streamlined_twiddle_table[i / 4];
        naive_mulR(res + i + 0, poly1 + i + 0, poly2 + i + 0, 2, &twiddle, coeff_ring);
        twiddle = -twiddle;
        naive_mulR(res + i + 2, poly1 + i + 2, poly2 + i + 2, 2, &twiddle, coeff_ring);
    }

    // point_mul(res, poly1, poly2, ARRAY_N, 1, coeff_ring);

// ================
// Generate twiddle factors for the inverse via Gentlemans--Sande FFT.

    zeta = OMEGA_INV;
    coeff_ring.expZ(&omega, &zeta, 2);
    scale = 1;
    gen_streamlined_DWT_table(streamlined_twiddle_table,
        &scale, &omega, &zeta, profile, 0, coeff_ring);

    // assert(memcmp(streamlined_iNTT_table, streamlined_twiddle_table, (NTT_N - 1) * sizeof(int16_t)) == 0);

// ================
// Apply Gentleman--Sande FFT.

    compressed_GS_iNTT(res,
        0, 6, streamlined_twiddle_table, profile, coeff_ring);


// ================
// Multiply the scale to reference.

    scale = 128;
    for(size_t i = 0; i < ARRAY_N; i++){
        coeff_ring.mulZ(ref + i, ref + i, &scale);
    }

    for(size_t i = 0; i < ARRAY_N; i++){
        assert(ref[i] == res[i]);
    }

    printf("Test finished!\n");

}








