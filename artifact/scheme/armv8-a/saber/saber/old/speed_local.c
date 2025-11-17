
/*
 * CC0 1.0 Universal or the following MIT License
 *
 * MIT License
 *
 * Copyright (c) 2023: Hanno Becker, Vincent Hwang, Matthias J. Kannwischer, Bo-Yin Yang, and Shang-Yi Yang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "cbd.h"
#include "SABER_params.h"
#include "NTT.h"

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

int main(void){

    uint32_t A_NTT[SABER_L][SABER_L][SABER_N];
    uint32_t s_NTT_asymmetric[SABER_L][SABER_N];
    uint32_t s_NTT[SABER_L][SABER_N];
    uint32_t acc_NTT[SABER_L][SABER_N];

    // setup cycles
    init_counter();

    WRAP_FUNC("NTT",
            cycles, time0, time1,
            NTT(s_NTT[0]));

    WRAP_FUNC("NTT heavy",
            cycles, time0, time1,
            NTT_heavy(s_NTT_asymmetric[0], s_NTT[0]));

    WRAP_FUNC("asymmetric_mul",
            cycles, time0, time1,
            __asm_asymmetric_mul(&(A_NTT[0][0][0]), &(s_NTT[0][0]), &(s_NTT_asymmetric[0][0]), constants));

    WRAP_FUNC("iNTT",
            cycles, time0, time1,
            iNTT(acc_NTT[0]));

    WRAP_FUNC("Matrix vector multiplication",
            cycles, time0, time1,
            for(size_t j = 0;j < SABER_L; j++){ \
                for(size_t k = 0;k < SABER_L; k++){ \
                    NTT(A_NTT[j][k]); \
                } \
            } \
            for(size_t j = 0; j < SABER_L; j++){ \
                NTT_heavy(s_NTT_asymmetric[j], s_NTT[j]); \
            } \
            for(size_t j = 0; j < SABER_L; j++){ \
                __asm_asymmetric_mul(&(A_NTT[j][0][0]), &(s_NTT[0][0]), &(s_NTT_asymmetric[0][0]), constants); \
            } \
            for(size_t j = 0; j < SABER_L; j++){ \
                iNTT(&(A_NTT[j][0][0])); \
            })

    WRAP_FUNC("InnerProd(Enc)",
            cycles, time0, time1,
            for(size_t j = 0; j < SABER_L; j++){ \
                NTT(A_NTT[0][j]); \
            } \
            __asm_asymmetric_mul(&(A_NTT[0][0][0]), &(s_NTT[0][0]), &(s_NTT_asymmetric[0][0]), constants); \
            iNTT(&(A_NTT[0][0][0])));

    WRAP_FUNC("InnerProd(Dec)",
            cycles, time0, time1,
            for(size_t j = 0; j < SABER_L; j++){ \
                NTT(A_NTT[0][j]); \
            } \
            for(size_t j = 0; j < SABER_L; j++){ \
                NTT_heavy(s_NTT_asymmetric[j], s_NTT[j]); \
            } \
            __asm_asymmetric_mul(&(A_NTT[0][0][0]), &(s_NTT[0][0]), &(s_NTT_asymmetric[0][0]), constants); \
            iNTT(&(A_NTT[0][0][0])));

  return 0;
}
