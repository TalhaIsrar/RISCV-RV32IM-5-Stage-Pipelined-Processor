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

    // Finish simulation
    #50;
    $finish;
  end

endmodule
