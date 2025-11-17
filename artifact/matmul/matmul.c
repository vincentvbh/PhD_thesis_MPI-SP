
#include <stddef.h>

#include <arm_neon.h>

#include "matmul.h"

void matmla_ijk_n_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32_t a;
    int32x4_t cx4, bx4;

    for(size_t i = 0; i < I; i++){

        for(size_t j = 0; j < J; j++){

            a = A[i * J + j];
            for(size_t k = 0; k < K; k += 4){
                cx4 = vld1q_s32(C + i * K + k);
                bx4 = vld1q_s32(B + j * K + k);
                cx4 = vmlaq_n_s32(cx4, bx4, a);
                vst1q_s32(C + i * K + k, cx4);
            }

            // for(size_t k = 0; k < K; k++){
            //     C[i * K + k] += A[i * J + j] * B[j * K + k];
            // }

        }

    }
}

void matmla_ijk_lane_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32x4_t cx4, ax4, bx4[4];

    for(size_t i = 0; i < I; i++){

        for(size_t j = 0; j < J; j += 4){

            ax4 = vld1q_s32(A + i * J + j);

            for(size_t k = 0; k < K; k += 4){
                cx4 = vld1q_s32(C + i * K + k);

                bx4[0] = vld1q_s32(B + (j + 0) * K + k);
                bx4[1] = vld1q_s32(B + (j + 1) * K + k);
                bx4[2] = vld1q_s32(B + (j + 2) * K + k);
                bx4[3] = vld1q_s32(B + (j + 3) * K + k);

                cx4 = vmlaq_laneq_s32(cx4, bx4[0], ax4, 0);
                cx4 = vmlaq_laneq_s32(cx4, bx4[1], ax4, 1);
                cx4 = vmlaq_laneq_s32(cx4, bx4[2], ax4, 2);
                cx4 = vmlaq_laneq_s32(cx4, bx4[3], ax4, 3);

                vst1q_s32(C + i * K + k, cx4);

            }

        }
    }
}

void matmla_ikj_n_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32_t a;
    int32x4_t cx4, bx4;

    for(size_t i = 0; i < I; i++){

        for(size_t k = 0; k < K; k += 4){
            cx4 = vld1q_s32(C + i * K + k);
            for(size_t j = 0; j < J; j++){
                a = A[i * J + j];
                bx4 = vld1q_s32(B + j * K + k);
                cx4 = vmlaq_n_s32(cx4, bx4, a);
            }
            vst1q_s32(C + i * K + k, cx4);
        }

        // for(size_t k = 0; k < K; k++){
        //     for(size_t j = 0; j < J; j++){
        //         C[i * K + k] += A[i * J + j] * B[j * K + k];
        //     }
        // }

    }
}

void matmla_ikj_lane_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32x4_t cx4, ax4, bx4[4];

    for(size_t i = 0; i < I; i++){

        for(size_t k = 0; k < K; k += 4){
            cx4 = vld1q_s32(C + i * K + k);
            for(size_t j = 0; j < J; j += 4){

                ax4 = vld1q_s32(A + i * J + j);
                bx4[0] = vld1q_s32(B + (j + 0) * K + k);
                bx4[1] = vld1q_s32(B + (j + 1) * K + k);
                bx4[2] = vld1q_s32(B + (j + 2) * K + k);
                bx4[3] = vld1q_s32(B + (j + 3) * K + k);

                cx4 = vmlaq_laneq_s32(cx4, bx4[0], ax4, 0);
                cx4 = vmlaq_laneq_s32(cx4, bx4[1], ax4, 1);
                cx4 = vmlaq_laneq_s32(cx4, bx4[2], ax4, 2);
                cx4 = vmlaq_laneq_s32(cx4, bx4[3], ax4, 3);

            }
            vst1q_s32(C + i * K + k, cx4);
        }

    }
}

void matmla_jik_n_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32_t a;
    int32x4_t cx4, bx4;

    for(size_t j = 0; j < J; j++){
        for(size_t i = 0; i < I; i++){

            a = A[i * J + j];

            for(size_t k = 0; k < K; k += 4){
                cx4 = vld1q_s32(C + i * K + k);
                bx4 = vld1q_s32(B + j * K + k);
                cx4 = vmlaq_n_s32(cx4, bx4, a);
                vst1q_s32(C + i * K + k, cx4);
            }

            // for(size_t k = 0; k < K; k++){
            //     C[i * K + k] += A[i * J + j] * B[j * K + k];
            // }

        }
    }
}

void matmla_jik_lane_int32(int32_t *C, const int32_t *A, const int32_t * B){

    int32x4_t cx4, ax4, bx4[4];

    for(size_t i = 0; i < I; i++){

        for(size_t j = 0; j < J; j += 4){

            ax4 = vld1q_s32(A + i * J + j);

            for(size_t k = 0; k < K; k += 4){
                cx4 = vld1q_s32(C + i * K + k);

                bx4[0] = vld1q_s32(B + (j + 0) * K + k);
                bx4[1] = vld1q_s32(B + (j + 1) * K + k);
                bx4[2] = vld1q_s32(B + (j + 2) * K + k);
                bx4[3] = vld1q_s32(B + (j + 3) * K + k);

                cx4 = vmlaq_laneq_s32(cx4, bx4[0], ax4, 0);
                cx4 = vmlaq_laneq_s32(cx4, bx4[1], ax4, 1);
                cx4 = vmlaq_laneq_s32(cx4, bx4[2], ax4, 2);
                cx4 = vmlaq_laneq_s32(cx4, bx4[3], ax4, 3);

                vst1q_s32(C + i * K + k, cx4);

            }

        }
    }
}

void matmla_jki_int32(int32_t *C, const int32_t *A, const int32_t * B){
    for(size_t j = 0; j < J; j++){
        for(size_t k = 0; k < K; k++){
            for(size_t i = 0; i < I; i++){
                C[i * K + k] += A[i * J + j] * B[j * K + k];
            }
        }
    }
}

void matmla_kij_int32(int32_t *C, const int32_t *A, const int32_t * B){
    for(size_t k = 0; k < K; k++){
        for(size_t i = 0; i < I; i++){
            for(size_t j = 0; j < J; j++){
                C[i * K + k] += A[i * J + j] * B[j * K + k];
            }
        }
    }
}

void matmla_kji_int32(int32_t *C, const int32_t *A, const int32_t * B){
    for(size_t k = 0; k < K; k++){
        for(size_t j = 0; j < J; j++){
            for(size_t i = 0; i < I; i++){
                C[i * K + k] += A[i * J + j] * B[j * K + k];
            }
        }
    }
}
