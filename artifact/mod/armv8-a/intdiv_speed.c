
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <arm_neon.h>

#include "cycles.h"

#define NTESTS 100000

uint64_t time0, time1;
uint64_t cycles[NTESTS];

#define KYBER_Q 3329
#define KYBER_N 256

int16_t compress_D(int16_t a, const size_t D){
    if(a < 0){
        a += KYBER_Q;
    }
    return (int16_t)(( ( ((int32_t)a) << D) + (KYBER_Q / 2) ) / KYBER_Q) & ((1 << D) - 1);
}

__attribute__ ((always_inline))
int16_t Barrett_compress1(int16_t a){
    // 19-bit suffices for D = 1
    // 315 = round(2 * 2^19 / q)
    return (((int32_t)a * 315 + (1 << 18)) >> 19) & 0x1;
}

__attribute__ ((always_inline))
int16_t Barrett_compress4(int16_t a){
    // 16-bit suffices for D = 4
    // 315 = round(16 * 2^16 / q)
    return (((int32_t)a * 315 + (1 << 15)) >> 16) & 0xf;
}

__attribute__ ((always_inline))
int16_t Barrett_compress5(int16_t a){
    // 15-bit suffices for D = 5
    // 315 = round(32 * 2^15 / q)
    return (((int32_t)a * 315 + (1 << 14)) >> 15) & 0x1f;
}

__attribute__ ((always_inline))
int16_t Barrett_compress10(int16_t a){
    // 22-bit suffices for D = 10
    // 1290167 = round(1024 * 2^22 / q)
    // beware that adding prior to shifting overflows (32-bit), we must shift, add, and then shift here.
    return ( ((((int32_t)a * 1290167) >> 1) + \
                    (1 << 20)) >> 21) & 0x3ff;
}

__attribute__ ((always_inline))
int16_t Barrett_compress11(int16_t a){
    // 21-bit suffices for D = 11
    // 1290167 = round(2048 * 2^21 / q)
    // beware that adding prior to shifting overflows (32-bit), we must shift, add, and then shift here.
    return ( ((((int32_t)a * 1290167) >> 1) + \
                    (1 << 19)) >> 20) & 0x7ff;
}

__attribute__ ((noinline))
void poly_compress1_ref(uint8_t msg[32], const int16_t *a)
{
  unsigned int i,j;
  uint32_t t;

  for(i=0;i<KYBER_N/8;i++) {
    msg[i] = 0;
    for(j=0;j<8;j++) {
      t  = a[8*i+j];
      // t += ((int16_t)t >> 15) & KYBER_Q;
      // t  = (((t << 1) + KYBER_Q/2)/KYBER_Q) & 1;
      t <<= 1;
      t += 1665;
      t *= 80635;
      t >>= 28;
      t &= 1;
      msg[i] |= t << j;
    }
  }
}

__attribute__ ((noinline))
void poly_compress4_ref(uint8_t *r, const int16_t *a)
{
  unsigned int i,j;
  int16_t u;
  uint32_t d0;
  uint8_t t[8];

  for(i=0;i<KYBER_N/8;i++) {
    for(j=0;j<8;j++) {
      // map to positive standard representatives
      u  = a[8*i+j];
      u += (u >> 15) & KYBER_Q;
/*    t[j] = ((((uint16_t)u << 4) + KYBER_Q/2)/KYBER_Q) & 15; */
      d0 = u << 4;
      d0 += 1665;
      d0 *= 80635;
      d0 >>= 28;
      t[j] = d0 & 0xf;
    }

    r[0] = t[0] | (t[1] << 4);
    r[1] = t[2] | (t[3] << 4);
    r[2] = t[4] | (t[5] << 4);
    r[3] = t[6] | (t[7] << 4);
    r += 4;
  }

}

__attribute__ ((noinline))
void poly_compress5_ref(uint8_t *r, const int16_t *a){

  unsigned int i,j;
  int16_t u;
  uint32_t d0;
  uint8_t t[8];

  for(i=0;i<KYBER_N/8;i++) {
    for(j=0;j<8;j++) {
      // map to positive standard representatives
      u  = a[8*i+j];
      u += (u >> 15) & KYBER_Q;
/*    t[j] = ((((uint32_t)u << 5) + KYBER_Q/2)/KYBER_Q) & 31; */
      d0 = u << 5;
      d0 += 1664;
      d0 *= 40318;
      d0 >>= 27;
      t[j] = d0 & 0x1f;
    }

    r[0] = (t[0] >> 0) | (t[1] << 5);
    r[1] = (t[1] >> 3) | (t[2] << 2) | (t[3] << 7);
    r[2] = (t[3] >> 1) | (t[4] << 4);
    r[3] = (t[4] >> 4) | (t[5] << 1) | (t[6] << 6);
    r[4] = (t[6] >> 2) | (t[7] << 3);
    r += 5;
  }

}

__attribute__ ((noinline))
void poly_compress10_ref(uint8_t r[320], const int16_t *a)
{
  unsigned int j,k;
  uint64_t d0;

  uint16_t t[4];
    for(j=0;j<KYBER_N/4;j++) {
      for(k=0;k<4;k++) {
        t[k]  = a[4*j+k];
        t[k] += ((int16_t)t[k] >> 15) & KYBER_Q;
/*      t[k]  = ((((uint32_t)t[k] << 10) + KYBER_Q/2)/ KYBER_Q) & 0x3ff; */
        d0 = t[k];
        d0 <<= 10;
        d0 += 1665;
        d0 *= 1290167;
        d0 >>= 32;
        t[k] = d0 & 0x3ff;
      }

      r[0] = (t[0] >> 0);
      r[1] = (t[0] >> 8) | (t[1] << 2);
      r[2] = (t[1] >> 6) | (t[2] << 4);
      r[3] = (t[2] >> 4) | (t[3] << 6);
      r[4] = (t[3] >> 2);
      r += 5;
    }

}

__attribute__ ((noinline))
void poly_compress11_ref(uint8_t r[352], const int16_t *a)
{
  unsigned int j,k;
  uint64_t d0;

  uint16_t t[8];
    for(j=0;j<KYBER_N/8;j++) {
      for(k=0;k<8;k++) {
        t[k]  = a[8*j+k];
        t[k] += ((int16_t)t[k] >> 15) & KYBER_Q;
/*      t[k]  = ((((uint32_t)t[k] << 11) + KYBER_Q/2)/KYBER_Q) & 0x7ff; */
        d0 = t[k];
        d0 <<= 11;
        d0 += 1664;
        d0 *= 645084;
        d0 >>= 31;
        t[k] = d0 & 0x7ff;
      }

      r[ 0] = (t[0] >>  0);
      r[ 1] = (t[0] >>  8) | (t[1] << 3);
      r[ 2] = (t[1] >>  5) | (t[2] << 6);
      r[ 3] = (t[2] >>  2);
      r[ 4] = (t[2] >> 10) | (t[3] << 1);
      r[ 5] = (t[3] >>  7) | (t[4] << 4);
      r[ 6] = (t[4] >>  4) | (t[5] << 7);
      r[ 7] = (t[5] >>  1);
      r[ 8] = (t[5] >>  9) | (t[6] << 2);
      r[ 9] = (t[6] >>  6) | (t[7] << 5);
      r[10] = (t[7] >>  3);
      r += 11;
    }

}

__attribute__ ((noinline))
void poly_compress1(uint8_t r[32], const int16_t a[KYBER_N]){

    unsigned int i,j;
    int16_t u;

    for(i=0;i<KYBER_N/8;i++) {
        r[i] = 0;
        for(j=0;j<8;j++) {
            u = a[8*i+j];

            // 19-bit precision suffices for round(2 x / q)
            // inputs are in [-q/2, ..., q/2]
            // 315 = round(2 * 2^19 / q)
            u = Barrett_compress1(u);

            // this is equivalent to first mapping to positive
            // standard representatives followed by
            // u = ((((uint16_t)u << 1) + KYBER_Q/2)/KYBER_Q) & 1;

            r[i] |= u << j;

        }
    }

}

__attribute__ ((noinline))
void poly_compress4(uint8_t r[128], const int16_t a[KYBER_N]){

    unsigned int j,k;
    int16_t u;

    uint16_t t[8];
    for(j=0;j<KYBER_N/8;j++) {
        for(k=0;k<8;k++) {
            u  = a[8*j+k];

            // 16-bit precision suffices for round(2^4 x / q)
            // inputs are in [-q/2, ..., q/2]
            // 315 = round(16 * 2^16 / q)
            t[k] = Barrett_compress4(u);

            // this is equivalent to first mapping to positive
            // standard representatives followed by
            // t[j] = ((((uint16_t)u << 4) + KYBER_Q/2)/KYBER_Q) & 0xf;

        }

        r[0] = t[0] | (t[1] << 4);
        r[1] = t[2] | (t[3] << 4);
        r[2] = t[4] | (t[5] << 4);
        r[3] = t[6] | (t[7] << 4);
        r += 4;
    }

}

__attribute__ ((noinline))
void poly_compress5(uint8_t r[160], const int16_t a[KYBER_N]){

    unsigned int j,k;
    int16_t u;

    uint16_t t[8];
    for(j=0;j<KYBER_N/8;j++) {
        for(k=0;k<8;k++) {
            u  = a[8*j+k];


            // 15-bit precision suffices for round(2^5 x / q)
            // inputs are in [-q/2, ..., q/2]
            // 315 = round(32 * 2^15 / q)
            t[k] = Barrett_compress5(u);

            // this is equivalent to first mapping to positive
            // standard representatives followed by
            // t[j] = ((((uint32_t)u << 5) + KYBER_Q/2)/KYBER_Q) & 0x1f;

        }

        r[0] = (t[0] >> 0) | (t[1] << 5);
        r[1] = (t[1] >> 3) | (t[2] << 2) | (t[3] << 7);
        r[2] = (t[3] >> 1) | (t[4] << 4);
        r[3] = (t[4] >> 4) | (t[5] << 1) | (t[6] << 6);
        r[4] = (t[6] >> 2) | (t[7] << 3);
        r += 5;
    }

}

__attribute__ ((noinline))
void poly_compress10(uint8_t r[320], const int16_t a[KYBER_N]){

    unsigned int j,k;
    int16_t u;

    uint16_t t[4];
    for(j=0;j<KYBER_N/8;j++) {
        for(k=0;k<4;k++) {
            u  = a[4*j+k];

            // 22-bit suffices for round(1024 x / q)
            // inputs are in [-q/2, ..., q/2]
            // 1290167 = round(1024 * 2^22 / q)
            t[k] = Barrett_compress10(u);

            // this is equivalent to first mapping to positive
            // standard representatives followed by
            // t[k]  = ((((uint32_t)u << 10) + KYBER_Q/2)/ KYBER_Q) & 0x3ff;

        }

        r[0] = (t[0] >> 0);
        r[1] = (t[0] >> 8) | (t[1] << 2);
        r[2] = (t[1] >> 6) | (t[2] << 4);
        r[3] = (t[2] >> 4) | (t[3] << 6);
        r[4] = (t[3] >> 2);
        r += 5;
    }

}

__attribute__ ((noinline))
void poly_compress11(uint8_t r[352], const int16_t a[KYBER_N]){

    unsigned int j,k;
    int16_t u;

    uint16_t t[8];
    for(j=0;j<KYBER_N/8;j++) {
        for(k=0;k<8;k++) {
            u  = a[8*j+k];

            // 21-bit suffices for round(2048 x / q)
            // inputs are in [-q/2, ..., q/2]
            // 1290167 = round(2048 * 2^21 / q)
            t[k] = Barrett_compress11(u);

            // this is equivalent to first mapping to positive
            // standard representatives followed by
            // t[k]  = ((((uint32_t)u << 11) + KYBER_Q/2)/KYBER_Q) & 0x7ff;

        }

        r[ 0] = (t[0] >>  0);
        r[ 1] = (t[0] >>  8) | (t[1] << 3);
        r[ 2] = (t[1] >>  5) | (t[2] << 6);
        r[ 3] = (t[2] >>  2);
        r[ 4] = (t[2] >> 10) | (t[3] << 1);
        r[ 5] = (t[3] >>  7) | (t[4] << 4);
        r[ 6] = (t[4] >>  4) | (t[5] << 7);
        r[ 7] = (t[5] >>  1);
        r[ 8] = (t[5] >>  9) | (t[6] << 2);
        r[ 9] = (t[6] >>  6) | (t[7] << 5);
        r[10] = (t[7] >>  3);
        r += 11;
    }

}

#define SHIFT_WITH_HOLES_B(a, mask_lo, mask_hi, shift_i) ({ \
            int8x16_t val; \
            do { \
                val = (int8x16_t)vorrq_s16((int16x8_t)vandq_s8(a, mask_lo), \
                                  vshrq_n_s16((int16x8_t)vandq_s8(a, mask_hi), shift_i)); \
            } while(0); \
            val; \
        })

#define SHIFT_WITH_HOLES_B_VERY_LAZY(a, shift_i) ({ \
            int8x16_t val; \
            do { \
                val = (int8x16_t)vorrq_s16((int16x8_t)a, \
                                 vshrq_n_s16((int16x8_t)a, shift_i)); \
            } while(0); \
            val; \
        })

#define SHIFT_WITH_HOLES_H(a, mask_lo, mask_hi, shift_i) ({ \
            int16x8_t val; \
            do { \
                val = (int16x8_t)vorrq_s32((int32x4_t)vandq_s16(a, mask_lo), \
                                 vshrq_n_s32((int32x4_t)vandq_s16(a, mask_hi), shift_i)); \
            } while(0); \
            val; \
        })

#define SHIFT_WITH_HOLES_S(a, mask_lo, mask_hi, shift_i) ({ \
            int32x4_t val; \
            do { \
                val = (int32x4_t)vorrq_s64((int64x2_t)vandq_s32(a, mask_lo), \
                                 vshrq_n_s64((int64x2_t)vandq_s32(a, mask_hi), shift_i)); \
            } while(0); \
            val; \
        })

__attribute__ ((noinline))
void poly_compress1_intrinsics(uint8_t r[32], const int16_t a[KYBER_N]){

    int16x8_t tvec[16];
    int16x8_t mask1 = vdupq_n_s16(0x1);

    for(size_t i = 0; i < KYBER_N / 128; i++){

        for(size_t j = 0; j < 16; j++){
            tvec[j] = vld1q_s16(a + i * 128 + 8 * j);
            tvec[j] = vqdmulhq_n_s16(tvec[j], 315);
            tvec[j] = vrshrq_n_s16(tvec[j], 4);
            tvec[j] = vandq_s16(tvec[j], mask1);
        }

        for(size_t j = 0; j < 16; j += 2){
            tvec[j] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[j]), tvec[j + 1]);
            tvec[j] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[j], 7);
        }

        for(size_t j = 0; j < 16; j += 4){
            tvec[j] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[j]), tvec[j + 2]);
            tvec[j] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[j], 6);
        }

        tvec[0] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[0]), tvec[4]);
        tvec[8] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[8]), tvec[12]);
        tvec[0] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[0], 4);
        tvec[8] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[8], 4);

        tvec[0] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[0]), tvec[8]);

        vst1q_u8(r, (uint8x16_t)tvec[0]);
        r += 16;

    }

}

__attribute__ ((noinline))
void poly_compress4_intrinsics(uint8_t r[128], const int16_t a[KYBER_N]){

    int16x8_t tvec[4];
    int16x8_t mask4 = vdupq_n_s16(0xf);
    int16x8_t one = vdupq_n_s16(1);

    for(size_t i = 0; i < KYBER_N / 32; i++) {

        tvec[0] = vld1q_s16(a + i * 32 + 8 * 0);
        tvec[1] = vld1q_s16(a + i * 32 + 8 * 1);
        tvec[2] = vld1q_s16(a + i * 32 + 8 * 2);
        tvec[3] = vld1q_s16(a + i * 32 + 8 * 3);

        tvec[0] = vqdmulhq_n_s16(tvec[0], 315);
        tvec[1] = vqdmulhq_n_s16(tvec[1], 315);
        tvec[2] = vqdmulhq_n_s16(tvec[2], 315);
        tvec[3] = vqdmulhq_n_s16(tvec[3], 315);

        tvec[0] = vhaddq_s16(tvec[0], one);
        tvec[1] = vhaddq_s16(tvec[1], one);
        tvec[2] = vhaddq_s16(tvec[2], one);
        tvec[3] = vhaddq_s16(tvec[3], one);

        tvec[0] = vandq_s16(tvec[0], mask4);
        tvec[1] = vandq_s16(tvec[1], mask4);
        tvec[2] = vandq_s16(tvec[2], mask4);
        tvec[3] = vandq_s16(tvec[3], mask4);

        tvec[0] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[0]), tvec[1]);
        tvec[2] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[2]), tvec[3]);

        tvec[0] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[0], 4);
        tvec[2] = (int16x8_t)SHIFT_WITH_HOLES_B_VERY_LAZY((int8x16_t)tvec[2], 4);

        tvec[0] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[0]), tvec[2]);

        vst1q_s16((int16_t*)r, tvec[0]);

        r += 16;
    }

}

__attribute__ ((noinline))
void poly_compress5_intrinsics(uint8_t r[160], const int16_t a[KYBER_N]){

    int16x8_t tvec[2];
    int16x8_t mask5 = vdupq_n_s16(0x1f);
    int16x8_t mask_h_lo = {0x3ff, 0, 0x3ff, 0, 0x3ff, 0, 0x3ff, 0};
    int16x8_t mask_h_hi = {0, 0x3ff, 0, 0x3ff, 0, 0x3ff, 0, 0x3ff};
    int32x4_t mask_w_lo = {0xfffff, 0, 0xfffff, 0};
    int32x4_t mask_w_hi = {0, 0xfffff, 0, 0xfffff};
    int8x16_t mask_b_lo = {0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0};
    int8x16_t mask_b_hi = {0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f, 0, 0x1f};

    uint16_t t[2][8];
    for(size_t i = 0; i < KYBER_N / 16; i++) {

        tvec[0] = vld1q_s16(a + 16 * i + 8 * 0);
        tvec[1] = vld1q_s16(a + 16 * i + 8 * 1);
        tvec[0] = vqrdmulhq_n_s16(tvec[0], 315);
        tvec[1] = vqrdmulhq_n_s16(tvec[1], 315);
        tvec[0] = vandq_s16(tvec[0], mask5);
        tvec[1] = vandq_s16(tvec[1], mask5);

        tvec[0] = (int16x8_t)vmovn_high_s16(vmovn_s16(tvec[0]), tvec[1]);

        tvec[0] = (int16x8_t)SHIFT_WITH_HOLES_B((int8x16_t)tvec[0], mask_b_lo, mask_b_hi, 3);
        tvec[0] = SHIFT_WITH_HOLES_H(tvec[0], mask_h_lo, mask_h_hi, 6);
        tvec[0] = (int16x8_t)SHIFT_WITH_HOLES_S((int32x4_t)tvec[0], mask_w_lo, mask_w_hi, 12);

        vst1q_s16((int16_t*)t[0], tvec[0]);

        r[0] = t[0][0];
        r[1] = t[0][0] >> 8;
        r[2] = t[0][1];
        r[3] = t[0][1] >> 8;
        r[4] = t[0][2];
        r[5] = t[0][4];
        r[6] = t[0][4] >> 8;
        r[7] = t[0][5];
        r[8] = t[0][5] >> 8;
        r[9] = t[0][6];

        r += 10;
    }

}

__attribute__ ((noinline))
void poly_compress10_intrinsics(uint8_t r[320], const int16_t a[KYBER_N]){

    __attribute__((aligned(16)))uint16_t t[8];
    int16x8_t avec, tvec;
    int16x8_t mask10 = vdupq_n_s16(0x3ff);
    int16x8_t zero = vdupq_n_s16(0);

    int16x8_t mask_h_lo = {0x3ff, 0, 0x3ff, 0, 0x3ff, 0, 0x3ff, 0};
    int16x8_t mask_h_hi = {0, 0x3ff, 0, 0x3ff, 0, 0x3ff, 0, 0x3ff};
    int32x4_t mask_w_lo = {0xfffff, 0, 0xfffff, 0};
    int32x4_t mask_w_hi = {0, 0xfffff, 0, 0xfffff};

    for(size_t i = 0; i < KYBER_N / 8; i++){
        avec = vld1q_s16(a + 8 * i);

        tvec = vqdmulhq_n_s16(avec, -20553);
        tvec = vhaddq_s16(tvec, zero);
        tvec = vmlaq_n_s16(tvec, avec, 20);
        tvec = vrshrq_n_s16(tvec, 6);
        tvec = vandq_s16(tvec, mask10);

        tvec = SHIFT_WITH_HOLES_H(tvec, mask_h_lo, mask_h_hi, 6);
        tvec = (int16x8_t)SHIFT_WITH_HOLES_S((int32x4_t)tvec, mask_w_lo, mask_w_hi, 12);

        vst1q_s16((int16_t*)t, tvec);

        memcpy(r + 0, t + 0, 5);
        memcpy(r + 5, t + 4, 5);

        r += 10;
    }

}

__attribute__ ((noinline))
void poly_compress11_intrinsics(uint8_t r[352], const int16_t a[KYBER_N]){

    uint64_t lo64, hi64;
    __attribute__((aligned(16))) uint16_t t[8];
    int16x8_t avec, tvec;
    int16x8_t mask11 = vdupq_n_s16(0x7ff);
    int16x8_t zero = vdupq_n_s16(0);

    int16x8_t mask_h_lo = {0x7ff, 0, 0x7ff, 0, 0x7ff, 0, 0x7ff, 0};
    int16x8_t mask_h_hi = {0, 0x7ff, 0, 0x7ff, 0, 0x7ff, 0, 0x7ff};
    int32x4_t mask_w_lo = {0x3fffff, 0, 0x3fffff, 0};
    int32x4_t mask_w_hi = {0, 0x3fffff, 0, 0x3fffff};

    for(size_t i = 0; i < KYBER_N / 8; i++) {

        avec = vld1q_s16(a + 8 * i);

        tvec = vqdmulhq_n_s16(avec, -20553);
        tvec = vhaddq_s16(tvec, zero);
        tvec = vmlaq_n_s16(tvec, avec, 20);
        tvec = vrshrq_n_s16(tvec, 5);
        tvec = vandq_s16(tvec, mask11);

        tvec = SHIFT_WITH_HOLES_H(tvec, mask_h_lo, mask_h_hi, 5);
        tvec = (int16x8_t)SHIFT_WITH_HOLES_S((int32x4_t)tvec, mask_w_lo, mask_w_hi, 10);

        vst1q_s16((int16_t*)t, tvec);

        memcpy(r, t, 5);
        lo64 = 0;
        memcpy(&lo64, t + 2, 2);
        memcpy(&hi64, t + 4, 8);
        hi64 = (hi64 << 4) | (lo64 >> 8);

        memcpy(r + 5, &hi64, 6);

        r += 11;
    }

}


extern
void KYBER_AARCH64__asm_compress1x8_prototype(int16_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_pack1x128_prototype(uint8_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_poly_compress1x128_core(uint8_t *des, const int16_t *src, size_t iter);

__attribute__ ((noinline))
void poly_compress1_neon(uint8_t r[32], const int16_t a[KYBER_N]){

    int16_t buff[16][8];

    for(size_t i = 0; i < KYBER_N / 128; i++){
        for(size_t j = 0; j < 16; j++){
            KYBER_AARCH64__asm_compress1x8_prototype(buff[j], a + i * 128 + j * 8);
        }
        KYBER_AARCH64__asm_pack1x128_prototype(r + i * 16, (int16_t*)&buff[0][0]);
    }

}

extern
void KYBER_AARCH64__asm_compress4x8_prototype(int16_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_pack4x32_prototype(uint8_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_poly_compress4x32_core(uint8_t *des, const int16_t *src, size_t iter);

__attribute__ ((noinline))
void poly_compress4_neon(uint8_t r[128], const int16_t a[KYBER_N]){

    int16_t buff[4][8];

    for(size_t i = 0; i < KYBER_N / 32; i++) {
        for(size_t j = 0; j < 4; j++){
            KYBER_AARCH64__asm_compress4x8_prototype(buff[j], a + i * 32 + j * 8);
        }
        KYBER_AARCH64__asm_pack4x32_prototype(r + i * 16, (int16_t*)&buff[0][0]);
    }

}

extern
void KYBER_AARCH64__asm_compress5x8_prototype(int16_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_pack5x16_prototype(uint8_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_poly_compress5x16_core(uint8_t *des, const int16_t *src, size_t iter);

__attribute__ ((noinline))
void poly_compress5_neon(uint8_t r[160], const int16_t a[KYBER_N]){

    int16_t buff[2][8];

    for(size_t i = 0; i < KYBER_N / 16; i++) {
        KYBER_AARCH64__asm_compress5x8_prototype(buff[0], a + i * 16 + 0 * 8);
        KYBER_AARCH64__asm_compress5x8_prototype(buff[1], a + i * 16 + 1 * 8);
        KYBER_AARCH64__asm_pack5x16_prototype(r + i * 10, (int16_t*)&buff[0][0]);
    }

}

extern
void KYBER_AARCH64__asm_compress10x8_prototype(int16_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_pack10x8_prototype(uint8_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_poly_compress10x8_core(uint8_t *des, const int16_t *src, size_t iter);

__attribute__ ((noinline))
void poly_compress10_neon(uint8_t r[320], const int16_t a[KYBER_N]){

    int16_t buff[8];

    for(size_t i = 0; i < KYBER_N / 8; i++){
        KYBER_AARCH64__asm_compress10x8_prototype(buff, a + i * 8);
        KYBER_AARCH64__asm_pack10x8_prototype(r + i * 10, buff);
    }

}

extern
void KYBER_AARCH64__asm_compress11x8_prototype(int16_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_pack11x8_prototype(uint8_t *des, const int16_t *src);

extern
void KYBER_AARCH64__asm_poly_compress11x8_core(uint8_t *des, const int16_t *src, size_t iter);

__attribute__ ((noinline))
void poly_compress11_neon(uint8_t r[352], const int16_t a[KYBER_N]){

    int16_t buff[8];

    for(size_t i = 0; i < KYBER_N / 8; i++) {
        KYBER_AARCH64__asm_compress11x8_prototype(buff, a + i * 8);
        KYBER_AARCH64__asm_pack11x8_prototype(r + i * 11, buff);
    }

}

int main(void){

    int16_t a[KYBER_N];
    uint8_t res[352];

    for(size_t i = 0; i < KYBER_N; i++){
        a[i] = rand() % KYBER_Q;
    }

    init_counter();

    WRAP_FUNC("poly_compress1 ref",
              cycles, time0, time1,
              poly_compress1_ref(res, a));

    WRAP_FUNC("poly_compress1",
              cycles, time0, time1,
              poly_compress1(res, a));

    WRAP_FUNC("poly_comrpess1 intrinsics",
              cycles, time0, time1,
              poly_compress1_intrinsics(res, a));

    WRAP_FUNC("poly_compress1 asm",
              cycles, time0, time1,
              KYBER_AARCH64__asm_poly_compress1x128_core(res, a, KYBER_N / 128));

    WRAP_FUNC("poly_compress4 ref",
              cycles, time0, time1,
              poly_compress4_ref(res, a));

    WRAP_FUNC("poly_compress4",
              cycles, time0, time1,
              poly_compress4(res, a));

    WRAP_FUNC("poly_compress4 intrinsics",
              cycles, time0, time1,
              poly_compress4_intrinsics(res, a));

    WRAP_FUNC("poly_compress4 asm",
              cycles, time0, time1,
              KYBER_AARCH64__asm_poly_compress4x32_core(res, a, KYBER_N / 32));

    WRAP_FUNC("poly_compress5 ref",
              cycles, time0, time1,
              poly_compress5_ref(res, a));

    WRAP_FUNC("poly_compress5",
              cycles, time0, time1,
              poly_compress5(res, a));

    WRAP_FUNC("poly_compress5 intrinsics",
              cycles, time0, time1,
              poly_compress5_intrinsics(res, a));

    WRAP_FUNC("poly_compress5 asm",
              cycles, time0, time1,
              KYBER_AARCH64__asm_poly_compress5x16_core(res, a, KYBER_N / 16));

    WRAP_FUNC("poly_compress10 ref",
              cycles, time0, time1,
              poly_compress10_ref(res, a));

    WRAP_FUNC("poly_compress10",
              cycles, time0, time1,
              poly_compress10(res, a));

    WRAP_FUNC("poly_compress10 intrinsics",
              cycles, time0, time1,
              poly_compress10_intrinsics(res, a));

    WRAP_FUNC("poly_compress10 asm",
              cycles, time0, time1,
              KYBER_AARCH64__asm_poly_compress10x8_core(res, a, KYBER_N / 8));

    WRAP_FUNC("poly_compress11 ref",
              cycles, time0, time1,
              poly_compress11_ref(res, a));

    WRAP_FUNC("poly_compress11",
              cycles, time0, time1,
              poly_compress11(res, a));

    WRAP_FUNC("poly_compress11 intrinsics",
              cycles, time0, time1,
              poly_compress11_intrinsics(res, a));

    WRAP_FUNC("poly_compress11 asm",
              cycles, time0, time1,
              KYBER_AARCH64__asm_poly_compress11x8_core(res, a, KYBER_N / 8));

}


