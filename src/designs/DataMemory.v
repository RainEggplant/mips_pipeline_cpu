// TODO: Consider using distributed RAM if it is faster for small capacity.
// See: https://electronics.stackexchange.com/questions/382716/what-is-the-difference-between-bram-and-distributed-ram

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
reg [31:0] read_data;

always @(posedge clk)
  begin
    if (MemWrite)
      begin
        ram_data[address[RAM_SIZE_BIT + 1:2]] <= write_data;
        read_data <= MemRead ? write_data : 32'h00000000;
      end
    else
      read_data <= MemRead ? ram_data[address[RAM_SIZE_BIT + 1:2]] : 32'h00000000;
  end

endmodule
