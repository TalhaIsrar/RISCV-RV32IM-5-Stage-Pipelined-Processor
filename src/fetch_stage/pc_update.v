module pc_update(
    input [31:0] pc,
    input [31:0] pc_jump_addr,
    input [31:0] btb_target_pc,
    input btb_pc_valid,
    input btb_pc_predictTaken,
    input jump_en,
    output reg [31:0] next_pc
);
    always @* begin
        if (jump_en)
            next_pc = pc_jump_addr;
        else if (btb_pc_valid && btb_pc_predictTaken)
            next_pc = btb_target_pc;
        else
            next_pc = pc + 4; // The next PC value in case Branch Target Buffer doesnt have a valid entry
    end


endmodule