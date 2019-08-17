module ProgramCounter(clk, reset, PCWrite, pc_next, pc);
input clk;
input reset;
input PCWrite;
input [31:0] pc_next;
output reg [31:0] pc;

always @ (posedge clk)
  if (reset)
    pc <= 32'h00000000;
  else
    if (PCWrite)
      pc <= pc_next;

endmodule
