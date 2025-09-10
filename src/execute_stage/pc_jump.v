`include "../defines.vh"

module pc_jump(
    input [31:0] pc,
    input [31:0] immediate,
    input [31:0] op1,
    input [6:0] opcode,
    input [2:0] func3,
    input lt_flag,
    input ltu_flag,
    input zero_flag,
    input predictedTaken,
    output [31:0] update_pc,
    output [31:0] jump_addr,
    output modify_pc,
    output update_btb
);
    wire [31:0] input_a, input_b;
    wire jump_inst, branch_inst;
    wire jalr_inst;
    wire branch_taken;
    wire jump_en;

    assign jalr_inst = opcode ==`OPCODE_IJALR;
    assign jump_inst = (opcode ==`OPCODE_JTYPE) || jalr_inst;
    assign branch_inst = (opcode == `OPCODE_BTYPE);

    assign update_btb = jump_inst || branch_inst;

    // Compute branch/jump enable
    wire beq  = (func3 == `BTYPE_BEQ);
    wire bne  = (func3 == `BTYPE_BNE);
    wire blt  = (func3 == `BTYPE_BLT);
    wire bge  = (func3 == `BTYPE_BGE);
    wire bltu = (func3 == `BTYPE_BLTU);
    wire bgeu = (func3 == `BTYPE_BGEU);

    assign branch_taken = (beq  &&  zero_flag) ||
                        (bne  && ~zero_flag) ||
                        (blt  &&  lt_flag)   ||
                        (bge  && ~lt_flag)   ||
                        (bltu &&  ltu_flag)  ||
                        (bgeu && ~ltu_flag);

    assign jump_en = jump_inst || (branch_inst && branch_taken);

    assign modify_pc = jump_en ^ predictedTaken;
    
    assign input_a = jalr_inst ? op1  & ~32'b1 : pc;
    assign input_b = jalr_inst ? immediate & ~32'b1 : immediate;

    assign jump_addr = input_a + input_b;
    assign update_pc = predictedTaken ? pc + 32'h4 : jump_addr;


endmodule