.macro read fd, loc, len
    movq \fd, %rdi
    leaq \loc, %rsi
    movq \len, %rdx
    movq $0, %rax
    syscall
.endm
