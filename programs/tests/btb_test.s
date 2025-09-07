.section .text
.global _start
_start:
    li   x1, 0
    li   x2, 10
loop:
    addi x1, x1, 1
    blt  x1, x2, loop     # loop 10 times
    addi x3, x0, 123
done: j done
