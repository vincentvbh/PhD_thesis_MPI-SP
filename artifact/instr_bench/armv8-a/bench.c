
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "cycles.h"

#define NTESTS 100000

uint64_t time0, time1;
uint64_t cycles[NTESTS];

extern void __asm_dup_w_to_vecB(void);
extern void __asm_dup_w_to_vecH(void);
extern void __asm_dup_w_to_vecS(void);
extern void __asm_dup_x_to_vecD(void);

extern void __asm_dup_B_to_vecB(void);
extern void __asm_dup_H_to_vecH(void);
extern void __asm_dup_S_to_vecS(void);
extern void __asm_dup_D_to_vecD(void);

extern void __asm_mov_w_to_B(void);
extern void __asm_mov_w_to_H(void);
extern void __asm_mov_w_to_S(void);
extern void __asm_mov_x_to_D(void);

extern void __asm_mov_S_to_w(void);
extern void __asm_mov_D_to_x(void);

extern void __asm_mov_B_to_B(void);
extern void __asm_mov_H_to_H(void);
extern void __asm_mov_S_to_S(void);
extern void __asm_mov_D_to_D(void);
extern void __asm_mov_8B_to_8B(void);
extern void __asm_mov_16B_to_16B(void);

extern void __asm_xtn_xtn2_8H(void);
extern void __asm_xtn_xtn2_4S(void);
extern void __asm_xtn_xtn2_2D(void);

extern void __asm_sri_D(void);
extern void __asm_sri_8B(void);
extern void __asm_sri_16B(void);
extern void __asm_sri_8H(void);
extern void __asm_sri_4H(void);
extern void __asm_sri_2S(void);
extern void __asm_sri_4S(void);
extern void __asm_sri_2D(void);

int main(void){

    init_counter();

    WRAP_FUNC("dup w to vecB",
              cycles, time0, time1,
              __asm_dup_w_to_vecB());

    WRAP_FUNC("dup w to vecH",
              cycles, time0, time1,
              __asm_dup_w_to_vecH());

    WRAP_FUNC("dup w to vecS",
              cycles, time0, time1,
              __asm_dup_w_to_vecS());

    WRAP_FUNC("dup x to vecD",
              cycles, time0, time1,
              __asm_dup_x_to_vecD());

    WRAP_FUNC("dup B to vecB",
              cycles, time0, time1,
              __asm_dup_B_to_vecB());

    WRAP_FUNC("dup B to vecH",
              cycles, time0, time1,
              __asm_dup_H_to_vecH());

    WRAP_FUNC("dup B to vecS",
              cycles, time0, time1,
              __asm_dup_S_to_vecS());

    WRAP_FUNC("dup B to vecD",
              cycles, time0, time1,
              __asm_dup_D_to_vecD());

    WRAP_FUNC("mov w to B",
              cycles, time0, time1,
              __asm_mov_w_to_B());

    WRAP_FUNC("mov w to H",
              cycles, time0, time1,
              __asm_mov_w_to_H());

    WRAP_FUNC("mov w to S",
              cycles, time0, time1,
              __asm_mov_w_to_S());

    WRAP_FUNC("mov x to D",
              cycles, time0, time1,
              __asm_mov_x_to_D());

    WRAP_FUNC("mov S to w",
              cycles, time0, time1,
              __asm_mov_S_to_w());

    WRAP_FUNC("mov D to x",
              cycles, time0, time1,
              __asm_mov_D_to_x());

    WRAP_FUNC("mov B to B",
              cycles, time0, time1,
              __asm_mov_B_to_B());

    WRAP_FUNC("mov H to H",
              cycles, time0, time1,
              __asm_mov_H_to_H());

    WRAP_FUNC("mov S to S",
              cycles, time0, time1,
              __asm_mov_S_to_S());

    WRAP_FUNC("mov D to D",
              cycles, time0, time1,
              __asm_mov_D_to_D());

    WRAP_FUNC("mov 16B to 16B",
              cycles, time0, time1,
              __asm_mov_16B_to_16B());

    WRAP_FUNC("mov 8B to 8B",
              cycles, time0, time1,
              __asm_mov_8B_to_8B());

    WRAP_FUNC("xtn, xtn2 8H",
              cycles, time0, time1,
              __asm_xtn_xtn2_8H());

    WRAP_FUNC("xtn, xtn2 4S",
              cycles, time0, time1,
              __asm_xtn_xtn2_4S());

    WRAP_FUNC("xtn, xtn2 2D",
              cycles, time0, time1,
              __asm_xtn_xtn2_2D());

    WRAP_FUNC("sri D",
              cycles, time0, time1,
              __asm_sri_D());

    WRAP_FUNC("sri 8B",
              cycles, time0, time1,
              __asm_sri_8B());

    WRAP_FUNC("sri 16B",
              cycles, time0, time1,
              __asm_sri_16B());

    WRAP_FUNC("sri 4H",
              cycles, time0, time1,
              __asm_sri_4H());

    WRAP_FUNC("sri 8H",
              cycles, time0, time1,
              __asm_sri_8H());

    WRAP_FUNC("sri 2S",
              cycles, time0, time1,
              __asm_sri_2S());

    WRAP_FUNC("sri 4S",
              cycles, time0, time1,
              __asm_sri_4S());

    WRAP_FUNC("sri 2D",
              cycles, time0, time1,
              __asm_sri_2D());

}
