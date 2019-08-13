/* verilator lint_off UNUSED */

module IF_ID_Reg(clk, wr_en, reset, instr_in, pc_next_in);
input clk;
input wr_en;
input reset;
input [31:0] instr_in;
input [31:0] pc_next_in;

reg [31:0] instr;
reg [31:0] pc_next;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        if (wr_en)
          begin
            instr <= instr_in;
            pc_next <= pc_next_in;
          end
      end
    else
      begin
        instr <= 32'h00000000;
        pc_next <= 32'h00000000;
      end
  end
endmodule
