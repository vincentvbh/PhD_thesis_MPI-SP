#include <stdint.h>
#include <immintrin.h>
#include <string.h>
#include "params.h"
#include "polyvec.h"
#include "poly.h"
#include "ntt.h"
#include "consts.h"

#if (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 320))

static void poly_compress10(uint8_t r[320], const poly * restrict a){

    __m256i a0;
    __m256i p0, p1;
    __m128i lo, hi;

    const __m256i b0 = _mm256_set1_epi16(-20553);
    const __m256i b1 = _mm256_set1_epi16(20);
    const __m256i b2 = _mm256_set1_epi16(1 << 9);
    const __m256i mask10 = _mm256_set1_epi16(0x3ff);
    const __m256i shift = _mm256_set1_epi32((1024 << 16) + 1);
    const __m256i sllv_indx = _mm256_set1_epi64x(12);
    const __m256i shuffle = _mm256_set_epi8( 8,  4,  3,  2,  1,  0, -1, -1,
                                            -1, -1, -1, -1, 12, 11, 10,  9,
                                            -1, -1, -1, -1, -1, -1, 12, 11,
                                            10,  9,  8,  4,  3,  2,  1,  0);

    for(size_t i = 0; i < KYBER_N / 16; i++){
        a0 = _mm256_loadu_si256(&a->vec[i]);

        p0 = _mm256_mulhi_epi16(a0, b0);
        p1 = _mm256_mullo_epi16(a0, b1);
        p0 = _mm256_add_epi16(p0, p1);
        p0 = _mm256_mulhrs_epi16(p0, b2);

        // below are the same as before
        a0 = _mm256_and_si256(p0, mask10);

        a0 = _mm256_madd_epi16(a0, shift);

        a0 = _mm256_sllv_epi32(a0, sllv_indx);
        a0 = _mm256_srli_epi64(a0, 12);

        a0 = _mm256_shuffle_epi8(a0, shuffle);

        lo = _mm256_castsi256_si128(a0);
        hi = _mm256_extracti128_si256(a0, 1);

        lo = _mm_blend_epi16(lo, hi, 0xe0);

        _mm_storeu_si128((__m128i*)(r + i * 20 + 0), lo);
        memcpy(r + i * 20 + 16, &hi, 4);

    }

}

static void poly_decompress10(poly * restrict r, const uint8_t a[320+12])
{
  unsigned int i;
  __m256i f;
  const __m256i q = _mm256_set1_epi32((KYBER_Q << 16) + 4*KYBER_Q);
  const __m256i shufbidx = _mm256_set_epi8(11,10,10, 9, 9, 8, 8, 7,
                                            6, 5, 5, 4, 4, 3, 3, 2,
                                            9, 8, 8, 7, 7, 6, 6, 5,
                                            4, 3, 3, 2, 2, 1, 1, 0);
  const __m256i sllvdidx = _mm256_set1_epi64x(4);
  const __m256i mask = _mm256_set1_epi32((32736 << 16) + 8184);

  for(i=0;i<KYBER_N/16;i++) {
    f = _mm256_loadu_si256((__m256i *)&a[20*i]);
    f = _mm256_permute4x64_epi64(f,0x94);
    f = _mm256_shuffle_epi8(f,shufbidx);
    f = _mm256_sllv_epi32(f,sllvdidx);
    f = _mm256_srli_epi16(f,1);
    f = _mm256_and_si256(f,mask);
    f = _mm256_mulhrs_epi16(f,q);
    _mm256_store_si256(&r->vec[i],f);
  }
}

#elif (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 352))

static void poly_compress11(uint8_t r[352], const poly * restrict a){

    __m256i a0, a1;
    __m256i p0, p1;
    __m128i lo, hi;

    const __m256i b0 = _mm256_set1_epi16(-20553);
    const __m256i b1 = _mm256_set1_epi16(20);
    const __m256i b2 = _mm256_set1_epi16(1 << 10);
    const __m256i mask11 = _mm256_set1_epi16(0x7ff);
    const __m256i shift1 = _mm256_set1_epi32((2048 << 16) + 1);
    const __m256i sllv32_indx = _mm256_set_epi32(0, 10, 0, 10, 0, 10, 0, 10);
    const __m256i srlv64_indx = _mm256_set_epi64x(30, 10, 30, 10);
    const __m256i shuffle = _mm256_set_epi8( 4,  3,  2,  1,  0,  0, -1, -1,
                                            -1, -1, 10,  9,  8,  7,  6,  5,
                                            -1, -1, -1, -1, -1, 10,  9,  8,
                                             7,  6,  5,  4,  3,  2,  1,  0);

    for(size_t i = 0; i < 16; i++){

        a0 = _mm256_loadu_si256(&a->vec[i]);

        p0 = _mm256_mulhi_epi16(a0, b0);
        p1 = _mm256_mullo_epi16(a0, b1);
        p0 = _mm256_add_epi16(p0, p1);
        p0 = _mm256_mulhrs_epi16(p0, b2);

        // below are the same as before
        a0 = _mm256_and_si256(p0, mask11);

        a0 = _mm256_madd_epi16(a0, shift1);

        a0 = _mm256_sllv_epi32(a0, sllv32_indx);
        a1 = _mm256_bsrli_epi128(a0, 8);

        a0 = _mm256_srlv_epi64(a0, srlv64_indx);
        a1 = _mm256_slli_epi64(a1, 34);

        a0 = _mm256_add_epi64(a0, a1);
        a0 = _mm256_shuffle_epi8(a0, shuffle);

        lo = _mm256_castsi256_si128(a0);
        hi = _mm256_extracti128_si256(a0, 1);
        lo = _mm_blendv_epi8(lo, hi, _mm256_castsi256_si128(shuffle));

        _mm_storeu_si128((__m128i*)(r + i * 22 +  0), lo);
        memcpy(r + i * 22 + 16, &hi, 6);

    }

}

static void poly_decompress11(poly * restrict r, const uint8_t a[352+10])
{
  unsigned int i;
  __m256i f;
  const __m256i q = _mm256_load_si256(&qdata.vec[_16XQ/16]);
  const __m256i shufbidx = _mm256_set_epi8(13,12,12,11,10, 9, 9, 8,
                                            8, 7, 6, 5, 5, 4, 4, 3,
                                           10, 9, 9, 8, 7, 6, 6, 5,
                                            5, 4, 3, 2, 2, 1, 1, 0);
  const __m256i srlvdidx = _mm256_set_epi32(0,0,1,0,0,0,1,0);
  const __m256i srlvqidx = _mm256_set_epi64x(2,0,2,0);
  const __m256i shift = _mm256_set_epi16(4,32,1,8,32,1,4,32,4,32,1,8,32,1,4,32);
  const __m256i mask = _mm256_set1_epi16(32752);

  for(i=0;i<KYBER_N/16;i++) {
    f = _mm256_loadu_si256((__m256i *)&a[22*i]);
    f = _mm256_permute4x64_epi64(f,0x94);
    f = _mm256_shuffle_epi8(f,shufbidx);
    f = _mm256_srlv_epi32(f,srlvdidx);
    f = _mm256_srlv_epi64(f,srlvqidx);
    f = _mm256_mullo_epi16(f,shift);
    f = _mm256_srli_epi16(f,1);
    f = _mm256_and_si256(f,mask);
    f = _mm256_mulhrs_epi16(f,q);
    _mm256_store_si256(&r->vec[i],f);
  }
}

#endif

/*************************************************
* Name:        polyvec_compress
*
* Description: Compress and serialize vector of polynomials
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for KYBER_POLYVECCOMPRESSEDBYTES)
*              - polyvec *a: pointer to input vector of polynomials
**************************************************/
void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES+2], const polyvec *a)
{
  unsigned int i;

#if (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 320))
  for(i=0;i<KYBER_K;i++)
    poly_compress10(&r[320*i],&a->vec[i]);
#elif (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 352))
  for(i=0;i<KYBER_K;i++)
    poly_compress11(&r[352*i],&a->vec[i]);
#endif
}

/*************************************************
* Name:        polyvec_decompress
*
* Description: De-serialize and decompress vector of polynomials;
*              approximate inverse of polyvec_compress
*
* Arguments:   - polyvec *r: pointer to output vector of polynomials
*              - const uint8_t *a: pointer to input byte array
*                                  (of length KYBER_POLYVECCOMPRESSEDBYTES)
**************************************************/
void polyvec_decompress(polyvec *r, const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES+12])
{
  unsigned int i;

#if (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 320))
  for(i=0;i<KYBER_K;i++)
    poly_decompress10(&r->vec[i],&a[320*i]);
#elif (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 352))
  for(i=0;i<KYBER_K;i++)
    poly_decompress11(&r->vec[i],&a[352*i]);
#endif
}

/*************************************************
* Name:        polyvec_tobytes
*
* Description: Serialize vector of polynomials
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for KYBER_POLYVECBYTES)
*              - polyvec *a: pointer to input vector of polynomials
**************************************************/
void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], const polyvec *a)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_tobytes(r+i*KYBER_POLYBYTES, &a->vec[i]);
}

/*************************************************
* Name:        polyvec_frombytes
*
* Description: De-serialize vector of polynomials;
*              inverse of polyvec_tobytes
*
* Arguments:   - uint8_t *r: pointer to output byte array
*              - const polyvec *a: pointer to input vector of polynomials
*                                  (of length KYBER_POLYVECBYTES)
**************************************************/
void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES])
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_frombytes(&r->vec[i], a+i*KYBER_POLYBYTES);
}

/*************************************************
* Name:        polyvec_ntt
*
* Description: Apply forward NTT to all elements of a vector of polynomials
*
* Arguments:   - polyvec *r: pointer to in/output vector of polynomials
**************************************************/
void polyvec_ntt(polyvec *r)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_ntt(&r->vec[i]);
}

/*************************************************
* Name:        polyvec_invntt_tomont
*
* Description: Apply inverse NTT to all elements of a vector of polynomials
*              and multiply by Montgomery factor 2^16
*
* Arguments:   - polyvec *r: pointer to in/output vector of polynomials
**************************************************/
void polyvec_invntt_tomont(polyvec *r)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_invntt_tomont(&r->vec[i]);
}

/*************************************************
* Name:        polyvec_basemul_acc_montgomery
*
* Description: Multiply elements in a and b in NTT domain, accumulate into r,
*              and multiply by 2^-16.
*
* Arguments: - poly *r: pointer to output polynomial
*            - const polyvec *a: pointer to first input vector of polynomials
*            - const polyvec *b: pointer to second input vector of polynomials
**************************************************/
void polyvec_basemul_acc_montgomery(poly *r, const polyvec *a, const polyvec *b)
{
  unsigned int i;
  poly tmp;

  poly_basemul_montgomery(r,&a->vec[0],&b->vec[0]);
  for(i=1;i<KYBER_K;i++) {
    poly_basemul_montgomery(&tmp,&a->vec[i],&b->vec[i]);
    poly_add(r,r,&tmp);
  }
}

/*************************************************
* Name:        polyvec_reduce
*
* Description: Applies Barrett reduction to each coefficient
*              of each element of a vector of polynomials;
*              for details of the Barrett reduction see comments in reduce.c
*
* Arguments:   - polyvec *r: pointer to input/output polynomial
**************************************************/
void polyvec_reduce(polyvec *r)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_reduce(&r->vec[i]);
}

void polyvec_round_reduce(polyvec *r)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_round_reduce(&r->vec[i]);
}

/*************************************************
* Name:        polyvec_add
*
* Description: Add vectors of polynomials
*
* Arguments: - polyvec *r:       pointer to output vector of polynomials
*            - const polyvec *a: pointer to first input vector of polynomials
*            - const polyvec *b: pointer to second input vector of polynomials
**************************************************/
void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_add(&r->vec[i], &a->vec[i], &b->vec[i]);
}
