.section .text
.globl _start

_start:
    li x1, 0x7FFFFFFF   # dividend = 2147483647
    li x2, 2            # divisor = 2

    li x3, 0          # quotient = 0
    li x4, 0          # remainder = 0
    li x5, 30         # bit index = 31

div_loop:
    # Shift remainder left by 1 and bring in next dividend bit
    sll x4, x4, 1
    srl x6, x1, x5    # get bit x5 of dividend
    andi x6, x6, 1
    or x4, x4, x6

    # Compare remainder >= divisor
    blt x4, x2, skip_sub
    sub x4, x4, x2     # remainder -= divisor
    li x6, 1
    sll x6, x6, x5     # set quotient bit
    or x3, x3, x6

skip_sub:
    addi x5, x5, -1
    bgez x5, div_loop   # loop until bit < 0

end:
    j end
