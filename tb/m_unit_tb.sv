`include "../soc/m_definitions.svh"

`timescale 1ns / 1ns

module m_unit_tb;
    timeunit 1ns / 1ns;
    reg clk;
    reg resetn;
    reg m_valid;
	reg[31:0] m_instruction;
	reg[31:0] m_rs1;
	reg[31:0] m_rs2;

    reg m_wr;
	reg[31:0] m_rd;
    reg m_busy;
    reg m_ready;


    riscv_m_unit m_unit
    (
	.clk	(clk),
	.resetn	(resetn),
    .valid  (m_valid),
    .instruction (m_instruction),
    .rs1    (m_rs1),
    .rs2    (m_rs2),

    .wr (m_wr),
    .rd (m_rd),
    .busy (m_busy),
    .ready (m_ready)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task test(func3 instruction,input [31:0] rs1,input [31:0] rs2,input [31:0] expected);
        begin
            @(posedge clk);
            m_valid <= '1;
            m_instruction <= {16'h0200,1'b0,instruction,12'h033};
            m_rs1 <= rs1;
            m_rs2 <= rs2;

            @(posedge clk);
            m_valid <= '0;
            wait(m_ready);

            if (m_rd == expected) begin
		$display("Passed: insn %h, rs1 %h, rs2 %h, Result %h", instruction, rs1, rs2, expected);
            end else begin
		$display("Failed: insn %h, rs1 %h, rs2 %h, Expected %h, Calculated %h", instruction, rs1, rs2, expected, m_rd);
            end
            @(posedge clk);
        end
    endtask

    initial begin
        resetn = 0;
        //m_valid = 0;
        //m_instruction = 0;
        //m_rs1 = 0;
        //m_rs2 = 0;

        @(posedge clk);
        resetn = 0;
        @(posedge clk);
        resetn = 1;
        @(posedge clk);

        $display("Testing MUL");
        // MUL (lower bits)
        test(MUL, 32'h1111FFFF, 32'h1111FFFF, 32'hDDDC0001); // MUL 1111FFFF * 1111FFFF = 01236543DDDC0001
        test(MUL, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'h00000001); // MUL 4294967295 * 4294967295 = 18446744065119617025
        test(MUL, 32'h00000002, 32'hFFFFFFFF, 32'hFFFFFFFE); // MULH 2 * -1 = -1

        $display("Testing MULH");
        // MULH (upper bits)
        test(MULH, 32'hFFFFFFFB, 32'hFFFFFFFC, 32'h00000000); // MULH -5 * -4 = 20 // MSB 32 Bits 0
        test(MULH, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'h00000000); // MULH -1 * -1 = 1
        test(MULH, 32'h00000002, 32'hFFFFFFFF, 32'hFFFFFFFF); // MULH 2 * -1 = -1

        $display("Testing MULHSU");
        // MULHSU (upper bits)
        test(MULHSU, 32'hFFFFFFFB, 32'h00000004, 32'hFFFFFFFF); // MULHSU -5 * 4 = -20 // MSB 32 Bits 1
        test(MULHSU, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF); // MULHSU -1 * 4294967295 = -4294967295

        $display("Testing MULHU");
        // MULHU (upper bits)
        test(MULHU, 32'h1111FFFF, 32'h1111FFFF, 32'h01236543); // MULHU 1111FFFF * 1111FFFF = 01236543DDDC0001
        test(MULHU, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFE); // MULHU 4294967295 * 4294967295 = 18446744065119617025

        $display("Testing DIV");
        // DIV
        test(DIV, 32'hFFFFFFF3, 32'h00000005, 32'hFFFFFFFE); // DIV -13 / 5 = -2
        test(DIV, 32'h00000005, 32'hFFFFFFF3, 32'h00000000); // DIV 5 / -13 = 0
        test(DIV, 32'hFFFFFFF3, 32'h00000000, 32'hFFFFFFFF); // DIV -13 / 0 = -1              DIV BY 0
        test(DIV, 32'h00000005, 32'h00000000, 32'hFFFFFFFF); // DIV   5 / 0 = -1              DIV BY 0
        test(DIV, 32'h80000000, 32'hFFFFFFFF, 32'h80000000); // DIV h80000000 / -1 = 80000000 Overflow
        test(DIV, 32'd34, 32'd23, 32'd1);
        test(DIV, -32'd34, 32'd23, -32'd1);
        test(DIV, 32'd34, -32'd23, -32'd1);
        test(DIV, -32'd34, -32'd23, 32'd1);

        $display("Testing DIVU");
        // DIVU
        test(DIVU, 32'h0000000D, 32'h00000005, 32'h00000002); // DIVU 13 / 5 = 2
        test(DIVU, 32'h00000005, 32'h0000000D, 32'h00000000); // DIVU 5 / 13 = 0
        test(DIVU, 32'h0000000D, 32'h00000000, 32'hFFFFFFFF); // DIVU 13 / 0 = MAX             DIV BY 0
        test(DIVU, 32'd34, 32'd23, 32'd1);
        test(DIVU, '0, 32'd74, '0);
        test(DIVU, 32'hFFFFFFFF, '0, 32'hFFFFFFFF);

        $display("Testing REM");
        // REM
        test(REM, 32'hFFFFFFF3, 32'h00000005, 32'hFFFFFFFD); // REM -13 % 5 = -3
        test(REM, 32'h00000005, 32'hFFFFFFF3, 32'h00000005); // REM 5 % -13 = 5
        test(REM, 32'hFFFFFF30, 32'h00003001, 32'hFFFFFF30); // REM hFFFFFF30 % h3001 = hFFFFFF30
        test(REM, 32'hFFFFFFF3, 32'h00000000, 32'hFFFFFFF3); // REM -13 % 0 = -13             DIV BY 0
        test(REM, 32'h80000000, 32'hFFFFFFFF, 32'h00000000); // REM h80000000 / -1 = 0        Overflow

        $display("Testing REMU");
        // REMU
        test(REMU, 32'h0000000D, 32'h00000005, 32'h00000003); // REMU 13 % 5 = 3
        test(REMU, 32'h00000005, 32'h0000000D, 32'h00000005); // REMU 5 % 13 = 5
        test(REMU, 32'h00003000, 32'h00003001, 32'h00003000); // REMU h3000 % h3001 = h3000
        test(REMU, 32'h0000000D, 32'h00000000, 32'h0000000D); // REMU 13 % 0 = 13              DIV BY 0

	$stop;
    end
endmodule
