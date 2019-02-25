; Keyboard routines for Protected Mode

; ============================================ ;
; Get Keyboard Input Routine
; Arguments: None
; Outputs: cl: Character
; ============================================ ;
keyboard_input:
  push ax
  mov cl, 0x00

  in al, 0x64       ; get the status port byte. If bit-0 is 1 then the keyboard buffer has something
  bt ax, 0          ; test bit-0
  jnc .done

  ; find what scancode set we are working with and execute finding that character.
  mov al, [KEYBOARD_TYPE]
  cmp al, 0x3F
  je .set1
  cmp al, 0x41
  je .set2
  .set3:
    call keyboard_set3_input
    jmp .done
  .set1:
    call keyboard_set1_input
    jmp .done
  .set2:
    call keyboard_set2_input

  .done:
  pop ax
  ret

; ============================================ ;
; Keyboard Initialize Routine
; Arguments: None
; Outputs: None
; ============================================ ;
keyboard_init:
  pusha

  .find_scan_set:
    mov al, 0xF0        ; ask the keyboard for the scancode command.
    out 0x60, al
    call keyboard_ack
    mov al, 0x00
    out 0x60, al        ; send the option command of 0x00 to the keyboard for getting the scancode set.
    call keyboard_ack
    in al, 0x60         ; get the actual scancode set and put it into KEYBOARD_TYPE
    ; 0x3F = Set 1, 0x41 = Set 2, 0x43 = Set 3
    mov [KEYBOARD_TYPE], al

  .done:
  popa
  ret

; ============================================ ;
; Keyboard Acknowledge Routine
; Arguments: dl: Port
; Outputs: None
; ============================================ ;
keyboard_ack:
  pusha

  .get_ack:
  in al, 0x60         ; look for ACK response (FA)
  cmp al, 0xFA
  jne .get_ack

  .done:
  popa
  mov ax, 0x00        ; finish with no error
  ret
  .done_error:
  popa
  mov ax, 0x01        ; finish with an error of some sort occuring.
  ret

KEYBOARD_TYPE db 0    ; Not properly set until after a call to keyboard_init

%include "utils/keyboard_sets.asm"
