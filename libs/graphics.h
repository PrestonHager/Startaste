// graphics.h
// by Preston Hager
// for Startaste OS

extern void graphics_clear(unsigned char top_color, unsigned char main_color);
extern void graphics_update_navigation(unsigned char msg[]);
extern void graphics_print(unsigned char msg[], unsigned char x, unsigned char y);
extern void graphics_put_char(unsigned char c, unsigned char x, unsigned char y);
extern void graphics_move_cursor(unsigned char x, unsigned char y);
