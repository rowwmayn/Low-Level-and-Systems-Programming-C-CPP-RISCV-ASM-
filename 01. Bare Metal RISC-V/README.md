# 🔩 Bare-Metal RISC-V Programming: Deep Dive Guide

## 📋 Table of Contents
- [What is Bare-Metal Programming?](#what-is-bare-metal-programming)
- [Code Analysis: Register Addition Program](#code-analysis-register-addition-program)
- [Assembly Structure Breakdown](#assembly-structure-breakdown)
- [Register Usage in RISC-V](#register-usage-in-risc-v)
- [System Calls (ecall) Explained](#system-calls-ecall-explained)
- [Build Process Deep Dive](#build-process-deep-dive)
- [Why These Specific Commands?](#why-these-specific-commands)
- [Memory Layout Understanding](#memory-layout-understanding)
- [Debugging and Analysis](#debugging-and-analysis)
- [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)

## 🤔 What is Bare-Metal Programming?

**Bare-metal programming** means writing code that runs directly on the processor hardware without an operating system layer. Think of it as having a direct conversation with the CPU itself.

### 🏗️ The Software Stack Comparison

```
┌─────────────────────────┐    ┌─────────────────────────┐
│    Regular Programming  │    │   Bare-Metal Programming │
├─────────────────────────┤    ├─────────────────────────┤
│   Your C Program        │    │   Your Assembly/C Code   │
│   (printf, malloc, etc) │    │   (direct instructions)  │
├─────────────────────────┤    ├─────────────────────────┤
│   C Standard Library    │    │                         │
│   (glibc, stdio.h)      │    │        NOTHING!         │
├─────────────────────────┤    │                         │
│   Operating System      │    │                         │
│   (Linux kernel)        │    │                         │
├─────────────────────────┤    ├─────────────────────────┤
│   Hardware (CPU/RAM)    │    │   Hardware (CPU/RAM)    │
└─────────────────────────┘    └─────────────────────────┘
```

### 🎯 Why Write Bare-Metal Code?

1. **🧠 Understanding**: Learn how computers *really* work at the lowest level
2. **🚀 Performance**: No OS overhead - direct hardware control
3. **🔧 Embedded Systems**: Many microcontrollers don't run operating systems
4. **🎓 Education**: Essential for computer science and engineering students
5. **🛠️ System Programming**: Foundation for writing operating systems and drivers

## 🔍 Code Analysis: Register Addition Program

Let's dissect our RISC-V assembly program line by line:

```assembly
.section .data
msg:
    .ascii "Result: "
len_msg = . - msg
```

### 📊 Data Section Breakdown

- **`.section .data`**: Tells the assembler "everything after this goes in the data section"
  - Data section = where we store variables, strings, and constants
  - Gets loaded into RAM when program runs

- **`msg:`**: A **label** - like a variable name pointing to memory location
  - Labels are addresses in memory where data starts
  - Think of it as `char* msg` pointing to the string

- **`.ascii "Result: "`**: Directive to store the string bytes in memory
  - `.ascii` doesn't add null terminator (unlike `.asciiz`)
  - Each character becomes one byte: 'R'=82, 'e'=101, 's'=115, etc.

- **`len_msg = . - msg`**: Calculate string length at assembly time
  - `.` means "current memory location"
  - `msg` is the start address of our string
  - Subtraction gives us the length (8 bytes for "Result: ")
  - This is computed by the assembler, not at runtime!

### 🖥️ Text Section (Code) Breakdown

```assembly
.section .text
.globl _start
_start:
```

- **`.section .text`**: Code section - where executable instructions go
- **`.globl _start`**: Makes `_start` visible to the linker
  - Like `extern` in C - tells linker this symbol can be referenced from other files
  - **Why `_start` and not `main`?** In bare-metal, there's no C runtime to call `main()`
  - `_start` is the absolute entry point - where CPU jumps when program loads

### 🔢 Register Operations

```assembly
li x1, 5       # x1 = 5
li x2, 7       # x2 = 7
add x3, x1, x2
```

- **`li x1, 5`**: "Load Immediate" - put the number 5 directly into register x1
  - Registers are like super-fast variables built into the CPU
  - No memory access needed - fastest possible operation

- **`add x3, x1, x2`**: Add contents of x1 and x2, store result in x3
  - This is pure CPU computation
  - All happens in one clock cycle on RISC-V

### 🔤 ASCII Conversion

```assembly
addi x3, x3, 48
```

- **`addi x3, x3, 48`**: "Add Immediate" - add 48 to x3
- **Why 48?** ASCII character codes:
  - '0' = 48, '1' = 49, '2' = 50, ..., '9' = 57
  - Our result (5+7=12) becomes '12' but we only show first digit
  - 12 + 48 = 60 = ASCII '<' (this is why we need better number conversion for multi-digit numbers!)

## 🎛️ Register Usage in RISC-V

RISC-V has 32 general-purpose registers, but they have conventional uses:

| Register | ABI Name | Purpose | Usage in Our Code |
|----------|----------|---------|------------------|
| x0 | zero | Always 0 | Not used (read-only) |
| x1 | ra | Return address | Our first number (5) |
| x2 | sp | Stack pointer | Our second number (7) |
| x3 | gp | Global pointer | Our result storage |
| x10 | a0 | Function arg 0 / return value | System call arg 1 (fd) |
| x11 | a1 | Function arg 1 | System call arg 2 (buffer) |
| x12 | a2 | Function arg 2 | System call arg 3 (length) |
| x17 | a7 | Function arg 7 | System call number |

### 🤔 Why These Specific Registers?

- **x1, x2, x3**: We chose these arbitrarily for our computation
- **x10, x11, x12, x17**: Required by RISC-V Linux system call convention
  - Not our choice - this is how Linux kernel expects arguments!

## 📞 System Calls (ecall) Explained

System calls are the **only way** bare-metal programs can communicate with the outside world.

### 🔄 How System Calls Work

```
Your Program          Linux Kernel
     │                      │
     │  1. Setup registers   │
     │     x10 = fd         │
     │     x11 = buffer     │
     │     x12 = length     │
     │     x17 = syscall#   │
     │                      │
     │  2. ecall ───────────→│
     │                      │ 3. Kernel processes request
     │                      │    - Validates arguments
     │                      │    - Performs I/O operation
     │                      │    - Returns result
     │                      │
     │ ←────────────────────│ 4. Return to your program
```

### 📝 Write System Call Breakdown

```assembly
li x10, 1          # fd = stdout (file descriptor 1)
la x11, msg        # address of message buffer
li x12, len_msg    # number of bytes to write
li x17, 64         # syscall number for write
ecall              # make the system call
```

**Linux write() system call signature:**
```c
ssize_t write(int fd, const void *buf, size_t count);
```

**RISC-V register mapping:**
- `x10 (a0)` = fd (file descriptor)
- `x11 (a1)` = buf (pointer to data)
- `x12 (a2)` = count (number of bytes)
- `x17 (a7)` = 64 (system call number)

### 🚪 Exit System Call

```assembly
li x17, 93         # syscall exit
li x10, 0          # exit code 0
ecall
```

- **93**: Linux system call number for `exit()`
- **0**: Exit code (0 = success, non-zero = error)
- Without this, program would crash when it runs past the end!

## 🛠️ Build Process Deep Dive

Let's understand exactly what each build command does:

### Step 1: Assembly (`riscv64-unknown-elf-as`)

```bash
riscv64-unknown-elf-as -o add_registers.o add_registers.s
```

**What this command does:**
- **`riscv64`**: Target 64-bit RISC-V architecture
- **`unknown`**: No specific vendor (generic RISC-V)
- **`elf`**: Output ELF (Executable and Linkable Format) files
- **`as`**: The assembler tool
- **`-o add_registers.o`**: Output object file name
- **`add_registers.s`**: Input assembly source file

**What happens internally:**
1. **Parse assembly syntax** - Check for syntax errors
2. **Convert mnemonics to machine code** - `li x1, 5` becomes `0x00500093`
3. **Create symbol table** - Track labels like `_start`, `msg`
4. **Generate relocations** - Mark addresses that need fixing by linker
5. **Output object file** - Contains machine code + metadata

**Object file contents:**
- **Machine code**: Binary instructions the CPU can execute
- **Symbol table**: Names and addresses of labels
- **Relocation table**: "Fix these addresses later"
- **Section headers**: Where code vs data goes

### Step 2: Linking (`riscv64-unknown-elf-ld`)

```bash
riscv64-unknown-elf-ld -o add_registers add_registers.o
```

**What the linker does:**
1. **Resolve symbols** - Figure out final addresses for all labels
2. **Combine sections** - Put all code together, all data together
3. **Apply relocations** - Fill in the actual addresses
4. **Create executable** - Add program headers for OS loader
5. **Set entry point** - Tell loader to start at `_start`

**Memory layout after linking:**
```
Virtual Address Space:
┌─────────────────┐ ← 0x10000000 (typical start)
│  .text section  │   (your code: _start, instructions)
├─────────────────┤
│  .data section  │   (your data: msg, constants)  
├─────────────────┤
│  (unused space) │
└─────────────────┘
```

### Step 3: Execution (`qemu-riscv64`)

```bash
qemu-riscv64 add_registers
```

**What QEMU does:**
1. **Load executable** - Read ELF file, map sections to virtual memory
2. **Set up CPU state** - Initialize registers, stack pointer
3. **Jump to entry point** - Start executing at `_start`
4. **Emulate RISC-V CPU** - Fetch, decode, execute each instruction
5. **Handle system calls** - Forward `ecall` to host Linux kernel
6. **Manage memory** - Translate RISC-V addresses to host addresses

## 🧠 Why These Specific Commands?

### 🎯 Why `riscv64-unknown-elf-*` Tools?

1. **`riscv64`**: We're targeting 64-bit RISC-V processors
   - Could also use `riscv32` for 32-bit targets
   - Determines instruction encoding and register width

2. **`unknown`**: No specific vendor/board
   - Alternative: `sifive` for SiFive boards
   - `unknown` = generic, works anywhere

3. **`elf`**: We want ELF format output
   - ELF = standard Linux executable format
   - Alternative: `eabi` for embedded systems

### 🔧 Why Separate Assembly and Linking?

**Benefits of two-step process:**
- **Modularity**: Can link multiple object files together
- **Libraries**: Can link with pre-compiled libraries
- **Debugging**: Can inspect object files before final executable
- **Optimization**: Linker can optimize across modules

**Single command alternative** (does both steps):
```bash
riscv64-unknown-elf-gcc -nostdlib -o add_registers add_registers.s
```

### 🎭 Why QEMU Instead of Native Execution?

Your Ubuntu PC has an x86_64 processor, not RISC-V. QEMU:
- **Emulates RISC-V CPU** - Translates RISC-V instructions to x86_64
- **Provides Linux environment** - Handles system calls
- **No hardware needed** - Develop RISC-V code on any machine

## 🗺️ Memory Layout Understanding

When your program runs, memory is organized like this:

```
RISC-V Virtual Address Space:
┌─────────────────────┐ ← 0xFFFFFFFF (high memory)
│       Stack         │   ↓ (grows downward)
│    (automatic vars) │
├─────────────────────┤
│         ...         │   (unused virtual space)
├─────────────────────┤
│        Heap         │   ↑ (grows upward)
│   (dynamic alloc)   │   (not used in our program)
├─────────────────────┤
│    .data section    │   ← msg lives here
│   (global vars)     │   ← len_msg value here
├─────────────────────┤
│    .text section    │   ← _start code here
│   (your code)       │   ← all instructions here
└─────────────────────┘ ← 0x10000000 (typical start)
```

### 📍 Address Calculation Example

```assembly
la x11, msg        # Load address of msg
```

If `msg` is at address `0x10001000`, this instruction loads `0x10001000` into register x11.

When we do the system call:
- x11 points to memory location `0x10001000`
- That memory contains bytes: `'R' 'e' 's' 'u' 'l' 't' ':' ' '`
- Kernel reads from that address and prints to screen

## 🐛 Debugging and Analysis

### Inspect Your Object File

```bash
# View symbols in object file
riscv64-unknown-elf-nm add_registers.o

# Disassemble object file
riscv64-unknown-elf-objdump -d add_registers.o

# View all sections
riscv64-unknown-elf-objdump -h add_registers.o
```

### Inspect Your Executable

```bash
# Disassemble final executable
riscv64-unknown-elf-objdump -d add_registers

# View program headers (how OS loads it)
riscv64-unknown-elf-readelf -l add_registers

# View section headers
riscv64-unknown-elf-readelf -S add_registers
```

### Debug with GDB

```bash
# Debug the program
gdb-multiarch add_registers

# In GDB:
(gdb) set architecture riscv:rv64
(gdb) break _start
(gdb) run
(gdb) info registers    # Show all register values
(gdb) x/s 0x10001000   # Examine memory as string
(gdb) stepi            # Step one instruction
```

### Trace System Calls

```bash
# See all system calls your program makes
strace qemu-riscv64 add_registers
```

## ⚠️ Common Pitfalls and Solutions

### 1. **Segmentation Fault**

**Problem:** Program crashes with segfault
**Causes:**
- Missing `_start` label
- Missing `.globl _start` directive
- Invalid memory access

**Solution:**
```assembly
.globl _start    # Don't forget this!
_start:          # Entry point must exist
```

### 2. **Nothing Printed**

**Problem:** Program runs but no output
**Causes:**
- Wrong system call number
- Wrong register usage
- Incorrect buffer address

**Debug:**
```bash
strace qemu-riscv64 add_registers  # See if write() is called
```

### 3. **Wrong Output**

**Problem:** Garbage characters printed
**Causes:**
- ASCII conversion error
- Wrong string length
- Buffer not properly initialized

**Fix for multi-digit numbers:**
```assembly
# This only works for single digits (0-9)
addi x3, x3, 48

# For larger numbers, need proper conversion routine
```

### 4. **Build Errors**

**Problem:** Assembly or linking fails
**Common fixes:**
```bash
# Check if tools are installed
which riscv64-unknown-elf-as

# Verify file exists and has correct extension
ls -la add_registers.s

# Check for typos in labels and mnemonics
```

### 5. **Program Doesn't Exit**

**Problem:** Program hangs or crashes at end
**Solution:** Always end with exit system call:
```assembly
li x17, 93    # exit syscall
li x10, 0     # exit code
ecall         # Don't forget this!
```

## 🎓 Educational Value

This bare-metal programming exercise teaches you:

1. **CPU Architecture** - How processors execute instructions
2. **Memory Management** - How programs are loaded and organized
3. **System Interfaces** - How software talks to operating systems
4. **Assembly Language** - The human-readable form of machine code
5. **Tool chains** - How source code becomes executable programs
6. **Debugging Skills** - How to diagnose low-level problems

### 🚀 Next Steps

1. **Extend the program** - Handle multi-digit results
2. **Add input** - Use read() system call to get user input
3. **More operations** - Implement subtraction, multiplication
4. **Functions** - Learn RISC-V calling conventions
5. **Memory allocation** - Implement simple heap management

## 📚 Further Reading

- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- [RISC-V Assembly Programming](https://github.com/riscv/riscv-asm-manual)
- [Linux System Call Interface](https://man7.org/linux/man-pages/man2/syscalls.2.html)
- [ELF File Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
- [QEMU User Mode](https://qemu.readthedocs.io/en/latest/user/main.html)

---

*Understanding bare-metal programming gives you superpowers - you know exactly what your computer is doing at the lowest level! 🦸‍♂️*