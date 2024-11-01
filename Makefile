SRCDIR = src
OBJDIR = obj
BUILDDIR = build
INCDIR = inc

CXX = gcc
CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -m64 -nostdlib -T linker.ld

# Function to recursively find all source files
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2)$(filter $(subst *,%,$2),$d))

ASM_SRC = $(call rwildcard,$(SRCDIR),*.asm)
ASM_OBJS = $(patsubst $(SRCDIR)/%.asm, $(OBJDIR)/%.o, $(ASM_SRC))

CXX_SRC = $(call rwildcard,$(SRCDIR),*.c)
CXX_OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(CXX_SRC))

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	mkdir -p $(dir $@)
	@echo "Compiling $<"
	nasm -f elf64 $< -o $@ 

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(dir $@)
	$(CXX) $(CFLAGS) -c $< -o $@

boot: $(BUILDDIR)/boot.bin
$(BUILDDIR)/boot.bin: boot/boot.asm
	mkdir -p $(BUILDDIR)
	nasm -f bin boot/boot.asm -o $(BUILDDIR)/boot.bin -I$(INCDIR)/

kernel: $(ASM_OBJS) $(CXX_OBJS)
	mkdir -p $(BUILDDIR)
	$(CXX) $(LDFLAGS) $(ASM_OBJS) $(CXX_OBJS) -o $(BUILDDIR)/kernel.tmp
	objcopy -O binary $(BUILDDIR)/kernel.tmp $(BUILDDIR)/kernel.bin

all: boot kernel

clean:
	rm -rf $(OBJDIR) $(BUILDDIR)