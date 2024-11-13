.macro close fd
    movq \fd, %rdi
    movq $4, %rax
    syscall
.endm
