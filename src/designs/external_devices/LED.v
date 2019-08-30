module LED(
         clk, reset, MemWrite, write_data, led
       );
input clk;
input reset;
input MemWrite;
input [31:0] write_data;
output reg [31:0] led;

always @ (posedge clk)
  begin
    if (reset)
      led <= 32'h00000000;
    else
      if (MemWrite)
        led <= write_data;
  end

endmodule
