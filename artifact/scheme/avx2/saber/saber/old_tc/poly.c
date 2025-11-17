#include "cbd.h"
#include "fips202.h"
#include "pack_unpack.h"
#include "polymul.h"
#include "poly.h"

#define h1 (1 << (SABER_EQ - SABER_EP - 1))
#define h2 ((1 << (SABER_EP - 2)) - (1 << (SABER_EP - SABER_ET - 1)) + (1 << (SABER_EQ - SABER_EP - 1)))
#define MAX(a,b) (((a)>(b))?(a):(b))

void polymul(uint16_t c[SABER_N], const uint16_t a[SABER_N], const uint16_t b[SABER_N]){

    toom4_points_product c_eval;
    toom4_points b_eval;

    toom4_eval(&b_eval, (poly*)b);

    toom4_mul_A_by_B_eval(&c_eval, (poly*)a, &b_eval, 0);

    toom4_interp((poly*)c, &c_eval);

}

void polymla(uint16_t c[SABER_N], const uint16_t a[SABER_N], const uint16_t b[SABER_N]){

    toom4_points_product c_eval;
    toom4_points b_eval;
    uint16_t buff[SABER_N];

    toom4_eval(&b_eval, (poly*)b);

    toom4_mul_A_by_B_eval(&c_eval, (poly*)a, &b_eval, 0);

    toom4_interp((poly*)buff, &c_eval);

    for(size_t i = 0; i < SABER_N; i++){
        c[i] += buff[i];
    }

}

static inline keccak_state shake128_absorb_seed(const uint8_t seed[SABER_SEEDBYTES]){

    keccak_state ctx;
    shake128_init(&ctx);
    shake128_absorb(&ctx, seed, SABER_SEEDBYTES);
    shake128_finalize(&ctx);

    return ctx;

}

void MatrixVectorMulKeyPairNTT_A( uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], uint8_t sk[SABER_INDCPA_SECRETKEYBYTES]){

    uint16_t s_poly[SABER_N];
    uint16_t buff[SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    toom4_points s_eval;
    toom4_points_product As_eval[SABER_L];

    uint8_t *seed_A = pk + SABER_POLYVECCOMPRESSEDBYTES;
    uint8_t *seed_s = sk;

    size_t i, j;

    keccak_state shake_s_ctx = shake128_absorb_seed(seed_s);
    keccak_state shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        shake128_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(s_poly, shake_out);
#ifdef SABER_COMPRESS_SECRETKEY
        POLmu2BS(sk + i * SABER_POLYSECRETBYTES, s_poly); // sk <- s
#else
        POLq2BS(sk + i * SABER_POLYSECRETBYTES, s_poly);
#endif

        toom4_eval(&s_eval, (poly*)s_poly);

        for (j = 0; j < SABER_L; j++) {

            shake128_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, buff);

            if (i == 0) {
                toom4_mul_A_by_B_eval(&As_eval[j], (poly*)buff, &s_eval, 0);
            } else {
                toom4_mul_A_by_B_eval(&As_eval[j], (poly*)buff, &s_eval, 1);
            }

        }
    }

    for (i = 0; i < SABER_L; i++) {

        toom4_interp((poly*)buff, &As_eval[i]);

        for (j = 0; j < SABER_N; j++) {
            buff[j] = ((buff[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        POLp2BS(pk + i * SABER_POLYCOMPRESSEDBYTES, buff);
    }

}

uint32_t MatrixVectorMulEncNTT_A(uint8_t ct0[SABER_POLYVECCOMPRESSEDBYTES], uint8_t ct1[SABER_SCALEBYTES_KEM], const uint8_t seed_s[SABER_NOISE_SEEDBYTES], const uint8_t seed_A[SABER_SEEDBYTES], const uint8_t pk[SABER_INDCPA_PUBLICKEYBYTES], const uint8_t m[SABER_KEYBYTES], int compare){

    uint16_t acc[SABER_N];
    uint16_t buff[SABER_N];

    uint8_t shake_out[MAX(SABER_POLYBYTES, SABER_POLYCOINBYTES)];

    toom4_points s_eval[SABER_L];
    toom4_points_product As_eval;

    uint16_t mp[SABER_N];

    size_t i, j;
    uint32_t fail = 0;

    keccak_state shake_s_ctx = shake128_absorb_seed(seed_s);

    for(i = 0; i < SABER_L; i++){
        shake128_squeeze(shake_out, SABER_POLYCOINBYTES, &shake_s_ctx);
        cbd(buff, shake_out);
        toom4_eval(&s_eval[i], (poly*)buff);
    }

    keccak_state shake_A_ctx = shake128_absorb_seed(seed_A);

    for (i = 0; i < SABER_L; i++) {

        for (j = 0; j < SABER_L; j++) {

            shake128_squeeze(shake_out, SABER_POLYBYTES, &shake_A_ctx);
            BS2POLq(shake_out, buff);

            if (j == 0) {
                toom4_mul_A_by_B_eval(&As_eval, (poly*)buff, &s_eval[j], 0);
            } else {
                toom4_mul_A_by_B_eval(&As_eval, (poly*)buff, &s_eval[j], 1);
            }

        }

        toom4_interp((poly*)acc, &As_eval);

        for (j = 0; j < SABER_N; j++) {
            acc[j] = ((acc[j] + h1) >> (SABER_EQ - SABER_EP));
        }

        if (compare) {
            fail |= POLp2BS_cmp(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        } else {
            POLp2BS(ct0 + i * SABER_POLYCOMPRESSEDBYTES, acc);
        }
    }

    for(j = 0; j < SABER_L; j++){

        BS2POLp(pk + j * SABER_POLYCOMPRESSEDBYTES, buff);

        if(j == 0){
            toom4_mul_A_by_B_eval(&As_eval, (poly*)buff, &s_eval[j], 0);
        }else{
            toom4_mul_A_by_B_eval(&As_eval, (poly*)buff, &s_eval[j], 1);
        }

    }

    toom4_interp((poly*)acc, &As_eval);

    BS2POLmsg(m, mp);

    for(j = 0; j < SABER_N; j++){
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

    toom4_points s_eval;
    toom4_points_product As_eval;

    size_t i;

    for (i = 0; i < SABER_L; i++) {

#ifdef SABER_COMPRESS_SECRETKEY
        BS2POLmu(sk + i * SABER_POLYSECRETBYTES, buff);
#else
        BS2POLq(sk + i * SABER_POLYSECRETBYTES, buff);
#endif
        BS2POLp(ciphertext + i * SABER_POLYCOMPRESSEDBYTES, A_poly);

        toom4_eval(&s_eval, (poly*)buff);

        if(i == 0){
            toom4_mul_A_by_B_eval(&As_eval, (poly*)A_poly, &s_eval, 0);
        }else{
            toom4_mul_A_by_B_eval(&As_eval, (poly*)A_poly, &s_eval, 1);
        }

    }

    toom4_interp((poly*)acc, &As_eval);

    BS2POLT(ciphertext + SABER_POLYVECCOMPRESSEDBYTES, buff);

    for (i = 0; i < SABER_N; i++) {
        A_poly[i] = (acc[i] + h2 - (buff[i] << (SABER_EP - SABER_ET))) >> (SABER_EP - 1);
    }

    POLmsg2BS(m, A_poly);

}




