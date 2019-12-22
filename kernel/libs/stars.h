// stars.h
// by Preston Hager
// for Startaste OS

extern Star* new_star(short id, void *update);
extern void star_orbit(Planet *planet, Star *self);
extern void star_add_element(Element *element, Star *self);
