; global descriptor table for Startaste OS, protected mode.
gdt:
.start:

; offset = 0x0
.null:  ; null descriptor
  dq 0            ; defines 8 bytes of 0

; offset = 0x8
.code:  ; code segment descriptor
  ; base=0x0, limit=0xfffff
  ; access byte: present=1b, privilage=00b (kernel), 1b, executable=1b (code sector), direction=0b (N/A), read-write=0b (non-readable code), accessed=0b
  ; flags: granularity=1b (size in kilobyte blocks), size=1b (32 bit protected mode), 00b
  dw 0xffff     ; limit (bits 0-15)
  dw 0x0        ; base (bits 0-15)
  db 0x0        ; base (bits 16-23)
  db 10011000b  ; access byte
  db 11001111b  ; flags + limit (bits 16-19)
  db 0x0        ; base (bits 24-31)

; offset = 0xf0
.data: ; data degment descriptor
  ; base=0x0, limit=0xfffff
  ; access byte: present=1b, privilage=00b (kernel), 1b, executable=0b (data sector), direction=0b (grows down), read-write=1b (writable data), accessed=0b
  ; flags: granularity=1b (size in kilobyte blocks), size=1b (32 bit protected mode), 00b
  dw 0xffff     ; limit (bits 0-15)
  dw 0x0        ; base (bits 0-15)
  db 0x0        ; base (bits 16-23)
  db 10010010b  ; access byte
  db 11001111b  ; flags + liimit (bits 16-19)
  db 0x0        ; base (bits 24-31)

.end: ; to make calculations easier with an assembler.

gdt_descriptor:
  dw gdt.end - gdt - 1  ; size of gdt (minus 1 bc the max size is one more than the max value in the register)
  dd gdt                ; start of the gdt

; Also define constants for the kernel so we know where the code and data segments are.
CODE_SEG equ gdt.code - gdt
DATA_SEG equ gdt.data - gdt
