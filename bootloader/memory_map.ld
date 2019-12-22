/* memory_map.ld
   by Preston Hager */

MEMORY
{
  bootloader  (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00000400
  kernel      (rx)  : ORIGIN = 0x00000400, LENGTH = 0x00800000
  memory      (rwx) : ORIGIN = 0x00800400, LENGTH = 0x00700B00
}

__bootloader_start__ = ORIGIN(bootloader);
__bootloader_size__ = LENGTH(bootloader);
__kernel_start__ = ORIGIN(kernel);
__kernel_size__ = LENGTH(kernel);
