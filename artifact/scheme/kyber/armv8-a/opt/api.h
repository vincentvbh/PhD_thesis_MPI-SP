#ifndef KYBER_AARCH64_API_H
#define KYBER_AARCH64_API_H

/*
 * This file is licensed
 * under Apache 2.0 (https://www.apache.org/licenses/LICENSE-2.0.html) or
 * public domain at https://github.com/pq-crystals/kyber/tree/master/ref
 */

#define CRYPTO_SECRETKEYBYTES  KYBER_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  KYBER_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES KYBER_CIPHERTEXTBYTES
#define CRYPTO_BYTES           KYBER_SSBYTES

#include <stdint.h>

#if KYBER_K == 2
#define KYBER_AARCH64_CRYPTO_SECRETKEYBYTES  1632
#define KYBER_AARCH64_CRYPTO_PUBLICKEYBYTES  800
#define KYBER_AARCH64_CRYPTO_CIPHERTEXTBYTES 768
#define KYBER_AARCH64_CRYPTO_BYTES           32
#define KYBER_AARCH64_CRYPTO_ALGNAME         "Kyber512"
#elif KYBER_K == 3
#define KYBER_AARCH64_CRYPTO_SECRETKEYBYTES  2400
#define KYBER_AARCH64_CRYPTO_PUBLICKEYBYTES  1184
#define KYBER_AARCH64_CRYPTO_CIPHERTEXTBYTES 1088
#define KYBER_AARCH64_CRYPTO_BYTES           32
#define KYBER_AARCH64_CRYPTO_ALGNAME         "Kyber768"
#elif KYBER_K == 4
#define KYBER_AARCH64_CRYPTO_SECRETKEYBYTES  3168
#define KYBER_AARCH64_CRYPTO_PUBLICKEYBYTES  1568
#define KYBER_AARCH64_CRYPTO_CIPHERTEXTBYTES 1568
#define KYBER_AARCH64_CRYPTO_BYTES           32
#define KYBER_AARCH64_CRYPTO_ALGNAME         "Kyber1024"
#endif

int KYBER_AARCH64_crypto_kem_keypair(uint8_t *pk, uint8_t *sk);

int KYBER_AARCH64_crypto_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk);

int KYBER_AARCH64_crypto_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
