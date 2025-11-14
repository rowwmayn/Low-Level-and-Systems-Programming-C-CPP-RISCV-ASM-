#!/bin/bash

# RISC-V Assembly Build Script

FILENAME=$1

if [ -z "$FILENAME" ]; then
    echo "Usage: ./build.sh <filename_without_extension>"
    echo "Example: ./build.sh calc"
    exit 1
fi

echo "🔧 Assembling ${FILENAME}.s..."
riscv64-unknown-elf-as -o ${FILENAME}.o ${FILENAME}.s

if [ $? -ne 0 ]; then
    echo "❌ Assembly failed!"
    exit 1
fi

echo "🔗 Linking ${FILENAME}.o..."
riscv64-unknown-elf-ld -o ${FILENAME} ${FILENAME}.o

if [ $? -ne 0 ]; then
    echo "❌ Linking failed!"
    exit 1
fi

echo "✅ Build successful!"
echo "🚀 Running ${FILENAME}..."
echo "------------------------"
qemu-riscv64 ./${FILENAME}
echo "------------------------"
echo "Exit code: $?"
