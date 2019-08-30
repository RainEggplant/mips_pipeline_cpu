module Bus(clk, reset, MemRead, MemWrite, address, write_data, read_data, IRQ, led, ssd);
input clk;
input reset;
input MemRead;
input MemWrite;
input [31:0] address;
input [31:0] write_data;
output [31:0] read_data;
output IRQ;
output [7:0] led;
output [11:0] ssd;

wire [31:0] read_data;
wire [31:0] read_data_DM;
wire [31:0] read_data_Timer;
wire [31:0] read_data_LED;
wire [31:0] read_data_SSD;
wire [31:0] read_data_ST;

wire en_DM = (address <= 32'h000007ff);
wire en_Timer = (address >= 32'h40000000 && address <= 32'h40000008);
wire en_LED = address == 32'h4000000C;
wire en_SSD = address == 32'h40000010;

parameter RAM_SIZE = 512;
parameter RAM_SIZE_BIT = 9;

DataMemory #(.RAM_SIZE(RAM_SIZE), .RAM_SIZE_BIT(RAM_SIZE_BIT)) data_mem_0(
             .clk(clk), .MemWrite(en_DM && MemWrite), .address(address[RAM_SIZE_BIT + 1:2]),
             .write_data(write_data), .read_data(read_data_DM)
           );

Timer timer_0(
        .clk(clk), .reset(reset), .MemWrite(en_Timer && MemWrite), .address(address[3:2]),
        .write_data(write_data), .read_data(read_data_Timer), .IRQ(IRQ)
      );

LED led_0(
      .clk(clk), .reset(reset), .MemWrite(en_LED && MemWrite),
      .write_data(write_data), .led(read_data_LED)
    );

assign led = read_data_LED[7:0];

SSD ssd_0(
      .clk(clk), .reset(reset), .MemWrite(en_SSD && MemWrite),
      .write_data(write_data), .ssd(read_data_SSD)
    );

assign ssd = read_data_SSD[11:0];

SysTick sys_tick_0(
          .clk(clk), .reset(reset), .systick(read_data_ST)
        );

assign read_data =
       MemRead ?
       (en_DM ? read_data_DM :
        en_Timer ? read_data_Timer :
        en_LED ? read_data_LED :
        en_SSD ? read_data_SSD :
        read_data_ST) :
       32'h00000000;

endmodule
