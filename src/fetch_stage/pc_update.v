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

    // The next PC value in case Branch Target Buffer doesnt have a valid entry
    assign pc_without_btb = jump_en ? pc_jump_addr : pc + 4;

    // The final next PC value is the one from BTB if it is valid & the dynamic predictor says to jump
    // Otherwise we use the PC value we calculated before
    assign next_pc = (btb_pc_valid && btb_pc_predictTaken && !jump_en) ? btb_target_pc : pc_without_btb;

endmodule