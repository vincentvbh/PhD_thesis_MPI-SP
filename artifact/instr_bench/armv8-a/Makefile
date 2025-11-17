

CC ?= gcc

CFLAGS += -O3 -Wall -Wunused -march=armv8-a

COMMON_PATH = ./common

CFLAGS += -I$(COMMON_PATH)

COMMON_SOURCE =

CYCLES_PATH = ./common
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

BENCHFLAGS = -I$(CYCLES_PATH) -DBENCH

ASM_HEADERS =
ASM_SOURCES = __asm_dup_mov.S __asm_xtn.S __asm_sri.S
C_HEADERS =
C_SOURCES =

SOURCES = $(ASM_SOURCES) $(C_SOURCES)
HEADERS = $(ASM_HEADERS) $(C_HEADERS)

all: bench

bench: bench.c $(SOURCES) $(HEADERS) $(CYCLES_HEADERS) $(CYCLES_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(BENCHFLAGS) $(CYCLES_SOURCES) $< -o $@

.PHONY: clean
clean:
	rm -f bench


