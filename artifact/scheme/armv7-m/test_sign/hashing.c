
#include "api.h"
#include "sign.h"
#include "hal.h"
#include "sendfn.h"
#include "randombytes.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define ITERATIONS 100

#define MLEN 59
#define CTXLEN 14

#define printcycles(S, U) send_unsignedll((S), (U))

unsigned long long hash_cycles;

int main(void)
{
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sm[MLEN+CRYPTO_BYTES];
  uint8_t ctx[CTXLEN];
  size_t smlen;
  int i;

  hal_setup(CLOCK_BENCHMARK);

  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }

  for(i=0;i<ITERATIONS; i++)
  {
    // Key-pair generation
    hash_cycles = 0;
    crypto_sign_keypair(pk, sk);
    printcycles("keypair hash cycles:", hash_cycles);

    // Signing
    randombytes(sm, MLEN);
    hash_cycles = 0;
    crypto_sign(sm, &smlen, sm, MLEN, ctx, CTXLEN, sk);
    printcycles("sign hash cycles:", hash_cycles);

    // Verification
    hash_cycles = 0;
    crypto_sign_open(sm, &smlen, sm, smlen, ctx, CTXLEN, pk);
    printcycles("verify hash cycles:", hash_cycles);

    hal_send_str("+");
  }

  hal_send_str("#");
  return 0;
}
