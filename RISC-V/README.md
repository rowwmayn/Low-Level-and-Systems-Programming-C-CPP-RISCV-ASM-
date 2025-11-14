# RISC-V Assembly Code Breakdown

## Code Structure

```asm
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
```

## Instructions

- **`.global _start`** - Makes `_start` visible to linker (program entry point where execution begins)
- **`li`** (load immediate) - Loads a constant value directly into register
- **`la`** (load address) - Loads memory address into register
- **`ecall`** - Environment call (asks OS to perform an operation via syscall)

## Registers

- **a0-a6** - Argument registers (pass parameters to syscalls/functions)
- **a7** - Syscall number register (tells OS which operation to perform)

## First Syscall (Write)

| Register | Value | Purpose |
|----------|-------|---------|
| a0 | 1 | File descriptor (1 = stdout, standard output stream to terminal) |
| a1 | message address | Pointer to string (memory location where text is stored) |
| a2 | 14 | Number of bytes to write (length of "Hello RISC-V!\n") |
| a7 | 64 | Syscall number (64 = write operation) |

## Second Syscall (Exit)

| Register | Value | Purpose |
|----------|-------|---------|
| a0 | 0 | Exit code |
| a7 | 93 | Syscall number (exit) |

## Data Section

- **`.section .rodata`** - Read-only data section (data that can't be modified during execution)
- **`.string`** - Null-terminated string directive (adds \0 byte at end automatically)
- **Syscall** - System call (request to OS kernel to perform privileged operations like I/O)