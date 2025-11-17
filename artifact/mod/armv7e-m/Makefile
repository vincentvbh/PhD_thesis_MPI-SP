
COMMON_PATH             = ./common

include $(COMMON_PATH)/make.mk

all: intdiv.elf intdiv.bin \
	 intdiv_speed.elf intdiv_speed.bin

ARMv7-M_ASM             = __asm_compress_armv7e-m.S

intdiv.elf: intdiv.o $(ARMv7-M_ASM) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(ARMv7-M_ASM) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

intdiv_speed.elf: intdiv_speed.o $(ARMv7-M_ASM) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(ARMv7-M_ASM) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

.PHONY: clean libclean

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	rm -f *.d
	rm -f *.o
	rm -f *.bin
	rm -f *.elf





