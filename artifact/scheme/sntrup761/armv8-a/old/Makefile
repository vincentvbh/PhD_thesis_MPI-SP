CC ?= /usr/bin/cc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer -mtune=native -mcpu=native -O3
NISTFLAGS += -Wno-unused-result -mpopcnt -maes \
             -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

COMMON_PATH = ../common

HASH_PATH = $(COMMON_PATH)
HASH_HEADERS = $(HASH_PATH)/sha2.h
HASH_SOURCES = $(HASH_PATH)/sha2.c

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
ASM_SOURCES = divstep_utils.S \
	polymul/Bruun_GF_mul.S polymul/iNTT.S polymul/NTT.S polymul/mul.S polymul/rader.S polymul/radix3.S
C_HEADERS = api.h kem.h crypto_kem_sntrup761.h params.h paramsmenu.h sntrup_core.h symmetric.h \
	poly_type.h poly_mulmod.h poly_mask.h \
	poly_encode_decode.h poly_arith.h poly_recip.h poly_rand.h
C_SOURCES = Decode.c Encode.c kem.c sntrup_core.c symmetric.c \
	type/int32.c type/uint32.c poly_mulmod.c poly_mask.c \
	poly_encode_decode.c poly_arith.c poly_recip.c poly_rand.c \
	polymul/poly_basic.c polymul/poly_vec.c polymul/polymul.c polymul/rader.c

HEADERS = $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS) $(ASM_HEADERS) $(C_HEADERS)
SOURCES = $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES) $(ASM_SOURCES) $(C_SOURCES)

all: test testvectors bench

bench: speed speed_arith speed_polymul speed_Rqinv

test: test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

testvectors: testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -DNORAND $< -o $@

speed: speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) $< -o $@

speed_polymul: speed_polymul.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) $< -o $@

speed_arith: speed_arith.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) $< -o $@

speed_Rqinv: speed_Rqinv.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(BENCHFLAGS) $(SOURCES) $(CYCLES_SOURCES) $< -o $@

.PHONY: bench clean

clean:
	-$(RM) -rf *.o
	-$(RM) -rf *.gch
	-$(RM) -rf test
	-$(RM) -rf testvectors
	-$(RM) -rf speed
	-$(RM) -rf speed_polymul
	-$(RM) -rf speed_arith
	-$(RM) -rf speed_Rqinv








