
CC ?= gcc
CFLAGS = -O3 -Wall -march=native

HEADERS = matmul.h
SOURCES = matmul.c

all: test

test: test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

.PHONY: clean

clean:
	rm -f test
