/* Based on supercop-20200702/crypto_core/invhrss701/simpler/core.c */

#include "poly.h"

#include <arm_neon.h>

#include <stdio.h>

// static inline uint8_t mod3(uint8_t a) { /* a between 0 and 9 */
//     int16_t t, c;
//     a = (a >> 2) + (a & 3); /* between 0 and 4 */
//     t = a - 3;
//     c = t >> 5;
//     return (uint8_t) (t ^ (c & (a ^ t)));
// }

static inline uint8_t signed_mod3(uint8_t a) { /* a between 0 and 9 */
    int16_t t, c;
    a = (a >> 2) + (a & 3); /* between 0 and 4 */
    t = a - 3;
    c = t >> 5;
    t = t ^ (c & (a ^ t));
    t |= t >> 1;
    return t;
}

/*

    00    01    11

00  00    00    00

01  00    01    11

11  00    11    01

clo = alo & blo
chi = (ahi ^ bhi) & clo

*/

// signed Z3
static inline void mul_Z3_bitsliced(uint64_t *ptr_clo, uint64_t *ptr_chi,
    uint64_t *ptr_alo, uint64_t *ptr_ahi, uint64_t *ptr_blo, uint64_t *ptr_bhi){

    uint64_t alo, ahi;
    uint64_t blo, bhi;
    uint64_t nonzero;

    alo = *ptr_alo;
    ahi = *ptr_ahi;
    blo = *ptr_blo;
    bhi = *ptr_bhi;

    nonzero = alo & blo;

    *ptr_clo = nonzero;
    *ptr_chi = (ahi ^ bhi) & nonzero;

}

static inline void mul_Z3_bitsliced_uint8x16(uint8x16_t *ptr_clo, uint8x16_t *ptr_chi,
    uint8x16_t *ptr_alo, uint8x16_t *ptr_ahi, uint8x16_t *ptr_blo, uint8x16_t *ptr_bhi){

    uint8x16_t alo, ahi;
    uint8x16_t blo, bhi;
    uint8x16_t nonzero;

    alo = *ptr_alo;
    ahi = *ptr_ahi;
    blo = *ptr_blo;
    bhi = *ptr_bhi;

    nonzero = alo & blo;

    *ptr_clo = nonzero;
    *ptr_chi = (ahi ^ bhi) & nonzero;

}

/*

    00    01    11

00  00    01    11

01  01    11    00

11  11    00    01

clo = (alo ^ blo) | (alo ^ ahi ^ bhi)
chi = (alo ^ bhi) & (ahi ^ blo)

*/

// signed Z3
static inline void add_Z3_bitsliced(uint64_t *ptr_clo, uint64_t *ptr_chi,
    uint64_t *ptr_alo, uint64_t *ptr_ahi, uint64_t *ptr_blo, uint64_t *ptr_bhi){

    uint64_t alo, ahi;
    uint64_t blo, bhi;
    uint64_t t;

    alo = *ptr_alo;
    ahi = *ptr_ahi;
    blo = *ptr_blo;
    bhi = *ptr_bhi;

    t = alo ^ bhi;

    *ptr_clo = (alo ^ blo) | (t ^ ahi);
    *ptr_chi = t & (ahi ^ blo);

}

static inline void add_Z3_bitsliced_uint8x16(uint8x16_t *ptr_clo, uint8x16_t *ptr_chi,
    uint8x16_t *ptr_alo, uint8x16_t *ptr_ahi, uint8x16_t *ptr_blo, uint8x16_t *ptr_bhi){

    uint8x16_t alo, ahi;
    uint8x16_t blo, bhi;
    uint8x16_t t;

    alo = *ptr_alo;
    ahi = *ptr_ahi;
    blo = *ptr_blo;
    bhi = *ptr_bhi;

    t = alo ^ bhi;

    *ptr_clo = (alo ^ blo) | (t ^ ahi);
    *ptr_chi = t & (ahi ^ blo);

}

void poly_S3_inv(poly *r, const poly *a) {

    uint64_t flo[11], fhi[11];
    uint64_t glo[11], ghi[11];
    uint64_t vlo[11], vhi[11];
    uint64_t wlo[11], whi[11];

    uint64_t swapx64;
    uint64_t t0x64, t1x64;
    uint64_t tlo, thi;
    uint64_t signlo, signhi;

    uint8_t g[NTRU_N];

    size_t loop;
    int16_t delta, swap;
    int8_t sign;
    int8_t f0, g0;

    uint8x16_t swapx128;
    uint8x16_t tlol, thil;
    uint8x16_t signlol, signhil;
    uint8x16_t t0x128, t1x128;

    uint8x16_t *flol, *fhil;
    uint8x16_t *glol, *ghil;
    uint8x16_t *vlol, *vhil;
    uint8x16_t *wlol, *whil;

    flol = (uint8x16_t*)flo;
    fhil = (uint8x16_t*)fhi;
    glol = (uint8x16_t*)glo;
    ghil = (uint8x16_t*)ghi;
    vlol = (uint8x16_t*)vlo;
    vhil = (uint8x16_t*)vhi;
    wlol = (uint8x16_t*)wlo;
    whil = (uint8x16_t*)whi;


    for(size_t i = 0; i < NTRU_N - 1; ++i){
        g[NTRU_N - 2 - i] = signed_mod3((a->coeffs[i] & 3) + 2 * (a->coeffs[NTRU_N - 1] & 3));
    }
    g[NTRU_N - 1] = 0;

    for(size_t i = 0; i < 11; i++){
        flo[i] = 0xffffffffffffffff;
        fhi[i] = 0;
        glo[i] = 0;
        ghi[i] = 0;
        vlo[i] = 0;
        vhi[i] = 0;
        wlo[i] = 0;
        whi[i] = 0;
    }
    flo[10] = 0x1fffffffffffffff;
    wlo[0] = 1;
    for(size_t i = 0; i < NTRU_N; i++){
        glo[i / 64] |= ((((uint64_t)g[i]) & 1) >> 0) << ((i % 64));
        ghi[i / 64] |= ((((uint64_t)g[i]) & 2) >> 1) << ((i % 64));
    }

    delta = 1;

    for(loop = 0; loop < 2 * (NTRU_N - 1) - 1; ++loop) {

        for(size_t i = 10; i > 0; i--){
            vlo[i] = (vlo[i] << 1) | (vlo[i - 1] >> 63);
            vhi[i] = (vhi[i] << 1) | (vhi[i - 1] >> 63);
        }
        vlo[0] <<= 1;
        vhi[0] <<= 1;

        g0 = (glo[0] & 1) | (-(int8_t)(ghi[0] & 1));
        f0 = (flo[0] & 1) | (-(int8_t)(fhi[0] & 1));

        sign = -g0*f0;
        swap = -(int16_t)( (((uint16_t)(-delta)) >> 15) & g0 & 1);
        delta ^= swap & (delta ^ -delta);
        delta += 1;

        signlo = (uint64_t)(-((sign & 1) >> 0));
        signhi = (uint64_t)(-((sign & 2) >> 1));
        swapx64 = (uint64_t)((int64_t)swap);
        signlol = (uint8x16_t)vdupq_n_s16(-((sign & 1) >> 0));
        signhil = (uint8x16_t)vdupq_n_s16(-((sign & 2) >> 1));
        swapx128 = (uint8x16_t)vdupq_n_s16(swap);

#define SWAP64(off) { \
        t0x64 = swapx64 & (flo[off] ^ glo[off]); \
        t1x64 = swapx64 & (vlo[off] ^ wlo[off]); \
        flo[off] ^= t0x64; \
        glo[off] ^= t0x64; \
        vlo[off] ^= t1x64; \
        wlo[off] ^= t1x64; \
        t0x64 = swapx64 & (fhi[off] ^ ghi[off]); \
        t1x64 = swapx64 & (vhi[off] ^ whi[off]); \
        fhi[off] ^= t0x64; \
        ghi[off] ^= t0x64; \
        vhi[off] ^= t1x64; \
        whi[off] ^= t1x64; \
        mul_Z3_bitsliced(&tlo, &thi, &signlo, &signhi, flo + off, fhi + off); \
        add_Z3_bitsliced(glo + off, ghi + off, glo + off, ghi + off, &tlo, &thi); \
        mul_Z3_bitsliced(&tlo, &thi, &signlo, &signhi, vlo + off, vhi + off); \
        add_Z3_bitsliced(wlo + off, whi + off, wlo + off, whi + off, &tlo, &thi); \
    }

#define SWAP128(off) { \
        t0x128 = swapx128 & (flol[off] ^ glol[off]); \
        t1x128 = swapx128 & (vlol[off] ^ wlol[off]); \
        flol[off] ^= t0x128; \
        glol[off] ^= t0x128; \
        vlol[off] ^= t1x128; \
        wlol[off] ^= t1x128; \
        t0x128 = swapx128 & (fhil[off] ^ ghil[off]); \
        t1x128 = swapx128 & (vhil[off] ^ whil[off]); \
        fhil[off] ^= t0x128; \
        ghil[off] ^= t0x128; \
        vhil[off] ^= t1x128; \
        whil[off] ^= t1x128; \
        mul_Z3_bitsliced_uint8x16(&tlol, &thil, &signlol, &signhil, flol + off, fhil + off); \
        add_Z3_bitsliced_uint8x16(glol + off, ghil + off, glol + off, ghil + off, &tlol, &thil); \
        mul_Z3_bitsliced_uint8x16(&tlol, &thil, &signlol, &signhil, vlol + off, vhil + off); \
        add_Z3_bitsliced_uint8x16(wlol + off, whil + off, wlol + off, whil + off, &tlol, &thil); \
    }

        SWAP128(0);
        SWAP64(8);
        SWAP128(1);
        SWAP64(9);
        SWAP128(2);
        SWAP64(10);
        SWAP128(3);

#undef SWAP64
#undef SWAP128

        for(size_t i = 0; i < 10; i++){
            glo[i] = (glo[i] >> 1) | (glo[i + 1] << 63);
            ghi[i] = (ghi[i] >> 1) | (ghi[i + 1] << 63);
        }
        glo[10] >>= 1;
        ghi[10] >>= 1;

    }

    sign = (flo[0] & 1) | (-(int8_t)(fhi[0] & 1));
    signlo = (uint64_t)(-((int64_t)((sign & 1) >> 0)));
    signhi = (uint64_t)(-((int64_t)((sign & 2) >> 1)));

    for(size_t i = 0; i < 11; i++){
        mul_Z3_bitsliced(vlo + i, vhi + i, &signlo, &signhi, vlo + i, vhi + i);
        // convert to unsigned
        vlo[i] ^= vhi[i];
    }

    for(size_t i = 0; i < NTRU_N - 1; i++){
        r->coeffs[i] = (uint16_t)(
                        (((vlo[(NTRU_N - 2 - i) / 64] >> ((NTRU_N - 2 - i) % 64)) & 1) << 0) |
                        (((vhi[(NTRU_N - 2 - i) / 64] >> ((NTRU_N - 2 - i) % 64)) & 1) << 1)
                        );
    }
    r->coeffs[NTRU_N - 1] = 0;
}
