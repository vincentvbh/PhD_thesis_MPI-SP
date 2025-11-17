
#include <immintrin.h>

#include "cbd.h"
#include "fips202.h"
#include "pack_unpack.h"
#include "poly.h"
#include "NTT.h"

#define h1 (1 << (SABER_EQ - SABER_EP - 1))
#define h2 ((1 << (SABER_EP - 2)) - (1 << (SABER_EP - SABER_ET - 1)) + (1 << (SABER_EQ - SABER_EP - 1)))
#define MAX(a,b) (((a)>(b))?(a):(b))

void poly_reduce(uint16_t c[SABER_N], const uint16_t a[SABER_N]){

    const __m256i mod = _mm256_set1_epi16(KEM_Q-1);
    const __m256i q = _mm256_set1_epi16(KEM_Q);
    const __m256i hq = _mm256_set1_epi16(KEM_Q/2-1);
    __m256i f, t;

    for(size_t i = 0; i < POLY_N / 16;i++) {
        f = _mm256_load_si256((__m256i *)&a[16 * i]);
        f = _mm256_and_si256(f,mod);
        t = _mm256_cmpgt_epi16(f,hq);
        t = _mm256_and_si256(t,q);
        f = _mm256_sub_epi16(f,t);
        _mm256_store_si256((__m256i *)&c[16 * i],f);
    }

}

// static
// void polymul(uint16_t r[SABER_N], const uint16_t a[SABER_N], const uint16_t b[SABER_N]){
//     poly a2, b2;
//     nttpoly ahat, bhat, chat;

//     poly_reduce(a2.coeffs, a);
//     poly_reduce(b2.coeffs, b);

//     poly_ntt(&ahat,&a2,PDATA0);
//     poly_ntt(&bhat,&b2,PDATA0);
//     poly_basemul_montgomery(&ahat,&ahat,&bhat,PDATA0);
//     poly_invntt_tomont(&ahat,&ahat,PDATA0);
//     poly_ntt(&bhat,&a2,PDATA1);
//     poly_ntt(&chat,&b2,PDATA1);
//     poly_basemul_montgomery(&bhat,&bhat,&chat,PDATA1);
//     poly_invntt_tomont(&bhat,&bhat,PDATA1);
//     poly_crt((poly*)r,&ahat,&bhat);
// }

// static
// void polymla(uint16_t c[SABER_N], const uint16_t a[SABER_N], const uint16_t b[SABER_N]){

//     uint16_t buff[SABER_N];

//     polymul(buff, a, b);

//     for(size_t i = 0; i < SABER_N; i++){
//         c[i] += buff[i];
//     }

// }

static inline keccak_state shake128_absorb_seed(const uint8_t seed[SABER_SEEDBYTES]){

    keccak_state ctx;
    shake128_init(&ctx);
    shake128_absorb(&ctx, seed, SABER_SEEDBYTES);
    shake128_finalize(&ctx);

    return ctx;

}

void MatrixVectorMulKeyPairNTT_A( uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint16_t buff[SABER_N];
    uint16_t acc[SABER_L * SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    nttpolyvec AT_hat0[SABER_L], AT_hat1[SABER_L];
    nttpolyvec s_hat0, s_hat1;
    nttpoly acc_hat0, acc_hat1;

    uint8_t *seed_A = pk + SABER_POLYVECCOMPRESSEDBYTES;
    uint8_t *seed_s = sk;

    keccak_state shake_s_ctx = shake128_absorb_seed(seed_s);
    keccak_state shake_A_ctx = shake128_absorb_seed(seed_A);

    for(size_t i = 0; i < SABER_L; i++){
        shake128_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(buff, shake_out);
#ifdef SABER_COMPRESS_SECRETKEY
        POLmu2BS(sk + i * SABER_POLYSECRETBYTES, buff); // sk <- s
#else
        POLq2BS(sk + i * SABER_POLYSECRETBYTES, buff);
#endif
        poly_reduce(buff, buff);
        poly_ntt(&s_hat0.vec[i], (poly*)buff, PDATA0);
        poly_ntt(&s_hat1.vec[i], (poly*)buff, PDATA1);
    }

    for(size_t i = 0; i < SABER_L; i++){
        for(size_t j = 0; j < SABER_L; j++){
            shake128_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, buff);
            poly_reduce(buff, buff);
            poly_ntt(&AT_hat0[j].vec[i], (poly*)buff, PDATA0);
            poly_ntt(&AT_hat1[j].vec[i], (poly*)buff, PDATA1);
        }
    }

    for(size_t i = 0; i < SABER_L; i++){
        polyvec_basemul_acc_montgomery(&acc_hat0, &AT_hat0[i], &s_hat0, PDATA0);
        polyvec_basemul_acc_montgomery(&acc_hat1, &AT_hat1[i], &s_hat1, PDATA1);

        poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0);
        poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1);
        poly_crt((poly*)&acc[i * SABER_N], (poly*)&acc_hat0, (poly*)&acc_hat1);

    }

    for (size_t i = 0; i < SABER_L; i++) {

        for (size_t j = 0; j < SABER_N; j++) {
            buff[j] = ((acc[i * SABER_N + j] + h1) >> (SABER_EQ - SABER_EP));
        }

        POLp2BS(pk + i * SABER_POLYCOMPRESSEDBYTES, buff);
    }

}

uint32_t MatrixVectorMulEncNTT_A(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare){

    uint16_t A_poly[SABER_N];
    uint16_t s_poly[SABER_N];
    uint16_t acc[SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    nttpolyvec A_hat0, A_hat1;
    nttpolyvec s_hat0, s_hat1;
    nttpoly acc_hat0, acc_hat1;

    uint16_t *mp = A_poly;

    uint32_t fail = 0;

    keccak_state shake_s_ctx = shake128_absorb_seed(seed_s);

    for(size_t i = 0; i < SABER_L; i++){
        shake128_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(s_poly, shake_out);
        poly_reduce(s_poly, s_poly);
        poly_ntt(&s_hat0.vec[i], (poly*)s_poly, PDATA0);
        poly_ntt(&s_hat1.vec[i], (poly*)s_poly, PDATA1);
    }

    keccak_state shake_A_ctx = shake128_absorb_seed(seed_A);

    for (size_t i = 0; i < SABER_L; i++) {

        for (size_t j = 0; j < SABER_L; j++) {

            shake128_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, A_poly);

            poly_reduce(A_poly, A_poly);
            poly_ntt(&A_hat0.vec[j], (poly*)A_poly, PDATA0);
            poly_ntt(&A_hat1.vec[j], (poly*)A_poly, PDATA1);

        }

        polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0);
        polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1);

        poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0);
        poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1);
        poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1);

        for (size_t j = 0; j < SABER_N; j++) {
            acc[j] = ((acc[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        if (compare) {
            fail |= POLp2BS_cmp(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        } else {
            POLp2BS(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        }
    }

    for(size_t j = 0; j < SABER_L; j++){

        BS2POLp(pk + j * SABER_POLYCOMPRESSEDBYTES, A_poly);
        poly_reduce(A_poly, A_poly);
        poly_ntt(&A_hat0.vec[j], (poly*)A_poly, PDATA0);
        poly_ntt(&A_hat1.vec[j], (poly*)A_poly, PDATA1);

    }

    polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0);
    polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1);

    poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0);
    poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1);
    poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1);

    BS2POLmsg(m, mp);

    for(size_t j = 0; j < SABER_N; j++){
        acc[j] = (acc[j] - (mp[j] << (SABER_EP - 1)) + h1) >> (SABER_EP - SABER_ET);
    }

    if(compare){
        fail |= POLT2BS_cmp(ct1, acc);
    }else{
        POLT2BS(ct1, acc);
    }

    return fail;

}



void InnerProdDecNTT(uint8_t m[SABER_KEYBYTES], const uint8_t ciphertext[SABER_BYTES_CCA_DEC], const uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint16_t A_poly[SABER_N];
    uint16_t buff[SABER_N];
    uint16_t acc[SABER_N];

    nttpolyvec A_hat0, A_hat1;
    nttpolyvec s_hat0, s_hat1;
    nttpoly acc_hat0, acc_hat1;

    for (size_t i = 0; i < SABER_L; i++) {

#ifdef SABER_COMPRESS_SECRETKEY
        BS2POLmu(sk + i * SABER_POLYSECRETBYTES, buff);
#else
        BS2POLq(sk + i * SABER_POLYSECRETBYTES, buff);
#endif
        BS2POLp(ciphertext + i * SABER_POLYCOMPRESSEDBYTES, A_poly);

        poly_reduce(A_poly, A_poly);
        poly_reduce(buff, buff);

        poly_ntt(&A_hat0.vec[i], (poly*)A_poly, PDATA0);
        poly_ntt(&A_hat1.vec[i], (poly*)A_poly, PDATA1);
        poly_ntt(&s_hat0.vec[i], (poly*)buff, PDATA0);
        poly_ntt(&s_hat1.vec[i], (poly*)buff, PDATA1);

    }
    polyvec_basemul_acc_montgomery(&acc_hat0, &A_hat0, &s_hat0, PDATA0);
    polyvec_basemul_acc_montgomery(&acc_hat1, &A_hat1, &s_hat1, PDATA1);

    poly_invntt_tomont((poly*)&acc_hat0, &acc_hat0, PDATA0);
    poly_invntt_tomont((poly*)&acc_hat1, &acc_hat1, PDATA1);
    poly_crt((poly*)acc, (poly*)&acc_hat0, (poly*)&acc_hat1);

    BS2POLT(ciphertext + SABER_POLYVECCOMPRESSEDBYTES, buff);

    for (size_t i = 0; i < SABER_N; i++) {
        A_poly[i] = (acc[i] + h2 - (buff[i] << (SABER_EP - SABER_ET))) >> (SABER_EP - 1);
    }

    POLmsg2BS(m, A_poly);

}




