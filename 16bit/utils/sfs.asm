; Simple File System Routines

; ============================================ ;
; Write File Routine
; Arguments: si: Location of Data, null terminated
; Ouputs: ax: result code (0x00 for success)
; ============================================ ;
sfs_write:
  pusha

  .done_0:
  popa
  mov ax, 0
  ret

; ============================================ ;
; Initialize Routine (must call to read the file system metadata)
; Arguments: none
; Ouputs: ax: result code (0x00 for success)
; ============================================ ;
sfs_init:
  pusha

  .get_data_area:
    mov ax, [0x7C00+0x019C+16]
    mov [DATA_AREA_SIZE], ax

  .done_0:
  popa
  mov ax, 0
  ret

BLOCK_SIZE db 0
DATA_AREA_SIZE dq 0
INDEX_AREA_SIZE dq 0
TOTAL_SIZE dq 0
OFFSET dd 0
