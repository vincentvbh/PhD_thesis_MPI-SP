
# Apple M1 Pro

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^677 - 1)) average cycles:
5488
(TC5^{-1})^* average cycles:
619
TC5 average cycles:
256
(TC3^{-1})^* (x9) average cycles:
67
(TC32^{-1})^* (x9) average cycles:
138
TC33 (x9) average cycles:
50
TMVP2_8x8 (x9) average cycles:
220
TC33^* (x9) average cycles:
49
TC5^* average cycles:
192
```

### Opt

```
```

## `speed_arith`

### Ref

```
poly_Rq_inv average cycles:
1054788
poly_R2_inv average cycles:
670474
poly_S3_inv average cycles:
1363810
poly_Rq_mul average cycles:
44684
poly_S3_mul average cycles:
44823
```

### Old

```
poly_Rq_inv average cycles:
84871
poly_R2_inv average cycles:
40958
poly_S3_inv average cycles:
179778
poly_Rq_mul average cycles:
5496
poly_S3_mul average cycles:
5753
```

### Opt

```
poly_Rq_inv average cycles:
84905
poly_R2_inv average cycles:
40972
poly_S3_inv average cycles:
106064
poly_Rq_mul average cycles:
5495
poly_S3_mul average cycles:
5753
```

## `speed`

### Ref

```
crypto_kem_keypair average cycles:
2661926
crypto_kem_enc average cycles:
100424
crypto_kem_dec average cycles:
149605
owcpa_keypair average cycles:
2627837
owcpa_enc average cycles:
44563
owcpa_dec average cycles:
153547
```

### Old

```
crypto_kem_keypair average cycles:
307296
crypto_kem_enc average cycles:
23913
crypto_kem_dec average cycles:
33829
owcpa_keypair average cycles:
309077
owcpa_enc average cycles:
7847
owcpa_dec average cycles:
22328
```

### Opt

```
crypto_kem_keypair average cycles:
233807
crypto_kem_enc average cycles:
23919
crypto_kem_dec average cycles:
33837
owcpa_keypair average cycles:
235423
owcpa_enc average cycles:
7847
owcpa_dec average cycles:
22343
```

# Cortex-A72

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^677 - 1)) median cycles:
26485
(TC5^{-1})^* median cycles:
2407
TC5 median cycles:
615
(TC3^{-1})^* (x9) median cycles:
201
(TC32^{-1})^* (x9) median cycles:
565
TC33 (x9) median cycles:
145
TMVP2_8x8 (x9) median cycles:
1389
TC33^* (x9) median cycles:
205
TC5^* median cycles:
848
```

### Opt

```
```

## `speed_arith`

### Old

```
poly_Rq_inv median cycles:
347208
poly_R2_inv median cycles:
135444
poly_S3_inv median cycles:
496911
poly_Rq_mul median cycles:
26493
poly_S3_mul median cycles:
28517
```

### Opt

```
poly_Rq_inv median cycles:
347721
poly_R2_inv median cycles:
135449
poly_S3_inv median cycles:
315051
poly_Rq_mul median cycles:
26651
poly_S3_mul median cycles:
28491
```

## `speed`

### Old

```
crypto_kem_keypair median cycles:
1016712
crypto_kem_enc median cycles:
81572
crypto_kem_dec median cycles:
121628
owcpa_keypair median cycles:
1002281
owcpa_enc median cycles:
33298
owcpa_dec median cycles:
102706
```

### Opt

```
crypto_kem_keypair median cycles:
858278
crypto_kem_enc median cycles:
82700
crypto_kem_dec median cycles:
123877
owcpa_keypair median cycles:
839539
owcpa_enc median cycles:
32225
owcpa_dec median cycles:
102495
```
