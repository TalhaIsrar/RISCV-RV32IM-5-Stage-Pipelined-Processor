module pc_update(
    input [31:0] pc,
    input [31:0] pc_jump_addr,
    input [31:0] btb_target_pc,
    input btb_pc_valid,
    input btb_pc_predictTaken,
    input jump_en,
    output reg [31:0] next_pc
);
    wire [1:0] selection = {jump_en , btb_pc_valid && btb_pc_predictTaken};
    wire [31:0] pc_plus_4 = pc + 32'h4;

    always @(*) begin
        case (selection)
            2'b11,
            2'b10 : next_pc = pc_jump_addr;
            2'b01 : next_pc = btb_target_pc;
            default : next_pc = pc_plus_4;
        endcase
    end

endmodule