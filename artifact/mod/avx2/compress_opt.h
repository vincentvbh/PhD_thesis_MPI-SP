#ifndef COMPRESS_OPT_H
#define COMPRESS_OPT_H

#include "params.h"

#include <stdint.h>

void poly_compress1(uint8_t r[32], const int16_t a[KYBER_N]);
void poly_compress4(uint8_t r[128], const int16_t a[KYBER_N]);
void poly_compress5(uint8_t r[160], const int16_t a[KYBER_N]);
void poly_compress10(uint8_t r[320], const int16_t a[KYBER_N]);
void poly_compress11(uint8_t r[352], const int16_t a[KYBER_N]);

void poly_compress1_avx2(uint8_t r[32], const int16_t a[KYBER_N]);
void poly_compress4_avx2(uint8_t r[128], const int16_t a[KYBER_N]);
void poly_compress5_avx2(uint8_t r[128], const int16_t a[KYBER_N]);
void poly_compress10_avx2(uint8_t r[320], const int16_t a[KYBER_N]);
void poly_compress11_avx2(uint8_t r[352], const int16_t a[KYBER_N]);

#endif

