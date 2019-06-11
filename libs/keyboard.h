// keyboard.h
// by Preston Hager
// for Aurora Compiler

extern void keyboard_observer_new(KeyboardObserver *ko);
extern void keyboard_observable_new(KeybaordObservable *ko);
extern void keyboard_observable_update();

extern void keyboard_on_next(char code);
extern void keyboard_on_error();
extern void keyboard_on_complete();
