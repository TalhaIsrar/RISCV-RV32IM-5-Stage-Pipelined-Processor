module register_file (
    input clk,

    input wr_en,
    input [4:0] wr_addr,
    input [31:0] wr_data,

    input [4:0] rs1_addr,
    input [4:0] rs2_addr,

    output wire [31:0] op1,
    output wire [31:0] op2
);
    reg [31:0] reg_file [31:0];

    // x0 is hardwired to 0
    assign op1 = (rs1_addr == 0) ? 32'b0 : reg_file[rs1_addr];
    assign op2 = (rs2_addr == 0) ? 32'b0 : reg_file[rs2_addr];

    // Write operation
    always @(posedge clk) begin
        if (wr_en && wr_addr != 0)
            reg_file[wr_addr] <= wr_data;
    end


endmodule