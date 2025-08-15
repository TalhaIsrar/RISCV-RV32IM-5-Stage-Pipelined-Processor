module lru_reg(
    input clk,
    input rst,
    input [7:0] LRU_updated,

    output reg [7:0] LRU
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LRU <= 8'h00; // Reset LRU to 0
        end else begin
            LRU <= LRU_updated;
        end
    end

endmodule