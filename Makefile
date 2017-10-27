# The Assembler (default=nasm):
ASSEMBLER=nasm
# The Emulator (default=qemu-system-i386):
EMULATOR=qemu-system-i386
# Default file name in case it isn't passed in:
<<<<<<< HEAD
file=bootloader.asm
=======
file=16bit.asm
>>>>>>> 2d5d50d5ef84923719480d0893dac9736ce209cb

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
