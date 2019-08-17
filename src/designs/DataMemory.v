module DataMemory(clk, MemRead, MemWrite, address, write_data, read_data);
input clk;
input MemRead;
input MemWrite;
input [31:0] address;
input [31:0] write_data;
output [31:0] read_data;

parameter RAM_SIZE = 512;
parameter RAM_SIZE_BIT = 9;

reg [31:0] ram_data[RAM_SIZE - 1: 0];
assign read_data = MemRead ? ram_data[address[RAM_SIZE_BIT + 1:2]] : 32'h00000000;

always @ (posedge clk)
  if (MemWrite)
    ram_data[address[RAM_SIZE_BIT + 1:2]] <= write_data;
endmodule
