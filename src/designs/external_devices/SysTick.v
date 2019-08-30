module SysTick(
         clk, reset, systick
       );
input clk;
input reset;
output reg [31:0] systick;

always @ (posedge clk)
  begin
    if (reset)
      systick <= 32'h00000000;
    else
      systick <= systick + 1;
  end

endmodule
