
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "api.h"
#include "params.h"
#include "kem.h"
#include "sntrup_core.h"

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


int main()
{
    unsigned char pk[CRYPTO_PUBLICKEYBYTES] = {0};
    unsigned char sk[CRYPTO_SECRETKEYBYTES] = {0};
    unsigned char ct[CRYPTO_CIPHERTEXTBYTES] = {0};
    unsigned char key_a[CRYPTO_BYTES] = {0};
    unsigned char key_b[CRYPTO_BYTES] = {0};

    Fq h[POLY_N], c[POLY_N];
    small f[POLY_N],v[POLY_N];

    Inputs r;

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
    WRAP_FUNC("ZKeyGen",
            cycles, time0, time1,
            ZKeyGen(pk, sk));
    WRAP_FUNC("ZEncrypt",
            cycles, time0, time1,
            ZEncrypt(ct, r, pk));
    WRAP_FUNC("ZDecrypt",
            cycles, time0, time1,
            ZDecrypt(r, ct, sk));

    WRAP_FUNC("KeyGen",
            cycles, time0, time1,
            KeyGen(h,f,v));
    WRAP_FUNC("Encrypt",
            cycles, time0, time1,
            Encrypt(c,r,h));
    WRAP_FUNC("Decrypt",
            cycles, time0, time1,
            Decrypt(r,c,f,v));

  return 0;

}






