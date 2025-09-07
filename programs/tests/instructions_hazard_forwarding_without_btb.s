    # Initialize registers
    addi x1, x0, 5        
    addi x2, x0, 3        
    addi x3, x0, 2        
    addi x4, x0, 1    
    addi x10, x0, 1023    

    # R-type computations
    add x5, x1, x2        
    sub x6, x1, x3        
    and x7, x2, x4        

    # Store/load
    sw x1, 0(x5)
    lw x8, 0(x5)          

    addi x9, x8, 10 # Check for internal stall here 

    sb x10, 4(x5)
    lb x11, 4(x5) 

    # Branch instructions
    beq x1, x2, skip1     
    addi x12, x0, 1       

skip1:
    bne x1, x2, taken1    
    addi x13, x0, 2       

taken1:
    addi x14, x0, 3       

    # JAL instruction
    jal x15, jump_label
    addi x16, x0, 4       

jump_label:
    addi x17, x0, 5       

    # JALR instruction
    addi x18, x0, 10 

    # LUI instruction
    lui x20, 0x12345       # x20 = 0x12345000

    # AUIPC instruction
    auipc x21, 0x10        # x21 = PC + 0x10000
    jalr x19, x18, 0