

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "poly.h"
#include "tc.h"
#include "batch_multiplication.h"

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

    poly src1, src2;
    poly des;

    init_counter();

    uint16_t tmp_ab[SB0 * 9 * 2];
    uint16_t tmp_c[SB0_RES * 9];
    uint16_t tmp_aabb[9*SB2*50+224*8*2], tmp_cc[9*SB2_RES*25+224*32]; // 50, 25
    uint16_t *tmp_aa = &tmp_aabb[9*SB2*0],
             *tmp_bb = &tmp_aabb[9*SB2*25+224*8],
             *tmp_aa1 = &tmp_aabb[9*SB2*25],
             *tmp_cc1 = &tmp_cc[9*SB2_RES*25];
    uint16_t *kaw[9], *kcw[9];


    kaw[0] = &tmp_ab[0 * SB0]; // A(0)
    kaw[1] = &tmp_ab[2 * SB0];
    kaw[2] = &tmp_ab[4 * SB0];
    kaw[3] = &tmp_ab[6 * SB0];
    kaw[4] = &tmp_ab[8 * SB0];
    kaw[5] = &tmp_ab[10 * SB0];
    kaw[6] = &tmp_ab[12 * SB0];
    kaw[7] = &tmp_ab[14 * SB0];
    kaw[8] = &tmp_ab[16 * SB0]; // A(f)

    // kcw
    kcw[0] = &tmp_c[0 * SB0_RES];
    kcw[1] = &tmp_c[1 * SB0_RES];
    kcw[2] = &tmp_c[2 * SB0_RES];
    kcw[3] = &tmp_c[3 * SB0_RES];
    kcw[4] = &tmp_c[4 * SB0_RES];
    kcw[5] = &tmp_c[5 * SB0_RES];
    kcw[6] = &tmp_c[6 * SB0_RES];
    kcw[7] = &tmp_c[7 * SB0_RES];
    kcw[8] = &tmp_c[8 * SB0_RES];


    WRAP_FUNC("polymul (Z_q[x] / (x^677 - 1))",
            cycles, time0, time1,
            poly_Rq_mul(&(des), &(src1), &(src2)));

    WRAP_FUNC("TC5 (x2)",
            cycles, time0, time1,
            tc5(kaw, &(src1.coeffs[0])));

    WRAP_FUNC("TC33 (x18)",
            cycles, time0, time1,
            tc33(&tmp_aa[0], kaw[0]));


    WRAP_FUNC("K2 (x2)",
            cycles, time0, time1,
            k2(&tmp_aa1[0], &tmp_aa[16]));

    WRAP_FUNC("schoolbook 8x8",
            cycles, time0, time1,
            schoolbook_8x8(&tmp_cc[32], &tmp_aa[16], &tmp_bb[16]));

    WRAP_FUNC("K2^{-1}",
            cycles, time0, time1,
            ik2(&tmp_cc[32], &tmp_cc1[0]));

    WRAP_FUNC("schoolbook 16x16",
            cycles, time0, time1,
            schoolbook_16x16(&tmp_cc[0], &tmp_aa[0] , &tmp_bb[0]));

    WRAP_FUNC("TC33^{-1} (x9)",
            cycles, time0, time1,
            itc33(kcw[0], &tmp_cc[0]));

    WRAP_FUNC("TC5^{-1}",
            cycles, time0, time1,
            itc5(tmp_ab, kcw));

  return 0;

}









