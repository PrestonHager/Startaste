; Graphics routines

; ============================================ ;
; Move Cursor Routine
; Arguments: dh: Row, dl: Column
; Ouputs: None
; ============================================ ;
graphics_move_cursor:   ; Move cursor routine
  pusha       ; Push registers to stack

  mov bh, 0   ; Page argument
  mov ah, 2   ; Function code
  int 10h		; Call video screen draw interrupt

  popa
  ret

; ============================================ ;
; Get Cursor Routine
; Arguments: None
; Outputs: dh: Row, dl: Column
; ============================================ ;
graphics_get_cursor:   ; Move cursor routine
  mov bh, 0   ; Page argument
  mov ah, 3   ; Function code
  int 10h		; Call video screen draw interrupt

  ret

; ============================================ ;
; Hide Cursor Routine
; Arguments: None
; Outputs: None
; ============================================ ;
graphics_hide_cursor:   ; Hide cursor routine
  pusha
  call graphics_get_cursor    ; Set the start scan line and end scan line by getting the cursor
  mov cx, 2607h   ; Default cursor option with last bit set to non-zero
  mov ah, 1       ; Function code
  int 10h         ; Call video screen draw interrupt
  popa
  ret

; ============================================ ;
; Show Cursor Routine
; Arguments: None
; Outputs: None
; ============================================ ;
graphics_show_cursor:   ; Hide cursor routine
  pusha
  call graphics_get_cursor    ; Set the start scan line and end scan line by getting the cursor
  mov cx, 0607h   ; Default cursor option with last bit set to zero
  mov ah, 1       ; Function code
  int 10h         ; Call video screen draw interrupt
  popa
  ret

; ============================================ ;
; Get Character Routine
; Arguments: None
; Outputs: dh: Color, dl: Character
; ============================================ ;
graphics_get_character: ; Get character routine
  mov bh, 0   ; Page argument
  mov ah, 8   ; Function code
  int 10h     ; Call video screen draw interrupt

  ret

; ============================================ ;
; Get Character XY Routine
; Arguments: dh: x coord, dl: y coord
; Outputs: dh: Color, dl: Character
; ============================================ ;
graphics_get_character_xy:
  pusha
  mov al, dh
  mov bl, 160
  mul bl            ; AX = x * 80 * 2
  xor bx, bx
  mov bl, dl
  add bx, bx        ; BX = y * 2
  add ax, bx        ; AX = x*160 + y*2
  mov si, ax
  mov ax, 0x0B800
  mov es, ax        ; ES:SI points to the character at the coordinates X, Y
  mov dl, [es:si]   ; DL has the ASCII code of the character at coordinates X, Y
  mov dh, [es:si+2] ; DH has the collor code of the character
  popa

; ============================================ ;
; Get Line Routine
; Arguments: dh: Line
; Outputs: si: Line ASCII (which is also at memory location labeled, "graphics_get_line_string")
; ============================================ ;
graphics_get_line:
  pusha

  mov ax, 0xB800
  ; add ax, dh
  mov es, ax              ; move the memory address of the start of the video screen into extra segment.
  mov si, 0               ; the source index is the offset which starts at 0 plus 2 * dh (the line number) * 80.
  mov ax, 160
  mul dh
  add si, ax
  mov di, 0               ; the destination index is the offset for moving a character into memory.
  mov cx, 80              ; counting register set to the number of times to run the loop.

  .repeat:
    mov ax, [es:si]       ; move the character at memory address es:si into ax. this will be the first 8 bits which is the character code.
    mov [graphics_get_line_string + di], ax     ; move the character in ax to the graphics_get_line_string variable location.
    add si, 2
    add di, 1
    dec cx
    cmp cx, 0           ; run loop 80 times. adding 2 to si each time makes it 160 at the end.
    jne .repeat

  mov [graphics_get_line_string + 80], DWORD 0    ; the last character has a color code that isn't writen over so write a null over it.

  .done:
    popa
    mov si, graphics_get_line_string
    ret

; ============================================ ;
; Print String Routine
; Arguments: si: Message Location (zero-terminated string)
; Outputs: None
; ============================================ ;
graphics_print_string:
	pusha

	mov ah, 0Eh    ; Function code

  .repeat:
  	lodsb				; Get char from string
  	cmp al, 0
  	je .done			; If char is zero, finish
  	int 10h				; Else, call 10h interrupt
  	jmp .repeat			; And then loop

  .done: ; finish function
  	popa
  	ret

; ============================================ ;
; Print Number Routine
; Arguments: si: Message Location (ten-terminated number sequence)
; Outputs: None
; ============================================ ;
graphics_print_number:
	pusha

	mov ah, 0Eh    ; Function code

  .repeat:
  	lodsb				; Get char from string
  	cmp al, 10
  	je .done			; If char is zero, finish
    add al, '0'   ; add char '0' to al, to make it a number
  	int 10h				; Else, call 10h interrupt
  	jmp .repeat			; And then loop

  .done: ; finish function
  	popa
  	ret

; ============================================ ;
; Move Cursor to End of Line Routine
; Arguments: dh: Line
; Outputs: None
; ============================================ ;
graphics_move_end_line:
  pusha

  call graphics_hide_cursor
  call graphics_get_cursor
  mov dl, 80                      ; Set column to end of row
  call graphics_move_cursor
  .loop_find_character:           ; Find the last character of that row and set cursor there
    cmp dl, 0                   ; If in first column of row then row is empty and jump to finish
    je .done
    dec dl                      ; Otherwise continue... Go back one column
    call graphics_move_cursor
    call graphics_get_character
    cmp al, 32                  ; Test to see if character is space
    je .loop_find_character
  inc dl                          ; If there is a character increment column one and continue
  .done:
    call graphics_move_cursor
    call graphics_show_cursor
    popa
    ret

; ============================================ ;
; Clear Screen Routine
; Arguments: None
; Outputs: None
; ============================================ ;
graphics_clear_screen:
  pusha

  mov dl, 0
  mov dh, 0
  call graphics_move_cursor       ; first, set the cursor to 0, 0

  ; then print a lot of spaces with black background.
  mov ah, 09h     ; function code
  mov bh, 0       ; page number
  mov bl, 0x0F    ; color code
  mov cx, 80*25   ; number of times to print char.
  mov al, ' '     ; the character
  int 10h         ; call the BIOS call of video services.

  mov dl, 0
  mov dh, 0
  call graphics_move_cursor

  .done:
    popa
    ret

; ============================================ ;
; Draw Background Routine
; Arguments: ax: Top Text, bx: Bottom Text, cx: Color
; Outputs: None
; ============================================ ;
graphics_background:
  pusha
  push ax				; Store params to pop out later
  push bx
  push cx

  mov dl, 0
  mov dh, 0
  call graphics_move_cursor

  mov ah, 09h			; Draw white bar at top
  mov bh, 0
  mov cx, 80
  mov bl, 0x90
  mov al, ' '
  int 10h

  mov dl, 0
  mov dh, 1
  call graphics_move_cursor

  mov ah, 09h			; Draw color section
  mov cx, 1840
  pop bx				; Get color param (originally in CX)
  mov bh, 0
  mov al, ' '
  int 10h

  mov dh, 24
  mov dl, 0
  call graphics_move_cursor

  mov ah, 09h			; Draw white bar at bottom
  mov bh, 0
  mov cx, 80
  mov bl, 0x90
  mov al, ' '
  int 10h

  mov dh, 24
  mov dl, 0
  call graphics_move_cursor
  pop bx				; Get bottom string param
  mov si, bx
  call graphics_print_string

  mov dh, 0
  mov dl, 0
  call graphics_move_cursor
  pop ax				; Get top string param
  mov si, ax
  call graphics_print_string

  mov dh, 1
  mov dl, 0
  call graphics_move_cursor

  popa
  ret

graphics_get_line_string times 80 dw 0