LDS = linker.ld
CC = x86_64-elf-gcc

CFLAGS = -ffreestanding -nostdlib -mno-red-zone
LDFLAGS = -T $(LDS) -ffreestanding -nostdlib

SRCDIR := src
OBJDIR := lib
BUILDDIR = bin
INCDIR := inc

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

ASM_SRC = $(call rwildcard,$(SRCDIR),*.asm)          
ASM_OBJS = $(patsubst $(SRCDIR)/%.asm, $(OBJDIR)/%.asm.o, $(ASM_SRC))

C_SRC = $(call rwildcard,$(SRCDIR),*.c)         
C_OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(C_SRC))
DIRS = $(wildcard $(SRCDIR)/*)

$(OBJDIR)/%.asm.o: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	@echo "Compiling $<"
	nasm -f elf64 $< -o $@ -I$(INCDIR)/

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

boot: $(BUILDDIR)/boot.bin
$(BUILDDIR)/boot.bin: boot/boot.asm
	mkdir -p $(BUILDDIR)
	nasm -f bin boot/boot.asm -o $(BUILDDIR)/boot.bin -I$(INCDIR)/

kernel: $(ASM_OBJS) $(C_OBJS)
	mkdir -p $(BUILDDIR)
	$(CC) $(LDFLAGS) $(ASM_OBJS) $(C_OBJS) -o $(BUILDDIR)/kernel.bin





buildimg: boot kernel
	cat $(BUILDDIR)/boot.bin $(BUILDDIR)/kernel.bin > megos.img

run: buildimg
	qemu-system-x86_64 -drive file=megos.img -m 256M -cpu qemu64 -net none

clean:
	rm -rf $(BUILDDIR) $(OBJDIR) megos.img

