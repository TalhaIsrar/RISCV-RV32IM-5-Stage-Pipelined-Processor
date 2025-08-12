module execute_stage(
    input [31:0] op1,
    input [31:0] op2,
    input [11:0] immediate,
    input [6:0] func7,
    input [2:0] func3,
    input [6:0] opcode,
    input ex_alu_src,
    output wire [31:0] result,
    output wire [31:0] op2_selected
);

    wire [3:0] ALUControl;
    wire [31:0] op2_alu;

    wire [31:0] immediate_extended = {{20{immediate[11]}}, immediate}; //  Sign extend the immediate for I Type
    assign op2_alu = ex_alu_src ? immediate_extended : op2;
    assign op2_selected = op2;

    // Instantiate the ALU Controller
    alu_control alu_control_inst (
        .func3(func3),
        .func7(func7),
        .opcode(opcode),
        .ALUControl(ALUControl)
    );   

    // Instantiate the ALU module
    alu alu_inst (
        .op1(op1),
        .op2(op2_alu),
        .ALUControl(ALUControl),
        .result(result)
    );

endmodule