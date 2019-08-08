module DataMemory(clk, reset, MemRead, MemWrite, address, write_data, read_data);
input clk;
input reset;
input MemRead;
input MemWrite;
input [31:0] address;
input [31:0] write_data;
output [31:0] read_data;

parameter RAM_SIZE = 256;
parameter RAM_SIZE_BIT = 8;

reg [31:0] RAM_data[RAM_SIZE - 1: 0];
assign read_data = MemRead? RAM_data[address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;

integer i;
always @(posedge reset or posedge clk)
  if (reset)
    for (i = 0; i < RAM_SIZE; i = i + 1)
      RAM_data[i] <= 32'h00000000;
  else if (MemWrite)
    RAM_data[address[RAM_SIZE_BIT + 1:2]] <= write_data;

endmodule
