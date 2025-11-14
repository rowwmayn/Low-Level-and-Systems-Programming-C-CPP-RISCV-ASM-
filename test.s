.global _start
_start:
    li a0, 1          # stdout
    la a1, message    # address of string
    li a2, 14         # length
    li a7, 64         # write syscall
    ecall
    
    li a0, 0          # exit code
    li a7, 93         # exit syscall
    ecall

.section .rodata
message:
    .string "Hello RISC-V!\n"
