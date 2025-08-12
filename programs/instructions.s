    # R-type computations
    add x5, x1, x2       
    sub x6, x5, x3       
    and x7, x6, x4       

    # Store
    sw x7, 0(x5)         # Store result x7 to memory at address in x5

    nop                  # Delay slot for memory write (simulate pipeline stall)
    nop

    # Now load from memory safely
    lw x8, 0(x5)         # Load from memory into x8

    # More independent instructions to avoid hazards
    addi x9, x8, 10      
    andi x10, x9, 0xFF   

    # Store byte and load byte with delays
    sb x10, 4(x5)        
    nop
    nop
    lb x11, 4(x5)        
