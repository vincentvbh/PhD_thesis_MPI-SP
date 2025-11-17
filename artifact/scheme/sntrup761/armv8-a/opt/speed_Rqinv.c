
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

    Fq finv[POLY_N];
    small f[POLY_N];

    init_counter();

    WRAP_FUNC("Rq_recip3",
            cycles, time0, time1,
            Rq_recip3(finv,f));

  return 0;

}






