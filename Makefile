# The Assembler (default=nasm):
ASSEMBLER=nasm
# The Emulator (default=qemu-system-i386):
EMULATOR=qemu-system-i386
# Default file name in case it isn't passed in:
file=bootloader.asm
kernel=kernel.asm

run:
	$(ASSEMBLER) -f bin -o os0.tmp $(file)
	$(ASSEMBLER) -f bin -o os1.tmp $(kernel)
	copy /b os0.tmp+os1.tmp os.img
	$(EMULATOR) -drive format=raw,file=os.img
