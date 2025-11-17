#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "polymul.h"

#define __AVERAGE__
#define NTESTS 10000
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    uint16_t a[SABER_N], b[SABER_N], ab[SABER_N];
    uint16_t A[SABER_L][SABER_N];

    toom4_points b_eval;
    toom4_points s_eval[SABER_L];
    toom4_points_product ab_eval;

    WRAP_FUNC("polymul",
              cycles, time0, time1,
              toom4_eval(&b_eval, (poly*)b); \
              toom4_mul_A_by_B_eval(&ab_eval, (poly*)a, &b_eval, 0); \
              toom4_interp((poly*)ab, &ab_eval));

    WRAP_FUNC("MatrixVectorMul",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  toom4_eval(&s_eval[j], (poly*)b); \
              } \
              for(size_t j = 0; j < SABER_L; j++){ \
                  for(size_t k = 0; k < SABER_L; k++){ \
                      if(k == 0){ \
                          toom4_mul_A_by_B_eval(&ab_eval, (poly*)A[k], &s_eval[k], 0); \
                      }else{ \
                          toom4_mul_A_by_B_eval(&ab_eval, (poly*)A[k], &s_eval[k], 1); \
                      } \
                  } \
                  toom4_interp((poly*)ab, &ab_eval); \
              });

    WRAP_FUNC("InnerProd (Enc)",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  if(j == 0){
                      toom4_mul_A_by_B_eval(&ab_eval, (poly*)a, &b_eval, 0); \
                  }else{
                      toom4_mul_A_by_B_eval(&ab_eval, (poly*)a, &b_eval, 1); \
                  }
              } \
              toom4_interp((poly*)ab, &ab_eval));

    WRAP_FUNC("InnerProd (Dec)",
              cycles, time0, time1,
              for(size_t j = 0; j < SABER_L; j++){ \
                  toom4_eval(&b_eval, (poly*)b); \
                  if(j == 0){
                      toom4_mul_A_by_B_eval(&ab_eval, (poly*)a, &b_eval, 0); \
                  }else{
                      toom4_mul_A_by_B_eval(&ab_eval, (poly*)a, &b_eval, 1); \
                  }
              } \
              toom4_interp((poly*)ab, &ab_eval));

    return 0;

}
