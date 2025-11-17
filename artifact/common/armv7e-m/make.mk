
COMMON_PATH            ?= .

# cross-compilation targeting Armv7-M on macOS
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

%.bin: %.elf
	$(ARMv7-M_CROSS_OBJCOPY) -Obinary $(*).elf $(*).bin

%.elf: %.o $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_LD) -o $(*).elf $(*).o $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

%.o: %.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

%.o: %.S opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

