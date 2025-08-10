module instruction_mem(
    input clk,
    input rst,
    input [31:0] pc,
    output reg [31:0] instruction
);

    // Memory array to hold instructions
    reg [31:0] mem [0:1023]; // 4KB memory

    // Initialize memory using file
    initial begin
        $readmemh("instructions.hex", mem);
    end

    always @(posedge clk) begin
        if (rst) begin
            instruction <= 32'h00000000; // Reset instruction to NOP
        end else begin
            instruction <= mem[pc[11:2]]; // Fetch instruction based on PC
        end
    end
endmodule