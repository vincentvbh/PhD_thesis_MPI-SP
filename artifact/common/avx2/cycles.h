#ifndef CYCLES_H
#define CYCLES_H

#define __AVERAGE__

#include <stdint.h>

void init_counter(void);

#ifdef USE_RDPMC  /* Needs echo 2 > /sys/devices/cpu/rdpmc */

static inline uint64_t get_cycle(void) {
  const uint32_t ecx = (1U << 30) + 1;
  uint64_t result;

  __asm__ volatile ("rdpmc; shlq $32,%%rdx; orq %%rdx,%%rax"
    : "=a" (result) : "c" (ecx) : "rdx");

  return result;
}

#else

static inline uint64_t get_cycle(void) {
  uint64_t result;

  __asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
    : "=a" (result) : : "%rdx");

  return result;
}

#endif

#define CYCLE_TYPE "%ld"

#ifdef __AVERAGE__

#define LOOP_INIT(__clock0, __clock1) { \
    __clock0 = get_cycle(); \
}
#define LOOP_TAIL(__f_string, records, __clock0, __clock1) { \
    __clock1 = get_cycle(); \
    printf(__f_string " average cycles:\n" CYCLE_TYPE "\n", (__clock1 - __clock0) / NTESTS); \
}
#define BODY_INIT(__clock0, __clock1) {}
#define BODY_TAIL(records, __clock0, __clock1) {}

#elif defined(__MEDIAN__)

#include <stdlib.h>

static int cmp_uint64(const void *a, const void *b){
    return ((*((const uint64_t*)a)) - ((*((const uint64_t*)b))));
}

#define LOOP_INIT(__clock0, __clock1) {}
#define LOOP_TAIL(__f_string, records, __clock0, __clock1) { \
    qsort(records, NTESTS, sizeof(uint64_t), cmp_uint64); \
    printf(__f_string " median cycles:\n" CYCLE_TYPE "\n", records[NTESTS >> 1]); \
}
#define BODY_INIT(__clock0, __clock1) { \
    __clock0 = get_cycle(); \
}
#define BODY_TAIL(records, __clock0, __clock1) { \
    __clock1 = get_cycle(); \
    records[i] = __clock1 - __clock0; \
}

#endif

#define WRAP_FUNC(__f_string, records, __clock0, __clock1, func){ \
    LOOP_INIT(__clock0, __clock1); \
    for(size_t i = 0; i < NTESTS; i++){ \
        BODY_INIT(__clock0, __clock1); \
        func; \
        BODY_TAIL(records, __clock0, __clock1); \
    } \
    LOOP_TAIL(__f_string, records, __clock0, __clock1); \
}




#endif

