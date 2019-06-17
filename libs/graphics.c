// graphics.c
// by Preston Hager
// for Startaste OS

#include "graphics.h"
#include "io.c"

#define VIDEO_MEMORY_ADDRESS 0xb8000
#define COLUMNS 80
#define ROWS 25

/* graphics_clear
 - clears the screen with two given colors. */
void graphics_clear(unsigned char top_color, unsigned char main_color) {
  unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY_ADDRESS;
  // first get the top row of characters
  for (unsigned int i = 0; i < COLUMNS; i++) {
    // set the character to a space with the color of `top_color`
    video_memory[i*2] = ' ';
    video_memory[i*2+1] = top_color;
  }
  // set the characters in the rest of the rows.
  for (unsigned int i = 1; i < ROWS; i++) {
    for (unsigned int j = 0; j < COLUMNS; j++) {
      // now a bit of math to find the location of each character and set the character similar to above.
      video_memory[(i*COLUMNS+j)*2] = ' ';
      video_memory[(i*COLUMNS+j)*2+1] = main_color;
    }
  }
}

/* graphics_update_navigation
 - updates the navigation message with the supplied message. */
void graphics_update_navigation(unsigned char msg[]) {
  unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY_ADDRESS;
  // first clear the row by overwriting the old message with spaces.
  for (unsigned int i = 0; i < COLUMNS; i++) {
    video_memory[i*2] = ' ';
  }
  // now, write the new message on that space.
  graphics_print(msg, 0, 0);
}

/* graphics_print
 - prints a string at a location (col, row). */
void graphics_print(unsigned char msg[], unsigned char x, unsigned char y) {
  // calculate the starting location in video memory given the x and y.
  unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY_ADDRESS + (ROWS*COLUMNS*y + COLUMNS*x)*2;
  // loop over the string until we reach the null-terminator.
  for (unsigned int i = 0; msg[i] != 0; i++) {
    // set the character at video_memory[i*2 + "what we calculated"] to msg[i].
    video_memory[i*2] = msg[i];
  }
}

/* graphics_put_char
 - puts a character at the location x, y on screen. */
void graphics_put_char(unsigned char c, unsigned char x, unsigned char y) {
  unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY_ADDRESS + (ROWS*COLUMNS*y + COLUMNS*x)*2;
  *video_memory = c;
}

/* graphics_move_cursor
 - moves the cursor to a specified location (col, row). */
void graphics_move_cursor(unsigned char x, unsigned char y) {
  // the cursor position is calculated.
  unsigned short cursor_position = (COLUMNS*y + x);
  // set the low byte.
  out(0x03D4, 0x0f);
  out(0x03D5, cursor_position & 0xFF);
  // and then the high byte.
  out(0x03D4, 0x0e);
  out(0x03D5, (cursor_position >> 8) & 0xFF);
}
