    # Initialize registers
    addi x1, x0, 5        # x1 = 5
    addi x2, x0, 3        # x2 = 3
    addi x3, x0, 2        # x3 = 2
    addi x4, x0, 1        # x4 = 1
    addi x10,x0, 1023     # x10 = 1023

    # R-type computations
    add x5, x1, x2        # x5 = 5 + 3 = 8
    sub x6, x1, x3        # x6 = 5 - 2 = 3
    and x7, x2, x4        # x7 = 3 & 1 = 1

    # Store/load
    nop
    sw x1, 0(x5)          # MEM[8] = 5
    nop
    nop
    nop
    lw x8, 0(x5)          # x8 = 5

    addi x9, x6, 10       # x9 = 3 + 10 = 13

    sb x10, 4(x5)         # MEM[12] = 0xFF
    nop
    nop
    nop
    lb x11, 4(x5)         # x11 = 0xFF

    # Branch instructions
    beq x1, x2, skip1     # x1 != x2, skip branch not taken
    nop
    nop
    nop
    addi x12, x0, 1       # x12 = 1

skip1:
    bne x1, x2, taken1    # x1 != x2, branch taken
    nop
    nop
    nop
    addi x13, x0, 2       # Skipped if branch taken

taken1:
    addi x14, x0, 3       # x14 = 3

    # JAL instruction
    jal x15, jump_label   # x15 = PC+4, PC = jump_label

    nop
    nop
    nop
    addi x16, x0, 4       # Should be skipped

jump_label:
    addi x17, x0, 5       # x17 = 5

    # JALR instruction
    addi x18, x0, 40      # x18 = 28 (in HEX)
    nop
    nop
    nop
    jalr x19, x18, 0      # x19 = PC+4, PC = x18 + 0
