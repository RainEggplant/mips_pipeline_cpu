/* verilator lint_off UNUSED */

module EX_MEM_Reg(
         clk, reset,
         alu_out_in, rt_in, write_addr_in, pc_next_in,
         MemRead_in, MemWrite_in,
         MemToReg_in, RegWrite_in
       );
input clk;
input reset;

// EX data
input [31:0] alu_out_in;
input [31:0] rt_in;
input [4:0] write_addr_in;
input [31:0] pc_next_in;

// Mem control
input MemRead_in;
input MemWrite_in;

// WB control
input [1:0] MemToReg_in;
input RegWrite_in;


reg [31:0] alu_out;
reg [31:0] rt;
reg [4:0] write_addr;
reg [31:0] pc_next;
reg MemRead;
reg MemWrite;
reg [1:0] MemToReg;
reg RegWrite;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        alu_out <= alu_out_in;
        rt <= rt_in;
        write_addr <= write_addr_in;
        pc_next <= pc_next_in;
        MemRead <= MemRead_in;
        MemWrite <= MemWrite_in;
        MemToReg <= MemToReg_in;
        RegWrite <= RegWrite_in;
      end
    else
      begin
        alu_out <= 32'h00000000;
        rt <= 32'h00000000;
        write_addr <= 5'b00000;
        pc_next <= 32'h00000000;
        MemRead <= 0;
        MemWrite <= 0;
        MemToReg <= 2'b00;
        RegWrite <= 0;
      end
  end
endmodule
