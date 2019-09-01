module RegisterFile(
         clk, reset,
         RegWrite, write_addr, write_data,
         read_addr_1, read_addr_2,
         read_data_1, read_data_2
       );
input clk;
input reset;
input RegWrite;
input [4:0] write_addr;
input [31:0] write_data;
input [4:0] read_addr_1;
input [4:0] read_addr_2;
output [31:0] read_data_1;
output [31:0] read_data_2;

reg [31:0] rf_data[31:1];

assign read_data_1 =
       (read_addr_1 == 5'b00000) ? 32'h00000000 : rf_data[read_addr_1];
assign read_data_2 =
       (read_addr_2 == 5'b00000) ? 32'h00000000 : rf_data[read_addr_2];

integer i;
always @(posedge clk)
  if (reset)
    begin
      for (i = 1; i < 29; i = i + 1)
        rf_data[i] <= 32'h00000000;

      rf_data[29] <= 32'h00000800;
      rf_data[30] <= 32'h00000000;
      rf_data[31] <= 32'h00000000;
    end
  else if (RegWrite && (write_addr != 5'b00000))
    rf_data[write_addr] <= write_data;

endmodule
