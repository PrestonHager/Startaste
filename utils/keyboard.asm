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

; ============================================ ;
; Keyboard Update Routine
; Arguments: None
; Outputs: None (changes display)
; ============================================ ;
keyboard_update:
  pusha

  ; NOTE: keyboard driver is work in progress not all scancode sets will work
  call keyboard_input
  cmp cl, 0
  je .key_not_found
  mov ch, 0x90
  call graphics_get_cursor
  cmp cl, 0x08
  je .backspace
  cmp cl, 0x10
  je .enter_key
  call graphics_put_char
  jmp .move_cursor

  ; Test cases, the basckspace and enter keys.
  .backspace:
    cmp dl, 0                   ; if: column != 0
    je .column_0
    dec dl                      ; then: column -= 1
    jmp .column_0_next
    .column_0:
    cmp bl, 1                   ; if the row is 1 then don't delete any further
    je .next
    dec bl                      ; else: row -= 1
    mov dx, 79                  ; column = 79 (actually column 80 bc 0-indexed)
    ; test to see if the last character of the previous row is a space, if it isn't then delete and continue
    mov eax, COLUMNS      ; math for calculating video memory below
    mul bl
    add ax, dx
    mov cx, 2
    mul cx
    add eax, VID_MEM
    mov dx, 79            ; for some reason the dx register had been reset, so we just move it back to the end of the row
    cmp [eax], byte 0x20
    jne .column_0_next
    .find_space:          ; if it is a space then, find the next non-space character, move back one space and return
    cmp dl, 0             ; if we get all the way to column 0 without finding a character then move on
    je .next
    sub eax, 2
    dec dl
    cmp [eax], byte 0x20
    je .find_space
    inc dl
    jmp .next
    .column_0_next:
    mov cx, 0x9020        ; cl=0x20, ch=0x90
    call graphics_put_char
    jmp .next
  .enter_key:
    call interpreter_run
    jmp .next

  ; Otherwise if none of the test cases were met we jump here and move the cursor variables
  .move_cursor:
  inc dl
  cmp dl, 80
  jne .next
  mov dl, 0
  inc bl
  .next:      ; finnaly actually move the cursor
  call graphics_move_cursor

  ; This gets called either if no key was found or once everything is done.
  .key_not_found:
    popa
    ret

KEYBOARD_TYPE db 0    ; Not properly set until after a call to keyboard_init

%include "utils/keyboard_sets.asm"
