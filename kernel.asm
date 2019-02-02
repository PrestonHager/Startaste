; kernel for Startaste OS.
[BITS 32]
[ORG 0x7E00]

%define ROWS 25
%define COLUMNS 80
%define VID_MEM 0xb8000

SECTION .text
kernel_main:
  ; initialize the keyboard (basically what scancode set are we using)
  call keyboard_init
  ; start the graphics.
  mov ch, 0x38
  mov cl, 0x90
  mov si, navigation_msg
  call graphics_clear
  mov ch, 0x90
  mov bl, 1
  mov dl, 0
  mov si, COMMAND_MSG
  call graphics_print_string
  mov ch, 0x90
  mov cl, [KEYBOARD_TYPE]
  add cl, 48
  call graphics_put_char

.update:
  call keyboard_input
  cmp al, 0
  je .key_not_found
  mov cl, al
  call graphics_get_cursor
  call graphics_print_string
  mov al, 0
  .key_not_found:
  jmp .update

SECTION .data
WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '> ', 0
QUIT_MSG db 'HUNG STARTASTE', 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"

times 512-($-$$) db 0	; Padding for the rest of the kernel
