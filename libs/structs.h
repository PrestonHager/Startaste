// structs.h
// by Preston Hager
// for Startaste OS

/** Bool Structure
 * Holds one bit that is either 1 or 0, true or false.
 */
typedef struct bool_t {
  char v:1;
} bool;

/** Element Data Structure.
 * Holds 16 bytes of data in a special format.
 */
typedef struct element_t {
  char data[16];
} Element;

/** Planet (or Observer) Structure
 * Holds information about the planet and the pointers to its functions.
 * - short id A unique (to all planets on one star) two byte numerical id.
 * - void *on_next Called when the parent star emmits an element.
 * - void *on_error Called when the parent star errors out and cannot continue.
 * - void *on_complete Called when the parent star terminates or ends.
 */
typedef struct planet_t {
  short id;
  void (*on_next)();
  void (*on_error)();
  void (*on_complete)();
} Planet;

/** Star (or Observable) Structure
 * Holds information about the Star and a few pointers to functions.
 * - short id A unique (to all stars) two byte numerical id.
 * - Element elements[128] An array of up to the last 128 elements emmited.
 * - Planet *planets[4] An array of pointers to up to 4 orbitting planets.
 * - char element_index The index of the last element emmited (often 127).
 * - void *update Pointer to update function of the observable.
 * - void *orbit Pointer to the orbit (subscribe) function to make a planet (Observer) orbit this star.
 */
typedef struct star_t {
  short id;
  Element *elements[128];
  char element_index;
  // TODO: make planets dynamicaly allocate instead of having a limit.
  Planet *planets[4];
  char total_planets;
  void (*update)();
  void (*orbit)();
  void (*add_element)();
} Star;
