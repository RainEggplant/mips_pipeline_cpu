`timescale 1ns / 1ns
module test_cpu();

reg reset;
reg clk;
reg IRQ;

CPU cpu1(.clk(clk), .reset(reset));

initial
  fork
    reset = 1;
    clk = 1;
    #100 reset = 0;
  join

always #50 clk = ~clk;

endmodule
