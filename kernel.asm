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
  mov bl, 1
  mov dl, 1
  call graphics_move_cursor

.update:
  call keyboard_update
  jmp .update

kernel_quit:
  mov ch, 0x0F
  mov cl, 0x0F
  mov si, NULL_MSG
  call graphics_clear
  mov bl, 0
  mov dl, 0
  mov si, QUIT_MSG
  call graphics_print_string
  hlt
  jmp $

SECTION .data
WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '>', 0
QUIT_MSG db 'EXIT SUCCESSFUL. YOU MAY NOW TURN OFF THE COMPTER.', 0
DEBUG_STRING db 'DEBUG', 0
NULL_MSG db 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"
%include "utils/string.asm"
%include "utils/interpreter.asm"

times 1536-($-$$)-5 db 0	; Padding for the rest of the kernel
jmp kernel_main.update
kernel_end:
