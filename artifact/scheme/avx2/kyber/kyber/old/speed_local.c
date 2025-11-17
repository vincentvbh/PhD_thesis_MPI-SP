#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "poly.h"
#include "polyvec.h"

#define __AVERAGE__
#define NTESTS 10000
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    polyvec A[KYBER_K];
    polyvec s;
    polyvec As;

    WRAP_FUNC("NTT",
              cycles, time0, time1,
              poly_ntt(&s.vec[0]));

    WRAP_FUNC("iNTT",
              cycles, time0, time1,
              poly_invntt_tomont(&s.vec[0]));

    WRAP_FUNC("MatrixVectorMul",
              cycles, time0, time1,
              polyvec_ntt(&s); \
              for(size_t j = 0; j < KYBER_K; j++) \
                  polyvec_basemul_acc_montgomery(&As.vec[j], &A[j], &s); \
              polyvec_invntt_tomont(&As));

    WRAP_FUNC("InnerProd (Enc)",
              cycles, time0, time1,
              polyvec_basemul_acc_montgomery(&As.vec[0], &A[0], &s); \
              poly_invntt_tomont(&As.vec[0]));

    WRAP_FUNC("InnerProd (Dec)",
              cycles, time0, time1,
              polyvec_ntt(&s); \
              polyvec_basemul_acc_montgomery(&As.vec[0], &A[0], &s); \
              poly_invntt_tomont(&As.vec[0]));

    return 0;

}
