; Keyboard routines for Protected Mode

; ============================================ ;
; Get Keyboard Input Routine
; Arguments: None
; Outputs: al: Character
; ============================================ ;
keyboard_input:
  mov cl, 0

  jmp .done
  in al, 0x60       ; get the scan code and put it in cl for later
  mov cl, al

  in al, 0x61       ; reset the control port to read the next character
  rol al, 4
  or al, 0x80       ; the two lines that execute here are:
  out 0x61, al      ; outp(0x61, IN | 0x80);
  ror al, 4         ; outp(0x61, IN);
  out 0x61, al

  mov al, 0x20      ; send 0x20 to port 0x20
  out 0x20, al

  .done:
  mov al, cl        ; that scancode that is still in cl is moved to al
  ret

; ============================================ ;
; Keyboard Initialize Routine
; Arguments: None
; Outputs: None
; ============================================ ;
keyboard_init:
  pusha

  .test_keyboard_on:
    mov al, 0x20        ; send a read request to the PS/2 controller
    out 0x64, al
    in al, 0x60
    ; test bit and reset it (to 0)
    btr ax, 4           ; byte-4 is keyboard enabled (0=yes, 1=no)
    jc .keyboard_on
    ; if the keyboard isn't enabled then enable it
    rol ax, 4
    mov al, 0x60        ; send a write request
    out 0x64, al
    ror ax, 4
    out 0x60, al        ; write the actual data (status byte) to port 0x60
    .keyboard_on:

  .done:
  popa
  ret

KEYBOARD_TYPE db 0    ; Not properly set until after a call to keyboard_init
