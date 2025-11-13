.section .text
.globl _start
_start:
    li x10, 1              # fd = stdout
    la x11, msg            # load msg address
    li x12, 13             # length of message
    li x17, 64             # syscall number for write
    ecall                  # make system call
    
    li x17, 93             # syscall number for exit
    li x10, 0              # exit code
    ecall                  # make system call

.section .data
msg:
    .ascii "Hello RISC-V\n"

