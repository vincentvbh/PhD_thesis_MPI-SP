#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include <stddef.h>

extern const int16_t constants[8];

extern const int16_t _3x2_twiddle[8];

extern const int16_t _3x2_itwiddle[8];

extern const int16_t twiddle_rader17_permuted[16];

extern const int16_t twiddle_irader17_permuted[16];

extern const int16_t twist_table_lohi[2 * 16 * 96];

extern const int16_t twist_inv_table_lohi[2 * 16 * 96];

extern const int16_t twist_16x6x16_table_lohi[2 * 16 * 6 * 16];

extern const int16_t twist_16x6x16_inv_table_lohi[2 * 16 * 6 * 16];

extern void __asm_3x2_twistx2(int16_t *src, const int16_t *table1, const int16_t *table2, const int16_t *_constants);
extern void __asm_rader17_primitive(int16_t *des, const int16_t *src, const int16_t *table, const int16_t *_constants);
extern void __asm_irader17_primitive(int16_t *des, const int16_t *src, const int16_t *table, const int16_t *_constants);

extern void __asm_Toeplitz_CT_cyclic16_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                const size_t next_bytes, size_t iter);
extern void __asm_Toeplitz_Karatsuba_negacyclic16_doubling_flexible(int16_t *des, const int16_t *src1, const int16_t *src2, const int16_t *_constants,
                                                                    const size_t next_bytes, size_t iter);

#endif

