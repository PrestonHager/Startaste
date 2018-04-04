; bootloader for Startaste OS. This boot's the kernel.

[org 0x7C00]
BITS 16

KERNEL_OFFSET equ 0x200
KERNEL_SIZE equ 0x2

mov [BOOT_DRIVE], dl  ; save the bootdrive number for later use.

bootloader:
  mov bp, 0x9000  ; update the base and stack pointers.
  mov sp, bp

  .read_disk:
  ; read the disk
  mov bx, KERNEL_OFFSET   ; set the offset.
  mov ax, 0x07C0
  mov es, ax
	mov dl, [BOOT_DRIVE]
  mov ah, 02h ; function: read sectors from drive
  mov al, KERNEL_SIZE ; sectors to read
  mov ch, 0x0 ; tracks
  mov cl, 0x2 ; sector number
  mov dh, 0x0 ; head
  mov dl, 0x80 ; drive
  int 0x13
  ; if the disk doesn't load. then jump to printing an error.
  jc .error
  cmp al, KERNEL_SIZE  ; compare to see if we read the expected amount of sectors.
  jne .error
  ; otherwise go to the kernel
  jmp 0x07C0:KERNEL_OFFSET

  .error:
    mov si, ERROR_MSG
    mov ah, 01h ; function: get status of last drive operation.
    mov dl, 0x0 ; drive
    int 0x13
    add [si], ah
    call print_string
    jmp $

ERROR_MSG db "Error in booting.", 0
BOOT_DRIVE db 0

%include "utils/print_string.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
