`include "../defines.vh"

module alu(
    input [31:0] op1,
    input [31:0] op2,
    input [3:0] ALUControl,

    output reg [31:0] result,
    output lt_flag,   // signed comparison
    output ltu_flag,  // unsigned comparison
    output zero_flag  // result == 0
);
    assign lt_flag = $signed(op1) < $signed(op2);
    assign ltu_flag = op1 < op2;

    always @(*) begin
        case (ALUControl)
            `ALU_ADD:  result = op1 + op2;
            `ALU_SUB:  result = op1 - op2;
            `ALU_AND:  result = op1 & op2;
            `ALU_OR:   result = op1 | op2;
            `ALU_XOR:  result = op1 ^ op2;
            `ALU_SLL:  result = op1 << op2[4:0];    // Shift left logical - lower 5 bits used according to RISCV Spec
            `ALU_SRL:  result = op1 >> op2[4:0];    // Shift right logical
            `ALU_SRA:  result = $signed(op1) >>> op2[4:0];   // Shift right arithmetic
            `ALU_SLT:  result = lt_flag ? 32'd1 : 32'd0;
            `ALU_SLTU: result = ltu_flag ? 32'd1 : 32'd0;
            default:  result = 32'b0;
        endcase
    end

    assign zero_flag = (result == 32'b0);

endmodule