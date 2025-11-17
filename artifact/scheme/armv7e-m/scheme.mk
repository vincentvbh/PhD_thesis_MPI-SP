
define schemelib_armv7e-m
$(1)_$(2)_PATH        = ./$(3)/$(4)/$(5)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(filter-out $$($(1)_$(2)_PATH)/speed_local.c $$($(1)_$(2)_PATH)/speed_local_hashing.c, $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S))
$(1)_$(2)_OBJS        = $$(patsubst %.c, %.o, $$($(1)_$(2)_SOURCES))
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH)

$(3)/obj/$(1)_$(2)_test.o: test_$(6)/test.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_test.elf: $(3)/obj/$(1)_$(2)_test.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7E-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

$(3)/obj/$(1)_$(2)_testvectors.o: test_$(6)/testvectors.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_testvectors.elf: $(3)/obj/$(1)_$(2)_testvectors.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7E-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

$(3)/obj/$(1)_$(2)_speed.o: test_$(6)/speed.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed.elf: $(3)/obj/$(1)_$(2)_speed.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7E-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

ifneq (,$$(wildcard $$($(1)_$(2)_PATH)/speed_local.c))
$(3)/obj/$(1)_$(2)_speed_local.o: $$($(1)_$(2)_PATH)/speed_local.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed_local.elf: $(3)/obj/$(1)_$(2)_speed_local.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endif

$(3)/obj/$(1)_$(2)_profile_hashing.o: test_$(6)/hashing.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_profile_hashing.elf: $(3)/obj/$(1)_$(2)_profile_hashing.o $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7E-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

ifneq (,$$(wildcard $$($(1)_$(2)_PATH)/speed_local_hashing.c))
$(3)/obj/$(1)_$(2)_speed_local_hashing.o: $$($(1)_$(2)_PATH)/speed_local_hashing.c opencm3_lib
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7E-M_CROSS_CFLAGS) -o $$@ -c $$<

$(3)/elf/$(1)_$(2)_speed_local_hashing.elf: $(3)/obj/$(1)_$(2)_speed_local_hashing.o $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	mkdir -p $$(@D)
	$$(ARMv7E-M_CROSS_LD) $$(PROFILE_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7E-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endif
endef

# Dilithium

$(eval $(call schemelib_armv7e-m,dilithium2,ref,dilithium,dilithium2,ref,sign))
$(eval $(call schemelib_armv7e-m,dilithium3,ref,dilithium,dilithium3,ref,sign))

$(eval $(call schemelib_armv7e-m,dilithium5,old_stack,dilithium,dilithium5,old_stack,sign))

$(eval $(call schemelib_armv7e-m,dilithium2,old_speed,dilithium,dilithium2,old_speed,sign))
$(eval $(call schemelib_armv7e-m,dilithium3,old_speed,dilithium,dilithium3,old_speed,sign))
$(eval $(call schemelib_armv7e-m,dilithium5,old_speed,dilithium,dilithium5,old_speed,sign))

# Kyber

$(eval $(call schemelib_armv7e-m,kyber512,ref,kyber,kyber512,ref,kem))
$(eval $(call schemelib_armv7e-m,kyber768,ref,kyber,kyber768,ref,kem))
$(eval $(call schemelib_armv7e-m,kyber1024,ref,kyber,kyber1024,ref,kem))

$(eval $(call schemelib_armv7e-m,kyber512,old_montgomery_barrett,kyber,kyber512,old_montgomery_barrett,kem))
$(eval $(call schemelib_armv7e-m,kyber768,old_montgomery_barrett,kyber,kyber768,old_montgomery_barrett,kem))
$(eval $(call schemelib_armv7e-m,kyber1024,old_montgomery_barrett,kyber,kyber1024,old_montgomery_barrett,kem))

$(eval $(call schemelib_armv7e-m,kyber512,old_plant,kyber,kyber512,old_plant,kem))
$(eval $(call schemelib_armv7e-m,kyber768,old_plant,kyber,kyber768,old_plant,kem))
$(eval $(call schemelib_armv7e-m,kyber1024,old_plant,kyber,kyber1024,old_plant,kem))

$(eval $(call schemelib_armv7e-m,kyber512,opt,kyber,kyber512,opt,kem))
$(eval $(call schemelib_armv7e-m,kyber768,opt,kyber,kyber768,opt,kem))
$(eval $(call schemelib_armv7e-m,kyber1024,opt,kyber,kyber1024,opt,kem))

# Saber

$(eval $(call schemelib_armv7e-m,lightsaber,ref,saber,lightsaber,ref,kem))
$(eval $(call schemelib_armv7e-m,saber,ref,saber,saber,ref,kem))
$(eval $(call schemelib_armv7e-m,firesaber,ref,saber,firesaber,ref,kem))

$(eval $(call schemelib_armv7e-m,lightsaber,old_tmvp,saber,lightsaber,old_tmvp,kem))
$(eval $(call schemelib_armv7e-m,saber,old_tmvp,saber,saber,old_tmvp,kem))
$(eval $(call schemelib_armv7e-m,firesaber,old_tmvp,saber,firesaber,old_tmvp,kem))

$(eval $(call schemelib_armv7e-m,lightsaber,old_stack,saber,lightsaber,old_stack,kem))
$(eval $(call schemelib_armv7e-m,saber,old_stack,saber,saber,old_stack,kem))
$(eval $(call schemelib_armv7e-m,firesaber,old_stack,saber,firesaber,old_stack,kem))

$(eval $(call schemelib_armv7e-m,lightsaber,old_speed,saber,lightsaber,old_speed,kem))
$(eval $(call schemelib_armv7e-m,saber,old_speed,saber,saber,old_speed,kem))
$(eval $(call schemelib_armv7e-m,firesaber,old_speed,saber,firesaber,old_speed,kem))

# NTRU

$(eval $(call schemelib_armv7e-m,ntruhps2048677,ref,ntru,ntruhps2048677,ref,kem))
$(eval $(call schemelib_armv7e-m,ntruhrss701,ref,ntru,ntruhrss701,ref,kem))

$(eval $(call schemelib_armv7e-m,ntruhps2048677,old_1536,ntru,ntruhps2048677,old_1536,kem))
$(eval $(call schemelib_armv7e-m,ntruhrss701,old_1536,ntru,ntruhrss701,old_1536,kem))

$(eval $(call schemelib_armv7e-m,ntruhps2048677,old_tmvp,ntru,ntruhps2048677,old_tmvp,kem))
$(eval $(call schemelib_armv7e-m,ntruhrss701,old_tmvp,ntru,ntruhrss701,old_tmvp,kem))

$(eval $(call schemelib_armv7e-m,ntruhps2048677,old_1440,ntru,ntruhps2048677,old_1440,kem))
$(eval $(call schemelib_armv7e-m,ntruhrss701,old_1440,ntru,ntruhrss701,old_1440,kem))

# NTRU Prime

$(eval $(call schemelib_armv7e-m,sntrup761,ref,ntrup,sntrup761,ref,kem))

$(eval $(call schemelib_armv7e-m,sntrup761,old_1536,ntrup,sntrup761,old_1536,kem))

$(eval $(call schemelib_armv7e-m,sntrup761,old_1530,ntrup,sntrup761,old_1530,kem))




