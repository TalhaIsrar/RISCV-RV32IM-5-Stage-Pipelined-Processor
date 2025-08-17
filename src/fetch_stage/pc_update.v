module pc_update(
    input [31:0] pc,
    input [31:0] pc_jump_addr,
    input [31:0] btb_target_pc,
    input btb_pc_valid,
    input btb_pc_predictTaken,
    input jump_en,
    output [31:0] next_pc
);
    wire [31:0] pc_without_btb;

    assign pc_without_btb = jump_en ? pc_jump_addr : pc + 4;
    assign next_pc = (btb_pc_valid && btb_pc_predictTaken) ? btb_target_pc : pc_without_btb;

endmodule