#ifndef NANORQ_UTIL_H
#define NANORQ_UTIL_H

#include <stdint.h>
#include <string.h>

#include <octmat.h>

#include "kvec.h"

#define div_ceil(A, B) ((A) / (B) + ((A) % (B) ? 1 : 0))
#define div_floor(A, B) ((A) / (B))

#define TMPSWAP(type, a, b)                                                    \
  do {                                                                         \
    type __tmp = a;                                                            \
    a = b;                                                                     \
    b = __tmp;                                                                 \
  } while (0)

typedef struct {
  uint32_t esi;
  octmat row;
} repair_sym;

typedef struct {
  int idx;
  size_t nz;
  size_t od;
  size_t cc;
} rowstat;

typedef kvec_t(repair_sym) repair_vec;
typedef kvec_t(int) int_vec;

#endif
