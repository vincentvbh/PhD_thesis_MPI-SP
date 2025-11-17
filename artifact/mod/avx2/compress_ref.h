#ifndef COMPRESS_REF_H
#define COMPRESS_REF_H

#include "params.h"

#include <stdint.h>

void poly_compress1_ref(uint8_t msg[32], const int16_t a[KYBER_N]);
void poly_compress4_ref(uint8_t r[128], const int16_t a[KYBER_N]);
void poly_compress5_ref(uint8_t r[160], const int16_t a[KYBER_N]);
void poly_compress10_ref(uint8_t r[320], const int16_t a[KYBER_N]);
void poly_compress11_ref(uint8_t r[352], const int16_t a[KYBER_N]);

#endif

