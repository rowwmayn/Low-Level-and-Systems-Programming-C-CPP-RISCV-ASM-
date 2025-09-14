void _start() {
    const char msg[] = "Hello from bare-metal C!\n";
    register long a0 asm("a0") = 1;       // fd = stdout
    register long a1 asm("a1") = (long)msg;
    register long a2 asm("a2") = sizeof(msg) - 1;
    register long a7 asm("a7") = 64;      // write syscall
    asm volatile ("ecall");

    a7 = 93;  // exit syscall
    a0 = 0;
    asm volatile ("ecall");
}


