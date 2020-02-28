# Default platform, change this to `win` for switching to some windows variables
platform=linux
# Default type of compilation, this affects the files we request later.
type=kernel

# Defining tools and commands.
# The Assembler (default=nasm):
ASM=nasm
# The default catanation command, (cat for most linux based systems, not installed for windows).
CAT=cat

# the `type` variable can be changed to create either a bootloader only, c compiled, or assembly kernel.
ifeq ($(type), boot)
	# The default tool chain prefix used in the tools.
	TOOL=
	bootloader=bootloader_i386
	files = $(bootloader).bin
	SYSTEM=i386
else ifeq ($(type), c)
	TOOL=arm-eabi
	bootloader=bootloader/bootloader
	kernel=kernel/ckernel
	files = $(bootloader).bin $(bootloader)_magic.binary $(kernel).bin
	SYSTEM=arm
else
	TOOL=
	bootloader=bootloader_i386
	kernel=kernel_i386
	files = $(bootloader).bin $(kernel).bin
	SYSTEM=i386
endif

ifeq ($(TOOL), )
	# The default compiler, (gcc for linux systems. not installed on windows.)
	# The default linker, (ld for linux systems. not installed on windows.)
	C=gcc
	LINKER=ld
	# The default object-copy, (objcopy for linux systems. not installed on windows.)
	OBJCOPY=objcopy
else
	# if there is a tool chain, add it to the begining of each compiler, linker and object-copy.
	C=$(TOOL)-gcc
	LINKER=$(TOOL)-ld
	OBJCOPY=$(TOOL)-objcopy
endif

# if the platform is windows, change a few of the variables to work.
ifeq ($(platform), win)
	kernel_entry=kernel_entry_win
	CAT=type
endif

# requirements for each type of make command.
# avaliable commands are:
# all - makes everything, runs the `os.img`, and cleans up
# run - makes `os.img` and runs it.
# clean - cleans all .o, .bin, .tmp files.

all: run clean

run: os.img
	@ echo "Running the emulator using compiled image."
	@ qemu-system-$(SYSTEM) -readconfig emulator_config.txt $(qemu_args)

os.img: $(files)
	@ echo "Catanating files to make OS image."
	@ $(CAT) $(files) > os.img

%.bin: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f bin -o $@ $<

$(bootloader).bin: $(bootloader).o
	@ echo "Copying binary from $<."
	@ $(OBJCOPY) -O binary --pad-to=0x1FE --gap-fill=0x00 $< $@.tmp
	@ $(CAT) $@.tmp bootloader/bootloader_magic.binary > $@

%.bin: %.o
	@ echo "Copying binary from $<."
	@ $(OBJCOPY) -O binary $< $@

%.o: %.c
	@ echo "Compiling $<."
	@ $(C) -O0 -std=c99 -fno-pie -ffreestanding -c $< -o $@

%.o: %.asm
	@ echo "Assembling $<."
	@ $(ASM) -f elf32 -o $@ $<

clean:
	@ echo "Cleaning up the temporary files."
	@ rm -f *.bin *.o
	@ rm -f */*.bin */*.o
