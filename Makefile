SRCS := $(shell find kernel/ -name '*.c')
OBJS := $(SRCS:.c=.o)
CC = gcc
LD = ld

CFLAGS := \
    -Ikernel/src \
	-fpermissive \
    -ffreestanding \
    -fno-stack-protector \
    -fno-pic \
	-w \
    -O1 \
    -m32 \
    -g \

ASM_FLAGS := \
    -f elf32

LD_FLAGS := \
	-nostdlib \
	-Tkernel/link.ld \
	-m elf_i386 \
	-z max-page-size=0x1000

.SUFFIXE: .c
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: $(OBJS)
	nasm -f elf32 kernel/src/entry.asm -o entry.o
	nasm -f elf32 kernel/src/lunarForge/lunar.asm -o lunar.o
	$(LD) $(LD_FLAGS) $(OBJS) entry.o lunar.o -o $@

clean:
	rm -f $(OBJS)
	rm -f kernel.elf
	rm -f krnl.iso
	rm -f entry.o

krnl:
	rm -rf iso_root
	mkdir -p iso_root
	cp kernel.elf \
		limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso_root/
	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o krnl.iso
	limine/limine-deploy krnl.iso
	rm -rf iso_root

run:
	make krnl
	qemu-system-i386 -m 128M -serial stdio -cdrom ./krnl.iso
