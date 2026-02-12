
This folder contains various files for the Armv7E-M implementations.

- Source code shared between cryptographic schemes.
    - `chacha20.[ch]`
    - `crypto_sort.[ch]`
    - `fips202.[ch]`
    - `keccakf1600.[hS]`
    - `randombytes.[ch]`
    - `rng.[ch]`
    - `sha512.[ch]`
    - `sha512_inner32.s`
    - `sort_asm.S`
- External firmware library, configuration files, and makefile rules for compilation.
    - `hal-opencm3.c`
    - `hal.h`
    - `make.mk`
    - `sendfn.h`
    - `stm32f4discovery.ld`
- Scripts and configuration files for compiling, testing and benchmarking.
    - `config.py`
    - `flash_bin.sh`
    - `read_serial.py`
