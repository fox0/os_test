## CONFIG: Architecture to build for
ARCH=amd64

RUSTC=rustc
LD=ld
AS=as

LINKFLAGS=-T arch/$(ARCH)/link.ld -Map map.txt --gc-sections -z max-page-size=0x1000
RUSTFLAGS=-O --cfg arch__$(ARCH) --target=arch/$(ARCH)/target.json -C soft-float -C panic=abort

.PHONY: all run clean

all: kernel.$(ARCH).bin

run: kernel.$(ARCH).bin kernel.$(ARCH).bin
ifeq ($(ARCH),amd64)
	qemu-system-x86_64 -serial stdio -kernel $<
endif

kernel.$(ARCH).bin: start.o kernel.o libcore.rlib libcompiler_builtins.rlib
	$(LD) -o $@ $(LINKFLAGS) start.o kernel.o libcore.rlib libcompiler_builtins.rlib
ifeq ($(ARCH),amd64)
	mv $@ $@.elf64
	objcopy $@.elf64 -F elf32-i386 $@
endif

start.o: arch/$(ARCH)/start.S
	$(AS) -o $@ $<

kernel.o: main.rs libcompiler_builtins.rlib
	$(RUSTC) $(RUSTFLAGS) --emit=obj,dep-info $< -L .

libcompiler_builtins.rlib: libcompiler_builtins/src/lib.rs libcore.rlib
	$(RUSTC) $(RUSTFLAGS) --cfg feature=\"compiler-builtins\" --emit=link,dep-info -L . $< --cfg stage0

libcore.rlib: libcore/lib.rs
	$(RUSTC) $(RUSTFLAGS) --crate-type=lib --crate-name=core --emit=link,dep-info $<

libcore/lib.rs: rustc-nightly-src.tar.gz
	tar -xmf $< rustc-nightly-src/src/libcore rustc-nightly-src/src/stdsimd --transform 's~^rustc-nightly-src/src/~~'

libcompiler_builtins/src/lib.rs: rustc-nightly-src.tar.gz
	tar -xmf $< rustc-nightly-src/vendor/compiler_builtins --transform 's~^rustc-nightly-src/vendor/~lib~'

rustc-nightly-src.tar.gz:
	curl https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz -o $@

clean:
	rm -rf *.o *.d *.rlib *.bin *.elf64 libcore stdsimd libcompiler_builtins map.txt
