
CC            ?= gcc
CFLAGS        += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  				 -Wshadow -Wpointer-arith -mavx2 -mbmi2 -mpopcnt \
  				 -march=native -mtune=native -O3 -fomit-frame-pointer -z noexecstack
RM             = /bin/rm

COMMON_PATH    = ./common


HASH_PATH      = $(COMMON_PATH)
HASH_HEADERS   = $(HASH_PATH)/sha2.h $(HASH_PATH)/fips202.h $(HASH_PATH)/fips202x4.h $(wildcard $(COMMON_PATH)/keccak4x/*.h)
HASH_SOURCES   = $(HASH_PATH)/sha2.c $(HASH_PATH)/fips202.c $(HASH_PATH)/fips202x4.c $(wildcard $(COMMON_PATH)/keccak4x/*.c)

SORT_PATH      = $(COMMON_PATH)
SORT_HEADERS   = $(SORT_PATH)/crypto_sort.h
SORT_SOURCES   = $(SORT_PATH)/crypto_sort.c

RAND_PATH      = $(COMMON_PATH)
RAND_HEADERS   = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES   = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

COMMON_HEADERS = $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS)
COMMON_SOURCES = $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES)

CFLAGS        += -I$(HASH_PATH) -I$(SORT_PATH) -I$(RAND_PATH)

CYCLES_PATH    = $(COMMON_PATH)
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS     = -I$(CYCLES_PATH) -DBENCH

include scheme.mk

all: test speed

test: \
	dilithium_test \
	kyber_test \
	saber_test \
	ntru_test \
	ntrup_test

speed: \
	dilithium_speed \
	kyber_speed \
	saber_speed \
	ntru_speed \
	ntrup_speed

dilithium_test: \
	dilithium/obj/dilithium2_ref_test \
	dilithium/obj/dilithium2_ref_testvectors \
	dilithium/obj/dilithium3_ref_test \
	dilithium/obj/dilithium3_ref_testvectors \
	dilithium/obj/dilithium5_ref_test \
	dilithium/obj/dilithium5_ref_testvectors \
	dilithium/obj/dilithium2_old_test \
	dilithium/obj/dilithium2_old_testvectors \
	dilithium/obj/dilithium3_old_test \
	dilithium/obj/dilithium3_old_testvectors \
	dilithium/obj/dilithium5_old_test \
	dilithium/obj/dilithium5_old_testvectors

dilithium_speed: \
	dilithium/obj/dilithium2_old_speed \
	dilithium/obj/dilithium2_old_speed_local \
	dilithium/obj/dilithium3_old_speed \
	dilithium/obj/dilithium3_old_speed_local \
	dilithium/obj/dilithium5_old_speed \
	dilithium/obj/dilithium5_old_speed_local

dilithium: \
	dilithium_test \
	dilithium_speed

kyber_test: \
	kyber/obj/kyber512_ref_test \
	kyber/obj/kyber512_ref_testvectors \
	kyber/obj/kyber768_ref_test \
	kyber/obj/kyber768_ref_testvectors \
	kyber/obj/kyber1024_ref_test \
	kyber/obj/kyber1024_ref_testvectors \
	kyber/obj/kyber512_old_test \
	kyber/obj/kyber512_old_testvectors \
	kyber/obj/kyber768_old_test \
	kyber/obj/kyber768_old_testvectors \
	kyber/obj/kyber1024_old_test \
	kyber/obj/kyber1024_old_testvectors \
	kyber/obj/kyber512_opt_test \
	kyber/obj/kyber512_opt_testvectors \
	kyber/obj/kyber768_opt_test \
	kyber/obj/kyber768_opt_testvectors \
	kyber/obj/kyber1024_opt_test \
	kyber/obj/kyber1024_opt_testvectors

kyber_speed: \
	kyber/obj/kyber512_old_speed \
	kyber/obj/kyber512_old_speed_local \
	kyber/obj/kyber768_old_speed \
	kyber/obj/kyber768_old_speed_local \
	kyber/obj/kyber1024_old_speed \
	kyber/obj/kyber1024_old_speed_local \
	kyber/obj/kyber512_opt_speed \
	kyber/obj/kyber768_opt_speed \
	kyber/obj/kyber1024_opt_speed

kyber: \
	kyber_test \
	kyber_speed

saber_test: \
	saber/obj/lightsaber_ref_test \
	saber/obj/lightsaber_ref_testvectors \
	saber/obj/saber_ref_test \
	saber/obj/saber_ref_testvectors \
	saber/obj/firesaber_ref_test \
	saber/obj/firesaber_ref_testvectors \
	saber/obj/lightsaber_old_tc_test \
	saber/obj/lightsaber_old_tc_testvectors \
	saber/obj/saber_old_tc_test \
	saber/obj/saber_old_tc_testvectors \
	saber/obj/firesaber_old_tc_test \
	saber/obj/firesaber_old_tc_testvectors \
	saber/obj/lightsaber_old_ntt_test \
	saber/obj/lightsaber_old_ntt_testvectors \
	saber/obj/saber_old_ntt_test \
	saber/obj/saber_old_ntt_testvectors \
	saber/obj/firesaber_old_ntt_test \
	saber/obj/firesaber_old_ntt_testvectors

saber_speed: \
	saber/obj/lightsaber_old_tc_speed \
	saber/obj/lightsaber_old_tc_speed_local \
	saber/obj/saber_old_tc_speed \
	saber/obj/saber_old_tc_speed_local \
	saber/obj/firesaber_old_tc_speed \
	saber/obj/firesaber_old_tc_speed_local \
	saber/obj/lightsaber_old_ntt_speed \
	saber/obj/lightsaber_old_ntt_speed_local \
	saber/obj/saber_old_ntt_speed \
	saber/obj/saber_old_ntt_speed_local \
	saber/obj/firesaber_old_ntt_speed \
	saber/obj/firesaber_old_ntt_speed_local

saber: \
	saber_test \
	saber_speed

ntru_test: \
	ntru/obj/ntruhps2048677_ref_test \
	ntru/obj/ntruhps2048677_ref_testvectors \
	ntru/obj/ntruhrss701_ref_test \
	ntru/obj/ntruhrss701_ref_testvectors \
	ntru/obj/ntruhps2048677_old_tc_test \
	ntru/obj/ntruhps2048677_old_tc_testvectors \
	ntru/obj/ntruhrss701_old_tc_test \
	ntru/obj/ntruhrss701_old_tc_testvectors

ntru_speed: \
	ntru/obj/ntruhps2048677_old_tc_speed \
	ntru/obj/ntruhps2048677_old_tc_speed_local \
	ntru/obj/ntruhrss701_old_tc_speed \
	ntru/obj/ntruhrss701_old_tc_speed_local

ntru: \
	ntru_test \
	ntru_speed

ntrup_test: \
	ntrup/obj/sntrup761_ref_test

ntrup_speed: \
	ntrup/obj/sntrup761_ref_speed

ntrup: \
	ntrup_test \
	ntrup_speed

.PHONY: clean

clean:
	-$(RM) -rf dilithium/obj
	-$(RM) -rf kyber/obj
	-$(RM) -rf ntru/obj
	-$(RM) -rf ntrup/obj
	-$(RM) -rf saber/obj

