
# platform independent flags
CC                     ?= gcc
CFLAGS                 += -Wall -O3

RM                     ?= /usr/bin/rm

# avx2 flags
AVX2_FLAGS              = -mavx2 -z noexecstack

COMMON_PATH             = ./common

CFLAGS                 += -I$(COMMON_PATH)

COMMON_SOURCE           = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

CYCLES_PATH             = $(COMMON_PATH)
CYCLES_HEADERS          = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES          = $(CYCLES_PATH)/cycles.c

BENCHFLAGS              = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS             = basemul_core.inc butterflies.inc permute.inc fq.inc shuffle.inc
ASM_SOURCES             = basemul.S rader17.S radix_3x2.S kyber_basemul.S kyber_ntt.S kyber_intt.S

HEADERS                 = $(ASM_HEADERS) cdecl.h kyber_consts.h
SOUCRES                 = $(ASM_SOURCES) $(COMMON_SOURCE) kyber_consts.c

all: \
	ntrup_ntt ntrup_ntt_speed \
	kyber_ntt_speed


ntrup_ntt: ntrup_ntt.c $(HEADERS) $(SOUCRES)
	$(CC) $(CFLAGS) $(AVX2_FLAGS) $(SOUCRES) $< -o $@

ntrup_ntt_speed: ntrup_ntt_speed.c $(HEADERS) $(SOUCRES)
	$(CC) $(CFLAGS) $(AVX2_FLAGS) $(SOUCRES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

kyber_ntt_speed: kyber_ntt_speed.c $(HEADERS) $(SOUCRES)
	$(CC) $(CFLAGS) $(AVX2_FLAGS) $(SOUCRES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean

clean:
	$(RM) -rf ntrup_ntt
	$(RM) -rf ntrup_ntt_speed
	$(RM) -rf kyber_ntt_speed



