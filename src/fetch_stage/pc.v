module pc(
    input clk,
    input rst,
    input [31:0] next_pc,
    output reg [31:0] pc
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'h00000000; // Reset PC to 0
        end else begin
            pc <= next_pc; // Update PC with the next value
        end
    end

endmodule