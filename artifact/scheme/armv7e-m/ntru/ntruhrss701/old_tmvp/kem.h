#ifndef KEM_H
#define KEM_H

int crypto_kem_keypair(uint8_t *pk, uint8_t *sk);
int crypto_kem_enc(uint8_t *c, uint8_t *k, const uint8_t *pk);
int crypto_kem_dec(uint8_t *k, const uint8_t *c, const uint8_t *sk);

#endif

