module Bus(
         clk, reset, pc,
         MemRead, MemWrite,
         address, write_data,
         uart_on, uart_mode, uart_ram_id, Rx_Serial,
         instruction, read_data,
         IRQ, led, ssd, Tx_Serial
       );
parameter IM_SIZE = 256;
parameter IM_SIZE_BIT = 8;
parameter DM_SIZE = 512;
parameter DM_SIZE_BIT = 9;

input clk;
input reset;
input [31:0] pc;
input MemRead;
input MemWrite;
input [31:0] address;
input [31:0] write_data;
input uart_on;
input uart_mode;
input uart_ram_id;
input Rx_Serial;
output [31:0] instruction;
output [31:0] read_data;
output IRQ;
output [7:0] led;
output [11:0] ssd;
output Tx_Serial;

wire [DM_SIZE_BIT - 1: 0] uart_addr;
wire on_received;
wire [31:0] recv_data;
wire IM_Done;
wire DM_Done;

wire [31:0] read_data;
wire [31:0] read_data_DM;
wire [31:0] read_data_Timer;
wire [31:0] read_data_LED;
wire [31:0] read_data_SSD;
wire [31:0] read_data_ST;

wire en_UART = reset && uart_on;
wire en_DM = (address <= 32'h000007ff);
wire en_Timer = (address >= 32'h40000000 && address <= 32'h40000008);
wire en_LED = address == 32'h4000000C;
wire en_SSD = address == 32'h40000010;


InstructionMemory #(.RAM_SIZE(IM_SIZE), .RAM_SIZE_BIT(IM_SIZE_BIT)) instr_mem_0(
                    .clk(clk),
                    .MemWrite(en_UART && uart_ram_id == 0 && on_received),
                    .address(en_UART ? uart_addr[IM_SIZE_BIT - 1:0] : pc[IM_SIZE_BIT + 1:2]),
                    .write_data(recv_data),
                    .read_data(instruction)
                  );

DataMemory #(.RAM_SIZE(DM_SIZE), .RAM_SIZE_BIT(DM_SIZE_BIT)) data_mem_0(
             .clk(clk),
             .MemWrite((en_DM && MemWrite) || (en_UART && uart_ram_id == 1 && on_received)),
             .address(en_UART ? uart_addr[DM_SIZE_BIT - 1:0] : address[DM_SIZE_BIT + 1:2]),
             .write_data(en_UART ? recv_data : write_data), .read_data(read_data_DM)
           );

UART #(.IM_SIZE(IM_SIZE), .IM_SIZE_BIT(IM_SIZE_BIT), .DM_SIZE(DM_SIZE), .DM_SIZE_BIT(DM_SIZE_BIT), .MAX_SIZE_BIT(DM_SIZE_BIT))
     uart_0(.clk(clk), .en(en_UART), .mode(uart_mode), .ram_id(uart_ram_id),
            .Rx_Serial(Rx_Serial), .data_to_send(read_data_DM), .addr(uart_addr),
            .on_received(on_received), .recv_data(recv_data), .Tx_Serial(Tx_Serial),
            .IM_Done(IM_Done), .DM_Done(DM_Done));

Timer timer_0(
        .clk(clk), .reset(reset), .MemWrite(en_Timer && MemWrite), .address(address[3:2]),
        .write_data(write_data), .read_data(read_data_Timer), .IRQ(IRQ)
      );

LED led_0(
      .clk(clk), .reset(reset), .MemWrite(en_LED && MemWrite),
      .write_data(write_data), .led(read_data_LED)
    );

assign led = reset ? {IM_Done, DM_Done, 6'b0} : read_data_LED[7:0];

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
