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
  ; NOTE: keyboard driver is work in progress not all scancode set will work
  call keyboard_input
  cmp cl, 0
  je .key_not_found
  mov ch, 0x90
  call graphics_get_cursor
  cmp cl, 0x08
  je .backspace
  cmp cl, 0x10
  je .enter_key
  call graphics_put_char
  jmp .move_cursor
  .backspace:
    cmp dl, 0                   ; if: column != 0
    je .column_0
    dec dl                      ; then: column -= 1
    jmp .column_0_next
    .column_0:
    cmp bl, 1                   ; if the row is 1 then don't delete any further
    je .next
    dec bl                      ; else: row -= 1
    mov dx, 79                  ; column = 79 (actually column 80 bc 0-indexed)
    ; test to see if the last character of the previous row is a space, if it isn't then delete and continue
    mov eax, COLUMNS      ; math for calculating video memory below
    mul bl
    add ax, dx
    mov cx, 2
    mul cx
    add eax, VID_MEM
    mov dx, 79            ; for some reason the dx register had been reset, so we just move it back to the end of the row
    cmp [eax], byte 0x20
    jne .column_0_next
    .find_space:          ; if it is a space then, find the next non-space character, move back one space and return
    cmp dl, 0             ; if we get all the way to column 0 without finding a character then move on
    je .next
    sub eax, 2
    dec dl
    cmp [eax], byte 0x20
    je .find_space
    inc dl
    jmp .next
    .column_0_next:
    mov cx, 0x9020        ; cl=0x20, ch=0x90
    call graphics_put_char
    jmp .next
  .enter_key:
    mov dl, 0
    call string_get_row
    mov cl, 0x20
    call string_strip
    inc bl
    call graphics_print_string
    inc bl
    mov si, COMMAND_MSG
    call graphics_print_string
    mov dl, 1
    jmp .next
  .move_cursor:
  inc dl
  cmp dl, 80
  jne .next
  mov dl, 0
  inc bl
  .next:
  call graphics_move_cursor
  mov cl, 0
  .key_not_found:
  jmp .update

SECTION .data
WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '>', 0
QUIT_MSG db 'HUNG STARTASTE', 0
DEBUG_STRING db 'debug', 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"
%include "utils/string.asm"

times 1024-($-$$) db 0	; Padding for the rest of the kernel
