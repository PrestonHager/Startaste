; kernel for Startaste OS.
[BITS 32]
[ORG 0x8000]

kernel_main:
  mov byte [ds:0B8000h], 'P'      ; Move the ASCII-code of 'P' into first video memory
  mov byte [ds:0B8001h], 38h      ; Assign a color code
  ; start the graphics.
  mov eax, WELCOME_MSG		      ; move welcome message pointer to eax
  mov bl, 0x38			            ; main background color and char color
  call graphics_print_string	  ; call printing the message

.update:
  jmp .update

%include "utils/graphics_protected.asm"

WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
navigation_msg db 'Nebula > Formation', 0
COMMAND_MSG db '> ', 0
QUIT_MSG db 'HUNG STARTASTE', 0

times 512-($-$$-512) db 0	; Padding for the rest of the kernel
