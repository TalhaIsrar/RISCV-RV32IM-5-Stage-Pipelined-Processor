module pc_update(
    input [31:0] pc,
    input [31:0] immediate,
    input [31:0] op1,
    input [6:0] opcode,
    output [31:0] update_pc
);
    wire [31:0] input_a, input_b;

    assign input_a = (opcode == `OPCODE_IJALR) ? op1  & ~32'b1 : pc;
    assign input_b = (opcode == `OPCODE_IJALR) ? immediate & ~32'b1 : immediate;

    assign update_pc = input_a + input_b;

endmodule