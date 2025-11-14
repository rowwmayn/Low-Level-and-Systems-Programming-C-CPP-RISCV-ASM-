.section .data
msg:
    .ascii "Result: "
len_msg = . - msg
result_char:
    .byte 0
newline:
    .byte 10

.section .text
.globl _start
_start:
    # Add two numbers
    li x1, 5           # x1 = 5
    li x2, 7           # x2 = 7
    add x3, x1, x2     # x3 = x1 + x2 = 12
    
    # Convert to ASCII (NOTE: only works for 0-9)
    addi x3, x3, 48    # Convert to ASCII character
    
    # Store result character in memory
    la x4, result_char
    sb x3, 0(x4)       # Store byte
    
    # Print "Result: "
    li x10, 1          # fd = stdout
    la x11, msg        # buffer = msg
    li x12, len_msg    # length
    li x17, 64         # syscall write
    ecall
    
    # Print the number
    li x10, 1          # fd = stdout
    la x11, result_char # buffer = result_char
    li x12, 1          # length = 1 character
    li x17, 64         # syscall write
    ecall
    
    # Print newline
    li x10, 1
    la x11, newline
    li x12, 1
    li x17, 64
    ecall
    
    # Exit
    li x17, 93         # syscall exit
    li x10, 0          # exit code
    ecall
