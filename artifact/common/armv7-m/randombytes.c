#include <stdint.h>
#include "randombytes.h"

//TODO Maybe we do not want to use the hardware RNG for all randomness, but instead only read a seed and then expand that using fips202.

#define NORAND

#if defined(NORAND) || defined(BENCH) || defined(BENCH_RAND)

#pragma message("using non-random randombytes!")

#include <stdlib.h>
#include <string.h>

#include "rng.h"

unsigned char __attribute__((aligned (16)))keybytes[crypto_rng_KEYBYTES] = {
  0x49, 0x54, 0xcc, 0x49, 0xa4, 0x94, 0xba, 0x0,
  0x41, 0x76, 0x78, 0x17, 0x5f, 0xb9, 0xfb, 0x23,
  0x18, 0x91, 0x65, 0xb7, 0x90, 0xb4, 0x9f, 0x65,
  0x91, 0x6c, 0xe4, 0xc1, 0xde, 0xac, 0xf4, 0x6c
};
unsigned char __attribute__((aligned (16)))outbytes[crypto_rng_OUTPUTBYTES];
unsigned long long pos = crypto_rng_OUTPUTBYTES;

static void randombytes_internal(uint8_t *x, size_t xlen){

#ifdef SIMPLE

  while (xlen > 0) {
    if (pos == crypto_rng_OUTPUTBYTES) {
      crypto_rng(outbytes,keybytes,keybytes);
      pos = 0;
    }
    *x++ = outbytes[pos]; xlen -= 1;
    outbytes[pos++] = 0;
  }

#else /* same output but optimizing copies */

  while (xlen > 0) {
    unsigned long long ready;

    if (pos == crypto_rng_OUTPUTBYTES) {
      while (xlen > crypto_rng_OUTPUTBYTES) {
        crypto_rng(x,keybytes,keybytes);
        x += crypto_rng_OUTPUTBYTES;
        xlen -= crypto_rng_OUTPUTBYTES;
      }
      if (xlen == 0) return;

      crypto_rng(outbytes,keybytes,keybytes);
      pos = 0;
    }

    ready = crypto_rng_OUTPUTBYTES - pos;
    if (xlen <= ready) ready = xlen;
    memcpy(x,outbytes + pos,ready);
    memset(outbytes + pos,0,ready);
    x += ready;
    xlen -= ready;
    pos += ready;
  }

#endif

}


void randombytes(uint8_t *obuf, size_t len) __attribute__ ((weak, alias ("randombytes_internal")));

#else

#include <libopencm3/stm32/rng.h>

void randombytes_trng(uint8_t *obuf, size_t len)
{
    union
    {
        unsigned char aschar[4];
        uint32_t asint;
    } random;

    while (len > 4)
    {
        random.asint = rng_get_random_blocking();
        *obuf++ = random.aschar[0];
        *obuf++ = random.aschar[1];
        *obuf++ = random.aschar[2];
        *obuf++ = random.aschar[3];
        len -= 4;
    }
    if (len > 0)
    {
        for (random.asint = rng_get_random_blocking(); len > 0; --len)
        {
            *obuf++ = random.aschar[len - 1];
        }
    }

}

void randombytes(uint8_t *obuf, size_t len) __attribute__ ((weak, alias ("randombytes_trng")));

#endif


