// bootloader.c
// by Preston Hager

#include "memory_map.h"

static void start_kernel(unsigned int pc, unsigned int sp) {
    __asm("mov r13, r2\n\
          bx r1\n");
}

int main(void) {
  unsigned int *kernel_code = (unsigned int *)__kernel_start__;
  unsigned int kernel_sp = kernel_code[0];
  unsigned int kernel_start = kernel_code[1];

  start_kernel(kernel_start, kernel_sp);

  // shouldn't be reached
  while (1);
}