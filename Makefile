# The Assembler (default=nasm):
ASSEMBLER=nasm
# The Emulator (default=qemu-system-i386):
EMULATOR=qemu-system-i386
# The "remover" on windows it's "del" on unix it's "rm"
REMOVER=del
# Default file name in case it isn't passed in:
file=bootloader.asm
kernel=kernel.asm
#file=16bit.asm

run: all
	$(EMULATOR) -drive format=raw,file=os.img

all: clean

clean: os.img
	$(REMOVER) *.tmp

os.img:
	$(ASSEMBLER) -f bin -o os0.tmp $(file)
	$(ASSEMBLER) -f bin -o os1.tmp $(kernel)
	copy /b os0.tmp+os1.tmp os.img

erase:
	$(REMOVER) *.tmp
	$(REMOVER) os.img
