; kernel for Startaste OS.
[BITS 32]
[ORG 0x8000]

%define ROWS 25
%define COLUMNS 80
%define VID_MEM 0xb8000

kernel_main:
  ; start the graphics.
  mov ch, 0x90
  call graphics_clear
  mov bl, 2
  mov dl, 0
  mov cl, 'S'
  mov ch, 0x90
  mov si, WELCOME_MSG
  call graphics_print_string
  call graphics_put_char

.update:
  jmp .update

%include "utils/graphics_protected.asm"

WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '> ', 0
QUIT_MSG db 'HUNG STARTASTE', 0

times 512-($-$$-512) db 0	; Padding for the rest of the kernel