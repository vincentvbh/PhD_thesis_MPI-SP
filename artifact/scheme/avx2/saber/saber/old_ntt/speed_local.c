#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "poly.h"
#include "NTT.h"

#define __AVERAGE__
#define NTESTS 10000
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    poly a;
    nttpoly a_hat0;
    nttpolyvec s_hat0, s_hat1;
    nttpolyvec A_hat0, A_hat1;
    nttpoly acc_hat0, acc_hat1;

    uint16_t acc[SABER_N];


    WRAP_FUNC("NTT",
              cycles, time0, time1,
              poly_ntt(&a_hat0, &a, PDATA0));

    WRAP_FUNC("iNTT",
              cycles, time0, time1,
              poly_invntt_tomont(&a, &a_hat0, PDATA0));

    WRAP_FUNC("Inner Prod NTT",
              cycles, time0, time1,
              polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0));

    WRAP_FUNC("MatrixVectorMul",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  poly_reduce((uint16_t*)a.coeffs, (uint16_t*)a.coeffs); \
                  poly_ntt(&s_hat0.vec[j], &a, PDATA0); \
                  poly_ntt(&s_hat1.vec[j], &a, PDATA1); \
              } \
              for(size_t j = 0; j < SABER_L; j++){ \
                  for(size_t k = 0; k < SABER_L; k++){ \
                      poly_reduce((uint16_t*)a.coeffs, (uint16_t*)a.coeffs); \
                      poly_ntt(&A_hat0.vec[k], &a, PDATA0); \
                      poly_ntt(&A_hat1.vec[k], &a, PDATA1); \
                  } \
                  polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0); \
                  polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1); \
                  poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0); \
                  poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1); \
                  poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1); \
              });

    WRAP_FUNC("InnerProd (Enc)",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  poly_reduce((uint16_t*)a.coeffs, (uint16_t*)a.coeffs); \
                  poly_ntt(&A_hat0.vec[j], &a, PDATA0); \
                  poly_ntt(&A_hat1.vec[j], &a, PDATA1); \
              } \
              polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0); \
              polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1); \
              poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0); \
              poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1); \
              poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1));

    WRAP_FUNC("InnerProd (Dec)",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  poly_reduce((uint16_t*)a.coeffs, (uint16_t*)a.coeffs); \
                  poly_ntt(&s_hat0.vec[j], &a, PDATA0); \
                  poly_ntt(&s_hat1.vec[j], &a, PDATA1); \
              } \
              for(size_t j = 0; j < SABER_L; j++){ \
                  poly_reduce((uint16_t*)a.coeffs, (uint16_t*)a.coeffs); \
                  poly_ntt(&A_hat0.vec[j], &a, PDATA0); \
                  poly_ntt(&A_hat1.vec[j], &a, PDATA1); \
              } \
              polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0); \
              polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1); \
              poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0); \
              poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1); \
              poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1));


    return 0;

}
