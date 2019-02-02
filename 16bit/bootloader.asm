; bootloader for Startaste OS. This boot's the kernel.
[org 0x7C00]
BITS 16

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
KERNEL_OFFSET equ 0x200
KERNEL_SIZE equ 0x3

%include "16bit/utils/print_string.asm"

; Simple File System Implementation
times 404-($-$$) db 0   ; set all bytes past the bootloader up to offset 0x019C to 0
sfs_sb:
  dq 0                          ; last alteration time of super-block values
  db 0h,0h,0h,0h,0h,0h,0h,40h   ; size of data area in blocks
  db 0h,0h,0h,0h,0h,0h,0h,20h    ; size of index area in bytes
  db 53h,46h                    ; magic number ('SFS')
  db 53h
  db 10h                        ; version number (1.0)
  db 0h,0h,0h,0h,0h,0h,0h,70h    ; total number of blocks in volume. (size of reserve area + data area + free space + index area)
  db 0h,0h,0h,10h               ; size of reserve area, including super-block in blocks (this will be the size of the bootloader+kernel)
  db 00h                        ; size of blocks such that `bytes = 2^(size+7)`
  ; here the block size will 2^(0+7) = 128 bytes
  db 0xED                       ; checksum: sum of all bytes between magic number and here equals a number which has the lower 8 bits at 0
  ; for example: 0x53 46 53 10 00 00 00 70 00 10 00 `ED` = 0x2 00 where the lower 8 bits (a byte) are 0x00.

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
