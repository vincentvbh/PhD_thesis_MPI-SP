
This folder contains source code generating the constants used in the assembly-optimized implementations.

- `gen_table.[ch]`: Generate tables of constants used in the assembly-optimized implementations.
- `naive_mult.[ch]`: Naive polynomial multiplications for testing purpose.
- `ntt_c.[ch]`: Apply the target computations with the tables generated. The target computations are then to be turned into assembly-optimized implementations with the same tables.
- `tools.[ch]`: Basic constructs defining an integer ring with data type `int16_t` and `int32_t`. Bit-reversal permutation is here as well.
