/* verilator lint_off UNUSED */

module MEM_WB_Reg(
         clk, reset,
         write_addr_in, mem_data_in,
         MemToReg_in, RegWrite_in
       );
input clk;
input reset;

// Mem data
input [4:0] write_addr_in;
input [31:0] mem_data_in;

// WB control
input [1:0] MemToReg_in;
input RegWrite_in;


reg [4:0] write_addr;
reg [31:0] mem_data;
reg [1:0] MemToReg;
reg RegWrite;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        write_addr <= write_addr_in;
        mem_data <= mem_data_in;
        MemToReg <= MemToReg_in;
        RegWrite <= RegWrite_in;
      end
    else
      begin
        write_addr <= 5'b00000;
        mem_data <= 32'h00000000;
        MemToReg <= 0;
        RegWrite <= 0;
      end
  end
endmodule
