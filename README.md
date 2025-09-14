# 🔧 RISC-V Development on Ubuntu: Complete Student Guide

Welcome to RISC-V development! This guide will help you set up a complete RISC-V development environment on Ubuntu and teach you how to write, compile, and run RISC-V programs.

## 📋 Table of Contents
- [What You'll Get](#what-youll-get)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Tutorial 1: Assembly Programming](#tutorial-1-assembly-programming)
- [Tutorial 2: Bare-Metal C Programming](#tutorial-2-bare-metal-c-programming)
- [Tutorial 3: Linux C Programming](#tutorial-3-linux-c-programming)
- [Advanced Topics](#advanced-topics)
- [Troubleshooting](#troubleshooting)
- [Learning Resources](#learning-resources)

## 🎯 What You'll Get

After completing this setup, you'll have **two powerful RISC-V development toolchains**:

### 1. 🔩 Bare-Metal Toolchain (`riscv64-unknown-elf-gcc`)
- **What it is**: Programs run directly on the processor without an operating system
- **What's included**: Only the processor and your code - no standard library functions
- **What you can't use**: No `stdio.h`, no `printf()`, no `malloc()` - you're on your own!
- **Perfect for**: Learning computer architecture, embedded systems, and understanding how computers really work
- **Communication method**: Direct system calls using `ecall` instruction

### 2. 🐧 Linux Toolchain (`riscv64-linux-gnu-gcc`)
- **What it is**: Normal C programs that run on RISC-V Linux
- **What's included**: Full C standard library (glibc) with all familiar functions
- **What you can use**: Everything! `printf()`, `scanf()`, `malloc()`, file I/O, etc.
- **Perfect for**: Regular programming, porting existing C code to RISC-V
- **Communication method**: Standard C library functions

Both toolchains use **QEMU** (a processor emulator) so you can run RISC-V programs on your regular Ubuntu computer!

## 🛠️ Prerequisites

Before starting, make sure you have:
- Ubuntu 20.04 or newer (or similar Debian-based distribution)
- Internet connection for downloading packages
- Basic familiarity with terminal/command line
- Text editor (nano, vim, VS Code, etc.)

## 🚀 Installation

### Step 1: Create the Setup Script

Create a file called `setup-riscv.sh`:

```bash
nano setup-riscv.sh
```

Copy and paste this script:

```bash
#!/bin/bash
# RISC-V Development Environment Setup Script

echo "🔧 Setting up RISC-V development environment..."

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install RISC-V toolchains
echo "🛠️  Installing RISC-V toolchains..."
sudo apt install -y gcc-riscv64-unknown-elf gcc-riscv64-linux-gnu

# Install QEMU for RISC-V emulation
echo "🖥️  Installing QEMU RISC-V emulator..."
sudo apt install -y qemu-user qemu-user-static

# Install build tools
echo "🔨 Installing additional build tools..."
sudo apt install -y build-essential gdb-multiarch

echo "✅ Installation complete!"
echo ""
echo "🧪 Testing installations..."

# Test bare-metal toolchain
if command -v riscv64-unknown-elf-gcc &> /dev/null; then
    echo "✅ Bare-metal toolchain: $(riscv64-unknown-elf-gcc --version | head -n1)"
else
    echo "❌ Bare-metal toolchain installation failed"
fi

# Test Linux toolchain
if command -v riscv64-linux-gnu-gcc &> /dev/null; then
    echo "✅ Linux toolchain: $(riscv64-linux-gnu-gcc --version | head -n1)"
else
    echo "❌ Linux toolchain installation failed"
fi

# Test QEMU
if command -v qemu-riscv64 &> /dev/null; then
    echo "✅ QEMU emulator: $(qemu-riscv64 --version | head -n1)"
else
    echo "❌ QEMU installation failed"
fi

echo ""
echo "🎉 Your RISC-V development environment is ready!"
echo "📚 You can now follow the tutorials in the README."
```

### Step 2: Run the Setup Script

```bash
chmod +x setup-riscv.sh
./setup-riscv.sh
```

Wait for the installation to complete. You should see green checkmarks (✅) for all components.

### Step 3: Verify Installation

Run these commands to double-check everything is working:

```bash
riscv64-unknown-elf-gcc --version   # Should show bare-metal compiler
riscv64-linux-gnu-gcc --version     # Should show Linux compiler  
qemu-riscv64 --version              # Should show QEMU emulator
```

## 🎓 Tutorial 1: Assembly Programming

Let's start with pure RISC-V assembly language - the most basic level of programming.

### Understanding the Code

First, let's understand what our assembly program does:

```assembly
.section .text          # This is where our code goes
.globl _start          # Make _start visible to the linker
_start:                # Program entry point (like main() in C)
    li a0, 1           # Load immediate: a0 = 1 (stdout file descriptor)
    la a1, msg         # Load address: a1 = address of msg
    li a2, 13          # Load immediate: a2 = 13 (message length)
    li a7, 64          # Load immediate: a7 = 64 (write syscall number)
    ecall              # Make system call (like calling write())
    
    li a7, 93          # Load immediate: a7 = 93 (exit syscall number)
    li a0, 0           # Load immediate: a0 = 0 (exit code)
    ecall              # Make system call (like calling exit())

.section .data         # This is where our data goes
msg:
    .ascii "Hello RISC-V\n"  # Our message string
```

### Step-by-Step Tutorial

1. **Create the assembly file**:
```bash
nano hello.s
```

2. **Copy this code**:
```assembly
.section .text
.globl _start
_start:
    li a0, 1              # fd = stdout
    la a1, msg            # load msg address
    li a2, 13             # length of message
    li a7, 64             # syscall number for write
    ecall                 # make system call
    
    li a7, 93             # syscall number for exit
    li a0, 0              # exit code
    ecall                 # make system call

.section .data
msg:
    .ascii "Hello RISC-V\n"
```

3. **Assemble the code** (convert assembly to machine code):
```bash
riscv64-unknown-elf-as -o hello.o hello.s
```

4. **Link the object file** (create executable):
```bash
riscv64-unknown-elf-ld -o hello hello.o
```

5. **Run the program**:
```bash
qemu-riscv64 hello
```

**Expected output**:
```
Hello RISC-V
```

### 🤔 What Just Happened?

1. **Assembly**: The assembler converted your human-readable assembly code into machine code
2. **Linking**: The linker created a complete executable program
3. **Emulation**: QEMU pretended to be a RISC-V processor and ran your program

## 🎓 Tutorial 2: Bare-Metal C Programming

Now let's write C code that runs without an operating system - you're in complete control!

### Understanding Bare-Metal Programming

In bare-metal programming:
- No `printf()` - you make system calls directly
- No `main()` - you start at `_start()`
- No standard library - you're on your own!
- You communicate directly with the system using `ecall`

### Step-by-Step Tutorial

1. **Create the C file**:
```bash
nano hello_bare.c
```

2. **Copy this code**:
```c
// Bare-metal C program - no standard library!
void _start() {
    // Our message to print
    const char msg[] = "Hello bare-metal C!\n";
    
    // Set up registers for system call
    register long a0 asm("a0") = 1;              // fd = stdout (1)
    register long a1 asm("a1") = (long)msg;      // buf = message address
    register long a2 asm("a2") = sizeof(msg)-1;  // len = message length
    register long a7 asm("a7") = 64;             // syscall = write (64)
    
    // Make the write system call
    asm volatile("ecall");
    
    // Now exit the program
    a7 = 93;  // syscall = exit (93)
    a0 = 0;   // exit code = 0 (success)
    asm volatile("ecall");
}
```

3. **Compile the program**:
```bash
riscv64-unknown-elf-gcc -nostdlib -o hello_bare hello_bare.c
```
   - `-nostdlib`: Don't link with standard library

4. **Run the program**:
```bash
qemu-riscv64 hello_bare
```

**Expected output**:
```
Hello bare-metal C!
```

### 💡 Key Concepts

- **`_start()`**: Entry point for bare-metal programs (instead of `main()`)
- **`register ... asm("a0")`**: Forces the compiler to use specific RISC-V registers
- **`ecall`**: RISC-V instruction for making system calls
- **System call numbers**: 64 = write, 93 = exit (Linux system call numbers)

## 🎓 Tutorial 3: Linux C Programming

Now let's write normal C programs that use the full standard library!

### Step-by-Step Tutorial

1. **Create a normal C file**:
```bash
nano hello_linux.c
```

2. **Copy this familiar code**:
```c
#include <stdio.h>

int main() {
    printf("Hello RISC-V Linux!\n");
    printf("This program uses the full C library!\n");
    printf("We can use printf, scanf, malloc, and everything else!\n");
    return 0;
}
```

3. **Compile with the Linux toolchain**:
```bash
riscv64-linux-gnu-gcc -o hello_linux hello_linux.c
```

4. **Run the program**:
```bash
qemu-riscv64 hello_linux
```

**Expected output**:
```
Hello RISC-V Linux!
This program uses the full C library!
We can use printf, scanf, malloc, and everything else!
```

### 🎯 Try More Complex Examples

**File I/O Example**:
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *file = fopen("test.txt", "w");
    if (file) {
        fprintf(file, "Hello from RISC-V!\n");
        fclose(file);
        printf("File written successfully!\n");
    }
    return 0;
}
```

**Dynamic Memory Example**:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char *buffer = malloc(100);
    if (buffer) {
        strcpy(buffer, "Dynamically allocated string on RISC-V!");
        printf("%s\n", buffer);
        free(buffer);
    }
    return 0;
}
```

## 🔍 Advanced Topics

### Inspecting Generated Assembly

Want to see what RISC-V assembly your C code generates?

```bash
# Generate assembly from C code
riscv64-unknown-elf-gcc -S hello_linux.c -o hello_linux.s
cat hello_linux.s
```

### Disassembling Binaries

Want to see the machine code in your executable?

```bash
# Disassemble the binary
riscv64-unknown-elf-objdump -d hello_linux
```

### Using GDB for Debugging

Debug your RISC-V programs:

```bash
# Compile with debug symbols
riscv64-unknown-elf-gcc -g -nostdlib -o hello_bare hello_bare.c

# Debug with GDB
gdb-multiarch hello_bare
```

Inside GDB:
```
(gdb) set architecture riscv:rv64
(gdb) break _start
(gdb) run
(gdb) stepi          # Step one instruction
(gdb) info registers # Show register contents
```

## 🛠️ Troubleshooting

### Common Issues and Solutions

**Problem**: `command not found` when running compiler
```bash
# Solution: Make sure installation completed successfully
sudo apt install gcc-riscv64-unknown-elf gcc-riscv64-linux-gnu
```

**Problem**: `qemu-riscv64: command not found`
```bash
# Solution: Install QEMU user mode emulation
sudo apt install qemu-user qemu-user-static
```

**Problem**: "File format not recognized" error
```bash
# Solution: You're using the wrong toolchain
# Use riscv64-unknown-elf-* for bare-metal
# Use riscv64-linux-gnu-* for Linux programs
```

**Problem**: Segmentation fault when running program
```bash
# For Linux programs, make sure you have the runtime libraries
sudo apt install libc6-riscv64-cross
```

### Getting Help

If you encounter issues:
1. Check that all packages installed correctly
2. Verify you're using the right toolchain for your program type
3. Make sure your assembly syntax is correct
4. Check file permissions (`chmod +x` for scripts)

## 📚 Learning Resources

### RISC-V Architecture
- [RISC-V ISA Manual](https://riscv.org/technical/specifications/) - Official specification
- [RISC-V Assembly Programmer's Manual](https://github.com/riscv/riscv-asm-manual) - Assembly language guide

### System Programming
- [Linux System Call Reference](https://man7.org/linux/man-pages/man2/syscalls.2.html) - All system calls
- [RISC-V Linux Syscall ABI](https://github.com/riscv/riscv-linux/wiki/RISC-V-Linux-User-ABI) - How syscalls work on RISC-V

### Tools and Emulation
- [QEMU Documentation](https://www.qemu.org/docs/master/system/riscv/virt.html) - RISC-V emulation
- [GDB Manual](https://sourceware.org/gdb/current/onlinedocs/gdb/) - Debugging guide

## 🎉 What's Next?

Now that you have a working RISC-V development environment, you can:

1. **🔬 Experiment with assembly language** - Learn how processors really work
2. **🧠 Study computer architecture** - Understand instruction sets and calling conventions  
3. **🔧 Build embedded systems** - Write programs that run on bare hardware
4. **🐧 Port existing C programs** - Compile your favorite programs for RISC-V
5. **🚀 Prepare for real hardware** - Get ready for RISC-V development boards

### Suggested Next Steps

1. Write a program that takes user input using system calls
2. Create a simple calculator using bare-metal C
3. Port a small existing C program to RISC-V
4. Learn about RISC-V calling conventions and write assembly functions
5. Experiment with different optimization levels (`-O1`, `-O2`, `-O3`)

Happy coding with RISC-V! 🚀

---

*This guide was created to help students learn RISC-V development. If you find any issues or have suggestions for improvement, please let me know!*
