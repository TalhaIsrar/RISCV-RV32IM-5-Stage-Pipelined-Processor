module register_file (
    input clk,
    input rst,

    input wr_en,
    input [4:0] wr_addr,
    input [31:0] wr_data,

    input [4:0] rs1_addr,
    input [4:0] rs2_addr,

    output wire [31:0] op1,
    output wire [31:0] op2
);
    reg [31:0] reg_file [31:0];

    assign op1 = reg_file[rs1_addr];
    assign op2 = reg_file[rs2_addr];

    // Write operation
    // Rst for entire register file is avoided to prevent extra area after unrolling for loop
    always @(posedge clk) begin
        if (rst) 
            reg_file[0] <= 0; // Register 0 is hardwired to 0
        else if (wr_en && wr_addr != 0) 
            reg_file[wr_addr] <= wr_data;
    end

endmodule