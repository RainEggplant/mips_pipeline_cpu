module InstructionMemory(address, instruction);
input [31:0] address;
output reg [31:0] instruction;

always @ (*)
  case (address[9:2])
    8'd0:
      instruction = 32'h08100003;
    8'd1:
      instruction = 32'h0810001f;
    8'd2:
      instruction = 32'h08100027;
    8'd3:
      instruction = 32'h3c010040;
    8'd4:
      instruction = 32'h343f0018;
    8'd5:
      instruction = 32'h03e00008;
    8'd6:
      instruction = 32'h3c094000;
    8'd7:
      instruction = 32'h3c0affff;
    8'd8:
      instruction = 32'h354affe7;
    8'd9:
      instruction = 32'had2a0000;
    8'd10:
      instruction = 32'had2a0004;
    8'd11:
      instruction = 32'h340b0003;
    8'd12:
      instruction = 32'had2b0008;
    8'd13:
      instruction = 32'h20040003;
    8'd14:
      instruction = 32'h0c100010;
    8'd15:
      instruction = 32'h1000ffff;
    8'd16:
      instruction = 32'h23bdfff8;
    8'd17:
      instruction = 32'hafbf0004;
    8'd18:
      instruction = 32'hafa40000;
    8'd19:
      instruction = 32'h28880001;
    8'd20:
      instruction = 32'h11000003;
    8'd21:
      instruction = 32'h00001026;
    8'd22:
      instruction = 32'h23bd0008;
    8'd23:
      instruction = 32'h03e00008;
    8'd24:
      instruction = 32'h2084ffff;
    8'd25:
      instruction = 32'h0c100010;
    8'd26:
      instruction = 32'h8fa40000;
    8'd27:
      instruction = 32'h8fbf0004;
    8'd28:
      instruction = 32'h23bd0008;
    8'd29:
      instruction = 32'h00821020;
    8'd30:
      instruction = 32'h03e00008;
    8'd31:
      instruction = 32'hafa9fffc;
    8'd32:
      instruction = 32'hafaafff8;
    8'd33:
      instruction = 32'h3c094000;
    8'd34:
      instruction = 32'h340a0003;
    8'd35:
      instruction = 32'had2a0008;
    8'd36:
      instruction = 32'h8fa9fffc;
    8'd37:
      instruction = 32'h8faafff8;
    8'd38:
      instruction = 32'h03400008;
    8'd39:
      instruction = 32'h1000ffff;
    default:
      instruction = 32'h00000000;
  endcase

endmodule
