module decode_stage(
    input clk,
    input rst,
    input instruction,
    input pc,

    output wire [31:0] op1,
    output wire [31:0] op2
);

    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;


    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

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