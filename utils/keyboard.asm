; Keyboard routines for Protected Mode

; ============================================ ;
; Get Keyboard Input Routine
; Arguments: None
; Outputs: al: Character
; ============================================ ;
keyboard_input:
  mov al, 0
  
  .done:
  ret

; ============================================ ;
; Keyboard Initialize Routine
; Arguments: None
; Outputs: None
; ============================================ ;
keyboard_init:
  pusha

  mov al, 0xF4
  out 0x60, al

  .done:
  popa
  ret

KEYBOARD_TYPE db 0    ; Not properly set until after a call to keyboard_init
