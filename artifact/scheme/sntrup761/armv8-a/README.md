

# Apple M1 Pro

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^1632 - 1)) average cycles:
8148
```

### Opt

```
polymul (Z_q[x] / (x^761 - x - 1)) average cycles:
6942
```

## `speed_arith`

### Old

```
R3_recip average cycles:
197395
Rq_mult_small average cycles:
8811
R3_mult average cycles:
9165
```

### Opt

```
R3_recip average cycles:
130810
Rq_mult_small average cycles:
7006
R3_mult average cycles:
7261
```

## `speed_Rqinv`

### Old

```
Rq_recip3 average cycles:
1528747
```

### Opt

```
Rq_recip3 average cycles:
1474240
```

## `speed`

### Old

```
crypto_kem_keypair average cycles:
1839276
crypto_kem_enc average cycles:
64640
crypto_kem_dec average cycles:
43952
ZKeyGen average cycles:
1821130
ZEncrypt average cycles:
10789
ZDecrypt average cycles:
19793
KeyGen average cycles:
1790562
Encrypt average cycles:
9266
Decrypt average cycles:
18687
```

### Opt

```
crypto_kem_keypair average cycles:
1762355
crypto_kem_enc average cycles:
62612
crypto_kem_dec average cycles:
38085
ZKeyGen average cycles:
1737999
ZEncrypt average cycles:
8825
ZDecrypt average cycles:
16180
KeyGen average cycles:
1668268
Encrypt average cycles:
7267
Decrypt average cycles:
14863
```

# Cortex-A72

## `speed_polymul`

### Old

```
polymul (Z_q[x] / (x^1632 - 1)) median cycles:
36557
```

### Opt

```
polymul (Z_q[x] / (x^761 - x - 1)) median cycles:
32597
```

## `speed_arith`

### Old

```
R3_recip median cycles:
587421
Rq_mult_small median cycles:
39710
R3_mult median cycles:
41437
```

### Opt

```
R3_recip median cycles:
379165
Rq_mult_small median cycles:
32505
R3_mult median cycles:
33426
```

## `speed_Rqinv`

### Old

```
Rq_recip3 median cycles:
5897373
```

### Opt

```
```

## `speed`

### Old

```
crypto_kem_keypair median cycles:
6609515
crypto_kem_enc median cycles:
149303
crypto_kem_dec median cycles:
158882
ZKeyGen median cycles:
6530961
ZEncrypt median cycles:
48554
ZDecrypt median cycles:
87773
KeyGen median cycles:
6535959
Encrypt median cycles:
40891
Decrypt median cycles:
83984
```

### Opt

```
crypto_kem_keypair median cycles:
6343731
crypto_kem_enc median cycles:
140194
crypto_kem_dec median cycles:
134140
ZKeyGen median cycles:
6273996
ZEncrypt median cycles:
41993
ZDecrypt median cycles:
74741
KeyGen median cycles:
6323166
Encrypt median cycles:
33575
Decrypt median cycles:
70645
```

