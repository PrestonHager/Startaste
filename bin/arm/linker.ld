ENTRY(_start)

SECTIONS {
  /* QEMU loads kernel from here. */
  . = 0x80010000;

  /* Entry stub goes first, then the stack/programs */
  .stub   : { _start.o(.text) }
  .text   : { *(.text) }
  .rodata : { *(.rodata) }
  .data   : { *(.data) }
  .bss    : { *(.bss COMMON) }

  STACK_BASE = .;
  . += 0x10000;
  STACK_TOP = .;
}
