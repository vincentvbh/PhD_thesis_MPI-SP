#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "sign.h"
#include "poly.h"
#include "polyvec.h"

#define __AVERAGE__
#define NTESTS 10000
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    polyvecl A[K];
    polyvecl s;
    polyveck As;

    WRAP_FUNC("NTT",
              cycles, time0, time1,
              poly_ntt(&s.vec[0]));

    WRAP_FUNC("iNTT",
              cycles, time0, time1,
              poly_invntt_tomont(&s.vec[0]));

    WRAP_FUNC("Inner product NTT L",
              cycles, time0, time1,
              polyvecl_pointwise_acc_montgomery(&As.vec[0], &A[0], &s));

    WRAP_FUNC("MatrixVectorMul",
              cycles, time0, time1,
              polyvecl_ntt(&s); \
              for(size_t j = 0; j < K; j++) \
                  polyvecl_pointwise_acc_montgomery(&As.vec[j], &A[j], &s); \
              polyveck_invntt_tomont(&As));

    return 0;

}
