
#include "api.h"
#include "sign.h"
#include "params.h"
#include "sendfn.h"
#include "hal.h"
#include "poly.h"
#include "polyvec.h"
#include "smallntt.h"
#include "smallpoly.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    polyvecl A;
    polyvecl s, cs1;
    polyveck As;
    poly a, b, c, cs2;
    smallpoly c_small, s1[L], s2;
    smallhalfpoly c_small_prime;

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    poly_ntt(&a);
    newcount = hal_get_time();
    printcycles("NTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    poly_pointwise_montgomery(&c, &a, &b);
    newcount = hal_get_time();
    printcycles("basemul cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    poly_invntt_tomont(&a);
    newcount = hal_get_time();
    printcycles("iNTT cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_pointwise_acc_montgomery(&As.vec[0], &A, &s);
    newcount = hal_get_time();
    printcycles("Inner product L:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_ntt(&s);
    for(size_t i = 0; i < K; i++){
        polyvecl_pointwise_acc_montgomery(&As.vec[i], &A, &s);
    }
    polyveck_invntt_tomont(&As);
    newcount = hal_get_time();
    printcycles("Matrix-vector multiplication:", newcount - oldcount);

    oldcount = hal_get_time();
    small_ntt((int16_t*)&c_small);
    newcount = hal_get_time();
    printcycles("small NTT:", newcount - oldcount);

    oldcount = hal_get_time();
    small_ntt((int16_t*)&c_small);
    small_point_mul((int16_t*)&c_small_prime, (const int16_t*)&c_small);
    newcount = hal_get_time();
    printcycles("small NTT heavy:", newcount - oldcount);

    oldcount = hal_get_time();
    small_asymmetric_mul((int16_t*)&cs2, (const int16_t*)&c_small, (const int16_t*)&c_small_prime, (const int16_t*)&s2);
    newcount = hal_get_time();
    printcycles("small asymmetric mul:", newcount - oldcount);

    oldcount = hal_get_time();
    small_invntt_tomont((int16_t*)&c_small);
    newcount = hal_get_time();
    printcycles("small iNTT:", newcount - oldcount);

    oldcount = hal_get_time();
    polyvecl_small_basemul_invntt(&cs1, &c_small, &c_small_prime, (const smallpoly*)&s1);
    newcount = hal_get_time();
    printcycles("c s1:", newcount - oldcount);

    oldcount = hal_get_time();
    for(size_t i = 0; i < K; i++){
        poly_small_basemul_invntt(&cs2, &c_small, &c_small_prime, &s2);
    }
    newcount = hal_get_time();
    printcycles("c s2:", newcount - oldcount);

    hal_send_str("#");

}



