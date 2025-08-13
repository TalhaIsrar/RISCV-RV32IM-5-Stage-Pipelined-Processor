`include "../defines.vh"

module pc_jump(
    input [31:0] pc,
    input [31:0] immediate,
    input [31:0] op1,
    input [6:0] opcode,
    input [2:0] func3,
    input [31:0] alu_result,
    output [31:0] update_pc,
    output reg modify_pc
);
    wire [31:0] input_a, input_b;
    wire jump_inst, branch_inst;

    assign input_a = (opcode == `OPCODE_IJALR) ? op1  & ~32'b1 : pc;
    assign input_b = (opcode == `OPCODE_IJALR) ? immediate & ~32'b1 : immediate;

    assign update_pc = input_a + input_b;
    
    assign jump_inst = (opcode ==`OPCODE_JTYPE) || (opcode ==`OPCODE_IJALR);
    assign branch_inst = (opcode == `OPCODE_BTYPE);

    always @(*) begin
        if (jump_inst)
            modify_pc = 1'b1;
        else begin
            if(branch_inst) begin
                case(func3)
                    `BTYPE_BEQ:  modify_pc = (alu_result == 0); // SUB
                    `BTYPE_BNE:  modify_pc = (alu_result != 0); // SUB 
                    `BTYPE_BLT:  modify_pc = (alu_result == 1); // SLT signed
                    `BTYPE_BGE:  modify_pc = (alu_result == 0); // SLT signed
                    `BTYPE_BLTU: modify_pc = (alu_result == 1); // SLTU unsigned
                    `BTYPE_BGEU: modify_pc = (alu_result == 0); // SLTU unsigned
                    default:     modify_pc = (alu_result == 0);
                endcase
            end else
                modify_pc = 1'b0;
        end  
    end

endmodule