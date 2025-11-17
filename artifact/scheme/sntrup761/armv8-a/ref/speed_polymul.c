
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "kem.h"
#include "sntrup_core.h"
#include "poly_arith.h"

#if __APPLE__
#define __AVERAGE__
#define NTESTS 1000000
#else
#define __MEDIAN__
#define NTESTS 1000
#endif
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main()
{

    int16_t big_src[POLY_N];
    int8_t small_src[POLY_N];
    int16_t res[POLY_N];

    init_counter();

    WRAP_FUNC("polymul (Z_q[x] / (x^761 - x - 1))",
            cycles, time0, time1,
            Rq_mult_small(res, big_src, small_src));




  return 0;

}






