module writeback_stage(
    input wb_load,
    input [31:0] mem_read_data,
    input [31:0] alu_result,

    output [31:0] wb_result
);
    assign wb_result = wb_load ? mem_read_data : alu_result;

endmodule