module pc(
    input clk,
    input rst,
    input [31:0] next_pc,
    input pc_en,
    output reg [31:0] pc
);

    // Next PC Register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'h00000000; // Reset PC to 0
        end else if (pc_en) begin
            pc <= next_pc; // Update PC with the next value
        end else begin
            pc <= pc;
        end
    end

endmodule