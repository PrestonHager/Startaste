// ckernel.c
// by Preston Hager
// for Startaste OS

#include "libs/graphics.c"

void kernel_start() {
  char navigation_message[80] = "Nebula > Formation";
  graphics_clear(0x38, 0x90);
  graphics_update_navigation(navigation_message);
  graphics_put_char('>', 0, 1);
  graphics_move_cursor(1, 1);
}
