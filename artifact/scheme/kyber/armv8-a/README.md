
# Apple M1 Pro

## `kyber512`

### Old

```
crypto_kem_keypair average cycles:
17755
crypto_kem_enc average cycles:
19559
crypto_kem_dec average cycles:
26058
```

### Opt

```
crypto_kem_keypair average cycles:
17529
crypto_kem_enc average cycles:
18666
crypto_kem_dec average cycles:
24857
NTT cycles average cycles:
225
NTT_heavy average cycles:
243
point_mul average cycles:
26
asymmetric_mul (dim x base_mul) average cycles:
150
iNTT average cycles:
228
MatrixVectorMul average cycles:
1239
InnerProd (Enc) average cycles:
375
InnerProd (Dec) average cycles:
863
```

## `kyber768`

### Old

```
crypto_kem_keypair average cycles:
29181
crypto_kem_enc average cycles:
31933
crypto_kem_dec average cycles:
41397
```

### Opt

```
crypto_kem_keypair average cycles:
28849
crypto_kem_enc average cycles:
30724
crypto_kem_dec average cycles:
39960
NTT cycles average cycles:
225
NTT_heavy average cycles:
244
point_mul average cycles:
26
asymmetric_mul (dim x base_mul) average cycles:
199
iNTT average cycles:
228
MatrixVectorMul average cycles:
2006
InnerProd (Enc) average cycles:
425
InnerProd (Dec) average cycles:
1154
```

## `kyber1024`

### Old

```
crypto_kem_keypair average cycles:
42222
crypto_kem_enc average cycles:
46309
crypto_kem_dec average cycles:
60309
```

### Opt

```
crypto_kem_keypair average cycles:
41824
crypto_kem_enc average cycles:
44259
crypto_kem_dec average cycles:
57842
NTT cycles average cycles:
225
NTT_heavy average cycles:
243
point_mul average cycles:
26
asymmetric_mul (dim x base_mul) average cycles:
249
iNTT average cycles:
228
MatrixVectorMul average cycles:
2876
InnerProd (Enc) average cycles:
475
InnerProd (Dec) average cycles:
1446
```

# Cortex-A72

## `kyber512`

### Old

```
crypto_kem_keypair median cycles:
73076
crypto_kem_enc median cycles:
76498
crypto_kem_dec median cycles:
79315
```

### Opt

```
crypto_kem_keypair median cycles:
63024
crypto_kem_enc median cycles:
64607
crypto_kem_dec median cycles:
74782
NTT cycles median cycles:
964
NTT_heavy median cycles:
1112
point_mul median cycles:
159
asymmetric_mul (dim x base_mul) median cycles:
625
iNTT median cycles:
1132
MatrixVectorMul median cycles:
5710
InnerProd (Enc) median cycles:
1751
InnerProd (Dec) median cycles:
3958
```

## `kyber768`

### Old

```
crypto_kem_keypair median cycles:
111842
crypto_kem_enc median cycles:
120344
crypto_kem_dec median cycles:
126904
```

### Opt

```
crypto_kem_keypair median cycles:
100627
crypto_kem_enc median cycles:
110714
crypto_kem_dec median cycles:
124586
NTT cycles median cycles:
970
NTT_heavy median cycles:
1113
point_mul median cycles:
159
asymmetric_mul (dim x base_mul) median cycles:
838
iNTT median cycles:
1129
MatrixVectorMul median cycles:
9249
InnerProd (Enc) median cycles:
1959
InnerProd (Dec) median cycles:
5287
```

## `kyber1024`

### Old

```
crypto_kem_keypair median cycles:
172229
crypto_kem_enc median cycles:
182539
crypto_kem_dec median cycles:
194726
```

### Opt

```
crypto_kem_keypair median cycles:
161657
crypto_kem_enc median cycles:
169523
crypto_kem_dec median cycles:
188414
NTT cycles median cycles:
956
NTT_heavy median cycles:
1113
point_mul median cycles:
159
asymmetric_mul (dim x base_mul) median cycles:
1039
iNTT median cycles:
1129
MatrixVectorMul median cycles:
13754
InnerProd (Enc) median cycles:
2335
InnerProd (Dec) median cycles:
6793
```

