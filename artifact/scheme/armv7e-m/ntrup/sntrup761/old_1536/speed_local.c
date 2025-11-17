
#include "api.h"
#include "kem.h"
#include "sendfn.h"
#include "hal.h"
#include "Rq_mult.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define printcycles(S, U) send_unsignedll((S), (U))

uint64_t oldcount, newcount;
char out[128];

int main(void){

    int8_t g[768];
    int16_t f[768], fg[768];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    oldcount = hal_get_time();
    Rq_mult_small((Fq*)&fg, (Fq*)&f, (small*)&g);
    newcount = hal_get_time();
    printcycles("bigxsmall polymul cycles:", newcount - oldcount);


    hal_send_str("#");

}



