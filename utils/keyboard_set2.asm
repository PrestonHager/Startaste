; Keyboard Scancode Set 2 routines for Protected Mode

; ============================================ ;
; Keyboard Scancode Set 2 Input Routine
; Arguments: None
; Outputs: cl: Character
; ============================================ ;
keyboard_set2_input:
  in al, 0x60       ; get the scan code and put it in cl for later

  ; test for the special cases, backspace, space, shift, etc.
  cmp al, 0x0E
  je .backspace
  cmp al, 0x1C
  je .enter_key
  cmp al, 0x39
  je .space
  cmp al, 0x2A
  je .l_shift
  cmp al, 0x36
  je .r_shift
  cmp al, 0xAA
  je .l_shift_release
  cmp al, 0xB6
  je .r_shift_release

  .alpha_keys:
    mov bx, SCANCODE_ALPHA    ; index the SCANCODE_ALPHA list and test the scancode
    .repeat:
    mov cl, [bx]              ; pull from list
    inc bl                    ; increment pointer
    cmp bx, SCANCODE_ALPHA+26 ; if we've reached the end move on
    je .num_keys
    cmp al, cl                ; if the scancode is equal to the one in the list then continue, otherwise repeat
    jne .repeat
    sub bl, SCANCODE_ALPHA    ; this will nuetralize the index
    mov cl, [R_SHIFT_PRESSED] ; test to see if the shift key is pressed if it is add 0x40 if it isn't add 0x60
    cmp cl, 0x01
    je .shift_pressed
    mov cl, [L_SHIFT_PRESSED] ; test the left shift key too
    cmp cl, 0x01
    je .shift_pressed
      add bl, 0x60
      jmp .shift_done
    .shift_pressed:
      add bl, 0x40
    .shift_done:
    mov cl, bl
    jmp .done
  .num_keys:
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
  ret

SCANCODE_ALPHA db 0x1E, 0x30, 0x2E, 0x20, 0x12, 0x21, 0x22, 0x23, 0x17, 0x24, 0x25, 0x26, 0x32, 0x31, 0x18, 0x19, 0x10, 0x13, 0x1F, 0x14, 0x16, 0x2F, 0x11, 0x2D, 0x15, 0x2C
SCANCODE_NUM db 0x0b, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a
L_SHIFT_PRESSED db 0x00
R_SHIFT_PRESSED db 0x00

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
