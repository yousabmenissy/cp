.include "lib/sys_read.s"
.include "lib/sys_write.s"
.include "lib/sys_open.s"
.include "lib/sys_close.s"
.include "lib/sys_stat.s"
.include "lib/sys_exit.s"


.section .data
usage: .string "Usage: cp <src> <dest>\n"
usage_len: .quad . - usage
error: .string "error: could not open file\n"
error_len: .quad . - error

.section .bss
.lcomm buff, 1024

.section .text
.global _start
_start:
    movq %rsp, %rbp
    movq %rbp, %rbx

    cmpq $3, (%rbx)
    jne exit_usage

section0:
    addq $16, %rbx
    open (%rbx), O_RDONLY(%rip), $0
    pushq %rax
    testq %rax, %rax
    js exit_error

section1:
    subq $144, %rsp
    stat -8(%rbp), -152(%rbp)
    testq %rax, %rax
    js exit_error

    movq -104(%rbp), %rax
    cqo
    movq $1024, %rcx
    div %rcx

section2:
    incq %rax
    movq %rax, %r8

    addq $8, %rbx
    movq O_CREAT(%rip), %rax
    or O_WRONLY(%rip), %rax
    open (%rbx), %rax, S_IRWXU(%rip)
    pushq %rax
    testq %rax, %rax
    js exit_error

.LP0:
    read -8(%rbp), buff(%rip), $1024
    write -160(%rbp), buff(%rip), %rax

    decq %r8
    cmpq $0, %r8
    jne .LP0

    close -8(%rbp)
    close -160(%rbp)
exit_success:
    exit $0

exit_usage:
    write $1, usage(%rip), usage_len(%rip)
    exit $-1

exit_error:
    write $1, error(%rip), error_len(%rip)
    exit $-2
