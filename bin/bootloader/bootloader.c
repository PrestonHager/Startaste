// bootloader.c
// by Preston Hager

#include "memory_map.h"

/* start_kernel
 - uses assembly to set the stack pointer and branch (jump) to the start of the kernel. */
static void start_kernel(unsigned int pc, unsigned int sp) {
  __asm__ ("mov r13, r1\n\
            bx r0\n" // base assembly.
  );
}

void main() {
  unsigned int *kernel_code = (unsigned int *)__kernel_start__;
  unsigned int kernel_sp = kernel_code[0];
  unsigned int kernel_start = kernel_code[1];

  start_kernel(kernel_start, kernel_sp);

  // shouldn't be reached
  while (1);
}
