ENTRY(_start)

SECTIONS {
    . = 1M;

    .multiboot :
    {
        boot.o(.multiboot)
    }

    .bss :
    {
        boot.o(.bss)
    }

    .text :
    {
        boot.o(.text)
        kernel.o(.text)
    }
}
