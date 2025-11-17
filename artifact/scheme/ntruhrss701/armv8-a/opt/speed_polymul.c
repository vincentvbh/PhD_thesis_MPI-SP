

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "poly.h"
#include "tmvp.h"
#include "batch_multiplication.h"

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

    poly src1, src2;
    poly des;

    uint16_t tmp[SB0 * 9 * 3]; // SB0 = 144
    uint16_t *toepa = &tmp[0 * SB0]; /* nine 144*144 toeplitz matrix, needs nine length-288 vectors to store */
    uint16_t *kbw   = &tmp[18* SB0]; /* nine 144*144 vectors*/

    init_counter();

    WRAP_FUNC("polymul (Z_q[x] / (x^701 - 1))",
            cycles, time0, time1,
            poly_Rq_mul(&(des), &(src1), &(src2)));

    WRAP_FUNC("(TC5^{-1})^*",
            cycles, time0, time1,
            ittc5(toepa, &(src1.coeffs[0])));

    WRAP_FUNC("TC5",
            cycles, time0, time1,
            tc5(kbw, &(src2.coeffs[0])));

    WRAP_FUNC("TMVP 144",
            cycles, time0, time1,
            tmvp_144_ka33_ka2(&kbw[0], &toepa[0]));

    WRAP_FUNC("TC5^*",
            cycles, time0, time1,
            ttc5(&(des.coeffs[0]), kbw));




  return 0;

}









