`include "defines.vh"

module forwarding_unit(
    input [31:0] rs1,
    input [31:0] rs2,
    input [31:0] rd_mem,
    input [31:0] rd_wb,
    input reg_file_wr_mem,
    input reg_file_wr_wb,

    output reg [1:0] operand_a_cntl,
    output reg [1:0] operand_b_cntl
);

    always @(*) begin
        if (rs1 == rd_mem && rd_mem != 5'b00000 && reg_file_wr_mem)
            operand_a_cntl = `FORWARD_MEM;
        else if (rs1 == rd_wb && rd_wb != 5'b00000 && reg_file_wr_wb)
            operand_a_cntl = `FORWARD_WB;
        else 
            operand_a_cntl = `FORWARD_ORG;
    end

    always @(*) begin
        if (rs2 == rd_mem && rd_mem != 5'b00000 && reg_file_wr_mem)
            operand_b_cntl = `FORWARD_MEM;
        else if (rs2 == rd_wb && rd_wb != 5'b00000 && reg_file_wr_wb)
            operand_b_cntl = `FORWARD_WB;
        else 
            operand_b_cntl = `FORWARD_ORG;
    end

endmodule