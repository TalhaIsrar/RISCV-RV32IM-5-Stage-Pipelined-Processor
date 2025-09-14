.section .text
.globl _start

_start:
    li x1, 0x7FFFFFFF   # dividend = 2147483647
    li x2, 2            # divisor = 2

    div x3, x1, x2   # x3 = x1 / x2 (hardware divide)

end: 
    j end            # stop program
