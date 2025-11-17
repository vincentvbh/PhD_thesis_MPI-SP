
#include "api.h"
#include "kem.h"
#include "SABER_params.h"
#include "sendfn.h"
#include "hal.h"
#include "NTT.h"
#include "poly.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    uint16_t poly[SABER_N];
    int32_t poly_NTT[SABER_N];
    int32_t buff_NTT[SABER_N];
    int32_t s_NTT[SABER_N];
    int32_t A_NTT[SABER_N];
    int32_t acc_NTT[SABER_L][SABER_N];


    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    NTT_forward_32((uint32_t*)s_NTT, poly);
    newcount = hal_get_time();
    printcycles("NTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    NTT_mul_32((uint32_t*)acc_NTT[0], (uint32_t*)A_NTT, (uint32_t*)s_NTT);
    newcount = hal_get_time();
    printcycles("basemul cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    NTT_inv_32(poly, (uint32_t*)s_NTT);
    newcount = hal_get_time();
    printcycles("iNTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_forward_32((uint32_t*)s_NTT, poly);
        for (size_t j = 0; j < SABER_L; j++) {
            NTT_forward_32((uint32_t*)A_NTT, poly);
            if(i == 0){
                NTT_mul_32((uint32_t*)acc_NTT[j], (uint32_t*)A_NTT, (uint32_t*)s_NTT);
            }else{
                NTT_mul_acc_32((uint32_t*)acc_NTT[j], (uint32_t*)A_NTT, (uint32_t*)s_NTT);
            }
        }
    }
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_inv_32(poly, (uint32_t*)(acc_NTT) + i * SABER_N);
    }
    newcount = hal_get_time();
    printcycles("Matrix-vector multiplication:", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t j = 0; j < SABER_L; j++){
        NTT_forward_32((uint32_t*)A_NTT, poly);
        if(j == 0){
            NTT_mul_32((uint32_t*)acc_NTT[0], (uint32_t*)A_NTT, (uint32_t*)(s_NTT + j * SABER_N));
        }else{
            NTT_mul_acc_32((uint32_t*)acc_NTT[0], (uint32_t*)A_NTT, (uint32_t*)(s_NTT + j * SABER_N));
        }
    }
    NTT_inv_32(poly, (uint32_t*)acc_NTT[0]);
    newcount = hal_get_time();
    printcycles("Inner product (Enc):", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        NTT_forward_32((uint32_t*)poly_NTT, poly);
        NTT_forward_32((uint32_t*)buff_NTT, poly);
        if (i == 0) {
            NTT_mul_32((uint32_t*)acc_NTT[0], (uint32_t*)poly_NTT, (uint32_t*)buff_NTT);
        } else {
            NTT_mul_acc_32((uint32_t*)acc_NTT[0], (uint32_t*)poly_NTT, (uint32_t*)buff_NTT);
        }
    }
    NTT_inv_32(poly, (uint32_t*)acc_NTT[0]);
    newcount = hal_get_time();
    printcycles("Inner product (Dec):", newcount - oldcount);

    hal_send_str("#");

}



