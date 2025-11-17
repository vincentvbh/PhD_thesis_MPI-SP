#include "api.h"
#include "kem.h"
#include "hal.h"
#include "sendfn.h"

#include <stdint.h>
#include <string.h>

#define ITERATIONS 100

#define printcycles(S, U) send_unsignedll((S), (U))

unsigned long long hash_cycles;

int main(void)
{
  unsigned char key_a[CRYPTO_BYTES], key_b[CRYPTO_BYTES];
  unsigned char sk[CRYPTO_SECRETKEYBYTES];
  unsigned char pk[CRYPTO_PUBLICKEYBYTES];
  unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
  int i;

  hal_setup(CLOCK_BENCHMARK);

  for(i = 0; i < 60; i++){
    hal_send_str("==========================");
  }

  for(i=0;i<ITERATIONS; i++)
  {
    // Key-pair generation
    hash_cycles = 0;
    crypto_kem_keypair(pk, sk);
    printcycles("keypair hash cycles:", hash_cycles);

    // Encapsulation
    hash_cycles = 0;
    crypto_kem_enc(ct, key_a, pk);
    printcycles("encaps hash cycles:", hash_cycles);

    // Decapsulation
    hash_cycles = 0;
    crypto_kem_dec(key_b, ct, sk);
    printcycles("decaps hash cycles:", hash_cycles);

    if (memcmp(key_a, key_b, CRYPTO_BYTES)) {
      hal_send_str("ERROR KEYS\n");
    }
    else {
      hal_send_str("OK KEYS\n");
    }
    hal_send_str("+");
  }
  hal_send_str("#");
  return 0;
}
