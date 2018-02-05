# The Assembler (default=nasm):
ASSEMBLER=nasm
# The Emulator (default=qemu-system-i386):
EMULATOR=qemu-system-i386
# Default file name in case it isn't passed in:
# file=bootloader.asm
file=16bit.asm

run: os.img
	$(EMULATOR) -drive format=raw,file=os.img

all: os.img

os.img:
	$(ASSEMBLER) -f bin -o os.img $(file)

clean:
	rm os.tmp.bin
	rm os.img
