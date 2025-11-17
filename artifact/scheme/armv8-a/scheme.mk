
# parameter set, implementation, scheme path, parameter set path, implementation path, flags, primitive
define schemelib_armv8-a
$(1)_$(2)_PATH        = ./$(3)/$(4)/$(5)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i) $$(wildcard $$($(1)_$(2)_PATH)/*.inc)
$(1)_$(2)_SOURCES     = $$(filter-out $$($(1)_$(2)_PATH)/speed_local.c, $$(wildcard $$($(1)_$(2)_PATH)/*.c)) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S)
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH) $(6)

$(3)/obj/$(1)_$(2)_test: test_$(7)/test.c $$(COMMON_HEADERS) $$(COMMON_SOURCES) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	mkdir -p $$(@D)
	$$(CC) $$(CFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$($(1)_$(2)_SOURCES) $$< -o $$@

$(3)/obj/$(1)_$(2)_testvectors: test_$(7)/testvectors.c $$(COMMON_HEADERS) $$(COMMON_SOURCES) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	mkdir -p $$(@D)
	$$(CC) $$(CFLAGS) $$($(1)_$(2)_CFLAGS) -DNORAND $$(COMMON_SOURCES) $$($(1)_$(2)_SOURCES) $$< -o $$@

$(3)/obj/$(1)_$(2)_speed: test_$(7)/speed.c $$(COMMON_HEADERS) $$(COMMON_SOURCES) $$(CYCLES_HEADERS) $$(CYCLES_SOURCES) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	mkdir -p $$(@D)
	$$(CC) $$(CFLAGS) $$(BENCHFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(CYCLES_SOURCES) $$($(1)_$(2)_SOURCES) $$< -o $$@

ifneq (,$$(wildcard $$($(1)_$(2)_PATH)/speed_local.c))
$(3)/obj/$(1)_$(2)_speed_local: $$($(1)_$(2)_PATH)/speed_local.c $$(COMMON_HEADERS) $$(COMMON_SOURCES) $$(CYCLES_HEADERS) $$(CYCLES_SOURCES) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	mkdir -p $$(@D)
	$$(CC) $$(CFLAGS) $$(BENCHFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(CYCLES_SOURCES) $$($(1)_$(2)_SOURCES) $$< -o $$@
endif
endef

# Dilithium

$(eval $(call schemelib_armv8-a,dilithium2,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=2,sign))
$(eval $(call schemelib_armv8-a,dilithium3,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=3,sign))
$(eval $(call schemelib_armv8-a,dilithium5,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=5,sign))

$(eval $(call schemelib_armv8-a,dilithium2,old,dilithium,dilithium,old,-DDILITHIUM_MODE=2,sign))
$(eval $(call schemelib_armv8-a,dilithium3,old,dilithium,dilithium,old,-DDILITHIUM_MODE=3,sign))
$(eval $(call schemelib_armv8-a,dilithium5,old,dilithium,dilithium,old,-DDILITHIUM_MODE=5,sign))

$(eval $(call schemelib_armv8-a,dilithium2,opt,dilithium,dilithium,opt,-DDILITHIUM_MODE=2,sign))
$(eval $(call schemelib_armv8-a,dilithium3,opt,dilithium,dilithium,opt,-DDILITHIUM_MODE=3,sign))
$(eval $(call schemelib_armv8-a,dilithium5,opt,dilithium,dilithium,opt,-DDILITHIUM_MODE=5,sign))

# Kyber

$(eval $(call schemelib_armv8-a,kyber512,ref,kyber,kyber,ref,-DKYBER_K=2,kem))
$(eval $(call schemelib_armv8-a,kyber768,ref,kyber,kyber,ref,-DKYBER_K=3,kem))
$(eval $(call schemelib_armv8-a,kyber1024,ref,kyber,kyber,ref,-DKYBER_K=4,kem))

$(eval $(call schemelib_armv8-a,kyber512,old,kyber,kyber,old,-DKYBER_K=2,kem))
$(eval $(call schemelib_armv8-a,kyber768,old,kyber,kyber,old,-DKYBER_K=3,kem))
$(eval $(call schemelib_armv8-a,kyber1024,old,kyber,kyber,old,-DKYBER_K=4,kem))

$(eval $(call schemelib_armv8-a,kyber512,opt,kyber,kyber,opt,-DKYBER_K=2,kem))
$(eval $(call schemelib_armv8-a,kyber768,opt,kyber,kyber,opt,-DKYBER_K=3,kem))
$(eval $(call schemelib_armv8-a,kyber1024,opt,kyber,kyber,opt,-DKYBER_K=4,kem))

# Saber

$(eval $(call schemelib_armv8-a,lightsaber,ref,saber,saber,ref,-DSABER_L=2,kem))
$(eval $(call schemelib_armv8-a,saber,ref,saber,saber,ref,-DSABER_L=3,kem))
$(eval $(call schemelib_armv8-a,firesaber,ref,saber,saber,ref,-DSABER_L=4,kem))

$(eval $(call schemelib_armv8-a,lightsaber,old_tc,saber,saber,old_tc,-DSABER_L=2,kem))
$(eval $(call schemelib_armv8-a,saber,old_tc,saber,saber,old_tc,-DSABER_L=3,kem))
$(eval $(call schemelib_armv8-a,firesaber,old_tc,saber,saber,old_tc,-DSABER_L=4,kem))

$(eval $(call schemelib_armv8-a,lightsaber,old,saber,saber,old,-DSABER_L=2,kem))
$(eval $(call schemelib_armv8-a,saber,old,saber,saber,old,-DSABER_L=3,kem))
$(eval $(call schemelib_armv8-a,firesaber,old,saber,saber,old,-DSABER_L=4,kem))

# NTRU

$(eval $(call schemelib_armv8-a,ntruhps2048677,ref,ntru,ntruhps2048677,ref,,kem))
$(eval $(call schemelib_armv8-a,ntruhrss701,ref,ntru,ntruhrss701,ref,,kem))

$(eval $(call schemelib_armv8-a,ntruhps2048677,old,ntru,ntruhps2048677,old,,kem))
$(eval $(call schemelib_armv8-a,ntruhrss701,old,ntru,ntruhrss701,old,,kem))

$(eval $(call schemelib_armv8-a,ntruhps2048677,opt_tc,ntru,ntruhps2048677,opt_tc,,kem))

$(eval $(call schemelib_armv8-a,ntruhps2048677,opt_tmvp,ntru,ntruhps2048677,opt_tmvp,,kem))
$(eval $(call schemelib_armv8-a,ntruhrss701,opt_tmvp,ntru,ntruhrss701,opt_tmvp,,kem))

$(eval $(call schemelib_armv8-a,ntruhps2048677,opt,ntru,ntruhps2048677,opt,,kem))
$(eval $(call schemelib_armv8-a,ntruhrss701,opt,ntru,ntruhrss701,opt,,kem))

# NTRU Prime

$(eval $(call schemelib_armv8-a,sntrup761,ref,ntrup,sntrup761,ref,,kem))
$(eval $(call schemelib_armv8-a,sntrup761,opt_gt,ntrup,sntrup761,opt_gt,,kem))
$(eval $(call schemelib_armv8-a,sntrup761,opt_schoenhage,ntrup,sntrup761,opt_schoenhage,,kem))
$(eval $(call schemelib_armv8-a,sntrup761,opt_rader,ntrup,sntrup761,opt_rader,,kem))
$(eval $(call schemelib_armv8-a,sntrup761,opt_truncated_rader,ntrup,sntrup761,opt_truncated_rader,,kem))
$(eval $(call schemelib_armv8-a,sntrup761,opt,ntrup,sntrup761,opt,,kem))




