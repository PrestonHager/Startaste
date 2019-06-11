// keyboard.c
// by Preston Hager
// for Aurora Compiler

#include "keyboard.h"

typedef enum {false, true} bool;

typedef struct {
  void (*on_next)();
  void (*on_error)();
  void (*on_complete)();
} Observer;

typedef struct {
  char* codes;
  bool active;
  void (*update);
} KeyboardObservable;

void keyboard_observer_new(Observer *ko) {
  ko->on_next = keyboard_on_next;
  ko->on_error = keyboard_on_error;
  ko->on_complete = keyboard_on_complete;
}

void keyboard_observable_new(KeybaordObservable *ko) {
  char[64] ko->codes;
  ko->active = false;
  ko->update = keyboard_observable_update;
}

void keyboard_observable_update() {

}

void keyboard_on_next(char code) {

}

void keyboard_on_error() {

}

void keyboard_on_complete() {

}
