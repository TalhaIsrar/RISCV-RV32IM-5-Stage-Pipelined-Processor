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
    output invalid_inst,
    output m_type_inst
);
    wire r_type_inst;
    wire i_type_inst;
    wire wb_inst;
    wire u_type_inst;
    wire b_type_inst;
    wire j_type_inst;
    wire aupic_inst;
    wire jalr_inst;

    assign wb_inst = (opcode == `OPCODE_RTYPE);
    assign r_type_inst = (wb_inst && (func7 == `FUNC7_ADD || func7 == `FUNC7_SUB));
    assign i_type_inst = (opcode == `OPCODE_ITYPE);
    assign mem_write = (opcode == `OPCODE_STYPE);
    assign wb_load = (opcode == `OPCODE_ILOAD);
    assign m_type_inst = (wb_inst && (func7 == `FUNC7_M_UNIT));
    assign u_type_inst = (opcode == `OPCODE_UTYPE);
    assign b_type_inst = (opcode == `OPCODE_BTYPE);
    assign j_type_inst = (opcode == `OPCODE_JTYPE);
    assign aupic_inst = ( opcode == `OPCODE_AUIPC);
    assign jalr_inst = (opcode == `OPCODE_IJALR);

    assign ex_alu_src  = i_type_inst || wb_load || mem_write ||
                          u_type_inst ||aupic_inst || jalr_inst;

    assign wb_reg_file  = wb_inst || i_type_inst || wb_load ||
                          u_type_inst ||aupic_inst || jalr_inst || j_type_inst;
                         
    assign invalid_inst = !(r_type_inst || ex_alu_src ||
                            b_type_inst || j_type_inst);

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