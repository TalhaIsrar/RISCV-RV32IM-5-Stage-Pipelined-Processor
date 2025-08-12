`include "defines.vh"

module alu_control(
    input [2:0] func3,
    input [6:0] func7,
    input [1:0] ALUOp,
    output [3:0] alu_ctrl
);

    reg [3:0] ALUControl;

    // ALU control (funct-based)
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = ALU_ADD;  // Load/Store use ADD
            2'b01: ALUControl = ALU_SUB;  // Branch compare
            2'b10: begin                  // R-type / I-type
                case (funct3)
                    3'b000: ALUControl = (funct7[5] & opcode[5]) ? ALU_SUB : ALU_ADD;
                    3'b001: ALUControl = ALU_SLL;
                    3'b010: ALUControl = ALU_SLT;
                    3'b011: ALUControl = ALU_SLTU;
                    3'b100: ALUControl = ALU_XOR;
                    3'b101: ALUControl = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    3'b110: ALUControl = ALU_OR;
                    3'b111: ALUControl = ALU_AND;
                endcase
            end
            default: ALUControl = ALU_ADD;
        endcase
    end


endmodule