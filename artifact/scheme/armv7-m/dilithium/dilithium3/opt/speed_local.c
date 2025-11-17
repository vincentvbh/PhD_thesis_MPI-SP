
#include "api.h"
#include "sign.h"
#include "sendfn.h"
#include "hal.h"
#include "ntt.h"
#include "poly.h"
#include "polyvec.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    polyvecl A_row, s1;
    polyveck As1;

    int32_t a[N];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    ntt(a);
    newcount = hal_get_time();
    printcycles("Constant-time Dilithium NTT:", newcount - oldcount);

    oldcount = hal_get_time();
    ntt_fast(a);
    newcount = hal_get_time();
    printcycles("Variable-time Dilithium NTT:", newcount - oldcount);

    oldcount = hal_get_time();
    invntt_tomont(a);
    newcount = hal_get_time();
    printcycles("Constant-time Dilithium iNTT:", newcount - oldcount);

    oldcount = hal_get_time();
    invntt_tomont_fast(a);
    newcount = hal_get_time();
    printcycles("Variable-time Dilithium iNTT:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_pointwise_acc_montgomery(&As1.vec[0], &A_row, &s1);
    newcount = hal_get_time();
    printcycles("Constant-time Dilithium inner product L:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_pointwise_acc_montgomery_fast(&As1.vec[0], &A_row, &s1);
    newcount = hal_get_time();
    printcycles("Variable-time Dilithium inner product L:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_ntt(&s1);
    for(size_t i = 0; i < K; i++){
        polyvecl_pointwise_acc_montgomery(&As1.vec[i], &A_row, &s1);
        poly_reduce(&As1.vec[i]);
        poly_invntt_tomont(&As1.vec[i]);
    }
    newcount = hal_get_time();
    printcycles("Constant-time Dilithium matrix-vector multiplication:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_ntt_fast(&s1);
    for(size_t i = 0; i < K; i++){
        polyvecl_pointwise_acc_montgomery_fast(&As1.vec[i], &A_row, &s1);
        poly_reduce(&As1.vec[i]);
        poly_invntt_tomont_fast(&As1.vec[i]);
    }
    newcount = hal_get_time();
    printcycles("Variable-time Dilithium matrix-vector multiplication:", newcount - oldcount);

    hal_send_str("#");

}





