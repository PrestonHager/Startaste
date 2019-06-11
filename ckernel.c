// ckernel.c
// by Preston Hager
// for Startaste OS

#include "libs/graphics.c"

void kernel_start() {
  // Initialize the graphics.
  // First, print the navigation_message and clear the screen.
  char navigation_message[80] = "Nebula > Formation";
  graphics_clear(0x38, 0x90);
  graphics_update_navigation(navigation_message);
  // And then, put the command line character down, and move the cursor.
  graphics_put_char('>', 0, 1);
  graphics_move_cursor(1, 1);
}
