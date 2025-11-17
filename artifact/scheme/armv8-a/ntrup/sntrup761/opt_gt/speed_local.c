#include <stdio.h>
#include <stdint.h>

#include "api.h"
#include "kem.h"
#include "params.h"
#include "sntrup_core.h"
#include "poly_arith.h"
#include "poly_recip.h"
#include "opt.h"
#include "polymul.h"

#if __APPLE__
#define __AVERAGE__
#define NTESTS 10000
#else
#define __MEDIAN__
#define NTESTS 1000
#endif
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    Fq finv[POLY_N], h[POLY_N], fg[POLY_N];
    small f[POLY_N], g[POLY_N], ginv[POLY_N];
    small e[POLY_N];
    small ev[POLY_N];
    int32_t fg_full[NTT_DIM_X * NTT_DIM_Y * NTT_DIM_Z];

    init_counter();

    WRAP_FUNC("mulcore",
            cycles, time0, time1,
            polymul(fg_full, finv, fg));

    WRAP_FUNC("Rq_mult_small",
            cycles, time0, time1,
            Rq_mult_small(h,finv,g));

    WRAP_FUNC("R3_recip",
            cycles, time0, time1,
            R3_recip(ginv,g));

    WRAP_FUNC("R3_mult",
            cycles, time0, time1,
            R3_mult(ev,e,ginv));

    WRAP_FUNC("Rq_recip3",
            cycles, time0, time1,
            Rq_recip3(finv,f));

    return 0;

}

