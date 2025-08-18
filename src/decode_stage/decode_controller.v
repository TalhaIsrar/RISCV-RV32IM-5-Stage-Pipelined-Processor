`include "../defines.vh"

module decode_controller (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output ex_alu_src,
    output mem_write,
    output reg [2:0] mem_load_type,
    output reg [1:0] mem_store_type,
    output wb_load,
    output wb_reg_file,
    output invalid_inst
);
    wire r_type_inst;
    wire i_type_inst;

    assign r_type_inst = (opcode == `OPCODE_RTYPE && (func7 == `FUNC7_ADD || func7 == `FUNC7_SUB));
    assign i_type_inst = (opcode == `OPCODE_ITYPE && (func7 == `FUNC7_ADD || func7 == `FUNC7_SUB));

    assign ex_alu_src  = (opcode == `OPCODE_ITYPE ||
                         opcode == `OPCODE_ILOAD ||
                         opcode == `OPCODE_STYPE ||
                         opcode == `OPCODE_UTYPE ||
                         opcode == `OPCODE_AUIPC ||
                         opcode == `OPCODE_IJALR);

    assign mem_write = (opcode == `OPCODE_STYPE);
    assign wb_load = (opcode == `OPCODE_ILOAD);
    
    assign wb_reg_file  = (opcode == `OPCODE_RTYPE ||
                         opcode == `OPCODE_UTYPE ||
                         opcode == `OPCODE_ITYPE ||
                         opcode == `OPCODE_ILOAD ||
                         opcode == `OPCODE_IJALR ||
                         opcode == `OPCODE_AUIPC ||
                         opcode == `OPCODE_JTYPE);
                         
    assign invalid_inst = !(r_type_inst || (opcode == `OPCODE_UTYPE) || wb_load || 
                            i_type_inst || (opcode == `OPCODE_IJALR) || mem_write ||
                            (opcode == `OPCODE_AUIPC) || (opcode == `OPCODE_BTYPE) || (opcode == `OPCODE_JTYPE));

    always @(*) begin
        mem_store_type = `STORE_DEF; // Disable writing
        if (mem_write) begin
            case (func3)
                3'b000: mem_store_type = `STORE_SB;
                3'b001: mem_store_type = `STORE_SH;
                3'b010: mem_store_type = `STORE_SW;
                default:mem_store_type = `STORE_DEF; // Disable writing
            endcase
        end
    end

    always @(*) begin
        mem_load_type = `LOAD_DEF; // Load full value
        if (wb_load) begin
            case (func3)
                3'b000: mem_load_type = `LOAD_LB;
                3'b001: mem_load_type = `LOAD_HD;
                3'b010: mem_load_type = `LOAD_LW;
                3'b100: mem_load_type = `LOAD_LBU;
                3'b101: mem_load_type = `LOAD_LHU;
                default:mem_load_type = `LOAD_DEF; // Load full value
            endcase
        end
    end

endmodule