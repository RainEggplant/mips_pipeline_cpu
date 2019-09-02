/* verilator lint_off WIDTH */

module ALU(in_1, in_2, ALUCtl, Sign, out);
input [31:0] in_1, in_2;
input [4:0] ALUCtl;
input Sign;
output reg [31:0] out;

wire [1:0] ss;
assign ss = {in_1[31], in_2[31]};

wire lt_31;
assign lt_31 = (in_1[30:0] < in_2[30:0]);

// Assume both are signed numbers.
wire lt_signed;
// If signs are different, then lt = 0 when ss == 2'b01
// (positive number is always larger than negative one).
// But if signs are the same, then lt = lt_31
// (which is normal comparison).
assign lt_signed = (in_1[31] ^ in_2[31])?
       ((ss == 2'b01)? 0: 1): lt_31;

always @(*)
  case (ALUCtl)
    5'b00000:
      out = in_1 & in_2;
    5'b00001:
      out = in_1 | in_2;
    5'b00010:
      out = in_1 + in_2;
    5'b00110:
      out = in_1 - in_2;
    5'b00111:
      out = {31'h00000000, Sign? lt_signed: (in_1 < in_2)};
    5'b01100:
      out = ~(in_1 | in_2);
    5'b01101:
      out = in_1 ^ in_2;
    5'b10000:
      out = (in_2 << in_1[4:0]);
    5'b11000:
      out = (in_2 >> in_1[4:0]);
    5'b11001:
      out = ({{32{in_2[31]}}, in_2} >> in_1[4:0]);
    default:
      out = 32'h00000000;
  endcase

endmodule
