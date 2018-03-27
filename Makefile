# The Assembler (default=nasm):
ASSEMBLER=nasm
# The default catanation command, (cat for most linux systems, type for windows).
CAT_COMMAND=cat
# Default file name in case it isn't passed in:
file=bootloader.asm
kernel=kernel.asm

ifeq ($(platform), win)
	CAT_COMMAND = type
endif

all: run clean

run: os.img
	qemu-system-i386 -drive format=raw,file=os.img

os.img: os0.tmp os1.tmp
	$(CAT_COMMAND) os0.tmp os1.tmp > os.img

os0.tmp:
	$(ASSEMBLER) -f bin -o os0.tmp $(file)

os1.tmp:
	$(ASSEMBLER) -f bin -o os1.tmp $(kernel)

clean:
	rm os0.tmp os1.tmp
