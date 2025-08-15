`timescale 1ns/1ps

module btb_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [31:0] pc;
  reg [31:0] update_pc;
  reg update;
  reg [31:0] update_target;
  reg mispredicted;

  // Outputs
  wire [31:0] target_pc;
  wire valid;
  wire predictedTaken;

  // Instantiate the DUT
  btb dut (
    .clk(clk),
    .rst(rst),
    .pc(pc),
    .update_pc(update_pc),
    .update(update),
    .update_target(update_target),
    .mispredicted(mispredicted),
    .target_pc(target_pc),
    .valid(valid),
    .predictedTaken(predictedTaken)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 100MHz clock

  // Test vectors
  initial begin
    // Reset
    rst = 1;
    update = 0;
    pc = 0;
    update_pc = 0;
    update_target = 0;
    mispredicted = 0;
    #20;
    rst = 0;

    // Example: Write first entry to BTB
    pc = 32'h000A0000;
    update_pc = 32'h000A0000;
    update_target = 32'h000A0020;
    update = 1;
    mispredicted = 0;
    #10;
    update = 0;

    // Check that BTB predicts correctly
    pc = 32'h000A0000;
    #10;
    $display("Valid: %b, Target: %h, PredTaken: %b", valid, target_pc, predictedTaken);

    // Add second entry
    pc = 32'h000B0000;
    update_pc = 32'h000B0000;
    update_target = 32'h000B0020;
    update = 1;
    #10;
    update = 0;

    // Check first and second entry
    pc = 32'h000A0000;
    #10;
    $display("Entry 0 - Valid: %b, Target: %h", valid, target_pc);

    pc = 32'h000B0000;
    #10;
    $display("Entry 1 - Valid: %b, Target: %h", valid, target_pc);

    // Test misprediction
    pc = 32'h000A0000;
    mispredicted = 1;
    update = 1;
    #10;
    update = 0;
    mispredicted = 0;
    #10;
    $display("After mispredict - Valid: %b, Target: %h, PredTaken: %b", valid, target_pc, predictedTaken);

    // Finish simulation
    #50;
    $finish;
  end

endmodule
