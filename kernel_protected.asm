; kernel for Startaste OS.

[org 0x8000]
BITS 32

kernel_main:
.start:
  jmp $
  ; start the graphics.
  mov ax, WELCOME_MSG		; Top bar message
  mov cx, 0x38			; Main background color and char color
  call graphics_print_string	; Call draw background routine
  mov si, COMMAND_MSG         ; and prompt user for next command.
  call graphics_print_string

.update:
  jmp .update

%include "utils/graphics_protected.asm"

WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '> ', 0
QUIT_MSG db 'HUNG STARTASTE', 0

times 512-($-$$) db 0	; Padding for the rest of the kernel
