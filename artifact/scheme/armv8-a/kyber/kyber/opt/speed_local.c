#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "indcpa.h"
#include "params.h"
#include "indcpa.h"
#include "poly.h"
#include "polyvec.h"
#include "ntt.h"

#if __APPLE__
#define __AVERAGE__
#define NTESTS 10000
#else
#define __MEDIAN__
#define NTESTS 1000
#endif
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    int16_t A[KYBER_K][KYBER_K][KYBER_N];
    int16_t s[KYBER_K][KYBER_N];
    int16_t s_asymmetric[KYBER_K][KYBER_N];
    int16_t acc[KYBER_K][KYBER_N];

    int16_t poly1[KYBER_K][KYBER_N];

    // Init performance counter
    init_counter();

    WRAP_FUNC("NTT cycles",
              cycles, time0, time1,
              NTT((poly1[0])));

    WRAP_FUNC("NTT_heavy",
              cycles, time0, time1,
              NTT((s[0])); \
              KYBER_AARCH64__asm_point_mul_extended((s_asymmetric[0]), s[0], pre_asymmetric_table_extended, asymmetric_const));

    WRAP_FUNC("point_mul",
              cycles, time0, time1,
              KYBER_AARCH64__asm_point_mul_extended((s_asymmetric[0]), s[0], pre_asymmetric_table_extended, asymmetric_const));

    WRAP_FUNC("asymmetric_mul",
              cycles, time0, time1,
              KYBER_AARCH64__asm_asymmetric_mul(acc[0], poly1[0], s[0], s_asymmetric[0], asymmetric_const));

    WRAP_FUNC("iNTT",
              cycles, time0, time1,
              iNTT(poly1[0]));

    WRAP_FUNC("MatrixVectorMul",
              cycles, time0, time1,
              for (size_t j = 0; j < KYBER_K; j++){ \
                  NTT(s[j]); \
                  KYBER_AARCH64__asm_point_mul_extended(s_asymmetric[j], s[j], pre_asymmetric_table_extended, asymmetric_const); \
              } \
              for (size_t j = 0; j < KYBER_K; j++){ \
                  KYBER_AARCH64__asm_asymmetric_mul(acc[j], A[j][0], s[0], s_asymmetric[0], asymmetric_const); \
              } \
              for (size_t j = 0; j < KYBER_K; j++){ \
                  iNTT(acc[j]); \
              });

    WRAP_FUNC("InnerProd (Enc)",
              cycles, time0, time1,
              KYBER_AARCH64__asm_asymmetric_mul(acc[0], A[0][0], s[0], s_asymmetric[0], asymmetric_const); \
              iNTT(acc[0]));

    WRAP_FUNC("InnerProd (Dec)",
              cycles, time0, time1,
              for (size_t j = 0; j < KYBER_K; j++){ \
                  NTT(s[j]); \
                  KYBER_AARCH64__asm_point_mul_extended(s_asymmetric[j], s[j], pre_asymmetric_table_extended, asymmetric_const); \
              } \
              KYBER_AARCH64__asm_asymmetric_mul(acc[0], A[0][0], s[0], s_asymmetric[0], asymmetric_const); \
              iNTT(acc[0]));

    return 0;

}
