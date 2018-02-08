BITS 16

; bootloader for Startaste OS. This boot's the main assembly.

bootloader:
  mov ax, 07C0h	; Set up 4k stack space after bootloader
  add ax, 288	; (4096 + 512) / 16 bytes per paragraph
  cli				; Disable interrupts while changing stack
  mov ss, ax
  mov sp, 4096
  sti				; Restore interrupts

  mov ax, 07C0h	; Set data segment to where it's loaded
	mov ds, ax

  .read_disk:
  ; read the disk
  mov ah, 02h ; function: read sectors from drive
  mov al, 0x1 ; sectors to read
  mov ch, 0x0 ; tracks
  mov cl, 0x2 ; sector number
  mov dh, 0x0 ; head
  mov dl, 0x0 ; drive
  mov bx, 0x07E0 ; address for ES. will calcuate to 0x7E00 with offset included.
  mov es, bx
  xor bx, bx  ; now set bx (offset) to 0.
  int 0x13
  ; if the disk doesn't load. then jump to printing an error.
  jc .error
  ; otherwise jump to the code.
  jmp 0x7E00

  .error:
    mov si, ERROR_MSG
    mov ah, 01h ; function: get status of last drive operation.
    mov dl, 0x0 ; drive
    int 0x13
    add [si], ah
    call print_string
    jmp $

ERROR_MSG db " # Error in booting.", 0

%include "utils/print_string.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
