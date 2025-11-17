
#include "api.h"
#include "kem.h"
#include "SABER_params.h"
#include "sendfn.h"
#include "hal.h"
#include "Hom.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    int32_t poly1[SABER_N], poly2[SABER_N];
    int32_t res[SABER_N];
    int32_t poly_Hom_M[32 * 7 * 8], poly_Hom_V[32 * 7 * 4];
    int32_t res_MV[32 * 7 * 4];
    int32_t acc[SABER_L][SABER_N];
    int32_t acc_Hom[SABER_L][32 * 7 * 4];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    Hom_M(poly_Hom_M, poly2);
    newcount = hal_get_time();
    printcycles("Hom_M cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    Hom_V(poly_Hom_V, poly1);
    newcount = hal_get_time();
    printcycles("Hom_V cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    __asm_TMVP_mul_4x4_full(res_MV, poly_Hom_M, poly_Hom_V);
    newcount = hal_get_time();
    printcycles("BiHom cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    Hom_I(res, res_MV);
    newcount = hal_get_time();
    printcycles("Hom_I cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t i = 0; i < SABER_L; i++){
        Hom_M(poly_Hom_M, poly2);
        for(size_t j = 0; j < SABER_L; j++){
            Hom_V(poly_Hom_V, poly1);
            if(i == 0){
                __asm_TMVP_mul_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }else{
                __asm_TMVP_mla_4x4_full(&acc_Hom[i][0], poly_Hom_M, poly_Hom_V);
            }
        }
    }
    for(size_t i = 0; i < SABER_L; i++){
        Hom_I(&acc[i][0], &acc_Hom[i][0]);
    }
    newcount = hal_get_time();
    printcycles("Matrix-vector multiplication:", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t i = 0; i < SABER_L; i++){
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    printcycles("Inner product (Enc):", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t i = 0; i < SABER_L; i++){
        Hom_M(poly_Hom_M, poly2);
        Hom_V(poly_Hom_V, poly1);
        if(i == 0){
            __asm_TMVP_mul_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }else{
            __asm_TMVP_mla_4x4_full(&acc_Hom[0][0], poly_Hom_M, poly_Hom_V);
        }
    }
    Hom_I(&acc[0][0], &acc_Hom[0][0]);
    newcount = hal_get_time();
    printcycles("Inner product (Dec):", newcount - oldcount);

    hal_send_str("#");

}



