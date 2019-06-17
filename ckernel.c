// ckernel.c
// by Preston Hager
// for Startaste OS

#include "libs/structs.h"
#include "libs/ckernel.h"
#include "libs/graphics.c"
#include "libs/stars.c"

// The list of registered stars, the number is the maximum number of stars that can be registered at once.
Star *KERNEL_STARS[64];
// A useful number to index the last free index of stars and to inquire about how full the registery is.
char TOTAL_STARS;

void kernel_star_register(Star *star) {
  // Store the star in the next spot in the registery
  KERNEL_STARS[TOTAL_STARS] = star;
  // And then increase that index and the total number of stars.
  TOTAL_STARS ++;
}

void kernel_start() {
  // Initialize the graphics.
  graphics_start();
  // Initialize the stars.
  // These are Observables from ReactiveX programming.
  // We call Observalbes Stars and the Subscribed Observers are called Orbitting Planets.
  star_start();
  while (1) {
    // Run through the updates of each star.
    // Note that the star must be registered with the kernel before it can be updated.
    for (int i=0; i < TOTAL_STARS; i++) {
      // Update the star at i until we reach the end of all the star in the KERNEL_STARS.
      KERNEL_STARS[i]->update();
    }
  }
}

void graphics_start() {
  // First, print the navigation_message and clear the screen.
  char navigation_message[80] = "Nebula > Formation";
  graphics_clear(0x38, 0x90);
  graphics_update_navigation(navigation_message);
  // And then, put the command line character down, and move the cursor.
  graphics_put_char('>', 1, 0);
  graphics_move_cursor(1, 1);
}

void keyboard_update(Star *self) {
  // TODO: finish keyboard update function.
  // See if there's input from the keyboard.
  // If there is, then get it.
  // Now put that character into the keyboard_star.
}

void star_start() {
  // One of the biggest stars is the keyboard input.
  Star *keyboard_star = new_star(0x0001, &keyboard_update);
  kernel_star_register(keyboard_star);
}
