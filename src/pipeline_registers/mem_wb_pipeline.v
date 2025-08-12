module mem_wb_pipeline(
    input clk,
    input rst,
    input mem_wb_load      
    input [31:0] mem_read_data,
    input [31:0] mem_calculated_result,
    output reg [31:0] wb_read_data,
    output reg [31:0] wb_calculated_result,
    output reg wb_load
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_load <= 1'b0;
            wb_read_data <= 32'h00000000;
            wb_calculated_result <= 32'h00000000;
        end else begin
            wb_load <= mem_wb_load;
            wb_read_data <= mem_read_data;
            wb_calculated_result <= mem_calculated_result;
        end
    end

endmodule