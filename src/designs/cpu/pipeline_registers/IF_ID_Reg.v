/* verilator lint_off UNUSED */

module IF_ID_Reg(clk, reset, wr_en, Flush, instr_in, pc_next_in);
input clk;
input reset;
input wr_en;
input Flush;
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
            instr <= Flush ? 32'h00000000 : instr_in;
            // pc_next <= Flush ? pc_next : pc_next_in;
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
