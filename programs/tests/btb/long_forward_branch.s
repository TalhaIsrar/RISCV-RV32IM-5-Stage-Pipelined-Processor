li x1, 0
li x2, 32

long_loop:
    addi x1, x1, 1
    blt x1, x2, long_loop

li x3, 0xBEEF
end: j end
