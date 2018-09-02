; Graphics routines for Protected Mode

; ============================================ ;
; Move Cursor Routine
; Arguments: al: Column, bl: Row
; Outputs: None
; ============================================ ;
graphics_move_cursor:
  pusha

  ; first make sure the row doesn't exceed 24 and the column 80
  cmp al, 80
  je .done
  cmp bl, 24
  je .done

  mov cl, 80
  mul bl      ; note, because we know that the row doesn't exceed 24 the number cannot be larger than 1920
  mov ah, 0x0 ; null the high bytes of ax so we can add the right column number
  add bx, ax  ; add the column to the row
  mov [_GRAPHICS_CURSOR], bx  ; store the total into CURSOR

  .done:
  popa
  ret

; ============================================ ;
; Print String Routine
; Arguments: eax: String Pointer, bl: Color
; Outputs: None
; ============================================ ;
graphics_print_string:
  pusha

  mov ecx, _GRAPHICS_CURSOR  ; move the current cursor position into cx
  add ecx, _GRAPHICS_SCREEN  ; and add the base screen address

  .repeat:
    mov dl, [eax]       ; load the current character into the first half of bx
    cmp dl, 0           ; make sure it's not the end of the string.
    je .done
    mov [ecx], bx       ; mov ax into the screen plus the offset.
    add cx, 2           ; increase the offset by 2 (length of character)
    add eax, 1          ; increase the string pointer by 1
    jmp .repeat

  .done:
  popa
  ret

_GRAPHICS_SCREEN equ 0xb8000
_GRAPHICS_CURSOR db 0x0
