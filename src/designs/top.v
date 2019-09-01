module top(
         sysclk, reset,
         uart_on, uart_mode, uart_ram_id, Rx_Serial,
         led, ssd, Tx_Serial
       );
input sysclk;
input reset;
input uart_on;
input uart_mode;
input uart_ram_id;
input Rx_Serial;
output [7:0] led;
output [11:0] ssd;
output Tx_Serial;

CPU cpu1(
      .clk(sysclk), .reset(reset),
      .uart_on(uart_on), .uart_mode(uart_mode), .uart_ram_id(uart_ram_id), .Rx_Serial(Rx_Serial),
      .led(led), .ssd(ssd), .Tx_Serial(Tx_Serial)
    );

endmodule
