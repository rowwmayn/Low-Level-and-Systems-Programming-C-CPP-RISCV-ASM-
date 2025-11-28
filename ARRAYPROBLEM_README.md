# RISC-V Array Test Breakdown

## Data Section

```asm
.section .data
A:  .dword 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0
    .space 696
h:  .dword 10
```

- **`.section .data`** - Writable data section (can be modified during execution)
- **`.dword`** - Directive to define 8-byte (doubleword) values
- **`A:`** - Label marking start of array in memory
- **`.space 696`** - Reserves 696 bytes (87 doublewords × 8 bytes) of empty space
- Array has 13 initialized values + 87 zeros = 100 total doublewords
- **`h:`** - Label for variable h, initialized to 10

## Code Section

### Setup
```asm
la x22, A           # Load address of array A into x22
ld x21, h           # Load value of h (10) into x21
```

- **`la`** (load address) - Gets memory address where A starts
- **`ld`** (load doubleword) - Loads 8-byte value from memory

### Problem 1: g = h + A[8]
```asm
ld x5, 64(x22)      # Load A[8] into x5
add x20, x21, x5    # x20 = x21 + x5
```

- **`64(x22)`** - Offset addressing: base address + 64 bytes
- Calculation: A[8] is at position 8, each element is 8 bytes → 8×8 = 64
- Loads value 5 from A[8]
- **`add`** - Adds two registers: 10 + 5 = 15
- Result stored in x20 (represents variable g)

### Problem 2: A[12] = h + A[8]
```asm
sd x20, 96(x22)     # Store x20 into A[12]
```

- **`sd`** (store doubleword) - Writes 8-byte value to memory
- **`96(x22)`** - A[12] offset: 12×8 = 96 bytes
- Stores 15 into A[12]

### Verification
```asm
ld x6, 96(x22)      # Load A[12] to verify
mv a0, x20          # Copy g to a0
li a7, 93           # Exit syscall number
ecall               # Make syscall
```

- **`mv`** (move) - Pseudo-instruction: `addi a0, x20, 0`
- Exit code = value in a0 = 15
- Check with `echo $?` after running

## Memory Layout

```
Address:    Content:
x22+0       A[0] = 0
x22+8       A[1] = 0
...
x22+64      A[8] = 5    ← Read from here
...
x22+96      A[12] = 15  ← Write to here
```