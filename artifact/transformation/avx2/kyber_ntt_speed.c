
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <immintrin.h>

#include "kyber_consts.h"
#include "cdecl.h"

#include "cycles.h"

#define NTESTS 100000

uint64_t time0, time1;
uint64_t cycles[NTESTS];

extern
void ntt_avx(int16_t*, const int16_t*);

extern
void invntt_avx(int16_t*, const int16_t*);

extern
void basemul_avx(int16_t*, const int16_t*, const int16_t*, const int16_t*);

__attribute__ ((noinline))
void poly_add(int16_t *r, const int16_t *a, const int16_t *b)
{
  unsigned int i;
  __m256i f0, f1;

  for(i=0;i<KYBER_N/16;i++) {
    f0 = _mm256_load_si256((__m256i*)(a + i * 16));
    f1 = _mm256_load_si256((__m256i*)(b + i * 16));
    f0 = _mm256_add_epi16(f0, f1);
    _mm256_store_si256((__m256i*)(r + i * 16), f0);
  }
}

int main(void){

    __attribute__ ((aligned (32))) int16_t a[256], b[256], c[256];

    WRAP_FUNC("poly_add",
            cycles, time0, time1,
            poly_add(c, a, b));

    WRAP_FUNC("ntt_avx",
            cycles, time0, time1,
            ntt_avx(a, qdata));

    WRAP_FUNC("invntt_avx",
            cycles, time0, time1,
            ntt_avx(a, qdata));

    WRAP_FUNC("basemul_avx",
            cycles, time0, time1,
            basemul_avx(c, a, b, qdata));

}

