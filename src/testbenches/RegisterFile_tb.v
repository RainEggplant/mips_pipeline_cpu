`timescale 1ns / 1ns

module RegisterFile_tb;

// RegisterFile Parameters
parameter PERIOD = 10;

// RegisterFile Inputs
reg clk = 0;
reg reset = 0;
reg RegWrite = 0;
reg [4:0] write_addr = 0;
reg [31:0] write_data = 0;
reg [4:0] read_addr_1 = 0;
reg [4:0] read_addr_2 = 0;

// RegisterFile Outputs
wire [31:0] read_data_1;
wire [31:0] read_data_2;


initial
  begin
    forever
      #(PERIOD / 2)  clk = ~clk;
  end

initial
  begin
    clk = 1;
    #PERIOD reset = 1;
    #PERIOD reset = 0;
  end

RegisterFile reg_file(.clk(clk), .reset(reset),
                      .RegWrite(RegWrite), .write_addr(write_addr), .write_data(write_data),
                      .read_addr_1(read_addr_1), .read_addr_2(read_addr_2),
                      .read_data_1(read_data_1), .read_data_2(read_data_2));

initial
  begin
    // Write to $1, read $1 at the same time
    #(PERIOD * 2);
    read_addr_1 = 5'b00001;
    write_addr = 5'b00001;
    write_data = 32'h_aaaa_aaaa;
    RegWrite = 1;
    #PERIOD RegWrite = 0;

    // Write to $0, this should be invalid
    #PERIOD;
    write_addr = 5'b00000;
    write_data = 32'h_bbbb_bbbb;
    RegWrite = 1;
    #PERIOD RegWrite = 0;
    
    #PERIOD;
    read_addr_2 = 5'b00000;

    #(PERIOD * 2);
    $finish;
  end

endmodule
