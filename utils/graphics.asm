; Graphics routines for Protected Mode

; ============================================ ;
; Put Character Routine
; Arguments: bl: Row, dl: Column, cx: Character and Color
; Outputs: None (changes display)
; ============================================ ;
graphics_put_char:
  pusha
  ; calaculate the address of the character.
  mov eax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov bx, 2
  mul bx              ; multiply everything by 2 because every character takes 2 bytes.
  add eax, VID_MEM

  .draw:
  mov [eax], cx

  .done:
  popa
  ret

; ============================================ ;
; Clear Screen Routine
; Arguments: cl: Main Color, ch: Top Color, si: Top Message
; Outputs: None (changes display)
; ============================================ ;
graphics_clear:
  pusha
  mov eax, VID_MEM        ; must use 32-bit register for addressing otherwise it thinks it's a different location.
  mov dx, 0
  mov bl, ' '             ; set the background character color and character.
  mov bh, cl

  .top_msg:
    mov cl, [si]          ; get the first character of the Top Message
    cmp cl, 0             ; make sure it's not a null character (strings are null-terminated)
    je .top_msg_finish
    mov [eax], cx         ; if it isn't then we can put it into video memory
    add eax, 2            ; increase the pointer to video memory by 2 bytes (one for character, one for color)
    inc si                ; and increment the counter and string pointer by 1
    inc dx
    cmp dx, COLUMNS       ; if the counter has reached the end of the row, then we don't need to print the rest of the message.
    jne .top_msg
  .top_msg_finish:
    mov cl, ' '           ; put the character that we are printing, a space, into lower bytes of cx
  .top_msg_finish_:
    mov [eax], cx         ; put a space at the video memory
    add eax, 2            ; add 2 to the video memeory pointer again, and increment the counter
    inc dx
    cmp dx, COLUMNS       ; if the counter has reached the end of a row then we can stop.
    jne .top_msg_finish_

  .repeat:
    mov [eax], bx
    add eax, 2
    inc dx
    cmp dx, ROWS*COLUMNS
    jne .repeat

  .move_cursor:
  mov bl, 0
  mov dl, 0
  call graphics_move_cursor

  .done:
  popa
  ret

; ============================================ ;
; Print String Routine
; Arguments: si: String (null-term), bl: Row, dl: Column, ch: Color
; Outputs: None (changes display)
; ============================================ ;
graphics_print_string:
  pusha
  ; calaculate the address of the character.
  mov eax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov bx, 2
  mul bx              ; multiply everything by 2 because every character takes 2 bytes.
  add eax, VID_MEM

  mov edx, eax
  mov ah, ch

  .repeat:
    lodsb
    cmp al, 0
    je .done
    ; the character and character is now in cx and ready to be printed.
    mov [edx], ax
    add edx, 2
    jmp .repeat

  .done:
  popa
  ret

; ============================================ ;
; Get Cursor Routine
; Arguments: None
; Outputs: bl: Row, dl: Column
; ============================================ ;
graphics_get_cursor:
  push ax
  mov ax, [GRAPHICS_CURSOR_POSITION]
  mov dl, al
  mov bl, ah

  .done:
  pop ax
  ret

; ============================================ ;
; Move Cursor Routine
; Arguments: bl: Row, dl: Column
; Outputs: None (changes display)
; ============================================ ;
graphics_move_cursor:
  pusha
  ; set the cursor position variable
  mov ax, 0
  add al, dl
  add ah, bl     ; add the lower bits onto ax
  mov [GRAPHICS_CURSOR_POSITION], ax   ; move the value of eax into the location at GRAPHICS_CURSOR_POSITION
  ; calaculate the address of the character.
  mov eax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov ebx, eax      ; it must be stored in bx so we can access it later on

  .low_byte:
  mov al, 0x0f
  mov dx, 0x03D4
  out dx, al
  mov al, bl
  mov dx, 0x03D5
  out dx, al

  .high_byte:
  mov al, 0x0e
  mov dx, 0x03D4
  out dx, al
  mov al, bh
  mov dx, 0x03D5
  out dx, al

  .done:
  popa
  ret

; define cursor position variables
GRAPHICS_CURSOR_POSITION dw 0x0000    ; 0x xx yy
