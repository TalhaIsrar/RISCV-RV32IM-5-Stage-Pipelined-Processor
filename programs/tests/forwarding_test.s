.section .text
.global _start
_start:
    li   x1, 5
    li   x2, 7
    add  x3, x1, x2          # x3=12
    sub  x4, x3, x2          # x4=5 (must forward x3)
    beq  x4, x1, br1         # must forward x4
    li   x10, 0              # wrong if reached
br1:
    sw   x3, 0(x0)           # mem[0]=12
    lw   x5, 0(x0)           # x5=12
    add  x6, x5, x1          # must stall or fwd -> 17
done: j done
