; bootloader for Startaste OS.
[BITS 16]
[ORG 0x7C00]

; the kernel size may need to be ajusted to fit the size of whatever comes after.
%define KERNEL_SIZE 3
%define KERNEL_OFFSET 0x200

bootloader:
  ; first load the kernel into memory, then enter protected mode, and jump to the kernel.

  mov bp, 0x9000  ; update the base and stack pointers.
  mov sp, bp

  .read_disk:
    ; read the disk
    mov bx, KERNEL_OFFSET   ; set the offset.
    mov ax, 0x07C0
    mov ds, ax
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
    ; otherwise go to loading the gdt
    jmp load_gdt

  .error:
    mov si, ERROR_MSG
    mov ah, 01h ; function: get status of last drive operation.
    mov dl, 0x0 ; drive
    int 0x13
    add [si], ah
    call print_string
    jmp $

  ; now load the gdt, and jump to the kernel.
load_gdt:
  cli                     ; disable interrupts.
  xor ax, ax
  mov ds, ax              ; set data segment to 0 (used by lgdt)

  lgdt [gdt_descriptor]   ; load the GDT descriptor

  mov eax, cr0            ; copy the contents of cr0 into eax
  or eax, 1               ; set bit 0 to 1
  mov cr0, eax            ; copy the contents of eax back into cr0

  jmp 08h:protected_mode  ; jump to code segment, offset protected_mode

[BITS 32]                       ; We now need 32-bit instructions
protected_mode:
  mov ax, 10h             ; Save data segment identifyer
  mov ds, ax              ; Move a valid data segment into the data segment register
  mov ss, ax              ; Move a valid data segment into the stack segment register
  mov esp, 90000h         ; Move the stack pointer to 90000h

  call enable_A20

  jmp 08h:kernel_start_offset

ERROR_MSG db "Error in booting.", 0
BOOT_DRIVE db 0

%include "utils/gdt.asm"
%include "utils/print_string.asm"
%include "utils/A20.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55

kernel_start_offset:  ; all the kernel code is automaticly loaded after this.
