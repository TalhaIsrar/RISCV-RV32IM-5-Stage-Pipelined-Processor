module decode_stage(
    input clk,
    input rst,
    input instruction,
    input pc,

    output wire [31:0] op1,
    output wire [31:0] op2,
    output wire [4:0] rd,
    output wire [11:0] immediate,
    output wire [6:0] pass_opcode,
    output wire alu_src,
    output wire [6:0] func7,
    output wire [2:0] func3,
    output wire mem_write,
    output wire [2:0] mem_load_type,
    output wire[1:0] mem_store_type,
    output wire wb_load
);

    wire [6:0] opcode;
    wire [4:0] rs1, rs2;
    
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign immediate = instruction[31:20]; // We will extend by 0 in next stage to reduce size of pipeline buffer
    assign func7 = instruction[31:25];
    assign func3 = instruction[14:12];


    // Instantiate the controller module
    decode_controller decode_controller_inst (
        .opcode(opcode),
        .func3(func3),
        .ex_opcode(pass_opcode),
        .ex_alu_src(alu_src),
        .mem_write(mem_write),
        .mem_load_type(mem_load_type),
        .mem_store_type(mem_store_type),
        .wb_load(wb_load)
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