#ifndef POLYMUL_H
#define POLYMUL_H

#include "SABER_params.h"
#include <immintrin.h>
#include <stdint.h>

typedef union {
    uint16_t coeffs[SABER_N];
    __m256i dummy;
} poly;

typedef union {
    uint16_t coeffs[4 * SABER_N];
    __m256i dummy;
} toom4_points;

typedef union {
    uint16_t coeffs[8 * SABER_N];
    __m256i dummy;
} toom4_points_product;

void MatrixVectorMul(poly c[SABER_L], const poly A[SABER_L][SABER_L], const toom4_points s_eval[SABER_L], int transpose);

void InnerProd(poly *c, const poly b[SABER_L], const toom4_points s_eval[SABER_L]);

void toom4_interp(poly *res_avx, const toom4_points_product *c_eval);

void toom4_eval(toom4_points *b_eval, const poly *b);

void toom4_mul_A_by_B_eval(toom4_points_product *c_eval, const poly *a_avx, const toom4_points *b_eval, int accumulate);


#endif

