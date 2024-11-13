.section .text
.macro exit status
    movq \status, %rdi
    movq $60, %rax
    syscall
.endm
