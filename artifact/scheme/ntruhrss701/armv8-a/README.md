
# Apple M1 Pro

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^701 - 1)) average cycles:
6907
(TC5^{-1})^* average cycles:
630
TC5 average cycles:
194
TMVP 144 average cycles:
649
TC5^* average cycles:
186
```

### Opt

```
```

## `speed_arith`

### Ref

```
poly_Rq_inv average cycles:
1072379
poly_R2_inv average cycles:
737392
poly_S3_inv average cycles:
1456203
poly_Rq_mul average cycles:
41828
poly_S3_mul average cycles:
46433
```

### Old

```
poly_Rq_inv average cycles:
98021
poly_R2_inv average cycles:
42370
poly_S3_inv average cycles:
186100
poly_Rq_mul average cycles:
6971
poly_S3_mul average cycles:
7254
```

### Opt

```
poly_Rq_inv average cycles:
97785
poly_R2_inv average cycles:
42370
poly_S3_inv average cycles:
109809
poly_Rq_mul average cycles:
6971
poly_S3_mul average cycles:
7261
```

## `speed`

### Ref

```
crypto_kem_keypair average cycles:
2756716
crypto_kem_enc average cycles:
68053
crypto_kem_dec average cycles:
176865
owcpa_keypair average cycles:
2783322
owcpa_enc average cycles:
57252
owcpa_dec average cycles:
155591
```

### Old

```
crypto_kem_keypair average cycles:
327528
crypto_kem_enc average cycles:
16577
crypto_kem_dec average cycles:
37359
owcpa_keypair average cycles:
323950
owcpa_enc average cycles:
10403
owcpa_dec average cycles:
28179
```

### Opt

```
crypto_kem_keypair average cycles:
251247
crypto_kem_enc average cycles:
16581
crypto_kem_dec average cycles:
37287
owcpa_keypair average cycles:
247687
owcpa_enc average cycles:
10403
owcpa_dec average cycles:
28128
```

# Cortex-A72

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^701 - 1)) median cycles:
31109
(TC5^{-1})^* median cycles:
2467
TC5 median cycles:
618
TMVP 144 median cycles:
3000
TC5^* median cycles:
853
```

### Opt

```
```

## `speed_arith`

### Old

```
poly_Rq_inv median cycles:
391010
poly_R2_inv median cycles:
140285
poly_S3_inv median cycles:
503593
poly_Rq_mul median cycles:
31366
poly_S3_mul median cycles:
33370
```

### Opt

```
poly_Rq_inv median cycles:
391109
poly_R2_inv median cycles:
140295
poly_S3_inv median cycles:
331704
poly_Rq_mul median cycles:
31183
poly_S3_mul median cycles:
33342
```

## `speed`

### Old

```
crypto_kem_keypair median cycles:
1075080
crypto_kem_enc median cycles:
59140
crypto_kem_dec median cycles:
142280
owcpa_keypair median cycles:
1070415
owcpa_enc median cycles:
42378
owcpa_dec median cycles:
121217
```

### Opt

```
crypto_kem_keypair median cycles:
907779
crypto_kem_enc median cycles:
59643
crypto_kem_dec median cycles:
142397
owcpa_keypair median cycles:
903959
owcpa_enc median cycles:
42329
owcpa_dec median cycles:
120996
```


