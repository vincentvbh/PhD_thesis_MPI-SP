
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "poly.h"

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

    poly a, b, c;
    poly f, invf;

    init_counter();

    WRAP_FUNC("poly_Rq_inv",
            cycles, time0, time1,
            poly_Rq_inv(&invf, &f));
    WRAP_FUNC("poly_R2_inv",
            cycles, time0, time1,
            poly_R2_inv(&b, &a));
    WRAP_FUNC("poly_S3_inv",
            cycles, time0, time1,
            poly_S3_inv(&invf, &f));
    WRAP_FUNC("poly_Rq_mul",
            cycles, time0, time1,
            poly_Rq_mul(&c, &a, &b));
    WRAP_FUNC("poly_S3_mul",
            cycles, time0, time1,
            poly_S3_mul(&c, &a, &b));

  return 0;

}

