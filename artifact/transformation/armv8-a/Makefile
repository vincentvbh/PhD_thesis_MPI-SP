
CC ?= gcc

CFLAGS += -O3 -Wall -Wunused -Wpedantic -Wno-pointer-arith -Wsign-compare

COMMON_PATH = ./common

CFLAGS += -I$(COMMON_PATH)

COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

CYCLES_PATH = ./common
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS = macros.i macros_common.i
ASM_SOURCES = __asm_Karatsuba.S __asm_Toeplitz.S __asm_permute.S

C_HEADERS =
C_SOURCES =

HEADERS = $(ASM_HEADERS) $(C_HEADERS)
SOURCES = $(ASM_SOURCES) $(C_SOURCES) $(COMMON_SOURCE)

DILITHIUM_SOURCES = __asm_Dilithium_NTT.S __asm_Dilithium_iNTT.S __asm_Dilithium_basemul.S
KYBER_SOURCES     = __asm_Kyber_NTT.S __asm_Kyber_iNTT.S __asm_Kyber_basemul.S
NTRUP_SOURCES     = __asm_NTRU_Prime_NTT.S __asm_NTRU_Prime_Rader17_primitive.S

all: polymul_small polymul_small_speed \
		gen_kyber_ntt_table kyber_ntt kyber_ntt_speed \
		gen_dilithium_ntt_table dilithium_ntt dilithium_ntt_speed \
		gen_ntrup_ntt_table ntrup_ntt ntrup_ntt_speed

polymul_small: polymul_small.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

polymul_small_speed: polymul_small_speed.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

gen_kyber_ntt_table: gen_kyber_ntt_table.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

kyber_ntt: kyber_ntt.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $(KYBER_SOURCES) $< -o $@

kyber_ntt_speed: kyber_ntt_speed.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(KYBER_SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

gen_dilithium_ntt_table: gen_dilithium_ntt_table.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

dilithium_ntt: dilithium_ntt.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $(DILITHIUM_SOURCES) $< -o $@

dilithium_ntt_speed: dilithium_ntt_speed.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(DILITHIUM_SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

gen_ntrup_ntt_table: gen_ntrup_ntt_table.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

ntrup_ntt: ntrup_ntt.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $(NTRUP_SOURCES) $< -o $@

ntrup_ntt_speed: ntrup_ntt_speed.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(NTRUP_SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean
clean:
	rm -f polymul_small
	rm -f polymul_small_speed
	rm -f gen_kyber_ntt_table
	rm -f kyber_ntt
	rm -f kyber_ntt_speed
	rm -f gen_dilithium_ntt_table
	rm -f dilithium_ntt
	rm -f dilithium_ntt_speed
	rm -f gen_ntrup_ntt_table
	rm -f ntrup_ntt
	rm -f ntrup_ntt_speed

