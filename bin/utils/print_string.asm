; Print string routine

print_string:		; actual label
	mov ah, 0Eh	; int 10h 'print char' function

.repeat:
	lodsb		; Get character from string
	cmp al, 0
	je .done	; If char is zero, finish
	int 10h		; Else, call 10h-0Eh
	jmp .repeat	; And loop

.done:
	ret
