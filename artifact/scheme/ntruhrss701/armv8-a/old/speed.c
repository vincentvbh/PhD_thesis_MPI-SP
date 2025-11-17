
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "owcpa.h"

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

int main(void)
{
    unsigned char pk[CRYPTO_PUBLICKEYBYTES] = {0};
    unsigned char sk[CRYPTO_SECRETKEYBYTES] = {0};
    unsigned char ct[CRYPTO_CIPHERTEXTBYTES] = {0};
    unsigned char key_a[CRYPTO_BYTES] = {0};
    unsigned char key_b[CRYPTO_BYTES] = {0};
    uint8_t seed[NTRU_SAMPLE_FG_BYTES];
    uint8_t rm[NTRU_OWCPA_MSGBYTES];
    poly r, m;

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

    WRAP_FUNC("owcpa_keypair",
            cycles, time0, time1,
            owcpa_keypair(pk, sk, seed));
    WRAP_FUNC("owcpa_enc",
            cycles, time0, time1,
            owcpa_enc(ct, &r, &m, pk));
    WRAP_FUNC("owcpa_dec",
            cycles, time0, time1,
            owcpa_dec(rm, ct, sk));


  return 0;

}






