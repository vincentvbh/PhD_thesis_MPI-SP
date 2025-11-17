CC ?= /usr/bin/cc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -mavx2 -mbmi2 -mpopcnt \
  -march=native -mtune=native -O3 -fomit-frame-pointer -z noexecstack
NISTFLAGS += -Wno-unused-result -mavx2 -mbmi2 -mpopcnt \
  -march=native -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

COMMON_PATH = ../common

HASH_PATH = $(COMMON_PATH)
HASH_HEADERS = $(HASH_PATH)/fips202.h $(HASH_PATH)/fips202x4.h $(wildcard $(COMMON_PATH)/keccak4x/*.h)
HASH_SOURCES = $(HASH_PATH)/fips202.c $(HASH_PATH)/fips202x4.c $(wildcard $(COMMON_PATH)/keccak4x/*.c)

SORT_PATH = .
SORT_HEADERS =
SORT_SOURCES =

RAND_PATH = $(COMMON_PATH)
RAND_HEADERS = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

CFLAGS += -I$(HASH_PATH) -I$(SORT_PATH) -I$(RAND_PATH)

CYCLES_PATH = $(COMMON_PATH)
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

HEADERS = params.h align.h kem.h indcpa.h polyvec.h poly.h reduce.h fq.inc shuffle.inc \
  ntt.h consts.h rejsample.h cbd.h verify.h symmetric.h

SOURCES = kem.c indcpa.c polyvec.c poly.c fq.S shuffle.S ntt.S invntt.S \
  basemul.S consts.c rejsample.c cbd.c verify.c symmetric-shake.c

HEADERS += $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS)
SOURCES += $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES)


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
	$(CC) $(CFLAGS) -DKYBER_K=2 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

kyber768_speed: kyber_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=3 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

kyber1024_speed: kyber_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) -DKYBER_K=4 $(SOURCES) $(CYCLES_SOURCES) $< -o $@

.PHONY: bench clean

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
