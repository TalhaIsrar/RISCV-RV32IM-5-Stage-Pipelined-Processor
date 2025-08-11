module if_id_pipeline(
    input clk,
    input rst,
    input [31:0] id_pc,
    input [31:0] id_op1,
    input [31:0] id_op2,
    input [11:0] id_immediate,
    input [6:0]  id_opcode,
    input id_alu_src,
    input [6:0]  id_func7,
    input [2:0]  id_func3,

    output reg [31:0] ex_pc,
    output reg [31:0] ex_op1,
    output reg [31:0] ex_op2,
    output reg [11:0] ex_immediate,
    output reg [6:0] ex_opcode,
    output reg ex_alu_src,
    output reg [6:0] ex_func7,
    output reg [2:0] ex_func3   
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_pc <= 32'h00000000;
            ex_op1 <= 32'h00000000;
            ex_op2 <= 32'h00000000;
            ex_immediate <= 12'h000;
            ex_opcode <= 7'b0000000;
            ex_alu_src <= 1'b0;
            ex_func7 <= 7'b0000000;
            ex_func3 <= 3'b000;
        end else begin
            ex_pc <= id_pc;
            ex_op1 <= id_op1;
            ex_op2 <= id_op2;
            ex_immediate <= id_immediate;
            ex_opcode <= id_opcode;
            ex_alu_src <= id_alu_src;
            ex_func7 <= id_func7;
            ex_func3 <= id_func3;
        end
    end

endmodule