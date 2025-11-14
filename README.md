# RISC-V Setup Guide

## Installation (WSL Ubuntu)

```bash
sudo apt update
sudo apt install gcc-riscv64-linux-gnu g++-riscv64-linux-gnu
sudo apt install qemu-user qemu-user-static
```

## C++ Programming Example

**Create `hello.cpp`:**

```cpp
#include <iostream>

int main() {
    std::cout << "Hello from RISC-V C++!" << std::endl;
    return 0;
}
```

**Compile and Run:**

```bash
riscv64-linux-gnu-g++ hello.cpp -o hello -static
qemu-riscv64 ./hello
```

## Assembly Programming Example

**Create `test.s`:**

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

**Assemble and Run:**

```bash
riscv64-linux-gnu-as test.s -o test.o
riscv64-linux-gnu-ld test.o -o test
qemu-riscv64 ./test
```

**Output:**
```
Hello RISC-V!
```