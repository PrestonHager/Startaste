; Stirng Routines

; ============================================ ;
; Integer to String Routine
; Arguments: ax: Integer/Number to Convert. (Max: 255), si: Location of String Buffer (len 4)
; Ouputs: si: Location of String.
; ============================================ ;
num_to_string:
  pusha
  mov bx, 10        ; divisor (or base) will always be 10.

  .repeat:          ; this is on a loop, so I can expand it later, not the most effecient.
    ; div will return: ax: result, dx: remainder
    div bx          ; divide ax (the number) by bx (the base) which drops the last digit.
    add dx, '0'     ; add '0' to dx, which will convert the decimal number to ascii
    mov [si], dx    ; move the now ascii char to si
    inc si          ; increment si by 1 to go to the next character slot.
    cmp ax, 0       ; see if the number has been fully looped over.
    jne .repeat

  .done:
    mov si, 0       ; make sure the string is null (0) terminated.
    popa
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
    cmp al, 0   ; check if the end of the string.
    jne .find

  .done:
    dec bx      ; the actual length is one more since we compare the character after we increase bx.
    pop si
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
; Compare Strings Routine
; Arguments: si: Location of string, di: location of second string.
; Ouputs: bx: true/false, 1/0, of if strings match.
; ============================================ ;
string_compare:
  push si
  mov bx, 1

  .repeat:
    mov al, [si]
    mov dl, [di]
    cmp al, dl
    jne .done_false
    cmp al, 0
    je .done
    inc si
    inc di
    jmp .repeat

  .done_false:
    mov bx, 0
  .done:
    pop si
    ret

; ============================================ ;
; Strip String Routine
; Arguments: si: Location of string, dl: character to be stripped.
; Ouputs: si: Stripped string
; ============================================ ;
string_strip:
  pusha

  ; get the length of the string, so we can work with the string from back to front, removing trailing characters first.
  call string_length    ; WORKS: the resulting number is 79 for every command line entry.
  mov cx, si            ; put si into cx, this is a number value, so it can be compared (resulting in the beginning of the string).
  add si, bx            ; add bx (the string length, to si) this moves the address to the end of the string.
  dec si                ; subtract one more from the string, as the length is 1 more than the index of the string.

  .repeat:
    mov al, [si]        ; same as lodsb, moves char at si to al and doesn't increase si, since we will decrease it later.
    cmp al, dl          ; if the character is the same as the character to be stripped, then overwrite it to BYTE 0
    jne .done           ; if not, then finish
    mov [si], BYTE 0
    dec si              ; move si down one, this goes backwards in the string.
    cmp si, cx          ; if si is at the beginning of the string, then finish.
    je .done
    jmp .repeat         ; otherwise, repeat what just happened.

  .done:
    popa
    ret
