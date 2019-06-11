// ckernel.c
// by Preston Hager
// for Startaste OS

#include "libs/graphics.c"
#include "libs/keyboard.c"

void kernel_start() {
  // Initialize the graphics.
  char navigation_message[80] = "Nebula > Formation";
  graphics_clear(0x38, 0x90);
  graphics_update_navigation(navigation_message);
  graphics_put_char('>', 0, 1);
  graphics_move_cursor(1, 1);
  // Set up the obserbables for the devices.
  // Obserbable for keyboard:
  KeybaordObservable keyboard_observable;
  keyboard_observable_new(&keyboard_observable);
  Observer keyboard_observer;
  keyboard_observer_new(&keyboard_observer);
}
