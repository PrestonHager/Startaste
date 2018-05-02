; Interrupter Routines

; ============================================ ;
; Run Command Routine
; Arguments: si: Location of command string (null terminated)
; Ouputs: si: Command return result (printable), ax: Command return result (code)
; ============================================ ;
interrupter_run_command:
  push di

  add si, 2
  call string_lower
  call graphics_print_string
  mov bl, ' '
  call string_strip
  call graphics_print_string
  ; mov ax, 2
  ; ret

  mov di, interrupter_COMMANDS_help_command           ; test the help command
  cmpsb
  je .help_command
  mov di, interrupter_COMMANDS_quit_command           ; test the quit command
  cmpsb
  je .quit_command
  jmp .done         ; if it's not any of those commands, then just finish.
  .help_command:
    mov si, interrupter_MSGS_help         ; set the return message.
    mov ax, 1                             ; set the return code.
    jmp .done
  .quit_command:
    mov ax, 0             ; set the return code.
    jmp .done

  .done:
    mov si, interrupter_MSGS_help
    mov ax, 2
    pop di
    ret

interrupter_COMMANDS_help_command db 'help', 0
interrupter_COMMANDS_quit_command db 'quit', 0
interrupter_MSGS_help db 'Help:', 0xA, 0xD, 'help: shows this help message.', 0xA, 0xD, 'quit: hangs kernel.', 0xA, 0xD, 0
