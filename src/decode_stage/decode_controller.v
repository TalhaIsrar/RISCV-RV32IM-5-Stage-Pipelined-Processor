module decode_controller (
    input [6:0] opcode,
    output [6:0]ex_opcode,
    output ex_alu_src,
    output mem_signals,
    output wb_signals
);

    assign ex_opcode = opcode;
    assign ex_alu_src  = (opcode == OPCODE_ITYPE ||
                         opcode == OPCODE_ILOAD ||
                         opcode == OPCODE_IJALR);

endmodule