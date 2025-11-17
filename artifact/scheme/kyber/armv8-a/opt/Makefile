CC ?= /usr/bin/cc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer -mtune=native -O3
NISTFLAGS += -Wno-unused-result -mpopcnt -maes \
             -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

CFLAGS += -march=armv8-a

COMMON_PATH = ../common

HASH_PATH    = $(COMMON_PATH)
HASH_HEADERS = $(HASH_PATH)/fips202.h $(HASH_PATH)/fips202x2.h
HASH_SOURCES = $(HASH_PATH)/fips202.c $(HASH_PATH)/fips202x2.c $(HASH_PATH)/feat.S

SORT_PATH    = .
SORT_HEADERS =
SORT_SOURCES =

RAND_PATH    = $(COMMON_PATH)
RAND_HEADERS = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

CFLAGS += -I$(HASH_PATH) -I$(SORT_PATH) -I$(RAND_PATH)

CYCLES_PATH    = $(COMMON_PATH)
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS = macros.i macros_common.i
ASM_SOURCES = __asm_NTT.S __asm_iNTT.S  __asm_base_mul.S __asm_poly.S __asm_compress.S

HASH_HEADERS += symmetric.h rejsample.h
HASH_SOURCES += symmetric-shake.c rejsample.c

HEADERS = params.h api.h indcpa.h polyvec.h poly.h NTT_params.h ntt.h cbd.h reduce.h verify.h
SOURCES = kem.c indcpa.c polyvec.c poly.c ntt.c cbd.c reduce.c verify.c

HEADERS += $(ASM_HEADERS) $(C_HEADERS) $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS)
SOURCES += $(ASM_SOURCES) $(C_SOURCES) $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES)

all: test speed

test: kyber512_test kyber512_testvectors \
	  kyber768_test kyber768_testvectors \
	  kyber1024_test kyber1024_testvectors

speed: kyber512_speed \
	   kyber768_speed \
	   kyber1024_speed

kyber512_test: kyber_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES) $< -o $@

kyber512_testvectors: kyber_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES) $< -o $@ -DNORAND

kyber768_test: kyber_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES) $< -o $@

kyber768_testvectors: kyber_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES) $< -o $@ -DNORAND

kyber1024_test: kyber_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES) $< -o $@

kyber1024_testvectors: kyber_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES) $< -o $@ -DNORAND

kyber512_speed: kyber_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) -DKYBER_K=2 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

kyber768_speed: kyber_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) -DKYBER_K=3 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

kyber1024_speed: kyber_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) -DKYBER_K=4 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean

clean:
	-$(RM) -rf *.o
	-$(RM) -rf kyber512_test
	-$(RM) -rf kyber512_testvectors
	-$(RM) -rf kyber768_test
	-$(RM) -rf kyber768_testvectors
	-$(RM) -rf kyber1024_test
	-$(RM) -rf kyber1024_testvectors
	-$(RM) -rf kyber512_speed
	-$(RM) -rf kyber768_speed
	-$(RM) -rf kyber1024_speed



