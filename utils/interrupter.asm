; Interrupter Routines

; ============================================ ;
; Run Command Routine
; Arguments: si: Location of command string (null terminated)
; Ouputs: si: Command return result (printable), ax: Command return result (code)
; ============================================ ;
interrupter_run_command:
  push di       ; push, and then later pop, the registers and stack pointers that we don't use as return values.
  push dx

  add si, 2
  call string_lower           ; WORKS: correctly lowers string, but leaves trailing whitespace.
  mov dl, ' '
  call string_strip           ; WORKS: strips the ends of strings correctly.

  ; compare each command string to the input.
  mov di, interrupter_COMMANDS_help_command           ; test the help command
  call string_compare
  cmp bx, 1
  je .help_command
  mov di, interrupter_COMMANDS_quit_command           ; test the quit command
  call string_compare
  cmp bx, 1
  je .quit_command

  ; if it doesn't match with anything, then put msg not found, and code 2.
  mov si, interrupter_MSGS_not_found  ; move cmd not found msg into default.
  mov ax, 2
  jmp .done

  ; each command has a different msg and return code.
  .help_command:
    mov si, interrupter_MSGS_help     ; set the return message.
    mov ax, 1                         ; set the return code.
    jmp .done
  .quit_command:
    mov si, interrupter_MSGS_null
    mov ax, 0                         ; set the return code.
    jmp .done

  .done:
    pop di
    pop dx
    ret

interrupter_COMMANDS_help_command db 'help', 0
interrupter_COMMANDS_quit_command db 'quit', 0
interrupter_MSGS_help db 'Help:', 0xA, 0xD, 'help: shows this help message.', 0xA, 0xD, 'quit: hangs kernel.', 0xA, 0xD, 0
interrupter_MSGS_not_found db 'Command not found.', 0xA, 0xD, 0
interrupter_MSGS_null db 0
