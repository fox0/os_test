ENTRY(_start)

SECTIONS {
    . = 1M;

    .multiboot :
    {
        *(.multiboot)
    }

    .bss :
    {
        *(.bss)
    }

    .text :
    {
        *(.text)
    }
}
