.section .text
.globl _start
_start:
    li a0, 1
    la a1, msg
    li a2, 13
    li a7, 64
    ecall

    li a7, 93
    li a0, 0
    ecall

.section .data
msg:
    .ascii "Hello RISC-V\n"
