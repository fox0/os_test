global kernel_main

section .text
bits 32
kernel_main:
    ; print `OK` to screen
    mov dword [0xb8000], 0x2f4b2f4f
    hlt
