module ex_mem_pipeline(
    input clk,
    input rst,
    input [31:0] ex_result,
    input [31:0] ex_op2_selected,
    input ex_memory_write,
    input [2:0] ex_memory_load_type,
    input [1:0] ex_memory_store_type,
    input ex_wb_load,

    output reg [31:0] mem_result,
    output reg [31:0] mem_op2_selected,
    output reg mem_memory_write,
    output reg [2:0] mem_memory_load_type,
    output reg [1:0] mem_memory_store_type,
    output reg mem_wb_load  
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_result <= 32'h00000000;
            mem_op2_selected <= 32'h00000000;
            mem_memory_write <= 1'b0;
            mem_memory_load_type <= 3'b111;
            mem_memory_store_type <= 2'b00;
            mem_wb_load <= 1'b0;

        end else begin
            mem_result <= ex_result;
            mem_op2_selected <= ex_op2_selected;
            mem_memory_write <= ex_memory_write;
            mem_memory_load_type <= ex_memory_load_type;
            mem_memory_store_type <= ex_memory_store_type;
            mem_wb_load <= ex_wb_load;
        end
    end

endmodule