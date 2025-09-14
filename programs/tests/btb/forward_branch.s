li x1, 0       # counter
li x2, 10      # loop limit

loop1:
    addi x1, x1, 1
    blt x1, x2, loop1

li x3, 0xBEEF
end: j end
