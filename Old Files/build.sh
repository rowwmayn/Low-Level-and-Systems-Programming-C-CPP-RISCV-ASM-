#!/bin/bash
TARGET=${1:-hello}
echo "=== Building $TARGET ==="
riscv64-unknown-elf-as -o ${TARGET}.o ${TARGET}.s && \
riscv64-unknown-elf-ld -o ${TARGET} ${TARGET}.o && \
echo "=== Running $TARGET ===" && \
qemu-riscv64 ${TARGET}
