module decode_stage(
    input clk,
    input rst,
    input instruction,
    input pc,

    output wire [31:0] op1,
    output wire [31:0] op2,
    output wire [4:0] rd,
    output wire [11:0] immediate,
    output wire [6:0] pass_opcode
);

    wire [6:0] opcode;
    wire [4:0] rs1, rs2;
    wire i_type;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign immediate = instruction[31:20]; // We will extend by 0 in next stage to reduce size of pipeline buffer

    // Instantiate the controller module
    decode_controller decode_controller_inst (
        .opcode(opcode),
        .ex_opcode(pass_opcode),
        .ex_i_type(i_type),
        .mem_signals(),
        .wb_signals()
    );

    // Instantiate the register file module
    register_file register_file_inst (
        .clk(clk),
        .wr_en(),
        .wr_addr(),
        .wr_data(),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .op1(op1),
        .op2(op2)
    );


endmodule