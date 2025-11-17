
COMMON_PATH       = ./common

include $(COMMON_PATH)/make.mk

COMMON_HEADERS    = $(COMMON_PATH)/tools.h $(COMMON_PATH)/naive_mult.h $(COMMON_PATH)/gen_table.h
COMMON_SOURCES    = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c

DILITHIUM_HEADERS = Dilithium_params.h Dilithium_NTT_params.h \
					macros.i reduce.i mulmod.i butterflies.i
DILITHIUM_SOURCES = __asm_ntt.S __asm_intt.S __asm_mul.S __asm_Nussbaumer.S __asm_iNussbaumer.S __asm_TMVP_mul.S __asm_TMVP.S

DILITHIUM_HEADERS += $(COMMON_HEADERS)
DILITHIUM_SOURCES += $(COMMON_SOURCES)

.PHONY: test speed

all: test speed

test: Dilithium_test.elf Nussbaumer_test.elf

speed: Dilithium2_speed.elf Dilithium3_speed.elf Dilithium5_speed.elf Nussbaumer_speed.elf

Dilithium_test.elf: Dilithium_test.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

Dilithium2_speed.o: Dilithium_speed.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DDILITHIUM_MODE=2 -o $@ -c $<

Dilithium2_speed.elf: Dilithium2_speed.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

Dilithium3_speed.o: Dilithium_speed.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DDILITHIUM_MODE=3 -o $@ -c $<

Dilithium3_speed.elf: Dilithium3_speed.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

Dilithium5_speed.o: Dilithium_speed.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DDILITHIUM_MODE=5 -o $@ -c $<

Dilithium5_speed.elf: Dilithium5_speed.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

Nussbaumer_test.elf: Nussbaumer_test.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

Nussbaumer_speed.elf: Nussbaumer_speed.o $(DILITHIUM_HEADERS) $(DILITHIUM_SOURCES) $(OPENCM3_OBJS) $(ARMv7-M_CROSS_LDSCRIPT)
	$(ARMv7-M_CROSS_CC) $(OPENCM3_OBJS) $(DILITHIUM_SOURCES) $< -o $@ $(ARMv7-M_CROSS_LDFLAGS) -l$(OPENCM3_LIBNAME)

.PHONY: clean libclean

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	rm -f *.d
	rm -f *.o
	rm -f *.bin
	rm -f *.elf

