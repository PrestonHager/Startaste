; bootloader for Startaste OS. This boot's the kernel.

[org 0x7C00]
BITS 16

bootloader:
  mov bp, 0x9000  ; update the base and stack pointers.
  mov sp, bp

  .protected_mode:
    ; enter into protected mode
    cli   ; clear interrupts
    lgdt [gdt_descriptor]   ; load global descriptor table.
    mov eax, cr0
    or al, 1      ; set bit in CR0 to 1 for protected mode.
    mov cr0, eax

    ; point at the new data segment
    mov ax, DATA_SEG

    jmp CODE_SEG:enter_protected_mode

BITS 32
enter_protected_mode:
  ; point at the new data segment
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000      ; update the stack position because we now have more bits!
  mov esp, ebp

  jmp 0x07C0:0x200

%include "utils/gdt.asm"

times 510-($-$$) db 0	; Padding for the rest of boot sector minus 2 special chars
dw 0xAA55
