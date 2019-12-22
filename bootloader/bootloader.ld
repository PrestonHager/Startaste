/* bootloader.ld
   by Preston Hager */

INCLUDE bootloader/memory_map.ld

/* Section Definitions */
SECTIONS
{
    .text :
    {
        KEEP(*(.vectors .vectors.*))
        *(.text*)
        *(.rodata*)
        _etext = .;
    } > bootloader
}
