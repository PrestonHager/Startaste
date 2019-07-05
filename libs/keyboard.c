// keyboard.c
// by Preston Hager
// for Startaste OS

#include "keyboard.h"

void keyboard_update(Star *star) {
  // See if there's input from the keyboard.
  char status_byte = in(0x64);
  if (!(status_byte & 1)) {
    // if there isn't, then just return from the function.
    return;
  }
  // If there is, then get it.
  char key = in(0x60);
  // First, we must convert it to ASCII, to do this we use a predefined table.
  Element *element = keyboard_parse_key(key);
  // Debug statements....
  graphics_put_char(element->data[0], 0, 3);
  // graphics_put_char(element->data[1], 1, 3);
  // Doesn't work. Indexing the planets or calling the on_next function while passing in element.
  // Now put that character and whether it's a make or break into the keyboard_star.
  for (int i=0; i < star->total_planets; i++) {
    // Call the on_next function for each orbitting planet.
    // graphics_put_char(i+'0', 2, 3);
    // star->planets[i]->on_next(&element);
  }
}

Element* keyboard_parse_key(char key) {
  Element *element;
  // The keys 0x00 - 0x58 are make codes (key down).
  if (key < 0x59) {
    element->data[0] = 'M';
  } else {
    // Otherwise the key is 0x81 - 0xD3 and is a break code (key up).
    element->data[0] = 'B';
    // We can then subtract 0x80 from this key to get it's equivilant make code to make translation easier.
    key = key - 0x80;
  }
  // Finally, we can translate this make code into the equivilant ascii (or representation) of the key.
  char c = keyboard_lookup(key);
  // If the character is a backslash then we must also look at the special key map.
  if (c == '\\') {
    element->data[2] = keyboard_special_lookup(key);
  }
  // Finally we put the actual key (possibly a backslash designating a special key) into the data with a null-terminator.
  element->data[1] = c;
  element->data[3] = 0;
  return element;
}

bool keyboard_ack() {
  bool return_bool;
  char times;
  while (times < 255) {
    char ack = in(0x60);
    if (ack == 0xFA) {
      return_bool.v = 1;
      return return_bool;
    }
  }
  return return_bool;
}

char keyboard_lookup(char index) {
  // Where there is a backslash a special key is mapped to it. Use the `keyboard_special_map`.
  static const char keyboard_map[0x58] = {
    ' ', ' ', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', '0', '-', '=', '\\', '\\',
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I',
    'O', 'P', '[', ']', '\\', '\\', 'A', 'S',
    'D', 'F', 'G', 'H', 'J', 'K', 'L', ';',
    '\'', '`', '\\', '\\', 'Z', 'X', 'V', 'B',
    'N', 'M', ',', '.', '/', '\\', '\\', '\\',
    ' ', '\\', '\\', '\\', '\\', '\\', '\\', '\\',
    '\\', '\\', '\\', '\\', '\\', '\\', '\\', '\\',
    '\\', '\\', '\\', '\\', '\\', '\\', '\\', '\\',
    '\\', '\\', '\\', '\\', '\\', '\\', '\\', '\\'
  };
  index = keyboard_map[index];
  return index;
}

char keyboard_special_lookup(char index) {
  static const char keyboard_special_map[0x58] = {
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', 'B', 'T', // B = Backspace, T = Tab
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', 'E', 'C', ' ', ' ', // E = Enter, ZXC = Left Shift-Alt-Ctrl
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', 'Z', '\\', ' ', ' ', ' ', ' ', // = Backslash.
    ' ', ' ', ' ', ' ', ' ', 'M', '*', 'X', // MNB = Right Shift-Alt-Ctrl, * = Numpad *
    ' ', 'A', 'Q', 'W', 'E', 'R', 'T', 'Y', // A = Caps Lock, QWERTYUIOP[] = F1, F2, F3...
    'U', 'I', 'O', 'P', 'K', 'S', '7', '8', // K = Num Lock, S = Scroll Lock, 0-9 = Numpad 0-9
    '9', '-', '4', '5', '6', '+', '1', '2', // - = Numpad -, + = Numpad +
    '3', '0', '.', 'F', ' ', ' ', '[', ']' // . = Numpad .
  };
  index = keyboard_special_map[index];
  return index;
}
