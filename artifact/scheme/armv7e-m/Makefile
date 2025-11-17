
COMMON_PATH             = ./common

HASH_PATH               = $(COMMON_PATH)
HASH_HEADERS            = $(HASH_PATH)/fips202.h $(HASH_PATH)/keccakf1600.h $(HASH_PATH)/sha512.h
HASH_SOURCES            = $(HASH_PATH)/fips202.c $(HASH_PATH)/keccakf1600.S $(HASH_PATH)/sha512.c $(HASH_PATH)/sha512_inner32.s

HASH_PROFILE_OBJS       = $(patsubst %.c, %_profile_hashing.o, $(HASH_SOURCES))

RAND_PATH               = $(COMMON_PATH)
RAND_HEADERS            = $(RAND_PATH)/randombytes.h $(RAND_PATH)/rng.h $(RAND_PATH)/chacha20.h
RAND_SOURCES            = $(RAND_PATH)/randombytes.c $(RAND_PATH)/rng.c $(RAND_PATH)/chacha20.c

SORT_PATH               = $(COMMON_PATH)
SORT_HEADERS            = $(SORT_PATH)/crypto_sort.h
SORT_SOURCES	        = $(SORT_PATH)/crypto_sort.c $(SORT_PATH)/sort_asm.S

COMMON_HEADERS          = $(HASH_HEADERS) $(RAND_HEADERS) $(SORT_HEADERS)
COMMON_SOURCES          = $(HASH_SOURCES) $(RAND_SOURCES) $(SORT_SOURCES)
COMMON_OBJS             = $(patsubst %.c, %.o, $(COMMON_SOURCES))

PROFILE_HEADERS         = $(HASH_HEADERS) $(RAND_HEADERS) $(SORT_HEADERS)
PROFILE_SOURCES         = $(RAND_SOURCES) $(SORT_SOURCES)
PROFILE_OBJS            = $(HASH_PROFILE_OBJS) $(patsubst %.c, %.o, $(PROFILE_SOURCES))

# cross-compilation targeting ARMv7E-M on linux/macOS
ARMv7E-M_ARCH_FLAGS     = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
ARMv7E-M_DEFINES        = -DSTM32F4 -DSTM32F407VG

ARMv7E-M_CROSS_PREFIX  ?= arm-none-eabi
ARMv7E-M_CROSS_CC       = $(ARMv7E-M_CROSS_PREFIX)-gcc
ARMv7E-M_CROSS_LD       = $(ARMv7E-M_CROSS_PREFIX)-gcc
ARMv7E-M_CROSS_OBJCOPY  = $(ARMv7E-M_CROSS_PREFIX)-objcopy
ARMv7E-M_CROSS_OBJDUMP  = $(ARMv7E-M_CROSS_PREFIX)-objdump
ARMv7E-M_CROSS_GDB      = $(ARMv7E-M_CROSS_PREFIX)-gdb

OPENCM3_DIR             = $(COMMON_PATH)/libopencm3
OPENCM3_OBJS            = $(COMMON_PATH)/hal-opencm3.o
OPENCM3_LIBNAME         = opencm3_stm32f4

DEVICE                 ?= stm32f4discovery

ARMv7E-M_LDSCRIPT       = $(COMMON_PATH)/$(DEVICE).ld

ARMv7E-M_CROSS_CFLAGS  += -O3 -Wall \
						  -I$(OPENCM3_DIR)/include -I$(COMMON_PATH) \
						  -fno-common $(ARMv7E-M_ARCH_FLAGS) -MD $(ARMv7E-M_DEFINES)

ARMv7E-M_CROSS_LDFLAGS += --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
		 				  -T$(ARMv7E-M_LDSCRIPT) -nostartfiles \
		 				  $(ARMv7E-M_ARCH_FLAGS) \
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
	dilithium/elf/dilithium5_old_stack_test.elf \
	dilithium/elf/dilithium5_old_stack_testvectors.elf \
	dilithium/elf/dilithium2_old_speed_test.elf \
	dilithium/elf/dilithium2_old_speed_testvectors.elf \
	dilithium/elf/dilithium3_old_speed_test.elf \
	dilithium/elf/dilithium3_old_speed_testvectors.elf \
	dilithium/elf/dilithium5_old_speed_test.elf \
	dilithium/elf/dilithium5_old_speed_testvectors.elf \

DILITHIUM_TEST_BIN = $(patsubst dilithium/elf/%, dilithium/bin/%, $(patsubst %.elf, %.bin, $(DILITHIUM_TEST_ELF)))

DILITHIUM_SPEED_ELF = \
	dilithium/elf/dilithium5_old_stack_speed.elf \
	dilithium/elf/dilithium5_old_stack_profile_hashing.elf \
	dilithium/elf/dilithium2_old_speed_speed.elf \
	dilithium/elf/dilithium2_old_speed_speed_local.elf \
	dilithium/elf/dilithium2_old_speed_profile_hashing.elf \
	dilithium/elf/dilithium3_old_speed_speed.elf \
	dilithium/elf/dilithium3_old_speed_speed_local.elf \
	dilithium/elf/dilithium3_old_speed_profile_hashing.elf \
	dilithium/elf/dilithium5_old_speed_speed.elf \
	dilithium/elf/dilithium5_old_speed_speed_local.elf \


DILITHIUM_SPEED_BIN = $(patsubst dilithium/elf/%, dilithium/bin/%, $(patsubst %.elf, %.bin, $(DILITHIUM_SPEED_ELF)))

DILITHIUM_ELF = $(DILITHIUM_TEST_ELF) $(DILITHIUM_SPEED_ELF)
DILITHIUM_BIN = $(DILITHIUM_TEST_BIN) $(DILITHIUM_SPEED_BIN)

dilithium: \
	$(DILITHIUM_BIN)

KYBER_TEST_ELF = \
	kyber/elf/kyber512_ref_test.elf \
	kyber/elf/kyber512_ref_testvectors.elf \
	kyber/elf/kyber768_ref_test.elf \
	kyber/elf/kyber768_ref_testvectors.elf \
	kyber/elf/kyber1024_ref_test.elf \
	kyber/elf/kyber1024_ref_testvectors.elf \
	kyber/elf/kyber512_old_montgomery_barrett_test.elf \
	kyber/elf/kyber512_old_montgomery_barrett_testvectors.elf \
	kyber/elf/kyber768_old_montgomery_barrett_test.elf \
	kyber/elf/kyber768_old_montgomery_barrett_testvectors.elf \
	kyber/elf/kyber1024_old_montgomery_barrett_test.elf \
	kyber/elf/kyber1024_old_montgomery_barrett_testvectors.elf \
	kyber/elf/kyber512_old_plant_test.elf \
	kyber/elf/kyber512_old_plant_testvectors.elf \
	kyber/elf/kyber768_old_plant_test.elf \
	kyber/elf/kyber768_old_plant_testvectors.elf \
	kyber/elf/kyber1024_old_plant_test.elf \
	kyber/elf/kyber1024_old_plant_testvectors.elf \
	kyber/elf/kyber512_opt_test.elf \
	kyber/elf/kyber512_opt_testvectors.elf \
	kyber/elf/kyber768_opt_test.elf \
	kyber/elf/kyber768_opt_testvectors.elf \
	kyber/elf/kyber1024_opt_test.elf \
	kyber/elf/kyber1024_opt_testvectors.elf

KYBER_TEST_BIN = $(patsubst kyber/elf/%, kyber/bin/%, $(patsubst %.elf, %.bin, $(KYBER_TEST_ELF)))

KYBER_SPEED_ELF = \
	kyber/elf/kyber512_old_montgomery_barrett_speed.elf \
	kyber/elf/kyber512_old_montgomery_barrett_speed_local_hashing.elf \
	kyber/elf/kyber768_old_montgomery_barrett_speed.elf \
	kyber/elf/kyber768_old_montgomery_barrett_speed_local_hashing.elf \
	kyber/elf/kyber1024_old_montgomery_barrett_speed.elf \
	kyber/elf/kyber1024_old_montgomery_barrett_speed_local_hashing.elf \
	kyber/elf/kyber512_old_plant_speed.elf \
	kyber/elf/kyber512_old_plant_speed_local.elf \
	kyber/elf/kyber512_old_plant_profile_hashing.elf \
	kyber/elf/kyber512_old_plant_speed_local_hashing.elf \
	kyber/elf/kyber768_old_plant_speed.elf \
	kyber/elf/kyber768_old_plant_profile_hashing.elf \
	kyber/elf/kyber768_old_plant_speed_local_hashing.elf \
	kyber/elf/kyber1024_old_plant_speed.elf \
	kyber/elf/kyber1024_old_plant_profile_hashing.elf \
	kyber/elf/kyber1024_old_plant_speed_local_hashing.elf \
	kyber/elf/kyber512_opt_speed.elf \
	kyber/elf/kyber768_opt_speed.elf \
	kyber/elf/kyber1024_opt_speed.elf

KYBER_SPEED_BIN = $(patsubst kyber/elf/%, kyber/bin/%, $(patsubst %.elf, %.bin, $(KYBER_SPEED_ELF)))

KYBER_ELF = $(KYBER_TEST_ELF) $(KYBER_SPEED_ELF)
KYBER_BIN = $(KYBER_TEST_BIN) $(KYBER_SPEED_BIN)

kyber: \
	$(KYBER_BIN)

SABER_TEST_ELF = \
	saber/elf/lightsaber_ref_test.elf \
	saber/elf/lightsaber_ref_testvectors.elf \
	saber/elf/saber_ref_test.elf \
	saber/elf/saber_ref_testvectors.elf \
	saber/elf/firesaber_ref_test.elf \
	saber/elf/firesaber_ref_testvectors.elf \
	saber/elf/lightsaber_old_tmvp_test.elf \
	saber/elf/lightsaber_old_tmvp_testvectors.elf \
	saber/elf/saber_old_tmvp_test.elf \
	saber/elf/saber_old_tmvp_testvectors.elf \
	saber/elf/firesaber_old_tmvp_test.elf \
	saber/elf/firesaber_old_tmvp_testvectors.elf \
	saber/elf/lightsaber_old_stack_test.elf \
	saber/elf/lightsaber_old_stack_testvectors.elf \
	saber/elf/saber_old_stack_test.elf \
	saber/elf/saber_old_stack_testvectors.elf \
	saber/elf/firesaber_old_stack_test.elf \
	saber/elf/firesaber_old_stack_testvectors.elf \
	saber/elf/lightsaber_old_speed_test.elf \
	saber/elf/lightsaber_old_speed_testvectors.elf \
	saber/elf/saber_old_speed_test.elf \
	saber/elf/saber_old_speed_testvectors.elf \
	saber/elf/firesaber_old_speed_test.elf \
	saber/elf/firesaber_old_speed_testvectors.elf

SABER_TEST_BIN = $(patsubst saber/elf/%, saber/bin/%, $(patsubst %.elf, %.bin, $(SABER_TEST_ELF)))

SABER_SPEED_ELF = \
	saber/elf/lightsaber_old_tmvp_speed.elf \
	saber/elf/lightsaber_old_tmvp_speed_local.elf \
	saber/elf/lightsaber_old_tmvp_profile_hashing.elf \
	saber/elf/saber_old_tmvp_speed.elf \
	saber/elf/saber_old_tmvp_speed_local.elf \
	saber/elf/saber_old_tmvp_profile_hashing.elf \
	saber/elf/firesaber_old_tmvp_speed.elf \
	saber/elf/firesaber_old_tmvp_speed_local.elf \
	saber/elf/firesaber_old_tmvp_profile_hashing.elf \
	saber/elf/lightsaber_old_stack_speed.elf \
	saber/elf/saber_old_stack_speed.elf \
	saber/elf/firesaber_old_stack_speed.elf \
	saber/elf/lightsaber_old_speed_speed.elf \
	saber/elf/lightsaber_old_speed_speed_local.elf \
	saber/elf/saber_old_speed_speed.elf \
	saber/elf/saber_old_speed_speed_local.elf \
	saber/elf/firesaber_old_speed_speed.elf \
	saber/elf/firesaber_old_speed_speed_local.elf

SABER_SPEED_BIN = $(patsubst saber/elf/%, saber/bin/%, $(patsubst %.elf, %.bin, $(SABER_SPEED_ELF)))

SABER_ELF = $(SABER_TEST_ELF) $(SABER_SPEED_ELF)
SABER_BIN = $(SABER_TEST_BIN) $(SABER_SPEED_BIN)

saber: \
	$(SABER_BIN)

NTRU_TEST_ELF = \
	ntru/elf/ntruhps2048677_ref_test.elf \
	ntru/elf/ntruhps2048677_ref_testvectors.elf \
	ntru/elf/ntruhrss701_ref_test.elf \
	ntru/elf/ntruhrss701_ref_testvectors.elf \
	ntru/elf/ntruhps2048677_old_1536_test.elf \
	ntru/elf/ntruhps2048677_old_1536_testvectors.elf \
	ntru/elf/ntruhrss701_old_1536_test.elf \
	ntru/elf/ntruhrss701_old_1536_testvectors.elf \
	ntru/elf/ntruhps2048677_old_tmvp_test.elf \
	ntru/elf/ntruhps2048677_old_tmvp_testvectors.elf \
	ntru/elf/ntruhrss701_old_tmvp_test.elf \
	ntru/elf/ntruhrss701_old_tmvp_testvectors.elf \
	ntru/elf/ntruhps2048677_old_1440_test.elf \
	ntru/elf/ntruhps2048677_old_1440_testvectors.elf \
	ntru/elf/ntruhrss701_old_1440_test.elf \
	ntru/elf/ntruhrss701_old_1440_testvectors.elf

NTRU_TEST_BIN = $(patsubst ntru/elf/%, ntru/bin/%, $(patsubst %.elf, %.bin, $(NTRU_TEST_ELF)))

NTRU_SPEED_ELF = \
	ntru/elf/ntruhps2048677_old_1536_speed.elf \
	ntru/elf/ntruhps2048677_old_1536_speed_local.elf \
	ntru/elf/ntruhps2048677_old_1536_profile_hashing.elf \
	ntru/elf/ntruhrss701_old_1536_speed.elf \
	ntru/elf/ntruhrss701_old_1536_speed_local.elf \
	ntru/elf/ntruhrss701_old_1536_profile_hashing.elf \
	ntru/elf/ntruhps2048677_old_tmvp_speed.elf \
	ntru/elf/ntruhrss701_old_tmvp_speed.elf \
	ntru/elf/ntruhps2048677_old_1440_speed.elf \
	ntru/elf/ntruhps2048677_old_1440_speed_local.elf \
	ntru/elf/ntruhrss701_old_1440_speed.elf \
	ntru/elf/ntruhrss701_old_1440_speed_local.elf

NTRU_SPEED_BIN = $(patsubst ntru/elf/%, ntru/bin/%, $(patsubst %.elf, %.bin, $(NTRU_SPEED_ELF)))

NTRU_ELF = $(NTRU_TEST_ELF) $(NTRU_SPEED_ELF)
NTRU_BIN = $(NTRU_TEST_BIN) $(NTRU_SPEED_BIN)

ntru: \
	$(NTRU_BIN)

NTRUP_TEST_ELF = \
	ntrup/elf/sntrup761_ref_test.elf \
	ntrup/elf/sntrup761_ref_testvectors.elf \
	ntrup/elf/sntrup761_old_1536_test.elf \
	ntrup/elf/sntrup761_old_1536_testvectors.elf \
	ntrup/elf/sntrup761_old_1530_test.elf \
	ntrup/elf/sntrup761_old_1530_testvectors.elf

NTRUP_TEST_BIN = $(patsubst ntrup/elf/%, ntrup/bin/%, $(patsubst %.elf, %.bin, $(NTRUP_TEST_ELF)))

NTRUP_SPEED_ELF = \
	ntrup/elf/sntrup761_old_1536_speed.elf \
	ntrup/elf/sntrup761_old_1536_speed_local.elf \
	ntrup/elf/sntrup761_old_1536_profile_hashing.elf \
	ntrup/elf/sntrup761_old_1530_speed.elf \
	ntrup/elf/sntrup761_old_1530_speed_local.elf

NTRUP_SPEED_BIN = $(patsubst ntrup/elf/%, ntrup/bin/%, $(patsubst %.elf, %.bin, $(NTRUP_SPEED_ELF)))

NTRUP_ELF = $(NTRUP_TEST_ELF) $(NTRUP_SPEED_ELF)
NTRUP_BIN = $(NTRUP_TEST_BIN) $(NTRUP_SPEED_BIN)

ntrup: \
	$(NTRUP_BIN)

.PHONY: all clean libclean

all: \
	dilithium \
	kyber \
	saber \
	ntru \
	ntrup

include scheme.mk

# default rules

%_profile_hashing.o: %.c opencm3_lib
	$(ARMv7E-M_CROSS_CC) $(ARMv7E-M_CROSS_CFLAGS) -DPROFILE_HASHING -o $@ -c $<

%_profile_hashing.o: %.S opencm3_lib
	$(ARMv7E-M_CROSS_CC) $(ARMv7E-M_CROSS_CFLAGS) -DPROFILE_HASHING -o $@ -c $<

%.o: %.c opencm3_lib
	$(ARMv7E-M_CROSS_CC) $(ARMv7E-M_CROSS_CFLAGS) -o $@ -c $<

%.o: %.S opencm3_lib
	$(ARMv7E-M_CROSS_CC) $(ARMv7E-M_CROSS_CFLAGS) -o $@ -c $<

define makebin
$(1)/bin/%.bin: $(1)/elf/%.elf
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_OBJCOPY) -Obinary $$< $$@
endef

$(eval $(call makebin,dilithium))
$(eval $(call makebin,kyber))
$(eval $(call makebin,saber))
$(eval $(call makebin,ntru))
$(eval $(call makebin,ntrup))

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	find . -name '*.d' -delete
	find . -name '*.o' -delete
	rm -rf **/obj
	rm -rf **/elf
	rm -rf **/bin




