
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include <arm_neon.h>

#include "cycles.h"

#define NTESTS 100000
uint64_t time0, time1;
uint64_t cycles[NTESTS];

// iter must even
extern void __asm_trn8x8_full(int16_t *des, const int16_t *src, const size_t iter);

extern void __asm_Karatsuba8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Karatsuba_negacyclic8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

extern void __asm_Toeplitz_negacyclic8_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

// iter must be even > 0
extern void __asm_Toeplitz_negacyclic8_Z65536_flexible(int16_t *c, const int16_t *a, const int16_t *b,
                                                       const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype(int16_t *c, const int16_t *a, const int16_t *b);

// iter must be even > 0
extern void __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible(int16_t *c, const int16_t *a, const int16_t *b,
                                                                  const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_negacyclic8_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_negacyclic8_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_CT_cyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_CT_cyclic16_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                const size_t next_bytes, size_t iter);

extern void __asm_Toeplitz_Karatsuba_negacyclic16_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                           const size_t next_bytes, size_t iter);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                                    const size_t next_bytes, size_t iter);

// ================
// Z_Q

#define Q 4591

// R = 65536 below
// R mod Q
#define RmodQ (1262)
// -Q^{-1} mod R
#define Qprime (-15631)

static const int16_t constants[8] = {
Q, Qprime
};

#define ARRAY_N 2048

#define MASK (0x3ff)

int main(void){

    int16_t a[ARRAY_N], b[ARRAY_N];
    int16_t aNeon[ARRAY_N], bNeon[ARRAY_N];
    int16_t res[2 * ARRAY_N];
    int16_t resNeon[2 * ARRAY_N];

    for(size_t i = 0; i < ARRAY_N; i++){
        a[i] = rand() & MASK;
        b[i] = rand() & MASK;
    }

    init_counter();

// ================================
// Z_65536

    printf("Z_65536\n");

// ================
// size-8 polynomial multiplication

    WRAP_FUNC("Karatsuba long Z65536 8x8",
              cycles, time0, time1,
              __asm_Karatsuba8x8_Z65536_prototype(resNeon, aNeon, bNeon));

// ========

    WRAP_FUNC("Karatsuba negacyclic Z65536 8x8",
              cycles, time0, time1,
              __asm_Karatsuba_negacyclic8x8_Z65536_prototype(resNeon, aNeon, bNeon));

// ========

    // ARRAY_N / 64 = 32
    WRAP_FUNC("32 transpose Z65536 8x8",
              cycles, time0, time1,
              __asm_trn8x8_full(aNeon, a, ARRAY_N / 64));

// ========

    WRAP_FUNC("Karatsuba striding negacyclic Z65536 8x8",
              cycles, time0, time1,
              __asm_Karatsuba_striding_negacyclic8x8_Z65536_prototype(resNeon, aNeon, bNeon));

// ========

    WRAP_FUNC("Toeplitz negacyclic Z65536 8",
              cycles, time0, time1,
              __asm_Toeplitz_negacyclic8_Z65536_prototype(res, a, b));

// ========

    // ARRAY_N / 8 = 256
    WRAP_FUNC("256 Toeplitz negacyclic Z65536 8",
              cycles, time0, time1,
              __asm_Toeplitz_negacyclic8_Z65536_flexible(res, a, b, 8 * sizeof(int16_t), ARRAY_N / 8));

// ================
// size-16 polynomial multiplication

// ========

    WRAP_FUNC("Toeplitz-Karatsuba negacyclic Z65536 16",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_prototype(res, a, b));

// ========

    // ARRAY_N / 16 = 128
    WRAP_FUNC("128 Toeplitz-Karatsuba negacyclic Z65536 16",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_Z65536_flexible(res, a, b, 16 * sizeof(int16_t), ARRAY_N / 16));

// ================================
// Z_Q

    printf("Z_Q\n");

// ================
// size-8 polynomial multiplication

// ========

    WRAP_FUNC("Toeplitz negacyclic 8",
              cycles, time0, time1,
              __asm_Toeplitz_negacyclic8_prototype(res, a, b, constants));

// ========

    // ARRAY_N / 8 = 256
    WRAP_FUNC("256 Toeplitz negacyclic 8",
              cycles, time0, time1,
              __asm_Toeplitz_negacyclic8_flexible(res, a, b, constants, 8 * sizeof(int16_t), ARRAY_N / 8));

// ================
// size-16 polynomial multiplication

// ========

    WRAP_FUNC("Toeplitz CT cyclic 16",
              cycles, time0, time1,
              __asm_Toeplitz_CT_cyclic16_prototype(res, a, b, constants));

// ========

    WRAP_FUNC("128 Toeplitz CT cyclic 16",
              cycles, time0, time1,
              __asm_Toeplitz_CT_cyclic16_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16));

// ========

    WRAP_FUNC("Toeplitz negacyclic 16",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_prototype(res, a, b, constants));

// ========

    WRAP_FUNC("Toeplitz Karatsuba negacyclic 16",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_prototype(res, a, b, constants));

// ========

    WRAP_FUNC("128 Toeplitz Karatsuba negacyclic 16",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16));

// ========

    WRAP_FUNC("Toeplitz Karatsuba negacyclic 16 with doubling",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_doubling_prototype(res, a, b, constants));

// ========

    WRAP_FUNC("128 Toeplitz Karatsuba negacyclic 16 with doubling",
              cycles, time0, time1,
              __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(res, a, b, constants, 16 * sizeof(int16_t), ARRAY_N / 16));

// ========

}




