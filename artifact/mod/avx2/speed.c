
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "compress_ref.h"
#include "compress_old.h"
#include "compress_opt.h"

#define __AVERAGE__
#include "cycles.h"

#define NTESTS 100000

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    __attribute__ ((aligned(32))) int16_t a[KYBER_N];
    __attribute__ ((aligned(32))) int16_t apos[KYBER_N];
    __attribute__ ((aligned(32))) uint8_t ref[352];
    __attribute__ ((aligned(32))) uint8_t res[352];

    for(size_t i = 0; i < KYBER_N; i++){
        a[i] = rand() % KYBER_Q;
        a[i] -= KYBER_Q / 2;
        apos[i] = a[i];
        if(apos[i] < 0){
            apos[i] += KYBER_Q;
        }
    }

    WRAP_FUNC("poly_compress1 ref",
              cycles, time0, time1,
              poly_compress1_ref(ref, a));

    WRAP_FUNC("poly_compress1",
              cycles, time0, time1,
              poly_compress1(res, a));

    WRAP_FUNC("poly_compress1 old",
              cycles, time0, time1,
              poly_compress1_old(res, apos));

    WRAP_FUNC("poly_compress1 avx2",
              cycles, time0, time1,
              poly_compress1_avx2(res, a));

    WRAP_FUNC("poly_compress4 ref",
              cycles, time0, time1,
              poly_compress4_ref(ref, a));

    WRAP_FUNC("poly_compress4",
              cycles, time0, time1,
              poly_compress4(res, a));

    WRAP_FUNC("poly_compress4 old",
              cycles, time0, time1,
              poly_compress4_old(res, apos));

    WRAP_FUNC("poly_compress4 avx2",
              cycles, time0, time1,
              poly_compress4_avx2(res, a));

    WRAP_FUNC("poly_compress5 ref",
              cycles, time0, time1,
              poly_compress5_ref(ref, a));

    WRAP_FUNC("poly_compress5",
              cycles, time0, time1,
              poly_compress5(res, a));

    WRAP_FUNC("poly_compress5 old",
              cycles, time0, time1,
              poly_compress5_old(res, apos));

    WRAP_FUNC("poly_compress5 avx2",
              cycles, time0, time1,
              poly_compress5_avx2(res, a));

    WRAP_FUNC("poly_compress10 ref",
              cycles, time0, time1,
              poly_compress10_ref(ref, a));

    WRAP_FUNC("poly_compress10",
              cycles, time0, time1,
              poly_compress10(res, a));

    WRAP_FUNC("poly_compress10 old",
              cycles, time0, time1,
              poly_compress10_old(res, apos));

    WRAP_FUNC("poly_compress10 avx2",
              cycles, time0, time1,
              poly_compress10_avx2(res, a));

    WRAP_FUNC("poly_compress11 ref",
              cycles, time0, time1,
              poly_compress11_ref(ref, a));

    WRAP_FUNC("poly_compress11",
              cycles, time0, time1,
              poly_compress11(res, a));

    WRAP_FUNC("poly_compress11 old",
              cycles, time0, time1,
              poly_compress11_old(res, apos));

    WRAP_FUNC("poly_compress11 avx2",
              cycles, time0, time1,
              poly_compress11_avx2(res, a));

}

