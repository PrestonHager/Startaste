; bootloader for Startaste OS. This boot's the kernel.

[org 0x0]
BITS 16

bootloader:
  ; how does the stack work?
  ; xor  ax, ax      ; This is shorter/faster than "mov ax, 0h"
  ; mov  ds, ax
  ; mov  ss, ax
  ; mov  sp, 0x200   ; set stack pointer after our bootloader
  ; mov  di, 0x0   ; set Data pointer to memory location where is our bootloader loaded

  ; i know that this code works, but i don't know how.
  ; set up a stack after the bootloader.
  ;  = 0x7C00 / 16 = 0x07C0
  mov ax, 0x07C0	; the ax is a 16bit memory address (adrs*16+offset). this is the bootloader's address + it's length (512 bytes)
  add ax, 288
  cli				; Disable interrupts while changing stack
  mov ss, ax  ; move stack segment to ax address.
  mov sp, 4096  ; stack pointer is offset, this is size of stack (4096 bytes).
  sti				; Restore interrupts

  ; Set data segment to where it's loaded
  mov ax, 0x07C0  ; ax = bootlaoder location 16bit memory address (loc/16).
	mov ds, ax ; set ds to location.

  ; mov si, DEBUG_MSG
  ; call print_string
  ; jmp $

  .read_disk:
  ; read the disk
  mov ah, 02h ; function: read sectors from drive
  mov al, 0x1 ; sectors to read
  mov ch, 0x0 ; tracks
  mov cl, 0x2 ; sector number
  mov dh, 0x0 ; head
  mov dl, 0x80 ; drive
  mov bx, 0x0880 ; address for ES. will calcuate to 0x7E00 with offset included.
  mov es, bx
  xor bx, bx  ; now set bx (offset) to 0.
  int 0x13
  ; if the disk doesn't load. then jump to printing an error.
  jc .error
  ; otherwise jump to the code.
  jmp 0x0880:0x0000

  .error:
    mov si, ERROR_MSG
    mov ah, 01h ; function: get status of last drive operation.
    mov dl, 0x0 ; drive
    int 0x13
    add [si], ah
    call print_string
    jmp $

ERROR_MSG db " # Error in booting.", 0
DEBUG_MSG db "This is a debug msg.", 0

%include "utils/print_string.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
