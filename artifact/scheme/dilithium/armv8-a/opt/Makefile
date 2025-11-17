CC ?= /usr/bin/cc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
          -Wshadow -Wpointer-arith -fomit-frame-pointer -mtune=native -O3
NISTFLAGS += -Wno-unused-result -mpopcnt -maes \
             -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

CFLAGS += -march=armv8-a

COMMON_PATH = ../common

HASH_PATH = $(COMMON_PATH)
HASH_HEADERS = $(HASH_PATH)/fips202.h $(HASH_PATH)/fips202x2.h
HASH_SOURCES = $(HASH_PATH)/fips202.c $(HASH_PATH)/fips202x2.c $(HASH_PATH)/feat.S

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

ASM_HEADERS = macros.i macros_common.i
ASM_SOURCES = __asm_NTT.S __asm_iNTT.S __asm_poly.S

HASH_HEADERS += symmetric.h
HASH_SOURCES += symmetric-shake.c

HEADERS = params.h sign.h ntt.h packing.h poly.h polyvec.h reduce.h rounding.h
SOURCES = sign.c ntt.c packing.c poly.c polyvec.c reduce.c rounding.c

HEADERS += $(ASM_HEADERS) $(C_HEADERS) $(HASH_HEADERS) $(SORT_HEADERS) $(RAND_HEADERS)
SOURCES += $(ASM_SOURCES) $(C_SOURCES) $(HASH_SOURCES) $(SORT_SOURCES) $(RAND_SOURCES)

all: test speed

test: dilithium2_test dilithium2_testvectors \
	  dilithium3_test dilithium3_testvectors \
	  dilithium5_test dilithium5_testvectors

speed: dilithium2_speed \
	   dilithium3_speed \
	   dilithium5_speed

dilithium2_test: dilithium_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=2 $(SOURCES) $< -o $@

dilithium2_testvectors: dilithium_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=2 $(SOURCES) $< -o $@ -DNORAND

dilithium3_test: dilithium_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=3 $(SOURCES) $< -o $@

dilithium3_testvectors: dilithium_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=3 $(SOURCES) $< -o $@ -DNORAND

dilithium5_test: dilithium_test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=5 $(SOURCES) $< -o $@

dilithium5_testvectors: dilithium_testvectors.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=5 $(SOURCES) $< -o $@ -DNORAND

dilithium2_speed: dilithium_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=2 $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

dilithium3_speed: dilithium_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=3 $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

dilithium5_speed: dilithium_speed.c $(HEADERS) $(SOURCES) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=5 $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean

clean:
	-$(RM) -rf *.o
	-$(RM) -rf dilithium2_test
	-$(RM) -rf dilithium2_testvectors
	-$(RM) -rf dilithium3_test
	-$(RM) -rf dilithium3_testvectors
	-$(RM) -rf dilithium5_test
	-$(RM) -rf dilithium5_testvectors
	-$(RM) -rf dilithium2_speed
	-$(RM) -rf dilithium3_speed
	-$(RM) -rf dilithium5_speed

