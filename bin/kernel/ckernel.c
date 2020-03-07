// ckernel.c
// by Preston Hager
// for Startaste OS

#include "libs/structs.h"
#include "libs/ckernel.h"
#include "libs/stars.c"
#include "libs/planets.c"

// The list of registered stars, the number is the maximum number of stars that can be registered at once.
Star *KERNEL_STARS[64];
// A useful number to index the last free index of stars and to inquire about how full the registery is.
unsigned char TOTAL_STARS;

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
  star_planet_start();
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
  unsigned char *video_mem = (unsigned char*) 0xb8000;
  video_mem[0] = 'A';
}

void star_planet_start() {

}
