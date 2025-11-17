
CC ?= gcc

CFLAGS += -O3 -Wall -Wunused -Wpedantic -Wno-pointer-arith -Wsign-compare

COMMON_PATH = ./common

CFLAGS += -I$(COMMON_PATH)

COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

C_HEADERS =
C_SOURCES =

SOURCES = $(C_SOURCES) $(COMMON_SOURCE)
HEADERS = $(C_HEADERS)

all: \
	DWT DWT_mixed DWT_merged_layers \
	FNT \
	GT \
	Karatsuba Karatsuba-striding Karatsuba-striding_multi-layer \
	Nussbaumer Schoenhage \
	TC TC-striding Toeplitz-TC

DWT: DWT.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

DWT_mixed: DWT_mixed.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

DWT_merged_layers: DWT_merged_layers.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

FNT: FNT.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

GT: GT.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Karatsuba: Karatsuba.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Karatsuba-striding: Karatsuba-striding.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Karatsuba-striding_multi-layer: Karatsuba-striding_multi-layer.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Nussbaumer: Nussbaumer.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Schoenhage: Schoenhage.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

TC: TC.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

TC-striding: TC-striding.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

Toeplitz-TC: Toeplitz-TC.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@


.PHONY: clean
clean:
	rm -f DWT
	rm -f DWT_mixed
	rm -f DWT_merged_layers
	rm -f FNT
	rm -f GT
	rm -f Karatsuba
	rm -f Karatsuba-striding
	rm -f Karatsuba-striding_multi-layer
	rm -f Nussbaumer
	rm -f Schoenhage
	rm -f TC
	rm -f TC-striding
	rm -f Toeplitz-TC





