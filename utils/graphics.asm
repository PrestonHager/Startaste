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
; Outputs: si: Line ASCII
; ============================================ ;
graphics_get_line:
  pusha
  pop si      ; pop si so we can write to it
  ; call graphics_get_cursor
  ; mov [graphics_get_line_row_save], dh      ; dh: row; dl: column
  ; mov [graphics_get_line_column_save], dl   ; get the current cursor and save it in memory in graphics_get_line_row_save and graphics_get_line_column_save
  mov si, WORD 0
  mov dl, 0   ; set the column of the cursor to 0 and move it, this will set it at the begining of the selected line.
  ; call graphics_move_cursor

  .repeat:
    call graphics_get_character_xy
    mov [si], dl               ; get the character and move it into the si register
    inc si      ; increment offset by 1
    ; call graphics_get_cursor
    ; cmp dl, 80
    ; je .done      ; compare column to last column and if last then finish.
    inc dl                      ; get the cursor again and move it one column to the right
    cmp dl, 81
    je .done
    ; call graphics_move_cursor
    jmp .repeat

  .done:
    ; mov dh, [graphics_get_line_row_save]
    ; mov dl, [graphics_get_line_column_save]   ; move memory values for saved row and column into dh/dl for moving cursor back to original position
    ; call graphics_move_cursor
    push si     ; make sure si is preserved
    popa

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
; Draw Background Routine
; Arguments: ax: Top Text, bx: Bottom Text, cx: Color
; Outputs: None
; ============================================ ;
graphics_background:     ; Draw background routine
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
  mov dl, 1
  call graphics_move_cursor
  pop bx				; Get bottom string param
  mov si, bx
  call graphics_print_string

  mov dh, 0
  mov dl, 1
  call graphics_move_cursor
  pop ax				; Get top string param
  mov si, ax
  call graphics_print_string

  mov dh, 1			; Ready for app text
  mov dl, 0
  call graphics_move_cursor

  popa
  ret

graphics_get_line_row_save db 0
graphics_get_line_column_save db 0
