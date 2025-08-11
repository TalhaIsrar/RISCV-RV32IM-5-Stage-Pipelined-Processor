module decode_controller (
    input [6:0] opcode,
    input [2:0] func3,
    output [6:0] ex_opcode,
    output ex_alu_src,
    output mem_write,
    output reg [2:0] mem_load_type,
    output reg [1:0] mem_store_type,
    output wb_load
);

    assign ex_opcode = opcode;
    assign ex_alu_src  = (opcode == OPCODE_ITYPE ||
                         opcode == OPCODE_ILOAD ||
                         opcode == OPCODE_IJALR);

    assign mem_write = (opcode == OPCODE_STYPE);
    assign wb_load = (opcode == OPCODE_ILOAD);
    
    always @(*) begin
        mem_store_type = 2'b11; // Disable writing
        if (mem_write) begin
            case (func3)
                3'b000: mem_store_type = 2'b00;
                3'b001: mem_store_type = 2'b01;
                3'b010: mem_store_type = 2'b10;
                default: mem_store_type = 2'b11; // Disable writing
            endcase
        end
    end

    always @(*) begin
        mem_load_type = 3'b111; // Load full value
        if (wb_load) begin
            case (func3)
                3'b000: mem_load_type = 3'b000;
                3'b001: mem_load_type = 3'b001;
                3'b010: mem_load_type = 3'b010;
                3'b100: mem_load_type = 3'b011;
                3'b101: mem_load_type = 3'b100;
                default: mem_load_type = 3'b111; // Load full value
            endcase
        end
    end

endmodule