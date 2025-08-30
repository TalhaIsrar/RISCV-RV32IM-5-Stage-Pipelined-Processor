module execute_stage(
    input [31:0] pc,
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] immediate,
    input [6:0] func7,
    input [2:0] func3,
    input [6:0] opcode,
    input ex_alu_src,
    input predictedTaken,
    input invalid_inst,
    
    input [1:0] operand_a_forward_cntl,
    input [1:0] operand_b_forward_cntl,
    input [31:0] data_forward_mem,
    input [31:0] data_forward_wb,

    output wire [31:0] result,
    output wire [31:0] op1_selected,
    output wire [31:0] op2_selected,
    output wire [31:0] pc_jump_addr,
    output wire jump_en,
    output wire update_btb,
    output wire [31:0] calc_jump_addr
);

    wire [3:0] ALUControl;
    reg [31:0] op1_forwarded;
    reg [31:0] op2_forwarded;
    reg [31:0] op1_alu;
    reg [31:0] op2_alu;

    // Mux for forwarding operand 1
    always @(*) begin
        case (operand_a_forward_cntl)
            `FORWARD_ORG: op1_forwarded = op1;
            `FORWARD_MEM: op1_forwarded = data_forward_mem;
            `FORWARD_WB:  op1_forwarded = data_forward_wb;
            default:      op1_forwarded = op1;
        endcase
    end

    // Mux for forwarding operand 2
    always @(*) begin
        case (operand_b_forward_cntl)
            `FORWARD_ORG: op2_forwarded = op2;
            `FORWARD_MEM: op2_forwarded = data_forward_mem;
            `FORWARD_WB:  op2_forwarded = data_forward_wb;
            default:      op2_forwarded = op2;
        endcase
    end

    // Pass op2 directly to pipeline stage in case it is used for Load instruction
    // Forwarded outputs are also used in the M unit to avoid data hazards
    assign op2_selected = op2_forwarded;
    assign op1_selected = op1_forwarded;

    // Based on instruction type select data to write into rd later
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
            `OPCODE_UTYPE: begin
                op1_alu = 32'h00000000;
                op2_alu = immediate;
            end
            `OPCODE_AUIPC: begin
                op1_alu = pc;
                op2_alu = immediate;
            end
            default: begin
                op1_alu = invalid_inst ? 0 : op1_forwarded;
                op2_alu = ex_alu_src ? immediate : op2_forwarded;
            end      
        endcase
    end
    

    // Instantiate the PC Jump Module
    pc_jump pc_jump_inst (
        .pc(pc),
        .immediate(immediate),
        .op1(op1_forwarded),
        .opcode(opcode),
        .func3(func3),
        .alu_result(result),
        .predictedTaken(predictedTaken),
        .update_pc(pc_jump_addr),
        .jump_addr(calc_jump_addr),
        .modify_pc(jump_en),
        .update_btb(update_btb)
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