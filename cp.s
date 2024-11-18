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
.lcomm buff, 4096

.section .text
.global _start
_start:
    movq %rsp, %rbp
    subq $160, %rsp
    movq %rbp, %rbx

    cmpq $3, (%rbx)
    jne exit_usage

section0:
    addq $16, %rbx  # argv[1]
    open (%rbx), O_RDONLY(%rip), $0 # open file for reading
    movq %rax, -160(%rbp)

    testq %rax, %rax
    js exit_error

section1:
    stat -160(%rbp), -144(%rbp)
    testq %rax, %rax
    js exit_error

    movq -96(%rbp), %rax   # rax hold the filesize

    cqo
    movq $4096, %rcx    # block size
    div %rcx

section2:
    incq %rax   # rax hold the number of writes needed
    movq %rax, %r8

    addq $8, %rbx   #argv[2]
    movq O_CREAT(%rip), %rax
    or   O_WRONLY(%rip), %rax
    open (%rbx), %rax, S_IRWXU(%rip)    # create the second file with write permissions
    movq %rax, -152(%rbp)
    testq %rax, %rax
    js exit_error

.LP0:
    read -160(%rbp), buff(%rip), $4096
    write -152(%rbp), buff(%rip), %rax

    decq %r8
    cmpq $0, %r8
    jne .LP0

    close -152(%rbp)
    close -160(%rbp)
exit_success:
    exit $0

exit_usage:
    write $1, usage(%rip), usage_len(%rip)
    exit $-1

exit_error:
    write $1, error(%rip), error_len(%rip)
    exit $-2
