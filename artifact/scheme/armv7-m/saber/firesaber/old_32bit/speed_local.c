#include "api.h"
#include "kem.h"
#include "SABER_params.h"
#include "sendfn.h"
#include "hal.h"
#include "NTT.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    int32_t s_NTT[SABER_N];
    int32_t acc_NTT[SABER_L * SABER_N];
    int32_t A_NTT[SABER_N];

    uint16_t poly[SABER_N];
    uint16_t acc[SABER_N];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    NTT_forward(s_NTT, poly);
    newcount = hal_get_time();
    printcycles("Constant-time 32-bit NTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    NTT_forward_leak(s_NTT, poly);
    newcount = hal_get_time();
    printcycles("Variable-time 32-bit NTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    NTT_mul(s_NTT, acc_NTT + 0 * SABER_N / 2, acc_NTT + 1 * SABER_N / 2);
    newcount = hal_get_time();
    printcycles("Constant-time 32-bit base_mul cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    NTT_inv(s_NTT, s_NTT);
    newcount = hal_get_time();
    printcycles("Constant-time 32-bit iNTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_forward(s_NTT, poly);
        for (size_t j = 0; j < SABER_L; j++) {
            NTT_forward(A_NTT, poly);
            if (j == 0) {
                NTT_mul(acc_NTT + j * SABER_N, s_NTT, A_NTT);
            } else {
                NTT_mul_acc(acc_NTT + j * SABER_N, s_NTT, A_NTT);
            }
        }
    }
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_inv(poly, acc_NTT + i * SABER_N);
    }
    newcount = hal_get_time();
    printcycles("32-bit MatrixVectorMul speed opt cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t i = 0; i < SABER_L; i++){
        NTT_forward(A_NTT, poly);
        if(i == 0){
            NTT_mul(acc_NTT, s_NTT, A_NTT);
        }else{
            NTT_mul_acc(acc_NTT, s_NTT, A_NTT);
        }
    }
    NTT_inv(acc, acc_NTT);
    newcount = hal_get_time();
    printcycles("32-bit InnderProd (Encrypt) speed opt cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_forward(A_NTT, poly);
        NTT_forward(s_NTT, poly);
        if (i == 0) {
            NTT_mul(acc_NTT, A_NTT, s_NTT);
        } else {
            NTT_mul_acc(acc_NTT, A_NTT, s_NTT);
        }
    }
    NTT_inv(poly, acc_NTT);
    newcount = hal_get_time();
    printcycles("32-bit InnderProd (Decrypt) speed opt cycles:", newcount - oldcount);

    hal_send_str("#");

}


