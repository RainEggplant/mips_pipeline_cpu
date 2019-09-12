`timescale 1ns / 1ns

module DataMemory_tb;

// RegisterFile Parameters
parameter PERIOD = 10;

// RegisterFile Inputs
reg clk = 1;
reg MemWrite = 0;
reg [31:0] address = 32'h00000000;
reg [31:0] write_data = 32'h00000000;

// RegisterFile Outputs
wire [31:0] read_data;

initial
  begin
    forever
      #(PERIOD / 2)  clk = ~clk;
  end

DataMemory data_mem(
             .clk(clk), .MemWrite(MemWrite), .address(address),
             .write_data(write_data), .read_data(read_data));

initial
  begin
    #PERIOD
    // Write to 0x1
    MemWrite = 1;
    address = 32'h00000004;
    write_data = 32'h11111111;
    // Write to 0x2
    #PERIOD
     address = 32'h00000008;
    write_data = 32'h22222222;
    // Read 0x1
    #PERIOD
     MemWrite = 0;
    address = 32'h00000004;
    // Read 0x2
    #PERIOD
     address = 32'h00000008;
    // Read 0x1
    #PERIOD
     address = 32'h00000004;
    #PERIOD;
    $finish;
  end

endmodule
