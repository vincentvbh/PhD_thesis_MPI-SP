
# Matrix multiplications with Armv8-A Neon

This folder contains matrix multiplications iterating in the order

- $i, j, k$
- $i, k, j$
- $j, i, k$

with Armv8-A Neon intrinsics.
The implementations are examples demonstrating the non-one-to-one correspondence between intrinsics and assembly instructions.
The programs in this folder aim for simplicity and do not fully explore the register pressure issues,
but prior experiments from author's [earlier project](https://github.com/vincentvbh/matrix_mul/blob/main/eigen_test.c) already demonstrated the performance degrade due to unexpected translation from intrinsics to assembly instructions introducing additional register spills at the assembly level that should had been avoided if the intrinsics were translated into the desired assembly instructions.

# Compile

```
make
```

# Dumping the binary

```
objdump -d test > asm.txt
```
