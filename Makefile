# The Assembler (default=nasm):
ASM=nasm
# The default catanation command, (cat for most linux systems, type for windows).
CAT=cat
# The default compiler, (gcc for linux systems. not installed on windows.)
# COMPILER=gcc
# The default linker, (ld for linux systems. not installed on windows.)
# LINKER=ld
# Default file name in case it isn't passed in:
bootloader=bootloader
kernel=kernel
filesystem=file_system_data
type=kernel
qemu_args=

ifeq ($(type), boot)
	files = $(bootloader).o
else ifeq ($(type), fs)
	files = $(bootloader).o $(kernel).o $(filesystem).o
else ifeq ($(type), filesystem)
	files = $(bootloader).o $(kernel).o $(filesystem).o
else
	files = $(bootloader).o $(kernel).o
endif

ifeq ($(platform), win)
	CAT = type
endif

all: run clean

run: os.img
	@ echo "Running the emulator using compiled image."
	@ qemu-system-i386 -readconfig emulator_config.txt $(qemu_args)

os.img: $(files)
	@ echo "Catanating files to make image."
	@ $(CAT) $(files) > os.img

%.o: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f bin -o $@ $<

clean:
	@ echo "Cleaning up the temporary files."
	@ rm *.o

clean-full:
	@ echo "Cleaning all files."
	@ rm *.o os.img
