#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "api.h"
#include "kem.h"

#if __APPLE__
#define NTESTS 10000
#else
#define NTESTS 1000
#endif
#include "cycles.h"

uint64_t time0, time1;
uint64_t cycles[NTESTS];

int main(void){

    uint8_t pk[CRYPTO_PUBLICKEYBYTES] = {0};
    uint8_t sk[CRYPTO_SECRETKEYBYTES] = {0};
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES] = {0};
    uint8_t key_a[CRYPTO_BYTES] = {0};
    uint8_t key_b[CRYPTO_BYTES] = {0};

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

    return 0;

}
