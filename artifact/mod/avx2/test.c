
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "compress_ref.h"
#include "compress_old.h"
#include "compress_opt.h"

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

    poly_compress1_ref(ref, a);
    poly_compress1(res, a);
    assert(memcmp(ref, res, 32) == 0);
    poly_compress1_old(res, apos);
    assert(memcmp(ref, res, 32) == 0);
    poly_compress1_avx2(res, a);
    assert(memcmp(ref, res, 32) == 0);

    poly_compress4_ref(ref, a);
    poly_compress4(res, a);
    assert(memcmp(ref, res, 128) == 0);
    poly_compress4_old(res, apos);
    assert(memcmp(ref, res, 128) == 0);
    poly_compress4_avx2(res, a);
    assert(memcmp(ref, res, 128) == 0);

    poly_compress5_ref(ref, a);
    poly_compress5(res, a);
    assert(memcmp(ref, res, 160) == 0);
    poly_compress5_old(res, apos);
    assert(memcmp(ref, res, 160) == 0);
    poly_compress5_avx2(res, a);
    assert(memcmp(ref, res, 160) == 0);

    poly_compress10_ref(ref, a);
    poly_compress10(res, a);
    assert(memcmp(ref, res, 320) == 0);
    poly_compress10_old(res, apos);
    assert(memcmp(ref, res, 320) == 0);
    poly_compress10_avx2(res, a);
    assert(memcmp(ref, res, 320) == 0);

    poly_compress11_ref(ref, a);
    poly_compress11(res, a);
    assert(memcmp(ref, res, 352) == 0);
    poly_compress11_old(res, apos);
    assert(memcmp(ref, res, 352) == 0);
    poly_compress11_avx2(res, a);
    assert(memcmp(ref, res, 352) == 0);

    printf("Test finished!\n");

}

