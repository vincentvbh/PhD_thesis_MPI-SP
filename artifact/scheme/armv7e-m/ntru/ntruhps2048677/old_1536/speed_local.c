
#include "api.h"
#include "kem.h"
#include "sendfn.h"
#include "hal.h"
#include "poly.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    poly a, b, c;

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    poly_Rq_mul(&c, &a, &b);
    newcount = hal_get_time();
    printcycles("TMVP cycles:", newcount - oldcount);

    oldcount = hal_get_time();
    poly_SignedZ3_Rq_mul(&c, &a, &b);
    newcount = hal_get_time();
    printcycles("NTT polymul cycles:", newcount - oldcount);

    hal_send_str("#");

}



