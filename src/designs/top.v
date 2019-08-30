module top(sysclk, reset, led, ssd);
input sysclk, reset;
output [7:0] led;
output [11:0] ssd;

CPU cpu1(.clk(sysclk), .reset(reset), .led(led), .ssd(ssd));

endmodule
