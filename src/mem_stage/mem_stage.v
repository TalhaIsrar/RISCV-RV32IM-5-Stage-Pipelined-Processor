module mem_stage(
    input clk,
    input rst,
    input [31:0] result,
    input [31:0] op2_data,
    input mem_write
    input [1:0] store_type,
    input [2:0] load_type,
    output wire [31:0] read_data
);


    // Instantiate the Data Memory
    data_mem data_mem_inst (
        .clk(clk),
        .rst(rst),
        .mem_write()
        .store_type(),
        .load_type(),
        .addr(result[11:0]),
        .write_data(op2_data),
        .read_data(read_data)
    );   

endmodule