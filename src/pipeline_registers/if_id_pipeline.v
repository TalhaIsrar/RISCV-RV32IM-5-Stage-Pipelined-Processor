module if_id_pipeline(
    input clk,
    input rst,
    input pipeline_flush,
    input pipeline_en,
    
    input [31:0] if_pc,
    input [31:0] if_instruction,
    input if_pred_taken,
    output reg [31:0] id_pc,
    output [31:0] id_instruction,
    output reg id_pred_taken
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_pc <= 32'h00000000;
            id_pred_taken <= 1'b0;
        end else if (pipeline_flush) begin
            id_pc <= id_pc;
            id_pred_taken <= 1'b0;
        end else if (pipeline_en) begin
            id_pc <= if_pc;
            id_pred_taken <= if_pred_taken;    
        end
    end

    // Instruction is passed directly from fetch stage to decode stage because
    // register already in instruction memory module
    assign id_instruction = if_instruction;

endmodule