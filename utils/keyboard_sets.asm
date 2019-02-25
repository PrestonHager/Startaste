; Keyboard Scancode Set 2 routines for Protected Mode

; ============================================ ;
; Keyboard Scancode Set 2 Input Routine
; Arguments: None
; Outputs: cl: Character
; ============================================ ;
keyboard_set2_input:
  push eax
  push ebx
  push edx
  in al, 0x60       ; get the scan code and put it in cl for later

  ; test for the special cases, backspace, space, shift, etc.
  cmp al, 0x0E
  je .backspace
  cmp al, 0x1C
  je .enter_key
  cmp al, 0x39
  je .space
  cmp al, 0x01
  je .escape
  cmp al, 0x2A
  je .l_shift
  cmp al, 0x36
  je .r_shift
  cmp al, 0xAA
  je .l_shift_release
  cmp al, 0xB6
  je .r_shift_release

  .alpha_keys:
    cmp al, 0x10                  ; if the scancode is between 0x10 and 0x32 it is an alpha character
    jl .number_keys               ; otherwise we jump to the .not_alpha label
    cmp al, 0x32
    jg .number_keys
    mov ebx, SCANCODE_ALPHA-0x10  ; this is a pointer to which character to print
    add bl, al
    mov cl, [ebx]
    ; if the character is a '-' then it's actually a non-alpha character but might be examined later
    cmp cl, '-'
    je .not_number                ; normally we might jump to .number_keys, but we know due to keyboard mapping that it can't be a number
    ; here the character is stored in bl and we test for the shift button to make other characters
    mov bl, [R_SHIFT_PRESSED]     ; test to see if the shift key is pressed if it isn't then we add 0x20
    cmp bl, 0x01
    je .done
    mov bl, [L_SHIFT_PRESSED]     ; test the left shift key too
    cmp bl, 0x01
    je .done
    ; if no statment has jumped yet, then the shift key is not pressed and we add 0x20 to make the character lower case
    add cl, 0x20
    jmp .done
  .number_keys:
    cmp al, 0x02                  ; test for al to be between 0x02 and 0x0b (keys 1-0)
    jl .not_number                ; if it isn't then jump to .not_number
    cmp al, 0x0b
    jg .not_number
    mov edx, 0x0
    add dl, al
    add edx, SCANCODE_NUM-0x02    ; edx is a pointer that we add al (the scancode) to
    ; test for the shift key, if it's pressed add 0xa (10) to the pointer to get the character above the number key
    mov bl, [R_SHIFT_PRESSED]
    cmp bl, 0x01
    je .number_shift_pressed
    mov bl, [L_SHIFT_PRESSED]
    cmp bl, 0x01
    je .number_shift_pressed
    jmp .number_done
    .number_shift_pressed:
      add edx, 0x0a               ; if the either shift button is pressed we add 0x0a (10) to the pointer
    .number_done:
    mov cl, [edx]                 ; move the character at the pointer into cl
    jmp .done
  .not_number:
  mov cl, 0x00
  jmp .done

  .backspace:
    mov cl, 0x08
    jmp .done
  .enter_key:
    mov cl, 0x10
    jmp .done
  .space:
    mov cl, 0x20
    jmp .done
  .escape:
    mov cl, 0x00
    jmp .done
  .l_shift:
    mov [L_SHIFT_PRESSED], BYTE 0x01
    jmp .done
  .l_shift_release:
    mov [L_SHIFT_PRESSED], BYTE 0x00
    jmp .done
  .r_shift:
    mov [R_SHIFT_PRESSED], BYTE 0x01
    jmp .done
  .r_shift_release:
    mov [R_SHIFT_PRESSED], BYTE 0x00
    jmp .done

  .done:
  pop eax
  pop ebx
  pop edx
  ret

L_SHIFT_PRESSED db 0x00
R_SHIFT_PRESSED db 0x00
SCANCODE_ALPHA db 'QWERTYUIOP----ASDFGHJKL-----ZXCVBNM'  ; first character is 0x10, last at 0x32
SCANCODE_NUM db '1234567890!@#$%^&*()'                   ; first character is 0x02, last at 0x0b

; ============================================ ;
; Keyboard Scancode Set 1 Input Routine
; Arguments: None
; Outputs: cl: Character
; ============================================ ;
keyboard_set1_input:
  in al, 0x60       ; get the scan code and put it in cl for later
  mov cl, al

  .done:
  ret

; ============================================ ;
; Keyboard Scancode Set 3 Input Routine
; Arguments: None
; Outputs: cl: Character
; ============================================ ;
keyboard_set3_input:
  in al, 0x60       ; get the scan code and put it in cl for later
  mov cl, al

  .done:
  ret
