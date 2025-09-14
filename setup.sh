#!/bin/bash
set -e

echo "=== Updating packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing RISC-V Bare-Metal Toolchain ==="
sudo apt install -y gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf

echo "=== Installing RISC-V Linux Toolchain ==="
sudo apt install -y gcc-riscv64-linux-gnu g++-riscv64-linux-gnu

echo "=== Installing Emulator (QEMU) and Debugger ==="
sudo apt install -y qemu-user qemu-user-binfmt gdb-multiarch

echo "=== Installation Complete ==="
echo "Bare-metal compiler: riscv64-unknown-elf-gcc"
echo "Linux compiler:     riscv64-linux-gnu-gcc"
echo "Run binaries with:  qemu-riscv64 <program>"
echo "Debug with:         gdb-multiarch"
