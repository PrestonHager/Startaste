; String routines for Protected Mode

; ============================================ ;
; Get Row Routine
; Arguments: bl: Row
; Outputs: si: Pointer to Row String
; ============================================ ;
string_get_row:
  pusha
  mov si, STRING_ROW_STRING
  mov eax, COLUMNS
  mul bl                      ; row * columns
  mov bx, 2                   ; multiply everything by 2 because every character takes 2 bytes.
  mul bx
  add eax, VID_MEM            ; add the video memory address
  mov bx, 80

  .repeat:
    mov cl, [eax]
    mov [si], cl
    add eax, 2
    inc si
    dec bx
    cmp bx, 0
    je .done
    jmp .repeat

  .done:
    mov [si], byte 0
    popa
    mov si, STRING_ROW_STRING
    ret

; ============================================ ;
; Strip String Routine
; Arguments: si: Location of String, cl: Character to Strip.
; Ouputs: None
; ============================================ ;
string_strip:
  pusha

  ; mov bx, 0       ; set the start length to 0
  ; .length:
  ;   mov bl, [si]  ; get the character in si
  ;   inc ax        ; increase both ax and si by 1
  ;   inc si
  ;   cmp bl, 0     ; if it's the end then continue, otherwise repeat.
  ;   jne .length

  .done:
    popa
    ret

STRING_ROW_STRING times COLUMNS+1 db 0
