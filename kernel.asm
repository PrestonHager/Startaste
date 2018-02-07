; kernel for Startaste OS.

start:
  mov ax, WELCOME_MSG		; Top bar message
  mov bx, navigation_msg	; Bottom bar message (blank/empty)
  mov cx, 0x38			; Main background color and char color
  call graphics_background	; Call draw background routine

update:
	call keyboard_input
	; call graphics_get_cursor
	; cmp dh, 1					; Cannot be a new command on the first line.
	; je .done_not_newline
	; cmp dl, 0					; If the column is == to 0 then continue otherwise not new line.
	; jne .done_not_newline
	; ; Is a newline and a command has been sent.
	; mov si, DEBUG_MSG
	; call graphics_print_string
	.done_not_newline:
	jmp update		; run update loop

  WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
  DEBUG_MSG db 'debugMsg.', 0
  navigation_msg db 'Nebula > Formation', 0
  BLANK_MSG db '', 0

%include "utils/graphics.asm"
%include "utils/keyboard.asm"

times 512-($-$$) db 0	; Padding for the rest of the kernel
