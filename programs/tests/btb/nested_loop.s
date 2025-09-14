li x1, 0       # outer counter
li x2, 0       # inner counter
li x3, 4       # outer limit
li x4, 8       # inner limit

outer_loop:
    addi x1, x1, 1
    li x2, 0
inner_loop:
    addi x2, x2, 1
    blt x2, x4, inner_loop
    blt x1, x3, outer_loop

li x5, 0xBEEF
end: j end
