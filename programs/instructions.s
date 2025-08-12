    # Initialize registers with immediate values
    addi x1, x0, 5       # x1 = 5
    addi x2, x0, 3       # x2 = 3
    addi x3, x0, 2       # x3 = 2
    addi x4, x0, 1       # x4 = 1
    addi x10,x0, 1023    # x10=1023

    # R-type computations
    add x5, x1, x2       # x5 = 5 + 3 = 8
    sub x6, x1, x3       # x6 = 5 - 2 = 3
    and x7, x2, x4       # x7 = 3 & 1 = 1 (binary 011 & 001 = 001)

    # Store
    sw x1, 0(x5)         # Store 5 at memory address 8

    nop                  # Delay slot for memory write
    nop
    nop

    # Now load from memory safely
    lw x8, 0(x5)         # x8 = 5 (loaded from memory[8])

    # More independent instructions to avoid hazards
    addi x9, x6, 10      # x9 = 3 + 10 = 13

    # Store byte and load byte with delays
    sb x10, 4(x5)        # Store byte 3FF at memory address 12 (Only FF should get written)
    nop
    nop
    nop
    lw x11, 4(x5)        # x11 = 00FF (load byte from memory[12])
