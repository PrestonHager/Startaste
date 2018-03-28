; kernel for Startaste OS.

[org 0x8C00]
BITS 16

kernel_start:
  ; setup stack.
  ; the stack segment register (ss) is right after the kernel. so the current address + 512. and because of 16bit memory addresses we divide it by 16.
  ; the stack pointer register (sp) is the bottom of the stack (or the offset) so it's at 0.
  mov ax, 0x08C0	; the ax is a 16bit memory address (adrs*16+offset). this is the bootloader's address + it's length (512 bytes)
  add ax, 512
  cli				; Disable interrupts while changing stack
  mov ss, ax  ; move stack segment to ax address.
  mov sp, 0  ; stack pointer is offset, this is size of stack (4096 bytes).
  sti				; Restore interrupts

  ; Set data segment to the begining of the kernel (to encapsul all the data).
  mov ax, 0x08C0  ; ax = bootlaoder location 16bit memory address (loc/16).
	mov ds, ax ; set ds to location.

  ; now run the graphics.
  mov ax, WELCOME_MSG		; Top bar message
  mov bx, navigation_msg	; Bottom bar message (blank/empty)
  mov cx, 0x38			; Main background color and char color
  call graphics_background	; Call draw background routine

kernel_update:
	call keyboard_input
	call graphics_get_cursor
	cmp dh, 1					; Cannot be a new command on the first line.
	je .done_not_newline
	cmp dl, 0					; If the column is == to 0 then continue otherwise not new line.
	jne .done_not_newline
	; Is a newline and a command has been sent.
	mov si, DEBUG_MSG
	call graphics_print_string
	.done_not_newline:
	jmp kernel_update		; run update loop

  WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
  DEBUG_MSG db 'debugMsg.', 0
  navigation_msg db 'Nebula > Formation', 0
  BLANK_MSG db '', 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"

times 1024-($-$$) db 0	; Padding for the rest of the kernel
