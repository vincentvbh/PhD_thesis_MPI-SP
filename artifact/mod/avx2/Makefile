
# platform independent flags
CC                     ?= gcc
CFLAGS                 += -Wall -O3

RM ?= /usr/bin/rm

# avx2 flags
AVX2_FLAGS              = -mavx2 -z noexecstack

COMMON_PATH = ./common

CFLAGS += -I$(COMMON_PATH)

CYCLES_PATH = $(COMMON_PATH)
CYCLES_HEADERS = $(CYCLES_PATH)/cycles.h
CYCLES_SOURCES = $(CYCLES_PATH)/cycles.c

HEADERS = compress_ref.h compress_old.h compress_opt.h
SOUCRES = compress_ref.c compress_old.c compress_opt.c

all: test speed

test: test.c $(HEADERS) $(SOUCRES)
	$(CC) $(CFLAGS) $(AVX2_FLAGS) $(SOUCRES) $< -o $@

speed: speed.c $(HEADERS) $(SOUCRES)
	$(CC) $(CFLAGS) $(AVX2_FLAGS) $(SOUCRES) $< -o $@

.PHONY: clean

clean:
	$(RM) -rf test
	$(RM) -rf speed



