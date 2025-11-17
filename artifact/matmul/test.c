
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "matmul.h"

int32_t A[6][I][J];
int32_t B[6][J][K];
int32_t C[6][I][K];

int main(void){

    for(size_t i = 0; i < I; i++){
        for(size_t j = 0; j < J; j++){
            A[0][i][j] = A[1][i][j] = A[2][i][j] = A[3][i][j] = A[4][i][j] = A[5][i][j] = (int32_t)rand();
        }
    }

    for(size_t j = 0; j < J; j++){
        for(size_t k = 0; k < K; k++){
            B[0][j][k] = B[1][j][k] = B[2][j][k] = B[3][j][k] = B[4][j][k] = B[5][j][k] = (int32_t)rand();
        }
    }

    memset(C, 0, sizeof(C));

    matmla_ijk_n_int32(&C[0][0][0], &A[0][0][0], &B[0][0][0]);
    matmla_ijk_lane_int32(&C[1][0][0], &A[1][0][0], &B[1][0][0]);
    matmla_ikj_n_int32(&C[2][0][0], &A[2][0][0], &B[2][0][0]);
    matmla_ikj_lane_int32(&C[3][0][0], &A[3][0][0], &B[3][0][0]);
    matmla_jik_n_int32(&C[4][0][0], &A[4][0][0], &B[4][0][0]);
    matmla_jik_lane_int32(&C[5][0][0], &A[5][0][0], &B[5][0][0]);

    for(size_t i = 0; i < I; i++){
        for(size_t k = 0; k < K; k++){
            assert( (C[0][i][k] == C[1][i][k]) &&
                    (C[1][i][k] == C[2][i][k]) &&
                    (C[2][i][k] == C[3][i][k]) &&
                    (C[3][i][k] == C[4][i][k]) &&
                    (C[4][i][k] == C[5][i][k]) &&
                    (C[5][i][k] == C[0][i][k]) );
        }
    }

    printf("Test finished!\n");

}
