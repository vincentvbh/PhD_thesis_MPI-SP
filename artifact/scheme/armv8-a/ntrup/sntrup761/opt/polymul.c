
#include "polymul.h"
#include "ntt.h"
#include "NTT_params.h"

#include <arm_neon.h>

void mulcore(int16_t *des, const int16_t *src1, const int16_t *src2){

    __attribute__ ((aligned (16)))int16_t src1_NTT[1536];
    __attribute__ ((aligned (16)))int16_t src2_NTT[1536];

    __asm_rader17_primitive(src1_NTT, src1, twiddle_rader17_permuted, constants);
    __asm_rader17_primitive(src2_NTT, src2, twiddle_rader17_permuted, constants);

    __asm_3x2_twistx2(src1_NTT, twist_table_lohi, twist_16x6x16_table_lohi, _3x2_twiddle);
    __asm_3x2_twistx2(src2_NTT, twist_table_lohi, twist_16x6x16_table_lohi, _3x2_twiddle);

    __asm_Toeplitz_CT_cyclic16_flexible(src1_NTT, src1_NTT, src2_NTT, constants, 32 * sizeof(int16_t), 768 / 16);
    __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(src1_NTT + 16, src1_NTT + 16, src2_NTT + 16, constants,
                                                            32 * sizeof(int16_t), 768 / 16);

    __asm_3x2_twistx2(src1_NTT, twist_16x6x16_inv_table_lohi, twist_inv_table_lohi, _3x2_itwiddle);

    __asm_irader17_primitive(des, src1_NTT, twiddle_irader17_permuted, constants);

}

void polymul(int16_t *des, const int16_t *src1, const int16_t *src2){

    int16x8_t ti, tip, tip1, lo, hi;
    int16x8_t tmp;

    mulcore(des, src1, src2);

    tmp[0] = FINAL_SCALE;
    tmp[1] = FINAL_SCALE_hi;
    tmp[2] = Q;
    tmp[3] = Qbar;

    des[0] -= des[761 - 1];
    for(size_t i = 0; i < 768; i += 8){
        ti = vld1q_s16(des + i);
        tip = vld1q_s16(des + i + 761);
        tip1 = vld1q_s16(des + i + 761 - 1);
        ti = ti + tip + tip1;
        lo = vmulq_n_s16(ti, tmp[0]);
        hi = vqrdmulhq_n_s16(ti, tmp[1]);
        lo = vmlsq_n_s16(lo, hi, tmp[2]);
        hi = vqdmulhq_n_s16(lo, tmp[3]);
        hi = vrshrq_n_s16(hi, 12);
        lo = vmlsq_n_s16(lo, hi, tmp[2]);
        vst1q_s16(des + i, lo);
    }

}


