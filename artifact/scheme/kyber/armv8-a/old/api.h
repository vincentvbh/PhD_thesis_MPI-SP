#ifndef API_H
#define API_H

#include "params.h"
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
