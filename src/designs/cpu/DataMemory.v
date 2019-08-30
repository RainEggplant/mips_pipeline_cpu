module DataMemory(clk, MemRead, MemWrite, address, write_data, read_data);
parameter RAM_SIZE = 512;
parameter RAM_SIZE_BIT = 9;
input clk;
input MemRead;
input MemWrite;
input [RAM_SIZE_BIT - 1:0] address;
input [31:0] write_data;
output [31:0] read_data;

reg [31:0] ram_data[RAM_SIZE - 1: 0];
assign read_data = MemRead ? ram_data[address] : 32'h00000000;

always @ (posedge clk)
  if (MemWrite)
    ram_data[address] <= write_data;
endmodule
