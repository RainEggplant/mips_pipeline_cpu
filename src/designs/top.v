module top(sysclk, reset, IRQ, led);
input sysclk, reset, IRQ;
output led;

CPU cpu1(.clk(sysclk), .reset(reset), .IRQ(IRQ));
assign led = cpu1.pc[0];

endmodule
