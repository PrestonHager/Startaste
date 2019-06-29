// planets.c
// by Preston Hager
// for Startaste OS

#include "planets.h"

Planet* new_planet(short id, void *on_next, void *on_error, void *on_complete) {
  Planet *planet;
  planet->id = id;
  // Not sure if these do anything, it doesn't seem to actually set them.
  planet->on_next = on_next;
  planet->on_error = on_error;
  planet->on_complete = on_complete;
  return planet;
}
