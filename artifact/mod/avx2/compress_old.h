#ifndef COMPRESS_OLD_H
#define COMPRESS_OLD_H

#include "params.h"

#include <stdint.h>

void poly_compress1_old(uint8_t msg[32], const int16_t a[KYBER_N]);
void poly_compress4_old(uint8_t r[128], const int16_t a[KYBER_N]);
void poly_compress5_old(uint8_t r[160], const int16_t a[KYBER_N]);
void poly_compress10_old(uint8_t r[320], const int16_t a[KYBER_N]);
void poly_compress11_old(uint8_t r[352], const int16_t a[KYBER_N]);

#endif

