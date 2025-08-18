`include "defines.vh"

module hazard_unit(
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [6:0] opcode,
    input [4:0] ex_rd,
    input ex_load_inst,
    input jump_branch_taken,
    input invalid_inst,

    output reg if_id_pipeline_flush,
    output reg if_id_pipeline_en,
    output reg id_ex_pipeline_flush,
    output reg pc_en
);

    wire id_rs1_used;
    wire id_rs2_used;

    // For load we need to check if rs1 or rs2 is actually used in the instruction
    assign id_rs1_used  = (opcode == `OPCODE_RTYPE ||
                         opcode == `OPCODE_ITYPE ||
                         opcode == `OPCODE_ILOAD ||
                         opcode == `OPCODE_IJALR ||
                         opcode == `OPCODE_STYPE ||
                         opcode == `OPCODE_BTYPE);

    assign id_rs2_used  = (opcode == `OPCODE_RTYPE ||
                         opcode == `OPCODE_STYPE ||
                         opcode == `OPCODE_BTYPE);

    // At one time only 1 of `ex_load_inst` or `jump_branch_taken` will be true
    always @(*) begin
        //  Default values to avoid latch
        if_id_pipeline_flush = 1'b0;
        if_id_pipeline_en = 1'b1;
        id_ex_pipeline_flush = 1'b0;
        pc_en = 1'b1;

        // Jump/Branch taken flush - 2 Stall
        if (jump_branch_taken) begin
            if_id_pipeline_flush = 1'b1;
            if_id_pipeline_en = 1'b0;
            id_ex_pipeline_flush = 1'b1;
            pc_en = 1'b1;

        // Load flush - 1 Stall
        end else if (ex_load_inst && ex_rd != 5'b00000) begin
            if (((id_rs1 == ex_rd) && id_rs1_used) || ((id_rs2 == ex_rd) && id_rs2_used)) begin
                if_id_pipeline_flush = 1'b0;
                if_id_pipeline_en = 1'b0;
                id_ex_pipeline_flush = 1'b1;
                pc_en = 1'b0;
            end
        end

        else if (invalid_inst) begin
            if_id_pipeline_flush = 1'b0;
            if_id_pipeline_en = 1'b1;
            id_ex_pipeline_flush = 1'b1;
            pc_en = 1'b1;            
        end
    end

endmodule