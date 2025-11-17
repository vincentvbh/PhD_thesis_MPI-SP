
define schemelib_armv7-m
$(1)_$(2)_PATH        = $$(SOURCE_ROOT_PATH)/$(3)/$(4)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S)
$(1)_$(2)_OBJS        = $$(patsubst %.c, %.o, $$($(1)_$(2)_SOURCES))
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH) $(5)

obj/$(1)_$(2)_test.o: $$(TESTS_ROOT_PATH)/test.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$(1)_$(2)_test.elf: obj/$(1)_$(2)_test.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$(1)_$(2)_testvectors.o: $$(TESTS_ROOT_PATH)/testvectors.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$(1)_$(2)_testvectors.elf: obj/$(1)_$(2)_testvectors.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$(1)_$(2)_speed.o: $$(TESTS_ROOT_PATH)/speed.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$(1)_$(2)_speed.elf: obj/$(1)_$(2)_speed.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endef

define schemelib_armv7
$(1)_$(2)_PATH        = $$(SOURCE_ROOT_PATH)/$(3)/$(4)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S)
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH) $(5)

obj_armv7/$(1)_$(2)_test: $$(TESTS_ROOT_PATH)/test.c $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	$$(ARMv7_CROSS_CC) $$(ARMv7_CROSS_FLAGS) $$(ARMv7_CROSS_CFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(COMMON_PATH)/hal-opencm3.c $$($(1)_$(2)_SOURCES) $$< -o $$@

obj_armv7/$(1)_$(2)_testvectors: $$(TESTS_ROOT_PATH)/testvectors.c $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	$$(ARMv7_CROSS_CC) $$(ARMv7_CROSS_FLAGS) $$(ARMv7_CROSS_CFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(COMMON_PATH)/hal-opencm3.c $$($(1)_$(2)_SOURCES) $$< -o $$@
endef

$(eval $(call schemelib_armv7-m,lightsaber,ref,lightsaber,ref,))
$(eval $(call schemelib_armv7-m,saber,ref,saber,ref,))
$(eval $(call schemelib_armv7-m,firesaber,ref,firesaber,ref,))

$(eval $(call schemelib_armv7-m,lightsaber,old,lightsaber,old,))
$(eval $(call schemelib_armv7-m,saber,old,saber,old,))
$(eval $(call schemelib_armv7-m,firesaber,old,firesaber,old,))

$(eval $(call schemelib_armv7-m,lightsaber,opt,lightsaber,opt,))
$(eval $(call schemelib_armv7-m,saber,opt,saber,opt,))
$(eval $(call schemelib_armv7-m,firesaber,opt,firesaber,opt,))

$(eval $(call schemelib_armv7,lightsaber,ref,lightsaber,ref,))
$(eval $(call schemelib_armv7,saber,ref,saber,ref,))
$(eval $(call schemelib_armv7,firesaber,ref,firesaber,ref,))

$(eval $(call schemelib_armv7,lightsaber,old,lightsaber,old,))
$(eval $(call schemelib_armv7,saber,old,saber,old,))
$(eval $(call schemelib_armv7,firesaber,old,firesaber,old,))

$(eval $(call schemelib_armv7,lightsaber,opt,lightsaber,opt,))
$(eval $(call schemelib_armv7,saber,opt,saber,opt,))
$(eval $(call schemelib_armv7,firesaber,opt,firesaber,opt,))




