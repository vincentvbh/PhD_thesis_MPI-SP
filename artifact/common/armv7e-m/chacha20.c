/* Based on the public domain implemntation in
 * crypto_stream/chacha20/e/ref from http://bench.cr.yp.to/supercop.html
 * by Daniel J. Bernstein */

#include <stdint.h>
#include "chacha20.h"

#include <stddef.h>

#define ROUNDS 20

typedef uint32_t uint32;

static inline uint32 load_littleendian(const unsigned char *x)
{
  return *((uint32_t*)x);
}

static inline void store_littleendian(unsigned char *x,uint32 u)
{
  *((uint32_t*)x) = u;
}

static inline uint32 rotate(uint32 a, int d)
{
  return (a << d) | (a >> (32 - d));
}

static void quarterround(uint32_t *ptr_a, uint32_t *ptr_b, uint32_t *ptr_c, uint32_t *ptr_d)
{
  uint32_t a, b, c, d;
  a = *ptr_a;
  b = *ptr_b;
  c = *ptr_c;
  d = *ptr_d;

  a = a + b;
  d = d ^ a;
  d = rotate(d, 16);

  c = c + d;
  b = b ^ c;
  b = rotate(b, 12);

  a = a + b;
  d = d ^ a;
  d = rotate(d, 8);

  c = c + d;
  b = b ^ c;
  b = rotate(b, 7);

  *ptr_a = a;
  *ptr_b = b;
  *ptr_c = c;
  *ptr_d = d;

}

// __m128i rot16 = _mm_set_epi8(13,12,15,14,9,8,11,10,5,4,7,6,1,0,3,2);
// __m128i rot8  = _mm_set_epi8(14,13,12,15,10,9,8,11,6,5,4,7,2,1,0,3);

// static void quarterroundx4(__m128i *ptr_a, __m128i *ptr_b, __m128i *ptr_c, __m128i *ptr_d){

//   __m128i a, b, c, d;
//   a = *ptr_a;
//   b = *ptr_b;
//   c = *ptr_c;
//   d = *ptr_d;

//   a = _mm_add_epi32(a, b);
//   d = _mm_xor_si128(d, a);
//   d = _mm_shuffle_epi8(d, rot16);

//   c = _mm_add_epi32(c, d);
//   b = _mm_xor_si128(b, c);
//   b = _mm_or_si128(_mm_slli_epi32(c, 12), _mm_srli_epi32(c, 20));

//   a = _mm_add_epi32(a, b);
//   d = _mm_xor_si128(d, a);
//   d = _mm_shuffle_epi8(d, rot8);

//   c = _mm_add_epi32(c, d);
//   b = _mm_xor_si128(b, c);
//   b = _mm_or_si128(_mm_slli_epi32(b, 7), _mm_srli_epi32(b, 25));

//   *ptr_a = a;
//   *ptr_b = b;
//   *ptr_c = c;
//   *ptr_d = d;
// }

static int crypto_core_chacha20(
        unsigned char *out,
  const unsigned char *in,
  const unsigned char *k,
  const unsigned char *c
)
{
  uint32 x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;
  uint32 j0, j1, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15;
  int i;

    j0  = x0  = load_littleendian( c +  0);
    j1  = x1  = load_littleendian( c +  4);
    j2  = x2  = load_littleendian( c +  8);
    j3  = x3  = load_littleendian( c + 12);
    j4  = x4  = load_littleendian( k +  0);
    j5  = x5  = load_littleendian( k +  4);
    j6  = x6  = load_littleendian( k +  8);
    j7  = x7  = load_littleendian( k + 12);
    j8  = x8  = load_littleendian( k + 16);
    j9  = x9  = load_littleendian( k + 20);
    j10 = x10 = load_littleendian( k + 24);
    j11 = x11 = load_littleendian( k + 28);
    j12 = x12 = load_littleendian(in +  8);
    j13 = x13 = load_littleendian(in + 12);
    j14 = x14 = load_littleendian(in +  0);
    j15 = x15 = load_littleendian(in +  4);

  for (i = ROUNDS;i > 0;i -= 2) {
    quarterround(&x0, &x4, &x8,&x12);
    quarterround(&x1, &x5, &x9,&x13);
    quarterround(&x2, &x6,&x10,&x14);
    quarterround(&x3, &x7,&x11,&x15);
    quarterround(&x0, &x5,&x10,&x15);
    quarterround(&x1, &x6,&x11,&x12);
    quarterround(&x2, &x7, &x8,&x13);
    quarterround(&x3, &x4, &x9,&x14);
  }

  x0 += j0;
  x1 += j1;
  x2 += j2;
  x3 += j3;
  x4 += j4;
  x5 += j5;
  x6 += j6;
  x7 += j7;
  x8 += j8;
  x9 += j9;
  x10 += j10;
  x11 += j11;
  x12 += j12;
  x13 += j13;
  x14 += j14;
  x15 += j15;

  store_littleendian(out + 0,x0);
  store_littleendian(out + 4,x1);
  store_littleendian(out + 8,x2);
  store_littleendian(out + 12,x3);
  store_littleendian(out + 16,x4);
  store_littleendian(out + 20,x5);
  store_littleendian(out + 24,x6);
  store_littleendian(out + 28,x7);
  store_littleendian(out + 32,x8);
  store_littleendian(out + 36,x9);
  store_littleendian(out + 40,x10);
  store_littleendian(out + 44,x11);
  store_littleendian(out + 48,x12);
  store_littleendian(out + 52,x13);
  store_littleendian(out + 56,x14);
  store_littleendian(out + 60,x15);

  return 0;
}

static const unsigned char sigma[16] = "expand 32-byte k";

int crypto_stream_chacha20(unsigned char *c,unsigned long long clen, const unsigned char *n, const unsigned char *k)
{
  unsigned char block[64];
  unsigned char kcopy[32];

  uint64_t inx6[6][2];

  if (!clen)
    return 0;

  for (size_t i = 0;i < 32;++i)
    kcopy[i] = k[i];
  for(size_t i = 0; i < 6; i++){
    inx6[i][0] = *(uint64_t*)n;
    inx6[i][1] = i;
  }

  while (clen >= 64) {
    crypto_core_chacha20(c, (unsigned char*)inx6, kcopy, sigma);

    inx6[0][1]++;

    clen -= 64;
    c += 64;
  }

  if (clen) {
    crypto_core_chacha20(block, (unsigned char*)inx6, kcopy, sigma);
    for (size_t i = 0;i < clen;++i)
      c[i] = block[i];
  }
  return 0;
}


