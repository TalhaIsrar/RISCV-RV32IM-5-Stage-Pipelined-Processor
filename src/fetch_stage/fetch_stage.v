module fetch_stage(
    input clk,
    input rst,
    output [31:0] instruction,
    output [31:0] pc
);

    wire [31:0] next_pc;
    
    // Instantiate the PC module
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instantiate the PC update module
    pc_update pc_update_inst (
        .pc(pc),
        .next_pc(next_pc)
    );

    // Instantiate the instruction memory module
    instruction_mem instruction_mem_inst (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction(instruction)
    );

endmodule