`timescale 1ns / 1ns
module CPU_tb_insertion_sort();

reg reset;
reg clk;
reg uart_on;

CPU cpu_0(
      .clk(clk), .reset(reset), .uart_on(uart_on),
      .led(led), .ssd(ssd)
    );

initial
  begin
    $display("Loading instructions into instr_mem ...");
    $readmemh("insertion_sort.hex", cpu_0.bus.instr_mem_0.ram_data);
    $display("Instructions loaded!");
    $display("Loading data into data_mem ...");
    $readmemh("insertion_sort_data.hex", cpu_0.bus.data_mem_0.ram_data);
    $display("Data loaded!");
    clk = 1;
    uart_on = 0;
    reset = 1;
    #10 reset = 0;
  end

always #5 clk = ~clk;

endmodule
