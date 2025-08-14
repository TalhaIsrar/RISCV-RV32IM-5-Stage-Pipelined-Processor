module if_id_pipeline(
    input clk,
    input rst,
    input pipeline_flush,
    input pipeline_en,
    
    input [31:0] if_pc,
    input [31:0] if_instruction,
    output reg [31:0] id_pc,
    output [31:0] id_instruction
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_pc <= 32'h00000000;
        end else if (pipeline_flush) begin
            id_pc <= 32'h00000013;      // Push NOP into pipeline
        end else if (pipeline_en) begin
            id_pc <= if_pc;    
        end
    end

    // Instruction is passed directly from fetch stage to decode stage because
    // register already in instruction memory module
    assign id_instruction = if_instruction;

endmodule