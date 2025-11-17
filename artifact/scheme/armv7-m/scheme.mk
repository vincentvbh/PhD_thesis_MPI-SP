
define schemelib_armv7-m
$(1)_$(2)_PATH        = ./$(3)/$(4)/$(5)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(filter-out $$($(1)_$(2)_PATH)/speed_local.c $$($(1)_$(2)_PATH)/speed_local_hashing.c, $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S))
$(1)_$(2)_OBJS        = $$(patsubst %.c, %.o, $$($(1)_$(2)_SOURCES))
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH)

$(3)/obj/$(1)_$(2)_test.o: test_$(6)/test.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_test.elf: $(3)/obj/$(1)_$(2)_test.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

$(3)/obj/$(1)_$(2)_testvectors.o: test_$(6)/testvectors.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_testvectors.elf: $(3)/obj/$(1)_$(2)_testvectors.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

$(3)/obj/$(1)_$(2)_speed.o: test_$(6)/speed.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed.elf: $(3)/obj/$(1)_$(2)_speed.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

ifneq (,$$(wildcard $$($(1)_$(2)_PATH)/speed_local.c))
$(3)/obj/$(1)_$(2)_speed_local.o: $$($(1)_$(2)_PATH)/speed_local.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed_local.elf: $(3)/obj/$(1)_$(2)_speed_local.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endif

$(3)/obj/$(1)_$(2)_profile_hashing.o: test_$(6)/hashing.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_profile_hashing.elf: $(3)/obj/$(1)_$(2)_profile_hashing.o $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

ifneq (,$$(wildcard $$($(1)_$(2)_PATH)/speed_local_hashing.c))
$(3)/obj/$(1)_$(2)_speed_local_hashing.o: $$($(1)_$(2)_PATH)/speed_local_hashing.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed_local_hashing.elf: $(3)/obj/$(1)_$(2)_speed_local_hashing.o $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7-M_CROSS_LD) $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endif
endef

# Kyber

$(eval $(call schemelib_armv7-m,kyber512,ref,kyber,kyber512,ref,kem))
$(eval $(call schemelib_armv7-m,kyber768,ref,kyber,kyber768,ref,kem))
$(eval $(call schemelib_armv7-m,kyber1024,ref,kyber,kyber1024,ref,kem))

$(eval $(call schemelib_armv7-m,kyber512,old,kyber,kyber512,old,kem))
$(eval $(call schemelib_armv7-m,kyber768,old,kyber,kyber768,old,kem))
$(eval $(call schemelib_armv7-m,kyber1024,old,kyber,kyber1024,old,kem))

$(eval $(call schemelib_armv7-m,kyber512,opt,kyber,kyber512,opt,kem))
$(eval $(call schemelib_armv7-m,kyber768,opt,kyber,kyber768,opt,kem))
$(eval $(call schemelib_armv7-m,kyber1024,opt,kyber,kyber1024,opt,kem))

# Saber

$(eval $(call schemelib_armv7-m,lightsaber,ref,saber,lightsaber,ref,kem))
$(eval $(call schemelib_armv7-m,saber,ref,saber,saber,ref,kem))
$(eval $(call schemelib_armv7-m,firesaber,ref,saber,firesaber,ref,kem))

$(eval $(call schemelib_armv7-m,lightsaber,old_tc,saber,lightsaber,old_tc,kem))
$(eval $(call schemelib_armv7-m,saber,old_tc,saber,saber,old_tc,kem))
$(eval $(call schemelib_armv7-m,firesaber,old_tc,saber,firesaber,old_tc,kem))

$(eval $(call schemelib_armv7-m,lightsaber,old_32bit,saber,lightsaber,old_32bit,kem))
$(eval $(call schemelib_armv7-m,saber,old_32bit,saber,saber,old_32bit,kem))
$(eval $(call schemelib_armv7-m,firesaber,old_32bit,saber,firesaber,old_32bit,kem))

$(eval $(call schemelib_armv7-m,lightsaber,old_16bit,saber,lightsaber,old_16bit,kem))
$(eval $(call schemelib_armv7-m,saber,old_16bit,saber,saber,old_16bit,kem))
$(eval $(call schemelib_armv7-m,firesaber,old_16bit,saber,firesaber,old_16bit,kem))

$(eval $(call schemelib_armv7-m,lightsaber,opt,saber,lightsaber,opt,kem))
$(eval $(call schemelib_armv7-m,saber,opt,saber,saber,opt,kem))
$(eval $(call schemelib_armv7-m,firesaber,opt,saber,firesaber,opt,kem))

# Dilithium

$(eval $(call schemelib_armv7-m,dilithium2,ref,dilithium,dilithium2,ref,sign))
$(eval $(call schemelib_armv7-m,dilithium3,ref,dilithium,dilithium3,ref,sign))

$(eval $(call schemelib_armv7-m,dilithium2,old,dilithium,dilithium2,old,sign))
$(eval $(call schemelib_armv7-m,dilithium3,old,dilithium,dilithium3,old,sign))
$(eval $(call schemelib_armv7-m,dilithium5,old,dilithium,dilithium5,old,sign))

$(eval $(call schemelib_armv7-m,dilithium2,opt,dilithium,dilithium2,opt,sign))
$(eval $(call schemelib_armv7-m,dilithium3,opt,dilithium,dilithium3,opt,sign))
$(eval $(call schemelib_armv7-m,dilithium5,opt,dilithium,dilithium5,opt,sign))




