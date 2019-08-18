module ProgramCounter(clk, reset, wr_en, pc_next, pc);
input clk;
input reset;
input wr_en;
input [31:0] pc_next;
output reg [31:0] pc;

always @ (posedge clk)
  if (reset)
    pc <= 32'h00000000;
  else
    if (wr_en)
      pc <= pc_next;

endmodule
