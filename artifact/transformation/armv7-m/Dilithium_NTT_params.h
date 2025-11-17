#ifndef DILITHIUM_NTT_PARAMS_H
#define DILITHIUM_NTT_PARAMS_H

#include "Dilithium_params.h"

#ifndef N
#define N 256
#endif
#define LOGNTT_N 8

// #define Q (8380417)
// R mod^+- Q
#define RmodQ (-4186625)
// -Q^{-1} mod^+- R
#define Qprime (-58728449)
// (R^2 mod^+- Q) * Qprime mod^+- R
#define RmodQhi (-2145647103)

#define omegaQ (1753)
#define omegainvQ (731434)

#define INV256 (-32736)

#endif

