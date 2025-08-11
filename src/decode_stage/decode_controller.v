module decode_controller (
    input [6:0] opcode,
    output [6:0]ex_opcode,
    output ex_i_type,
    output mem_signals,
    output wb_signals
);

    assign ex_opcode = opcode;
    assign ex_i_type  = (opcode == OPCODE_ITYPE ||
                         opcode == OPCODE_ILOAD ||
                         opcode == OPCODE_IJALR);

endmodule