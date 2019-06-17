// stars.c
// by Preston Hager
// for Startaste OS

#include "stars.h"

Star* new_star(short id, void *update) {
  Star *star;
  star->id = id;
  star->update = update;
  star->orbit = &star_orbit;
  return star;
}

void star_orbit(Planet *planet, Star *self) {
  for (int i=0; i < 4; i++) {
    if (self->planets[i] == 0) {
      self->planets[i] = planet;
      return;
    }
  }
}
