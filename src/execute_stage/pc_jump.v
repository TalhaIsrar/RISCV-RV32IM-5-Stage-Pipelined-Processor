`include "../defines.vh"

module pc_jump(
    input [31:0] pc,
    input [31:0] immediate,
    input [31:0] op1,
    input [6:0] opcode,
    input [2:0] func3,
    input [31:0] alu_result,
    input predictedTaken,
    output [31:0] update_pc,
    output [31:0] jump_addr,
    output modify_pc,
    output update_btb
);
    wire [31:0] input_a, input_b;
    wire jump_inst, branch_inst;
    reg jump_en;

    assign jump_inst = (opcode ==`OPCODE_JTYPE) || (opcode ==`OPCODE_IJALR);
    assign branch_inst = (opcode == `OPCODE_BTYPE);

    assign update_btb = jump_inst || branch_inst;

    always @(*) begin
        if (jump_inst)
            jump_en = 1'b1;
        else begin
            if(branch_inst) begin
                case(func3)
                    `BTYPE_BEQ:  jump_en = (alu_result == 0); // SUB
                    `BTYPE_BNE:  jump_en = (alu_result != 0); // SUB 
                    `BTYPE_BLT:  jump_en = (alu_result == 1); // SLT signed
                    `BTYPE_BGE:  jump_en = (alu_result == 0); // SLT signed
                    `BTYPE_BLTU: jump_en = (alu_result == 1); // SLTU unsigned
                    `BTYPE_BGEU: jump_en = (alu_result == 0); // SLTU unsigned
                    default:     jump_en = (alu_result == 0);
                endcase
            end else
                jump_en = 1'b0;
        end  
    end

    assign modify_pc = jump_en ^ predictedTaken;
    
    assign input_a = (opcode == `OPCODE_IJALR) ? op1  & ~32'b1 : pc;
    assign input_b = (opcode == `OPCODE_IJALR) ? immediate & ~32'b1 : immediate;

    assign jump_addr = input_a + input_b;
    assign update_pc = predictedTaken ? pc + 32'h4 : jump_addr;


endmodule