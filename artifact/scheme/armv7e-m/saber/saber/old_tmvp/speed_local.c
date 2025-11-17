
#include "api.h"
#include "kem.h"
#include "SABER_params.h"
#include "SABER_indcpa.h"
#include "poly.h"
#include "poly_mul.h"
#include "sendfn.h"
#include "hal.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    uint16_t s[SABER_K][SABER_N];
    uint16_t b[SABER_K][SABER_N];
    uint16_t poly[SABER_N];
    polyvec A;

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    pol_mul(poly, s[0], b[0]);
    newcount = hal_get_time();
    printcycles("polymul:", newcount - oldcount);

    oldcount = hal_get_time();
    MatrixVectorMul(&A, s, b, 511, 0);
    newcount = hal_get_time();
    printcycles("MatrixVectorMul:", newcount - oldcount);

    oldcount = hal_get_time();
    InnerProd(s, b, 511, poly);
    newcount = hal_get_time();
    printcycles("InnerProd:", newcount - oldcount);

    hal_send_str("#");

}
