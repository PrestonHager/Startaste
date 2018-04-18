; Keyboard routines

; ============================================ ;
; Testfor Input Routine
; Arguments: None
; ============================================ ;
keyboard_test_input:    ; Testfor input routine
  pusha
  mov ah, 01h     ; Function code
  int 16h
  jz .done
  ; otherwise there was a key press...
  popa
  mov ah, 00h     ; Function code
  int 16h         ; Call 16h interrupt
  ret             ; Return with values in ah and al
  .done:      ; Finish routine
    popa
    ret

; ============================================ ;
; Keyboard Input Routine
; Arguments: None
; Outputs: ax: Newline entered (1 = true, 0 = false)
; ============================================ ;
keyboard_input:     ; Keyboard input routine
    pusha

  .repeat:
    mov al, 0

    call keyboard_test_input
    cmp al, 0
    jne .is_ascii    ; finish if no key pressed
    cmp ah, 0
    jne .is_scan_code
    jmp .done

  .is_scan_code:
    cmp ah, 4Bh
    je near .left_arrow         ; I had to add the near jump here. I'm not entirely sure what this means or does. NOTE TO SELF: Research Later.
    cmp ah, 4Dh
    je .right_arrow
    jmp .done
  .is_ascii:
    mov ah, 0Eh
    cmp al, 8
    je .backspace
    cmp al, 13
    je .newline
    cmp al, 9
    je .tab
    int 10h
    jmp .done

  .backspace:
    call graphics_get_cursor
    cmp dl, 0                       ; See if the column number is 0
    jne .backspace_normal           ; If it isn't then jump to normal backspace
    cmp dh, 1                       ; If the next row is the first row then don't go back a line
    je .done
    dec dh
    call graphics_move_cursor
    call graphics_move_end_line
    jmp .done

  .backspace_normal:
    mov ah, 0Eh
    mov al, 8
    int 10h
    mov al, 32
    int 10h
    mov al, 8
    int 10h
    jmp .done

  .newline:
    call graphics_get_cursor    ; Get cursor row and column
    cmp dh, 23                  ; Compare row to last row
    je .done                    ; If last row then finish, otherwise continue
    pop ax
    mov ax, 1
    push ax
    mov ah, 0Eh
    mov al, 13
    int 10h
    mov al, 10
    int 10h
    jmp .done

  .tab:
    call graphics_get_cursor    ; Get the cursor row and column
    add dl, 2     ; Add 2 to the column register for the graphics cursor function(s)
    call graphics_move_cursor
    jmp .done   ; Now finish.

  .right_arrow:
    call graphics_get_cursor
    inc dl
    cmp dl, 81
    jne .done_right_arrow_not_endline
    mov dl, 0
    inc dh
    cmp dh, 24
    je .done_right_arrow_not_endline
    .done_right_arrow_not_endline:
    call graphics_move_cursor
    jmp .done

  .left_arrow:
    call graphics_get_cursor
    cmp dl, 0
    jne .left_arrow_not_begining_line
    cmp dh, 1
    je .done
    dec dh
    call graphics_move_cursor
    call graphics_move_end_line
    jmp .done
    .left_arrow_not_begining_line:
    dec dl
    call graphics_move_cursor
    jmp .done

  .done:
    popa
    ret

newlineTyped db 0
