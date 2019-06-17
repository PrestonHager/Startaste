// stars.c
// by Preston Hager
// for Startaste OS

#include "stars.h"

Star* new_star(short id, void *update) {
  Star *star;
  star->id = id;
  star->element_index = 0;
  star->total_planets = 0;
  star->update = update;
  star->orbit = &star_orbit;
  star->add_element = &star_add_element;
  return star;
}

void star_orbit(Planet *planet, Star *self) {
  if (self->total_planets < 4) {
    self->total_planets += 1;
    self->planets[self->total_planets] = planet;
  }
}

void star_add_element(Element *element, Star *self) {
  // Test the index of the last element, if it's the absolute last item, we must shift everything over.
  if (self->element_index == 127) {
    // Shift the array to the left by 1.
    for (int i=0; i < 127; i++) {
      self->elements[i] = self->elements[i+1];
    }
  } else {
    // Otherwise we can increase the element index before we add the next element.
    self->element_index += 1;
  }
  // Now we add the Element to the elements of star `self`.
  self->elements[self->element_index] = element;
}
