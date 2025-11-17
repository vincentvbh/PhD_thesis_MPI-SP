
#include "api.h"
#include "sign.h"
#include "randombytes.h"
#include "hal.h"
#include "sendfn.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define ITERATIONS 100

#define MLEN 59
#define CTXLEN 14

#define printcycles(S, U) send_unsignedll((S), (U))

char out[128];

int main(void)
{
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sm[MLEN+CRYPTO_BYTES];
  uint8_t ctx[CTXLEN];
  size_t smlen;
  unsigned long long t0, t1;
  int i;

  hal_setup(CLOCK_BENCHMARK);

  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }

  for(i=0;i<ITERATIONS; i++)
  {
    // Key-pair generation
    t0 = hal_get_time();
    crypto_sign_keypair(pk, sk);
    t1 = hal_get_time();
    printcycles("keypair cycles:", t1-t0);

    // Signing
    t0 = hal_get_time();
    crypto_sign(sm, &smlen, sm, MLEN, ctx, CTXLEN, sk);
    t1 = hal_get_time();
    printcycles("sign cycles:", t1-t0);

    // Verification
    t0 = hal_get_time();
    crypto_sign_open(sm, &smlen, sm, smlen, ctx, CTXLEN, pk);
    t1 = hal_get_time();
    printcycles("verify cycles:", t1-t0);

    hal_send_str("+");
  }
  hal_send_str("#\n");
  return 0;
}
