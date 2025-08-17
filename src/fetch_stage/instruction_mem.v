module instruction_mem(
    input clk,
    input rst,
    input [31:0] pc,
    input read_en,
    input flush,
    output reg [31:0] instruction
);

    // Memory array to hold instructions
    reg [31:0] mem [0:255]; // 1KB memory

    // Initialize memory using file
    initial begin
        $readmemh("C:\\Users\\Talha\\Documents\\vivado\\riscv_rv32i_5_stage_pipeline_processor\\programs\\instructions.hex", mem);
    end

    always @(posedge clk) begin
        if (rst) begin
            instruction <= 32'h00000000; // Reset instruction to NOP
        end else if (flush) begin
            instruction <= 32'h00000013; // Flush instruction to NOP
        end else if (read_en) begin
            instruction <= mem[pc[11:2]]; // Fetch instruction based on PC
        end
    end
endmodule