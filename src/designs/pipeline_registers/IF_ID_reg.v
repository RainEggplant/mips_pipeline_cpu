/* verilator lint_off UNUSED */

module IF_ID_reg(clk, wr_en, instr_in);
input clk;
input wr_en;
input [31:0] instr_in;
reg [31:0] instr;

always @ (posedge clk)
  if (wr_en)
    instr <= instr_in;
endmodule
