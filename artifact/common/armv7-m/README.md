
This folder contains various files for the Armv7-M implementations.

- Source code shared between cryptographic schemes.
    - `chacha20.[ch]`
    - `fips202.[ch]`
    - `keccakf1600.[hS]`
    - `randombytes.[ch]`
    - `rng.[ch]`
- External firmware library, configuration files, and makefile rules for compilation.
    - `hal-opencm3.c`
    - `hal.h`
    - `make.mk`
    - `nucleo-f2.cfg`
    - `sendfn.h`
    - `stm32f207zg.ld`
- Scripts and configuration files for compiling, testing and benchmarking.
    - `config.py`
    - `flash_bin.sh`
    - `makelib.sh`
    - `read_serial.py`


