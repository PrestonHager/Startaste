// keyboard.h
// by Preston Hager
// for Startaste OS

extern void keyboard_update(Star *self);
extern Element* keyboard_parse_key(char key);
extern bool keyboard_ack();
extern char keyboard_lookup(char index);
extern char keyboard_special_lookup(char index);
