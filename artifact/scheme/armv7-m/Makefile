
COMMON_PATH             = ./common

HASH_PATH               = $(COMMON_PATH)
HASH_HEADERS            = $(HASH_PATH)/fips202.h $(HASH_PATH)/keccakf1600.h
HASH_SOURCES            = $(HASH_PATH)/fips202.c $(HASH_PATH)/keccakf1600.S

HASH_PROFILE_OBJS       = $(patsubst %.c, %_profile_hashing.o, $(HASH_SOURCES))

RAND_PATH               = $(COMMON_PATH)
RAND_HEADERS            = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES            = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

COMMON_HEADERS          = $(HASH_HEADERS) $(RAND_HEADERS)
COMMON_SOURCES          = $(HASH_SOURCES) $(RAND_SOURCES)
COMMON_OBJS             = $(patsubst %.c, %.o, $(COMMON_SOURCES))

PROFILE_HEADERS         = $(HASH_HEADERS) $(RAND_HEADERS) $(SORT_HEADERS)
PROFILE_SOURCES         = $(RAND_SOURCES) $(SORT_SOURCES)
PROFILE_OBJS            = $(HASH_PROFILE_OBJS) $(patsubst %.c, %.o, $(PROFILE_SOURCES))

# cross-compilation targeting Armv7-M on macOS
ARMv7-M_ARCH_FLAGS      = -mthumb -mcpu=cortex-m3
ARMv7-M_DEFINES         = -DSTM32F2 -DSTM32F207ZG

ARMv7-M_CROSS_PREFIX   ?= arm-none-eabi
ARMv7-M_CROSS_CC        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_LD        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_OBJCOPY   = $(ARMv7-M_CROSS_PREFIX)-objcopy
ARMv7-M_CROSS_OBJDUMP   = $(ARMv7-M_CROSS_PREFIX)-objdump
ARMv7-M_CROSS_GDB       = $(ARMv7-M_CROSS_PREFIX)-gdb

OPENCM3_DIR             = $(COMMON_PATH)/libopencm3
OPENCM3_OBJS            = $(COMMON_PATH)/hal-opencm3.o
OPENCM3_LIBNAME         = opencm3_stm32f2

PLATFORM               ?= stm32f207zg

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

DILITHIUM_TEST_ELF = \
	dilithium/elf/dilithium2_ref_test.elf \
	dilithium/elf/dilithium2_ref_testvectors.elf \
	dilithium/elf/dilithium3_ref_test.elf \
	dilithium/elf/dilithium3_ref_testvectors.elf \
	dilithium/elf/dilithium2_old_test.elf \
	dilithium/elf/dilithium2_old_testvectors.elf \
	dilithium/elf/dilithium3_old_test.elf \
	dilithium/elf/dilithium3_old_testvectors.elf \
	dilithium/elf/dilithium5_old_test.elf \
	dilithium/elf/dilithium5_old_testvectors.elf \
	dilithium/elf/dilithium2_opt_test.elf \
	dilithium/elf/dilithium2_opt_testvectors.elf \
	dilithium/elf/dilithium3_opt_test.elf \
	dilithium/elf/dilithium3_opt_testvectors.elf \
	dilithium/elf/dilithium5_opt_test.elf \
	dilithium/elf/dilithium5_opt_testvectors.elf

DILITHIUM_SPEED_ELF = \
	dilithium/elf/dilithium2_old_speed.elf \
	dilithium/elf/dilithium2_old_speed_local.elf \
	dilithium/elf/dilithium2_old_profile_hashing.elf \
	dilithium/elf/dilithium3_old_speed.elf \
	dilithium/elf/dilithium3_old_speed_local.elf \
	dilithium/elf/dilithium3_old_profile_hashing.elf \
	dilithium/elf/dilithium5_old_speed.elf \
	dilithium/elf/dilithium5_old_speed_local.elf \
	dilithium/elf/dilithium5_old_profile_hashing.elf \
	dilithium/elf/dilithium2_opt_speed.elf \
	dilithium/elf/dilithium2_opt_speed_local.elf \
	dilithium/elf/dilithium3_opt_speed.elf \
	dilithium/elf/dilithium3_opt_speed_local.elf \
	dilithium/elf/dilithium5_opt_speed.elf \
	dilithium/elf/dilithium5_opt_speed_local.elf

dilithium: \
	$(DILITHIUM_TEST_ELF) \
	$(DILITHIUM_SPEED_ELF)

KYBER_TEST_ELF = \
	kyber/elf/kyber512_ref_test.elf \
	kyber/elf/kyber512_ref_testvectors.elf \
	kyber/elf/kyber768_ref_test.elf \
	kyber/elf/kyber768_ref_testvectors.elf \
	kyber/elf/kyber1024_ref_test.elf \
	kyber/elf/kyber1024_ref_testvectors.elf \
	kyber/elf/kyber512_old_test.elf \
	kyber/elf/kyber512_old_testvectors.elf \
	kyber/elf/kyber768_old_test.elf \
	kyber/elf/kyber768_old_testvectors.elf \
	kyber/elf/kyber1024_old_test.elf \
	kyber/elf/kyber1024_old_testvectors.elf \
	kyber/elf/kyber512_opt_test.elf \
	kyber/elf/kyber512_opt_testvectors.elf \
	kyber/elf/kyber768_opt_test.elf \
	kyber/elf/kyber768_opt_testvectors.elf \
	kyber/elf/kyber1024_opt_test.elf \
	kyber/elf/kyber1024_opt_testvectors.elf

KYBER_SPEED_ELF = \
	kyber/elf/kyber512_old_speed.elf \
	kyber/elf/kyber512_old_speed_local.elf \
	kyber/elf/kyber512_old_profile_hashing.elf \
	kyber/elf/kyber512_old_speed_local_hashing.elf \
	kyber/elf/kyber768_old_speed.elf \
	kyber/elf/kyber768_old_profile_hashing.elf \
	kyber/elf/kyber768_old_speed_local_hashing.elf \
	kyber/elf/kyber1024_old_speed.elf \
	kyber/elf/kyber1024_old_profile_hashing.elf \
	kyber/elf/kyber1024_old_speed_local_hashing.elf \
	kyber/elf/kyber512_opt_speed.elf \
	kyber/elf/kyber768_opt_speed.elf \
	kyber/elf/kyber1024_opt_speed.elf

kyber: \
	$(KYBER_TEST_ELF) \
	$(KYBER_SPEED_ELF)

SABER_TEST_ELF = \
	saber/elf/lightsaber_ref_test.elf \
	saber/elf/lightsaber_ref_testvectors.elf \
	saber/elf/saber_ref_test.elf \
	saber/elf/saber_ref_testvectors.elf \
	saber/elf/firesaber_ref_test.elf \
	saber/elf/firesaber_ref_testvectors.elf \
	saber/elf/lightsaber_old_tc_test.elf \
	saber/elf/lightsaber_old_tc_testvectors.elf \
	saber/elf/saber_old_tc_test.elf \
	saber/elf/saber_old_tc_testvectors.elf \
	saber/elf/firesaber_old_tc_test.elf \
	saber/elf/firesaber_old_tc_testvectors.elf \
	saber/elf/lightsaber_old_32bit_test.elf \
	saber/elf/lightsaber_old_32bit_testvectors.elf \
	saber/elf/saber_old_32bit_test.elf \
	saber/elf/saber_old_32bit_testvectors.elf \
	saber/elf/firesaber_old_32bit_test.elf \
	saber/elf/firesaber_old_32bit_testvectors.elf \
	saber/elf/lightsaber_old_16bit_test.elf \
	saber/elf/lightsaber_old_16bit_testvectors.elf \
	saber/elf/saber_old_16bit_test.elf \
	saber/elf/saber_old_16bit_testvectors.elf \
	saber/elf/firesaber_old_16bit_test.elf \
	saber/elf/firesaber_old_16bit_testvectors.elf \
	saber/elf/lightsaber_opt_test.elf \
	saber/elf/lightsaber_opt_testvectors.elf \
	saber/elf/saber_opt_test.elf \
	saber/elf/saber_opt_testvectors.elf \
	saber/elf/firesaber_opt_test.elf \
	saber/elf/firesaber_opt_testvectors.elf

SABER_SPEED_ELF = \
	saber/elf/lightsaber_old_tc_speed.elf \
	saber/elf/lightsaber_old_tc_speed_local.elf \
	saber/elf/lightsaber_old_tc_profile_hashing.elf \
	saber/elf/saber_old_tc_speed.elf \
	saber/elf/saber_old_tc_speed_local.elf \
	saber/elf/saber_old_tc_profile_hashing.elf \
	saber/elf/firesaber_old_tc_speed.elf \
	saber/elf/firesaber_old_tc_speed_local.elf \
	saber/elf/firesaber_old_tc_profile_hashing.elf \
	saber/elf/lightsaber_old_32bit_speed.elf \
	saber/elf/lightsaber_old_32bit_speed_local.elf \
	saber/elf/saber_old_32bit_speed.elf \
	saber/elf/saber_old_32bit_speed_local.elf \
	saber/elf/firesaber_old_32bit_speed.elf \
	saber/elf/firesaber_old_32bit_speed_local.elf \
	saber/elf/lightsaber_old_16bit_speed.elf \
	saber/elf/lightsaber_old_16bit_speed_local.elf \
	saber/elf/saber_old_16bit_speed.elf \
	saber/elf/saber_old_16bit_speed_local.elf \
	saber/elf/firesaber_old_16bit_speed.elf \
	saber/elf/firesaber_old_16bit_speed_local.elf \
	saber/elf/lightsaber_opt_speed.elf \
	saber/elf/lightsaber_opt_speed_local.elf \
	saber/elf/saber_opt_speed.elf \
	saber/elf/saber_opt_speed_local.elf \
	saber/elf/firesaber_opt_speed.elf \
	saber/elf/firesaber_opt_speed_local.elf

saber: \
	$(SABER_TEST_ELF) \
	$(SABER_SPEED_ELF)

.PHONY: all clean libclean

all: \
	dilithium \
	kyber \
	saber

include scheme.mk

# default rules

%_profile_hashing.o: %.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DPROFILE_HASHING -o $@ -c $<

%_profile_hashing.o: %.S opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DPROFILE_HASHING -o $@ -c $<

%.o: %.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

%.o: %.S opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	find . -name '*.d' -delete
	find . -name '*.o' -delete
	rm -rf **/obj
	rm -rf **/elf



