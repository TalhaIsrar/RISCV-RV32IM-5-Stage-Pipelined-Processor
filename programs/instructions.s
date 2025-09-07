.text
.globl _start

_start:
    li x1, 0          # loop counter i = 0
    li x2, 10         # loop limit = 10
    li x3, 0          # sum = 0
    
    # Initialize registers
    addi x4, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0
    addi x8, x0, 8    # Run 8 times

    mul x9, x2, x8

loop:
    addi x1, x1, 1    # i = i + 1
    add  x3, x3, x1   # sum += i

    blt  x1, x2, loop # branch back until i < 10  (taken 9 times, not taken once)

alt_loop:
    addi x4, x4, 1
    andi x5, x4, 1
    beq  x5, x0, even # branch taken on even iterations
    j    odd

even:
    addi x6, x6, 1    # count evens
    j    cont

odd:
    addi x7, x7, 1    # count odds

cont:
    blt  x4, x8, alt_loop   # repeat alternating branch 8 times

done:   
    mul x10, x7, x3
    addi x5, x0, 8

    # Store/load
    sw x1, 0(x5)
    lw x11, 0(x5)          

    addi x12, x11, 9 # Check for internal stall here 

    # Store/load
    sw x12, 0(x5)
    lw x13, 0(x5) 

    mul x14, x13, x12 # Check for internal stall here 

    nop
    nop