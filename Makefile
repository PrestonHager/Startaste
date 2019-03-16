# The Assembler (default=nasm):
ASM=nasm
# The default catanation command, (cat for most linux systems, type for windows).
CAT=cat
# The default compiler, (gcc for linux systems. not installed on windows.)
C=gcc
# The default linker, (ld for linux systems. not installed on windows.)
# LINKER=ld
# The default compiler's assembler (as for linux systems. not installed on windows.)
ASM_C=as
# Default file name in case it isn't passed in:
bootloader=bootloader
kernel=kernel
kernel_entry=kernel_entry
type=kernel
qemu_args=

ifeq ($(type), boot)
	files = $(bootloader).o
	c_files =
else ifeq ($(type), c_kernel)
	files = $(bootloader).o
	c_files = $(kernel).o
else ifeq ($(type), kernel_entry)
	files = $(bootloader).o
	c_files = $(kernel).o
else
	files = $(bootloader).o $(kernel).o
	c_files =
endif

ifeq ($(platform), win)
	CAT = type
endif

all: run clean

run: os.img
	@ echo "Running the emulator using compiled image."
	@ qemu-system-i386 -readconfig emulator_config.txt $(qemu_args)

os.img: $(files) $(c_files)
	@ echo "Catanating files to make image."
	@ $(CAT) $(files) $(c_files) > os.img

%.o: %.c
	@ echo "Compiling $<."
	@ $(C) -c -m32 -o $@ $<
	@ rm tmp.s

%.o: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f bin -o $@ $<

clean:
	@ echo "Cleaning up the temporary files."
	@ rm *.o

clean-full:
	@ echo "Cleaning all files."
	@ rm os.img *.o
