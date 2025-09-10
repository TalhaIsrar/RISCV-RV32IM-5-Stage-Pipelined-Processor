`include "../defines.vh"

module alu_control(
    input [2:0] func3,
    input [6:0] func7,
    input [6:0] opcode,
    output reg [3:0] ALUControl
);
    // Pre-decode special cases to shorten logic depth
    wire is_sub = func7[5] && opcode[5];
    wire is_sra = func7[5];

    always @(*) begin
        case (opcode)
            `OPCODE_RTYPE,
            `OPCODE_ITYPE: begin
                case (func3)
                    3'b000: ALUControl = is_sub ? `ALU_SUB : `ALU_ADD;
                    3'b001: ALUControl = `ALU_SLL;
                    3'b010: ALUControl = `ALU_SLT;
                    3'b011: ALUControl = `ALU_SLTU;
                    3'b100: ALUControl = `ALU_XOR;
                    3'b101: ALUControl = is_sra ? `ALU_SRA : `ALU_SRL;
                    3'b110: ALUControl = `ALU_OR;
                    3'b111: ALUControl = `ALU_AND;
                    default: ALUControl = `ALU_ADD; // safety fallback
                endcase
            end

            `OPCODE_BTYPE: begin
                case (func3)
                    `BTYPE_BLT,
                    `BTYPE_BGE:   ALUControl = `ALU_SLT;   // signed compare
                    `BTYPE_BLTU,
                    `BTYPE_BGEU:  ALUControl = `ALU_SLTU;  // unsigned compare
                    default:      ALUControl = `ALU_SUB;   // default branch compare
                endcase
            end

            default: ALUControl = `ALU_ADD; // Loads, stores, LUI, AUIPC, etc.
        endcase
    end

endmodule