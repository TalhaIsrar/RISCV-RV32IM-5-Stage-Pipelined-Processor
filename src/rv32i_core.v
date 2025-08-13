module rv32i_core(
    input clk,
    input rst
);
    wire [31:0] ex_if_pc_jump_addr;
    wire ex_jump_en;

    // IF/ID Connection
    wire [31:0] if_instruction, id_instruction;
    wire [31:0] if_pc, id_pc;

    // ID/EX Connection
    wire [31:0] ex_pc;
    wire [31:0] id_op1, ex_op1;
    wire [31:0] id_op2, ex_op2;
    wire [4:0]  id_wb_rd, ex_wb_rd;
    wire [31:0] id_immediate, ex_immediate;
    wire [6:0]  id_opcode, ex_opcode;
    wire        id_alu_src, ex_alu_src;
    wire [6:0]  id_func7, ex_func7;
    wire [2:0]  id_func3, ex_func3;
    wire        id_mem_write, ex_mem_write;
    wire [2:0]  id_mem_load_type, ex_mem_load_type;
    wire [1:0]  id_mem_store_type, ex_mem_store_type;
    wire        id_wb_load, ex_wb_load;
    wire        id_wb_reg_file, ex_wb_reg_file;

    // EX/MEM Conncetion
    wire [31:0] ex_result, mem_result;
    wire [31:0] ex_op2_selected, mem_op2_selected;
    wire [4:0]  mem_wb_rd;
    wire        mem_memory_write;
    wire [2:0]  mem_memory_load_type;
    wire [1:0]  mem_memory_store_type;
    wire        mem_wb_load;
    wire        mem_wb_reg_file;

    // MEM/WB Connection
    wire [31:0] mem_read_data, wb_read_data;
    wire [31:0] mem_calculated_result, wb_calculated_result;
    wire [4:0]  wb_rd;
    wire        wb_reg_file;
    wire        wb_load;
    wire [31:0] wb_result;


    // Instantiate the Fetch stage module
    fetch_stage fetch_stage_inst (
        .clk(clk),
        .rst(rst),
        .pc_jump_addr(ex_if_pc_jump_addr),
        .jump_en(ex_if_jump_en),
        .instruction(if_instruction),
        .pc(if_pc)
    );

    // Instantiate the IF/ID pipeline module
    if_id_pipeline if_id_pipeline_inst (
        .clk(clk),
        .rst(rst),
        .if_pc(if_pc),
        .if_instruction(if_instruction),
        .id_pc(id_pc),
        .id_instruction(id_instruction)
    );

    // Instantiate the Decode stage module
    decode_stage decode_stage_inst (
        .clk(clk),
        .rst(rst),
        .instruction(id_instruction),
        .reg_file_wr_en(wb_reg_file),   // Come from WB stage
        .reg_file_wr_addr(wb_rd), // Come from WB stage
        .reg_file_wr_data(wb_result), // Come from WB stage
        .op1(id_op1),
        .op2(id_op2),
        .rd(id_wb_rd),
        .immediate(id_immediate),
        .opcode(id_opcode),
        .alu_src(id_alu_src),
        .func7(id_func7),
        .func3(id_func3),
        .mem_write(id_mem_write),
        .mem_load_type(id_mem_load_type),
        .mem_store_type(id_mem_store_type),
        .wb_load(id_wb_load),
        .wb_reg_file(id_wb_reg_file)
    );

    // Instantiate the ID/EX pipeline module
    id_ex_pipeline id_ex_pipeline_inst (
        .clk(clk),
        .rst(rst),
        .id_pc(id_pc),
        .id_op1(id_op1),
        .id_op2(id_op2),
        .id_immediate(id_immediate),
        .id_opcode(id_opcode),
        .id_alu_src(id_alu_src),
        .id_func7(id_func7),
        .id_func3(id_func3),
        .id_mem_write(id_mem_write),
        .id_mem_load_type(id_mem_load_type),
        .id_mem_store_type(id_mem_store_type),
        .id_wb_load(id_wb_load),
        .id_wb_reg_file(id_wb_reg_file),
        .id_wb_rd(id_wb_rd),

        .ex_pc(ex_pc),
        .ex_op1(ex_op1),
        .ex_op2(ex_op2),
        .ex_immediate(ex_immediate),
        .ex_opcode(ex_opcode),
        .ex_alu_src(ex_alu_src),
        .ex_func7(ex_func7),
        .ex_func3(ex_func3),
        .ex_mem_write(ex_mem_write),
        .ex_mem_load_type(ex_mem_load_type),
        .ex_mem_store_type(ex_mem_store_type),
        .ex_wb_load(ex_wb_load),
        .ex_wb_reg_file(ex_wb_reg_file),
        .ex_wb_rd(ex_wb_rd)
    );

    // Instantiate the Execute stage module
    execute_stage execute_stage_inst (
        .pc(ex_pc),
        .op1(ex_op1),
        .op2(ex_op2),
        .immediate(ex_immediate),
        .func7(ex_func7),
        .func3(ex_func3),
        .opcode(ex_opcode),
        .ex_alu_src(ex_alu_src),
        .result(ex_result),
        .op2_selected(ex_op2_selected),
        .pc_jump_addr(ex_if_pc_jump_addr),
        .jump_en(ex_if_jump_en)
    );

    // Instantiate the EX/MEM pipeline module
    ex_mem_pipeline ex_mem_pipeline_inst (
        .clk(clk),
        .rst(rst),
        .ex_result(ex_result),
        .ex_op2_selected(ex_op2_selected),
        .ex_memory_write(ex_mem_write),
        .ex_memory_load_type(ex_mem_load_type),
        .ex_memory_store_type(ex_mem_store_type),
        .ex_wb_load(ex_wb_load),
        .ex_wb_reg_file(ex_wb_reg_file),
        .ex_wb_rd(ex_wb_rd),

        .mem_result(mem_result),
        .mem_op2_selected(mem_op2_selected),
        .mem_memory_write(mem_memory_write),
        .mem_memory_load_type(mem_memory_load_type),
        .mem_memory_store_type(mem_memory_store_type),
        .mem_wb_load(mem_wb_load),
        .mem_wb_reg_file(mem_wb_reg_file),
        .mem_wb_rd(mem_wb_rd)
    );

    // Instantiate the Memory stage module
    mem_stage mem_stage_inst (
        .clk(clk),
        .rst(rst),
        .result(mem_result),
        .op2_data(mem_op2_selected),
        .mem_write(mem_memory_write),
        .store_type(mem_memory_store_type),
        .load_type(mem_memory_load_type),
        .read_data(mem_read_data),
        .calculated_result(mem_calculated_result)
    );

    // Instantiate the MEM/WB pipeline module
    mem_wb_pipeline mem_wb_pipeline_inst (
        .clk(clk),
        .rst(rst),
        .mem_wb_load(mem_wb_load),
        .mem_wb_reg_file(mem_wb_reg_file),
        .mem_read_data(mem_read_data),
        .mem_calculated_result(mem_calculated_result),
        .mem_wb_rd(mem_wb_rd),
        .wb_load(wb_load),
        .wb_reg_file(wb_reg_file),
        .wb_read_data(wb_read_data),
        .wb_calculated_result(wb_calculated_result),
        .wb_rd(wb_rd)
    );

    // Instantiate the Write Back stage module
    writeback_stage writeback_stage_inst (
        .wb_load(wb_load),
        .mem_read_data(wb_read_data),
        .alu_result(wb_calculated_result),
        .wb_result(wb_result)
    );

endmodule