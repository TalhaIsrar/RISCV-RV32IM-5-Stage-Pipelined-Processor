`timescale 1ns/1ps

module rv32i_core_tb;

    reg clk;
    reg rst;

    // Instantiate the core
    rv32i_core dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize reset
        rst = 1;
        #20;       // Hold reset for 20ns
        rst = 0;

        // Run simulation for 100ns then finish
        #300;
        $finish;
    end
endmodule
