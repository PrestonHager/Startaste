// terminal.c
// by Preston Hager
// for Startaste OS

#include "terminal.h"

void terminal_on_next(Element element) {
  // the element isn't a pointer because it must be a read-only element.
  graphics_put_char(element.data[0], 4, 0);
}

void terminal_on_error() {

}

void terminal_on_complete() {

}
