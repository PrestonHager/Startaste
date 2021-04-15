/* memory_map.ld
   by Preston Hager */

MEMORY
{
  bootloader        (rx)  : ORIGIN = 0x00000000, LENGTH = 0x000001FE
  bootloader_magic  (rx)  : ORIGIN = 0x000001FE, LENGTH = 0x00000002
  kernel            (rx)  : ORIGIN = 0x00000200, LENGTH = 0x00800000
  memory            (rwx) : ORIGIN = 0x00800200, LENGTH = 0x00700D00
}

__bootloader_start__ = ORIGIN(bootloader);
__bootloader_size__ = LENGTH(bootloader);
__kernel_start__ = ORIGIN(kernel);
__kernel_size__ = LENGTH(kernel);
