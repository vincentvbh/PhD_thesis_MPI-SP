
# Compilation

```
make all
```

# Correctness

Type
```
./intdiv
./mulmod
```

# Firestore (Apple M1 Pro)

Type
```
sudo ./intdiv_speed
```

## Clang
Apple clang version 15.0.0 (clang-1500.3.9.4)

```
poly_compress1 ref average cycles:
133
poly_compress1 average cycles:
119
poly_comrpess1 intrinsics average cycles:
54
poly_compress1 asm average cycles:
57
poly_compress4 ref average cycles:
164
poly_compress4 average cycles:
107
poly_compress4 intrinsics average cycles:
47
poly_compress4 asm average cycles:
47
poly_compress5 ref average cycles:
176
poly_compress5 average cycles:
432
poly_compress5 intrinsics average cycles:
138
poly_compress5 asm average cycles:
94
poly_compress10 ref average cycles:
484
poly_compress10 average cycles:
85
poly_compress10 intrinsics average cycles:
237
poly_compress10 asm average cycles:
149
poly_compress11 ref average cycles:
448
poly_compress11 average cycles:
353
poly_compress11 intrinsics average cycles:
210
poly_compress11 asm average cycles:
146
```

## GCC
gcc (Homebrew GCC 13.3.0) 13.3.0

```
poly_compress1 ref average cycles:
122
poly_compress1 average cycles:
86
poly_comrpess1 intrinsics average cycles:
47
poly_compress1 asm average cycles:
57
poly_compress4 ref average cycles:
113
poly_compress4 average cycles:
45
poly_compress4 intrinsics average cycles:
39
poly_compress4 asm average cycles:
47
poly_compress5 ref average cycles:
464
poly_compress5 average cycles:
280
poly_compress5 intrinsics average cycles:
160
poly_compress5 asm average cycles:
94
poly_compress10 ref average cycles:
509
poly_compress10 average cycles:
188
poly_compress10 intrinsics average cycles:
210
poly_compress10 asm average cycles:
149
poly_compress11 ref average cycles:
504
poly_compress11 average cycles:
376
poly_compress11 intrinsics average cycles:
133
poly_compress11 asm average cycles:
146
```

# Cortex-A72 (Raspberry Pi 4)

Type
```
./intdiv_speed
```

## Clang

Ubuntu clang version 15.0.7

```
poly_compress1 ref median cycles:
543
poly_compress1 median cycles:
454
poly_comrpess1 intrinsics median cycles:
173
poly_compress1 asm median cycles:
179
poly_compress4 ref median cycles:
791
poly_compress4 median cycles:
435
poly_compress4 intrinsics median cycles:
179
poly_compress4 asm median cycles:
154
poly_compress5 ref median cycles:
770
poly_compress5 median cycles:
649
poly_compress5 intrinsics median cycles:
525
poly_compress5 asm median cycles:
349
poly_compress10 ref median cycles:
1194
poly_compress10 median cycles:
385
poly_compress10 intrinsics median cycles:
813
poly_compress10 asm median cycles:
498
poly_compress11 ref median cycles:
1250
poly_compress11 median cycles:
753
poly_compress11 intrinsics median cycles:
830
poly_compress11 asm median cycles:
673
```

## GCC

gcc (Ubuntu 12.3.0-1ubuntu1~23.04) 12.3.0

```
poly_compress1 ref median cycles:
408
poly_compress1 median cycles:
314
poly_comrpess1 intrinsics median cycles:
189
poly_compress1 asm median cycles:
183
poly_compress4 ref median cycles:
453
poly_compress4 median cycles:
231
poly_compress4 intrinsics median cycles:
170
poly_compress4 asm median cycles:
154
poly_compress5 ref median cycles:
899
poly_compress5 median cycles:
642
poly_compress5 intrinsics median cycles:
822
poly_compress5 asm median cycles:
351
poly_compress10 ref median cycles:
1266
poly_compress10 median cycles:
481
poly_compress10 intrinsics median cycles:
981
poly_compress10 asm median cycles:
504
poly_compress11 ref median cycles:
1132
poly_compress11 median cycles:
900
poly_compress11 intrinsics median cycles:
826
poly_compress11 asm median cycles:
680
```
