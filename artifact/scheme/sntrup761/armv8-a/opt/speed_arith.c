
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "kem.h"
#include "sntrup_core.h"
#include "poly_arith.h"
#include "poly_recip.h"

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

int main(void)
{

    Fq finv[POLY_N], h[POLY_N];
    small g[POLY_N], ginv[POLY_N];
    small e[POLY_N];
    small ev[POLY_N];

    init_counter();

    WRAP_FUNC("R3_recip",
            cycles, time0, time1,
            R3_recip(ginv,g));

    WRAP_FUNC("Rq_mult_small",
            cycles, time0, time1,
            Rq_mult_small(h,finv,g));

    WRAP_FUNC("R3_mult",
            cycles, time0, time1,
            R3_mult(ev,e,ginv));

  return 0;

}






