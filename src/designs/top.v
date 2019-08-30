module top(sysclk, reset, led);
input sysclk, reset;
output led;

CPU cpu1(.clk(sysclk), .reset(reset));
assign led = cpu1.pc[0];

endmodule
