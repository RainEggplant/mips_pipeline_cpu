`timescale 1ns / 1ns
module CPU_with_UART_tb();

reg reset;
reg clk;
reg uart_on;
reg uart_mode;
reg uart_ram_id;
reg Rx_Serial;
wire [7:0] led;
wire IM_Done = led[7];
wire DM_Done = led[6];
reg [31:0] instr [10:0];
reg [31:0] data [10:0];
CPU cpu_0(
      .clk(clk), .reset(reset),
      .uart_on(uart_on), .uart_mode(uart_mode), .uart_ram_id(uart_ram_id), .Rx_Serial(Rx_Serial),
      .led(led), .ssd(ssd), .Tx_Serial(Tx_Serial)
    );

integer i;
integer j;
initial
  begin
    clk = 1;
    reset = 1;
    uart_on = 0;
    uart_mode = 0;
    uart_ram_id = 0;
    # 10 uart_on = 1;
    Rx_Serial = 1;
    $display("Loading instructions into instr_mem ...");
    $readmemh("test_code_0.hex", instr);
    #10 reset = 1;
    for (i = 0; i < 10; i = i + 1)
      begin
        for (j = 0; j < 32; j = j + 1)
          begin
            if (j % 8 == 0)
              #208340 Rx_Serial = 0;
            #104170 Rx_Serial = instr[i][j];
            if ((j + 1) % 8 == 0)
              #104170 Rx_Serial = 1;
          end
      end
    #104170;
    $display("Instructions loaded!");
    $finish;
    $display("Loading data into data_mem ...");
    $readmemh("test_data_0.hex", data);
    uart_ram_id = 1;
    for (i = 0; i < 3; i = i + 1)
      begin
        for (j = 0; j < 32; j = j + 1)
          begin
            if (j % 8 == 0)
              #208340 Rx_Serial = 0;
            #104170 Rx_Serial = data[i][j];
            if ((j + 1) % 8 == 0)
              #104170 Rx_Serial = 1;
          end
      end
    #104170;
    $finish;
    $display("Data loaded!");
    $display("Start executing program ...");
    #10 uart_on = 0;
    reset = 0;
    #200 reset = 1;
    $finish;
    $display("Start dumping data_mem via UART");
    #20 uart_ram_id = 1;
    #20 uart_mode = 1;
    #20 uart_on = 1;
  end

always #5 clk = ~clk;

endmodule
