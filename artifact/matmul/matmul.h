#ifndef MATMUL_H
#define MATMUL_H

#include <stdint.h>
#include <stddef.h>

#define I 512
#define J 512
#define K 512

void matmla_ijk_n_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_ijk_lane_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_ikj_n_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_ikj_lane_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_jik_n_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_jik_lane_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_jki_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_kij_int32(int32_t *C, const int32_t *A, const int32_t * B);
void matmla_kji_int32(int32_t *C, const int32_t *A, const int32_t * B);

#endif



