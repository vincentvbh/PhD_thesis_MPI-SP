
CC ?= gcc

CFLAGS += -O3 -Wall -Wunused -march=armv8-a

COMMON_PATH = ./common

CFLAGS += -I$(COMMON_PATH)

COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

CYCLES_PATH = ./common
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS = macros.i macros_common.i
ASM_SOURCES = __asm_mulmod.S __asm_compress_neon.S
C_HEADERS =
C_SOURCES =

SOURCES = $(ASM_SOURCES) $(C_SOURCES)
HEADERS = $(ASM_HEADERS) $(C_HEADERS)

all: mulmod intdiv intdiv_speed

mulmod: mulmod.c $(SOURCES) $(HEADERS) $(COMMON_SOURCE)
	$(CC) $(CFLAGS) $(SOURCES) $(COMMON_SOURCE) $< -o $@

intdiv: intdiv.c $(SOURCES) $(HEADERS) $(COMMON_SOURCE)
	$(CC) $(CFLAGS) $(SOURCES) $(COMMON_SOURCE) $< -o $@

intdiv_speed: intdiv_speed.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean
clean:
	rm -f mulmod
	rm -f intdiv
	rm -f intdiv_speed




