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
  add eax, VID_MEM+2          ; add the video memory address and a character (because the command message is 1 character)
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
; Get String Length Routine
; Arguments: si: Location of stirng.
; Ouputs: bx: length of string.
; ============================================ ;
string_length:
  push si
  mov bx, 0     ; set default string length to 0, then count up

  .find:
    lodsb
    inc bx      ; increase string length var by 1
    or al, al   ; check if the end of the string.
    jnz .find

  .done:
    dec bx      ; the actual length is one more since we compare the character after we increase bx.
    pop si
    ret

; ============================================ ;
; Strip String Routine
; Arguments: si: Location of string, cl: character to be stripped.
; Ouputs: si: Stripped string
; ============================================ ;
string_strip:
  pusha

  ; get the length of the string, so we can work with the string from back to front, removing trailing characters first.
  call string_length    ; WORKS: the resulting number is 79 for every command line entry.
  mov dx, si            ; put si into cx, this is a number value, so it can be compared (resulting in the beginning of the string).
  add si, bx            ; add bx (the string length, to si) this moves the address to the end of the string.
  dec si                ; subtract one more from the string, as the length is 1 more than the index of the string.

  .repeat:
    mov al, [si]        ; same as lodsb, moves char at si to al and doesn't increase si, since we will decrease it later.
    cmp al, cl          ; if the character is the same as the character to be stripped, then overwrite it to BYTE 0
    jne .done           ; if not, then finish
    mov [si], BYTE 0
    dec si              ; move si down one, this goes backwards in the string.
    cmp si, dx          ; if si is at the beginning of the string, then finish.
    je .done
    jmp .repeat         ; otherwise, repeat what just happened.

  .done:
    popa
    ret

; ============================================ ;
; Compare Strings Routine
; Arguments: si: Location of string, di: location of second string.
; Ouputs: ax: true/false, 1/0, of if strings match.
; ============================================ ;
string_compare:
  push si
  push bx
  push dx
  mov ax, 1

  .repeat:
    mov bl, [si]
    mov dl, [di]
    cmp bl, dl
    jne .done_false
    or bl, dl
    jz .done
    inc si
    inc di
    jmp .repeat

  .done_false:
    mov ax, 0
  .done:
    pop dx
    pop bx
    pop si
    ret

; ============================================ ;
; Strip String Routine
; Arguments: si: Location of String
; Ouputs: si: Location of String
; ============================================ ;
string_lowercase:
  pusha

  .repeat:
    lodsb           ; load a character into al
    cmp al, 0       ; if it's a null, it's the end of the string.
    je .done
    cmp al, 0x41    ; if the character is less than 'A' then loop again
    jl .repeat
    cmp al, 0x5A    ; if the character is greater than 'Z' then loop again
    jg .repeat
    add al, 0x20    ; otherwise, add 0x20 to lowercase the character
    mov [si-1], al    ; move al back into [si]
    jmp .repeat     ; and repeat

  .done:
    popa
    ret

STRING_ROW_STRING times COLUMNS+1 db 0
