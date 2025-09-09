`include "../defines.vh"

module alu_control(
    input [2:0] func3,
    input [6:0] func7,
    input [6:0] opcode,
    output reg [3:0] ALUControl
);

    reg [1:0] ALUOp;

    // Main control (opcode-based)
    wire is_alu    = (opcode == `OPCODE_RTYPE) || (opcode == `OPCODE_ITYPE);
    wire is_branch = (opcode == `OPCODE_BTYPE);

    always @(*) begin
        if (is_alu)       ALUOp = 2'b10;
        else if (is_branch) ALUOp = 2'b01;
        else              ALUOp = 2'b00;
    end

    // ALU control (funct-based)
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = `ALU_ADD;  // Load/Store/LUI use ADD
            2'b01: begin
                case (func3)
                    `BTYPE_BLT:  ALUControl  = `ALU_SLT; // SLT signed
                    `BTYPE_BGE:  ALUControl  = `ALU_SLT; // SLT signed
                    `BTYPE_BLTU: ALUControl  = `ALU_SLTU; // SLTU unsigned
                    `BTYPE_BGEU: ALUControl  = `ALU_SLTU; // SLTU unsigned
                    default:     ALUControl = `ALU_SUB; // SUB
                endcase
            end
            
            2'b10: begin                  // R-type / I-type
                case (func3)
                    3'b000: ALUControl = (func7[5] & opcode[5]) ? `ALU_SUB : `ALU_ADD;
                    3'b001: ALUControl = `ALU_SLL;
                    3'b010: ALUControl = `ALU_SLT;
                    3'b011: ALUControl = `ALU_SLTU;
                    3'b100: ALUControl = `ALU_XOR;
                    3'b101: ALUControl = (func7[5]) ? `ALU_SRA : `ALU_SRL;
                    3'b110: ALUControl = `ALU_OR;
                    3'b111: ALUControl = `ALU_AND;
                endcase
            end
            default: ALUControl = `ALU_ADD;
        endcase
    end


endmodule