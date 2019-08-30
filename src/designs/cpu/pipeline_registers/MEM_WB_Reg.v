/* verilator lint_off UNUSED */

module MEM_WB_Reg(
         clk, reset,
         alu_out_in, write_addr_in, mem_out_in, pc_next_in,
         MemtoReg_in, RegWrite_in
       );
input clk;
input reset;

// Mem data
input [31:0] alu_out_in;
input [4:0] write_addr_in;
input [31:0] mem_out_in;
input [31:0] pc_next_in;

// WB control
input [1:0] MemtoReg_in;
input RegWrite_in;


reg [31:0] alu_out;
reg [4:0] write_addr;
reg [31:0] mem_out;
reg [31:0] pc_next;
reg [1:0] MemtoReg;
reg RegWrite;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        alu_out <= alu_out_in;
        write_addr <= write_addr_in;
        mem_out <= mem_out_in;
        pc_next <= pc_next_in;
        MemtoReg <= MemtoReg_in;
        RegWrite <= RegWrite_in;
      end
    else
      begin
        alu_out <= 32'h00000000;
        write_addr <= 5'b00000;
        mem_out <= 32'h00000000;
        pc_next <= 32'h00000000;
        MemtoReg <= 0;
        RegWrite <= 0;
      end
  end
endmodule
