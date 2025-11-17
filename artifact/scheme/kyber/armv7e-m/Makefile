
COMMON_PATH             = ./common

HASH_PATH               = $(COMMON_PATH)
HASH_HEADERS            = $(HASH_PATH)/fips202.h $(HASH_PATH)/keccakf1600.h
HASH_SOURCES            = $(HASH_PATH)/fips202.c $(HASH_PATH)/keccakf1600.S

RAND_PATH               = $(COMMON_PATH)
RAND_HEADERS            = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES            = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

COMMON_HEADERS          = $(HASH_HEADERS) $(RAND_HEADERS)
COMMON_SOURCES          = $(HASH_SOURCES) $(RAND_SOURCES)
COMMON_OBJS             = $(patsubst %.c, %.o, $(COMMON_SOURCES))

# cross-compilation targeting Armv7 on linux
ARMv7_CROSS_CC         ?= arm-linux-gnueabi-gcc
ARMv7_CROSS_FLAGS       = -march=armv7 -mthumb-interwork -z noexecstack -g -static -mfpu=neon
ARMv7_CROSS_CFLAGS      = $(CFLAGS) -O3 -Wall -DCROSS_ARMv7_HOSTTEST -I$(COMMON_PATH)

# cross-compilation targeting Armv7-M on linux/macOS
ARMv7-M_ARCH_FLAGS      = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
ARMv7-M_DEFINES         = -DSTM32F4 -DSTM32F407VG

ARMv7-M_CROSS_PREFIX   ?= arm-none-eabi
ARMv7-M_CROSS_CC        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_LD        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_OBJCOPY   = $(ARMv7-M_CROSS_PREFIX)-objcopy
ARMv7-M_CROSS_OBJDUMP   = $(ARMv7-M_CROSS_PREFIX)-objdump
ARMv7-M_CROSS_GDB       = $(ARMv7-M_CROSS_PREFIX)-gdb

OPENCM3_DIR             = $(COMMON_PATH)/libopencm3
OPENCM3_OBJS            = $(COMMON_PATH)/hal-opencm3.o
OPENCM3_LIBNAME         = opencm3_stm32f4

PLATFORM               ?= stm32f4discovery

ARMv7-M_LDSCRIPT        = $(COMMON_PATH)/$(PLATFORM).ld

ARMv7-M_CROSS_CFLAGS   += -O3 -Wall \
						  -I$(OPENCM3_DIR)/include -I$(COMMON_PATH) \
						  -fno-common $(ARMv7-M_ARCH_FLAGS) -MD $(ARMv7-M_DEFINES)

ARMv7-M_CROSS_LDFLAGS  += --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
		 				  -T$(ARMv7-M_LDSCRIPT) -nostartfiles \
		 				  $(ARMv7-M_ARCH_FLAGS) \
		 				  -L$(OPENCM3_DIR)/lib

opencm3_lib:
	@if [ ! "`ls -A $(OPENCM3_DIR)`" ] ; then \
		printf "######## ERROR ########\n"; \
		printf "\tlibopencm3 is not initialized.\n"; \
		printf "\tPlease run (in the root directory):\n"; \
		printf "\t$$ git submodule init\n"; \
		printf "\t$$ git submodule update\n"; \
		printf "\tbefore running make.\n"; \
		printf "######## ERROR ########\n"; \
		exit 1; \
		fi
	make -C $(OPENCM3_DIR)

SOURCE_ROOT_PATH      = ./
TESTS_ROOT_PATH       = ./

ALL_ELF = \
	elf/kyber512_ref_test.elf \
	elf/kyber512_ref_testvectors.elf \
	elf/kyber512_ref_speed.elf \
	elf/kyber768_ref_test.elf \
	elf/kyber768_ref_testvectors.elf \
	elf/kyber768_ref_speed.elf \
	elf/kyber1024_ref_test.elf \
	elf/kyber1024_ref_testvectors.elf \
	elf/kyber1024_ref_speed.elf \
	elf/kyber512_old_test.elf \
	elf/kyber512_old_testvectors.elf \
	elf/kyber512_old_speed.elf \
	elf/kyber768_old_test.elf \
	elf/kyber768_old_testvectors.elf \
	elf/kyber768_old_speed.elf \
	elf/kyber1024_old_test.elf \
	elf/kyber1024_old_testvectors.elf \
	elf/kyber1024_old_speed.elf \
	elf/kyber512_opt_test.elf \
	elf/kyber512_opt_testvectors.elf \
	elf/kyber512_opt_speed.elf \
	elf/kyber768_opt_test.elf \
	elf/kyber768_opt_testvectors.elf \
	elf/kyber768_opt_speed.elf \
	elf/kyber1024_opt_test.elf \
	elf/kyber1024_opt_testvectors.elf \
	elf/kyber1024_opt_speed.elf

ALL_BIN = $(patsubst elf/%, bin/%, $(patsubst %.elf, %.bin, $(ALL_ELF)))

BENCH_ELF = \
	elf/kyber512_ref_speed.elf \
	elf/kyber768_ref_speed.elf \
	elf/kyber1024_ref_speed.elf \
	elf/kyber512_old_speed.elf \
	elf/kyber768_old_speed.elf \
	elf/kyber1024_old_speed.elf \
	elf/kyber512_opt_speed.elf \
	elf/kyber768_opt_speed.elf \
	elf/kyber1024_opt_speed.elf

BENCH_BIN = $(patsubst elf/%, bin/%, $(patsubst %.elf, %.bin, $(BENCH_ELF)))

TEST_OBJ_ARMv7 = \
	obj_armv7/kyber512_ref_test \
	obj_armv7/kyber768_ref_test \
	obj_armv7/kyber1024_ref_test \
	obj_armv7/kyber512_old_test \
	obj_armv7/kyber768_old_test \
	obj_armv7/kyber1024_old_test \
	obj_armv7/kyber512_opt_test \
	obj_armv7/kyber768_opt_test \
	obj_armv7/kyber1024_opt_test

.PHONY: all all_armv7 clean libclean

all: $(ALL_ELF) $(ALL_BIN)

all_armv7: $(TEST_OBJ_ARMv7)

include scheme.mk

# default rules

%.o: %.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

%.o: %.S opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

bin/%.bin: elf/%.elf
	$(ARMv7-M_CROSS_OBJCOPY) -Obinary $< $@

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	find . -name '*.d' -delete
	find . -name '*.o' -delete
	rm -f bin/*
	rm -f elf/*
	rm -f obj/*
	rm -f obj_armv7/*



