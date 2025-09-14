.section .text
.global _start
_start:
    li   x1, 2
    addi x2, x1, 3         # 5
    mul  x3, x2, x1        # 10
    lw   x4, 0(x0)         # mem[0]=? assume 0
    add  x5, x4, x3        # hazard: LD->ALU
    div  x6, x5, x1        # hazard: ALU->DIV
    beq  x6, x3, taken     # hazard: DIV->BR
    addi x7, x0, 0
taken:
    addi x7, x0, 99
done: j done
