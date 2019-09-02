module BranchTest(Branch, BranchOp, in_1, in_2, BranchHazard);
input Branch;
input [2:0] BranchOp;
input [31:0] in_1;
input [31:0] in_2;
output BranchHazard;

reg result;
assign BranchHazard = Branch && result;

always @ (*)
  begin
    case (BranchOp)
      3'b001: // bltz
        result = in_1[31];
      3'b010: // bne
        result = ~(in_1 == in_2);
      3'b011: // blez
        result = in_1[31] || |in_1;
      3'b100: // bgtz
        result = ~(in_1[31] || |in_1);
      default:
        result = in_1 == in_2;
    endcase
  end
endmodule
