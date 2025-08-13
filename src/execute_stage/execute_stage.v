module execute_stage(
    input [31:0] pc,
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] immediate,
    input [6:0] func7,
    input [2:0] func3,
    input [6:0] opcode,
    input ex_alu_src,
    output wire [31:0] result,
    output reg [31:0] op2_selected,
    output wire [31:0] pc_jump_addr,
    output wire jump_en
);

    wire [3:0] ALUControl;
    reg [31:0] op1_alu;
    reg [31:0] op2_alu;

    assign op2_selected = op2;

    always @(*) begin
        case (opcode)
            `OPCODE_IJALR: begin
                op1_alu = pc;
                op2_alu = 32'd4;
            end
            `OPCODE_JTYPE: begin
                op1_alu = pc;
                op2_alu = 32'd4;
            end
            default: begin
                op1_alu = op1;
                op2_alu = ex_alu_src ? immediate : op2;
            end      
        endcase
    end

    // Instantiate the PC Jump Module
    pc_jump pc_jump_inst (
        .pc(pc),
        .immediate(immediate),
        .op1(op1),
        .opcode(opcode),
        .func3(func3),
        .alu_result(result),
        .update_pc(pc_jump_addr),
        .modify_pc(jump_en)
    );

    // Instantiate the ALU Controller
    alu_control alu_control_inst (
        .func3(func3),
        .func7(func7),
        .opcode(opcode),
        .ALUControl(ALUControl)
    );   

    // Instantiate the ALU module
    alu alu_inst (
        .op1(op1_alu),
        .op2(op2_alu),
        .ALUControl(ALUControl),
        .result(result)
    );

endmodule