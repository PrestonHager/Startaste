; Graphics routines for Protected Mode

; ============================================ ;
; Put Character Routine
; Arguments: bl: Row, dl: Column, cx: Character and Color
; Outputs: None (changes display)
; ============================================ ;
graphics_put_char:
  pusha
  dec bl
  ; calaculate the address of the character.
  mov eax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov bl, 2
  mul bl              ; multiply everything by 2 because every character takes 2 bytes.
  add eax, VID_MEM

  .draw:
  mov [eax], cx

  .done:
  popa
  ret

; ============================================ ;
; Clear Screen Routine
; Arguments: ch: Color
; Outputs: None (changes display)
; ============================================ ;
graphics_clear:
  pusha
  mov dx, 0
  mov eax, VID_MEM        ; must use 32-bit register for addressing otherwise it thinks it's a different location.
  mov cl, ' '

  .repeat:
    mov [eax], cx
    add eax, 2
    inc dx
    cmp dx, ROWS*COLUMNS
    jne .repeat

  .move_cursor:
  mov bl, 1
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
  dec bl
  ; calaculate the address of the character.
  mov eax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov bl, 2
  mul bl              ; multiply everything by 2 because every character takes 2 bytes.
  add eax, VID_MEM

  .repeat:
    mov cl, [si]
    inc si
    cmp cl, 0
    je .done
    ; the character is now in al and ready to be printed.
    mov [eax], cx
    add eax, 2
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
  pusha

  .done:
  popa
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
  rol ax, 8     ; rotate everything 8 times to move the lower bits to the upper bits
  add al, bl     ; add the lower bits onto ax
  mov [GRAPHICS_CURSOR_POSITION], ax   ; move the value of eax into the location at GRAPHICS_CURSOR_POSITION
  dec bl
  ; calaculate the address of the character.
  mov ax, COLUMNS
  mul bl              ; row * columns
  add al, dl          ; (row * columns) + colum
  mov bl, 2
  mul bl              ; multiply everything by 2 because every character takes 2 bytes.
  add ax, VID_MEM
  mov bx, ax      ; it must be stored in bx so we can access it later on

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
