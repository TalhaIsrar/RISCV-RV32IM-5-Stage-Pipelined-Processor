`include "m_definitions.svh"

module riscv_m_unit(
	input logic clk, 
	input logic resetn, 
	
	input logic valid,
	input logic[31:0] instruction,
	input logic[31:0] rs1,
	input logic[31:0] rs2,
    input logic[4:0] rd,

	output logic wr,
	output logic[31:0] result,
	output logic busy,
	output logic ready,
    output logic[4:0] result_dest
	);

//// DATA SIGNALS
logic [31:0] rs1_neg, rs2_neg;

// ALU inputs
logic [31:0] R; // remainder
logic [62:0] D; // divisor
logic [31:0] Z; // quotient
logic signed [32:0] mult_a;
logic signed [32:0] mult_b;
// ALU outputs
logic sub_neg;
logic [31:0] sub_result;  // subtraction's result
logic [31:0] div_rem;     // divider's result
logic [31:0] div_rem_neg; // divider's result inverted
logic signed [65:0] product;     // multiplier's result

//// CONTROL SIGNALS
logic [`MUX_R_LENGTH-1:0] mux_R;
logic [`MUX_D_LENGTH-1:0] mux_D;
logic [`MUX_Z_LENGTH-1:0] mux_Z;
logic [`MUX_MULTA_LENGTH-1:0] mux_multA;
logic [`MUX_MULTB_LENGTH-1:0] mux_multB;
logic [`MUX_DIV_REM_LENGTH-1:0] mux_div_rem;
logic [`MUX_OUT_LENGTH-1:0] mux_out;


//// SUB-BLOCK INSTANTIATION

// CONTROLLER
m_controller controller (
    .clk(clk), .resetn(resetn), .pcpi_valid(valid), // control input
    .instruction(instruction), .rs1(rs1), .rs2(rs2), // data inputs
    .mux_R(mux_R), .mux_D(mux_D), .mux_Z(mux_Z), .mux_multA(mux_multA), .mux_multB(mux_multB), // control inputs
    .mux_div_rem(mux_div_rem), .mux_out(mux_out), .pcpi_ready(ready), .pcpi_wr(wr), .pcpi_busy(busy), // control inputs
    .rs1_neg(rs1_neg), .rs2_neg(rs2_neg) // data outputs
);


// REGISTER FILE
m_registers registers(
    .clk(clk), .resetn(resetn), .mux_multA(mux_multA), .mux_multB(mux_multB), .sub_neg(sub_neg), .mux_R(mux_R), .mux_D(mux_D), .mux_Z(mux_Z), // control inputs
    .rs1(rs1), .rs2(rs2), .rs1_neg(rs1_neg), .rs2_neg(rs2_neg), .sub_result(sub_result), .product(product), // data inputs
    .mult_a(mult_a), .mult_b(mult_b), .R(R), .D(D), .Z(Z) // data outputs
);


// ALU
m_alu alu(
    .mux_div_rem(mux_div_rem), // control inputs
    .R(R), .D(D), .Z(Z), .mult_a(mult_a), .mult_b(mult_b), // data inputs
    .sub_neg(sub_neg), // control outputs
    .sub_result(sub_result), .div_rem(div_rem), .div_rem_neg(div_rem_neg), .product(product) // data outputs
);

// Register to hold destination register ID
always_ff @(posedge clk or posedge resetn) begin
    if (resetn)
        result_dest <= 5'd0;
    else if (valid && !busy)
        result_dest <= rd;
end

// COMBINATORIAL BLOCK
always_comb begin
    // MUX output selection
    unique case (mux_out)
        `MUX_OUT_ZERO:        result = '0;
        `MUX_OUT_DIV_REM:     result = div_rem;
        `MUX_OUT_DIV_REM_NEG: result = div_rem_neg;
        `MUX_OUT_MULT_LOWER:  result = product[31:0];
        `MUX_OUT_MULT_UPPER:  result = product[63:32];
        `MUX_OUT_ALL1:        result = {32{1'b1}};
        `MUX_OUT_MINUS_1:     result = -32'd1;
    endcase
end



endmodule
