BITS 16

; Bootloader 1

start:
	mov ax, 07C0h	; Set up 4k stack space after bootloader
	add ax, 288	; (4096 + 512) / 16 bytes per paragraph
	cli				; Disable interrupts while changing stack
	mov ss, ax
	mov sp, 4096
	sti				; Restore interrupts

	mov ax, 07C0h	; Set data segment to where it's loaded
	mov ds, ax

	mov ax, WELCOME_MSG		; Top bar message
	mov bx, navigation_msg	; Bottom bar message (blank/empty)
	mov cx, 0x38			; Main background color and char color
	call graphics_background	; Call draw background routine
	;call print_string	; Call print_string routine

update:
	call keyboard_input
	call graphics_get_cursor
	cmp dh, 1
	je .done_not_newline
	cmp dl, 0
	jne .done_not_newline
	; Is a newline and a command has been sent.
	.done_not_newline:
	jmp update		; run update loop
;jmp $	; Hang at end.

	WELCOME_MSG db 'Welcome to Startaste! You are currently in the Formation!', 0
	navigation_msg db 'Nebula > Formation', 0
	BLANK_MSG db '', 0

;%include "utils/print_string.asm"
%include "utils/graphics.asm"
%include "utils/keyboard.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
