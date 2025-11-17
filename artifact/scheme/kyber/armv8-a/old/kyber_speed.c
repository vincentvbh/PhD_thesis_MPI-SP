#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"
#include "indcpa.h"
#include "params.h"
#include "indcpa.h"
#include "poly.h"
#include "polyvec.h"
#include "ntt.h"

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

uint8_t seed[KYBER_SYMBYTES] = {0};

int main(void){

    uint8_t pk[KYBER_AARCH64_CRYPTO_PUBLICKEYBYTES] = {0};
    uint8_t sk[KYBER_AARCH64_CRYPTO_SECRETKEYBYTES] = {0};
    uint8_t ct[KYBER_AARCH64_CRYPTO_CIPHERTEXTBYTES] = {0};
    uint8_t key_a[KYBER_AARCH64_CRYPTO_BYTES] = {0};
    uint8_t key_b[KYBER_AARCH64_CRYPTO_BYTES] = {0};

    // Init performance counter
    init_counter();

    WRAP_FUNC("crypto_kem_keypair",
              cycles, time0, time1,
              crypto_kem_keypair(pk, sk));
    WRAP_FUNC("crypto_kem_enc",
              cycles, time0, time1,
              crypto_kem_enc(ct, key_b, pk));
    WRAP_FUNC("crypto_kem_dec",
              cycles, time0, time1,
              crypto_kem_dec(key_a, ct, sk));

//


  return 0;
}
