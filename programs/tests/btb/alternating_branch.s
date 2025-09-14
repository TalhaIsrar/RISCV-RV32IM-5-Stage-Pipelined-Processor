li x1, 0        # counter
li x2, 16        # number of iterations

alt_loop:
    addi x1, x1, 1
    andi x3, x1, 1     # x3 = x1 % 2
    beq x3, x0, branch_taken  # branch taken if x1 is even
    j no_branch

branch_taken:
    addi x4, x4, 1

no_branch:
    addi x5, x5, 1

    blt x1, x2, alt_loop  # loop until x1 == x2

li x6, 0xBEEF
end: j end
