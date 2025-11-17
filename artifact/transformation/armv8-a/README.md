
# Small-Dimensional Polynomial Multiplication

## Firestore (Apple M1 Pro)
```
Z_65536
Karatsuba long Z65536 8x8 average cycles:
25
Karatsuba negacyclic Z65536 8x8 average cycles:
25
32 transpose Z65536 8x8 average cycles:
241
Karatsuba striding negacyclic Z65536 8x8 average cycles:
21
Toeplitz negacyclic Z65536 8 average cycles:
11
256 Toeplitz negacyclic Z65536 8 average cycles:
1068
Toeplitz-Karatsuba negacyclic Z65536 16 average cycles:
15
128 Toeplitz-Karatsuba negacyclic Z65536 16 average cycles:
1741
Z_Q
Toeplitz negacyclic 8 average cycles:
11
256 Toeplitz negacyclic 8 average cycles:
1915
Toeplitz CT cyclic 16 average cycles:
18
128 Toeplitz CT cyclic 16 average cycles:
2043
Toeplitz negacyclic 16 average cycles:
24
Toeplitz Karatsuba negacyclic 16 average cycles:
24
128 Toeplitz Karatsuba negacyclic 16 average cycles:
2909
Toeplitz Karatsuba negacyclic 16 with doubling average cycles:
24
128 Toeplitz Karatsuba negacyclic 16 with doubling average cycles:
2986
```

## Cortex-A72 (Raspberry Pi 4)

```
Z_65536
Karatsuba long Z65536 8x8 median cycles:
147
Karatsuba negacyclic Z65536 8x8 median cycles:
137
32 transpose Z65536 8x8 median cycles:
801
Karatsuba striding negacyclic Z65536 8x8 median cycles:
131
Toeplitz negacyclic Z65536 8 median cycles:
30
256 Toeplitz negacyclic Z65536 8 median cycles:
4763
Toeplitz-Karatsuba negacyclic Z65536 16 median cycles:
81
128 Toeplitz-Karatsuba negacyclic Z65536 16 median cycles:
7713
Z_Q
Toeplitz negacyclic 8 median cycles:
38
256 Toeplitz negacyclic 8 median cycles:
7078
Toeplitz CT cyclic 16 median cycles:
72
128 Toeplitz CT cyclic 16 median cycles:
7422
Toeplitz negacyclic 16 median cycles:
98
Toeplitz Karatsuba negacyclic 16 median cycles:
98
128 Toeplitz Karatsuba negacyclic 16 median cycles:
9602
Toeplitz Karatsuba negacyclic 16 with doubling median cycles:
98
128 Toeplitz Karatsuba negacyclic 16 with doubling median cycles:
9951
```

# Kyber NTT

## Firestorm (Apple M1 Pro)

```
Kyber NTT asm average cycles:
244
Kyber extend asm average cycles:
27
Kyber asymmetric multiplcation asm average cycles:
134
Kyber asymmetric multiplication with Montgomery asm average cycles:
102
Kyber iNTT asm average cycles:
228
```

## Cortex-A72 (Raspberry Pi 4)

```
Kyber NTT asm median cycles:
955
Kyber extend asm median cycles:
159
Kyber asymmetric multiplcation asm median cycles:
774
Kyber asymmetric multiplication with Montgomery asm median cycles:
492
Kyber iNTT asm median cycles:
1130
```

# Dilithium NTT

## Firestorm (Apple M1 Pro)

```
Dilithium NTT asm average cycles:
440
Dilithium point multiplication with Montgomery asm average cycles:
117
Dilithium iNTT asm average cycles:
525
```

## Cortex-A72 (Raspberry Pi 4)

```
Dilithium NTT asm median cycles:
1804
Dilithium point multiplication with Montgomery asm median cycles:
603
Dilithium iNTT asm median cycles:
2551
```

# NTRU Prime NTT

## Firestorm (Apple M1 Pro)

```
Multiplication core average cycles:
6504
Polynomial multiplication average cycles:
6711
Primitive Rader-17 average cycles:
1010
Inverse primitive Rader-17 average cycles:
1009
Toeplitz size-16 cyclic average cycles:
786
Toeplitz size-16 negacyclic average cycles:
1141
Twisting with size-3x2 Good--Thomas average cycles:
503
```

## Cortex-A72 (Raspberry Pi 4)

```
Multiplication core median cycles:
30713
Polynomial multiplication median cycles:
32760
Primitive Rader-17 median cycles:
4367
Inverse primitive Rader-17 median cycles:
4367
Toeplitz size-16 cyclic median cycles:
2587
Toeplitz size-16 negacyclic median cycles:
3670
Twisting with size-3x2 Good--Thomas median cycles:
3201
```

