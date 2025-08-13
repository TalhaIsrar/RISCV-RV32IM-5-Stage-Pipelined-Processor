module pc_update(
    input [31:0] pc,
    input [31:0] pc_jump_addr,
    input jump_en,
    output [31:0] next_pc
);
    assign next_pc = jump_en ? pc_jump_addr : pc + 4

endmodule