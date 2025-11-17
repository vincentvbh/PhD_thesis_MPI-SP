

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

    uint16_t tmp[SB0 * 9 * 4]; // SB0 = 144
    uint16_t toepa3[SB1 * 5 * 2]; // SB1 = 48

    uint16_t *toepa = &tmp[0 * SB0]; /* nine 144*144 toeplitz matrix, needs nine length-288 vectors to store */
    uint16_t *kbw   = &tmp[18* SB0]; /* nine 144*144 vectors*/
    uint16_t *kcw   = &tmp[27* SB0]; /* nine 144*144 vectors*/
    uint16_t *toepa332 = &tmp[5 * 5 * SB2 * 0];
    uint16_t *kbcw = &tmp[5 * 5 * SB2 * 3];

    init_counter();

    WRAP_FUNC("polymul (Z_q[x] / (x^677 - 1))",
            cycles, time0, time1,
            poly_Rq_mul(&(des), &(src1), &(src2)));

    WRAP_FUNC("(TC5^{-1})^*",
            cycles, time0, time1,
            ittc5(toepa, &(src1.coeffs[0])));

    WRAP_FUNC("TC5",
            cycles, time0, time1,
            tc5(kbw, &(src2.coeffs[0])));

    WRAP_FUNC("(TC3^{-1})^* (x9)",
            cycles, time0, time1,
            ittc3(toepa3,  toepa));

    WRAP_FUNC("(TC32^{-1})^* (x9)",
            cycles, time0, time1,
            ittc32(toepa332, toepa3));

    WRAP_FUNC("TC33 (x9)",
            cycles, time0, time1,
            tc33(kbcw, kbw));

    WRAP_FUNC("TMVP2_8x8 (x9)",
            cycles, time0, time1,
            tmvp2_8x8(kbcw, toepa332));

    WRAP_FUNC("TC33^* (x9)",
            cycles, time0, time1,
            ttc33(kcw, kbcw));

    WRAP_FUNC("TC5^*",
            cycles, time0, time1,
            ttc5(&(des.coeffs[0]), kcw));




  return 0;

}









