
# Compile

```
make
```

# Apple M1 Pro

Run
```
sudo ./bench
```

Output:
```
loaded db: a14 (Apple A14/M1)
number of fixed counters: 2
number of configurable counters: 8
dup w to vecB average cycles:
2740
dup w to vecH average cycles:
2760
dup w to vecS average cycles:
2773
dup x to vecD average cycles:
2757
dup B to vecB average cycles:
1039
dup B to vecH average cycles:
1041
dup B to vecS average cycles:
1032
dup B to vecD average cycles:
1032
mov w to B average cycles:
2758
mov w to H average cycles:
2768
mov w to S average cycles:
2763
mov x to D average cycles:
2759
mov S to w average cycles:
2063
mov D to x average cycles:
2070
mov B to B average cycles:
1039
mov H to H average cycles:
1037
mov S to S average cycles:
1039
mov D to D average cycles:
1033
mov 16B to 16B average cycles:
520
mov 8B to 8B average cycles:
1033
xtn, xtn2 8H average cycles:
1035
xtn, xtn2 4S average cycles:
1034
xtn, xtn2 2D average cycles:
1035
sri D average cycles:
2066
sri 8B average cycles:
2064
sri 16B average cycles:
2072
sri 4H average cycles:
2069
sri 8H average cycles:
2067
sri 2S average cycles:
2071
sri 4S average cycles:
2071
sri 2D average cycles:
2068
```

# Cortex-A72

Run
```
./bench
```

Output:
```
dup w to vecB median cycles:
8209
dup w to vecH median cycles:
8209
dup w to vecS median cycles:
8209
dup x to vecD median cycles:
8209
dup B to vecB median cycles:
2740
dup B to vecH median cycles:
2740
dup B to vecS median cycles:
2740
dup B to vecD median cycles:
2740
mov w to B median cycles:
8206
mov w to H median cycles:
8206
mov w to S median cycles:
8206
mov x to D median cycles:
8206
mov S to w median cycles:
4088
mov D to x median cycles:
4088
mov B to B median cycles:
2051
mov H to H median cycles:
2051
mov S to S median cycles:
2051
mov D to D median cycles:
2051
mov 16B to 16B median cycles:
2740
mov 8B to 8B median cycles:
2051
xtn, xtn2 8H median cycles:
2051
xtn, xtn2 4S median cycles:
2051
xtn, xtn2 2D median cycles:
2051
sri D median cycles:
8195
sri 8B median cycles:
8195
sri 16B median cycles:
16387
sri 4H median cycles:
8195
sri 8H median cycles:
16387
sri 2S median cycles:
8195
sri 4S median cycles:
16387
sri 2D median cycles:
16387
```
