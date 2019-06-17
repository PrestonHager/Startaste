// keyboard.c
// by Preston Hager
// for Startaste OS

#include "keyboard.h"

void keyboard_update(Star *self) {
  // TODO: finish keyboard update function.
  // See if there's input from the keyboard.
  char status_byte = in(0x64);
  if (!status_byte & 1) {
    // if there isn't, then just return from the function.
    return;
  }
  // If there is, then get it.
  char key = in(0x60);
  // First, we must convert it to ASCII, to do this we use a predefined table.
  Element *element = keyboard_parse_key(key);
  // Now put that character and whether it's a make or break into the keyboard_star.
  self->add_element(element, self);
  for (int i=0; i < self->total_planets; i++) {
    self->planets[i]->on_next(element);
  }
}

Element* keyboard_parse_key(char key) {
  Element *element;
  // The keys 0x00 - 0x58 are make codes (key down).
  if (key > 0x59) {
    element->data[0] = 'M';
  } else {
    // Otherwise the key is 0x81 - 0xD3 and is a break code (key up).
    element->data[0] = 'B';
    // We can then subtract 0x80 from this key to get it's equivilant make code to make translation easier.
    key = key - 0x80;
  }
  // Finally, we can translate this make code into the equivilant ascii (or representation) of the key.
  // TODO: add table translation.
  return element;
}

bool keyboard_ack() {
  bool return_bool;
  char times;
  while (times < 255) {
    char ack = in(0x60);
    if (ack == 0xFA) {
      return_bool.v = 1;
      return return_bool;
    }
  }
  return return_bool;
}
