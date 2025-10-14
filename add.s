# add.s - Simple addition program
# Adds two numbers and exits with the result

.global _start

.text
_start:
    # Load two numbers into registers
    li a0, 42          # Load immediate value 42 into a0
    li a1, 58          # Load immediate value 58 into a1
    
    # Add them together
    add a2, a0, a1     # a2 = a0 + a1 (result: 100)
    
    # Exit with the result as exit code
    li a7, 93          # syscall number for exit (93)
    mv a0, a2          # move result to a0 (exit code)
    ecall              # make system call