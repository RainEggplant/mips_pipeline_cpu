/* verilator lint_off UNUSED */

module PCOnBreak(clk, reset, wr_en, pc_in, pc_on_break);
input clk;
input reset;
input wr_en;
input [31:0] pc_in;
output reg [31:0] pc_on_break;

always @ (posedge clk)
  begin
    if (~reset)
      begin
        if (wr_en)
          begin
            pc_on_break <= pc_in;
          end
      end
    else
      begin
        pc_on_break <= 32'h00000000;
      end
  end
endmodule
