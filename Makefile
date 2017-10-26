# The Assembler (default=nasm):
ASSEMBLER=nasm
# The Emulator (default=qemu-system-i386):
EMULATOR=qemu-system-i386
# Default file name in case it isn't passed in:
file=16bit.asm

run: os.img
	$(EMULATOR) os.img

all: os.img

os.img: os.tmp.bin
	dd status=noxfer conv=notrunc if=os.tmp.bin of=os.img

os.tmp.bin:
	$(ASSEMBLER) -f bin -o os.tmp.bin $(file)

clean:
	rm os.tmp.bin
	rm os.img
