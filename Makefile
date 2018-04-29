# The Assembler (default=nasm):
ASSEMBLER=nasm
# The default catanation command, (cat for most linux systems, type for windows).
CAT_COMMAND=cat
# The default compiler, (gcc for linux systems. not installed on windows.)
# COMPILER=gcc
# The default linker, (ld for linux systems. not installed on windows.)
# LINKER=ld
# Default file name in case it isn't passed in:
bootloader=bootloader.asm
kernel=kernel.asm

ifeq ($(platform), win)
	CAT_COMMAND = type
endif

all: run clean

run: os.img
	@ echo "Running the emulator using compiled image."
	@ qemu-system-i386 -readconfig emulator_config.txt

os.img: os0.tmp os1.tmp
	@ echo "Catanating files to make image."
	@ $(CAT_COMMAND) os0.tmp os1.tmp > os.img

os0.tmp:
	@ echo "Assembling bootloader file."
	@ $(ASSEMBLER) -f bin -o os0.tmp $(bootloader)
os1.tmp:
	@ echo "Assembling kernel file."
	@ $(ASSEMBLER) -f bin -o os1.tmp $(kernel)

# os1.o:
# 	@ echo "Compiling kernel file."
# 	@ $(ASSEMBLER) -f elf -o boot.tmp $(bootloader)
# 	@ $(COMPILER) -m32 -ffreestanding -c $(kernel) -o kernel.o
# 	@ $(LINKER) -o boot.tmp -Ttext 0x8000 kernel.o --oformat binary

clean:
	@ echo "Cleaning up the temporary files."
	@ rm os0.tmp os1.tmp

clean-full:
	@ echo "Cleaning all files."
	@ rm os0.tmp os1.tmp os.img
