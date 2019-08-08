module top(reset, sysclk, led);
input reset, sysclk;
output led;

CPU cpu1(reset, sysclk);
assign led = cpu1.pc[0];
endmodule
