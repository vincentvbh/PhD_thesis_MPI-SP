#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "poly.h"

#define __AVERAGE__
#define NTESTS 10000
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    poly a, b, c;

    WRAP_FUNC("TC polymul",
              cycles, time0, time1,
              poly_Rq_mul(&c, &a, &b));

    WRAP_FUNC("R2 inv",
              cycles, time0, time1,
              poly_R2_inv(&b, &a));

    WRAP_FUNC("Rq inv",
              cycles, time0, time1,
              poly_Rq_inv(&b, &a));

    WRAP_FUNC("S3 inv",
              cycles, time0, time1,
              poly_S3_inv(&b, &a));

    return 0;

}

