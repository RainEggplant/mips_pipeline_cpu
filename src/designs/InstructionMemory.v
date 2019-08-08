module InstructionMemory(address, instruction);
input [31:0] address;
output reg [31:0] instruction;

always @(*)
  case (address[9:2])
    8'd0:
      instruction <= 32'h20040003;
    8'd1:
      instruction <= 32'h0c000003;
    8'd2:
      instruction <= 32'h1000ffff;
    8'd3:
      instruction <= 32'h23bdfff8;
    8'd4:
      instruction <= 32'hafbf0004;
    8'd5:
      instruction <= 32'hafa40000;
    8'd6:
      instruction <= 32'h28880001;
    8'd7:
      instruction <= 32'h11000003;
    8'd8:
      instruction <= 32'h00001026;
    8'd9:
      instruction <= 32'h23bd0008;
    8'd10:
      instruction <= 32'h03e00008;
    8'd11:
      instruction <= 32'h2084ffff;
    8'd12:
      instruction <= 32'h0c000003;
    8'd13:
      instruction <= 32'h8fa40000;
    8'd14:
      instruction <= 32'h8fbf0004;
    8'd15:
      instruction <= 32'h23bd0008;
    8'd16:
      instruction <= 32'h00821020;
    8'd17:
      instruction <= 32'h03e00008;
    // // addi $a0, $zero, 12345 #(0x3039)
    // 8'd0:    instruction <= {6'h08, 5'd0 , 5'd4 , 16'h3039};
    // // addiu $a1, $zero, -11215 #(0xd431)
    // 8'd1:    instruction <= {6'h09, 5'd0 , 5'd5 , 16'hd431};
    // // sll $a2, $a1, 16
    // 8'd2:    instruction <= {6'h00, 5'd0 , 5'd5 , 5'd6 , 5'd16 , 6'h00};
    // // sra $a3, $a2, 16
    // 8'd3:    instruction <= {6'h00, 5'd0 , 5'd6 , 5'd7 , 5'd16 , 6'h03};
    // // beq $a3, $a1, L1
    // 8'd4:    instruction <= {6'h04, 5'd7 , 5'd5 , 16'h0001};
    // // lui $a0, -11111 #(0xd499)
    // 8'd5:    instruction <= {6'h0f, 5'd0 , 5'd4 , 16'hd499};
    // // L1:
    // // add $t0, $a2, $a0
    // 8'd6:    instruction <= {6'h00, 5'd6 , 5'd4 , 5'd8 , 5'd0 , 6'h20};
    // // sra $t1, $t0, 8
    // 8'd7:    instruction <= {6'h00, 5'd0 , 5'd8 , 5'd9 , 5'd8 , 6'h03};
    // // addi $t2, $zero, -12345 #(0xcfc7)
    // 8'd8:    instruction <= {6'h08, 5'd0 , 5'd10, 16'hcfc7};
    // // slt $v0, $a0, $t2
    // 8'd9:    instruction <= {6'h00, 5'd4 , 5'd10 , 5'd2 , 5'd0 , 6'h2a};
    // // sltu $v1, $a0, $t2
    // 8'd10:   instruction <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'h2b};
    // // Loop:
    // // j Loop
    // 8'd11:   instruction <= {6'h02, 26'd11};

    default:
      instruction <= 32'h00000000;
  endcase

endmodule
