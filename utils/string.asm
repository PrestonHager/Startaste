; Stirng Routines

; ============================================ ;
; Get String Length Routine
; Arguments: si: Location of stirng.
; Ouputs: ax: length of string.
; ============================================ ;
string_length:
  pusha
  mov ax, si
  mov bx, 0

  .find:
    lodsb
    inc bx
    cmp al, 0   ; check if the end of the string.
    jne .find

  .done:
    sub ax, bx
    push ax
    popa
    ret

; ============================================ ;
; Lower String Routine
; Arguments: si: Location of string (null terminated)
; Ouputs: si: Lowered string
; ============================================ ;
string_lower:
  pusha
  mov al, 0

  .repeat:
    lodsb
    cmp al, 65
    jl .done_repeat
    cmp al, 90
    jg .done_repeat
    add al, 32
    mov [si - 1], al
  .done_repeat:
    cmp al, 0
    jne .repeat

  .done:
    popa
    ret

; ============================================ ;
; Strip String Routine
; Arguments: si: Location of string, bl: character to be stripped.
; Ouputs: si: Stripped string
; ============================================ ;
string_strip:
  pusha

  mov ax, 0
  call string_length
  add ax, '0'
  mov [si], ax
  call graphics_print_string
  mov cx, si
  add si, ax

  .repeat:
    mov al, [si]
    cmp al, bl
    jne .done
    mov [si], BYTE 0
    dec si
    cmp si, cx
    je .done
    jmp .repeat

  .done:
    popa
    ret
