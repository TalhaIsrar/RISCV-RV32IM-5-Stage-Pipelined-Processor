module fetch_stage(
    input clk,
    input rst,
    input pc_en,
    input flush,
    input [31:0] pc_jump_addr,
    input jump_en,
    input [31:0] btb_target_pc,
    input btb_pc_valid,
    input btb_pc_predictTaken,
    output [31:0] instruction,
    output [31:0] pc
);

    wire [31:0] next_pc;
    
    // Instantiate the PC module
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc_en(pc_en),
        .pc(pc)
    );

    // Instantiate the PC update module
    pc_update pc_update_inst (
        .pc(pc),
        .pc_jump_addr(pc_jump_addr),
        .jump_en(jump_en),
        .next_pc(next_pc)
    );

    // Instantiate the instruction memory module
    instruction_mem instruction_mem_inst (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .flush(flush),
        .read_en(pc_en),
        .instruction(instruction)
    );

endmodule