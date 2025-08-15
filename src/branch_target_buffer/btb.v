`include "../defines.vh"

module btb(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] update_pc,
    input update,
    
    input [31:0] update_target,
    input mispredicted,

    output [31:0] target_pc,
    output valid,
    output predictedTaken
);

    wire [2:0] read_index;
    wire [26:0] read_tag;
    wire [127:0] read_set;
    
    // LRU Signals
    wire [7:0] LRU;
    wire next_LRU_read;



    // PC (32 bits) = Tag (27 bits) + Index (3 bits) + Byte offset (2 bits)
    assign read_index = pc[4:2];
    assign read_tag = pc[31:5];


    lru_reg lru_reg_inst(
        .clk(clk),
        .rst(rst),
        .LRU_updated(),
        .LRU_modify(),
        .LRU(LRU)
    );

    btb_file btb_file_inst(
        .clk(clk),
        .read_index(read_index),
        .update_index(),
        .write_index(),
        .write_set(),
        .write_en(),
        .read_set(read_set),
        .update_set()
    );

    btb_read btb_read_inst(
        .read_set(read_set),
        .lru(LRU),
        .read_tag(read_tag),
        .next_LRU_read(next_LRU_read),
        .valid(valid),
        .predictedTaken(predictedTaken),
        .target(target)
    );

    dynamic_branch_predictor dynamic_branch_predictor_inst1(
        .current_state(),
        .mispredicted(),
        .next_state()
    );

    dynamic_branch_predictor dynamic_branch_predictor_inst2(
        .current_state(),
        .mispredicted(),
        .next_state()
    );

endmodule