; Graphics routines for Protected Mode

; ============================================ ;
; Put Pixel Routine
; Arguments: bl: Row, dl: Column, cl: Pixel color
; Outputs: None (changes display)
; ============================================ ;
graphics_put_pixel:
  pusha

  .done:
  popa
  ret
