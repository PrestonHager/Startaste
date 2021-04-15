// keyboard.h
// by Preston Hager
// for Startaste OS

extern void keyboard_update(Star *self);
extern Element* keyboard_parse_key(unsigned char key);
extern bool keyboard_ack();
extern unsigned char keyboard_lookup(unsigned char index);
extern unsigned char keyboard_special_lookup(unsigned char index);
