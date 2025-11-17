#ifndef API_H
#define API_H

#include "params.h"

#if KYBER_K == 2
#define CRYPTO_SECRETKEYBYTES  1632
#define CRYPTO_PUBLICKEYBYTES  800
#define CRYPTO_CIPHERTEXTBYTES 768
#define CRYPTO_BYTES           32
#elif KYBER_K == 3
#define CRYPTO_SECRETKEYBYTES  2400
#define CRYPTO_PUBLICKEYBYTES  1184
#define CRYPTO_CIPHERTEXTBYTES 1088
#define CRYPTO_BYTES           32
#elif KYBER_K == 4
#define CRYPTO_SECRETKEYBYTES  3168
#define CRYPTO_PUBLICKEYBYTES  1568
#define CRYPTO_CIPHERTEXTBYTES 1568
#define CRYPTO_BYTES           32
#else
#error "unknown parameter set!"
#endif

#endif

