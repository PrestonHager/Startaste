# The Assembler (default=nasm):
ASM=nasm
# The default catanation command, (cat for most linux systems, type for windows).
CAT=cat
# The default compiler, (gcc for linux systems. not installed on windows.)
C=gcc
# The default linker, (ld for linux systems. not installed on windows.)
LINKER=ld
# The default object-copy, (objcopy for linux systems. not installed on windows.)
OBJCOPY=objcopy
# Default file name in case it isn't passed in:
bootloader=bootloader
kernel=kernel
type=kernel
libraries=graphics.o
qemu_args=

ifeq ($(type), boot)
	files = $(bootloader).bin
else ifeq ($(type), aurora)
	files = $(bootloader).bin $(kernel).bin
else ifeq ($(type), c)
	files = $(bootloader).bin $(kernel).bin
else
	files = $(bootloader).bin $(kernel).bin
endif

ifeq ($(platform), win)
	CAT = type
endif

all: run clean

run: os.img
	@ echo "Running the emulator using compiled image."
	@ qemu-system-i386 -readconfig emulator_config.txt $(qemu_args)

os.img: $(files)
	@ echo "Catanating files to make OS image."
	@ $(CAT) $(files) > os.img

%.bin: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f bin -o $@ $<

%.bin: %.c kernel_entry.o $(libraries)
	@ echo "Compiling $<."
	@ $(C) -ffreestanding -m32 -c $< -o file.o
	@ echo "Linking and turing in to bytecode."
	@ $(LINKER) -o file.tmp -Ttext 0x7E00 -m i386pe kernel_entry.o file.o
	@ $(OBJCOPY) -O binary -j .text file.tmp $@

%.o: %.c
	@ echo "Compiling $<."
	@ $(C) -ffreestanding -m32 -c $< -o $@

%.o: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f elf32 -o $@ $<

%.bin: %.aurora
	@ echo "Compiling Aurora file $<."
	@ aurora $< -o $@ -fs

clean:
	@ echo "Cleaning up the temporary files."
	@ rm -f *.bin *.o *.tmp
