// structs.h
// by Preston Hager
// for Startaste OS

/** Bool Structure
 * Holds one bit that is either 1 or 0, true or false.
 */
typedef struct bool_t {
  unsigned char v:1;
} bool;

/** Element Data Structure.
 * Holds 16 bytes of data in a special format.
 */
typedef struct element_t {
  unsigned char data[16];
} Element;

/** Planet (or Observer) Structure
 * Holds information about the planet and the pointers to its functions.
 * - short id A unique (to all planets on one star) two byte numerical id.
 * - void *on_next Called when the parent star emmits an element.
 * - void *on_error Called when the parent star errors out and cannot continue.
 * - void *on_complete Called when the parent star terminates or ends.
 */
typedef struct planet_t {
  unsigned short id;
  void (*on_next)();
  void (*on_error)();
  void (*on_complete)();
} Planet;

/** Star (or Observable) Structure
 * Holds information about the Star and a few pointers to functions.
 * - short id A unique (to all stars) two byte numerical id.
 * - Planet *planets[4] An array of pointers to up to 4 orbitting planets.
 * - char total_planets The number of total active planets orbitting this star.
 * - void *update Pointer to update function of the observable.
 */
typedef struct star_t {
  unsigned short id;
  // TODO: make planets dynamicaly allocate instead of having a limit.
  Planet *planets[4];
  unsigned char total_planets;
  void (*update)();
} Star;
