#ifndef POLYMUL_H
#define POLYMUL_H

#include <stdint.h>
#include <stddef.h>

void mulcore(int16_t *des, const int16_t *src1, const int16_t *src2);
void polymul(int16_t *des, const int16_t *src1, const int16_t *src2);

#endif

