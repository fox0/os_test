ISODIR=./isodir/boot/

all: run

run: build.iso
	qemu-system-i386 -cdrom build.iso

build.iso: kernel.bin grub.cfg
	mkdir -p $(ISODIR)grub
	cp grub.cfg $(ISODIR)grub/
	cp kernel.bin $(ISODIR)
	grub-mkrescue -o build.iso isodir

kernel.bin: boot.o kernel.o linker.ld
	ld -n -T linker.ld -o kernel.bin boot.o kernel.o

boot.o: boot.asm
	nasm -felf64 boot.asm -o boot.o

kernel.o: kernel.rs
	rustc --emit obj -C panic=abort kernel.rs -o kernel.o

clean:
	rm -rf *.iso *.o *.bin isodir
