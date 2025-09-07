`include "../defines.vh"

module id_ex_pipeline(
    input clk,
    input rst,
    input pipeline_flush,
    input pipeline_en,

    input id_invalid_inst,
    input [31:0] id_instruction,
    input [31:0] id_pc,
    input [31:0] id_op1,
    input [31:0] id_op2,
    input [31:0] id_immediate,
    input [6:0]  id_opcode,
    input id_alu_src,
    input [6:0]  id_func7,
    input [2:0]  id_func3,
    input id_mem_write,
    input [2:0] id_mem_load_type,
    input [1:0] id_mem_store_type,
    input id_wb_load,
    input id_wb_reg_file,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] id_wb_rd,
    input id_pred_taken,

    output reg ex_invalid_inst,
    output reg [31:0] ex_instruction,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_op1,
    output reg [31:0] ex_op2,
    output reg [31:0] ex_immediate,
    output reg [6:0] ex_opcode,
    output reg ex_alu_src,
    output reg [6:0] ex_func7,
    output reg [2:0] ex_func3,
    output reg ex_mem_write,
    output reg [2:0] ex_mem_load_type,
    output reg [1:0] ex_mem_store_type,
    output reg ex_wb_load,
    output reg ex_wb_reg_file,
    output reg [4:0] ex_rs1,
    output reg [4:0] ex_rs2,
    output reg [4:0] ex_wb_rd,
    output reg ex_pred_taken
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_invalid_inst <= 1'b0;
            ex_instruction <= 32'h00000000;
            ex_pc <= 32'h00000000;
            ex_op1 <= 32'h00000000;
            ex_op2 <= 32'h00000000;
            ex_immediate <= 32'h00000000;
            ex_opcode <= 7'b0000000;
            ex_alu_src <= 1'b0;
            ex_func7 <= 7'b0000000;
            ex_func3 <= 3'b000;
            ex_mem_write <= 1'b0;
            ex_mem_load_type <= 3'b111;
            ex_mem_store_type <= 2'b00;
            ex_wb_load <= 1'b0;
            ex_wb_reg_file <= 1'b0;
            ex_wb_rd <= 5'b00000;
            ex_rs1 <= 5'b00000;
            ex_rs2 <= 5'b00000;
            ex_pred_taken <= 1'b0;
        end else if (pipeline_flush) begin
            ex_invalid_inst <= id_invalid_inst;
            ex_instruction <= id_instruction;
            ex_pc <= ex_pc;
            ex_op1 <= id_op1;
            ex_op2 <= id_op2;
            ex_immediate <= 32'h00000000;
            ex_opcode <= `OPCODE_ITYPE;
            ex_alu_src <= 1'b1;
            ex_func7 <= 7'b0000000;
            ex_func3 <= 3'b000;
            ex_mem_write <= 1'b0;
            ex_mem_load_type <= 3'b111;
            ex_mem_store_type <= 2'b00;
            ex_wb_load <= 1'b0;
            ex_wb_reg_file <= 1'b0;
            ex_wb_rd <= id_wb_rd;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_pred_taken <= 1'b0;
        end else if (pipeline_en) begin
            ex_invalid_inst <= id_invalid_inst;
            ex_instruction <= id_instruction;
            ex_pc <= id_pc;
            ex_op1 <= id_op1;
            ex_op2 <= id_op2;
            ex_immediate <= id_immediate;
            ex_opcode <= id_opcode;
            ex_alu_src <= id_alu_src;
            ex_func7 <= id_func7;
            ex_func3 <= id_func3;
            ex_mem_write <= id_mem_write;
            ex_mem_load_type <= id_mem_load_type;
            ex_mem_store_type <= id_mem_store_type;
            ex_wb_load <= id_wb_load;
            ex_wb_reg_file <= id_wb_reg_file;
            ex_wb_rd <= id_wb_rd;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_pred_taken <= id_pred_taken;
        end
    end

endmodule