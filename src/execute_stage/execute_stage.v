module execute_stage(
    input [31:0] op1,
    input [31:0] op2,
    input [11:0] immediate,
    input [6:0] func7,
    input [2:0] func3,
    input [1:0] ALUOp,
    input ex_alu_src,
    output wire [31:0] result,
    output wire [31:0] op2_selected
);

    wire [3:0] alu_ctrl;

    wire [31:0] immediate_extended = {{20{immediate[11]}}, immediate}; //  Sign extend the immediate for I Type
    assign op2_selected = ex_alu_src ? immediate_extended : op2;

    // Instantiate the ALU Controller
    alu_control alu_control_inst (
        .func3(func3),
        .func7(func7),
        .ALUOp(ALUOp),
        .alu_ctrl(alu_ctrl)
    );   

    // Instantiate the ALU module
    alu alu_inst (
        .op1(op1),
        .op2(op2_selected),
        .alu_ctrl(alu_ctrl),
        .result(result)
    );

endmodule