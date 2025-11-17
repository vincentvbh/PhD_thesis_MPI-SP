
#include <immintrin.h>

#include "NTT_params.h"
#include "NTT.h"

static inline __m256i mulmod(const __m256i a, const __m256i b_pinv, const __m256i b, const __m256i p) {
  __m256i t,u;
  t = _mm256_mullo_epi16(a,b_pinv);
  u = _mm256_mulhi_epi16(a,b);
  t = _mm256_mulhi_epi16(t,p);
  t = _mm256_sub_epi16(u,t);
  return t;
}

void poly_crt(poly *r, const poly *a, const poly *b) {
  unsigned int i;
  __m256i f0, f1;
  const __m256i u_pinv = _mm256_set1_epi16(CRT_U_PINV);
  const __m256i u = _mm256_set1_epi16(CRT_U);
  const __m256i p0 = _mm256_load_si256((__m256i *)&PDATA0[_16XP]);
  const __m256i p1 = _mm256_load_si256((__m256i *)&PDATA1[_16XP]);
  const __m256i mod = _mm256_set1_epi16(KEM_Q-1);
  const __m256i mont0_pinv = _mm256_load_si256((__m256i *)&PDATA0[_16XMONT_PINV]);
  const __m256i mont0 = _mm256_load_si256((__m256i *)&PDATA0[_16XMONT]);

  for(i=0;i<KEM_N/16;i++) {
    f0 = _mm256_load_si256((__m256i *)&a->coeffs[16*i]);
    f1 = _mm256_load_si256((__m256i *)&b->coeffs[16*i]);
    f0 = mulmod(f0,mont0_pinv,mont0,p0);  // extra reduction
    f1 = _mm256_sub_epi16(f1,f0);
    f1 = mulmod(f1,u_pinv,u,p1);
    f1 = _mm256_mullo_epi16(f1,p0);
    f0 = _mm256_add_epi16(f0,f1);
    f0 = _mm256_and_si256(f0,mod);
    _mm256_store_si256((__m256i *)&r->coeffs[16*i],f0);
  }
}

