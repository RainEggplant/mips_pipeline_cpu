module InstructionMemory(clk, MemWrite, address, write_data, read_data);
parameter RAM_SIZE = 256;
parameter RAM_SIZE_BIT = 8;
input clk;
input MemWrite;
input [RAM_SIZE_BIT - 1:0] address;
input [31:0] write_data;
output [31:0] read_data;

reg [31:0] ram_data[RAM_SIZE - 1: 0];
assign read_data = ram_data[address];

always @ (posedge clk)
  if (MemWrite)
    ram_data[address] <= write_data;
endmodule
