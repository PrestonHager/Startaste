// stars.c
// by Preston Hager
// for Startaste OS

#include "stars.h"

Star* new_star(short id, void *update) {
  Star *star;
  star->id = id;
  star->total_planets = 0;
  star->update = update;
  return star;
}

void star_orbit(Planet *planet, Star *star) {
  if (star->total_planets < 4) {
    star->planets[star->total_planets] = planet;
    star->total_planets += 1;
  }
}
