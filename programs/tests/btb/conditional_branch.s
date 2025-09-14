li x1, 0       # counter
li x2, 16      # loop limit

loop_alt:
    addi x1, x1, 1
    beq x1, x2, loop_end
    blt x1, x2, loop_alt

loop_end:
    li x3, 0xBEEF

end: j end
