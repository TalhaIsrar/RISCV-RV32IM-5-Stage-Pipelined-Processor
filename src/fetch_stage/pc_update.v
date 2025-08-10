module pc_update(
    input [31:0] pc,
    output [31:0] next_pc
)
    assign next_pc = pc + 4; // Increment PC by 4 for next instruction
    // TODO : Handle branch and jump instructions to update next_pc accordingly

endmodule