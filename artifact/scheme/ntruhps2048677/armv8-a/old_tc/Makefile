CC ?= /usr/bin/cc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer -mtune=native -O3
NISTFLAGS += -Wno-unused-result -mpopcnt -maes \
             -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

COMMON_PATH = ../common

HASH_PATH = $(COMMON_PATH)
HASH_HEADERS = $(HASH_PATH)/fips202.h $(HASH_PATH)/sha2.h
HASH_SOURCES = $(HASH_PATH)/fips202.c $(HASH_PATH)/sha2.c

SORT_PATH = $(COMMON_PATH)
SORT_HEADERS = $(SORT_PATH)/crypto_sort.h
SORT_SOURCES = $(SORT_PATH)/crypto_sort.c

RAND_PATH = $(COMMON_PATH)
RAND_HEADERS = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

CFLAGS += -I$(HASH_PATH) -I$(SORT_PATH) -I$(RAND_PATH)

CYCLES_PATH    = $(COMMON_PATH)
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS =
ASM_SOURCES =
C_HEADERS = api.h cmov.h owcpa.h params.h poly.h sample.h tc.h batch_multiplication.h
C_SOURCES = cmov.c kem.c poly_mod.c \
	owcpa.c pack3.c packq.c poly.c poly_lift.c \
	poly_r2_inv.c poly_s3_inv.c sample.c \
	sample_iid.c tc.c batch_multiplication.c

HEADERS = $(ASM_HEADERS) $(C_HEADERS) $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS)
SOURCES = $(ASM_SOURCES) $(C_SOURCES) $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES)

all: test testvectors bench

bench: speed speed_polymul speed_arith

test: $(HEADERS) $(SOURCES) test.c
	$(CC) $(CFLAGS) $(SOURCES) test.c -o test

testvectors: $(HEADERS) $(SOURCES) testvectors.c
	$(CC) $(CFLAGS) $(SOURCES) -DNORAND testvectors.c -o testvectors

speed: $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES) speed.c
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) speed.c -o speed

speed_polymul: $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES) speed_polymul.c
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) speed_polymul.c -o speed_polymul

speed_arith: $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES) speed_arith.c
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) speed_arith.c -o speed_arith

.PHONY: clean

clean:
	-$(RM) -rf *.o
	-$(RM) -rf *.gch
	-$(RM) -rf test
	-$(RM) -rf testvectors
	-$(RM) -rf speed
	-$(RM) -rf speed_polymul
	-$(RM) -rf speed_arith

