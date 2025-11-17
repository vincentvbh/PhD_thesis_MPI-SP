
# parameter set, implementation, scheme path, parameter set path, implementation path, flags, primitive
define schemelib_avx2
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

# Kyber

$(eval $(call schemelib_avx2,kyber512,ref,kyber,kyber,ref,-DKYBER_K=2,kem))
$(eval $(call schemelib_avx2,kyber768,ref,kyber,kyber,ref,-DKYBER_K=3,kem))
$(eval $(call schemelib_avx2,kyber1024,ref,kyber,kyber,ref,-DKYBER_K=4,kem))

$(eval $(call schemelib_avx2,kyber512,old,kyber,kyber,old,-DKYBER_K=2,kem))
$(eval $(call schemelib_avx2,kyber768,old,kyber,kyber,old,-DKYBER_K=3,kem))
$(eval $(call schemelib_avx2,kyber1024,old,kyber,kyber,old,-DKYBER_K=4,kem))

$(eval $(call schemelib_avx2,kyber512,opt,kyber,kyber,opt,-DKYBER_K=2,kem))
$(eval $(call schemelib_avx2,kyber768,opt,kyber,kyber,opt,-DKYBER_K=3,kem))
$(eval $(call schemelib_avx2,kyber1024,opt,kyber,kyber,opt,-DKYBER_K=4,kem))

# Dilithium

$(eval $(call schemelib_avx2,dilithium2,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=2,sign))
$(eval $(call schemelib_avx2,dilithium3,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=3,sign))
$(eval $(call schemelib_avx2,dilithium5,ref,dilithium,dilithium,ref,-DDILITHIUM_MODE=5,sign))

$(eval $(call schemelib_avx2,dilithium2,old,dilithium,dilithium,old,-DDILITHIUM_MODE=2,sign))
$(eval $(call schemelib_avx2,dilithium3,old,dilithium,dilithium,old,-DDILITHIUM_MODE=3,sign))
$(eval $(call schemelib_avx2,dilithium5,old,dilithium,dilithium,old,-DDILITHIUM_MODE=5,sign))

# Saber

$(eval $(call schemelib_avx2,lightsaber,ref,saber,saber,ref,-DSABER_L=2,kem))
$(eval $(call schemelib_avx2,saber,ref,saber,saber,ref,-DSABER_L=3,kem))
$(eval $(call schemelib_avx2,firesaber,ref,saber,saber,ref,-DSABER_L=4,kem))

$(eval $(call schemelib_avx2,lightsaber,old_tc,saber,saber,old_tc,-DSABER_L=2,kem))
$(eval $(call schemelib_avx2,saber,old_tc,saber,saber,old_tc,-DSABER_L=3,kem))
$(eval $(call schemelib_avx2,firesaber,old_tc,saber,saber,old_tc,-DSABER_L=4,kem))

$(eval $(call schemelib_avx2,lightsaber,old_ntt,saber,saber,old_ntt,-DSABER_L=2,kem))
$(eval $(call schemelib_avx2,saber,old_ntt,saber,saber,old_ntt,-DSABER_L=3,kem))
$(eval $(call schemelib_avx2,firesaber,old_ntt,saber,saber,old_ntt,-DSABER_L=4,kem))

# NTRU

$(eval $(call schemelib_avx2,ntruhps2048677,ref,ntru,ntruhps2048677,ref,,kem))
$(eval $(call schemelib_avx2,ntruhrss701,ref,ntru,ntruhrss701,ref,,kem))

$(eval $(call schemelib_avx2,ntruhps2048677,old_tc,ntru,ntruhps2048677,old_tc,,kem))
$(eval $(call schemelib_avx2,ntruhrss701,old_tc,ntru,ntruhrss701,old_tc,,kem))

# NTRU Prime

$(eval $(call schemelib_avx2,sntrup761,ref,ntrup,sntrup761,ref,,kem))

