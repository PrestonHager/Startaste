; kernel for Startaste OS.

[org 0x7E00]
BITS 16

kernel_start:
  ; setup stack.
  ; the stack segment register (ss) is right after the kernel. so the current address + 1024. and because of 16bit memory addresses we divide it by 16.
  ; the stack pointer register (sp) is the bottom of the stack (or the offset) so it's at 0.
  mov ax, 0x0800	; the ax is a 16bit memory address (adrs*16+offset). this is the bootloader's address + it's length (512 bytes)
  add ax, 1024
  cli				; Disable interrupts while changing stack
  mov ss, ax  ; move stack segment to ax address.
  mov sp, 0x3000  ; stack pointer is offset, this is size of stack (16^3 * 3 = 12 kilobyte stack).
  sti				; Restore interrupts

  ; Set data segment to the begining of the kernel (to encapsul all the data).
  mov ax, 0x0  ; ax = bootlaoder location 16bit memory address (loc/16).
	mov ds, ax ; set ds to location.

  ; set up default values.
  mov ax, 0
  mov [newlineTyped], ax

  ; now run the graphics.
  mov ax, WELCOME_MSG		; Top bar message
  mov bx, navigation_msg	; Bottom bar message (blank/empty)
  mov cx, 0x38			; Main background color and char color
  call graphics_background	; Call draw background routine

kernel_update:
	call keyboard_input
  mov ax, [newlineTyped]
	cmp ax, 0            ; compare the newlineTyped varaible to 0, if true then it's not a newline.
	je .done_not_newline
	; Is a newline and a command has been sent.
	mov si, DEBUG_MSG
	call graphics_print_string
  ; Reset the variable.
  mov ax, 0
  mov [newlineTyped], ax
	.done_not_newline:
	jmp kernel_update		; run update loop

  WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
  DEBUG_MSG db 'debugMsg.', 0
  navigation_msg db 'Nebula > Formation', 0
  BLANK_MSG db '', 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"

times 1024-($-$$) db 0	; Padding for the rest of the kernel
