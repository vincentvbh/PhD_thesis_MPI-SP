
# Dilithium 2

```
============ Assembly benchmark ============

__asm_NTT cycles: 21844
__asm_point_montmul cycles: 8535
__asm_extend cycles: 10334
__asm_point_mul_pre cycles: 6741
__asm_iNTT cycles: 19726
__asm_iNTT_negacyclic (unused) cycles: 23906
__asm_NTT_fast cycles: 13673
__asm_point_montmul_fast cycles: 5461
__asm_point_mul_pre_fast cycles: 4948
__asm_iNTT_fast cycles: 13922

============ Dilithium operation benchmark ============


======== NTT/iNTT ========

Constant-time Dilithium NTT cycles: 21840
Constant-time Dilithium iNTT cycles: 26419
Variable-time Dilithium NTT cycles: 15720
Variable-time Dilithium iNTT cycles: 18827

======== Matrix Vector Multiplication ========

Dilitihum 2 matrix-vector mul cycles: 268655
Dilitihum 2 matrix-vector mul fast cycles: 193245
```

# Dilithium 3

```
============ Assembly benchmark ============

__asm_NTT cycles: 20479
__asm_point_montmul cycles: 8017
__asm_extend cycles: 9816
__asm_point_mul_pre cycles: 6479
__asm_iNTT cycles: 18199
__asm_iNTT_negacyclic (unused) cycles: 21852
__asm_NTT_fast cycles: 13155
__asm_point_montmul_fast cycles: 5071
__asm_point_mul_pre_fast cycles: 4686
__asm_iNTT_fast cycles: 13406

============ Dilithium operation benchmark ============


======== NTT/iNTT ========

Constant-time Dilithium NTT cycles: 20475
Constant-time Dilithium iNTT cycles: 24634
Variable-time Dilithium NTT cycles: 15203
Variable-time Dilithium iNTT cycles: 18049

======== Matrix Vector Multiplication ========

Dilitihum 3 matrix-vector mul cycles: 381215
Dilitihum 3 matrix-vector mul fast cycles: 274311
```

# Dilithium 5

```
============ Assembly benchmark ============

__asm_NTT cycles: 20479
__asm_point_montmul cycles: 8017
__asm_extend cycles: 9816
__asm_point_mul_pre cycles: 6479
__asm_iNTT cycles: 18199
__asm_iNTT_negacyclic (unused) cycles: 21852
__asm_NTT_fast cycles: 13155
__asm_point_montmul_fast cycles: 5071
__asm_point_mul_pre_fast cycles: 4687
__asm_iNTT_fast cycles: 13404

============ Dilithium operation benchmark ============


======== NTT/iNTT ========

Constant-time Dilithium NTT cycles: 20475
Constant-time Dilithium iNTT cycles: 24634
Variable-time Dilithium NTT cycles: 15204
Variable-time Dilithium iNTT cycles: 18049

======== Matrix Vector Multiplication ========

Dilitihum 5 matrix-vector mul cycles: 515453
Dilitihum 5 matrix-vector mul fast cycles: 375965
```

# Nussbaumer + TMVP-TC

```
============ Nussbaumer + TMVP-TC benchmark ============


============ Assembly benchmark ============

__asm_TMVP_mul_4x4_full cycles: 10319
__asm_TMVP_mla_4x4_full cycles: 13005
__asm_TC4_16_full cycles: 3403
__asm_TC4_T_16_full cycles: 4170
__asm_iTC4_T_7x7_full cycles: 11125
__asm_Nussbaumer_neg256_0_1_2_3_4 cycles: 4483
__asm_iNussbaumer_neg256_0_1_2_3 cycles: 4494
__asm_iNussbaumer_neg256_4_last cycles: 2221

============ Polynomial Multiplication ============

Hom_M cycles: 15716
Hom_V cycles: 7993
BiHom cycles: 10317
Hom_I cycles: 10767

============ Dilithium 2 ============

Dilithium 2 c t0 cycles: 87217

============ Saber Matrix Vector Multiplication ============

lightsaber matrix-vector product: 130529
saber matrix-vector product: 259620
firesaber matrix-vector product: 428897

============ Saber Inner Product (Encrypt) ============

lightsaber inner product (Enc): 50023
saber inner product (Enc): 71079
firesaber inner product (Enc): 92133

============ Saber Inner Product (Decrypt) ============

lightsaber inner product (Dec): 81062
saber inner product (Dec): 117622
firesaber inner product (Dec): 154189
```
