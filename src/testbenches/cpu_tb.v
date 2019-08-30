`timescale 1ns / 1ns
module test_cpu();

reg reset;
reg clk;
reg IRQ;

CPU cpu1(.clk(clk), .reset(reset), .IRQ(IRQ));

initial
  fork
    reset = 1;
    clk = 1;
    IRQ = 0;
    #100 reset = 0;
    #1000 IRQ = 1;
    #2500 IRQ = 0;
    #3900 IRQ = 1;
    #4000 IRQ = 0;
    #6000 IRQ = 1;
    #6100 IRQ = 0;
    #8000 IRQ = 1;
    #8100 IRQ = 0;
  join

always #50 clk = ~clk;

endmodule
