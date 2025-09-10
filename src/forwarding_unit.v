`include "defines.vh"

module forwarding_unit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd_mem,
    input [4:0] rd_wb,
    input reg_file_wr_mem,
    input reg_file_wr_wb,

    output reg [1:0] operand_a_cntl,
    output reg [1:0] operand_b_cntl
);

    wire valid_rd_mem;
    wire valid_rd_wb;

    wire valid_rs1_mem;
    wire valid_rs1_wb;
    wire valid_rs2_mem;
    wire valid_rs2_wb;

    assign valid_rd_mem = rd_mem != 5'b00000 && reg_file_wr_mem;
    assign valid_rd_wb = rd_wb != 5'b00000 && reg_file_wr_wb;

    assign valid_rs1_mem = rs1 == rd_mem && valid_rd_mem;
    assign valid_rs1_wb = rs1 == rd_wb && valid_rd_wb;
    assign valid_rs2_mem = rs2 == rd_mem && valid_rd_mem;
    assign valid_rs2_wb = rs2 == rd_wb && valid_rd_wb;

    always @(*) begin
        operand_a_cntl = valid_rs1_mem ? `FORWARD_MEM :
                        valid_rs1_wb  ? `FORWARD_WB  :
                                        `FORWARD_ORG;

        operand_b_cntl = valid_rs2_mem ? `FORWARD_MEM :
                        valid_rs2_wb  ? `FORWARD_WB  :
                                        `FORWARD_ORG;
    end

endmodule