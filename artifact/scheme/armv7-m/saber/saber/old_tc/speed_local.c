
#include "api.h"
#include "kem.h"
#include "SABER_params.h"
#include "poly.h"
#include "sendfn.h"
#include "hal.h"

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    uint16_t poly[SABER_N];
    uint16_t acc[SABER_L][SABER_N];
    uint16_t A[SABER_N];
    uint16_t s[SABER_N];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    polymul(acc[0], s, poly);
    newcount = hal_get_time();
    printcycles("polymul cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        if (i == 0) {
            polymul(acc[i], s, A);
        } else {
            polymla(acc[i], s, A);
        }
    }
    newcount = hal_get_time();
    printcycles("Inner product speed opt cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    for (size_t i = 0; i < SABER_L; i++) {
        for (size_t j = 0; j < SABER_L; j++) {
            if (j == 0) {
                polymul(acc[j], s, A);
            } else {
                polymla(acc[j], s, A);
            }
        }
    }
    newcount = hal_get_time();
    printcycles("MatrixVectorMul speed opt cycles:", newcount - oldcount);

    hal_send_str("#");

}

