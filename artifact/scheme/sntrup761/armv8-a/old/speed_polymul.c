
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "kem.h"
#include "poly_arith.h"
#include "polymul/NTT_params.h"
#include "polymul/polymul.h"
#include "polymul/rader.h"
#include "polymul/poly_basic.h"
#include "polymul/poly_vec.h"

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

int main(void)
{

    int16_t src1[POLY_N], src2[POLY_N];
    int16_t des[POLY_N];

    init_counter();

    WRAP_FUNC("polymul (Z_q[x] / (x^1632 - 1))",
            cycles, time0, time1,
            polymul(des, src1, src2));



  return 0;

}






