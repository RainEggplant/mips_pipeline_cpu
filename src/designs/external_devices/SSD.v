module SSD(
         clk, reset, MemWrite, write_data, ssd
       );
input clk;
input reset;
input MemWrite;
input [31:0] write_data;
output reg [31:0] ssd;

always @ (posedge clk)
  begin
    if (reset)
      ssd <= 32'h00000000;
    else
      if (MemWrite)
        ssd <= write_data;
  end

endmodule
