
#include "api.h"
#include "kem.h"
#include "hal.h"
#include "sendfn.h"

#include "poly.h"
#include "polyvec.h"
#include "matacc.h"

#include <stdint.h>
#include <string.h>

#define ITERATIONS 100

#define printcycles(S, U) send_unsignedll((S), (U))

unsigned long long hash_cycles;
unsigned long long t0, t1;

int main(void){

    poly bp, v;
    polyvec sp;
    polyvec_half sp_prime;
    int32_t r_tmp[KYBER_N];
    uint8_t seed[KYBER_SYMBYTES];

    hal_setup(CLOCK_BENCHMARK);

    for(size_t i = 0; i < 60; i++){
        hal_send_str("==========================");
    }

    hash_cycles = 0;
    t0 = hal_get_time();
    polyvec_ntt(&sp);
    matacc_cache32(&bp, r_tmp, &sp, &sp_prime, 0, seed, 1);
    poly_invntt(&bp);
    poly_reduce(&bp);
    for (size_t i = 1; i < KYBER_K; i++) {
        matacc_opt32(&bp, r_tmp, &sp, &sp_prime, i, seed, 1);
        poly_invntt(&bp);
        poly_reduce(&bp);
    }
    t1 = hal_get_time();
    printcycles("Matrix-vector multiplication", t1 - t0 - hash_cycles);

    hash_cycles = 0;
    t0 = hal_get_time();
    poly_basemul_opt_16_32(r_tmp, &sp.vec[0], &bp, &sp_prime.vec[0]);
    for (size_t i = 1; i < KYBER_K - 1; i++){
        poly_basemul_acc_opt_32_32(r_tmp, &sp.vec[i], &bp, &sp_prime.vec[i]);
    }
    poly_basemul_acc_opt_32_16(&v, &sp.vec[KYBER_K - 1], &bp, &sp_prime.vec[KYBER_K - 1], r_tmp);
    poly_invntt(&v);
    t1 = hal_get_time();
    printcycles("Inner product (Enc)", t1 - t0 - hash_cycles);

    hash_cycles = 0;
    t0 = hal_get_time();
    poly_ntt(&bp);
    poly_basemul_opt_16_32(r_tmp, &sp.vec[0], &bp, &sp_prime.vec[0]);
    for (size_t i = 1; i < KYBER_K - 1; i++){
        poly_ntt(&bp);
        poly_basemul_acc_opt_32_32(r_tmp, &sp.vec[i], &bp, &sp_prime.vec[i]);
    }
    poly_ntt(&bp);
    poly_basemul_acc_opt_32_16(&v, &sp.vec[KYBER_K - 1], &bp, &sp_prime.vec[KYBER_K - 1], r_tmp);
    poly_invntt(&v);
    t1 = hal_get_time();
    printcycles("Inner product (Dec)", t1 - t0 - hash_cycles);

    hal_send_str("#");

}
