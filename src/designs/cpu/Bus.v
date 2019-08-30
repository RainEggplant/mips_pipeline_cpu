module Bus(clk, reset, MemRead, MemWrite, address, write_data, read_data, IRQ);
input clk;
input reset;
input MemRead;
input MemWrite;
input [31:0] address;
input [31:0] write_data;
output [31:0] read_data;
output IRQ;

wire [31:0] read_data;
wire [31:0] read_data_DM;
wire [31:0] read_data_Timer;

wire en_DM = (address <= 32'h000007ff);
wire en_Timer = (address >= 32'h40000000 && address <= 32'h4000000B);
wire MemRead_DM = en_DM && MemRead;
wire MemWrite_DM = en_DM && MemWrite;
wire MemRead_Timer = en_Timer && MemRead;
wire MemWrite_Timer = en_Timer && MemWrite;

parameter RAM_SIZE = 512;
parameter RAM_SIZE_BIT = 9;

DataMemory #(.RAM_SIZE(RAM_SIZE), .RAM_SIZE_BIT(RAM_SIZE_BIT)) data_mem(
             .clk(clk), .MemRead(MemRead_DM), .MemWrite(MemWrite_DM), .address(address[RAM_SIZE_BIT + 1:2]),
             .write_data(write_data), .read_data(read_data_DM)
           );

Timer timer(
        .clk(clk), .reset(reset), .MemRead(MemRead_Timer), .MemWrite(MemWrite_Timer), .address(address[3:2]),
        .write_data(write_data), .read_data(read_data_Timer), .IRQ(IRQ)
      );

assign read_data =
       en_DM ? read_data_DM :
       en_Timer ? read_data_Timer :
       32'h00000000;

endmodule
