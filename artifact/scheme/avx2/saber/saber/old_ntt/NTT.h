#ifndef NTT_H
#define NTT_H

#include "NTT_params.h"
#include "consts256.h"
#include <stdint.h>

typedef struct{
  __attribute__((aligned(32)))
  int16_t coeffs[POLY_N];
} poly;

typedef struct{
  __attribute__((aligned(32)))
  int16_t coeffs[NTT_N];
} nttpoly;

typedef struct{
  poly vec[KEM_K];
} polyvec;

typedef struct{
  nttpoly vec[KEM_K];
} nttpolyvec;

extern
void poly_ntt(nttpoly *r, const poly *a, const int16_t *pdata);

extern
void poly_invntt_tomont(poly *r, const nttpoly *a, const int16_t *pdata);

extern
void poly_basemul_montgomery(nttpoly *r, const nttpoly *a, const nttpoly *b, const int16_t *pdata);

extern
void poly_crt(poly *r, const poly *a, const poly *b);

extern
void polyvec_basemul_acc_montgomery(nttpoly *r, const nttpolyvec *a, const nttpolyvec *b, const int16_t *pdata);

#endif

